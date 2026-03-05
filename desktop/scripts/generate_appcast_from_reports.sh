#!/usr/bin/env bash
set -eo pipefail

manifest_file="${1:-release/update_manifest.example.json}"
reports_dir="${2:-release/reports}"
output_file="${3:-release/reports/appcast_preview.json}"

if [[ ! -f "$manifest_file" ]]; then
  echo "[appcast-generate] missing manifest file: $manifest_file" >&2
  exit 1
fi

if [[ ! -d "$reports_dir" ]]; then
  echo "[appcast-generate] missing reports directory: $reports_dir" >&2
  exit 1
fi

python_bin=""
if command -v python3 >/dev/null 2>&1; then
  python_bin="python3"
elif command -v python >/dev/null 2>&1; then
  python_bin="python"
else
  echo "[appcast-generate] python runtime is required (python3 or python)." >&2
  exit 1
fi

"$python_bin" - "$manifest_file" "$reports_dir" "$output_file" <<'PY'
import datetime
import json
import pathlib
import sys

manifest_path = pathlib.Path(sys.argv[1])
reports_dir = pathlib.Path(sys.argv[2])
output_path = pathlib.Path(sys.argv[3])

with manifest_path.open("r", encoding="utf-8") as fh:
    manifest = json.load(fh)

required_manifest_fields = [
    "version",
    "channel",
    "publishedAt",
    "releaseNotesUrl",
    "macosArtifactUrl",
    "windowsArtifactUrl",
]
for field in required_manifest_fields:
    value = manifest.get(field)
    if not isinstance(value, str) or not value.strip():
        raise SystemExit(f"[appcast-generate] missing/invalid manifest field '{field}'")

report_files = sorted(reports_dir.glob("installer_update_report_*.json"))
if not report_files:
    raise SystemExit(f"[appcast-generate] no installer_update_report_*.json files found in {reports_dir}")

platform_artifacts = {}
for report_file in report_files:
    with report_file.open("r", encoding="utf-8") as fh:
        report = json.load(fh)

    platform = report.get("platform")
    if platform not in ("macos", "windows"):
        continue

    if report.get("version") != manifest["version"]:
        raise SystemExit(
            f"[appcast-generate] version mismatch in {report_file}: "
            f"{report.get('version')} != {manifest['version']}"
        )

    if report.get("channel") != manifest["channel"]:
        raise SystemExit(
            f"[appcast-generate] channel mismatch in {report_file}: "
            f"{report.get('channel')} != {manifest['channel']}"
        )

    sha256 = report.get("artifactArchiveSha256")
    size_bytes = report.get("artifactArchiveSizeBytes")
    archive_path = report.get("artifactArchivePath")
    if not isinstance(sha256, str) or not sha256.strip():
        raise SystemExit(f"[appcast-generate] missing artifactArchiveSha256 in {report_file}")
    if not isinstance(size_bytes, int) or size_bytes <= 0:
        raise SystemExit(f"[appcast-generate] invalid artifactArchiveSizeBytes in {report_file}")
    if not isinstance(archive_path, str) or not archive_path.strip():
        raise SystemExit(f"[appcast-generate] missing artifactArchivePath in {report_file}")

    artifact_url_key = "macosArtifactUrl" if platform == "macos" else "windowsArtifactUrl"

    platform_artifacts[platform] = {
        "platform": platform,
        "buildMode": report.get("buildMode", "unknown"),
        "url": manifest[artifact_url_key],
        "sha256": sha256,
        "sizeBytes": size_bytes,
        "archivePath": archive_path,
    }

if not platform_artifacts:
    raise SystemExit("[appcast-generate] no valid platform reports found for macOS/Windows")

ordered_artifacts = []
for platform in ("macos", "windows"):
    artifact = platform_artifacts.get(platform)
    if artifact is not None:
        ordered_artifacts.append(artifact)

appcast = {
    "channel": manifest["channel"],
    "latestVersion": manifest["version"],
    "publishedAt": manifest["publishedAt"],
    "releaseNotesUrl": manifest["releaseNotesUrl"],
    "generatedAt": datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
    "artifacts": ordered_artifacts,
}

output_path.parent.mkdir(parents=True, exist_ok=True)
with output_path.open("w", encoding="utf-8") as fh:
    json.dump(appcast, fh, indent=2)
    fh.write("\n")
PY

echo "[appcast-generate] generated: $output_file"
