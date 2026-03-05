#!/usr/bin/env bash
set -eo pipefail

index_file="${1:-../docs/technical-guide/developer/desktop-flutter-release-evidence-index.md}"
report_file="${2:-release/reports/release_evidence_index_check_report.md}"
timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

mkdir -p "$(dirname "$report_file")"

trim_spaces() {
  printf '%s' "$1" | sed -E 's/^[[:space:]]+|[[:space:]]+$//g'
}

errors=0
line_no=0
table_row_count=0
validated_row_count=0
promoted_row_count=0
blocked_row_count=0
seen_keys_blob=$'\n'
issues=""
validated_rows=""
attachment_results=""

append_issue() {
  local message="$1"
  echo "[release-evidence-check] ${message}" >&2
  issues+="- ${message}"$'\n'
  errors=$((errors + 1))
}

append_validated_row() {
  local row_line="$1"
  local row_rc="$2"
  local row_platform="$3"
  local row_decision="$4"
  validated_rows+="- line ${row_line}: RC \`${row_rc}\`, platform \`${row_platform}\`, decision \`${row_decision}\`"$'\n'
}

append_attachment_result() {
  local attachment_path="$1"
  local status="$2"
  attachment_results+="- \`${attachment_path}\`: ${status}"$'\n'
}

write_report() {
  local status="passed"
  if [[ "$errors" -gt 0 ]]; then
    status="failed"
  fi

  {
    echo "# Release Evidence Index Check Report"
    echo
    echo "- Generated at (UTC): $timestamp"
    echo "- Index file: $index_file"
    echo "- Table rows scanned: $table_row_count"
    echo "- Valid rows: $validated_row_count"
    echo "- Promoted rows: $promoted_row_count"
    echo "- Blocked rows: $blocked_row_count"
    echo "- Required attachment checks: ${#required_attachment_paths[@]}"
    echo "- Errors: $errors"
    echo "- Status: $status"
    echo
    echo "## Validated rows"
    if [[ -n "$validated_rows" ]]; then
      printf '%s' "$validated_rows"
    else
      echo "- none"
    fi
    echo
    echo "## Required attachment checks"
    if [[ -n "$attachment_results" ]]; then
      printf '%s' "$attachment_results"
    else
      echo "- none"
    fi
    echo
    echo "## Errors"
    if [[ -n "$issues" ]]; then
      printf '%s' "$issues"
    else
      echo "- none"
    fi
  } > "$report_file"
}

required_attachment_paths=(
  "release/reports/release_script_syntax_report.md"
  "release/reports/release_script_syntax_contract_report.md"
  "release/reports/verify_test_coverage_contract_report.md"
  "release/reports/desktop_command_inventory_contract_report.md"
  "release/reports/verify_test_coverage_report.md"
  "release/reports/desktop_command_inventory_report.md"
  "release/reports/update_manifest_validation_report.md"
  "release/reports/update_manifest_contract_report.md"
  "release/reports/verify_stage_timing_report.md"
  "release/reports/release_evidence_bundle_check_macos.md"
  "release/reports/release_evidence_bundle_check_windows.md"
  "release/reports/release_smoke_gate_policy_contract_report.md"
  "release/reports/release_evidence_index_check_report.md"
  "release/reports/release_evidence_index_contract_report.md"
)

if [[ ! -f "$index_file" ]]; then
  append_issue "missing index file: $index_file"
else
  while IFS= read -r line; do
    line_no=$((line_no + 1))

    # Process only table rows and skip header/separator rows.
    if [[ "$line" != \|* ]]; then
      continue
    fi
    if [[ "$line" == *"|---|"* ]]; then
      continue
    fi
    if [[ "$line" == *"| RC |"* ]]; then
      continue
    fi

    table_row_count=$((table_row_count + 1))
    row_has_error=0

    separator_count="$(printf '%s' "$line" | tr -cd '|' | wc -c | tr -d ' ')"
    if [[ "$separator_count" -ne 9 ]]; then
      append_issue "line $line_no must contain exactly 8 columns: $line"
      row_has_error=1
      continue
    fi

    row_payload="${line#|}"
    row_payload="${row_payload%|}"
    IFS='|' read -r col_rc col_version col_platform col_manifest col_report col_ci col_execution col_decision <<< "$row_payload"

    rc="$(trim_spaces "$col_rc")"
    version="$(trim_spaces "$col_version")"
    platform="$(trim_spaces "$col_platform")"
    manifest="$(trim_spaces "$col_manifest")"
    report="$(trim_spaces "$col_report")"
    ci_run="$(trim_spaces "$col_ci")"
    execution_ref="$(trim_spaces "$col_execution")"
    decision="$(trim_spaces "$col_decision")"

    if [[ -z "$rc" || -z "$platform" || -z "$decision" ]]; then
      append_issue "line $line_no missing required RC/platform/decision field(s): $line"
      row_has_error=1
      continue
    fi

    key="$(printf '%s::%s' "$rc" "$(printf '%s' "$platform" | tr '[:upper:]' '[:lower:]')")"
    if [[ "$seen_keys_blob" == *$'\n'"$key"$'\n'* ]]; then
      append_issue "line $line_no duplicate RC+platform key detected: $key"
      row_has_error=1
      continue
    fi
    seen_keys_blob+="${key}"$'\n'

    normalized="$(printf '%s' "$line" | tr '[:upper:]' '[:lower:]')"
    decision_normalized="$(printf '%s' "$decision" | tr '[:upper:]' '[:lower:]')"

    has_promoted=0
    if [[ "$decision_normalized" == promoted* ]]; then
      has_promoted=1
      promoted_row_count=$((promoted_row_count + 1))
    fi

    has_blocked=0
    if [[ "$decision_normalized" == blocked* ]]; then
      has_blocked=1
      blocked_row_count=$((blocked_row_count + 1))
    fi

    if [[ $has_promoted -eq 0 && $has_blocked -eq 0 ]]; then
      append_issue "line $line_no has invalid decision value: $decision"
      row_has_error=1
      continue
    fi

    if [[ $has_promoted -eq 1 ]]; then
      if [[ "$normalized" == *"tbd"* ]]; then
        append_issue "line $line_no promoted row includes TBD field(s): $line"
        row_has_error=1
      fi

      if [[ "$normalized" == *"placeholder"* ]]; then
        append_issue "line $line_no promoted row includes placeholder value(s): $line"
        row_has_error=1
      fi

      if [[ -z "$version" || -z "$manifest" || -z "$report" || -z "$ci_run" || -z "$execution_ref" ]]; then
        append_issue "line $line_no promoted row has empty required evidence field(s): $line"
        row_has_error=1
      fi
    fi

    if [[ "$row_has_error" -eq 0 ]]; then
      validated_row_count=$((validated_row_count + 1))
      append_validated_row "$line_no" "$rc" "$platform" "$decision"
    fi
  done < "$index_file"

  for attachment_path in "${required_attachment_paths[@]}"; do
    if grep -Fq "$attachment_path" "$index_file"; then
      append_attachment_result "$attachment_path" "found"
    else
      append_attachment_result "$attachment_path" "missing"
      append_issue "missing required attachment reference: $attachment_path"
    fi
  done
fi

write_report

if [[ $errors -gt 0 ]]; then
  echo "[release-evidence-check] failed with $errors issue(s). report: $report_file" >&2
  exit 1
fi

echo "[release-evidence-check] passed. report: $report_file"
