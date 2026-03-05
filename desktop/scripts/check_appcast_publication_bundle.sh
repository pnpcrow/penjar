#!/usr/bin/env bash
set -eo pipefail

bundle_file="${1:-release/reports/appcast_publication_bundle.json}"

if [[ ! -f "$bundle_file" ]]; then
  echo "[appcast-bundle-check] missing bundle file: $bundle_file" >&2
  exit 1
fi

python_bin=""
if command -v python3 >/dev/null 2>&1; then
  python_bin="python3"
elif command -v python >/dev/null 2>&1; then
  python_bin="python"
else
  echo "[appcast-bundle-check] python runtime is required (python3 or python)." >&2
  exit 1
fi

"$python_bin" - "$bundle_file" <<'PY'
import json
import pathlib
import re
import sys

bundle_path = pathlib.Path(sys.argv[1])
with bundle_path.open("r", encoding="utf-8") as fh:
    bundle = json.load(fh)

required_string_fields = [
    "generatedAt",
    "channel",
    "latestVersion",
    "sourceAppcastPath",
    "targetDirectory",
]
for field in required_string_fields:
    value = bundle.get(field)
    if not isinstance(value, str) or not value.strip():
        raise SystemExit(f"[appcast-bundle-check] missing/invalid field '{field}' in {bundle_path}")

if bundle["channel"] not in {"stable", "beta", "dev"}:
    raise SystemExit(f"[appcast-bundle-check] invalid channel: {bundle['channel']}")

if not re.fullmatch(r"\d+\.\d+\.\d+(?:[-.][A-Za-z0-9]+)?", bundle["latestVersion"]):
    raise SystemExit(f"[appcast-bundle-check] invalid latestVersion: {bundle['latestVersion']}")

if not re.fullmatch(r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z", bundle["generatedAt"]):
    raise SystemExit(f"[appcast-bundle-check] invalid generatedAt UTC timestamp: {bundle['generatedAt']}")

targets = bundle.get("targets")
if not isinstance(targets, list) or not targets:
    raise SystemExit(f"[appcast-bundle-check] targets must contain at least one entry: {bundle_path}")

sha256_regex = re.compile(r"[0-9a-f]{64}")
has_latest = False
has_version = False
expected_version_suffix = f"-{bundle['latestVersion']}.json"
expected_latest_suffix = "-latest.json"

for target in targets:
    if not isinstance(target, dict):
        raise SystemExit("[appcast-bundle-check] target entry must be an object")

    path = target.get("path")
    sha256 = target.get("sha256")
    size_bytes = target.get("sizeBytes")
    if not isinstance(path, str) or not path.endswith(".json"):
        raise SystemExit(f"[appcast-bundle-check] invalid target path: {path}")
    if not isinstance(sha256, str) or not sha256_regex.fullmatch(sha256):
        raise SystemExit(f"[appcast-bundle-check] invalid target sha256 for {path}: {sha256}")
    if not isinstance(size_bytes, int) or size_bytes <= 0:
        raise SystemExit(f"[appcast-bundle-check] invalid target sizeBytes for {path}: {size_bytes}")

    if path.endswith(expected_latest_suffix):
        has_latest = True
    if path.endswith(expected_version_suffix):
        has_version = True

if not has_latest:
    raise SystemExit("[appcast-bundle-check] missing latest target in bundle")
if not has_version:
    raise SystemExit("[appcast-bundle-check] missing version-pinned target in bundle")
PY

echo "[appcast-bundle-check] passed for $bundle_file"
