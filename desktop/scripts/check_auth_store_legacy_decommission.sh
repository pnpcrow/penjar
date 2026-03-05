#!/usr/bin/env bash
set -eo pipefail

strict_input="${1:-${STRICT_AUTH_STORE_LEGACY_DECOMMISSION:-0}}"
report_file="${2:-release/reports/auth_store_legacy_decommission_report.md}"

to_bool() {
  case "$(printf '%s' "${1:-0}" | tr '[:upper:]' '[:lower:]')" in
    1|true|yes|strict|on|enabled) echo 1 ;;
    *) echo 0 ;;
  esac
}

strict_mode="$(to_bool "$strict_input")"
mirror_legacy_mode="$(to_bool "${PENJAR_DESKTOP_REMOTE_STUB_AUTH_SECURE_STORAGE_MIRROR_LEGACY:-0}")"

legacy_path="${PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_PATH:-}"
legacy_load_command="${PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_LOAD_COMMAND:-}"
legacy_save_command="${PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_SAVE_COMMAND:-}"

timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
mkdir -p "$(dirname "$report_file")"

required_count=0
warning_count=0
required_notes=""
warning_notes=""

append_note() {
  local level="$1"
  local message="$2"
  if [[ "$level" == "required" ]]; then
    required_count=$((required_count + 1))
    if [[ -z "$required_notes" ]]; then
      required_notes="$message"
    else
      required_notes="${required_notes}"$'\n'"$message"
    fi
  else
    warning_count=$((warning_count + 1))
    if [[ -z "$warning_notes" ]]; then
      warning_notes="$message"
    else
      warning_notes="${warning_notes}"$'\n'"$message"
    fi
  fi
}

if [[ "$strict_mode" -eq 1 && "$mirror_legacy_mode" -eq 1 ]]; then
  append_note "required" \
    "STRICT_AUTH_STORE_LEGACY_DECOMMISSION=1 rejects PENJAR_DESKTOP_REMOTE_STUB_AUTH_SECURE_STORAGE_MIRROR_LEGACY=1."
fi

if [[ "$strict_mode" -eq 1 && -n "$legacy_path" ]]; then
  append_note "required" \
    "STRICT_AUTH_STORE_LEGACY_DECOMMISSION=1 rejects PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_PATH."
fi

if [[ "$strict_mode" -eq 1 && -n "$legacy_load_command" ]]; then
  append_note "required" \
    "STRICT_AUTH_STORE_LEGACY_DECOMMISSION=1 rejects PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_LOAD_COMMAND."
fi

if [[ "$strict_mode" -eq 1 && -n "$legacy_save_command" ]]; then
  append_note "required" \
    "STRICT_AUTH_STORE_LEGACY_DECOMMISSION=1 rejects PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_SAVE_COMMAND."
fi

if [[ "$strict_mode" -eq 0 && "$mirror_legacy_mode" -eq 1 ]]; then
  append_note "warning" \
    "Legacy mirror mode is enabled; keep retirement timeline explicit."
fi

if [[ "$strict_mode" -eq 0 && ( -n "$legacy_path" || -n "$legacy_load_command" || -n "$legacy_save_command" ) ]]; then
  append_note "warning" \
    "Legacy auth-store inputs are still configured; decommission check is advisory in non-strict mode."
fi

status="passed"
if [[ "$required_count" -gt 0 ]]; then
  status="failed"
elif [[ "$warning_count" -gt 0 ]]; then
  status="passed-with-warnings"
fi

{
  echo "# Auth Store Legacy Decommission Report"
  echo
  echo "- Generated at (UTC): $timestamp"
  echo "- Strict mode: $strict_mode"
  echo "- Status: $status"
  echo
  echo "## Effective inputs"
  echo "- PENJAR_DESKTOP_REMOTE_STUB_AUTH_SECURE_STORAGE_MIRROR_LEGACY: $mirror_legacy_mode"
  echo "- PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_PATH configured: $([[ -n "$legacy_path" ]] && echo yes || echo no)"
  echo "- PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_LOAD_COMMAND configured: $([[ -n "$legacy_load_command" ]] && echo yes || echo no)"
  echo "- PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_SAVE_COMMAND configured: $([[ -n "$legacy_save_command" ]] && echo yes || echo no)"
  echo
  echo "## Required checks"
  if [[ -n "$required_notes" ]]; then
    while IFS= read -r line; do
      echo "- $line"
    done <<< "$required_notes"
  else
    echo "- none"
  fi
  echo
  echo "## Advisory checks"
  if [[ -n "$warning_notes" ]]; then
    while IFS= read -r line; do
      echo "- $line"
    done <<< "$warning_notes"
  else
    echo "- none"
  fi
} > "$report_file"

if [[ "$required_count" -gt 0 ]]; then
  echo "[auth-store-legacy-decommission] failed. report: $report_file" >&2
  exit 1
fi

if [[ "$warning_count" -gt 0 ]]; then
  echo "[auth-store-legacy-decommission] warning: advisory checks found. report: $report_file"
  exit 0
fi

echo "[auth-store-legacy-decommission] passed. report: $report_file"
