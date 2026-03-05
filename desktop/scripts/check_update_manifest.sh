#!/usr/bin/env bash
set -eo pipefail

manifest_file="${1:-release/update_manifest.example.json}"

if [[ ! -f "$manifest_file" ]]; then
  echo "[update-manifest-check] missing manifest file: $manifest_file" >&2
  exit 1
fi

extract_value() {
  local key="$1"
  sed -n "s/.*\"$key\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p" "$manifest_file" | head -n 1
}

version="$(extract_value version)"
channel="$(extract_value channel)"
published_at="$(extract_value publishedAt)"
macos_url="$(extract_value macosArtifactUrl)"
windows_url="$(extract_value windowsArtifactUrl)"
notes_url="$(extract_value releaseNotesUrl)"

if [[ -z "$version" || -z "$channel" || -z "$published_at" || -z "$macos_url" || -z "$windows_url" || -z "$notes_url" ]]; then
  echo "[update-manifest-check] one or more required fields are missing/empty in $manifest_file" >&2
  exit 1
fi

if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+([-.][A-Za-z0-9]+)?$ ]]; then
  echo "[update-manifest-check] invalid semver-like version: $version" >&2
  exit 1
fi

case "$channel" in
  stable|beta|dev) ;;
  *)
    echo "[update-manifest-check] invalid channel: $channel (allowed: stable|beta|dev)" >&2
    exit 1
    ;;
esac

if [[ ! "$published_at" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$ ]]; then
  echo "[update-manifest-check] invalid publishedAt timestamp: $published_at" >&2
  exit 1
fi

for url in "$macos_url" "$windows_url" "$notes_url"; do
  if [[ ! "$url" =~ ^https:// ]]; then
    echo "[update-manifest-check] url must use https: $url" >&2
    exit 1
  fi
done

echo "[update-manifest-check] passed for $manifest_file"
