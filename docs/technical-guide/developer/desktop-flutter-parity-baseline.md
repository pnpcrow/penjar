---
title: Desktop Flutter Parity Baseline
desc: Consolidated parity checklist, migration inventory, and acceptance baseline for the Flutter desktop full-port program.
---

# Desktop Flutter Parity Baseline

This document consolidates workflow-level parity tracking, migration inventory, and acceptance gates
for the Flutter desktop full-port mandate. It replaces the previously separate parity checklist,
migration inventory, and parity acceptance baseline documents.

## Related artifacts

- [Web + MCP + Desktop Documentation Map](/technical-guide/developer/web-mcp-documentation-map/)
- [Web + MCP + Desktop Delivery Roadmap & Plan](/technical-guide/developer/web-mcp-desktop-roadmap/)
- [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/)
- [Desktop Flutter Development Runbook](/technical-guide/developer/desktop-flutter-development-runbook/)
- [Desktop Flutter Auth Backend Contract Integration Plan](/technical-guide/developer/desktop-flutter-auth-backend-contract-integration-plan/)
- [Desktop Flutter Release Validation](/technical-guide/developer/desktop-flutter-release-validation/)

## Status legend

- **Not started**: No Flutter implementation evidence yet.
- **In progress**: Partial implementation or test evidence exists.
- **Done**: Flutter implementation + tests + diagnostics + docs completed.
- **Blocked**: Temporary non-Flutter path with explicit blocker/owner/removal date.

## Gate status legend

- **Planned**: Gate definition exists, implementation not started.
- **In progress**: Test harness exists, still failing or incomplete.
- **Ready**: Gate passes in local/CI target matrix.
- **Verified**: Gate plus execution-log evidence reviewed and accepted.

## Inventory rules

1. Every temporary non-Flutter path must have: blocker, owner, removal date.
2. Rows without blocker/owner/removal date are invalid and must not be treated as accepted exceptions.
3. Removal progress is reviewed in Phase C execution log updates.

## Consolidated parity table

| Workflow domain | Representative workflow | Status | Owner | Removal date | Flutter acceptance gate | Gate status | Evidence |
|---|---|---|---|---|---|---|---|
| Authentication/session | Sign in, session restore, token refresh | In progress | Auth + Desktop Integration | 2026-05-31 | `desktop/test/parity/auth_session_parity_test.dart` | In progress | [Phase C Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| Project lifecycle | Open project, switch files/pages | In progress | Workspace Navigation | 2026-06-15 | `desktop/test/parity/project_lifecycle_parity_test.dart` | In progress | [Phase C Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| File lifecycle | Create/rename/open/delete file/page | In progress | Workspace Navigation | 2026-06-30 | `desktop/test/parity/file_lifecycle_parity_test.dart` | In progress | [Phase C Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| Canvas editing | Create/move/resize/style shapes | In progress | Workspace Core | 2026-07-15 | `desktop/test/parity/canvas_editing_parity_test.dart` | In progress | [Phase C Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| Asset management | Import/use assets | In progress | Workspace Core | 2026-07-31 | `desktop/test/parity/asset_management_parity_test.dart` | In progress | [Phase C Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| Collaboration context | Threads/presence awareness | In progress | Collaboration + Realtime | 2026-08-15 | `desktop/test/parity/collaboration_context_parity_test.dart` | In progress | [Phase C Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| Inspect/code handoff | Inspect metadata extraction | In progress | Inspect/Handoff | 2026-08-31 | `desktop/test/parity/inspect_handoff_parity_test.dart` | In progress | [Phase C Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| Export workflows | PNG/SVG export and save | In progress | Export Pipeline | 2026-09-15 | `desktop/test/parity/export_workflow_parity_test.dart` | In progress | [Phase C Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| Diagnostics/recovery | Runtime health, reconnect, remediation | In progress | Platform Reliability | 2026-09-30 | `desktop/test/parity/diagnostics_recovery_parity_test.dart` | In progress | [Phase C Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| Contract runtime mode | Runtime mode switch (in-memory vs remote-stub) | In progress | Desktop Flutter Program | — | `desktop/test/parity/remote_stub_mode_parity_test.dart` | In progress | [Phase C Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |

## Migration inventory: current web sources → Flutter targets

| Area | Current web implementation | Target Flutter implementation | Pending integration |
|---|---|---|---|
| Flutter workspace bootstrap | `desktop/` (`lib/`, `macos/`, `windows/`, `test/`) | Extend baseline into feature modules and shared contract adapters | Done (completed 2026-03-05) |
| Desktop shell/runtime | `frontend/src/app/main/ui.cljs`, routes, router | Flutter shell with native window lifecycle + route/state bridge | Production Windows protocol handler rollout, durable backend session persistence |
| Auth/session UI | `frontend/src/app/main/ui/auth*.cljs`, `data/auth.cljs` | Flutter auth/session flow with shared auth contract + secure credential path | Per-stage rollout execution evidence, full backend contract integration via [Auth Backend Contract Integration Plan](/technical-guide/developer/desktop-flutter-auth-backend-contract-integration-plan/) |
| Project lifecycle | `frontend/src/app/main/ui/dashboard.cljs`, projects/data | Flutter project lifecycle UI + state/events parity | Backend contract wiring + real navigation integration |
| File lifecycle | `frontend/src/app/main/ui/dashboard/files.cljs`, project/data | Flutter file lifecycle UI + contract-compatible file operations | Repository/file API integration |
| Canvas interaction | `frontend/src/app/main/ui/workspace.cljs`, viewport, drawing | Flutter canvas interaction layer with equivalent editing semantics | Real rendering engine/contract integration |
| Asset management | `frontend/src/app/main/ui/workspace/sidebar/assets.cljs` | Flutter asset management surface with shared asset contract | Real asset service/library contract integration |
| Collaboration context | `frontend/src/app/main/ui/workspace/comments.cljs`, presence | Flutter collaboration UI (presence/threads) with parity diagnostics | Real presence/comment service integration |
| Inspect/code handoff | `frontend/src/app/main/ui/inspect/code.cljs`, render, exports | Flutter inspect/handoff panels aligned with MCP inspect contracts | Real inspect contract binding and handoff payload transport |
| Export UX | `frontend/src/app/main/ui/exports/files.cljs`, export data | Flutter export flow with parity in format/options/status and save UX | Backend export pipeline and native save bridge integration |
| Diagnostics/recovery UX | `frontend/src/app/main/data/websocket.cljs`, workspace/mcp | Flutter-native diagnostics/recovery surface with embedded MCP health | Live telemetry ingestion and reconnect policy orchestration |

## Implementation highlights

All workflow domains share the following baseline capabilities already implemented in the Flutter desktop scaffold:

- Runtime-switchable in-memory/remote-stub contract boundary
- Backend response-driven state mutation wiring
- Sibling `result`/`data` envelope fallback regression coverage (contract + parity suites)
- Operation-scoped remote-stub blocking via `PENJAR_DESKTOP_REMOTE_STUB_BLOCKED_OPERATIONS`
- HTTP health-probe transport gating via `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_HEALTH_URL`
- Backend execution transport via `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_BASE_URL`
- Deep envelope-chain traversal with cycle-safe guards, sibling-envelope fallback
- Section-route initialization/restoration and deep-link parsing (`penjar://`)

### Authentication/session specifics

The authentication flow includes extensive backend normalization capabilities:

- **Alias support**: Flat+nested token/session/user/authentication alias inference with snake_case and camelCase variants for signed-in, signed-out, remember, and failure-flag fields
- **Backend error handling**: Numeric unauthorized/session-expiry codes (401/403/419/440), error-code container traversal, failure-flag aliases (`ok`/`isSuccess`/`is_success`/etc.), mixed-alias explicit-false precedence
- **Secure storage**: `flutter_secure_storage`-backed credential-store adapter with default-on rollout, strict fallback controls, and runtime legacy auth-store decommission
- **Schema strictness**: Optional `strictBackendSchema` gate, required backend-state mode (`requireBackendState`), sign-in credential-forwarding toggle
- **Operation-scoped endpoint overrides**: Per-auth-operation backend endpoint override wiring
- **Decommission guards**: Automated legacy auth-store and runtime source-level decommission verification scripts

Detailed per-unit implementation evidence is tracked in the [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/).

### Shell/routing specifics

- macOS URL-scheme registration (`penjar://`)
- Windows running-instance route relay (`WM_COPYDATA` → `onLaunchRoute`)
- Windows installer-pipeline protocol registration command-hook baseline (`PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND`)
- Host launch-route channel bridge (`consumeLaunchRoute` + `onLaunchRoute`)

## Acceptance baseline execution protocol

1. Define or update the Flutter gate implementation for one workflow row.
2. Run the gate on target platforms (minimum: local primary platform + CI matrix platform).
3. Record run command/result and review notes in the Phase C execution log.
4. Update status and evidence links in this document in the same implementation unit.

## CI execution anchor

- Desktop parity CI baseline workflow: `.github/workflows/tests-desktop-flutter.yml`.
- CI matrix runs Linux parity chain, macOS parity+build chain, and Windows parity chain.
- Canonical desktop verification chain script: `desktop/scripts/verify_desktop.sh`.
- Local fast verification path: `SKIP_PUB_GET=1` when dependency lock is unchanged.
- Canonical parity test-file list: `desktop/scripts/run_parity_tests.sh`.
- Contract-mode matrix script: `desktop/scripts/run_mode_matrix_tests.sh`.

## Completion criteria per row

1. User-facing workflow path is implemented in Flutter desktop surface.
2. Equivalent acceptance tests exist (unit/integration/e2e where appropriate).
3. Operational diagnostics/recovery behavior is documented.
4. Linked execution evidence is recorded in Phase C execution log.

## Review cadence

- Weekly: update status/owner/removal date columns.
- Per release: verify status/evidence links against Phase C execution log.
