#!/usr/bin/env bash
set -eo pipefail

report_file="${1:-release/reports/release_smoke_gate_policy_contract_report.md}"
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

  local tmp_report tmp_log rc actual result
  tmp_report="$(mktemp)"
  tmp_log="$(mktemp)"

  set +e
  if [[ "$#" -gt 0 ]]; then
    env "$@" ./scripts/check_release_smoke_gate_policy.sh "$tmp_report" >"$tmp_log" 2>&1
  else
    ./scripts/check_release_smoke_gate_policy.sh "$tmp_report" >"$tmp_log" 2>&1
  fi
  rc=$?
  set -e

  rm -f "$tmp_report" "$tmp_log"

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
  "Default policy shape should be ready."

run_case \
  "strict-signing-execution-without-readiness" \
  "fail" \
  "Strict signing execution must require strict signing readiness." \
  STRICT_SIGNING_EXECUTION=1 \
  STRICT_SIGNING_COMMAND_HOOKS=1 \
  STRICT_SIGNING_PLACEHOLDERS=1

run_case \
  "strict-windows-provenance-without-naming" \
  "fail" \
  "Strict Windows provenance must require strict naming mode." \
  STRICT_WINDOWS_INSTALLER_PROVENANCE=1 \
  STRICT_WINDOWS_INSTALLER_EXECUTION=1 \
  STRICT_WINDOWS_INSTALLER_PACKAGING=1

run_case \
  "strict-windows-protocol-without-execution" \
  "fail" \
  "Strict Windows protocol registration must require strict installer execution mode." \
  STRICT_WINDOWS_PROTOCOL_REGISTRATION=1

run_case \
  "production-publication-without-strict-evidence-bundle" \
  "fail" \
  "Non-dry-run external publication must require strict evidence bundle enforcement." \
  PUBLISH_APPCAST_EXTERNAL=1 \
  APPCAST_PUBLISH_PROVIDER=s3 \
  APPCAST_PUBLISH_DRY_RUN=0 \
  ALLOW_APPCAST_EXTERNAL_PRODUCTION=1 \
  STRICT_APPCAST_EXTERNAL_READINESS=1

run_case \
  "full-strict-profile" \
  "pass" \
  "Coherent fully strict profile should pass policy preflight." \
  STRICT_SIGNING=1 \
  STRICT_SIGNING_EXECUTION=1 \
  STRICT_SIGNING_COMMAND_HOOKS=1 \
  STRICT_SIGNING_PLACEHOLDERS=1 \
  STRICT_SIGNING_PROVENANCE=1 \
  STRICT_WINDOWS_INSTALLER_EXECUTION=1 \
  STRICT_WINDOWS_INSTALLER_PACKAGING=1 \
  STRICT_WINDOWS_INSTALLER_NAMING=1 \
  STRICT_WINDOWS_INSTALLER_PROVENANCE=1 \
  STRICT_WINDOWS_PROTOCOL_REGISTRATION=1 \
  STRICT_RELEASE_EVIDENCE_BUNDLE=1 \
  PUBLISH_APPCAST_EXTERNAL=1 \
  APPCAST_PUBLISH_PROVIDER=s3 \
  APPCAST_PUBLISH_DRY_RUN=0 \
  ALLOW_APPCAST_EXTERNAL_PRODUCTION=1 \
  STRICT_APPCAST_EXTERNAL_READINESS=1

status="passed"
if [[ "$failure_count" -gt 0 ]]; then
  status="failed"
fi

{
  echo "# Release Smoke Gate Policy Contract Report"
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
  echo "[release-smoke-gate-policy-contract] failed with ${failure_count} mismatch(es). report: $report_file" >&2
  exit 1
fi

echo "[release-smoke-gate-policy-contract] passed. report: $report_file"
