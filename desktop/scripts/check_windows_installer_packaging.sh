#!/usr/bin/env bash
set -eo pipefail

strict_input="${1:-0}"
build_mode="${2:-release}"
report_file="${3:-release/reports/windows_installer_packaging_report.md}"
strict_naming_input="${STRICT_WINDOWS_INSTALLER_NAMING:-0}"
name_pattern="${PENJAR_WINDOWS_INSTALLER_NAME_PATTERN:-^PenjarInstaller\.(msi|exe)$}"

strict_mode=0
case "$(printf '%s' "$strict_input" | tr '[:upper:]' '[:lower:]')" in
  1|true|yes|strict) strict_mode=1 ;;
esac

strict_naming_mode=0
case "$(printf '%s' "$strict_naming_input" | tr '[:upper:]' '[:lower:]')" in
  1|true|yes|strict) strict_naming_mode=1 ;;
esac

mode_dir=""
case "$build_mode" in
  release) mode_dir="Release" ;;
  debug) mode_dir="Debug" ;;
  *)
    echo "[windows-installer-check] invalid build mode: $build_mode (allowed: release|debug)" >&2
    exit 1
    ;;
esac

default_installer_path="build/windows/x64/runner/${mode_dir}/installer/PenjarInstaller.msi"
installer_path="${PENJAR_WINDOWS_INSTALLER_PATH:-$default_installer_path}"

status="missing"
error_message=""
installer_name="$(basename "$installer_path")"
naming_status="skipped"
timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

if [[ -f "$installer_path" ]]; then
  case "$installer_path" in
    *.msi|*.exe)
      status="present"
      if [[ -n "$name_pattern" ]]; then
        if [[ "$installer_name" =~ $name_pattern ]]; then
          naming_status="passed"
        else
          naming_status="failed"
          status="invalid-name"
          error_message="installer name does not match policy pattern"
        fi
      else
        naming_status="skipped"
      fi
      ;;
    *)
      status="invalid-extension"
      error_message="installer extension must be .msi or .exe"
      ;;
  esac
fi

strict_naming_failed=0
if [[ "$strict_naming_mode" -eq 1 && "$naming_status" != "passed" ]]; then
  strict_naming_failed=1
  if [[ -z "$error_message" ]]; then
    error_message="strict naming mode requires naming policy status=passed"
  fi
fi

mkdir -p "$(dirname "$report_file")"
{
  echo "# Windows Installer Packaging Report"
  echo
  echo "- Generated at (UTC): $timestamp"
  echo "- Strict mode: $strict_mode"
  echo "- Strict naming mode: $strict_naming_mode"
  echo "- Build mode: $build_mode"
  echo "- Installer path: $installer_path"
  echo "- Installer name: $installer_name"
  echo "- Naming policy pattern: $name_pattern"
  echo "- Naming policy status: $naming_status"
  echo "- Status: $status"
  if [[ -n "$error_message" ]]; then
    echo "- Error: $error_message"
  fi
} > "$report_file"

if [[ "$strict_naming_failed" -eq 1 ]]; then
  echo "[windows-installer-check] strict naming mode failed. report: $report_file" >&2
  exit 1
fi

if [[ "$strict_mode" -eq 1 ]]; then
  if [[ "$status" != "present" ]]; then
    echo "[windows-installer-check] strict mode failed. report: $report_file" >&2
    exit 1
  fi
fi

if [[ "$status" != "present" ]]; then
  echo "[windows-installer-check] warning: installer artifact not validated as present. report: $report_file"
  exit 0
fi

echo "[windows-installer-check] passed. report: $report_file"
