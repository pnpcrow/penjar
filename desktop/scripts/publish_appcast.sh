#!/usr/bin/env bash
set -eo pipefail

appcast_file="${1:-release/reports/appcast_preview.json}"
publish_dir="${2:-release/published}"

if [[ ! -f "$appcast_file" ]]; then
  echo "[appcast-publish] missing appcast file: $appcast_file" >&2
  exit 1
fi

python_bin=""
if command -v python3 >/dev/null 2>&1; then
  python_bin="python3"
elif command -v python >/dev/null 2>&1; then
  python_bin="python"
else
  echo "[appcast-publish] python runtime is required (python3 or python)." >&2
  exit 1
fi

publish_meta="$("$python_bin" - "$appcast_file" <<'PY'
import json
import re
import sys

appcast_file = sys.argv[1]
with open(appcast_file, "r", encoding="utf-8") as fh:
    data = json.load(fh)

channel = data.get("channel")
version = data.get("latestVersion")
if channel not in {"stable", "beta", "dev"}:
    raise SystemExit(f"[appcast-publish] invalid channel in {appcast_file}: {channel}")

if not isinstance(version, str) or not re.fullmatch(r"\d+\.\d+\.\d+(?:[-.][A-Za-z0-9]+)?", version):
    raise SystemExit(f"[appcast-publish] invalid latestVersion in {appcast_file}: {version}")

print(channel)
print(version)
PY
)"

channel="$(printf '%s\n' "$publish_meta" | sed -n '1p')"
version="$(printf '%s\n' "$publish_meta" | sed -n '2p')"

mkdir -p "$publish_dir"

latest_target="${publish_dir}/appcast-${channel}-latest.json"
version_target="${publish_dir}/appcast-${channel}-${version}.json"

cp "$appcast_file" "$latest_target"
cp "$appcast_file" "$version_target"

echo "[appcast-publish] generated latest target: $latest_target"
echo "[appcast-publish] generated version target: $version_target"
