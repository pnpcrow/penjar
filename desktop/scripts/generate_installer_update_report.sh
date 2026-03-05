#!/usr/bin/env bash
set -eo pipefail

platform="${1:-}"
build_mode="${2:-release}"
manifest_file="${3:-release/update_manifest.example.json}"
output_dir="${4:-release/reports}"
artifact_path="${5:-}"

if [[ -z "$platform" ]]; then
  echo "usage: $0 <macos|windows> [release|debug] [manifest-file] [output-dir] [artifact-path]" >&2
  exit 1
fi

case "$platform" in
  macos|windows) ;;
  *)
    echo "[installer-update-report] invalid platform: $platform (allowed: macos|windows)" >&2
    exit 1
    ;;
esac

mode_dir=""
build_flag=""
case "$build_mode" in
  release)
    mode_dir="Release"
    build_flag="release"
    ;;
  debug)
    mode_dir="Debug"
    build_flag="debug"
    ;;
  *)
    echo "[installer-update-report] invalid build mode: $build_mode (allowed: release|debug)" >&2
    exit 1
    ;;
esac

if [[ -z "$artifact_path" ]]; then
  case "$platform" in
    macos)
      artifact_path="build/macos/Build/Products/${mode_dir}/Penjar Desktop.app"
      ;;
    windows)
      artifact_path="build/windows/x64/runner/${mode_dir}"
      ;;
  esac
fi

if [[ ! -f "./scripts/check_update_manifest.sh" ]]; then
  echo "[installer-update-report] missing dependency script: ./scripts/check_update_manifest.sh" >&2
  exit 1
fi

./scripts/check_update_manifest.sh "$manifest_file"

if [[ ! -e "$artifact_path" ]]; then
  echo "[installer-update-report] missing build artifact path: $artifact_path" >&2
  exit 1
fi

python_bin=""
if command -v python3 >/dev/null 2>&1; then
  python_bin="python3"
elif command -v python >/dev/null 2>&1; then
  python_bin="python"
else
  echo "[installer-update-report] python runtime is required (python3 or python)." >&2
  exit 1
fi

mkdir -p "$output_dir"

archive_path="${output_dir}/penjar-${platform}-${build_flag}.zip"
report_path="${output_dir}/installer_update_report_${platform}.json"

"$python_bin" - "$artifact_path" "$archive_path" <<'PY'
import os
import sys
import zipfile

source_path = sys.argv[1]
archive_path = sys.argv[2]
source_norm = source_path.rstrip("/\\")
source_parent = os.path.dirname(source_norm)

with zipfile.ZipFile(archive_path, "w", compression=zipfile.ZIP_DEFLATED) as zf:
    if os.path.isdir(source_path):
        for root, _dirs, files in os.walk(source_path):
            files.sort()
            for name in files:
                full_path = os.path.join(root, name)
                rel_path = os.path.relpath(full_path, source_parent)
                rel_path = rel_path.replace(os.sep, "/")
                zf.write(full_path, rel_path)
    else:
        zf.write(source_path, os.path.basename(source_path))
PY

artifact_sha256="$("$python_bin" - "$archive_path" <<'PY'
import hashlib
import sys

path = sys.argv[1]
sha = hashlib.sha256()
with open(path, "rb") as fh:
    for chunk in iter(lambda: fh.read(1024 * 1024), b""):
        sha.update(chunk)
print(sha.hexdigest())
PY
)"

artifact_size_bytes="$(wc -c < "$archive_path" | tr -d '[:space:]')"
if [[ "$artifact_size_bytes" == "0" ]]; then
  echo "[installer-update-report] generated archive is empty: $archive_path" >&2
  exit 1
fi

generated_at="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

"$python_bin" - "$manifest_file" "$platform" "$report_path" "$build_mode" "$artifact_path" "$archive_path" "$artifact_sha256" "$artifact_size_bytes" "$generated_at" <<'PY'
import json
import sys

manifest_file = sys.argv[1]
platform = sys.argv[2]
report_path = sys.argv[3]
build_mode = sys.argv[4]
artifact_path = sys.argv[5]
archive_path = sys.argv[6]
artifact_sha256 = sys.argv[7]
artifact_size_bytes = int(sys.argv[8])
generated_at = sys.argv[9]

with open(manifest_file, "r", encoding="utf-8") as fh:
    manifest = json.load(fh)

artifact_url_key = "macosArtifactUrl" if platform == "macos" else "windowsArtifactUrl"

report = {
    "platform": platform,
    "buildMode": build_mode,
    "generatedAt": generated_at,
    "version": manifest["version"],
    "channel": manifest["channel"],
    "publishedAt": manifest["publishedAt"],
    "artifactPath": artifact_path,
    "artifactArchivePath": archive_path,
    "artifactArchiveSha256": artifact_sha256,
    "artifactArchiveSizeBytes": artifact_size_bytes,
    "artifactUrl": manifest[artifact_url_key],
    "releaseNotesUrl": manifest["releaseNotesUrl"],
    "manifestPath": manifest_file,
}

with open(report_path, "w", encoding="utf-8") as fh:
    json.dump(report, fh, indent=2)
    fh.write("\n")
PY

echo "[installer-update-report] generated: $report_path"
echo "[installer-update-report] archive: $archive_path"
