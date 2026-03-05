---
title: Desktop Flutter Parity Acceptance Baseline
desc: Executable acceptance baseline for workflow-level Flutter desktop parity validation.
---

# Desktop Flutter Parity Acceptance Baseline

This baseline defines the executable acceptance gate expected for each workflow row in the
[Desktop Flutter Parity Checklist](/technical-guide/developer/desktop-flutter-parity-checklist/).

No workflow row can be marked `Done` until its Flutter gate is implemented, executed, and recorded in
the [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/).

## Related artifacts

- [Web + MCP + Desktop Documentation Map](/technical-guide/developer/web-mcp-documentation-map/)
- [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/)
- [Desktop Flutter Parity Checklist](/technical-guide/developer/desktop-flutter-parity-checklist/)
- [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/)

## Gate status legend

- **Blocked**: Flutter workspace/module dependency not ready.
- **Planned**: gate definition exists, implementation not started.
- **In progress**: test harness exists, still failing or incomplete.
- **Ready**: gate passes in local/CI target matrix.
- **Verified**: gate plus execution-log evidence reviewed and accepted.

## Workflow acceptance baseline

| Workflow domain | Current evidence anchor | Required Flutter acceptance gate | Initial gate target | Status | Owner | Evidence |
|---|---|---|---|---|---|---|
| Authentication/session | [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/) (`Auth/session UI`) | Sign-in, session restore, token refresh parity integration test | `desktop/test/parity/auth_session_parity_test.dart` via `flutter test` | In progress | Auth + Desktop Integration | [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| Project lifecycle | [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/) (`Project lifecycle`) | Open/switch project parity integration test | `desktop/test/parity/project_lifecycle_parity_test.dart` via `flutter test` | In progress | Workspace Navigation | [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| File lifecycle | [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/) (`File lifecycle`) | File CRUD/navigation parity integration test | `desktop/test/parity/file_lifecycle_parity_test.dart` via `flutter test` | In progress | Workspace Navigation | [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| Canvas editing | [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/) (`Canvas interaction`) | Canvas edit semantics parity integration test | `desktop/test/parity/canvas_editing_parity_test.dart` via `flutter test` | In progress | Workspace Core | [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| Asset management | [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/) (`Asset management`) | Asset import/apply parity integration test | `desktop/test/parity/asset_management_parity_test.dart` via `flutter test` | In progress | Workspace Core | [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| Collaboration context | [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/) (`Collaboration context`) | Presence/thread continuity parity integration test | `desktop/test/parity/collaboration_context_parity_test.dart` via `flutter test` | In progress | Collaboration + Realtime | [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| Inspect/code handoff | [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/) (`Inspect/code handoff`) | Inspect metadata/code handoff parity integration test | `desktop/test/parity/inspect_handoff_parity_test.dart` via `flutter test` | In progress | Inspect/Handoff | [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| Export workflows | [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/) (`Export UX`) | Export option/output/save parity integration test | `desktop/test/parity/export_workflow_parity_test.dart` via `flutter test` | In progress | Export Pipeline | [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| Diagnostics/recovery | [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/) (`Diagnostics/recovery UX`) | Runtime health/reconnect/remediation parity test | `desktop/test/parity/diagnostics_recovery_parity_test.dart` via `flutter test` | In progress | Platform Reliability | [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| Contract runtime mode | [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/) (`Desktop shell/runtime`) | Runtime mode switch parity test (`in-memory` vs `remote-stub`) with status-surface verification | `desktop/test/parity/remote_stub_mode_parity_test.dart` via `flutter test` | In progress | Desktop Flutter Program | [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |

## Baseline execution protocol

1. Define or update the Flutter gate implementation for one workflow row.
2. Run the gate on target platforms (minimum: local primary platform + CI matrix platform).
3. Record run command/result and review notes in the Phase C execution log.
4. Update checklist/inventory status and evidence links in the same implementation unit.

## CI execution anchor

- Desktop parity CI baseline workflow: `.github/workflows/tests-desktop-flutter.yml`.
- Canonical desktop verification chain script: `desktop/scripts/verify_desktop.sh`.
- Canonical parity test-file list is managed in `desktop/scripts/run_parity_tests.sh` and consumed by root `desktop:test:parity` script + CI workflow.
- Contract-mode matrix script is managed in `desktop/scripts/run_mode_matrix_tests.sh` and consumed by root `desktop:test:mode-matrix` script + verification chain.
- Canonical parity list includes cross-cutting navigation persistence gate: `desktop/test/parity/shell_contract_persistence_parity_test.dart`.
- Canonical parity list includes cross-cutting runtime mode gate: `desktop/test/parity/remote_stub_mode_parity_test.dart`.
