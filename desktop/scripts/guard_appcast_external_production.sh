#!/usr/bin/env bash
set -eo pipefail

report_file="${1:-release/reports/appcast_external_production_guard_report.md}"

provider="$(printf '%s' "${APPCAST_PUBLISH_PROVIDER:-none}" | tr '[:upper:]' '[:lower:]')"
dry_run_input="${APPCAST_PUBLISH_DRY_RUN:-1}"
allow_input="${ALLOW_APPCAST_EXTERNAL_PRODUCTION:-0}"

dry_run=0
case "$(printf '%s' "$dry_run_input" | tr '[:upper:]' '[:lower:]')" in
  1|true|yes|dry-run|dryrun) dry_run=1 ;;
esac

allow_production=0
case "$(printf '%s' "$allow_input" | tr '[:upper:]' '[:lower:]')" in
  1|true|yes|allow|production) allow_production=1 ;;
esac

timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
mkdir -p "$(dirname "$report_file")"

status="allowed"
error_message=""

if [[ "$provider" == "none" ]]; then
  status="skipped"
elif [[ "$provider" != "s3" ]]; then
  status="blocked"
  error_message="unsupported provider: ${provider}"
elif [[ "$dry_run" -eq 1 ]]; then
  status="dry-run"
elif [[ "$allow_production" -eq 1 ]]; then
  status="allowed"
else
  status="blocked"
  error_message="production publish requires ALLOW_APPCAST_EXTERNAL_PRODUCTION=1"
fi

{
  echo "# Appcast External Production Guard Report"
  echo
  echo "- Generated at (UTC): $timestamp"
  echo "- Provider: $provider"
  echo "- Dry-run: $dry_run"
  echo "- Allow production: $allow_production"
  echo "- Status: $status"
  if [[ -n "$error_message" ]]; then
    echo "- Error: $error_message"
  fi
} > "$report_file"

if [[ "$status" == "blocked" ]]; then
  echo "[appcast-external-production-guard] blocked. report: $report_file" >&2
  exit 1
fi

echo "[appcast-external-production-guard] status=${status}. report: $report_file"
