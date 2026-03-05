#!/usr/bin/env bash
set -eo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/placeholder_hygiene.sh
source "${script_dir}/lib/placeholder_hygiene.sh"

platform="${1:-}"
strict_input="${2:-0}"
build_mode="${3:-release}"
report_file="${4:-}"

if [[ -z "$platform" ]]; then
  echo "usage: $0 <macos|windows> [strict=0|1] [release|debug] [report-file]" >&2
  exit 1
fi

case "$platform" in
  macos|windows) ;;
  *)
    echo "[signing-provenance] invalid platform: $platform (allowed: macos|windows)" >&2
    exit 1
    ;;
esac

mode_dir=""
case "$build_mode" in
  release) mode_dir="Release" ;;
  debug) mode_dir="Debug" ;;
  *)
    echo "[signing-provenance] invalid build mode: $build_mode (allowed: release|debug)" >&2
    exit 1
    ;;
esac

strict_mode=0
case "$(printf '%s' "$strict_input" | tr '[:upper:]' '[:lower:]')" in
  1|true|yes|strict) strict_mode=1 ;;
esac

artifact_path=""
verify_command=""
if [[ "$platform" == "macos" ]]; then
  artifact_path="${PENJAR_MACOS_SIGN_ARTIFACT_PATH:-build/macos/Build/Products/${mode_dir}/Penjar Desktop.app}"
  verify_command="${PENJAR_MACOS_SIGN_VERIFY_COMMAND:-}"
else
  artifact_path="${PENJAR_WINDOWS_SIGN_ARTIFACT_PATH:-build/windows/x64/runner/${mode_dir}}"
  verify_command="${PENJAR_WINDOWS_SIGN_VERIFY_COMMAND:-}"
fi

if [[ -z "$report_file" ]]; then
  report_file="release/reports/signing_artifact_provenance_${platform}.md"
fi

timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
mkdir -p "$(dirname "$report_file")"

artifact_status="missing"
hash_status="not-computed"
verify_status="missing"
overall_status="warning"
hash_value=""
error_message=""
verify_command_placeholder_status="not-configured"

compute_hash() {
  local target="$1"
  local py=""
  if command -v python3 >/dev/null 2>&1; then
    py="python3"
  elif command -v python >/dev/null 2>&1; then
    py="python"
  fi

  if [[ -n "$py" ]]; then
    "$py" - "$target" <<'PY'
import hashlib
import os
import sys

target = sys.argv[1]
if os.path.isfile(target):
    h = hashlib.sha256()
    with open(target, "rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    print(h.hexdigest())
    raise SystemExit(0)

if os.path.isdir(target):
    h = hashlib.sha256()
    base = os.path.abspath(target)
    files = []
    for root, _, names in os.walk(base):
        for name in names:
            files.append(os.path.join(root, name))
    files.sort()
    for path in files:
        rel = os.path.relpath(path, base).replace(os.sep, "/")
        h.update(rel.encode("utf-8"))
        with open(path, "rb") as f:
            for chunk in iter(lambda: f.read(1024 * 1024), b""):
                h.update(chunk)
    print(h.hexdigest())
    raise SystemExit(0)

raise SystemExit(1)
PY
    return
  fi

  if command -v shasum >/dev/null 2>&1 && [[ -f "$target" ]]; then
    shasum -a 256 "$target" | awk '{print $1}'
    return
  fi
  if command -v sha256sum >/dev/null 2>&1 && [[ -f "$target" ]]; then
    sha256sum "$target" | awk '{print $1}'
    return
  fi
  return 1
}

if [[ -e "$artifact_path" ]]; then
  artifact_status="present"
  if hash_value="$(compute_hash "$artifact_path" 2>/dev/null)"; then
    if [[ -n "$hash_value" ]]; then
      hash_status="computed"
    else
      hash_status="failed"
      error_message="hash value is empty"
    fi
  else
    hash_status="failed"
    error_message="artifact hash computation failed"
  fi

  if [[ -n "$verify_command" ]]; then
    if is_placeholder_command "$verify_command"; then
      verify_command_placeholder_status="detected"
      verify_status="failed"
      if [[ -z "$error_message" ]]; then
        error_message="verify command appears to be a placeholder"
      fi
    else
      verify_command_placeholder_status="clear"
      export PENJAR_SIGN_VERIFY_TARGET="$artifact_path"
      if bash -lc "$verify_command"; then
        verify_status="executed"
      else
        verify_status="failed"
        if [[ -z "$error_message" ]]; then
          error_message="sign verify command failed"
        fi
      fi
    fi
  else
    verify_command_placeholder_status="not-configured"
  fi
fi

if [[ "$artifact_status" == "present" && "$hash_status" == "computed" && "$verify_status" == "executed" ]]; then
  overall_status="validated"
elif [[ "$artifact_status" == "present" && "$hash_status" == "computed" ]]; then
  overall_status="ready-without-verify"
fi

if [[ "$strict_mode" -eq 1 ]]; then
  if [[ "$artifact_status" != "present" ]]; then
    overall_status="failed"
    if [[ -z "$error_message" ]]; then
      error_message="signed artifact path is missing"
    fi
  elif [[ "$hash_status" != "computed" ]]; then
    overall_status="failed"
  elif [[ -z "$verify_command" ]]; then
    overall_status="failed"
    if [[ -z "$error_message" ]]; then
      error_message="verify command missing in strict mode"
    fi
  elif [[ "$verify_status" != "executed" ]]; then
    overall_status="failed"
  fi
fi

{
  echo "# Signing Artifact Provenance Report (${platform})"
  echo
  echo "- Generated at (UTC): $timestamp"
  echo "- Strict mode: $strict_mode"
  echo "- Build mode: $build_mode"
  echo "- Artifact path: $artifact_path"
  echo "- Artifact status: $artifact_status"
  echo "- Hash status: $hash_status"
  echo "- Artifact SHA256: ${hash_value:-n/a}"
  echo "- Verify command configured: $([[ -n "$verify_command" ]] && echo yes || echo no)"
  echo "- Verify command placeholder status: $verify_command_placeholder_status"
  echo "- Verify command status: $verify_status"
  echo "- Overall status: $overall_status"
  if [[ -n "$error_message" ]]; then
    echo "- Error: $error_message"
  fi
} > "$report_file"

if [[ "$overall_status" == "failed" ]]; then
  echo "[signing-provenance] failed. report: $report_file" >&2
  exit 1
fi

if [[ "$overall_status" != "validated" ]]; then
  echo "[signing-provenance] warning: provenance not fully validated. report: $report_file"
  exit 0
fi

echo "[signing-provenance] passed. report: $report_file"
