#!/usr/bin/env bash
set -eo pipefail

report_file="${1:-release/reports/windows_installer_pipeline_contract_report.md}"
timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pipeline_script="${script_dir}/run_windows_installer_pipeline.sh"

mkdir -p "$(dirname "$report_file")"

case_rows=""
failure_count=0
total_cases=0

append_case_row() {
  local case_name="$1"
  local expected="$2"
  local actual="$3"
  local report_assertion="$4"
  local log_assertion="$5"
  local result="$6"
  local summary="$7"
  case_rows+="| ${case_name} | ${expected} | ${actual} | ${report_assertion} | ${log_assertion} | ${result} | ${summary} |"$'\n'
}

setup_empty_case() {
  local root_dir="$1"
  mkdir -p "$root_dir"
}

setup_release_runner_case() {
  local root_dir="$1"
  mkdir -p "$root_dir/build/windows/x64/runner/Release"
}

run_case() {
  local case_name="$1"
  local expected="$2"
  local summary="$3"
  local setup_fn="$4"
  local strict_arg="$5"
  local build_mode="$6"
  local required_report_pattern="$7"
  local required_log_pattern="$8"
  shift 8
  local env_overrides=("$@")

  local tmp_root tmp_report tmp_log rc actual result report_assertion log_assertion
  tmp_root="$(mktemp -d)"
  tmp_report="$tmp_root/windows_installer_pipeline_report.md"
  tmp_log="$tmp_root/windows_installer_pipeline.log"

  "$setup_fn" "$tmp_root"

  set +e
  (
    cd "$tmp_root"
    if [[ "${#env_overrides[@]}" -gt 0 ]]; then
      env "${env_overrides[@]}" "$pipeline_script" "$strict_arg" "$build_mode" "$tmp_report"
    else
      "$pipeline_script" "$strict_arg" "$build_mode" "$tmp_report"
    fi
  ) >"$tmp_log" 2>&1
  rc=$?
  set -e

  actual="pass"
  if [[ "$rc" -ne 0 ]]; then
    actual="fail"
  fi

  report_assertion="ok"
  if [[ -n "$required_report_pattern" ]]; then
    if [[ ! -f "$tmp_report" ]] || ! grep -Fq -- "$required_report_pattern" "$tmp_report"; then
      report_assertion="missing: ${required_report_pattern}"
    fi
  fi

  log_assertion="ok"
  if [[ -n "$required_log_pattern" ]]; then
    if ! grep -Fq -- "$required_log_pattern" "$tmp_log"; then
      log_assertion="missing: ${required_log_pattern}"
    fi
  fi

  result="ok"
  if [[ "$expected" != "$actual" || "$report_assertion" != "ok" || "$log_assertion" != "ok" ]]; then
    result="mismatch"
    failure_count=$((failure_count + 1))
  fi

  total_cases=$((total_cases + 1))
  append_case_row "$case_name" "$expected" "$actual" "$report_assertion" "$log_assertion" "$result" "$summary"

  rm -rf "$tmp_root"
}

run_case \
  "baseline-missing-runner-pass" \
  "pass" \
  "Missing runner directory should stay non-blocking in non-strict mode." \
  setup_empty_case \
  "0" \
  "release" \
  "- Protocol registration status: skipped" \
  "[windows-installer-pipeline] warning: pipeline skipped."

run_case \
  "strict-protocol-missing-command-fail" \
  "fail" \
  "Strict protocol mode must fail when protocol command is unset and runner exists." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Protocol error: protocol register command missing in strict protocol mode" \
  "[windows-installer-pipeline] strict mode failed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1"

run_case \
  "strict-protocol-placeholder-command-fail" \
  "fail" \
  "Strict protocol mode must fail when protocol command is a placeholder value." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Protocol command placeholder status: detected" \
  "[windows-installer-pipeline] strict mode failed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1" \
  "PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND=placeholder"

run_case \
  "strict-protocol-clear-command-pass" \
  "pass" \
  "Strict protocol mode should pass when a non-placeholder protocol command succeeds." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Protocol registration status: executed" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1" \
  "PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND=true"

run_case \
  "invalid-build-mode-fail" \
  "fail" \
  "Unsupported build modes should fail fast with explicit diagnostics." \
  setup_empty_case \
  "0" \
  "staging" \
  "" \
  "[windows-installer-pipeline] invalid build mode: staging (allowed: release|debug)"

status="passed"
if [[ "$failure_count" -gt 0 ]]; then
  status="failed"
fi

{
  echo "# Windows Installer Pipeline Contract Report"
  echo
  echo "- Generated at (UTC): $timestamp"
  echo "- Total cases: $total_cases"
  echo "- Failures: $failure_count"
  echo "- Status: $status"
  echo
  echo "| Case | Expected | Actual | Report assertion | Log assertion | Result | Summary |"
  echo "|---|---|---|---|---|---|---|"
  if [[ -n "$case_rows" ]]; then
    printf '%s' "$case_rows"
  else
    echo "| none | n/a | n/a | n/a | n/a | n/a | no cases executed |"
  fi
} > "$report_file"

if [[ "$failure_count" -gt 0 ]]; then
  echo "[windows-installer-pipeline-contract] failed with ${failure_count} mismatch(es). report: $report_file" >&2
  exit 1
fi

echo "[windows-installer-pipeline-contract] passed. report: $report_file"
