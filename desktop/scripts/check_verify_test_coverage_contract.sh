#!/usr/bin/env bash
set -eo pipefail

report_file="${1:-release/reports/verify_test_coverage_contract_report.md}"
source_checker="${2:-scripts/check_verify_test_coverage.sh}"
timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

if [[ ! -f "$source_checker" ]]; then
  echo "[verify-test-coverage-contract] source checker not found: $source_checker" >&2
  exit 1
fi

mkdir -p "$(dirname "$report_file")"

case_rows=""
failure_count=0
total_cases=0

append_case_row() {
  local case_name="$1"
  local expected="$2"
  local actual="$3"
  local report_assertion="$4"
  local result="$5"
  local summary="$6"
  case_rows+="| ${case_name} | ${expected} | ${actual} | ${report_assertion} | ${result} | ${summary} |"$'\n'
}

make_workspace_base() {
  local root_dir="$1"
  mkdir -p "$root_dir/scripts" "$root_dir/test/contracts" "$root_dir/test/parity"
  cp "$source_checker" "$root_dir/scripts/check_verify_test_coverage.sh"
  chmod +x "$root_dir/scripts/check_verify_test_coverage.sh"

  cat > "$root_dir/test/contracts/a_test.dart" <<'EOF'
void main() {}
EOF

  cat > "$root_dir/test/parity/b_test.dart" <<'EOF'
void main() {}
EOF

  cat > "$root_dir/test/widget_test.dart" <<'EOF'
void main() {}
EOF

  cat > "$root_dir/scripts/run_contract_tests.sh" <<'EOF'
#!/usr/bin/env bash
set -eo pipefail
flutter test test/contracts/a_test.dart
EOF

  cat > "$root_dir/scripts/run_parity_tests.sh" <<'EOF'
#!/usr/bin/env bash
set -eo pipefail
flutter test test/parity/b_test.dart
EOF

  cat > "$root_dir/scripts/run_mode_matrix_tests.sh" <<'EOF'
#!/usr/bin/env bash
set -eo pipefail
flutter test test/widget_test.dart
EOF

  chmod +x \
    "$root_dir/scripts/run_contract_tests.sh" \
    "$root_dir/scripts/run_parity_tests.sh" \
    "$root_dir/scripts/run_mode_matrix_tests.sh"
}

setup_baseline_case() {
  local root_dir="$1"
  make_workspace_base "$root_dir"
}

setup_uncovered_test_case() {
  local root_dir="$1"
  make_workspace_base "$root_dir"
  cat > "$root_dir/test/parity/uncovered_test.dart" <<'EOF'
void main() {}
EOF
}

setup_missing_referenced_case() {
  local root_dir="$1"
  make_workspace_base "$root_dir"
  cat >> "$root_dir/scripts/run_mode_matrix_tests.sh" <<'EOF'
flutter test test/parity/missing_test.dart
EOF
}

setup_unexpected_duplicate_case() {
  local root_dir="$1"
  make_workspace_base "$root_dir"
  cat >> "$root_dir/scripts/run_parity_tests.sh" <<'EOF'
flutter test test/contracts/a_test.dart
EOF
}

setup_allowed_duplicate_case() {
  local root_dir="$1"
  make_workspace_base "$root_dir"
  cat >> "$root_dir/scripts/run_parity_tests.sh" <<'EOF'
flutter test test/widget_test.dart
EOF
}

run_case() {
  local case_name="$1"
  local expected="$2"
  local summary="$3"
  local setup_fn="$4"
  local required_report_pattern="${5:-}"
  local duplicate_allow_override="${6:-}"

  local tmp_root tmp_report tmp_log rc actual result report_assertion
  tmp_root="$(mktemp -d)"
  tmp_report="$tmp_root/case_report.md"
  tmp_log="$tmp_root/case_log.txt"

  "$setup_fn" "$tmp_root"

  set +e
  if [[ -n "$duplicate_allow_override" ]]; then
    (
      cd "$tmp_root" && \
      VERIFY_TEST_COVERAGE_ALLOW_DUPLICATES="$duplicate_allow_override" \
      ./scripts/check_verify_test_coverage.sh "$tmp_report" test
    ) >"$tmp_log" 2>&1
  else
    (cd "$tmp_root" && ./scripts/check_verify_test_coverage.sh "$tmp_report" test) >"$tmp_log" 2>&1
  fi
  rc=$?
  set -e

  actual="pass"
  if [[ "$rc" -ne 0 ]]; then
    actual="fail"
  fi

  report_assertion="ok"
  if [[ -n "$required_report_pattern" ]]; then
    if ! grep -Fq "$required_report_pattern" "$tmp_report"; then
      report_assertion="missing: ${required_report_pattern}"
    fi
  fi

  result="ok"
  if [[ "$expected" != "$actual" || "$report_assertion" != "ok" ]]; then
    result="mismatch"
    failure_count=$((failure_count + 1))
  fi

  total_cases=$((total_cases + 1))
  append_case_row "$case_name" "$expected" "$actual" "$report_assertion" "$result" "$summary"

  rm -rf "$tmp_root"
}

run_case \
  "baseline-pass" \
  "pass" \
  "Baseline runner/test mapping should pass coverage guard." \
  setup_baseline_case \
  "Status: passed"

run_case \
  "uncovered-test-fail" \
  "fail" \
  "Discovered but unreferenced tests should fail coverage guard." \
  setup_uncovered_test_case \
  "test/parity/uncovered_test.dart"

run_case \
  "missing-referenced-test-fail" \
  "fail" \
  "Runner references to non-existent tests should fail coverage guard." \
  setup_missing_referenced_case \
  "test/parity/missing_test.dart"

run_case \
  "unexpected-duplicate-fail" \
  "fail" \
  "Unexpected duplicate test references should fail coverage guard." \
  setup_unexpected_duplicate_case \
  "test/contracts/a_test.dart (count=2;"

run_case \
  "allowed-duplicate-pass" \
  "pass" \
  "Configured allowed duplicates should not fail coverage guard." \
  setup_allowed_duplicate_case \
  "test/widget_test.dart (count=2;" \
  "test/widget_test.dart"

status="passed"
if [[ "$failure_count" -gt 0 ]]; then
  status="failed"
fi

{
  echo "# Verify Test Coverage Contract Report"
  echo
  echo "- Generated at (UTC): $timestamp"
  echo "- Source checker: $source_checker"
  echo "- Total cases: $total_cases"
  echo "- Failures: $failure_count"
  echo "- Status: $status"
  echo
  echo "| Case | Expected | Actual | Report assertion | Result | Summary |"
  echo "|---|---|---|---|---|---|"
  if [[ -n "$case_rows" ]]; then
    printf '%s' "$case_rows"
  else
    echo "| none | n/a | n/a | n/a | n/a | no cases executed |"
  fi
} > "$report_file"

if [[ "$failure_count" -gt 0 ]]; then
  echo "[verify-test-coverage-contract] failed with ${failure_count} mismatch(es). report: $report_file" >&2
  exit 1
fi

echo "[verify-test-coverage-contract] passed. report: $report_file"
