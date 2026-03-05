#!/usr/bin/env bash
set -eo pipefail

platform="${1:-}"
strict_input="${2:-${STRICT_RELEASE_EVIDENCE_BUNDLE:-0}}"
bundle_report_file="${3:-}"
check_report_file="${4:-}"

if [[ -z "$platform" ]]; then
  echo "usage: $0 <macos|windows> [strict-mode] [bundle-report-file] [check-report-file]" >&2
  exit 1
fi

case "$platform" in
  macos|windows) ;;
  *)
    echo "[release-evidence-bundle-check] invalid platform: $platform (allowed: macos|windows)" >&2
    exit 1
    ;;
esac

if [[ -z "$bundle_report_file" ]]; then
  bundle_report_file="release/reports/release_evidence_bundle_${platform}.md"
fi

if [[ -z "$check_report_file" ]]; then
  check_report_file="release/reports/release_evidence_bundle_check_${platform}.md"
fi

if [[ ! -f "$bundle_report_file" ]]; then
  echo "[release-evidence-bundle-check] bundle report not found: $bundle_report_file" >&2
  exit 1
fi

python_bin=""
if command -v python3 >/dev/null 2>&1; then
  python_bin="python3"
elif command -v python >/dev/null 2>&1; then
  python_bin="python"
else
  echo "[release-evidence-bundle-check] python runtime is required (python3 or python)." >&2
  exit 1
fi

mkdir -p "$(dirname "$check_report_file")"

"$python_bin" - "$platform" "$strict_input" "$bundle_report_file" "$check_report_file" <<'PY'
import datetime
import pathlib
import re
import sys

platform = sys.argv[1]
strict_raw = str(sys.argv[2]).strip().lower()
bundle_report_path = pathlib.Path(sys.argv[3])
check_report_path = pathlib.Path(sys.argv[4])

strict_mode = strict_raw in {"1", "true", "yes", "strict", "on", "enabled"}

content = bundle_report_path.read_text(encoding="utf-8")
row_pattern = re.compile(r"^\|\s*([^|]+?)\s*\|\s*([^|]+?)\s*\|$", re.MULTILINE)
rows = []
for match in row_pattern.finditer(content):
    report_name = match.group(1).strip()
    status = match.group(2).strip()
    if report_name.lower() == "report":
        continue
    if report_name.startswith("---"):
        continue
    rows.append((report_name, status))

if not rows:
    check_report_path.write_text(
        "\n".join(
            [
                f"# Release Evidence Bundle Check ({platform})",
                "",
                f"- Generated at (UTC): {datetime.datetime.now(datetime.timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')}",
                f"- Strict mode: {1 if strict_mode else 0}",
                f"- Bundle report: {bundle_report_path}",
                "- Status: failed",
                "",
                "## Errors",
                "- no status table rows found in bundle report",
            ]
        )
        + "\n",
        encoding="utf-8",
    )
    raise SystemExit("[release-evidence-bundle-check] failed: no status rows found.")

critical_tokens = ("failed", "error", "invalid")
risky_tokens = ("missing", "simulated", "ready-without-verify", "skipped", "not-configured", "unavailable", "unknown", "n/a")

classified_rows = []
critical_count = 0
risky_count = 0
for report_name, status in rows:
    normalized = status.lower()
    classification = "ok"
    if any(token in normalized for token in critical_tokens):
        classification = "critical"
        critical_count += 1
    elif any(token in normalized for token in risky_tokens):
        classification = "risky"
        risky_count += 1
    classified_rows.append((report_name, status, classification))

overall_status = "passed"
if critical_count > 0:
    overall_status = "failed"
elif risky_count > 0:
    overall_status = "failed" if strict_mode else "ready-with-warnings"

lines = [
    f"# Release Evidence Bundle Check ({platform})",
    "",
    f"- Generated at (UTC): {datetime.datetime.now(datetime.timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')}",
    f"- Strict mode: {1 if strict_mode else 0}",
    f"- Bundle report: {bundle_report_path}",
    f"- Status: {overall_status}",
    f"- Critical count: {critical_count}",
    f"- Risky count: {risky_count}",
    "",
    "## Status classification",
    "",
    "| Report | Raw status | Classification |",
    "|---|---|---|",
]

for report_name, status, classification in classified_rows:
    lines.append(f"| {report_name} | {status} | {classification} |")

lines.extend(["", "## Classification policy", "- `critical`: contains `failed|error|invalid`", "- `risky`: contains `missing|simulated|ready-without-verify|skipped|not-configured|unavailable|unknown|n/a`", "- `ok`: no critical/risky tokens"])

check_report_path.write_text("\n".join(lines) + "\n", encoding="utf-8")

if overall_status == "failed":
    raise SystemExit("[release-evidence-bundle-check] failed. report: " + str(check_report_path))
if overall_status == "ready-with-warnings":
    print("[release-evidence-bundle-check] warning: risky statuses detected. report: " + str(check_report_path))
else:
    print("[release-evidence-bundle-check] passed. report: " + str(check_report_path))
PY
