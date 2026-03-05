#!/usr/bin/env bash
set -eo pipefail

bundle_file="${1:-release/reports/appcast_publication_bundle.json}"
report_file="${2:-release/reports/appcast_external_publication_report.md}"

if [[ ! -f "$bundle_file" ]]; then
  echo "[appcast-external-publish] missing bundle file: $bundle_file" >&2
  exit 1
fi

python_bin=""
if command -v python3 >/dev/null 2>&1; then
  python_bin="python3"
elif command -v python >/dev/null 2>&1; then
  python_bin="python"
else
  echo "[appcast-external-publish] python runtime is required (python3 or python)." >&2
  exit 1
fi

bundle_meta="$("$python_bin" - "$bundle_file" <<'PY'
import json
import sys

bundle_path = sys.argv[1]
with open(bundle_path, "r", encoding="utf-8") as fh:
    data = json.load(fh)

channel = data.get("channel")
version = data.get("latestVersion")
targets = data.get("targets")

if not isinstance(channel, str) or not channel:
    raise SystemExit(f"[appcast-external-publish] invalid channel in {bundle_path}")
if not isinstance(version, str) or not version:
    raise SystemExit(f"[appcast-external-publish] invalid latestVersion in {bundle_path}")
if not isinstance(targets, list) or not targets:
    raise SystemExit(f"[appcast-external-publish] invalid targets in {bundle_path}")

print(channel)
print(version)
for target in targets:
    path = target.get("path")
    if isinstance(path, str) and path:
        print(path)
PY
)"

channel="$(printf '%s\n' "$bundle_meta" | sed -n '1p')"
version="$(printf '%s\n' "$bundle_meta" | sed -n '2p')"
target_paths="$(printf '%s\n' "$bundle_meta" | tail -n +3)"

provider="$(printf '%s' "${APPCAST_PUBLISH_PROVIDER:-none}" | tr '[:upper:]' '[:lower:]')"
dry_run_input="${APPCAST_PUBLISH_DRY_RUN:-1}"
dry_run=0
case "$(printf '%s' "$dry_run_input" | tr '[:upper:]' '[:lower:]')" in
  1|true|yes|dry-run|dryrun) dry_run=1 ;;
esac

timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
mkdir -p "$(dirname "$report_file")"

status="skipped"
error_message=""
operations_log=""

run_op() {
  local line="$1"
  if [[ -z "$operations_log" ]]; then
    operations_log="$line"
  else
    operations_log="${operations_log}"$'\n'"$line"
  fi
}

if [[ "$provider" == "none" ]]; then
  status="skipped"
  run_op "provider=none; external publish skipped."
elif [[ "$provider" == "s3" ]]; then
  s3_bucket="${APPCAST_S3_BUCKET:-}"
  s3_prefix="${APPCAST_S3_PREFIX:-desktop/appcast}"
  if [[ -z "$s3_bucket" ]]; then
    error_message="APPCAST_S3_BUCKET is required for s3 provider"
    status="failed"
  else
    status="published"
    while IFS= read -r target_path; do
      [[ -z "$target_path" ]] && continue
      if [[ ! -f "$target_path" ]]; then
        error_message="missing target file: $target_path"
        status="failed"
        break
      fi

      target_name="$(basename "$target_path")"
      destination="s3://${s3_bucket%/}/${s3_prefix%/}/${target_name}"

      cache_control="public,max-age=31536000,immutable"
      if [[ "$target_name" == *"-latest.json" ]]; then
        cache_control="no-cache,max-age=60,must-revalidate"
      fi

      if [[ "$dry_run" -eq 1 ]]; then
        run_op "dry-run aws s3 cp \"$target_path\" \"$destination\" --cache-control \"$cache_control\" --content-type application/json"
      else
        run_op "aws s3 cp \"$target_path\" \"$destination\" --cache-control \"$cache_control\" --content-type application/json"
        aws s3 cp "$target_path" "$destination" --cache-control "$cache_control" --content-type application/json
      fi
    done <<< "$target_paths"

    if [[ "$status" == "published" ]]; then
      invalidate_command="${APPCAST_CACHE_INVALIDATION_COMMAND:-}"
      if [[ -n "$invalidate_command" ]]; then
        if [[ "$dry_run" -eq 1 ]]; then
          run_op "dry-run ${invalidate_command}"
        else
          run_op "$invalidate_command"
          bash -lc "$invalidate_command"
        fi
      fi
    fi
  fi
else
  status="failed"
  error_message="unsupported provider: $provider"
fi

{
  echo "# Appcast External Publication Report"
  echo
  echo "- Generated at (UTC): $timestamp"
  echo "- Provider: $provider"
  echo "- Dry-run: $dry_run"
  echo "- Channel: $channel"
  echo "- Version: $version"
  echo "- Status: $status"
  if [[ -n "$error_message" ]]; then
    echo "- Error: $error_message"
  fi
  echo
  echo "## Operations"
  if [[ -n "$operations_log" ]]; then
    echo '```text'
    printf '%s\n' "$operations_log"
    echo '```'
  else
    echo "_none_"
  fi
} > "$report_file"

if [[ "$status" == "failed" ]]; then
  echo "[appcast-external-publish] failed. report: $report_file" >&2
  exit 1
fi

echo "[appcast-external-publish] completed with status=${status}. report: $report_file"
