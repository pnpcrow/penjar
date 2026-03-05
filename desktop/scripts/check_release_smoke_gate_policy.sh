#!/usr/bin/env bash
set -eo pipefail

report_file="${1:-release/reports/release_smoke_gate_policy_report.md}"

to_bool() {
  case "$(printf '%s' "${1:-0}" | tr '[:upper:]' '[:lower:]')" in
    1|true|yes|strict|on|enabled) echo 1 ;;
    *) echo 0 ;;
  esac
}

strict_signing_readiness="$(to_bool "${STRICT_SIGNING:-0}")"
strict_signing_execution="$(to_bool "${STRICT_SIGNING_EXECUTION:-0}")"
strict_signing_command_hooks="$(to_bool "${STRICT_SIGNING_COMMAND_HOOKS:-0}")"
strict_signing_placeholders="$(to_bool "${STRICT_SIGNING_PLACEHOLDERS:-0}")"
strict_signing_provenance="$(to_bool "${STRICT_SIGNING_PROVENANCE:-0}")"
strict_windows_installer_execution="$(to_bool "${STRICT_WINDOWS_INSTALLER_EXECUTION:-0}")"
strict_windows_installer_packaging="$(to_bool "${STRICT_WINDOWS_INSTALLER_PACKAGING:-0}")"
strict_windows_installer_naming="$(to_bool "${STRICT_WINDOWS_INSTALLER_NAMING:-0}")"
strict_windows_installer_provenance="$(to_bool "${STRICT_WINDOWS_INSTALLER_PROVENANCE:-0}")"
strict_release_evidence_bundle="$(to_bool "${STRICT_RELEASE_EVIDENCE_BUNDLE:-0}")"
publish_appcast_external="$(to_bool "${PUBLISH_APPCAST_EXTERNAL:-0}")"
appcast_publish_provider="$(printf '%s' "${APPCAST_PUBLISH_PROVIDER:-none}" | tr '[:upper:]' '[:lower:]')"
appcast_publish_dry_run="$(to_bool "${APPCAST_PUBLISH_DRY_RUN:-1}")"
allow_appcast_external_production="$(to_bool "${ALLOW_APPCAST_EXTERNAL_PRODUCTION:-0}")"
strict_appcast_external_readiness="$(to_bool "${STRICT_APPCAST_EXTERNAL_READINESS:-0}")"

timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
mkdir -p "$(dirname "$report_file")"

required_count=0
warning_count=0
required_notes=""
warning_notes=""

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

# Required policy relationships.
if [[ "$strict_signing_execution" -eq 1 && "$strict_signing_command_hooks" -eq 0 ]]; then
  add_required "STRICT_SIGNING_EXECUTION requires STRICT_SIGNING_COMMAND_HOOKS=1."
fi

if [[ "$strict_signing_execution" -eq 1 && "$strict_signing_readiness" -eq 0 ]]; then
  add_required "STRICT_SIGNING_EXECUTION requires STRICT_SIGNING=1."
fi

if [[ "$strict_signing_execution" -eq 1 && "$strict_signing_placeholders" -eq 0 ]]; then
  add_required "STRICT_SIGNING_EXECUTION requires STRICT_SIGNING_PLACEHOLDERS=1."
fi

if [[ "$strict_signing_provenance" -eq 1 && "$strict_signing_execution" -eq 0 ]]; then
  add_required "STRICT_SIGNING_PROVENANCE requires STRICT_SIGNING_EXECUTION=1."
fi

if [[ "$strict_signing_provenance" -eq 1 && "$strict_signing_readiness" -eq 0 ]]; then
  add_required "STRICT_SIGNING_PROVENANCE requires STRICT_SIGNING=1."
fi

if [[ "$strict_signing_provenance" -eq 1 && "$strict_signing_command_hooks" -eq 0 ]]; then
  add_required "STRICT_SIGNING_PROVENANCE requires STRICT_SIGNING_COMMAND_HOOKS=1."
fi

if [[ "$strict_signing_placeholders" -eq 1 && "$strict_signing_command_hooks" -eq 0 ]]; then
  add_required "STRICT_SIGNING_PLACEHOLDERS requires STRICT_SIGNING_COMMAND_HOOKS=1."
fi

if [[ "$strict_windows_installer_packaging" -eq 1 && "$strict_windows_installer_execution" -eq 0 ]]; then
  add_required "STRICT_WINDOWS_INSTALLER_PACKAGING requires STRICT_WINDOWS_INSTALLER_EXECUTION=1."
fi

if [[ "$strict_windows_installer_naming" -eq 1 && "$strict_windows_installer_execution" -eq 0 ]]; then
  add_required "STRICT_WINDOWS_INSTALLER_NAMING requires STRICT_WINDOWS_INSTALLER_EXECUTION=1."
fi

if [[ "$strict_windows_installer_naming" -eq 1 && "$strict_windows_installer_packaging" -eq 0 ]]; then
  add_required "STRICT_WINDOWS_INSTALLER_NAMING requires STRICT_WINDOWS_INSTALLER_PACKAGING=1."
fi

if [[ "$strict_windows_installer_provenance" -eq 1 && "$strict_windows_installer_execution" -eq 0 ]]; then
  add_required "STRICT_WINDOWS_INSTALLER_PROVENANCE requires STRICT_WINDOWS_INSTALLER_EXECUTION=1."
fi

if [[ "$strict_windows_installer_provenance" -eq 1 && "$strict_windows_installer_packaging" -eq 0 ]]; then
  add_required "STRICT_WINDOWS_INSTALLER_PROVENANCE requires STRICT_WINDOWS_INSTALLER_PACKAGING=1."
fi

if [[ "$strict_windows_installer_provenance" -eq 1 && "$strict_windows_installer_naming" -eq 0 ]]; then
  add_required "STRICT_WINDOWS_INSTALLER_PROVENANCE requires STRICT_WINDOWS_INSTALLER_NAMING=1."
fi

if [[ "$strict_release_evidence_bundle" -eq 1 && "$strict_signing_provenance" -eq 0 ]]; then
  add_required "STRICT_RELEASE_EVIDENCE_BUNDLE requires STRICT_SIGNING_PROVENANCE=1."
fi

if [[ "$strict_release_evidence_bundle" -eq 1 && "$strict_windows_installer_provenance" -eq 0 ]]; then
  add_required "STRICT_RELEASE_EVIDENCE_BUNDLE requires STRICT_WINDOWS_INSTALLER_PROVENANCE=1."
fi

if [[ "$publish_appcast_external" -eq 1 && "$appcast_publish_dry_run" -eq 0 && "$allow_appcast_external_production" -eq 0 ]]; then
  add_required "Non-dry-run external publication requires ALLOW_APPCAST_EXTERNAL_PRODUCTION=1."
fi

if [[ "$publish_appcast_external" -eq 1 && "$appcast_publish_provider" == "none" ]]; then
  add_required "PUBLISH_APPCAST_EXTERNAL=1 requires APPCAST_PUBLISH_PROVIDER to be configured."
fi

if [[ "$publish_appcast_external" -eq 1 && "$appcast_publish_provider" != "none" && "$appcast_publish_provider" != "s3" ]]; then
  add_required "Unsupported APPCAST_PUBLISH_PROVIDER for smoke policy: ${appcast_publish_provider}."
fi

if [[ "$publish_appcast_external" -eq 1 && "$appcast_publish_dry_run" -eq 0 && "$strict_appcast_external_readiness" -eq 0 ]]; then
  add_required "Non-dry-run external publication requires STRICT_APPCAST_EXTERNAL_READINESS=1."
fi

if [[ "$publish_appcast_external" -eq 1 && "$appcast_publish_dry_run" -eq 0 && "$strict_release_evidence_bundle" -eq 0 ]]; then
  add_required "Non-dry-run external publication requires STRICT_RELEASE_EVIDENCE_BUNDLE=1."
fi

# Advisory policy relationships.
if [[ "$publish_appcast_external" -eq 0 && "$strict_appcast_external_readiness" -eq 1 ]]; then
  add_warning "STRICT_APPCAST_EXTERNAL_READINESS is enabled while PUBLISH_APPCAST_EXTERNAL is disabled."
fi

if [[ "$publish_appcast_external" -eq 0 && "$allow_appcast_external_production" -eq 1 ]]; then
  add_warning "ALLOW_APPCAST_EXTERNAL_PRODUCTION is enabled while PUBLISH_APPCAST_EXTERNAL is disabled."
fi

if [[ "$publish_appcast_external" -eq 0 && "$appcast_publish_provider" != "none" ]]; then
  add_warning "APPCAST_PUBLISH_PROVIDER is set while PUBLISH_APPCAST_EXTERNAL is disabled."
fi

status="ready"
if [[ "$required_count" -gt 0 ]]; then
  status="failed"
elif [[ "$warning_count" -gt 0 ]]; then
  status="ready-with-warnings"
fi

{
  echo "# Release Smoke Gate Policy Report"
  echo
  echo "- Generated at (UTC): $timestamp"
  echo "- Status: $status"
  echo
  echo "## Effective gate toggles"
  echo "- STRICT_SIGNING: $strict_signing_readiness"
  echo "- STRICT_SIGNING_EXECUTION: $strict_signing_execution"
  echo "- STRICT_SIGNING_COMMAND_HOOKS: $strict_signing_command_hooks"
  echo "- STRICT_SIGNING_PLACEHOLDERS: $strict_signing_placeholders"
  echo "- STRICT_SIGNING_PROVENANCE: $strict_signing_provenance"
  echo "- STRICT_WINDOWS_INSTALLER_EXECUTION: $strict_windows_installer_execution"
  echo "- STRICT_WINDOWS_INSTALLER_PACKAGING: $strict_windows_installer_packaging"
  echo "- STRICT_WINDOWS_INSTALLER_NAMING: $strict_windows_installer_naming"
  echo "- STRICT_WINDOWS_INSTALLER_PROVENANCE: $strict_windows_installer_provenance"
  echo "- STRICT_RELEASE_EVIDENCE_BUNDLE: $strict_release_evidence_bundle"
  echo "- PUBLISH_APPCAST_EXTERNAL: $publish_appcast_external"
  echo "- APPCAST_PUBLISH_PROVIDER: $appcast_publish_provider"
  echo "- APPCAST_PUBLISH_DRY_RUN: $appcast_publish_dry_run"
  echo "- ALLOW_APPCAST_EXTERNAL_PRODUCTION: $allow_appcast_external_production"
  echo "- STRICT_APPCAST_EXTERNAL_READINESS: $strict_appcast_external_readiness"
  echo
  echo "## Required policy checks"
  if [[ -n "$required_notes" ]]; then
    while IFS= read -r line; do
      echo "- $line"
    done <<< "$required_notes"
  else
    echo "- none"
  fi
  echo
  echo "## Advisory policy checks"
  if [[ -n "$warning_notes" ]]; then
    while IFS= read -r line; do
      echo "- $line"
    done <<< "$warning_notes"
  else
    echo "- none"
  fi
} > "$report_file"

if [[ "$status" == "failed" ]]; then
  echo "[release-smoke-gate-policy] failed. report: $report_file" >&2
  exit 1
fi

if [[ "$status" == "ready-with-warnings" ]]; then
  echo "[release-smoke-gate-policy] warning: advisory checks found. report: $report_file"
  exit 0
fi

echo "[release-smoke-gate-policy] passed. report: $report_file"
