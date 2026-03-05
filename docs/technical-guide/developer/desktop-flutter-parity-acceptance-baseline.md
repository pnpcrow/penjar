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
- [Desktop Flutter Development Runbook](/technical-guide/developer/desktop-flutter-development-runbook/)
- [Desktop Flutter Release Validation Baseline](/technical-guide/developer/desktop-flutter-release-validation-baseline/)

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
- CI matrix baseline now runs Linux parity chain, macOS parity+build chain, and Windows parity chain.
- CI now uploads per-platform verification logs and macOS debug app artifact from parity workflow.
- Canonical desktop verification chain script: `desktop/scripts/verify_desktop.sh`.
- Local fast verification path is available through `SKIP_PUB_GET=1` (`desktop:verify:fast`, `desktop:verify:full:fast`) when dependency lock is unchanged.
- Canonical parity test-file list is managed in `desktop/scripts/run_parity_tests.sh` and consumed by root `desktop:test:parity` script + CI workflow.
- Contract-mode matrix script is managed in `desktop/scripts/run_mode_matrix_tests.sh` and consumed by root `desktop:test:mode-matrix` script + verification chain.
- Canonical parity list includes cross-cutting navigation persistence gate: `desktop/test/parity/shell_contract_persistence_parity_test.dart`.
- Canonical parity list includes cross-cutting runtime mode gate: `desktop/test/parity/remote_stub_mode_parity_test.dart`.
- Canonical parity list includes remote-stub unavailable-profile gate: `desktop/test/parity/remote_stub_unavailable_parity_test.dart`.
- Remote-stub degraded-path simulation now supports operation-scoped blocking via `PENJAR_DESKTOP_REMOTE_STUB_BLOCKED_OPERATIONS` (comma-separated operation IDs) in addition to global unavailable profile flag `PENJAR_DESKTOP_REMOTE_STUB_UNAVAILABLE`.
- Remote-stub transport now supports HTTP health-probe wiring via `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_HEALTH_URL` with optional timeout/status-code controls (`PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_TIMEOUT_MS`, `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_ALLOWED_STATUS_CODES`) plus reason override `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BLOCK_REASON`.
- Remote-stub transport now supports backend execution wiring via `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_BASE_URL` with optional timeout/auth/reason controls (`PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_TIMEOUT_MS`, `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_AUTH_TOKEN`, `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_BLOCK_REASON`).
- Scripted transport-level operation blocking remains available via `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BLOCKED_OPERATIONS` when HTTP health-probe URL is not configured.
- Remote-stub transport request contract now carries workflow/method/endpoint/payload metadata per operation so transport probes and future backend executors can validate request-shape parity.
- Backend execution failures now propagate operation-scoped remote-stub status text to workflow state surfaces via transport denial status.
- Backend execution success payloads can now drive workflow state transitions across auth/project/file/canvas/assets/collaboration/inspect/export/diagnostics remote-stub adapters, with delegate mutation fallback preserved when backend state payload is absent.
- Backend response parser now supports nested success envelopes (`result`, `data`) and status aliases (`message`, `detail`) for response-driven state transitions.
- Desktop shell route/state bridge now supports initial section-route seeding via `PENJAR_DESKTOP_INITIAL_SECTION` and selected-section restoration across restart (`shell_contract_persistence_parity_test.dart`).
- Desktop shell launch routing now supports deep-link/route argument parsing via `--penjar-section=...`, `--penjar-route=...`, and `penjar://...` section-route payloads.
- Desktop shell now includes host launch-route channel bridge (`penjar/desktop/launch_route`: `consumeLaunchRoute` + `onLaunchRoute`) with runtime host-pushed route event handling coverage, plus macOS URL-scheme registration and Windows running-instance route relay (`WM_COPYDATA` -> `onLaunchRoute`) baselines for `penjar://` deep-link handoff.
- Windows installer flow now includes protocol registration command-hook baseline (`PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND`) with optional `PENJAR_WINDOWS_PROTOCOL_SCHEME` / `PENJAR_WINDOWS_PROTOCOL_TARGET_PATH` overrides; real production registry/installer command provisioning remains pending.
- Remote-stub auth flow now includes auth snapshot store/seed seam, including startup auth-state seed parsing via `PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_JSON`.
- Remote-stub auth flow now supports file-backed snapshot persistence path via `PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_PATH` (contract store seam).
- Remote-stub auth flow now supports command-hook secure-store bridge controls via `PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_LOAD_COMMAND` and `PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_SAVE_COMMAND`.
- Remote-stub auth flow now supports flutter_secure_storage-backed native credential-store adapter path with default-on rollout (`PENJAR_DESKTOP_REMOTE_STUB_AUTH_SECURE_STORAGE_ENABLED` unset) plus explicit opt-out (`PENJAR_DESKTOP_REMOTE_STUB_AUTH_SECURE_STORAGE_ENABLED=false`) and optional key override `PENJAR_DESKTOP_REMOTE_STUB_AUTH_SECURE_STORAGE_KEY`.
- Secure-store rollout controls now include strict mode (`PENJAR_DESKTOP_REMOTE_STUB_AUTH_SECURE_STORAGE_STRICT`) and legacy mirror-write mode (`PENJAR_DESKTOP_REMOTE_STUB_AUTH_SECURE_STORAGE_MIRROR_LEGACY`) via composite auth-state-store path.
- Legacy auth-store retirement control now includes strict secure-store enforcement via `PENJAR_DESKTOP_REMOTE_STUB_AUTH_LEGACY_RETIREMENT_STRICT` (prevents legacy fallback/opt-out from overriding secure-store path).
- Environment-driven blocked-operation lists are filtered against `RemoteStubOperationIds` catalog in `desktop/lib/contracts/remote_stub_contracts.dart` to avoid unsupported operation keys.
- Diagnostics parity surface now includes runtime remote profile summary text (`Remote profile: ...`) including `auth-store` label for active auth snapshot persistence mode visibility during degraded-path validation.
