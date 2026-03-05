#!/usr/bin/env bash
set -eo pipefail

report_file="${1:-}"
rc_id="${2:-RC-DRAFT}"
ci_run_url="${3:-${CI_RUN_URL:-TBD}}"
execution_log_ref="${4:-WS-D-43}"
decision="${5:-blocked (unsigned smoke baseline)}"
output_path="${6:-}"

if [[ -z "$report_file" ]]; then
  echo "usage: $0 <report-file> [rc-id] [ci-run-url] [execution-log-ref] [decision] [output-path]" >&2
  exit 1
fi

if [[ ! -f "$report_file" ]]; then
  echo "[release-evidence-row] missing report file: $report_file" >&2
  exit 1
fi

python_bin=""
if command -v python3 >/dev/null 2>&1; then
  python_bin="python3"
elif command -v python >/dev/null 2>&1; then
  python_bin="python"
else
  echo "[release-evidence-row] python runtime is required (python3 or python)." >&2
  exit 1
fi

report_fields="$("$python_bin" - "$report_file" <<'PY'
import json
import sys

report_path = sys.argv[1]
with open(report_path, "r", encoding="utf-8") as fh:
    data = json.load(fh)

required = [
    "platform",
    "version",
    "artifactArchivePath",
    "artifactArchiveSha256",
]
for key in required:
    value = data.get(key)
    if not isinstance(value, str) or not value.strip():
        raise SystemExit(f"[release-evidence-row] invalid or missing field '{key}' in {report_path}")

platform = data["platform"].strip()
platform_label = "macOS" if platform == "macos" else "Windows" if platform == "windows" else platform

artifact_manifest = f"{data['artifactArchivePath']} (sha256: {data['artifactArchiveSha256']})"
installer_update_report = report_path

print(platform)
print(platform_label)
print(data["version"].strip())
print(artifact_manifest)
print(installer_update_report)
PY
)"

platform="$(printf '%s\n' "$report_fields" | sed -n '1p')"
platform_label="$(printf '%s\n' "$report_fields" | sed -n '2p')"
version="$(printf '%s\n' "$report_fields" | sed -n '3p')"
artifact_manifest="$(printf '%s\n' "$report_fields" | sed -n '4p')"
installer_update_report="$(printf '%s\n' "$report_fields" | sed -n '5p')"

if [[ -z "$output_path" ]]; then
  output_path="release/reports/release_evidence_row_${platform}.md"
fi

escape_table_cell() {
  printf '%s' "$1" | sed 's/|/\\|/g'
}

row="| $(escape_table_cell "$rc_id") | $(escape_table_cell "$version") | $(escape_table_cell "$platform_label") | $(escape_table_cell "$artifact_manifest") | $(escape_table_cell "$installer_update_report") | $(escape_table_cell "$ci_run_url") | $(escape_table_cell "$execution_log_ref") | $(escape_table_cell "$decision") |"

mkdir -p "$(dirname "$output_path")"
printf '%s\n' "$row" > "$output_path"

echo "[release-evidence-row] generated: $output_path"
