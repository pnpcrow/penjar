#!/usr/bin/env bash
set -eo pipefail

strict_input="${1:-${STRICT_APPCAST_EXTERNAL_READINESS:-0}}"
bundle_file="${2:-release/reports/appcast_publication_bundle.json}"
report_file="${3:-release/reports/appcast_external_readiness_report.md}"

strict_mode=0
case "$(printf '%s' "$strict_input" | tr '[:upper:]' '[:lower:]')" in
  1|true|yes|strict) strict_mode=1 ;;
esac

provider="$(printf '%s' "${APPCAST_PUBLISH_PROVIDER:-none}" | tr '[:upper:]' '[:lower:]')"
dry_run_input="${APPCAST_PUBLISH_DRY_RUN:-1}"
dry_run=0
case "$(printf '%s' "$dry_run_input" | tr '[:upper:]' '[:lower:]')" in
  1|true|yes|dry-run|dryrun) dry_run=1 ;;
esac

identity_check_command="${APPCAST_EXTERNAL_IDENTITY_CHECK_COMMAND:-}"
invalidation_check_command="${APPCAST_EXTERNAL_INVALIDATION_CHECK_COMMAND:-}"
cache_invalidation_command="${APPCAST_CACHE_INVALIDATION_COMMAND:-}"

timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
mkdir -p "$(dirname "$report_file")"

status="ready"
required_count=0
warning_count=0
required_notes=""
warning_notes=""
aws_credentials_detected="no"
identity_check_status="not-applicable"
invalidation_check_status="not-applicable"
cache_invalidation_command_status="not-applicable"
placeholder_command_count=0

add_required() {
  local line="$1"
  required_count=$((required_count + 1))
  if [[ -z "$required_notes" ]]; then
    required_notes="$line"
  else
    required_notes="${required_notes}"$'\n'"$line"
  fi
}

add_warning() {
  local line="$1"
  warning_count=$((warning_count + 1))
  if [[ -z "$warning_notes" ]]; then
    warning_notes="$line"
  else
    warning_notes="${warning_notes}"$'\n'"$line"
  fi
}

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

validate_command_hygiene() {
  local env_name="$1"
  local command_value="$2"
  local context="$3"
  local strict="$4"
  if [[ -z "$command_value" ]]; then
    return 1
  fi
  if is_placeholder_command "$command_value"; then
    placeholder_command_count=$((placeholder_command_count + 1))
    if [[ "$strict" -eq 1 ]]; then
      add_required "${env_name} appears to be a placeholder command (${context})."
    else
      add_warning "${env_name} appears to be a placeholder command (${context})."
    fi
    return 0
  fi
  return 1
}

if [[ "$provider" == "none" ]]; then
  status="skipped"
  add_warning "provider=none; external publication is disabled."
elif [[ "$provider" == "s3" ]]; then
  if [[ ! -f "$bundle_file" ]]; then
    add_required "missing publication bundle file: ${bundle_file}"
  fi
  if [[ -z "${APPCAST_S3_BUCKET:-}" ]]; then
    add_required "APPCAST_S3_BUCKET is required for provider=s3."
  fi

  if [[ "$dry_run" -eq 0 ]]; then
    identity_check_status="missing"
    invalidation_check_status="missing"
    cache_invalidation_command_status="missing"

    if ! command -v aws >/dev/null 2>&1; then
      add_required "aws CLI is required for non-dry-run external publication."
    fi

    if [[ -n "${AWS_ACCESS_KEY_ID:-}" && -n "${AWS_SECRET_ACCESS_KEY:-}" ]]; then
      aws_credentials_detected="yes"
    elif [[ -n "${AWS_PROFILE:-}" ]]; then
      aws_credentials_detected="yes"
    elif [[ -n "${AWS_ROLE_ARN:-}" && -n "${AWS_WEB_IDENTITY_TOKEN_FILE:-}" ]]; then
      aws_credentials_detected="yes"
    fi

    if [[ "$aws_credentials_detected" != "yes" ]]; then
      add_required "AWS credentials are not detected. Provide access keys, profile, or role/web-identity variables."
    fi

    identity_placeholder=0
    invalidation_placeholder=0
    cache_invalidation_placeholder=0

    if validate_command_hygiene "APPCAST_EXTERNAL_IDENTITY_CHECK_COMMAND" "$identity_check_command" "identity validation" "$strict_mode"; then
      identity_placeholder=1
    fi
    if validate_command_hygiene "APPCAST_EXTERNAL_INVALIDATION_CHECK_COMMAND" "$invalidation_check_command" "invalidation validation" "$strict_mode"; then
      invalidation_placeholder=1
    fi
    if validate_command_hygiene "APPCAST_CACHE_INVALIDATION_COMMAND" "$cache_invalidation_command" "cache invalidation execution" "$strict_mode"; then
      cache_invalidation_placeholder=1
    fi

    if [[ -n "$identity_check_command" ]]; then
      if [[ "$identity_placeholder" -eq 1 ]]; then
        identity_check_status="placeholder-detected"
      elif bash -lc "$identity_check_command"; then
        identity_check_status="executed"
      else
        identity_check_status="failed"
        add_required "APPCAST_EXTERNAL_IDENTITY_CHECK_COMMAND execution failed."
      fi
    elif [[ "$strict_mode" -eq 1 ]]; then
      add_required "APPCAST_EXTERNAL_IDENTITY_CHECK_COMMAND is required in strict mode for non-dry-run publication."
    else
      add_warning "APPCAST_EXTERNAL_IDENTITY_CHECK_COMMAND is not set; production identity validation is skipped."
    fi

    if [[ -z "$cache_invalidation_command" ]]; then
      if [[ "$strict_mode" -eq 1 ]]; then
        add_required "APPCAST_CACHE_INVALIDATION_COMMAND is required in strict mode for non-dry-run publication."
      else
        add_warning "APPCAST_CACHE_INVALIDATION_COMMAND is not set; cache invalidation will be skipped."
      fi
    elif [[ "$cache_invalidation_placeholder" -eq 1 ]]; then
      cache_invalidation_command_status="placeholder-detected"
    else
      cache_invalidation_command_status="configured"
    fi

    if [[ -n "$invalidation_check_command" ]]; then
      if [[ "$invalidation_placeholder" -eq 1 ]]; then
        invalidation_check_status="placeholder-detected"
      elif bash -lc "$invalidation_check_command"; then
        invalidation_check_status="executed"
      else
        invalidation_check_status="failed"
        add_required "APPCAST_EXTERNAL_INVALIDATION_CHECK_COMMAND execution failed."
      fi
    elif [[ "$strict_mode" -eq 1 ]]; then
      add_required "APPCAST_EXTERNAL_INVALIDATION_CHECK_COMMAND is required in strict mode for non-dry-run publication."
    else
      add_warning "APPCAST_EXTERNAL_INVALIDATION_CHECK_COMMAND is not set; invalidation validation is skipped."
    fi
  else
    identity_check_status="skipped-dry-run"
    invalidation_check_status="skipped-dry-run"
    cache_invalidation_command_status="skipped-dry-run"
  fi
else
  add_required "unsupported APPCAST_PUBLISH_PROVIDER: ${provider}"
fi

if [[ "$status" != "skipped" ]]; then
  if [[ "$required_count" -gt 0 ]]; then
    status="failed"
  elif [[ "$warning_count" -gt 0 ]]; then
    status="ready-with-warnings"
  else
    status="ready"
  fi
fi

{
  echo "# Appcast External Publication Readiness Report"
  echo
  echo "- Generated at (UTC): $timestamp"
  echo "- Strict mode: $strict_mode"
  echo "- Provider: $provider"
  echo "- Dry-run: $dry_run"
  echo "- Publication bundle path: $bundle_file"
  echo "- AWS credentials detected: $aws_credentials_detected"
  echo "- Identity check command configured: $([[ -n "$identity_check_command" ]] && echo yes || echo no)"
  echo "- Identity check status: $identity_check_status"
  echo "- Invalidation check command configured: $([[ -n "$invalidation_check_command" ]] && echo yes || echo no)"
  echo "- Invalidation check status: $invalidation_check_status"
  echo "- Cache invalidation command configured: $([[ -n "$cache_invalidation_command" ]] && echo yes || echo no)"
  echo "- Cache invalidation command status: $cache_invalidation_command_status"
  echo "- Placeholder command findings: $placeholder_command_count"
  echo "- Status: $status"
  echo
  echo "## Required checks"
  if [[ -n "$required_notes" ]]; then
    while IFS= read -r line; do
      echo "- $line"
    done <<< "$required_notes"
  else
    echo "- none"
  fi
  echo
  echo "## Advisory checks"
  if [[ -n "$warning_notes" ]]; then
    while IFS= read -r line; do
      echo "- $line"
    done <<< "$warning_notes"
  else
    echo "- none"
  fi
} > "$report_file"

if [[ "$status" == "failed" ]]; then
  if [[ "$strict_mode" -eq 1 ]]; then
    echo "[appcast-external-readiness] strict mode failed. report: $report_file" >&2
    exit 1
  fi
  echo "[appcast-external-readiness] warning: readiness checks failed in non-strict mode. report: $report_file"
  exit 0
fi

echo "[appcast-external-readiness] completed with status=${status}. report: $report_file"
