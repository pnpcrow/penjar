#!/usr/bin/env bash
set -eo pipefail

appcast_file="${1:-release/reports/appcast_preview.json}"
publish_dir="${2:-release/published}"
bundle_file="${3:-release/reports/appcast_publication_bundle.json}"

if [[ ! -f "$appcast_file" ]]; then
  echo "[appcast-bundle-generate] missing appcast file: $appcast_file" >&2
  exit 1
fi

if [[ ! -d "$publish_dir" ]]; then
  echo "[appcast-bundle-generate] missing publish directory: $publish_dir" >&2
  exit 1
fi

python_bin=""
if command -v python3 >/dev/null 2>&1; then
  python_bin="python3"
elif command -v python >/dev/null 2>&1; then
  python_bin="python"
else
  echo "[appcast-bundle-generate] python runtime is required (python3 or python)." >&2
  exit 1
fi

"$python_bin" - "$appcast_file" "$publish_dir" "$bundle_file" <<'PY'
import datetime
import hashlib
import json
import pathlib
import re
import sys

appcast_path = pathlib.Path(sys.argv[1])
publish_dir = pathlib.Path(sys.argv[2])
bundle_path = pathlib.Path(sys.argv[3])

with appcast_path.open("r", encoding="utf-8") as fh:
    appcast = json.load(fh)

channel = appcast.get("channel")
version = appcast.get("latestVersion")

if channel not in {"stable", "beta", "dev"}:
    raise SystemExit(f"[appcast-bundle-generate] invalid channel in {appcast_path}: {channel}")
if not isinstance(version, str) or not re.fullmatch(r"\d+\.\d+\.\d+(?:[-.][A-Za-z0-9]+)?", version):
    raise SystemExit(f"[appcast-bundle-generate] invalid latestVersion in {appcast_path}: {version}")

target_files = sorted(publish_dir.glob(f"appcast-{channel}-*.json"))
if not target_files:
    raise SystemExit(f"[appcast-bundle-generate] no published appcast files found for channel '{channel}' in {publish_dir}")

def sha256_of(path: pathlib.Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as fh:
        for chunk in iter(lambda: fh.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()

targets = []
for target in target_files:
    targets.append(
        {
            "path": str(target),
            "sha256": sha256_of(target),
            "sizeBytes": target.stat().st_size,
        }
    )

bundle = {
    "generatedAt": datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
    "channel": channel,
    "latestVersion": version,
    "sourceAppcastPath": str(appcast_path),
    "targetDirectory": str(publish_dir),
    "targets": targets,
}

bundle_path.parent.mkdir(parents=True, exist_ok=True)
with bundle_path.open("w", encoding="utf-8") as fh:
    json.dump(bundle, fh, indent=2)
    fh.write("\n")
PY

echo "[appcast-bundle-generate] generated: $bundle_file"
