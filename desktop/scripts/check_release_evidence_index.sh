#!/usr/bin/env bash
set -eo pipefail

index_file="${1:-../docs/technical-guide/developer/desktop-flutter-release-evidence-index.md}"

trim_spaces() {
  printf '%s' "$1" | sed -E 's/^[[:space:]]+|[[:space:]]+$//g'
}

if [[ ! -f "$index_file" ]]; then
  echo "[release-evidence-check] missing index file: $index_file" >&2
  exit 1
fi

errors=0
line_no=0
seen_keys_file="$(mktemp)"
trap 'rm -f "$seen_keys_file"' EXIT

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

  separator_count="$(printf '%s' "$line" | tr -cd '|' | wc -c | tr -d ' ')"
  if [[ "$separator_count" -ne 9 ]]; then
    echo "[release-evidence-check] line $line_no must contain exactly 8 columns: $line" >&2
    errors=$((errors + 1))
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
    echo "[release-evidence-check] line $line_no missing required RC/platform/decision field(s): $line" >&2
    errors=$((errors + 1))
    continue
  fi

  key="$(printf '%s::%s' "$rc" "$(printf '%s' "$platform" | tr '[:upper:]' '[:lower:]')")"
  if grep -Fxq "$key" "$seen_keys_file"; then
    echo "[release-evidence-check] line $line_no duplicate RC+platform key detected: $key" >&2
    errors=$((errors + 1))
    continue
  fi
  printf '%s\n' "$key" >> "$seen_keys_file"

  normalized="$(printf '%s' "$line" | tr '[:upper:]' '[:lower:]')"
  decision_normalized="$(printf '%s' "$decision" | tr '[:upper:]' '[:lower:]')"

  has_promoted=0
  if [[ "$decision_normalized" == promoted* ]]; then
    has_promoted=1
  fi

  has_blocked=0
  if [[ "$decision_normalized" == blocked* ]]; then
    has_blocked=1
  fi

  if [[ $has_promoted -eq 0 && $has_blocked -eq 0 ]]; then
    echo "[release-evidence-check] line $line_no has invalid decision value: $decision" >&2
    errors=$((errors + 1))
    continue
  fi

  if [[ $has_promoted -eq 1 ]]; then
    if [[ "$normalized" == *"tbd"* ]]; then
      echo "[release-evidence-check] line $line_no promoted row includes TBD field(s): $line" >&2
      errors=$((errors + 1))
    fi

    if [[ "$normalized" == *"placeholder"* ]]; then
      echo "[release-evidence-check] line $line_no promoted row includes placeholder value(s): $line" >&2
      errors=$((errors + 1))
    fi

    if [[ -z "$version" || -z "$manifest" || -z "$report" || -z "$ci_run" || -z "$execution_ref" ]]; then
      echo "[release-evidence-check] line $line_no promoted row has empty required evidence field(s): $line" >&2
      errors=$((errors + 1))
    fi
  fi

done < "$index_file"

required_attachment_paths=(
  "release/reports/release_script_syntax_report.md"
  "release/reports/release_script_syntax_contract_report.md"
  "release/reports/desktop_command_inventory_contract_report.md"
  "release/reports/verify_test_coverage_report.md"
  "release/reports/desktop_command_inventory_report.md"
  "release/reports/update_manifest_validation_report.md"
  "release/reports/verify_stage_timing_report.md"
  "release/reports/release_evidence_bundle_check_macos.md"
  "release/reports/release_evidence_bundle_check_windows.md"
  "release/reports/release_smoke_gate_policy_contract_report.md"
  "release/reports/release_evidence_index_contract_report.md"
)

for attachment_path in "${required_attachment_paths[@]}"; do
  if ! grep -Fq "$attachment_path" "$index_file"; then
    echo "[release-evidence-check] missing required attachment reference: $attachment_path" >&2
    errors=$((errors + 1))
  fi
done

if [[ $errors -gt 0 ]]; then
  echo "[release-evidence-check] failed with $errors issue(s)." >&2
  exit 1
fi

echo "[release-evidence-check] passed."
