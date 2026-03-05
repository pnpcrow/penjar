#!/usr/bin/env bash
set -eo pipefail

strict_input="${1:-${STRICT_SIGNING:-0}}"
report_file="${2:-release/reports/signing_readiness_report.md}"

strict_mode=0
case "$(printf '%s' "$strict_input" | tr '[:upper:]' '[:lower:]')" in
  1|true|yes|strict) strict_mode=1 ;;
esac

mkdir -p "$(dirname "$report_file")"
timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

missing_count=0

write_row() {
  local requirement="$1"
  local env_name="$2"
  local value="${!env_name:-}"
  local status="present"
  if [[ -z "$value" ]]; then
    status="missing"
    missing_count=$((missing_count + 1))
  fi

  printf '| %s | `%s` | %s |\n' "$requirement" "$env_name" "$status" >> "$report_file"
}

{
  echo "# Desktop Signing Readiness Report"
  echo
  echo "- Generated at (UTC): $timestamp"
  echo "- Strict mode: $strict_mode"
  echo
  echo "| Requirement | Environment Variable | Status |"
  echo "|---|---|---|"
} > "$report_file"

write_row "macOS signing identity" "PENJAR_MACOS_SIGN_IDENTITY"
write_row "macOS team id" "PENJAR_MACOS_TEAM_ID"
write_row "macOS notary profile" "PENJAR_MACOS_NOTARY_PROFILE"
write_row "Windows signing cert path" "PENJAR_WINDOWS_CERT_PATH"
write_row "Windows signing cert password" "PENJAR_WINDOWS_CERT_PASSWORD"

{
  echo
  echo "- Missing requirement count: $missing_count"
} >> "$report_file"

if [[ "$missing_count" -gt 0 ]]; then
  if [[ "$strict_mode" -eq 1 ]]; then
    echo "[signing-readiness] failed with $missing_count missing requirement(s). report: $report_file" >&2
    exit 1
  fi
  echo "[signing-readiness] warning: $missing_count requirement(s) missing. report: $report_file"
  exit 0
fi

echo "[signing-readiness] all required signing variables are present. report: $report_file"
