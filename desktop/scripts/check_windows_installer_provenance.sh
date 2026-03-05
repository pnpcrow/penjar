#!/usr/bin/env bash
set -eo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/placeholder_hygiene.sh
source "${script_dir}/lib/placeholder_hygiene.sh"

strict_input="${1:-0}"
build_mode="${2:-release}"
report_file="${3:-release/reports/windows_installer_provenance_report.md}"

strict_mode=0
case "$(printf '%s' "$strict_input" | tr '[:upper:]' '[:lower:]')" in
  1|true|yes|strict) strict_mode=1 ;;
esac

mode_dir=""
case "$build_mode" in
  release) mode_dir="Release" ;;
  debug) mode_dir="Debug" ;;
  *)
    echo "[windows-installer-provenance] invalid build mode: $build_mode (allowed: release|debug)" >&2
    exit 1
    ;;
esac

default_installer_path="build/windows/x64/runner/${mode_dir}/installer/PenjarInstaller.msi"
installer_path="${PENJAR_WINDOWS_INSTALLER_PATH:-$default_installer_path}"
provenance_command="${PENJAR_WINDOWS_INSTALLER_PROVENANCE_COMMAND:-}"

timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
mkdir -p "$(dirname "$report_file")"

artifact_status="missing"
hash_status="not-computed"
provenance_status="missing"
overall_status="warning"
sha256_value=""
error_message=""
provenance_command_placeholder_status="not-configured"

if [[ -f "$installer_path" ]]; then
  artifact_status="present"

  hash_tool=""
  if command -v shasum >/dev/null 2>&1; then
    hash_tool="shasum"
  elif command -v sha256sum >/dev/null 2>&1; then
    hash_tool="sha256sum"
  fi

  if [[ -n "$hash_tool" ]]; then
    if [[ "$hash_tool" == "shasum" ]]; then
      sha256_value="$(shasum -a 256 "$installer_path" | awk '{print $1}')"
    else
      sha256_value="$(sha256sum "$installer_path" | awk '{print $1}')"
    fi
    if [[ -n "$sha256_value" ]]; then
      hash_status="computed"
    else
      hash_status="failed"
      error_message="sha256 hash could not be computed"
    fi
  else
    hash_status="failed"
    error_message="no sha256 hash tool found (shasum/sha256sum)"
  fi

  if [[ -n "$provenance_command" ]]; then
    if is_placeholder_command "$provenance_command"; then
      provenance_command_placeholder_status="detected"
      provenance_status="failed"
      if [[ -z "$error_message" ]]; then
        error_message="provenance command appears to be a placeholder"
      fi
    else
      provenance_command_placeholder_status="clear"
      export PENJAR_WINDOWS_INSTALLER_PATH="$installer_path"
      if bash -lc "$provenance_command"; then
        provenance_status="executed"
      else
        provenance_status="failed"
        if [[ -z "$error_message" ]]; then
          error_message="provenance command failed"
        fi
      fi
    fi
  else
    provenance_command_placeholder_status="not-configured"
  fi
fi

if [[ "$artifact_status" == "present" && "$hash_status" == "computed" ]]; then
  if [[ "$provenance_status" == "executed" ]]; then
    overall_status="validated"
  elif [[ "$provenance_status" == "missing" ]]; then
    overall_status="warning"
    if [[ -z "$error_message" ]]; then
      error_message="provenance command is not configured"
    fi
  elif [[ "$provenance_status" == "failed" ]]; then
    overall_status="warning"
    if [[ -z "$error_message" ]]; then
      error_message="provenance command validation failed"
    fi
  fi
fi

if [[ "$strict_mode" -eq 1 ]]; then
  if [[ "$artifact_status" != "present" ]]; then
    overall_status="failed"
    if [[ -z "$error_message" ]]; then
      error_message="installer artifact is missing"
    fi
  elif [[ "$hash_status" != "computed" ]]; then
    overall_status="failed"
  elif [[ -z "$provenance_command" ]]; then
    overall_status="failed"
    provenance_status="missing"
    if [[ -z "$error_message" ]]; then
      error_message="provenance command missing in strict mode"
    fi
  elif [[ "$provenance_status" == "failed" ]]; then
    overall_status="failed"
    if [[ "$provenance_command_placeholder_status" == "detected" && -z "$error_message" ]]; then
      error_message="provenance command appears to be a placeholder in strict mode"
    fi
  fi
fi

{
  echo "# Windows Installer Provenance Report"
  echo
  echo "- Generated at (UTC): $timestamp"
  echo "- Strict mode: $strict_mode"
  echo "- Build mode: $build_mode"
  echo "- Installer path: $installer_path"
  echo "- Artifact status: $artifact_status"
  echo "- SHA256 status: $hash_status"
  echo "- SHA256: ${sha256_value:-n/a}"
  echo "- Provenance command configured: $([[ -n "$provenance_command" ]] && echo yes || echo no)"
  echo "- Provenance command placeholder status: $provenance_command_placeholder_status"
  echo "- Provenance command status: $provenance_status"
  echo "- Overall status: $overall_status"
  if [[ -n "$error_message" ]]; then
    echo "- Error: $error_message"
  fi
} > "$report_file"

if [[ "$overall_status" == "failed" ]]; then
  echo "[windows-installer-provenance] failed. report: $report_file" >&2
  exit 1
fi

if [[ "$overall_status" != "validated" ]]; then
  echo "[windows-installer-provenance] warning: provenance not fully validated. report: $report_file"
  exit 0
fi

echo "[windows-installer-provenance] passed. report: $report_file"
