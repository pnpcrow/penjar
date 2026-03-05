#!/usr/bin/env bash
set -eo pipefail

report_file="${1:-release/reports/verify_test_coverage_report.md}"
test_dir="${2:-test}"

runner_scripts=(
  "scripts/run_contract_tests.sh"
  "scripts/run_parity_tests.sh"
  "scripts/run_mode_matrix_tests.sh"
)

if [[ ! -d "$test_dir" ]]; then
  echo "[verify-test-coverage] test directory not found: $test_dir" >&2
  exit 1
fi

for runner in "${runner_scripts[@]}"; do
  if [[ ! -f "$runner" ]]; then
    echo "[verify-test-coverage] runner script not found: $runner" >&2
    exit 1
  fi
done

if ! command -v rg >/dev/null 2>&1; then
  echo "[verify-test-coverage] ripgrep (rg) is required." >&2
  exit 1
fi

timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
mkdir -p "$(dirname "$report_file")"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

trim_spaces() {
  printf '%s' "$1" | sed -E 's/^[[:space:]]+|[[:space:]]+$//g'
}

discovered_file="$tmp_dir/discovered_tests.txt"
coverage_refs_file="$tmp_dir/coverage_refs.txt"
coverage_sources_file="$tmp_dir/coverage_sources.tsv"
coverage_unique_file="$tmp_dir/coverage_unique.txt"
allow_duplicates_file="$tmp_dir/allow_duplicates.txt"
uncovered_file="$tmp_dir/uncovered_tests.txt"
missing_refs_file="$tmp_dir/missing_refs.txt"
allowed_duplicates_file="$tmp_dir/allowed_duplicates.txt"
unexpected_duplicates_file="$tmp_dir/unexpected_duplicates.txt"

allow_duplicates_raw="${VERIFY_TEST_COVERAGE_ALLOW_DUPLICATES-test/widget_test.dart}"
IFS=',' read -ra allow_entries <<< "$allow_duplicates_raw"
: > "$allow_duplicates_file"
for entry in "${allow_entries[@]}"; do
  normalized_entry="$(trim_spaces "$entry")"
  [[ -z "$normalized_entry" ]] && continue
  printf '%s\n' "$normalized_entry" >> "$allow_duplicates_file"
done
sort -u "$allow_duplicates_file" -o "$allow_duplicates_file"

find "$test_dir" -type f -name '*_test.dart' | sort > "$discovered_file"
: > "$coverage_refs_file"
: > "$coverage_sources_file"

for runner in "${runner_scripts[@]}"; do
  while IFS= read -r referenced_test; do
    [[ -z "$referenced_test" ]] && continue
    printf '%s\n' "$referenced_test" >> "$coverage_refs_file"
    printf '%s\t%s\n' "$referenced_test" "$runner" >> "$coverage_sources_file"
  done < <(rg -o --no-filename 'test/[A-Za-z0-9_./-]+_test\.dart' "$runner" || true)
done

sort -u "$coverage_refs_file" > "$coverage_unique_file"

get_runners_for_test() {
  local test_name="$1"
  awk -F'\t' -v name="$test_name" '$1 == name { print $2 }' "$coverage_sources_file" | sort -u | paste -sd ',' - | sed 's/,/, /g'
}

: > "$uncovered_file"
while IFS= read -r test_path; do
  [[ -z "$test_path" ]] && continue
  if ! grep -Fxq "$test_path" "$coverage_unique_file"; then
    printf '%s\n' "$test_path" >> "$uncovered_file"
  fi
done < "$discovered_file"

: > "$missing_refs_file"
while IFS= read -r referenced_test; do
  [[ -z "$referenced_test" ]] && continue
  if ! grep -Fxq "$referenced_test" "$discovered_file"; then
    printf '%s\n' "$referenced_test" >> "$missing_refs_file"
  fi
done < "$coverage_unique_file"

: > "$allowed_duplicates_file"
: > "$unexpected_duplicates_file"
while read -r count referenced_test; do
  [[ -z "$referenced_test" ]] && continue
  if [[ "$count" -le 1 ]]; then
    continue
  fi
  runners="$(get_runners_for_test "$referenced_test")"
  line="$referenced_test (count=$count; runners=$runners)"
  if grep -Fxq "$referenced_test" "$allow_duplicates_file"; then
    printf '%s\n' "$line" >> "$allowed_duplicates_file"
  else
    printf '%s\n' "$line" >> "$unexpected_duplicates_file"
  fi
done < <(sort "$coverage_refs_file" | uniq -c | awk '{print $1, $2}')

status="passed"
if [[ -s "$uncovered_file" || -s "$missing_refs_file" || -s "$unexpected_duplicates_file" ]]; then
  status="failed"
fi

{
  echo "# Verify Test Coverage Report"
  echo
  echo "- Generated at (UTC): $timestamp"
  echo "- Test directory: $test_dir"
  echo "- Runner scripts:"
  for runner in "${runner_scripts[@]}"; do
    echo "  - $runner"
  done
  echo "- Discovered test count: $(wc -l < "$discovered_file" | tr -d ' ')"
  echo "- Covered test count: $(wc -l < "$coverage_unique_file" | tr -d ' ')"
  echo "- Status: $status"
  echo
  echo "## Discovered tests"
  if [[ -s "$discovered_file" ]]; then
    while IFS= read -r test_path; do
      echo "- $test_path"
    done < "$discovered_file"
  else
    echo "- none"
  fi
  echo
  echo "## Covered tests"
  if [[ -s "$coverage_unique_file" ]]; then
    while IFS= read -r test_path; do
      echo "- $test_path"
    done < "$coverage_unique_file"
  else
    echo "- none"
  fi
  echo
  echo "## Uncovered tests"
  if [[ -s "$uncovered_file" ]]; then
    while IFS= read -r test_path; do
      echo "- $test_path"
    done < "$uncovered_file"
  else
    echo "- none"
  fi
  echo
  echo "## Missing referenced tests"
  if [[ -s "$missing_refs_file" ]]; then
    while IFS= read -r test_path; do
      echo "- $test_path"
    done < "$missing_refs_file"
  else
    echo "- none"
  fi
  echo
  echo "## Duplicate coverage references (allowed)"
  if [[ -s "$allowed_duplicates_file" ]]; then
    while IFS= read -r test_path; do
      echo "- $test_path"
    done < "$allowed_duplicates_file"
  else
    echo "- none"
  fi
  echo
  echo "## Duplicate coverage references (unexpected)"
  if [[ -s "$unexpected_duplicates_file" ]]; then
    while IFS= read -r test_path; do
      echo "- $test_path"
    done < "$unexpected_duplicates_file"
  else
    echo "- none"
  fi
} > "$report_file"

if [[ "$status" != "passed" ]]; then
  echo "[verify-test-coverage] failed. report: $report_file" >&2
  exit 1
fi

echo "[verify-test-coverage] passed. report: $report_file"
