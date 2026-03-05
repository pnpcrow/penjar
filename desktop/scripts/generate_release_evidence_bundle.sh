#!/usr/bin/env bash
set -eo pipefail

platform="${1:-}"
output_path="${2:-}"

if [[ -z "$platform" ]]; then
  echo "usage: $0 <macos|windows> [output-path]" >&2
  exit 1
fi

case "$platform" in
  macos|windows) ;;
  *)
    echo "[release-evidence-bundle] invalid platform: $platform (allowed: macos|windows)" >&2
    exit 1
    ;;
esac

if [[ -z "$output_path" ]]; then
  output_path="release/reports/release_evidence_bundle_${platform}.md"
fi

installer_report="release/reports/installer_update_report_${platform}.json"
signing_report="release/reports/signing_report_${platform}.md"
signing_provenance_report="release/reports/signing_artifact_provenance_${platform}.md"
gate_policy_report="release/reports/release_smoke_gate_policy_report.md"
windows_packaging_report="release/reports/windows_installer_packaging_report.md"
windows_pipeline_report="release/reports/windows_installer_pipeline_report.md"
windows_provenance_report="release/reports/windows_installer_provenance_report.md"

python_bin=""
if command -v python3 >/dev/null 2>&1; then
  python_bin="python3"
elif command -v python >/dev/null 2>&1; then
  python_bin="python"
fi

extract_json_field() {
  local file="$1"
  local field="$2"
  if [[ ! -f "$file" || -z "$python_bin" ]]; then
    return 0
  fi
  "$python_bin" - "$file" "$field" <<'PY'
import json
import sys

path = sys.argv[1]
field = sys.argv[2]

with open(path, "r", encoding="utf-8") as fh:
    data = json.load(fh)

value = data.get(field, "")
if isinstance(value, str):
    print(value)
PY
}

extract_md_field() {
  local file="$1"
  local label="$2"
  if [[ ! -f "$file" ]]; then
    return 0
  fi
  local line
  line="$(grep -E "^- ${label}: " "$file" | head -n 1 || true)"
  if [[ -z "$line" ]]; then
    return 0
  fi
  printf '%s\n' "${line#- ${label}: }"
}

extract_signing_stage() {
  local file="$1"
  local stage="$2"
  if [[ ! -f "$file" ]]; then
    return 0
  fi
  local line
  line="$(grep -E "^\\| ${stage} \\| " "$file" | head -n 1 || true)"
  if [[ -z "$line" ]]; then
    return 0
  fi
  printf '%s\n' "$line" | awk -F'|' '{gsub(/^[ \t]+|[ \t]+$/, "", $3); print $3}'
}

timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
version="$(extract_json_field "$installer_report" "version")"
artifact_archive="$(extract_json_field "$installer_report" "artifactArchivePath")"
artifact_sha256="$(extract_json_field "$installer_report" "artifactArchiveSha256")"

signing_stage_status="$(extract_signing_stage "$signing_report" "signing")"
notarization_stage_status="$(extract_signing_stage "$signing_report" "notarization")"
signing_provenance_status="$(extract_md_field "$signing_provenance_report" "Overall status")"
gate_policy_status="$(extract_md_field "$gate_policy_report" "Status")"
windows_packaging_status="$(extract_md_field "$windows_packaging_report" "Status")"
windows_pipeline_status="$(extract_md_field "$windows_pipeline_report" "Execution status")"
windows_provenance_status="$(extract_md_field "$windows_provenance_report" "Overall status")"

mkdir -p "$(dirname "$output_path")"

{
  echo "# Release Evidence Bundle (${platform})"
  echo
  echo "- Generated at (UTC): $timestamp"
  echo "- Installer report: $([[ -f "$installer_report" ]] && echo present || echo missing)"
  echo "- Version: ${version:-n/a}"
  if [[ -n "$artifact_archive" || -n "$artifact_sha256" ]]; then
    echo "- Artifact archive: ${artifact_archive:-n/a}"
    echo "- Artifact SHA256: ${artifact_sha256:-n/a}"
  fi
  echo
  echo "## Report status summary"
  echo
  echo "| Report | Status |"
  echo "|---|---|"
  echo "| signing pipeline (${platform}) | ${signing_stage_status:-missing} |"
  if [[ "$platform" == "macos" ]]; then
    echo "| notarization (${platform}) | ${notarization_stage_status:-missing} |"
  fi
  echo "| signing provenance (${platform}) | ${signing_provenance_status:-missing} |"
  echo "| release smoke gate policy | ${gate_policy_status:-missing} |"
  if [[ "$platform" == "windows" ]]; then
    echo "| windows installer packaging | ${windows_packaging_status:-missing} |"
    echo "| windows installer pipeline | ${windows_pipeline_status:-missing} |"
    echo "| windows installer provenance | ${windows_provenance_status:-missing} |"
  fi
} > "$output_path"

echo "[release-evidence-bundle] generated: $output_path"
