#!/usr/bin/env bash
set -eo pipefail

appcast_file="${1:-release/reports/appcast_preview.json}"

if [[ ! -f "$appcast_file" ]]; then
  echo "[appcast-check] missing appcast file: $appcast_file" >&2
  exit 1
fi

python_bin=""
if command -v python3 >/dev/null 2>&1; then
  python_bin="python3"
elif command -v python >/dev/null 2>&1; then
  python_bin="python"
else
  echo "[appcast-check] python runtime is required (python3 or python)." >&2
  exit 1
fi

"$python_bin" - "$appcast_file" <<'PY'
import json
import pathlib
import re
import sys

appcast_path = pathlib.Path(sys.argv[1])
with appcast_path.open("r", encoding="utf-8") as fh:
    data = json.load(fh)

required_string_fields = [
    "channel",
    "latestVersion",
    "publishedAt",
    "releaseNotesUrl",
    "generatedAt",
]
for field in required_string_fields:
    value = data.get(field)
    if not isinstance(value, str) or not value.strip():
        raise SystemExit(f"[appcast-check] missing/invalid field '{field}' in {appcast_path}")

if data["channel"] not in {"stable", "beta", "dev"}:
    raise SystemExit(f"[appcast-check] invalid channel: {data['channel']}")

if not re.fullmatch(r"\d+\.\d+\.\d+(?:[-.][A-Za-z0-9]+)?", data["latestVersion"]):
    raise SystemExit(f"[appcast-check] invalid latestVersion format: {data['latestVersion']}")

iso_utc = re.compile(r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z")
for field in ("publishedAt", "generatedAt"):
    if not iso_utc.fullmatch(data[field]):
        raise SystemExit(f"[appcast-check] invalid UTC timestamp in '{field}': {data[field]}")

if not data["releaseNotesUrl"].startswith("https://"):
    raise SystemExit(f"[appcast-check] releaseNotesUrl must use https: {data['releaseNotesUrl']}")

artifacts = data.get("artifacts")
if not isinstance(artifacts, list) or not artifacts:
    raise SystemExit(f"[appcast-check] artifacts array must contain at least one entry: {appcast_path}")

platform_seen = set()
sha256_regex = re.compile(r"[0-9a-f]{64}")

for artifact in artifacts:
    if not isinstance(artifact, dict):
        raise SystemExit("[appcast-check] artifact entry must be an object")

    platform = artifact.get("platform")
    if platform not in {"macos", "windows"}:
        raise SystemExit(f"[appcast-check] invalid artifact platform: {platform}")
    if platform in platform_seen:
        raise SystemExit(f"[appcast-check] duplicate artifact platform: {platform}")
    platform_seen.add(platform)

    url = artifact.get("url")
    if not isinstance(url, str) or not url.startswith("https://"):
        raise SystemExit(f"[appcast-check] invalid artifact url for {platform}: {url}")

    sha256 = artifact.get("sha256")
    if not isinstance(sha256, str) or not sha256_regex.fullmatch(sha256):
        raise SystemExit(f"[appcast-check] invalid sha256 for {platform}: {sha256}")

    size_bytes = artifact.get("sizeBytes")
    if not isinstance(size_bytes, int) or size_bytes <= 0:
        raise SystemExit(f"[appcast-check] invalid sizeBytes for {platform}: {size_bytes}")

    archive_path = artifact.get("archivePath")
    if not isinstance(archive_path, str) or not archive_path.strip():
        raise SystemExit(f"[appcast-check] missing archivePath for {platform}")
PY

echo "[appcast-check] passed for $appcast_file"
