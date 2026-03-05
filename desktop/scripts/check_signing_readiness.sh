#!/usr/bin/env bash
set -eo pipefail

strict_input="${1:-${STRICT_SIGNING:-0}}"
report_file="${2:-release/reports/signing_readiness_report.md}"
strict_command_hooks_input="${3:-${STRICT_SIGNING_COMMAND_HOOKS:-0}}"
strict_placeholders_input="${4:-${STRICT_SIGNING_PLACEHOLDERS:-0}}"

strict_mode=0
case "$(printf '%s' "$strict_input" | tr '[:upper:]' '[:lower:]')" in
  1|true|yes|strict) strict_mode=1 ;;
esac

strict_command_hooks_mode=0
case "$(printf '%s' "$strict_command_hooks_input" | tr '[:upper:]' '[:lower:]')" in
  1|true|yes|strict) strict_command_hooks_mode=1 ;;
esac

strict_placeholders_mode=0
case "$(printf '%s' "$strict_placeholders_input" | tr '[:upper:]' '[:lower:]')" in
  1|true|yes|strict) strict_placeholders_mode=1 ;;
esac

mkdir -p "$(dirname "$report_file")"
timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

missing_required_count=0
missing_command_hook_count=0
placeholder_required_count=0
placeholder_command_hook_count=0

is_placeholder_value() {
  local value="$1"
  local lowered
  lowered="$(printf '%s' "$value" | tr '[:upper:]' '[:lower:]')"

  if [[ "$lowered" =~ ^echo($|[[:space:]]) ]]; then
    return 0
  fi

  if [[ "$lowered" =~ ^\<.*\>$ ]]; then
    return 0
  fi

  if [[ "$lowered" =~ (changeme|change_me|replace_me|replace-this|replace_this|todo|tbd|placeholder|dummy|sample|example) ]]; then
    return 0
  fi

  return 1
}

write_row() {
  local requirement="$1"
  local env_name="$2"
  local category="$3"
  local value="${!env_name:-}"
  local status="present"
  if [[ -z "$value" ]]; then
    status="missing"
    if [[ "$category" == "required" ]]; then
      missing_required_count=$((missing_required_count + 1))
    elif [[ "$category" == "command-hook" ]]; then
      missing_command_hook_count=$((missing_command_hook_count + 1))
    fi
  elif is_placeholder_value "$value"; then
    status="placeholder"
    if [[ "$category" == "required" ]]; then
      placeholder_required_count=$((placeholder_required_count + 1))
    elif [[ "$category" == "command-hook" ]]; then
      placeholder_command_hook_count=$((placeholder_command_hook_count + 1))
    fi
  fi

  printf '| %s | `%s` | %s | %s |\n' "$requirement" "$env_name" "$category" "$status" >> "$report_file"
}

{
  echo "# Desktop Signing Readiness Report"
  echo
  echo "- Generated at (UTC): $timestamp"
  echo "- Strict mode: $strict_mode"
  echo "- Strict command hooks mode: $strict_command_hooks_mode"
  echo "- Strict placeholder mode: $strict_placeholders_mode"
  echo
  echo "| Requirement | Environment Variable | Category | Status |"
  echo "|---|---|---|---|"
} > "$report_file"

write_row "macOS signing identity" "PENJAR_MACOS_SIGN_IDENTITY" "required"
write_row "macOS team id" "PENJAR_MACOS_TEAM_ID" "required"
write_row "macOS notary profile" "PENJAR_MACOS_NOTARY_PROFILE" "required"
write_row "Windows signing cert path" "PENJAR_WINDOWS_CERT_PATH" "required"
write_row "Windows signing cert password" "PENJAR_WINDOWS_CERT_PASSWORD" "required"
write_row "macOS sign command hook" "PENJAR_MACOS_SIGN_COMMAND" "command-hook"
write_row "macOS notarize command hook" "PENJAR_MACOS_NOTARIZE_COMMAND" "command-hook"
write_row "Windows sign command hook" "PENJAR_WINDOWS_SIGN_COMMAND" "command-hook"
write_row "Windows installer command hook" "PENJAR_WINDOWS_INSTALLER_COMMAND" "command-hook"
write_row "macOS sign verify command hook" "PENJAR_MACOS_SIGN_VERIFY_COMMAND" "command-hook"
write_row "Windows sign verify command hook" "PENJAR_WINDOWS_SIGN_VERIFY_COMMAND" "command-hook"
write_row "Windows installer provenance command hook" "PENJAR_WINDOWS_INSTALLER_PROVENANCE_COMMAND" "command-hook"

{
  echo
  echo "- Missing required count: $missing_required_count"
  echo "- Missing command-hook count: $missing_command_hook_count"
  echo "- Placeholder required count: $placeholder_required_count"
  echo "- Placeholder command-hook count: $placeholder_command_hook_count"
} >> "$report_file"

if [[ "$missing_required_count" -gt 0 && "$strict_mode" -eq 1 ]]; then
  echo "[signing-readiness] failed with $missing_required_count missing required variable(s). report: $report_file" >&2
  exit 1
fi

if [[ "$missing_command_hook_count" -gt 0 && "$strict_command_hooks_mode" -eq 1 ]]; then
  echo "[signing-readiness] failed with $missing_command_hook_count missing command hook(s). report: $report_file" >&2
  exit 1
fi

placeholder_total=$((placeholder_required_count + placeholder_command_hook_count))
if [[ "$placeholder_total" -gt 0 && "$strict_placeholders_mode" -eq 1 ]]; then
  echo "[signing-readiness] failed with $placeholder_total placeholder value(s). report: $report_file" >&2
  exit 1
fi

missing_total=$((missing_required_count + missing_command_hook_count))
if [[ "$missing_total" -gt 0 || "$placeholder_total" -gt 0 ]]; then
  echo "[signing-readiness] warning: missing=$missing_total placeholder=$placeholder_total. report: $report_file"
  exit 0
fi

echo "[signing-readiness] all required signing variables and command hooks are present. report: $report_file"
