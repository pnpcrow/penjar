#!/usr/bin/env bash
set -eo pipefail

report_file="${1:-release/reports/auth_store_runtime_decommission_contract_report.md}"
timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

mkdir -p "$(dirname "$report_file")"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

case_rows=""
failure_count=0
total_cases=0

append_case_row() {
  local case_name="$1"
  local expected="$2"
  local actual="$3"
  local result="$4"
  local summary="$5"
  case_rows+="| ${case_name} | ${expected} | ${actual} | ${result} | ${summary} |"$'\n'
}

run_case() {
  local case_name="$1"
  local expected="$2"
  local summary="$3"
  local target_file="$4"

  local tmp_log case_report rc actual result
  tmp_log="$(mktemp)"
  case_report="$tmp_dir/${case_name}.report.md"

  set +e
  ./scripts/check_auth_store_runtime_decommission.sh "$case_report" "$target_file" >"$tmp_log" 2>&1
  rc=$?
  set -e

  rm -f "$tmp_log"

  actual="pass"
  if [[ "$rc" -ne 0 ]]; then
    actual="fail"
  fi

  result="ok"
  if [[ "$expected" != "$actual" ]]; then
    result="mismatch"
    failure_count=$((failure_count + 1))
  fi

  total_cases=$((total_cases + 1))
  append_case_row "$case_name" "$expected" "$actual" "$result" "$summary"
}

clean_fixture="$tmp_dir/clean_fixture.dart"
legacy_fixture="$tmp_dir/legacy_fixture.dart"

cat > "$clean_fixture" <<'EOF'
String hello() {
  return 'secure storage only';
}
EOF

cat > "$legacy_fixture" <<'EOF'
const String deprecated = 'PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_PATH';
EOF

run_case \
  "baseline-current-runtime" \
  "pass" \
  "Current desktop contract bundle should not include retired legacy auth-store env tokens." \
  "lib/contracts/desktop_contract_bundle.dart"

run_case \
  "synthetic-clean-pass" \
  "pass" \
  "Synthetic file without banned tokens should pass." \
  "$clean_fixture"

run_case \
  "synthetic-legacy-token-fail" \
  "fail" \
  "Synthetic file containing retired legacy token should fail." \
  "$legacy_fixture"

status="passed"
if [[ "$failure_count" -gt 0 ]]; then
  status="failed"
fi

{
  echo "# Auth Store Runtime Decommission Contract Report"
  echo
  echo "- Generated at (UTC): $timestamp"
  echo "- Total cases: $total_cases"
  echo "- Failures: $failure_count"
  echo "- Status: $status"
  echo
  echo "| Case | Expected | Actual | Result | Summary |"
  echo "|---|---|---|---|---|"
  if [[ -n "$case_rows" ]]; then
    printf '%s' "$case_rows"
  else
    echo "| none | n/a | n/a | n/a | no cases executed |"
  fi
} > "$report_file"

if [[ "$failure_count" -gt 0 ]]; then
  echo "[auth-store-runtime-decommission-contract] failed with ${failure_count} mismatch(es). report: $report_file" >&2
  exit 1
fi

echo "[auth-store-runtime-decommission-contract] passed. report: $report_file"
