#!/usr/bin/env bash
set -eo pipefail

report_file="${1:-release/reports/update_manifest_contract_report.md}"
source_manifest_file="${2:-release/update_manifest.example.json}"
timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

python_bin=""
if command -v python3 >/dev/null 2>&1; then
  python_bin="python3"
elif command -v python >/dev/null 2>&1; then
  python_bin="python"
else
  echo "[update-manifest-contract] python runtime is required (python3 or python)." >&2
  exit 1
fi

mkdir -p "$(dirname "$report_file")"

case_rows=""
failure_count=0
total_cases=0

append_case_row() {
  local case_name="$1"
  local expected="$2"
  local actual="$3"
  local report_assertion="$4"
  local result="$5"
  local summary="$6"
  case_rows+="| ${case_name} | ${expected} | ${actual} | ${report_assertion} | ${result} | ${summary} |"$'\n'
}

setup_baseline_case() {
  local target_manifest="$1"
  cp "$source_manifest_file" "$target_manifest"
}

setup_invalid_json_case() {
  local target_manifest="$1"
  cat > "$target_manifest" <<'EOF'
{
  "version": "0.0.0",
  "channel": "stable",
  "publishedAt": "2026-03-06T00:00:00Z",
  "macosArtifactUrl": "https://example.com/penjar/macos/Penjar-0.0.0.dmg"
EOF
}

setup_missing_required_field_case() {
  local target_manifest="$1"
  cp "$source_manifest_file" "$target_manifest"
  "$python_bin" - "$target_manifest" <<'PY'
import json
import pathlib
import sys

manifest_path = pathlib.Path(sys.argv[1])
data = json.loads(manifest_path.read_text(encoding="utf-8"))
data.pop("windowsArtifactUrl", None)
manifest_path.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
PY
}

setup_insecure_url_case() {
  local target_manifest="$1"
  cp "$source_manifest_file" "$target_manifest"
  "$python_bin" - "$target_manifest" <<'PY'
import json
import pathlib
import sys

manifest_path = pathlib.Path(sys.argv[1])
data = json.loads(manifest_path.read_text(encoding="utf-8"))
data["windowsArtifactUrl"] = "http://example.com/penjar/windows/Penjar-0.0.0.msi"
manifest_path.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
PY
}

setup_identical_platform_urls_case() {
  local target_manifest="$1"
  cp "$source_manifest_file" "$target_manifest"
  "$python_bin" - "$target_manifest" <<'PY'
import json
import pathlib
import sys

manifest_path = pathlib.Path(sys.argv[1])
data = json.loads(manifest_path.read_text(encoding="utf-8"))
data["windowsArtifactUrl"] = data.get("macosArtifactUrl", "")
manifest_path.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
PY
}

run_case() {
  local case_name="$1"
  local expected="$2"
  local summary="$3"
  local setup_fn="$4"
  local required_report_pattern="${5:-}"

  local tmp_manifest tmp_report tmp_log rc actual result report_assertion
  tmp_manifest="$(mktemp)"
  tmp_report="$(mktemp)"
  tmp_log="$(mktemp)"

  "$setup_fn" "$tmp_manifest"

  set +e
  ./scripts/check_update_manifest.sh "$tmp_manifest" "$tmp_report" >"$tmp_log" 2>&1
  rc=$?
  set -e

  actual="pass"
  if [[ "$rc" -ne 0 ]]; then
    actual="fail"
  fi

  report_assertion="ok"
  if [[ -n "$required_report_pattern" ]]; then
    if ! grep -Fq "$required_report_pattern" "$tmp_report"; then
      report_assertion="missing: ${required_report_pattern}"
    fi
  fi

  result="ok"
  if [[ "$expected" != "$actual" || "$report_assertion" != "ok" ]]; then
    result="mismatch"
    failure_count=$((failure_count + 1))
  fi

  total_cases=$((total_cases + 1))
  append_case_row "$case_name" "$expected" "$actual" "$report_assertion" "$result" "$summary"

  rm -f "$tmp_manifest" "$tmp_report" "$tmp_log"
}

if [[ ! -f "$source_manifest_file" ]]; then
  echo "[update-manifest-contract] source manifest file not found: $source_manifest_file" >&2
  exit 1
fi

run_case \
  "baseline-example-pass" \
  "pass" \
  "Baseline example manifest should pass validation." \
  setup_baseline_case \
  "Status: passed"

run_case \
  "invalid-json-fail" \
  "fail" \
  "Invalid JSON payload should fail validation." \
  setup_invalid_json_case \
  "invalid json:"

run_case \
  "missing-required-field-fail" \
  "fail" \
  "Removing required field should fail validation." \
  setup_missing_required_field_case \
  "missing/invalid required field 'windowsArtifactUrl'"

run_case \
  "insecure-artifact-url-fail" \
  "fail" \
  "Non-https artifact URL should fail validation." \
  setup_insecure_url_case \
  "url must use https (windowsArtifactUrl)"

run_case \
  "identical-platform-urls-fail" \
  "fail" \
  "Identical macOS/Windows artifact URLs should fail validation." \
  setup_identical_platform_urls_case \
  "macosArtifactUrl and windowsArtifactUrl must not be identical"

status="passed"
if [[ "$failure_count" -gt 0 ]]; then
  status="failed"
fi

{
  echo "# Update Manifest Contract Report"
  echo
  echo "- Generated at (UTC): $timestamp"
  echo "- Source manifest file: $source_manifest_file"
  echo "- Total cases: $total_cases"
  echo "- Failures: $failure_count"
  echo "- Status: $status"
  echo
  echo "| Case | Expected | Actual | Report assertion | Result | Summary |"
  echo "|---|---|---|---|---|---|"
  if [[ -n "$case_rows" ]]; then
    printf '%s' "$case_rows"
  else
    echo "| none | n/a | n/a | n/a | n/a | no cases executed |"
  fi
} > "$report_file"

if [[ "$failure_count" -gt 0 ]]; then
  echo "[update-manifest-contract] failed with ${failure_count} mismatch(es). report: $report_file" >&2
  exit 1
fi

echo "[update-manifest-contract] passed. report: $report_file"
