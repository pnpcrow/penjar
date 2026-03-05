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
- [Desktop Flutter Auth Backend Contract Integration Plan](/technical-guide/developer/desktop-flutter-auth-backend-contract-integration-plan/)
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
| Authentication/session | [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/) (`Auth/session UI`) | Sign-in, session restore, token refresh parity integration test aligned with [Desktop Flutter Auth Backend Contract Integration Plan](/technical-guide/developer/desktop-flutter-auth-backend-contract-integration-plan/) | `desktop/test/parity/auth_session_parity_test.dart` via `flutter test` | In progress | Auth + Desktop Integration | [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
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
- Windows installer flow now includes protocol registration command-hook baseline (`PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND`) with optional `PENJAR_WINDOWS_PROTOCOL_SCHEME` / `PENJAR_WINDOWS_PROTOCOL_TARGET_PATH` overrides, strict gate control (`STRICT_WINDOWS_PROTOCOL_REGISTRATION`), and helper script template (`desktop/scripts/register_windows_protocol.ps1`); real production registry/installer command provisioning remains pending.
- Remote-stub auth flow now includes auth snapshot store/seed seam, including startup auth-state seed parsing via `PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_JSON`.
- Remote-stub auth flow now supports flutter_secure_storage-backed native credential-store adapter path with default-on rollout (`PENJAR_DESKTOP_REMOTE_STUB_AUTH_SECURE_STORAGE_ENABLED` unset) plus explicit opt-out (`PENJAR_DESKTOP_REMOTE_STUB_AUTH_SECURE_STORAGE_ENABLED=false`) and optional key override `PENJAR_DESKTOP_REMOTE_STUB_AUTH_SECURE_STORAGE_KEY`.
- Secure-store rollout controls include strict read-fallback mode (`PENJAR_DESKTOP_REMOTE_STUB_AUTH_SECURE_STORAGE_STRICT`) in runtime auth-store resolution.
- Legacy auth-store command/file/mirror env inputs are runtime-decommissioned for auth-store resolution (`PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_PATH`, `PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_LOAD_COMMAND`, `PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_SAVE_COMMAND`, `PENJAR_DESKTOP_REMOTE_STUB_AUTH_SECURE_STORAGE_MIRROR_LEGACY`).
- Legacy auth-store decommission guard automation is available via `pnpm run desktop:auth-store:legacy-decommission:check` and `pnpm run desktop:auth-store:legacy-decommission:contract:check`, with strict enforcement (`STRICT_AUTH_STORE_LEGACY_DECOMMISSION=1`) in verification baseline.
- Runtime source-level auth-store decommission guard automation is available via `pnpm run desktop:auth-store:runtime-decommission:check` and `pnpm run desktop:auth-store:runtime-decommission:contract:check`.
- Remote-stub auth backend response parsing now normalizes flat+nested alias payloads for remember/signed-in fields (`remember`, `persistSession`, `isAuthenticated`, `authenticated`) and token/session/user hints (`accessToken`, `token`, `sessionToken`, `refreshToken`, `sessionId`, `user`) across `auth`/`authentication`, `session`, and `tokens` payloads, with explicit signed-out override precedence and flat+nested signed-out backend error-code precedence (`AUTH_REQUIRED`, `TOKEN_EXPIRED`, etc.) including `error`/`errors`/`failure` container payloads, numeric unauthorized/session-expiry codes (`401`, `403`, `419`, `440`), status-code alias extraction support (`statusCode`, `httpStatus`, `status_code`, `http_status`) with camelCase/snake_case regression coverage, snake_case failure-flag alias coverage (`is_success`, `is_ok`), nested error/error-list status-detail message normalization, deterministic code-only/failure-only fallback status mapping (`Authentication required.` / `Backend session expired.` / `Backend auth request failed.`) when explicit status/message/detail is absent, expanded session-expiry code variant normalization (`SESSION_TIMEOUT`, `EXPIRED_TOKEN`), cached backend code normalization regex helper usage for classifier hot paths, and explicit signed-in precedence regression coverage for code/failure-flag variants.
- Auth parser now treats explicit backend failure flags (`success`, `ok`, `isSuccess`, `is_success`, `is_ok`) set to false as signed-out inference precedence when explicit signed-in aliases are absent, including nested `error`/`meta` container variants.
- Signed-out precedence now forces signed-out transitions from previously signed-in snapshots when backend signed-out error-code or explicit failure-flag signals are present without explicit signed-in aliases.
- Auth contract now supports strict malformed-backend-auth schema fallback gate (`RemoteStubAuthSessionContract.strictBackendSchema`) that blocks delegate fallback when backend payload is present but does not satisfy auth-state parser schema, with strict malformed-payload auth parity UI coverage in `desktop/test/parity/remote_stub_mode_parity_test.dart`.
- Desktop contract bundle now forwards strict backend-auth schema mode through `DesktopContractBundle.fromMode(...)`, with environment toggle support via `PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_SCHEMA_STRICT` in `fromEnvironment()` and `loadFromEnvironment()`.
- Auth contract now supports optional required backend-auth state mode (`RemoteStubAuthSessionContract.requireBackendState`) that blocks delegate fallback when backend auth payload is missing/malformed, with runtime toggle `PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_REQUIRE_STATE` (auto-enabled by default for backend execution transport, explicit `false` opt-out supported).
- Desktop auth transport payload policy now supports optional sign-in credential forwarding via `PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_FORWARD_CREDENTIALS`; default behavior remains sanitized (`passwordLength` without raw password).
- HTTP backend auth non-2xx responses are now normalized into auth payload snapshots (`code`/`message`) so parser-driven auth state/status handling runs instead of transport-only block surfacing.
- Runtime remote profile summary now surfaces sign-in payload forwarding mode as `auth-sign-in-payload: forwarded` when credential forwarding is enabled.
- Runtime remote profile summary now surfaces strict auth backend schema mode as `auth-backend-schema: strict` for diagnostics visibility, with parity UI coverage in `desktop/test/parity/remote_stub_mode_parity_test.dart`.
- Runtime remote profile summary now surfaces required backend-auth state mode as `auth-backend-state: required`, with parity UI coverage in `desktop/test/parity/remote_stub_mode_parity_test.dart`.
- Parity UI coverage now includes backend unauthorized refresh transition from prior signed-in status in `desktop/test/parity/remote_stub_mode_parity_test.dart`.
- Parity UI coverage now includes required backend-auth state mode fallback blocking behavior for empty sign-in backend responses in `desktop/test/parity/remote_stub_mode_parity_test.dart`.
- Parity UI coverage now includes auto-enabled required backend-auth state behavior for backend execution transport profiles in `desktop/test/parity/remote_stub_mode_parity_test.dart`.
- Auth-session parity suite now includes backend integration flow coverage in `desktop/test/parity/auth_session_parity_test.dart` (backend snapshot sign-in/signed-out transition + required-state fallback blocking + code-only backend failure status mapping + statusCode/status_code unauthorized mapping + snake-case failure-flag auth-failed mapping + session-timeout session-expired mapping).
- Auth backend contract fixture matrix baseline is now maintained in `desktop/test/contracts/workflow_contracts_test.dart` (`auth backend contract fixture: ...` cases), including `result/data` envelope + `authState` alias coverage, status-code alias extraction coverage (`statusCode` / `httpStatus` / `status_code` / `http_status`), and explicit signed-in precedence regression cases for `SESSION_TIMEOUT` / `EXPIRED_TOKEN`, statusCode/status_code unauthorized variants, and snake-case failure-flag variants, to lock normalized signed-in/status precedence behavior before real backend auth contract binding.
- Environment-driven blocked-operation lists are filtered against `RemoteStubOperationIds` catalog in `desktop/lib/contracts/remote_stub_contracts.dart` to avoid unsupported operation keys.
- Diagnostics parity surface now includes runtime remote profile summary text (`Remote profile: ...`) including `auth-store` label for active auth snapshot persistence mode visibility during degraded-path validation.
