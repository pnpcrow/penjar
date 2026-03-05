#!/usr/bin/env bash
set -eo pipefail

extra_args=()

if [[ "${FLUTTER_NO_PUB:-0}" == "1" ]]; then
  extra_args+=(--no-pub)
fi

flutter test \
  "${extra_args[@]}" \
  test/parity/auth_session_parity_test.dart \
  test/parity/shell_contract_persistence_parity_test.dart \
  test/parity/project_lifecycle_parity_test.dart \
  test/parity/file_lifecycle_parity_test.dart \
  test/parity/canvas_editing_parity_test.dart \
  test/parity/asset_management_parity_test.dart \
  test/parity/collaboration_context_parity_test.dart \
  test/parity/inspect_handoff_parity_test.dart \
  test/parity/export_workflow_parity_test.dart \
  test/parity/diagnostics_recovery_parity_test.dart
