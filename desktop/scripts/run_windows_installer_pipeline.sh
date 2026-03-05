#!/usr/bin/env bash
set -eo pipefail

strict_input="${1:-0}"
build_mode="${2:-release}"
report_file="${3:-release/reports/windows_installer_pipeline_report.md}"

strict_mode=0
case "$(printf '%s' "$strict_input" | tr '[:upper:]' '[:lower:]')" in
  1|true|yes|strict) strict_mode=1 ;;
esac

mode_dir=""
case "$build_mode" in
  release) mode_dir="Release" ;;
  debug) mode_dir="Debug" ;;
  *)
    echo "[windows-installer-pipeline] invalid build mode: $build_mode (allowed: release|debug)" >&2
    exit 1
    ;;
esac

runner_dir="build/windows/x64/runner/${mode_dir}"
installer_output_path_default="${runner_dir}/installer/PenjarInstaller.msi"
installer_output_path="${PENJAR_WINDOWS_INSTALLER_PATH:-$installer_output_path_default}"
installer_command="${PENJAR_WINDOWS_INSTALLER_COMMAND:-}"

timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
mkdir -p "$(dirname "$report_file")"

execution_status="simulated"
error_message=""
command_placeholder_status="not-configured"

is_placeholder_command() {
  local command_value
  command_value="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')"
  if [[ "$command_value" =~ ^[[:space:]]*echo([[:space:]]|$) ]]; then
    return 0
  fi
  if printf '%s' "$command_value" | grep -Eq '<[^>]+>'; then
    return 0
  fi
  if [[ "$command_value" =~ (^|[^a-z0-9_])(todo|tbd|placeholder|changeme|change_me|replace_me|example|dummy|sample|fixme)([^a-z0-9_]|$) ]]; then
    return 0
  fi
  return 1
}

if [[ ! -d "$runner_dir" ]]; then
  if [[ "$strict_mode" -eq 1 ]]; then
    execution_status="failed"
    error_message="missing runner directory: ${runner_dir}"
  else
    execution_status="skipped"
    error_message="runner directory not found; installer pipeline skipped"
  fi
elif [[ -n "$installer_command" ]]; then
  export PENJAR_WINDOWS_RUNNER_DIR="$runner_dir"
  export PENJAR_WINDOWS_INSTALLER_OUTPUT_PATH="$installer_output_path"
  if is_placeholder_command "$installer_command"; then
    command_placeholder_status="detected"
    if [[ "$strict_mode" -eq 1 ]]; then
      execution_status="failed"
      error_message="installer command appears to be a placeholder in strict mode"
    else
      execution_status="simulated"
      error_message="installer command appears to be a placeholder; execution skipped"
    fi
  elif bash -lc "$installer_command"; then
    command_placeholder_status="clear"
    execution_status="executed"
  else
    command_placeholder_status="clear"
    execution_status="failed"
    error_message="installer command failed"
  fi
elif [[ "$strict_mode" -eq 1 ]]; then
  execution_status="failed"
  error_message="installer command missing in strict mode"
fi

{
  echo "# Windows Installer Pipeline Report"
  echo
  echo "- Generated at (UTC): $timestamp"
  echo "- Strict mode: $strict_mode"
  echo "- Build mode: $build_mode"
  echo "- Runner directory: $runner_dir"
  echo "- Installer output path: $installer_output_path"
  echo "- Installer command configured: $([[ -n "$installer_command" ]] && echo yes || echo no)"
  echo "- Installer command placeholder status: $command_placeholder_status"
  echo "- Execution status: $execution_status"
  if [[ -n "$error_message" ]]; then
    echo "- Error: $error_message"
  fi
} > "$report_file"

if [[ "$strict_mode" -eq 1 && "$execution_status" == "failed" ]]; then
  echo "[windows-installer-pipeline] strict mode failed. report: $report_file" >&2
  exit 1
fi

if [[ "$execution_status" == "failed" ]]; then
  echo "[windows-installer-pipeline] warning: pipeline failed. report: $report_file"
  exit 0
fi

if [[ "$execution_status" == "skipped" ]]; then
  echo "[windows-installer-pipeline] warning: pipeline skipped. report: $report_file"
  exit 0
fi

if [[ "$command_placeholder_status" == "detected" ]]; then
  echo "[windows-installer-pipeline] warning: placeholder installer command detected. report: $report_file"
  exit 0
fi

echo "[windows-installer-pipeline] completed. report: $report_file"
