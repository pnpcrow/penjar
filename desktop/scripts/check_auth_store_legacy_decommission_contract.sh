#!/usr/bin/env bash
set -eo pipefail

report_file="${1:-release/reports/auth_store_legacy_decommission_contract_report.md}"
timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

mkdir -p "$(dirname "$report_file")"

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
  shift 3

  local tmp_log rc actual result
  tmp_log="$(mktemp)"

  set +e
  if [[ "$#" -gt 0 ]]; then
    env "$@" ./scripts/check_auth_store_legacy_decommission.sh >"$tmp_log" 2>&1
  else
    ./scripts/check_auth_store_legacy_decommission.sh >"$tmp_log" 2>&1
  fi
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

run_case \
  "baseline-default" \
  "pass" \
  "Default advisory mode should pass."

run_case \
  "strict-no-legacy-pass" \
  "pass" \
  "Strict decommission should pass when no legacy store inputs are set." \
  STRICT_AUTH_STORE_LEGACY_DECOMMISSION=1

run_case \
  "strict-with-legacy-path-fail" \
  "fail" \
  "Strict decommission should fail when legacy file auth-store path is configured." \
  STRICT_AUTH_STORE_LEGACY_DECOMMISSION=1 \
  PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_PATH=/tmp/legacy-auth.json

run_case \
  "strict-with-legacy-command-fail" \
  "fail" \
  "Strict decommission should fail when legacy command-hook auth store is configured." \
  STRICT_AUTH_STORE_LEGACY_DECOMMISSION=1 \
  PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_LOAD_COMMAND='echo load'

run_case \
  "strict-with-legacy-save-command-fail" \
  "fail" \
  "Strict decommission should fail when legacy command-hook save path is configured." \
  STRICT_AUTH_STORE_LEGACY_DECOMMISSION=1 \
  PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_SAVE_COMMAND='echo save'

run_case \
  "strict-with-mirror-fail" \
  "fail" \
  "Strict decommission should fail when legacy mirror mode is enabled." \
  STRICT_AUTH_STORE_LEGACY_DECOMMISSION=1 \
  PENJAR_DESKTOP_REMOTE_STUB_AUTH_SECURE_STORAGE_MIRROR_LEGACY=1

status="passed"
if [[ "$failure_count" -gt 0 ]]; then
  status="failed"
fi

{
  echo "# Auth Store Legacy Decommission Contract Report"
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
  echo "[auth-store-legacy-decommission-contract] failed with ${failure_count} mismatch(es). report: $report_file" >&2
  exit 1
fi

echo "[auth-store-legacy-decommission-contract] passed. report: $report_file"
