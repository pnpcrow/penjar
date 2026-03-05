#!/usr/bin/env bash
set -eo pipefail

report_file="${1:-release/reports/release_evidence_index_contract_report.md}"
source_index_file="${2:-../docs/technical-guide/developer/desktop-flutter-release-evidence-index.md}"
timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

mkdir -p "$(dirname "$report_file")"

case_rows=""
failure_count=0
total_cases=0

append_case_row() {
  local case_name="$1"
  local expected="$2"
  local actual="$3"
  local log_assertion="$4"
  local report_assertion="$5"
  local result="$6"
  local summary="$7"
  case_rows+="| ${case_name} | ${expected} | ${actual} | ${log_assertion} | ${report_assertion} | ${result} | ${summary} |"$'\n'
}

setup_baseline_case() {
  local source_index="$1"
  local case_index="$2"
  cp "$source_index" "$case_index"
}

setup_missing_attachment_case() {
  local source_index="$1"
  local case_index="$2"
  local filtered_index
  cp "$source_index" "$case_index"
  filtered_index="$(mktemp)"
  awk '!/release_script_syntax_contract_report\.md/' "$case_index" > "$filtered_index"
  mv "$filtered_index" "$case_index"
}

setup_duplicate_key_case() {
  local source_index="$1"
  local case_index="$2"
  local duplicate_row
  cp "$source_index" "$case_index"
  duplicate_row="$(grep -E '^\| RC-' "$case_index" | head -n 1 || true)"
  if [[ -z "$duplicate_row" ]]; then
    duplicate_row="| RC-DUPLICATE | 0.0.0-duplicate | macOS | TBD | TBD | TBD | TBD | blocked (placeholder) |"
  fi
  printf '%s\n' "$duplicate_row" >> "$case_index"
}

run_case() {
  local case_name="$1"
  local expected="$2"
  local summary="$3"
  local setup_fn="$4"
  local required_log_pattern="${5:-}"
  local required_report_pattern="${6:-}"

  local tmp_index tmp_report tmp_log rc actual result log_assertion report_assertion
  tmp_index="$(mktemp)"
  tmp_report="$(mktemp)"
  tmp_log="$(mktemp)"

  "$setup_fn" "$source_index_file" "$tmp_index"

  set +e
  ./scripts/check_release_evidence_index.sh "$tmp_index" "$tmp_report" >"$tmp_log" 2>&1
  rc=$?
  set -e

  actual="pass"
  if [[ "$rc" -ne 0 ]]; then
    actual="fail"
  fi

  log_assertion="ok"
  if [[ -n "$required_log_pattern" ]]; then
    if ! grep -Fq "$required_log_pattern" "$tmp_log"; then
      log_assertion="missing: ${required_log_pattern}"
    fi
  fi

  report_assertion="ok"
  if [[ -n "$required_report_pattern" ]]; then
    if ! grep -Fq "$required_report_pattern" "$tmp_report"; then
      report_assertion="missing: ${required_report_pattern}"
    fi
  fi

  result="ok"
  if [[ "$expected" != "$actual" || "$log_assertion" != "ok" || "$report_assertion" != "ok" ]]; then
    result="mismatch"
    failure_count=$((failure_count + 1))
  fi

  total_cases=$((total_cases + 1))
  append_case_row "$case_name" "$expected" "$actual" "$log_assertion" "$report_assertion" "$result" "$summary"

  rm -f "$tmp_index" "$tmp_report" "$tmp_log"
}

if [[ ! -f "$source_index_file" ]]; then
  echo "[release-evidence-index-contract] source index file not found: $source_index_file" >&2
  exit 1
fi

run_case \
  "baseline-current-index-pass" \
  "pass" \
  "Current evidence index should pass guard checks." \
  setup_baseline_case \
  "" \
  "Status: passed"

run_case \
  "missing-required-attachment-fail" \
  "fail" \
  "Removing required attachment reference must fail guard checks." \
  setup_missing_attachment_case \
  "missing required attachment reference: release/reports/release_script_syntax_contract_report.md" \
  "missing required attachment reference: release/reports/release_script_syntax_contract_report.md"

run_case \
  "duplicate-rc-platform-fail" \
  "fail" \
  "Duplicated RC+platform entry must fail uniqueness guard." \
  setup_duplicate_key_case \
  "duplicate RC+platform key detected" \
  "duplicate RC+platform key detected"

status="passed"
if [[ "$failure_count" -gt 0 ]]; then
  status="failed"
fi

{
  echo "# Release Evidence Index Contract Report"
  echo
  echo "- Generated at (UTC): $timestamp"
  echo "- Source index file: $source_index_file"
  echo "- Total cases: $total_cases"
  echo "- Failures: $failure_count"
  echo "- Status: $status"
  echo
  echo "| Case | Expected | Actual | Log assertion | Report assertion | Result | Summary |"
  echo "|---|---|---|---|---|---|---|"
  if [[ -n "$case_rows" ]]; then
    printf '%s' "$case_rows"
  else
    echo "| none | n/a | n/a | n/a | n/a | n/a | no cases executed |"
  fi
} > "$report_file"

if [[ "$failure_count" -gt 0 ]]; then
  echo "[release-evidence-index-contract] failed with ${failure_count} mismatch(es). report: $report_file" >&2
  exit 1
fi

echo "[release-evidence-index-contract] passed. report: $report_file"
