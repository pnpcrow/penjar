#!/usr/bin/env bash
set -eo pipefail

report_file="${1:-release/reports/windows_installer_pipeline_contract_report.md}"
timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pipeline_script="${script_dir}/run_windows_installer_pipeline.sh"

mkdir -p "$(dirname "$report_file")"

if [[ ! -f "$pipeline_script" ]]; then
  echo "[windows-installer-pipeline-contract] missing pipeline script: $pipeline_script" >&2
  exit 1
fi

if [[ ! -x "$pipeline_script" ]]; then
  echo "[windows-installer-pipeline-contract] pipeline script is not executable: $pipeline_script" >&2
  exit 1
fi

case_rows=""
failure_count=0
total_cases=0
escaped_markdown_cell=""
scratch_root="$(mktemp -d)"
case_name_registry=()

cleanup_contract_scratch() {
  rm -rf "$scratch_root"
}
trap cleanup_contract_scratch EXIT

escape_markdown_cell() {
  local value="$1"
  value="${value//\\/\\\\}"
  value="${value//|/\\|}"
  value="${value//$'\n'/\\n}"
  value="${value//$'\r'/\\r}"
  value="${value//$'\t'/\\t}"
  value="${value//$'\f'/\\f}"
  value="${value//$'\v'/\\v}"
  escaped_markdown_cell="$value"
}

append_case_row() {
  local case_name="$1"
  local expected="$2"
  local actual="$3"
  local report_assertion="$4"
  local log_assertion="$5"
  local result="$6"
  local summary="$7"
  local case_name_escaped expected_escaped actual_escaped report_assertion_escaped
  local log_assertion_escaped result_escaped summary_escaped

  escape_markdown_cell "$case_name"
  case_name_escaped="$escaped_markdown_cell"
  escape_markdown_cell "$expected"
  expected_escaped="$escaped_markdown_cell"
  escape_markdown_cell "$actual"
  actual_escaped="$escaped_markdown_cell"
  escape_markdown_cell "$report_assertion"
  report_assertion_escaped="$escaped_markdown_cell"
  escape_markdown_cell "$log_assertion"
  log_assertion_escaped="$escaped_markdown_cell"
  escape_markdown_cell "$result"
  result_escaped="$escaped_markdown_cell"
  escape_markdown_cell "$summary"
  summary_escaped="$escaped_markdown_cell"

  case_rows+="| ${case_name_escaped} | ${expected_escaped} | ${actual_escaped} | ${report_assertion_escaped} | ${log_assertion_escaped} | ${result_escaped} | ${summary_escaped} |"$'\n'
}

ensure_unique_case_name() {
  local candidate="$1"
  local existing
  for existing in "${case_name_registry[@]}"; do
    if [[ "$existing" == "$candidate" ]]; then
      echo "[windows-installer-pipeline-contract] duplicate case name: $candidate" >&2
      return 1
    fi
  done
  case_name_registry+=("$candidate")
}

setup_empty_case() {
  local root_dir="$1"
  mkdir -p "$root_dir"
}

setup_release_runner_case() {
  local root_dir="$1"
  mkdir -p "$root_dir/build/windows/x64/runner/Release"
}

setup_debug_runner_case() {
  local root_dir="$1"
  mkdir -p "$root_dir/build/windows/x64/runner/Debug"
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

  ensure_unique_case_name "$case_name"

  local case_index case_root tmp_report tmp_log rc actual result report_assertion log_assertion
  local report_content log_content
  case_index=$((total_cases + 1))
  case_root="$scratch_root/case_${case_index}"
  mkdir -p "$case_root"
  tmp_report="$case_root/windows_installer_pipeline_report.md"
  tmp_log="$case_root/windows_installer_pipeline.log"

  "$setup_fn" "$case_root"

  set +e
  (
    cd "$case_root"
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
    if [[ ! -f "$tmp_report" ]]; then
      report_assertion="missing: ${required_report_pattern}"
    else
      report_content="$(<"$tmp_report")"
      if [[ "$report_content" != *"$required_report_pattern"* ]]; then
        report_assertion="missing: ${required_report_pattern}"
      fi
    fi
  fi

  log_assertion="ok"
  if [[ -n "$required_log_pattern" ]]; then
    if [[ ! -f "$tmp_log" ]]; then
      log_assertion="missing: ${required_log_pattern}"
    else
      log_content="$(<"$tmp_log")"
      if [[ "$log_content" != *"$required_log_pattern"* ]]; then
        log_assertion="missing: ${required_log_pattern}"
      fi
    fi
  fi

  result="ok"
  if [[ "$expected" != "$actual" || "$report_assertion" != "ok" || "$log_assertion" != "ok" ]]; then
    result="mismatch"
    failure_count=$((failure_count + 1))
  fi

  total_cases=$((total_cases + 1))
  append_case_row "$case_name" "$expected" "$actual" "$report_assertion" "$log_assertion" "$result" "$summary"

  rm -rf "$case_root"
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
  "non-strict-installer-command-failure-warning-pass" \
  "pass" \
  "Non-strict mode should keep installer command non-zero failures non-blocking with warning diagnostics." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Error: installer command failed" \
  "[windows-installer-pipeline] warning: pipeline failed." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=false"

run_case \
  "non-strict-installer-placeholder-warning-pass" \
  "pass" \
  "Non-strict mode should keep installer placeholder commands non-blocking with warning diagnostics." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Installer command placeholder status: detected" \
  "[windows-installer-pipeline] warning: placeholder installer command detected." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=placeholder"

run_case \
  "non-strict-protocol-command-failure-warning-pass" \
  "pass" \
  "Non-strict mode should keep protocol command non-zero failures non-blocking with warning diagnostics." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Protocol error: protocol register command failed" \
  "[windows-installer-pipeline] warning: protocol registration failed." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=true" \
  "PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND=false"

run_case \
  "non-strict-protocol-placeholder-warning-pass" \
  "pass" \
  "Non-strict mode should keep protocol placeholder commands non-blocking with warning diagnostics." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Protocol command placeholder status: detected" \
  "[windows-installer-pipeline] warning: placeholder protocol command detected." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=true" \
  "PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND=placeholder"

run_case \
  "debug-mode-non-strict-installer-command-failure-warning-pass" \
  "pass" \
  "Non-strict debug mode should keep installer command non-zero failures non-blocking with warning diagnostics." \
  setup_debug_runner_case \
  "0" \
  "debug" \
  "- Error: installer command failed" \
  "[windows-installer-pipeline] warning: pipeline failed." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=false"

run_case \
  "debug-mode-non-strict-installer-placeholder-warning-pass" \
  "pass" \
  "Non-strict debug mode should keep installer placeholder commands non-blocking with warning diagnostics." \
  setup_debug_runner_case \
  "0" \
  "debug" \
  "- Installer command placeholder status: detected" \
  "[windows-installer-pipeline] warning: placeholder installer command detected." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=placeholder"

run_case \
  "debug-mode-non-strict-protocol-command-failure-warning-pass" \
  "pass" \
  "Non-strict debug mode should keep protocol command non-zero failures non-blocking with warning diagnostics." \
  setup_debug_runner_case \
  "0" \
  "debug" \
  "- Protocol error: protocol register command failed" \
  "[windows-installer-pipeline] warning: protocol registration failed." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=true" \
  "PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND=false"

run_case \
  "debug-mode-non-strict-protocol-placeholder-warning-pass" \
  "pass" \
  "Non-strict debug mode should keep protocol placeholder commands non-blocking with warning diagnostics." \
  setup_debug_runner_case \
  "0" \
  "debug" \
  "- Protocol command placeholder status: detected" \
  "[windows-installer-pipeline] warning: placeholder protocol command detected." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=true" \
  "PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND=placeholder"

run_case \
  "strict-installer-missing-runner-fail" \
  "fail" \
  "Strict installer mode must fail when the runner directory is missing in release mode." \
  setup_empty_case \
  "1" \
  "release" \
  "- Error: missing runner directory: build/windows/x64/runner/Release" \
  "[windows-installer-pipeline] strict mode failed."

run_case \
  "strict-protocol-missing-runner-fail" \
  "fail" \
  "Strict protocol mode must fail when the runner directory is missing in release mode." \
  setup_empty_case \
  "0" \
  "release" \
  "- Protocol error: missing runner directory for strict protocol registration: build/windows/x64/runner/Release" \
  "[windows-installer-pipeline] strict mode failed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1"

run_case \
  "debug-mode-strict-installer-missing-runner-fail" \
  "fail" \
  "Strict installer mode must fail when the runner directory is missing in debug mode." \
  setup_empty_case \
  "1" \
  "debug" \
  "- Error: missing runner directory: build/windows/x64/runner/Debug" \
  "[windows-installer-pipeline] strict mode failed."

run_case \
  "debug-mode-strict-protocol-missing-runner-fail" \
  "fail" \
  "Strict protocol mode must fail when the runner directory is missing in debug mode." \
  setup_empty_case \
  "0" \
  "debug" \
  "- Protocol error: missing runner directory for strict protocol registration: build/windows/x64/runner/Debug" \
  "[windows-installer-pipeline] strict mode failed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1"

run_case \
  "strict-installer-missing-command-fail" \
  "fail" \
  "Strict installer mode must fail when installer command is unset and runner exists." \
  setup_release_runner_case \
  "1" \
  "release" \
  "- Error: installer command missing in strict mode" \
  "[windows-installer-pipeline] strict mode failed."

run_case \
  "strict-installer-true-alias-missing-command-fail" \
  "fail" \
  "Strict installer mode parser should treat strict input alias 'true' as strict and fail on missing installer command." \
  setup_release_runner_case \
  "true" \
  "release" \
  "- Strict mode: 1" \
  "[windows-installer-pipeline] strict mode failed."

run_case \
  "strict-installer-false-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should not treat strict input alias 'false' as strict when installer command is missing." \
  setup_release_runner_case \
  "false" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-whitespace-false-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should trim whitespace and keep alias ' false ' non-strict when installer command is missing." \
  setup_release_runner_case \
  " false " \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-off-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep alias 'off' non-strict when installer command is missing." \
  setup_release_runner_case \
  "off" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-whitespace-zero-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should trim alias ' 0 ' and keep it non-strict when installer command is missing." \
  setup_release_runner_case \
  " 0 " \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-truee-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep near-match alias 'truee' non-strict when installer command is missing." \
  setup_release_runner_case \
  "truee" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-yesplease-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep near-match alias 'yesplease' non-strict when installer command is missing." \
  setup_release_runner_case \
  "yesplease" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-strict-mode-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep near-match alias 'strict-mode' non-strict when installer command is missing." \
  setup_release_runner_case \
  "strict-mode" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-newline-uppercase-truee-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should trim newline-wrapped near-match alias '\\nTRUEE\\n' and keep it non-strict when installer command is missing." \
  setup_release_runner_case \
  $'\nTRUEE\n' \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-leading-zero-one-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep numeric near-match alias '01' non-strict when installer command is missing." \
  setup_release_runner_case \
  "01" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-decimal-one-zero-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep numeric near-match alias '1.0' non-strict when installer command is missing." \
  setup_release_runner_case \
  "1.0" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-plus-one-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep numeric near-match alias '+1' non-strict when installer command is missing." \
  setup_release_runner_case \
  "+1" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-scientific-one-e-zero-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep numeric near-match alias '1e0' non-strict when installer command is missing." \
  setup_release_runner_case \
  "1e0" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-hex-one-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep numeric near-match alias '0x1' non-strict when installer command is missing." \
  setup_release_runner_case \
  "0x1" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-binary-one-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep numeric near-match alias '0b1' non-strict when installer command is missing." \
  setup_release_runner_case \
  "0b1" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-uppercase-hex-one-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep numeric near-match alias '0X1' non-strict when installer command is missing." \
  setup_release_runner_case \
  "0X1" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-uppercase-binary-one-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep numeric near-match alias '0B1' non-strict when installer command is missing." \
  setup_release_runner_case \
  "0B1" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-underscore-one-zero-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep numeric near-match alias '1_0' non-strict when installer command is missing." \
  setup_release_runner_case \
  "1_0" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-comma-one-zero-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep numeric near-match alias '1,0' non-strict when installer command is missing." \
  setup_release_runner_case \
  "1,0" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-double-quoted-one-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep quoted near-match alias '\"1\"' non-strict when installer command is missing." \
  setup_release_runner_case \
  "\"1\"" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-single-quoted-one-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep quoted near-match alias \"'1'\" non-strict when installer command is missing." \
  setup_release_runner_case \
  "'1'" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-parenthesized-one-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep wrapper near-match alias '(1)' non-strict when installer command is missing." \
  setup_release_runner_case \
  "(1)" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-bracketed-one-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep wrapper near-match alias '[1]' non-strict when installer command is missing." \
  setup_release_runner_case \
  "[1]" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-whitespace-decimal-one-zero-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should trim numeric near-match alias ' 1.0 ' and keep it non-strict when installer command is missing." \
  setup_release_runner_case \
  " 1.0 " \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-tab-plus-one-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should trim numeric near-match alias '\\t+1\\t' and keep it non-strict when installer command is missing." \
  setup_release_runner_case \
  $'\t+1\t' \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-space-separated-one-zero-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep numeric near-match alias '1 0' non-strict when installer command is missing." \
  setup_release_runner_case \
  "1 0" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-newline-separated-one-zero-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep numeric near-match alias '1\\n0' non-strict when installer command is missing." \
  setup_release_runner_case \
  $'1\n0' \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-carriage-return-separated-one-zero-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep numeric near-match alias '1\\r0' non-strict when installer command is missing." \
  setup_release_runner_case \
  $'1\r0' \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-tab-separated-one-zero-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep numeric near-match alias '1\\t0' non-strict when installer command is missing." \
  setup_release_runner_case \
  $'1\t0' \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-expression-one-plus-zero-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep expression near-match alias '1+0' non-strict when installer command is missing." \
  setup_release_runner_case \
  "1+0" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-expression-one-minus-zero-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep expression near-match alias '1-0' non-strict when installer command is missing." \
  setup_release_runner_case \
  "1-0" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-expression-one-times-one-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep expression near-match alias '1*1' non-strict when installer command is missing." \
  setup_release_runner_case \
  "1*1" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-expression-one-div-one-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep expression near-match alias '1/1' non-strict when installer command is missing." \
  setup_release_runner_case \
  "1/1" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-expression-one-mod-one-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep expression near-match alias '1%1' non-strict when installer command is missing." \
  setup_release_runner_case \
  "1%1" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-expression-one-caret-one-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep expression near-match alias '1^1' non-strict when installer command is missing." \
  setup_release_runner_case \
  "1^1" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-expression-one-and-one-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep expression near-match alias '1&1' non-strict when installer command is missing." \
  setup_release_runner_case \
  "1&1" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-expression-one-pipe-one-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep expression near-match alias '1|1' non-strict when installer command is missing." \
  setup_release_runner_case \
  "1|1" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-expression-one-less-than-one-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep expression near-match alias '1<1' non-strict when installer command is missing." \
  setup_release_runner_case \
  "1<1" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-expression-one-greater-than-one-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep expression near-match alias '1>1' non-strict when installer command is missing." \
  setup_release_runner_case \
  "1>1" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-expression-one-eqeq-one-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep expression near-match alias '1==1' non-strict when installer command is missing." \
  setup_release_runner_case \
  "1==1" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-expression-one-noteq-one-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep expression near-match alias '1!=1' non-strict when installer command is missing." \
  setup_release_runner_case \
  "1!=1" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-expression-one-andand-one-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep expression near-match alias '1&&1' non-strict when installer command is missing." \
  setup_release_runner_case \
  "1&&1" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-expression-one-pipepipe-one-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep expression near-match alias '1||1' non-strict when installer command is missing." \
  setup_release_runner_case \
  "1||1" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-expression-one-shift-left-one-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep expression near-match alias '1<<1' non-strict when installer command is missing." \
  setup_release_runner_case \
  "1<<1" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-expression-one-shift-right-one-alias-missing-command-pass" \
  "pass" \
  "Strict installer mode parser should keep expression near-match alias '1>>1' non-strict when installer command is missing." \
  setup_release_runner_case \
  "1>>1" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] completed."

run_case \
  "strict-installer-nearmatch-truee-placeholder-warning-pass" \
  "pass" \
  "Strict installer mode parser should keep near-match alias 'truee' non-strict and preserve placeholder warning behavior." \
  setup_release_runner_case \
  "truee" \
  "release" \
  "- Strict mode: 0" \
  "[windows-installer-pipeline] warning: placeholder installer command detected." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=placeholder"

run_case \
  "strict-installer-strict-alias-clear-command-pass" \
  "pass" \
  "Strict installer mode parser should treat strict input alias 'strict' as strict and pass when installer command succeeds." \
  setup_release_runner_case \
  "strict" \
  "release" \
  "- Strict mode: 1" \
  "[windows-installer-pipeline] completed." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=true"

run_case \
  "strict-installer-yes-alias-placeholder-fail" \
  "fail" \
  "Strict installer mode parser should treat strict input alias 'yes' as strict and fail on placeholder installer command." \
  setup_release_runner_case \
  "yes" \
  "release" \
  "- Strict mode: 1" \
  "[windows-installer-pipeline] strict mode failed." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=placeholder"

run_case \
  "strict-installer-uppercase-yes-alias-placeholder-fail" \
  "fail" \
  "Strict installer mode parser should treat uppercase strict input alias 'YES' as strict and fail on placeholder installer command." \
  setup_release_runner_case \
  "YES" \
  "release" \
  "- Strict mode: 1" \
  "[windows-installer-pipeline] strict mode failed." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=placeholder"

run_case \
  "strict-installer-whitespace-yes-alias-placeholder-fail" \
  "fail" \
  "Strict installer mode parser should trim strict input alias whitespace and fail on placeholder installer command for ' yes '." \
  setup_release_runner_case \
  " yes " \
  "release" \
  "- Strict mode: 1" \
  "[windows-installer-pipeline] strict mode failed." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=placeholder"

run_case \
  "strict-installer-tab-whitespace-yes-alias-placeholder-fail" \
  "fail" \
  "Strict installer mode parser should trim tab-wrapped strict input alias and fail on placeholder installer command for '\\tYES\\t'." \
  setup_release_runner_case \
  $'\tYES\t' \
  "release" \
  "- Strict mode: 1" \
  "[windows-installer-pipeline] strict mode failed." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=placeholder"

run_case \
  "strict-installer-newline-whitespace-yes-alias-placeholder-fail" \
  "fail" \
  "Strict installer mode parser should trim newline-wrapped strict input alias and fail on placeholder installer command for '\\nYES\\n'." \
  setup_release_runner_case \
  $'\nYES\n' \
  "release" \
  "- Strict mode: 1" \
  "[windows-installer-pipeline] strict mode failed." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=placeholder"

run_case \
  "strict-installer-whitespace-numeric-one-placeholder-fail" \
  "fail" \
  "Strict installer mode parser should trim numeric strict input alias and fail on placeholder installer command for ' 1 '." \
  setup_release_runner_case \
  " 1 " \
  "release" \
  "- Strict mode: 1" \
  "[windows-installer-pipeline] strict mode failed." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=placeholder"

run_case \
  "strict-installer-cr-whitespace-yes-alias-placeholder-fail" \
  "fail" \
  "Strict installer mode parser should trim carriage-return-wrapped strict input alias and fail on placeholder installer command for '\\rYES\\r'." \
  setup_release_runner_case \
  $'\rYES\r' \
  "release" \
  "- Strict mode: 1" \
  "[windows-installer-pipeline] strict mode failed." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=placeholder"

run_case \
  "strict-installer-crlf-whitespace-yes-alias-placeholder-fail" \
  "fail" \
  "Strict installer mode parser should trim CRLF-wrapped strict input alias and fail on placeholder installer command for '\\r\\nYES\\r\\n'." \
  setup_release_runner_case \
  $'\r\nYES\r\n' \
  "release" \
  "- Strict mode: 1" \
  "[windows-installer-pipeline] strict mode failed." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=placeholder"

run_case \
  "strict-installer-formfeed-whitespace-yes-alias-placeholder-fail" \
  "fail" \
  "Strict installer mode parser should trim form-feed-wrapped strict input alias and fail on placeholder installer command for '\\fYES\\f'." \
  setup_release_runner_case \
  $'\fYES\f' \
  "release" \
  "- Strict mode: 1" \
  "[windows-installer-pipeline] strict mode failed." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=placeholder"

run_case \
  "strict-installer-vtab-whitespace-yes-alias-placeholder-fail" \
  "fail" \
  "Strict installer mode parser should trim vertical-tab-wrapped strict input alias and fail on placeholder installer command for '\\vYES\\v'." \
  setup_release_runner_case \
  $'\vYES\v' \
  "release" \
  "- Strict mode: 1" \
  "[windows-installer-pipeline] strict mode failed." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=placeholder"

run_case \
  "strict-installer-placeholder-command-fail" \
  "fail" \
  "Strict installer mode must fail when installer command is a placeholder value." \
  setup_release_runner_case \
  "1" \
  "release" \
  "- Error: installer command appears to be a placeholder in strict mode" \
  "[windows-installer-pipeline] strict mode failed." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=placeholder"

run_case \
  "strict-installer-clear-command-pass" \
  "pass" \
  "Strict installer mode should pass when installer command is configured and succeeds." \
  setup_release_runner_case \
  "1" \
  "release" \
  "- Execution status: executed" \
  "[windows-installer-pipeline] completed." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=true"

run_case \
  "strict-installer-command-failure-fail" \
  "fail" \
  "Strict installer mode must fail when installer command execution returns non-zero in release mode." \
  setup_release_runner_case \
  "1" \
  "release" \
  "- Error: installer command failed" \
  "[windows-installer-pipeline] strict mode failed." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=false"

run_case \
  "debug-mode-strict-installer-command-failure-fail" \
  "fail" \
  "Strict installer mode must fail when installer command execution returns non-zero in debug mode." \
  setup_debug_runner_case \
  "1" \
  "debug" \
  "- Error: installer command failed" \
  "[windows-installer-pipeline] strict mode failed." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=false"

run_case \
  "strict-installer-protocol-placeholder-fail" \
  "fail" \
  "Strict installer mode must fail when protocol command is placeholder, even without strict protocol mode." \
  setup_release_runner_case \
  "1" \
  "release" \
  "- Protocol error: protocol register command appears to be a placeholder in strict mode" \
  "[windows-installer-pipeline] strict mode failed." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=true" \
  "PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND=placeholder"

run_case \
  "strict-installer-protocol-command-failure-fail" \
  "fail" \
  "Strict installer mode must fail when protocol command execution returns non-zero in release mode." \
  setup_release_runner_case \
  "1" \
  "release" \
  "- Protocol error: protocol register command failed" \
  "[windows-installer-pipeline] strict mode failed." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=true" \
  "PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND=false"

run_case \
  "debug-mode-strict-installer-protocol-command-failure-fail" \
  "fail" \
  "Strict installer mode must fail when protocol command execution returns non-zero in debug mode." \
  setup_debug_runner_case \
  "1" \
  "debug" \
  "- Protocol error: protocol register command failed" \
  "[windows-installer-pipeline] strict mode failed." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=true" \
  "PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND=false"

run_case \
  "debug-mode-strict-installer-clear-command-pass" \
  "pass" \
  "Debug build mode should resolve debug runner directory and pass strict installer execution with a clear command." \
  setup_debug_runner_case \
  "1" \
  "debug" \
  "- Runner directory: build/windows/x64/runner/Debug" \
  "[windows-installer-pipeline] completed." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=true"

run_case \
  "debug-mode-strict-installer-true-alias-clear-command-pass" \
  "pass" \
  "Strict installer alias 'true' should pass in debug mode when installer command succeeds." \
  setup_debug_runner_case \
  "true" \
  "debug" \
  "- Strict mode: 1" \
  "[windows-installer-pipeline] completed." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=true"

run_case \
  "debug-mode-strict-installer-mixedcase-strict-alias-clear-command-pass" \
  "pass" \
  "Strict installer alias 'StRiCt' should pass in debug mode when installer command succeeds." \
  setup_debug_runner_case \
  "StRiCt" \
  "debug" \
  "- Strict mode: 1" \
  "[windows-installer-pipeline] completed." \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=true"

run_case \
  "debug-mode-strict-protocol-missing-command-fail" \
  "fail" \
  "Strict protocol mode should fail in debug build mode when protocol command is missing." \
  setup_debug_runner_case \
  "0" \
  "debug" \
  "- Protocol error: protocol register command missing in strict protocol mode" \
  "[windows-installer-pipeline] strict mode failed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1"

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
  "strict-protocol-true-alias-missing-command-fail" \
  "fail" \
  "Strict protocol mode parser should treat protocol alias 'true' as strict and fail on missing protocol command." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 1" \
  "[windows-installer-pipeline] strict mode failed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=true"

run_case \
  "strict-protocol-false-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should not treat protocol alias 'false' as strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=false"

run_case \
  "strict-protocol-whitespace-false-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should trim whitespace and keep alias ' false ' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION= false "

run_case \
  "strict-protocol-off-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep alias 'off' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=off"

run_case \
  "strict-protocol-whitespace-zero-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should trim alias ' 0 ' and keep it non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION= 0 "

run_case \
  "strict-protocol-nearmatch-truee-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep near-match alias 'truee' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=truee"

run_case \
  "strict-protocol-nearmatch-yesplease-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep near-match alias 'yesplease' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=yesplease"

run_case \
  "strict-protocol-nearmatch-strict-mode-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep near-match alias 'strict-mode' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=strict-mode"

run_case \
  "strict-protocol-nearmatch-newline-uppercase-truee-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should trim newline-wrapped near-match alias '\\nTRUEE\\n' and keep it non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  $'STRICT_WINDOWS_PROTOCOL_REGISTRATION=\nTRUEE\n'

run_case \
  "strict-protocol-nearmatch-leading-zero-one-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep numeric near-match alias '01' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=01"

run_case \
  "strict-protocol-nearmatch-decimal-one-zero-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep numeric near-match alias '1.0' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1.0"

run_case \
  "strict-protocol-nearmatch-plus-one-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep numeric near-match alias '+1' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=+1"

run_case \
  "strict-protocol-nearmatch-scientific-one-e-zero-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep numeric near-match alias '1e0' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1e0"

run_case \
  "strict-protocol-nearmatch-hex-one-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep numeric near-match alias '0x1' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=0x1"

run_case \
  "strict-protocol-nearmatch-binary-one-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep numeric near-match alias '0b1' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=0b1"

run_case \
  "strict-protocol-nearmatch-uppercase-hex-one-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep numeric near-match alias '0X1' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=0X1"

run_case \
  "strict-protocol-nearmatch-uppercase-binary-one-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep numeric near-match alias '0B1' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=0B1"

run_case \
  "strict-protocol-nearmatch-underscore-one-zero-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep numeric near-match alias '1_0' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1_0"

run_case \
  "strict-protocol-nearmatch-comma-one-zero-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep numeric near-match alias '1,0' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1,0"

run_case \
  "strict-protocol-nearmatch-double-quoted-one-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep quoted near-match alias '\"1\"' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  'STRICT_WINDOWS_PROTOCOL_REGISTRATION="1"'

run_case \
  "strict-protocol-nearmatch-single-quoted-one-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep quoted near-match alias \"'1'\" non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION='1'"

run_case \
  "strict-protocol-nearmatch-parenthesized-one-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep wrapper near-match alias '(1)' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=(1)"

run_case \
  "strict-protocol-nearmatch-bracketed-one-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep wrapper near-match alias '[1]' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=[1]"

run_case \
  "strict-protocol-nearmatch-whitespace-decimal-one-zero-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should trim numeric near-match alias ' 1.0 ' and keep it non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION= 1.0 "

run_case \
  "strict-protocol-nearmatch-tab-plus-one-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should trim numeric near-match alias '\\t+1\\t' and keep it non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  $'STRICT_WINDOWS_PROTOCOL_REGISTRATION=\t+1\t'

run_case \
  "strict-protocol-nearmatch-space-separated-one-zero-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep numeric near-match alias '1 0' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1 0"

run_case \
  "strict-protocol-nearmatch-newline-separated-one-zero-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep numeric near-match alias '1\\n0' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  $'STRICT_WINDOWS_PROTOCOL_REGISTRATION=1\n0'

run_case \
  "strict-protocol-nearmatch-carriage-return-separated-one-zero-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep numeric near-match alias '1\\r0' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  $'STRICT_WINDOWS_PROTOCOL_REGISTRATION=1\r0'

run_case \
  "strict-protocol-nearmatch-tab-separated-one-zero-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep numeric near-match alias '1\\t0' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  $'STRICT_WINDOWS_PROTOCOL_REGISTRATION=1\t0'

run_case \
  "strict-protocol-nearmatch-expression-one-plus-zero-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep expression near-match alias '1+0' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1+0"

run_case \
  "strict-protocol-nearmatch-expression-one-minus-zero-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep expression near-match alias '1-0' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1-0"

run_case \
  "strict-protocol-nearmatch-expression-one-times-one-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep expression near-match alias '1*1' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1*1"

run_case \
  "strict-protocol-nearmatch-expression-one-div-one-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep expression near-match alias '1/1' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1/1"

run_case \
  "strict-protocol-nearmatch-expression-one-mod-one-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep expression near-match alias '1%1' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1%1"

run_case \
  "strict-protocol-nearmatch-expression-one-caret-one-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep expression near-match alias '1^1' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1^1"

run_case \
  "strict-protocol-nearmatch-expression-one-and-one-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep expression near-match alias '1&1' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1&1"

run_case \
  "strict-protocol-nearmatch-expression-one-pipe-one-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep expression near-match alias '1|1' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1|1"

run_case \
  "strict-protocol-nearmatch-expression-one-less-than-one-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep expression near-match alias '1<1' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1<1"

run_case \
  "strict-protocol-nearmatch-expression-one-greater-than-one-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep expression near-match alias '1>1' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1>1"

run_case \
  "strict-protocol-nearmatch-expression-one-eqeq-one-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep expression near-match alias '1==1' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1==1"

run_case \
  "strict-protocol-nearmatch-expression-one-noteq-one-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep expression near-match alias '1!=1' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1!=1"

run_case \
  "strict-protocol-nearmatch-expression-one-andand-one-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep expression near-match alias '1&&1' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1&&1"

run_case \
  "strict-protocol-nearmatch-expression-one-pipepipe-one-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep expression near-match alias '1||1' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1||1"

run_case \
  "strict-protocol-nearmatch-expression-one-shift-left-one-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep expression near-match alias '1<<1' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1<<1"

run_case \
  "strict-protocol-nearmatch-expression-one-shift-right-one-alias-missing-command-pass" \
  "pass" \
  "Strict protocol mode parser should keep expression near-match alias '1>>1' non-strict when protocol command is missing." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1>>1"

run_case \
  "strict-protocol-nearmatch-truee-placeholder-warning-pass" \
  "pass" \
  "Strict protocol mode parser should keep near-match alias 'truee' non-strict and preserve protocol placeholder warning behavior." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 0" \
  "[windows-installer-pipeline] warning: placeholder protocol command detected." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=truee" \
  "PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND=placeholder"

run_case \
  "strict-protocol-uppercase-true-alias-missing-command-fail" \
  "fail" \
  "Strict protocol mode parser should treat uppercase protocol alias 'TRUE' as strict and fail on missing protocol command." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 1" \
  "[windows-installer-pipeline] strict mode failed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=TRUE"

run_case \
  "strict-protocol-whitespace-true-alias-missing-command-fail" \
  "fail" \
  "Strict protocol mode parser should trim protocol alias whitespace and fail on missing protocol command for ' true '." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 1" \
  "[windows-installer-pipeline] strict mode failed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION= true "

run_case \
  "strict-protocol-tab-whitespace-true-alias-missing-command-fail" \
  "fail" \
  "Strict protocol mode parser should trim tab-wrapped protocol alias and fail on missing protocol command for '\\tTRUE\\t'." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 1" \
  "[windows-installer-pipeline] strict mode failed." \
  $'STRICT_WINDOWS_PROTOCOL_REGISTRATION=\tTRUE\t'

run_case \
  "strict-protocol-newline-whitespace-true-alias-missing-command-fail" \
  "fail" \
  "Strict protocol mode parser should trim newline-wrapped protocol alias and fail on missing protocol command for '\\nTRUE\\n'." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 1" \
  "[windows-installer-pipeline] strict mode failed." \
  $'STRICT_WINDOWS_PROTOCOL_REGISTRATION=\nTRUE\n'

run_case \
  "strict-protocol-whitespace-numeric-one-missing-command-fail" \
  "fail" \
  "Strict protocol mode parser should trim numeric strict alias and fail on missing protocol command for ' 1 '." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 1" \
  "[windows-installer-pipeline] strict mode failed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION= 1 "

run_case \
  "strict-protocol-cr-whitespace-true-alias-missing-command-fail" \
  "fail" \
  "Strict protocol mode parser should trim carriage-return-wrapped protocol alias and fail on missing protocol command for '\\rTRUE\\r'." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 1" \
  "[windows-installer-pipeline] strict mode failed." \
  $'STRICT_WINDOWS_PROTOCOL_REGISTRATION=\rTRUE\r'

run_case \
  "strict-protocol-crlf-whitespace-true-alias-missing-command-fail" \
  "fail" \
  "Strict protocol mode parser should trim CRLF-wrapped protocol alias and fail on missing protocol command for '\\r\\nTRUE\\r\\n'." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 1" \
  "[windows-installer-pipeline] strict mode failed." \
  $'STRICT_WINDOWS_PROTOCOL_REGISTRATION=\r\nTRUE\r\n'

run_case \
  "strict-protocol-formfeed-whitespace-true-alias-missing-command-fail" \
  "fail" \
  "Strict protocol mode parser should trim form-feed-wrapped protocol alias and fail on missing protocol command for '\\fTRUE\\f'." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 1" \
  "[windows-installer-pipeline] strict mode failed." \
  $'STRICT_WINDOWS_PROTOCOL_REGISTRATION=\fTRUE\f'

run_case \
  "strict-protocol-vtab-whitespace-true-alias-missing-command-fail" \
  "fail" \
  "Strict protocol mode parser should trim vertical-tab-wrapped protocol alias and fail on missing protocol command for '\\vTRUE\\v'." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 1" \
  "[windows-installer-pipeline] strict mode failed." \
  $'STRICT_WINDOWS_PROTOCOL_REGISTRATION=\vTRUE\v'

run_case \
  "strict-protocol-strict-alias-missing-command-fail" \
  "fail" \
  "Strict protocol mode parser should treat protocol alias 'strict' as strict and fail on missing protocol command." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 1" \
  "[windows-installer-pipeline] strict mode failed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=strict"

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
  "strict-protocol-yes-alias-clear-command-pass" \
  "pass" \
  "Strict protocol mode parser should treat protocol alias 'yes' as strict and pass when protocol command succeeds." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 1" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=yes" \
  "PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND=true"

run_case \
  "strict-protocol-mixedcase-yes-alias-clear-command-pass" \
  "pass" \
  "Strict protocol mode parser should treat mixed-case protocol alias 'YeS' as strict and pass when protocol command succeeds." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Strict protocol registration mode: 1" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=YeS" \
  "PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND=true"

run_case \
  "strict-protocol-strict-alias-installer-placeholder-warning-pass" \
  "pass" \
  "Strict protocol alias 'strict' should keep installer placeholder warnings non-blocking when protocol command succeeds." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Installer command placeholder status: detected" \
  "[windows-installer-pipeline] warning: placeholder installer command detected." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=strict" \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=placeholder" \
  "PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND=true"

run_case \
  "strict-protocol-yes-alias-installer-command-failure-warning-pass" \
  "pass" \
  "Strict protocol alias 'yes' should keep installer command non-zero failures non-blocking when protocol command succeeds." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Error: installer command failed" \
  "[windows-installer-pipeline] warning: pipeline failed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=yes" \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=false" \
  "PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND=true"

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
  "strict-protocol-installer-command-failure-warning-pass" \
  "pass" \
  "Strict protocol mode should keep installer command non-zero failures non-blocking when protocol command succeeds in release mode." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Error: installer command failed" \
  "[windows-installer-pipeline] warning: pipeline failed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1" \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=false" \
  "PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND=true"

run_case \
  "strict-protocol-installer-placeholder-warning-pass" \
  "pass" \
  "Strict protocol mode should keep installer placeholder commands non-blocking when protocol command succeeds in release mode." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Installer command placeholder status: detected" \
  "[windows-installer-pipeline] warning: placeholder installer command detected." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1" \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=placeholder" \
  "PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND=true"

run_case \
  "debug-mode-strict-protocol-installer-command-failure-warning-pass" \
  "pass" \
  "Strict protocol mode should keep installer command non-zero failures non-blocking when protocol command succeeds in debug mode." \
  setup_debug_runner_case \
  "0" \
  "debug" \
  "- Error: installer command failed" \
  "[windows-installer-pipeline] warning: pipeline failed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1" \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=false" \
  "PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND=true"

run_case \
  "debug-mode-strict-protocol-installer-placeholder-warning-pass" \
  "pass" \
  "Strict protocol mode should keep installer placeholder commands non-blocking when protocol command succeeds in debug mode." \
  setup_debug_runner_case \
  "0" \
  "debug" \
  "- Installer command placeholder status: detected" \
  "[windows-installer-pipeline] warning: placeholder installer command detected." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1" \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=placeholder" \
  "PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND=true"

run_case \
  "strict-protocol-installer-removes-runner-skips-protocol-pass" \
  "pass" \
  "Strict protocol mode should skip protocol execution and remain non-blocking when installer command removes the runner directory in release mode." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Protocol registration status: simulated" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1" \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=rm -rf \"\$PENJAR_WINDOWS_RUNNER_DIR\"; true" \
  "PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND=false"

run_case \
  "debug-mode-strict-protocol-installer-removes-runner-skips-protocol-pass" \
  "pass" \
  "Strict protocol mode should skip protocol execution and remain non-blocking when installer command removes the runner directory in debug mode." \
  setup_debug_runner_case \
  "0" \
  "debug" \
  "- Protocol registration status: simulated" \
  "[windows-installer-pipeline] completed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1" \
  "PENJAR_WINDOWS_INSTALLER_COMMAND=rm -rf \"\$PENJAR_WINDOWS_RUNNER_DIR\"; true" \
  "PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND=false"

run_case \
  "strict-protocol-command-failure-fail" \
  "fail" \
  "Strict protocol mode must fail when protocol registration command returns non-zero in release mode." \
  setup_release_runner_case \
  "0" \
  "release" \
  "- Protocol error: protocol register command failed" \
  "[windows-installer-pipeline] strict mode failed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1" \
  "PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND=false"

run_case \
  "debug-mode-strict-protocol-command-failure-fail" \
  "fail" \
  "Strict protocol mode must fail when protocol registration command returns non-zero in debug mode." \
  setup_debug_runner_case \
  "0" \
  "debug" \
  "- Protocol error: protocol register command failed" \
  "[windows-installer-pipeline] strict mode failed." \
  "STRICT_WINDOWS_PROTOCOL_REGISTRATION=1" \
  "PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND=false"

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
