---
title: Desktop Flutter Migration Inventory
desc: Component-level inventory for tracking and decommissioning non-Flutter desktop paths.
---

# Desktop Flutter Migration Inventory

This inventory tracks remaining non-Flutter desktop paths and their decommission plans.

## Related artifacts

- [Web + MCP + Desktop Documentation Map](/technical-guide/developer/web-mcp-documentation-map/)
- [Web + MCP + Desktop Delivery Roadmap](/technical-guide/developer/web-mcp-desktop-roadmap/)
- [Web + MCP + Desktop Detailed Implementation Plan](/technical-guide/developer/web-mcp-desktop-implementation-plan/)
- [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/)
- [Desktop Flutter Development Runbook](/technical-guide/developer/desktop-flutter-development-runbook/)
- [Desktop Flutter Parity Checklist](/technical-guide/developer/desktop-flutter-parity-checklist/)
- [Desktop Flutter Parity Acceptance Baseline](/technical-guide/developer/desktop-flutter-parity-acceptance-baseline/)
- [Desktop Flutter Release Validation Baseline](/technical-guide/developer/desktop-flutter-release-validation-baseline/)

## Inventory rules

1. Every temporary non-Flutter path must have: blocker, owner, removal date.
2. Rows without blocker/owner/removal date are invalid and must not be treated as accepted exceptions.
3. Removal progress is reviewed in Phase C execution log updates.

## Migration inventory

| Area | Component/path | Current implementation | Target Flutter implementation | Blocker | Owner | Removal date | Status | Evidence |
|---|---|---|---|---|---|---|---|---|
| Flutter workspace bootstrap | `desktop/` (`lib/`, `macos/`, `windows/`, `test/`) | Flutter workspace created with macOS/Windows targets, baseline tests, static analysis, and macOS debug build validation | Extend baseline into feature modules and shared contract adapters | None (bootstrap completed on 2026-03-05) | Desktop Flutter Program | 2026-03-05 (completed) | Done | [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| Desktop shell/runtime | `frontend/src/app/main/ui.cljs`, `frontend/src/app/main/ui/routes.cljs`, `frontend/src/app/main/router.cljs` | Browser-first shell, route composition, and store-driven navigation live in ClojureScript UI runtime | Flutter shell with native window lifecycle + route/state bridge to shared contracts | Core Flutter shell is established; runtime-switchable in-memory/remote-stub contract routing, mode parity gate, operation-scoped remote-stub blocked-operation profile, scripted transport-client injection path, and operation-ID catalog/env filtering are implemented, but route/state integration and real backend transport implementation are pending | Desktop Flutter Program | 2026-05-15 | In progress | [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| Auth/session UI | `frontend/src/app/main/ui/auth.cljs`, `frontend/src/app/main/ui/auth/login.cljs`, `frontend/src/app/main/data/auth.cljs` | Auth entrypoints, login/recovery flows, and post-login redirect/session logic are web-only | Flutter auth/session flow with shared auth contract and secure desktop credential path | Baseline Flutter auth/session surface and runtime-switchable in-memory/remote-stub contract boundary are implemented; backend contract/session persistence wiring remains pending | Auth + Desktop Integration | 2026-05-31 | In progress | [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| Project lifecycle | `frontend/src/app/main/ui/dashboard.cljs`, `frontend/src/app/main/ui/dashboard/projects.cljs`, `frontend/src/app/main/data/dashboard.cljs` | Dashboard/recent/projects lifecycle is implemented in web dashboard surface | Flutter project lifecycle UI + state/events parity | Baseline Flutter project lifecycle surface and runtime-switchable in-memory/remote-stub contract boundary are implemented; backend contract wiring and real navigation integration remain pending | Workspace Navigation | 2026-06-15 | In progress | [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| File lifecycle | `frontend/src/app/main/ui/dashboard/files.cljs`, `frontend/src/app/main/data/project.cljs`, `frontend/src/app/main/data/dashboard.cljs` | File CRUD and file-list navigation are web dashboard interactions | Flutter file lifecycle UI + contract-compatible file operations | Baseline Flutter file lifecycle surface and runtime-switchable in-memory/remote-stub contract boundary are implemented; repository/file API integration remains pending | Workspace Navigation | 2026-06-30 | In progress | [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| Canvas interaction | `frontend/src/app/main/ui/workspace.cljs`, `frontend/src/app/main/ui/workspace/viewport.cljs`, `frontend/src/app/main/data/workspace/drawing.cljs` | Workspace viewport and drawing interactions run in web canvas runtime | Flutter canvas interaction layer with equivalent editing semantics | Baseline Flutter canvas editing surface and runtime-switchable in-memory/remote-stub contract boundary are implemented; real rendering engine/contract integration remains pending | Workspace Core | 2026-07-15 | In progress | [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| Asset management | `frontend/src/app/main/ui/workspace/sidebar/assets.cljs`, `frontend/src/app/main/data/workspace/assets.cljs`, `frontend/src/app/main/ui/workspace/libraries.cljs` | Asset/library browsing and application flows are web workspace sidebars | Flutter asset management surface with shared asset contract | Baseline Flutter asset management surface and runtime-switchable in-memory/remote-stub contract boundary are implemented; real asset service/library contract integration remains pending | Workspace Core | 2026-07-31 | In progress | [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| Collaboration context | `frontend/src/app/main/ui/workspace/comments.cljs`, `frontend/src/app/main/ui/workspace/presence.cljs`, `frontend/src/app/main/data/workspace/comments.cljs` | Comments/presence awareness and thread flows are web workspace interactions | Flutter collaboration UI (presence/threads) with parity diagnostics hooks | Baseline Flutter collaboration surface and runtime-switchable in-memory/remote-stub contract boundary are implemented; real presence/comment service integration remains pending | Collaboration + Realtime | 2026-08-15 | In progress | [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| Inspect/code handoff | `frontend/src/app/main/ui/inspect/code.cljs`, `frontend/src/app/main/ui/inspect/render.cljs`, `frontend/src/app/main/ui/inspect/exports.cljs` | Inspect rendering and code handoff panels are web-only components | Flutter inspect/handoff panels aligned with MCP inspect contracts | Baseline Flutter inspect/handoff surface and runtime-switchable in-memory/remote-stub contract boundary are implemented; real inspect contract binding and handoff payload transport remain pending | Inspect/Handoff | 2026-08-31 | In progress | [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| Export UX | `frontend/src/app/main/ui/exports/files.cljs`, `frontend/src/app/main/data/exports/files.cljs`, `frontend/src/app/main/ui/workspace/sidebar/options/menus/exports.cljs` | Export dialogs and export orchestration are implemented in web UI + data flows | Flutter export flow with parity in format/options/status and save UX | Baseline Flutter export workflow surface and runtime-switchable in-memory/remote-stub contract boundary are implemented; backend export pipeline and native save bridge integration remain pending | Export Pipeline | 2026-09-15 | In progress | [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |
| Diagnostics/recovery UX | `frontend/src/app/main/data/websocket.cljs`, `frontend/src/app/main/data/workspace/mcp.cljs`, `mcp/scripts/verify-live-evidence` | Web runtime handles ws/MCP events; diagnostics are script/tooling-centric and not surfaced via desktop-native UX | Flutter-native diagnostics/recovery surface with embedded MCP health and reconnect guidance | Baseline Flutter diagnostics/recovery surface and runtime-switchable in-memory/remote-stub contract boundary are implemented; live telemetry ingestion and reconnect policy orchestration remain pending | Platform Reliability | 2026-09-30 | In progress | [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) |

## Review cadence

- Weekly: update blocker/owner/removal date columns.
- Per release: verify status/evidence links against Phase C execution log.
