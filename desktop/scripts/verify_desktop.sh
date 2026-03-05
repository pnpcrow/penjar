#!/usr/bin/env bash
set -eo pipefail

timing_report_file="${VERIFY_TIMING_REPORT_FILE:-release/reports/verify_stage_timing_report.md}"
verify_start_epoch="$(date +%s)"
stage_lines=""

append_stage() {
  local stage="$1"
  local status="$2"
  local duration_seconds="$3"
  stage_lines+="${stage}"$'\t'"${status}"$'\t'"${duration_seconds}"$'\n'
}

run_stage() {
  local stage="$1"
  shift
  local stage_start stage_end stage_duration rc
  stage_start="$(date +%s)"
  set +e
  "$@"
  rc=$?
  set -e
  stage_end="$(date +%s)"
  stage_duration=$((stage_end - stage_start))
  if [[ "$rc" -eq 0 ]]; then
    append_stage "$stage" "passed" "$stage_duration"
  else
    append_stage "$stage" "failed" "$stage_duration"
  fi
  return "$rc"
}

write_timing_report() {
  local verify_exit_code="$1"
  local verify_end_epoch total_duration overall_status
  verify_end_epoch="$(date +%s)"
  total_duration=$((verify_end_epoch - verify_start_epoch))
  overall_status="passed"
  if [[ "$verify_exit_code" -ne 0 ]]; then
    overall_status="failed"
  fi

  mkdir -p "$(dirname "$timing_report_file")"
  {
    echo "# Verify Stage Timing Report"
    echo
    echo "- Generated at (UTC): $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
    echo "- Overall status: $overall_status"
    echo "- Total duration (seconds): $total_duration"
    echo
    echo "| Stage | Status | Duration (seconds) |"
    echo "|---|---|---|"
    if [[ -n "$stage_lines" ]]; then
      while IFS=$'\t' read -r stage_name stage_status stage_duration; do
        [[ -z "$stage_name" ]] && continue
        echo "| $stage_name | $stage_status | $stage_duration |"
      done <<< "$stage_lines"
    else
      echo "| none | n/a | 0 |"
    fi
  } > "$timing_report_file"

  if [[ "$verify_exit_code" -ne 0 ]]; then
    echo "[verify-desktop] failed. timing report: $timing_report_file" >&2
  else
    echo "[verify-desktop] passed. timing report: $timing_report_file"
  fi
}

on_exit() {
  local exit_code="$?"
  write_timing_report "$exit_code"
}

trap on_exit EXIT

if [[ "${SKIP_PUB_GET:-0}" != "1" ]]; then
  run_stage "flutter pub get" flutter pub get
else
  append_stage "flutter pub get" "skipped" "0"
fi

run_stage "release script syntax check" ./scripts/check_release_script_syntax.sh
run_stage "release script syntax contract check" ./scripts/check_release_script_syntax_contract.sh
run_stage "verify test coverage check" ./scripts/check_verify_test_coverage.sh
run_stage "verify test coverage contract check" ./scripts/check_verify_test_coverage_contract.sh
run_stage "auth store legacy decommission check" env STRICT_AUTH_STORE_LEGACY_DECOMMISSION=1 ./scripts/check_auth_store_legacy_decommission.sh
run_stage "auth store legacy decommission contract check" ./scripts/check_auth_store_legacy_decommission_contract.sh
run_stage "desktop command inventory check" ./scripts/check_desktop_command_inventory.sh
run_stage "desktop command inventory contract check" ./scripts/check_desktop_command_inventory_contract.sh
run_stage "update manifest check" ./scripts/check_update_manifest.sh
run_stage "update manifest contract check" ./scripts/check_update_manifest_contract.sh
run_stage "release smoke gate policy contract check" ./scripts/check_release_smoke_gate_policy_contract.sh
run_stage "release evidence index check" ./scripts/check_release_evidence_index.sh
run_stage "release evidence index contract check" ./scripts/check_release_evidence_index_contract.sh

run_stage "contract tests" env FLUTTER_NO_PUB=1 ./scripts/run_contract_tests.sh
run_stage "parity tests" env FLUTTER_NO_PUB=1 ./scripts/run_parity_tests.sh
run_stage "mode matrix tests" env FLUTTER_NO_PUB=1 ./scripts/run_mode_matrix_tests.sh
run_stage "flutter analyze" flutter analyze --no-pub

if [[ "${INCLUDE_BUILD:-0}" == "1" ]]; then
  run_stage "macos debug build" flutter build macos --debug --no-pub
else
  append_stage "macos debug build" "skipped" "0"
fi
