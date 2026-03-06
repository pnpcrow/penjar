#!/usr/bin/env bash
set -eo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/placeholder_hygiene.sh
source "${script_dir}/lib/placeholder_hygiene.sh"

strict_input="${1:-0}"
build_mode="${2:-release}"
report_file="${3:-release/reports/windows_installer_pipeline_report.md}"
strict_protocol_input="${STRICT_WINDOWS_PROTOCOL_REGISTRATION:-0}"

strict_mode=0
case "$(printf '%s' "$strict_input" | tr '[:upper:]' '[:lower:]')" in
  1|true|yes|strict) strict_mode=1 ;;
esac

strict_protocol_mode=0
case "$(printf '%s' "$strict_protocol_input" | tr '[:upper:]' '[:lower:]')" in
  1|true|yes|strict) strict_protocol_mode=1 ;;
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
runner_exists=0
if [[ -d "$runner_dir" ]]; then
  runner_exists=1
fi
installer_output_path_default="${runner_dir}/installer/PenjarInstaller.msi"
installer_output_path="${PENJAR_WINDOWS_INSTALLER_PATH:-$installer_output_path_default}"
installer_command="${PENJAR_WINDOWS_INSTALLER_COMMAND:-}"
protocol_register_command="${PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND:-}"
protocol_scheme="${PENJAR_WINDOWS_PROTOCOL_SCHEME:-penjar}"
protocol_target_path_default="${runner_dir}/penjar_desktop.exe"
protocol_target_path="${PENJAR_WINDOWS_PROTOCOL_TARGET_PATH:-$protocol_target_path_default}"

timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
mkdir -p "$(dirname "$report_file")"

execution_status="simulated"
error_message=""
command_placeholder_status="not-configured"
protocol_execution_status="simulated"
protocol_error_message=""
protocol_placeholder_status="not-configured"

if [[ "$runner_exists" -eq 0 ]]; then
  if [[ "$strict_mode" -eq 1 ]]; then
    execution_status="failed"
    error_message="missing runner directory: ${runner_dir}"
  else
    execution_status="skipped"
    error_message="runner directory not found; installer pipeline skipped"
  fi
  if [[ "$strict_protocol_mode" -eq 1 ]]; then
    protocol_execution_status="failed"
    protocol_error_message="missing runner directory for strict protocol registration: ${runner_dir}"
  else
    protocol_execution_status="skipped"
    protocol_error_message="runner directory not found; protocol registration skipped"
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

# Preserve legacy protocol-stage behavior when installer command mutates runner artifacts.
if [[ "$runner_exists" -eq 1 && ! -d "$runner_dir" ]]; then
  runner_exists=0
fi

if [[ "$runner_exists" -eq 1 && -n "$protocol_register_command" ]]; then
  export PENJAR_WINDOWS_PROTOCOL_SCHEME="$protocol_scheme"
  export PENJAR_WINDOWS_PROTOCOL_TARGET_PATH="$protocol_target_path"
  if is_placeholder_command "$protocol_register_command"; then
    protocol_placeholder_status="detected"
    if [[ "$strict_mode" -eq 1 || "$strict_protocol_mode" -eq 1 ]]; then
      protocol_execution_status="failed"
      protocol_error_message="protocol register command appears to be a placeholder in strict mode"
    else
      protocol_execution_status="simulated"
      protocol_error_message="protocol register command appears to be a placeholder; execution skipped"
    fi
  elif bash -lc "$protocol_register_command"; then
    protocol_placeholder_status="clear"
    protocol_execution_status="executed"
  else
    protocol_placeholder_status="clear"
    protocol_execution_status="failed"
    protocol_error_message="protocol register command failed"
  fi
elif [[ "$runner_exists" -eq 1 && "$strict_protocol_mode" -eq 1 ]]; then
  protocol_execution_status="failed"
  protocol_error_message="protocol register command missing in strict protocol mode"
fi

{
  echo "# Windows Installer Pipeline Report"
  echo
  echo "- Generated at (UTC): $timestamp"
  echo "- Strict mode: $strict_mode"
  echo "- Strict protocol registration mode: $strict_protocol_mode"
  echo "- Build mode: $build_mode"
  echo "- Runner directory: $runner_dir"
  echo "- Installer output path: $installer_output_path"
  echo "- Installer command configured: $([[ -n "$installer_command" ]] && echo yes || echo no)"
  echo "- Installer command placeholder status: $command_placeholder_status"
  echo "- Execution status: $execution_status"
  if [[ -n "$error_message" ]]; then
    echo "- Error: $error_message"
  fi
  echo "- Protocol scheme: $protocol_scheme"
  echo "- Protocol target path: $protocol_target_path"
  echo "- Protocol register command configured: $([[ -n "$protocol_register_command" ]] && echo yes || echo no)"
  echo "- Protocol command placeholder status: $protocol_placeholder_status"
  echo "- Protocol registration status: $protocol_execution_status"
  if [[ -n "$protocol_error_message" ]]; then
    echo "- Protocol error: $protocol_error_message"
  fi
} > "$report_file"

if [[ "$strict_mode" -eq 1 ]]; then
  if [[ "$execution_status" == "failed" || "$protocol_execution_status" == "failed" ]]; then
    echo "[windows-installer-pipeline] strict mode failed. report: $report_file" >&2
    exit 1
  fi
elif [[ "$strict_protocol_mode" -eq 1 && "$protocol_execution_status" == "failed" ]]; then
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

if [[ "$protocol_execution_status" == "failed" ]]; then
  echo "[windows-installer-pipeline] warning: protocol registration failed. report: $report_file"
  exit 0
fi

if [[ "$protocol_placeholder_status" == "detected" ]]; then
  echo "[windows-installer-pipeline] warning: placeholder protocol command detected. report: $report_file"
  exit 0
fi

echo "[windows-installer-pipeline] completed. report: $report_file"
