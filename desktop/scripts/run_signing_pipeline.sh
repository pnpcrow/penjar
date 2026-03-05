#!/usr/bin/env bash
set -eo pipefail

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
    echo "[signing-pipeline] invalid platform: $platform (allowed: macos|windows)" >&2
    exit 1
    ;;
esac

mode_dir=""
case "$build_mode" in
  release) mode_dir="Release" ;;
  debug) mode_dir="Debug" ;;
  *)
    echo "[signing-pipeline] invalid build mode: $build_mode (allowed: release|debug)" >&2
    exit 1
    ;;
esac

strict_mode=0
case "$(printf '%s' "$strict_input" | tr '[:upper:]' '[:lower:]')" in
  1|true|yes|strict) strict_mode=1 ;;
esac

artifact_path=""
sign_command=""
notarize_command=""
required_vars=()

if [[ "$platform" == "macos" ]]; then
  artifact_path="build/macos/Build/Products/${mode_dir}/Penjar Desktop.app"
  sign_command="${PENJAR_MACOS_SIGN_COMMAND:-}"
  notarize_command="${PENJAR_MACOS_NOTARIZE_COMMAND:-}"
  required_vars=("PENJAR_MACOS_SIGN_IDENTITY" "PENJAR_MACOS_TEAM_ID" "PENJAR_MACOS_NOTARY_PROFILE")
else
  artifact_path="build/windows/x64/runner/${mode_dir}"
  sign_command="${PENJAR_WINDOWS_SIGN_COMMAND:-}"
  required_vars=("PENJAR_WINDOWS_CERT_PATH" "PENJAR_WINDOWS_CERT_PASSWORD")
fi

if [[ -z "$report_file" ]]; then
  report_file="release/reports/signing_report_${platform}.md"
fi

mkdir -p "$(dirname "$report_file")"

if [[ ! -e "$artifact_path" ]]; then
  echo "[signing-pipeline] missing build artifact path: $artifact_path" >&2
  exit 1
fi

timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

missing_count=0
missing_names=""
for var_name in "${required_vars[@]}"; do
  if [[ -z "${!var_name:-}" ]]; then
    missing_count=$((missing_count + 1))
    if [[ -z "$missing_names" ]]; then
      missing_names="$var_name"
    else
      missing_names="${missing_names},${var_name}"
    fi
  fi
done

signing_status="simulated"
notarization_status="not-applicable"
signed_artifact_path="$artifact_path"
error_message=""
sign_command_placeholder_status="not-configured"
notarize_command_placeholder_status="not-applicable"

is_placeholder_command() {
  local command_value
  command_value="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')"
  if [[ "$command_value" =~ ^[[:space:]]*echo([[:space:]]|$) ]]; then
    return 0
  fi
  if printf '%s' "$command_value" | grep -Eq '<[^>]+>'; then
    return 0
  fi
  if [[ "$command_value" =~ (^|[^a-z0-9_])(todo|tbd|placeholder|changeme|change_me|replace_me|example|dummy|sample|fixme)([^a-z0-9_]|$) ]]; then
    return 0
  fi
  return 1
}

if [[ -n "$sign_command" ]]; then
  if is_placeholder_command "$sign_command"; then
    sign_command_placeholder_status="detected"
    if [[ "$strict_mode" -eq 1 ]]; then
      signing_status="failed"
      error_message="sign command appears to be a placeholder in strict mode"
    else
      signing_status="simulated"
      error_message="sign command appears to be a placeholder; execution skipped"
    fi
  else
    sign_command_placeholder_status="clear"
    export PENJAR_SIGN_TARGET="$artifact_path"
    if bash -lc "$sign_command"; then
      signing_status="executed"
    else
      signing_status="failed"
      error_message="sign command failed"
    fi
  fi
elif [[ "$strict_mode" -eq 1 ]]; then
  signing_status="failed"
  error_message="sign command missing in strict mode"
fi

if [[ "$platform" == "macos" ]]; then
  if [[ -n "$notarize_command" && "$signing_status" != "failed" ]]; then
    if is_placeholder_command "$notarize_command"; then
      notarize_command_placeholder_status="detected"
      if [[ "$strict_mode" -eq 1 ]]; then
        notarization_status="failed"
        if [[ -z "$error_message" ]]; then
          error_message="notarize command appears to be a placeholder in strict mode"
        fi
      else
        notarization_status="simulated"
        if [[ -z "$error_message" ]]; then
          error_message="notarize command appears to be a placeholder; execution skipped"
        fi
      fi
    else
      notarize_command_placeholder_status="clear"
      export PENJAR_NOTARIZE_TARGET="$signed_artifact_path"
      if bash -lc "$notarize_command"; then
        notarization_status="executed"
      else
        notarization_status="failed"
        if [[ -z "$error_message" ]]; then
          error_message="notarize command failed"
        fi
      fi
    fi
  elif [[ "$strict_mode" -eq 1 ]]; then
    notarization_status="failed"
    if [[ -z "$error_message" ]]; then
      error_message="notarize command missing in strict mode"
    fi
  else
    notarization_status="simulated"
    notarize_command_placeholder_status="not-configured"
  fi
fi

if [[ "$missing_count" -gt 0 && "$strict_mode" -eq 1 ]]; then
  if [[ -z "$error_message" ]]; then
    error_message="missing signing variables"
  fi
  if [[ "$signing_status" != "failed" ]]; then
    signing_status="failed"
  fi
fi

{
  echo "# Desktop Signing Pipeline Report (${platform})"
  echo
  echo "- Generated at (UTC): $timestamp"
  echo "- Strict mode: $strict_mode"
  echo "- Build mode: $build_mode"
  echo "- Artifact path: $artifact_path"
  echo "- Required variable missing count: $missing_count"
  if [[ "$missing_count" -gt 0 ]]; then
    echo "- Missing variables: $missing_names"
  fi
  echo "- Sign command configured: $([[ -n "$sign_command" ]] && echo yes || echo no)"
  echo "- Sign command placeholder status: $sign_command_placeholder_status"
  if [[ "$platform" == "macos" ]]; then
    echo "- Notarize command configured: $([[ -n "$notarize_command" ]] && echo yes || echo no)"
    echo "- Notarize command placeholder status: $notarize_command_placeholder_status"
  fi
  echo
  echo "| Stage | Status |"
  echo "|---|---|"
  echo "| signing | $signing_status |"
  if [[ "$platform" == "macos" ]]; then
    echo "| notarization | $notarization_status |"
  fi
  if [[ -n "$error_message" ]]; then
    echo
    echo "- Error: $error_message"
  fi
} > "$report_file"

if [[ "$strict_mode" -eq 1 ]]; then
  if [[ "$missing_count" -gt 0 || "$signing_status" == "failed" || "$notarization_status" == "failed" ]]; then
    echo "[signing-pipeline] strict mode failed. report: $report_file" >&2
    exit 1
  fi
fi

if [[ "$signing_status" == "failed" || "$notarization_status" == "failed" ]]; then
  echo "[signing-pipeline] warning: execution not fully completed. report: $report_file"
  exit 0
fi

if [[ "$sign_command_placeholder_status" == "detected" || "$notarize_command_placeholder_status" == "detected" ]]; then
  echo "[signing-pipeline] warning: placeholder command detected. report: $report_file"
  exit 0
fi

echo "[signing-pipeline] completed. report: $report_file"
