#!/usr/bin/env bash
set -eo pipefail

report_file="${1:-release/reports/desktop_command_inventory_contract_report.md}"
source_package_file="${2:-../package.json}"
timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

source_doc_files=(
  "../docs/technical-guide/developer/desktop-flutter-development-runbook.md"
  "../docs/technical-guide/developer/desktop-flutter-release-validation-baseline.md"
)

python_bin=""
if command -v python3 >/dev/null 2>&1; then
  python_bin="python3"
elif command -v python >/dev/null 2>&1; then
  python_bin="python"
else
  echo "[desktop-command-inventory-contract] python runtime is required (python3 or python)." >&2
  exit 1
fi

mkdir -p "$(dirname "$report_file")"

case_rows=""
failure_count=0
total_cases=0

CASE_PACKAGE_FILE=""
CASE_DOC_FILES=()

append_case_row() {
  local case_name="$1"
  local expected="$2"
  local actual="$3"
  local log_assertion="$4"
  local result="$5"
  local summary="$6"
  case_rows+="| ${case_name} | ${expected} | ${actual} | ${log_assertion} | ${result} | ${summary} |"$'\n'
}

copy_source_docs() {
  local dest_dir="$1"
  CASE_DOC_FILES=()
  local source_doc dest_doc base_name
  for source_doc in "${source_doc_files[@]}"; do
    base_name="$(basename "$source_doc")"
    dest_doc="${dest_dir}/${base_name}"
    cp "$source_doc" "$dest_doc"
    CASE_DOC_FILES+=("$dest_doc")
  done
}

setup_baseline_case() {
  local root_dir="$1"
  mkdir -p "$root_dir/docs"
  CASE_PACKAGE_FILE="$root_dir/package.json"
  cp "$source_package_file" "$CASE_PACKAGE_FILE"
  copy_source_docs "$root_dir/docs"
}

setup_missing_script_case() {
  local root_dir="$1"
  setup_baseline_case "$root_dir"
  "$python_bin" - "$CASE_PACKAGE_FILE" <<'PY'
import json
import pathlib
import sys

package_path = pathlib.Path(sys.argv[1])
data = json.loads(package_path.read_text(encoding="utf-8"))
scripts = data.get("scripts", {})
scripts.pop("desktop:release:evidence:check", None)
package_path.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
PY
}

setup_no_command_docs_case() {
  local root_dir="$1"
  mkdir -p "$root_dir/docs"
  CASE_PACKAGE_FILE="$root_dir/package.json"
  cp "$source_package_file" "$CASE_PACKAGE_FILE"
  local doc_path="$root_dir/docs/no_commands.md"
  cat > "$doc_path" <<'EOF'
# No command list

This file intentionally contains no desktop command references.
EOF
  CASE_DOC_FILES=("$doc_path")
}

run_case() {
  local case_name="$1"
  local expected="$2"
  local summary="$3"
  local setup_fn="$4"
  local required_log_pattern="${5:-}"

  local tmp_root tmp_report tmp_log rc actual result log_assertion
  tmp_root="$(mktemp -d)"
  tmp_report="$(mktemp)"
  tmp_log="$(mktemp)"

  CASE_PACKAGE_FILE=""
  CASE_DOC_FILES=()
  "$setup_fn" "$tmp_root"

  set +e
  ./scripts/check_desktop_command_inventory.sh "$tmp_report" "$CASE_PACKAGE_FILE" "${CASE_DOC_FILES[@]}" >"$tmp_log" 2>&1
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

  result="ok"
  if [[ "$expected" != "$actual" || "$log_assertion" != "ok" ]]; then
    result="mismatch"
    failure_count=$((failure_count + 1))
  fi

  total_cases=$((total_cases + 1))
  append_case_row "$case_name" "$expected" "$actual" "$log_assertion" "$result" "$summary"

  rm -rf "$tmp_root"
  rm -f "$tmp_report" "$tmp_log"
}

if [[ ! -f "$source_package_file" ]]; then
  echo "[desktop-command-inventory-contract] source package file not found: $source_package_file" >&2
  exit 1
fi

run_case \
  "baseline-current-docs-pass" \
  "pass" \
  "Current package/scripts and desktop docs should pass inventory checks." \
  setup_baseline_case

run_case \
  "missing-script-fail" \
  "fail" \
  "Removing required script mapping from package.json should fail inventory check." \
  setup_missing_script_case \
  "missing commands in package.json scripts: desktop:release:evidence:check"

run_case \
  "no-command-docs-fail" \
  "fail" \
  "Docs without any pnpm desktop commands should fail inventory check." \
  setup_no_command_docs_case \
  "no \`pnpm run\` commands detected in scanned docs."

status="passed"
if [[ "$failure_count" -gt 0 ]]; then
  status="failed"
fi

{
  echo "# Desktop Command Inventory Contract Report"
  echo
  echo "- Generated at (UTC): $timestamp"
  echo "- Source package file: $source_package_file"
  echo "- Source docs count: ${#source_doc_files[@]}"
  echo "- Total cases: $total_cases"
  echo "- Failures: $failure_count"
  echo "- Status: $status"
  echo
  echo "| Case | Expected | Actual | Log assertion | Result | Summary |"
  echo "|---|---|---|---|---|---|"
  if [[ -n "$case_rows" ]]; then
    printf '%s' "$case_rows"
  else
    echo "| none | n/a | n/a | n/a | n/a | no cases executed |"
  fi
} > "$report_file"

if [[ "$failure_count" -gt 0 ]]; then
  echo "[desktop-command-inventory-contract] failed with ${failure_count} mismatch(es). report: $report_file" >&2
  exit 1
fi

echo "[desktop-command-inventory-contract] passed. report: $report_file"
