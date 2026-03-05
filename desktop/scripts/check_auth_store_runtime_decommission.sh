#!/usr/bin/env bash
set -eo pipefail

report_file="${1:-release/reports/auth_store_runtime_decommission_report.md}"
target_file="${2:-lib/contracts/desktop_contract_bundle.dart}"
timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

mkdir -p "$(dirname "$report_file")"

legacy_tokens=(
  "PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_PATH"
  "PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_LOAD_COMMAND"
  "PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_SAVE_COMMAND"
  "PENJAR_DESKTOP_REMOTE_STUB_AUTH_SECURE_STORAGE_MIRROR_LEGACY"
  "PENJAR_DESKTOP_REMOTE_STUB_AUTH_LEGACY_RETIREMENT_STRICT"
)

token_rows=""
failure_count=0

append_row() {
  local token="$1"
  local result="$2"
  local summary="$3"
  token_rows+="| \`${token}\` | ${result} | ${summary} |"$'\n'
}

if [[ ! -f "$target_file" ]]; then
  {
    echo "# Auth Store Runtime Decommission Report"
    echo
    echo "- Generated at (UTC): $timestamp"
    echo "- Target file: $target_file"
    echo "- Status: failed"
    echo
    echo "## Error"
    echo "- target file not found."
  } > "$report_file"
  echo "[auth-store-runtime-decommission] failed. report: $report_file" >&2
  exit 1
fi

for token in "${legacy_tokens[@]}"; do
  matches="$(grep -nF "$token" "$target_file" || true)"
  if [[ -n "$matches" ]]; then
    failure_count=$((failure_count + 1))
    summary="$(printf '%s' "$matches" | tr '\n' ';' | sed 's/;$//')"
    append_row "$token" "found" "$summary"
  else
    append_row "$token" "clear" "none"
  fi
done

status="passed"
if [[ "$failure_count" -gt 0 ]]; then
  status="failed"
fi

{
  echo "# Auth Store Runtime Decommission Report"
  echo
  echo "- Generated at (UTC): $timestamp"
  echo "- Target file: $target_file"
  echo "- Legacy token count: ${#legacy_tokens[@]}"
  echo "- Matches found: $failure_count"
  echo "- Status: $status"
  echo
  echo "| Token | Result | Summary |"
  echo "|---|---|---|"
  if [[ -n "$token_rows" ]]; then
    printf '%s' "$token_rows"
  else
    echo "| none | n/a | no tokens checked |"
  fi
} > "$report_file"

if [[ "$failure_count" -gt 0 ]]; then
  echo "[auth-store-runtime-decommission] failed. report: $report_file" >&2
  exit 1
fi

echo "[auth-store-runtime-decommission] passed. report: $report_file"
