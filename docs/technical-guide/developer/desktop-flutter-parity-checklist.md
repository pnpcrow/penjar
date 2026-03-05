---
title: Desktop Flutter Parity Checklist
desc: Workflow-level parity checklist for the Flutter desktop full-port program.
---

# Desktop Flutter Parity Checklist

This checklist tracks user-facing workflow parity for the Flutter desktop full-port mandate.

## Related artifacts

- [Web + MCP + Desktop Documentation Map](/technical-guide/developer/web-mcp-documentation-map/)
- [Web + MCP + Desktop Delivery Roadmap](/technical-guide/developer/web-mcp-desktop-roadmap/)
- [Web + MCP + Desktop Detailed Implementation Plan](/technical-guide/developer/web-mcp-desktop-implementation-plan/)
- [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/)
- [Desktop Flutter Development Runbook](/technical-guide/developer/desktop-flutter-development-runbook/)
- [Desktop Flutter Auth Backend Contract Integration Plan](/technical-guide/developer/desktop-flutter-auth-backend-contract-integration-plan/)
- [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/)
- [Desktop Flutter Parity Acceptance Baseline](/technical-guide/developer/desktop-flutter-parity-acceptance-baseline/)
- [Desktop Flutter Release Validation Baseline](/technical-guide/developer/desktop-flutter-release-validation-baseline/)

## Checklist legend

- **Not started**: no Flutter implementation evidence yet.
- **In progress**: partial implementation or test evidence exists.
- **Done**: Flutter implementation + tests + diagnostics + docs completed.
- **Blocked**: temporary non-Flutter path with explicit blocker/owner/removal date.

## Workflow checklist

| Workflow domain | Representative workflow | Status | Owner | Evidence link | Notes |
|---|---|---|---|---|---|
| Authentication/session | Sign in, session restore, token refresh | In progress | Auth + Desktop Integration | [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/) | Flutter auth/session parity scaffold, parity test harness, runtime-switchable in-memory/remote-stub contract boundary, backend request metadata mapping, backend execution-path error propagation, backend response-driven state mutation wiring, auth snapshot store/seed seam, flutter_secure_storage-backed native credential-store adapter path, secure-store strict rollout/fallback controls, default-on secure-store rollout telemetry labels, runtime legacy auth-store command/file/mirror path decommission, strict decommission guard automation, runtime source-level decommission guard automation, backend auth normalization (flat+nested auth/session/token alias handling with explicit signed-out and flat+nested signed-out error-code precedence including error/error-list containers + numeric unauthorized/session-expiry codes + nested error/error-list status-detail message normalization), and auth backend contract fixture matrix baseline (including `result/data` envelope + `authState` alias coverage) are added; full backend contract integration is pending and tracked in [Desktop Flutter Auth Backend Contract Integration Plan](/technical-guide/developer/desktop-flutter-auth-backend-contract-integration-plan/). |
| Project lifecycle | Open project, switch files/pages | In progress | Workspace Navigation | [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/) | Flutter project lifecycle parity scaffold, parity test harness, runtime-switchable in-memory/remote-stub contract boundary, and backend response-driven state mutation wiring are added; backend contract/navigation integration is pending. |
| File lifecycle | Create/rename/open/delete file/page | In progress | Workspace Navigation | [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/) | Flutter file lifecycle parity scaffold, parity test harness, runtime-switchable in-memory/remote-stub contract boundary, and backend response-driven state mutation wiring are added; repository/file API integration is pending. |
| Canvas editing | Create/move/resize/style shapes | In progress | Workspace Core | [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/) | Flutter canvas parity scaffold, parity test harness, runtime-switchable in-memory/remote-stub contract boundary, and backend response-driven state mutation wiring are added; real renderer/contract integration is pending. |
| Asset management | Import/use assets | In progress | Workspace Core | [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/) | Flutter asset-management parity scaffold, parity test harness, runtime-switchable in-memory/remote-stub contract boundary, and backend response-driven state mutation wiring are added; shared asset contract integration is pending. |
| Collaboration context | Threads/presence awareness | In progress | Collaboration + Realtime | [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/) | Flutter collaboration parity scaffold, parity test harness, runtime-switchable in-memory/remote-stub contract boundary, and backend response-driven state mutation wiring are added; realtime backend integration is pending. |
| Inspect/code handoff | Inspect metadata extraction | In progress | Inspect/Handoff | [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/) | Flutter inspect/handoff parity scaffold, parity test harness, runtime-switchable in-memory/remote-stub contract boundary, and backend response-driven state mutation wiring are added; inspect contract payload integration is pending. |
| Export workflows | PNG/SVG export and save | In progress | Export Pipeline | [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/) | Flutter export-workflow parity scaffold, parity harness, runtime-switchable in-memory/remote-stub contract boundary, and backend response-driven state mutation wiring are added; backend export pipeline/native save integration is pending. |
| Diagnostics/recovery | Runtime health, reconnect, remediation | In progress | Platform Reliability | [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/) | Flutter diagnostics/recovery parity scaffold, parity harness, runtime-switchable in-memory/remote-stub contract boundary, HTTP health-probe remote transport gating, operation-level backend request metadata mapping, backend execution-path status propagation, and backend response-driven state mutation wiring are added; live telemetry/reconnect policy integration is pending. |

## Cross-cutting shell/release routing note

- Windows deep-link runtime handoff is covered by running-instance relay (`WM_COPYDATA` -> `onLaunchRoute`) and installer-pipeline protocol registration command-hook baseline (`PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND` with scheme/target overrides), with strict gate control (`STRICT_WINDOWS_PROTOCOL_REGISTRATION`) and helper script template (`desktop/scripts/register_windows_protocol.ps1`) available for release-smoke policy enforcement; production registry/installer command provisioning remains tracked as pending.

## Completion criteria per row

1. User-facing workflow path is implemented in Flutter desktop surface.
2. Equivalent acceptance tests exist (unit/integration/e2e where appropriate).
3. Operational diagnostics/recovery behavior is documented.
4. Linked execution evidence is recorded in Phase C execution log.
