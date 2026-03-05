#!/usr/bin/env bash
set -eo pipefail

platform="${1:-}"
strict_input="${2:-0}"
build_mode="${3:-release}"

if [[ -z "$platform" ]]; then
  echo "usage: $0 <macos|windows> [strict=0|1] [release|debug]" >&2
  exit 1
fi

build_flag=""
case "$build_mode" in
  release) build_flag="--release" ;;
  debug) build_flag="--debug" ;;
  *)
    echo "[signing-with-build] invalid build mode: $build_mode (allowed: release|debug)" >&2
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
    echo "[signing-with-build] invalid platform: $platform (allowed: macos|windows)" >&2
    exit 1
    ;;
esac

./scripts/run_signing_pipeline.sh "$platform" "$strict_input" "$build_mode"
