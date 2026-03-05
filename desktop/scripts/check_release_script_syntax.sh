#!/usr/bin/env bash
set -eo pipefail

report_file="${1:-release/reports/release_script_syntax_report.md}"
scripts_dir="${2:-scripts}"

if [[ ! -d "$scripts_dir" ]]; then
  echo "[release-script-syntax] scripts directory not found: $scripts_dir" >&2
  exit 1
fi

timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
mkdir -p "$(dirname "$report_file")"

checked_count=0
failed_count=0
checked_list=""
failed_list=""

append_line() {
  local current="$1"
  local line="$2"
  if [[ -z "$current" ]]; then
    printf '%s' "$line"
  else
    printf '%s\n%s' "$current" "$line"
  fi
}

while IFS= read -r script_path; do
  [[ -z "$script_path" ]] && continue
  checked_count=$((checked_count + 1))
  checked_list="$(append_line "$checked_list" "$script_path")"
  if ! bash -n "$script_path"; then
    failed_count=$((failed_count + 1))
    failed_list="$(append_line "$failed_list" "$script_path")"
  fi
done < <(find "$scripts_dir" -maxdepth 1 -type f -name '*.sh' | sort)

status="passed"
if [[ "$failed_count" -gt 0 ]]; then
  status="failed"
fi

{
  echo "# Release Script Syntax Report"
  echo
  echo "- Generated at (UTC): $timestamp"
  echo "- Scripts directory: $scripts_dir"
  echo "- Checked script count: $checked_count"
  echo "- Failed script count: $failed_count"
  echo "- Status: $status"
  echo
  echo "## Checked scripts"
  if [[ -n "$checked_list" ]]; then
    while IFS= read -r line; do
      echo "- $line"
    done <<< "$checked_list"
  else
    echo "- none"
  fi
  echo
  echo "## Failed scripts"
  if [[ -n "$failed_list" ]]; then
    while IFS= read -r line; do
      echo "- $line"
    done <<< "$failed_list"
  else
    echo "- none"
  fi
} > "$report_file"

if [[ "$failed_count" -gt 0 ]]; then
  echo "[release-script-syntax] failed. report: $report_file" >&2
  exit 1
fi

echo "[release-script-syntax] passed. report: $report_file"
