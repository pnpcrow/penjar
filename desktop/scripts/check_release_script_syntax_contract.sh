#!/usr/bin/env bash
set -eo pipefail

report_file="${1:-release/reports/release_script_syntax_contract_report.md}"
timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

mkdir -p "$(dirname "$report_file")"

case_rows=""
failure_count=0
total_cases=0

append_case_row() {
  local case_name="$1"
  local expected="$2"
  local actual="$3"
  local report_assertions="$4"
  local result="$5"
  local summary="$6"
  case_rows+="| ${case_name} | ${expected} | ${actual} | ${report_assertions} | ${result} | ${summary} |"$'\n'
}

setup_recursive_valid_case() {
  local dir="$1"
  mkdir -p "$dir/lib"
  cat > "$dir/top_level.sh" <<'EOF'
#!/usr/bin/env bash
echo "top-level"
EOF
  cat > "$dir/lib/nested_helper.sh" <<'EOF'
#!/usr/bin/env bash
echo "nested-helper"
EOF
}

setup_recursive_nested_invalid_case() {
  local dir="$1"
  mkdir -p "$dir/lib"
  cat > "$dir/top_level.sh" <<'EOF'
#!/usr/bin/env bash
echo "top-level"
EOF
  cat > "$dir/lib/broken_nested.sh" <<'EOF'
#!/usr/bin/env bash
if [[ 1 -eq 1 ]]; then
  echo "broken"
EOF
}

setup_empty_case() {
  local dir="$1"
  mkdir -p "$dir"
}

run_case() {
  local case_name="$1"
  local expected="$2"
  local summary="$3"
  local setup_fn="$4"
  local required_patterns="$5"

  local tmp_dir tmp_report tmp_log rc actual result report_assertions missing_patterns
  tmp_dir="$(mktemp -d)"
  tmp_report="$(mktemp)"
  tmp_log="$(mktemp)"

  "$setup_fn" "$tmp_dir"

  set +e
  ./scripts/check_release_script_syntax.sh "$tmp_report" "$tmp_dir" >"$tmp_log" 2>&1
  rc=$?
  set -e

  actual="pass"
  if [[ "$rc" -ne 0 ]]; then
    actual="fail"
  fi

  report_assertions="ok"
  missing_patterns=""
  if [[ -n "$required_patterns" ]]; then
    local pattern
    IFS=';' read -r -a pattern_array <<< "$required_patterns"
    for pattern in "${pattern_array[@]}"; do
      [[ -z "$pattern" ]] && continue
      if ! grep -Fq "$pattern" "$tmp_report"; then
        if [[ -z "$missing_patterns" ]]; then
          missing_patterns="$pattern"
        else
          missing_patterns="${missing_patterns}, $pattern"
        fi
      fi
    done
    if [[ -n "$missing_patterns" ]]; then
      report_assertions="missing: ${missing_patterns}"
    fi
  fi

  result="ok"
  if [[ "$expected" != "$actual" || "$report_assertions" != "ok" ]]; then
    result="mismatch"
    failure_count=$((failure_count + 1))
  fi

  total_cases=$((total_cases + 1))
  append_case_row "$case_name" "$expected" "$actual" "$report_assertions" "$result" "$summary"

  rm -rf "$tmp_dir"
  rm -f "$tmp_report" "$tmp_log"
}

run_case \
  "recursive-valid-nested-pass" \
  "pass" \
  "Recursive scan should pass with valid top-level + nested scripts and include nested path in report." \
  setup_recursive_valid_case \
  "Scan mode: recursive;/lib/nested_helper.sh"

run_case \
  "recursive-invalid-nested-fail" \
  "fail" \
  "Recursive scan should fail when nested script has syntax error." \
  setup_recursive_nested_invalid_case \
  "Scan mode: recursive;/lib/broken_nested.sh"

run_case \
  "empty-directory-pass" \
  "pass" \
  "Empty script directory should pass with checked count 0 and explicit recursive scan mode." \
  setup_empty_case \
  "Scan mode: recursive;Checked script count: 0"

status="passed"
if [[ "$failure_count" -gt 0 ]]; then
  status="failed"
fi

{
  echo "# Release Script Syntax Contract Report"
  echo
  echo "- Generated at (UTC): $timestamp"
  echo "- Total cases: $total_cases"
  echo "- Failures: $failure_count"
  echo "- Status: $status"
  echo
  echo "| Case | Expected | Actual | Report assertions | Result | Summary |"
  echo "|---|---|---|---|---|---|"
  if [[ -n "$case_rows" ]]; then
    printf '%s' "$case_rows"
  else
    echo "| none | n/a | n/a | n/a | n/a | no cases executed |"
  fi
} > "$report_file"

if [[ "$failure_count" -gt 0 ]]; then
  echo "[release-script-syntax-contract] failed with ${failure_count} mismatch(es). report: $report_file" >&2
  exit 1
fi

echo "[release-script-syntax-contract] passed. report: $report_file"
