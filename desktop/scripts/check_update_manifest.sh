#!/usr/bin/env bash
set -eo pipefail

manifest_file="${1:-release/update_manifest.example.json}"
report_file="${2:-release/reports/update_manifest_validation_report.md}"

if [[ ! -f "$manifest_file" ]]; then
  echo "[update-manifest-check] missing manifest file: $manifest_file" >&2
  exit 1
fi

python_bin=""
if command -v python3 >/dev/null 2>&1; then
  python_bin="python3"
elif command -v python >/dev/null 2>&1; then
  python_bin="python"
else
  echo "[update-manifest-check] python runtime is required (python3 or python)." >&2
  exit 1
fi

mkdir -p "$(dirname "$report_file")"

"$python_bin" - "$manifest_file" "$report_file" <<'PY'
import datetime
import json
import pathlib
import re
import sys

manifest_path = pathlib.Path(sys.argv[1])
report_path = pathlib.Path(sys.argv[2])

required_fields = [
    "version",
    "channel",
    "publishedAt",
    "macosArtifactUrl",
    "windowsArtifactUrl",
    "releaseNotesUrl",
]

def bool_label(value: bool) -> str:
    return "passed" if value else "failed"

try:
    with manifest_path.open("r", encoding="utf-8") as fh:
        manifest = json.load(fh)
except Exception as exc:  # noqa: BLE001
    report_path.write_text(
        "\n".join(
            [
                "# Update Manifest Validation Report",
                "",
                f"- Generated at (UTC): {datetime.datetime.now(datetime.timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')}",
                f"- Manifest file: {manifest_path}",
                "- Status: failed",
                "",
                "## Errors",
                f"- invalid json: {exc}",
            ]
        )
        + "\n",
        encoding="utf-8",
    )
    raise SystemExit(f"[update-manifest-check] invalid json in {manifest_path}: {exc}") from exc

checks = []
errors = []

for field in required_fields:
    value = manifest.get(field)
    passed = isinstance(value, str) and bool(value.strip())
    checks.append((f"required field: {field}", passed, str(value)))
    if not passed:
        errors.append(f"missing/invalid required field '{field}'")

version = str(manifest.get("version", ""))
channel = str(manifest.get("channel", ""))
published_at = str(manifest.get("publishedAt", ""))
macos_url = str(manifest.get("macosArtifactUrl", ""))
windows_url = str(manifest.get("windowsArtifactUrl", ""))
notes_url = str(manifest.get("releaseNotesUrl", ""))

version_ok = bool(re.fullmatch(r"[0-9]+\.[0-9]+\.[0-9]+([-.][A-Za-z0-9]+)?", version))
checks.append(("version semver-like format", version_ok, version))
if not version_ok:
    errors.append(f"invalid semver-like version: {version}")

channel_ok = channel in {"stable", "beta", "dev"}
checks.append(("channel value", channel_ok, channel))
if not channel_ok:
    errors.append(f"invalid channel: {channel} (allowed: stable|beta|dev)")

published_at_ok = bool(re.fullmatch(r"[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z", published_at))
checks.append(("publishedAt timestamp format", published_at_ok, published_at))
if not published_at_ok:
    errors.append(f"invalid publishedAt timestamp: {published_at}")

for label, url in (
    ("macosArtifactUrl", macos_url),
    ("windowsArtifactUrl", windows_url),
    ("releaseNotesUrl", notes_url),
):
    https_ok = url.startswith("https://")
    checks.append((f"{label} uses https", https_ok, url))
    if not https_ok:
        errors.append(f"url must use https ({label}): {url}")

macos_suffix_ok = bool(re.search(r"\.(dmg|pkg|zip)([?#].*)?$", macos_url))
checks.append(("macosArtifactUrl suffix", macos_suffix_ok, macos_url))
if not macos_suffix_ok:
    errors.append(f"macosArtifactUrl must end with .dmg/.pkg/.zip: {macos_url}")

windows_suffix_ok = bool(re.search(r"\.(msi|exe|zip)([?#].*)?$", windows_url))
checks.append(("windowsArtifactUrl suffix", windows_suffix_ok, windows_url))
if not windows_suffix_ok:
    errors.append(f"windowsArtifactUrl must end with .msi/.exe/.zip: {windows_url}")

platform_urls_distinct = macos_url != windows_url
checks.append(("platform artifact urls are distinct", platform_urls_distinct, f"macos={macos_url}; windows={windows_url}"))
if not platform_urls_distinct:
    errors.append("macosArtifactUrl and windowsArtifactUrl must not be identical")

status = "passed" if not errors else "failed"
lines = [
    "# Update Manifest Validation Report",
    "",
    f"- Generated at (UTC): {datetime.datetime.now(datetime.timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')}",
    f"- Manifest file: {manifest_path}",
    f"- Status: {status}",
    "",
    "## Manifest fields",
]
for field in required_fields:
    lines.append(f"- {field}: `{manifest.get(field, '')}`")

lines.extend(["", "## Checks"])
for name, passed, detail in checks:
    lines.append(f"- {name}: {bool_label(passed)} (`{detail}`)")

lines.extend(["", "## Errors"])
if errors:
    for error in errors:
        lines.append(f"- {error}")
else:
    lines.append("- none")

report_path.write_text("\n".join(lines) + "\n", encoding="utf-8")

if errors:
    raise SystemExit("[update-manifest-check] failed. report: " + str(report_path))
PY

echo "[update-manifest-check] passed for $manifest_file (report: $report_file)"
