#!/usr/bin/env bash
set -eo pipefail

platform="${1:-}"
build_mode="${2:-release}"
manifest_file="${3:-release/update_manifest.example.json}"

if [[ -z "$platform" ]]; then
  echo "usage: $0 <macos|windows> [release|debug] [manifest-file]" >&2
  exit 1
fi

build_flag=""
case "$build_mode" in
  release) build_flag="--release" ;;
  debug) build_flag="--debug" ;;
  *)
    echo "[installer-update-smoke] invalid build mode: $build_mode (allowed: release|debug)" >&2
    exit 1
    ;;
esac

if [[ "${SKIP_PUB_GET:-0}" != "1" ]]; then
  flutter pub get
fi

case "$platform" in
  macos)
    flutter build macos "$build_flag" --no-pub
    ;;
  windows)
    flutter build windows "$build_flag" --no-pub
    ;;
  *)
    echo "[installer-update-smoke] invalid platform: $platform (allowed: macos|windows)" >&2
    exit 1
    ;;
esac

./scripts/run_signing_pipeline.sh "$platform" "${STRICT_SIGNING_EXECUTION:-0}" "$build_mode"
./scripts/check_signing_artifact_provenance.sh "$platform" "${STRICT_SIGNING_PROVENANCE:-0}" "$build_mode"

if [[ "$platform" == "windows" ]]; then
  ./scripts/run_windows_installer_pipeline.sh "${STRICT_WINDOWS_INSTALLER_EXECUTION:-0}" "$build_mode"
  ./scripts/check_windows_installer_packaging.sh "${STRICT_WINDOWS_INSTALLER_PACKAGING:-0}" "$build_mode"
  ./scripts/check_windows_installer_provenance.sh "${STRICT_WINDOWS_INSTALLER_PROVENANCE:-0}" "$build_mode"
fi

./scripts/generate_installer_update_report.sh "$platform" "$build_mode" "$manifest_file"
