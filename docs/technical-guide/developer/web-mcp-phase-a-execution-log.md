---
title: Web + MCP Phase A Execution Log
desc: Detailed implementation record and unit-by-unit review log for Phase A delivery work.
---

# Web + MCP Phase A Execution Log

This log records execution work for Phase A tasks from the
[Delivery Roadmap & Plan](/technical-guide/developer/web-mcp-desktop-roadmap/).

## Linked planning and tracking artifacts

- Navigation and update protocol:
  - [Web + MCP + Desktop Documentation Map](/technical-guide/developer/web-mcp-documentation-map/)
- Upstream planning:
  - [Web + MCP + Desktop Delivery Roadmap](/technical-guide/developer/web-mcp-desktop-roadmap/)
- Parallel tracking/evidence:
  - [Web ↔ MCP Capability Matrix](/technical-guide/developer/web-mcp-capability-matrix/)
  - [Web + MCP Phase A Ticket Seed](/technical-guide/developer/web-mcp-phase-a-ticket-seed/)
  - [Web ↔ MCP Auth/Session Recovery Contract](/technical-guide/developer/web-mcp-auth-session-recovery-contract/)

## Execution baseline

- Active plan scope: **WS-B (Setup and operability)** in Phase A.
- Work date: **2026-03-04**.
- Delivery rule applied: implementation-first (runtime + diagnostics + docs, then review).

## Strategic decision note (2026-03-05)

- Desktop objective is confirmed as a **full Flutter port** for user-facing workflows.
- Temporary non-Flutter desktop paths are allowed only as explicitly blocked transition items with owner and removal deadline.
- Policy anchors:
  - [Web + MCP + Desktop Delivery Roadmap](/technical-guide/developer/web-mcp-desktop-roadmap/)

## Unit WS-B-01: Preflight and bootstrap hardening

### Planned objective

Reduce setup failure rate by validating environment prerequisites before install/build/start.

### Implemented changes

1. Added `mcp/scripts/preflight`:
   - validates workspace layout,
   - validates `node`, `corepack`, `pnpm`,
   - checks default MCP runtime ports (`4400`, `4401`, `4402`, `4403`) with env override support,
   - emits actionable remediation instructions when checks fail.
2. Updated `mcp/scripts/setup` to invoke preflight before dependency installation.
3. Updated `mcp/package.json`:
   - added `pnpm run preflight`,
   - prepended preflight to `bootstrap` and `bootstrap:multi-user`.
4. Added plugin preview port configurability through `PENJAR_MCP_PLUGIN_PORT` in `mcp/packages/plugin/vite.config.ts`.

### Unit review (detailed)

- **Review scope**
  - Script behavior consistency (`preflight` vs setup/bootstrap flow).
  - Port model consistency between preflight checks and actual runtime.
- **Issues found during review**
  1. Preflight allowed overriding plugin port, but plugin runtime initially did not read that variable.
  2. Preflight hard-failed when `corepack` was missing, even when `pnpm` was already installed and usable.
- **Fix applied**
  1. Added `PENJAR_MCP_PLUGIN_PORT` support in plugin Vite config and startup logs.
  2. Updated preflight/setup/build scripts to support `pnpm`-first environments without mandatory `corepack`.
- **Post-fix validation criteria**
  - Preflight and plugin runtime now resolve plugin port from the same variable name.
  - Setup path remains executable when `corepack` is unavailable but `pnpm` is present.

## Unit WS-B-02: Bridge diagnostics and health observability

### Planned objective

Add operator-facing diagnostics for common MCP bridge failures:
plugin disconnected, websocket timeout, and auth/token session problems.

### Implemented changes

1. Added `mcp/packages/server/src/BridgeDiagnostics.ts`:
   - diagnostic catalog,
   - error classification,
   - remediation message formatter.
2. Refactored `mcp/packages/server/src/PluginBridge.ts`:
   - added health snapshot output (`getHealthSnapshot()`),
   - tracks last connection/disconnect/timeout/failure metadata,
   - records classified failures for diagnostics,
   - fixed duplicate token-connection handling.
3. Updated `mcp/packages/server/src/Tool.ts`:
   - tool failures now include classified diagnostics and remediation guidance when applicable.
4. Updated `mcp/packages/server/src/PenjarMcpServer.ts`:
   - added `/health` endpoint with mode/session/bridge diagnostics payload.

### Unit review (detailed)

- **Review scope**
  - correctness of failure classification,
  - consistency of runtime state counters,
  - known error-path integrity in `PluginBridge`.
- **Issues found during review**
  1. Existing duplicate-token connection logic registered the new socket into `clientsByToken` even after reject/close.
  2. Initial `/health` behavior returned HTTP `503` for degraded plugin connectivity, which is noisy for startup diagnostics.
  3. `PluginBridge.ts` formatting diverged from workspace Prettier rules.
- **Fix applied**
  1. Duplicate-token rejection now returns before registration and records diagnostic context.
  2. Connection unregistering now validates token index ownership (`socket` identity check) before deletion.
  3. `/health` now always returns HTTP `200`; consumers must inspect payload `status` (`ok`/`degraded`).
  4. Applied Prettier formatting and reran `pnpm run fmt:check` to ensure style compliance.
- **Post-fix validation criteria**
  - rejected duplicate token sockets cannot overwrite active token-session routing.
  - `/health` exposes bridge counters and last failure metadata without requiring plugin task execution.

## Unit WS-B-03: Documentation, backlog, and traceability artifacts

### Planned objective

Document one-command startup/remediation and publish parity backlog evidence for Phase A tracking.

### Implemented changes

1. Updated `mcp/README.md`:
   - added preflight-first startup flow,
   - documented common remediation actions,
   - documented `/health` endpoint purpose and payload intent,
   - documented `PENJAR_MCP_PLUGIN_PORT`.
2. Updated `mcp/packages/server/README.md`:
   - added `/health` verification command for operator diagnostics.
3. Added parity backlog artifact:
   - `docs/technical-guide/developer/web-mcp-parity-backlog.md`.

### Unit review (detailed)

- **Review scope**
  - docs-to-runtime consistency for commands, ports, and endpoint paths.
- **Issues found during review**
  1. None after port-variable consistency fix in WS-B-01.
- **Post-fix validation criteria**
  - documented commands map directly to existing scripts and endpoints.

## Unit WS-B-04: Automated parity checks for closed P0 rows

### Planned objective

Add repeatable automated checks for already closed Phase A P0 items (setup/bootstrap and diagnostics/health).

### Implemented changes

1. Added `mcp/scripts/verify-phase-a`:
   - executes `preflight` (P0-001 gate),
   - builds `mcp-common` + `mcp-server`,
   - boots the server,
   - probes `/health`,
   - validates the `/health` payload contract (status/endpoints/bridge metrics/diagnostics catalog).
2. Updated `mcp/package.json`:
   - added `pnpm run verify:phase-a`.
3. Updated `mcp/scripts/check`:
   - appended `pnpm run verify:phase-a` so quality checks include the new parity gate.
4. Updated capability/backlog/docs references:
   - matrix and backlog evidence now reference the automated gate command.

### Unit review (detailed)

- **Review scope**
  - automated check reliability in local runtime,
  - validation coverage for both P0-001 and P0-002 closure evidence,
  - compatibility with existing `check` workflow.
- **Issues found during review**
  1. `mcp/scripts/check` 실행 시 기존 빌드 후 `verify:phase-a`가 다시 빌드를 수행해 중복 비용이 발생.
- **Fix applied**
  1. `verify-phase-a`에 `VERIFY_PHASE_A_SKIP_BUILD=true` 옵션을 추가해 중복 빌드를 건너뛸 수 있게 함.
  2. `mcp/scripts/check`에서 위 옵션을 사용하도록 갱신.
  3. `verify-phase-a` 자체에는 bounded polling, HTTP code assertion, payload contract assertion, cleanup trap을 유지.
- **Post-fix validation criteria**
  - `pnpm run verify:phase-a` passes end-to-end.
  - `mcp/scripts/check` includes the parity gate without manual intervention.
  - `mcp/scripts/check` path에서 추가 중복 빌드 없이 parity gate가 실행됨.

## Unit WS-B-05: Authentication/session recovery contract baseline

### Planned objective

Move P0-003 from undefined state to an explicit contract baseline with automated diagnostics presence checks.

### Implemented changes

1. Added auth/session recovery contract:
   - `docs/technical-guide/developer/web-mcp-auth-session-recovery-contract.md`.
2. Strengthened `verify-phase-a` payload contract checks:
   - now verifies presence of auth/session diagnostics codes:
     - `AUTH_TOKEN_MISSING`
     - `AUTH_TOKEN_EXPIRED_OR_MISMATCH`
3. Updated tracking artifacts:
   - capability matrix row for authentication/session updated to **Partial** with explicit next step,
   - P0 backlog item `P0-003` set to **In progress**.

### Unit review (detailed)

- **Review scope**
  - consistency between recovery contract and runtime diagnostics catalog,
  - backward compatibility of `verify:phase-a` and `scripts/check`.
- **Issues found during review**
  1. None functionally; the diagnostics catalog already provided all required auth/session codes.
- **Fix applied**
  1. No runtime fix required; contract assertions were tightened in automated verification.
- **Post-fix validation criteria**
  - `pnpm run verify:phase-a` succeeds with auth diagnostics assertions enabled.
  - `bash mcp/scripts/check` succeeds with the stricter verification gate.

## Unit WS-A-06: P0 ticket seeding and sequencing

### Planned objective

Execute immediate-order step 3 by transforming P0 parity rows into implementation-ready ticket seeds.

### Implemented changes

1. Added `docs/technical-guide/developer/web-mcp-phase-a-ticket-seed.md`:
   - priority order,
   - per-ticket scope,
   - acceptance criteria,
   - sequencing constraints.
2. Linked the ticket seed artifact from roadmap/developer index pages.

### Unit review (detailed)

- **Review scope**
  - backlog-to-ticket mapping completeness,
  - traceability across overview/index artifacts.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not applicable.
- **Post-fix validation criteria**
  - every active P0 backlog row has at least one seeded ticket with explicit acceptance criteria.

## Unit WS-B-07: Auth/session runtime negative probes

### Planned objective

Add executable runtime checks for token-missing and token-mismatch failures in multi-user mode.

### Implemented changes

1. Added `mcp/scripts/verify-auth-session`:
   - starts MCP server in multi-user mode,
   - performs tool call without token and verifies `AUTH_TOKEN_MISSING`,
   - performs tool call with token but no matching plugin session and verifies `AUTH_TOKEN_EXPIRED_OR_MISMATCH`.
2. Updated `mcp/package.json`:
   - added `pnpm run verify:auth-session`.
3. Updated `mcp/scripts/check`:
   - added `VERIFY_AUTH_SKIP_BUILD=true pnpm run verify:auth-session`.
4. Updated tracking/docs:
   - matrix/backlog/ticket-seed/readme updated with new runtime probe evidence.

### Unit review (detailed)

- **Review scope**
  - practical reproducibility of multi-user auth failures,
  - compatibility with existing check pipeline,
  - accuracy of diagnostic code assertions.
- **Issues found during review**
  1. None functionally; first implementation passed end-to-end.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `pnpm run verify:auth-session` passes independently.
  - `bash mcp/scripts/check` passes with both phase-a and auth-session gates enabled.

## Unit WS-B-08: Auth/session reconnect-retry success probe

### Planned objective

Close the remaining P0-003 validation gap by proving successful retry after token/session re-binding.

### Implemented changes

1. Extended `mcp/scripts/verify-auth-session`:
   - added reconnect-retry flow probe with a token-bound fake plugin WebSocket client,
   - verifies pre-recovery mismatch diagnostic,
   - verifies post-recovery successful tool execution without diagnostics.
2. Updated docs/backlog:
   - P0-003 marked **Closed** in parity backlog,
   - auth/session contract and ticket seed updated with reconnect-retry evidence.

### Unit review (detailed)

- **Review scope**
  - reliability of fake plugin handshake flow,
  - correctness of pre-recovery vs post-recovery assertions.
- **Issues found during review**
  1. Initial script edit introduced heredoc boundary break (`EOF` placement) causing shell execution failure.
- **Fix applied**
  1. Corrected heredoc closure and function boundaries in `verify-auth-session`.
- **Post-fix validation criteria**
  - `pnpm run verify:auth-session` passes with reconnect-retry assertion.
  - `bash mcp/scripts/check` passes with both verification gates enabled.

## Unit WS-A-09: Project lifecycle context baseline tooling

### Planned objective

Establish a concrete MCP entry-point for project/file context and add executable parity evidence for P0-004.

### Implemented changes

1. Added server tool:
   - `mcp/packages/server/src/tools/ActiveDesignContextTool.ts`
   - tool name: `active_design_context`
   - returns file/page/selection summary from plugin context.
2. Registered tool in `PenjarMcpServer` tool registry.
3. Added `mcp/scripts/verify-project-lifecycle`:
   - spins up server,
   - connects fake plugin WebSocket session,
   - calls `active_design_context` over MCP,
   - validates request/response path end-to-end.
4. Updated check pipeline and docs:
   - `pnpm run verify:project-lifecycle` added,
   - `mcp/scripts/check` now includes project lifecycle probe.

### Unit review (detailed)

- **Review scope**
  - tool registration and execution path correctness,
  - probe coverage for request/response round-trip.
- **Issues found during review**
  1. None; typecheck/build/probe passed on first run.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `pnpm run verify:project-lifecycle` passes independently.
  - `bash mcp/scripts/check` passes with phase-a/auth/project probes enabled.

## Unit WS-A-10: File lifecycle baseline tooling

### Planned objective

Move P0-005 from undocumented generic path to a concrete MCP surface with executable baseline evidence.

### Implemented changes

1. Added server tool:
   - `mcp/packages/server/src/tools/FileLifecycleTool.ts`
   - tool name: `file_lifecycle`
   - operations: `inspect`, `create_page`, `rename_file`, `rename_page`.
2. Registered tool in `PenjarMcpServer` tool registry.
3. Added `mcp/scripts/verify-file-lifecycle`:
   - server startup + health wait,
   - fake plugin WebSocket session,
   - E2E verification of lifecycle operations and response payloads.
4. Updated quality pipeline:
   - `pnpm run verify:file-lifecycle` added,
   - `mcp/scripts/check` now enforces lifecycle probe.

### Unit review (detailed)

- **Review scope**
  - correctness of lifecycle tool operation routing,
  - request/response integrity through executeCode task path,
  - check-pipeline integration stability.
- **Issues found during review**
  1. None; types/build/probe/check passed on first run.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `pnpm run verify:file-lifecycle` passes independently.
  - `bash mcp/scripts/check` passes with phase-a/auth/project/file probes enabled.

## Unit WS-A-11: Canvas editing baseline tooling

### Planned objective

Provide explicit MCP surface and executable parity evidence for common canvas geometry/style operations.

### Implemented changes

1. Added server tool:
   - `mcp/packages/server/src/tools/CanvasEditingTool.ts`
   - tool name: `canvas_editing`
   - operations: `create_rectangle`, `resize_shape`, `move_shape`, `set_fill_color`.
2. Registered tool in `PenjarMcpServer` tool registry.
3. Added `mcp/scripts/verify-canvas-editing`:
   - server startup + health wait,
   - fake plugin WebSocket session,
   - E2E verification of all supported canvas editing operations.
4. Updated quality pipeline:
   - `pnpm run verify:canvas-editing` added,
   - `mcp/scripts/check` now enforces canvas editing probe.

### Unit review (detailed)

- **Review scope**
  - operation argument validation and code generation paths,
  - end-to-end execution routing through plugin bridge,
  - check-pipeline stability after probe addition.
- **Issues found during review**
  1. Prettier check failed for `CanvasEditingTool.ts`.
- **Fix applied**
  1. Applied Prettier formatting and reran full `scripts/check` successfully.
- **Post-fix validation criteria**
  - `pnpm run verify:canvas-editing` passes independently.
  - `bash mcp/scripts/check` passes with phase-a/auth/project/file/canvas probes enabled.

## Unit WS-A-12: Asset management resilience baseline

### Planned objective

Add executable resilience evidence for asset import flows under plugin timeout/disconnect interruption cases.

### Implemented changes

1. Added server configuration knob:
   - `PENJAR_MCP_TASK_TIMEOUT_SECS` for plugin task timeout tuning.
2. Added `mcp/scripts/verify-asset-management`:
   - generates local PNG fixture,
   - validates `import_image` success path,
   - validates timeout diagnostic path (`PLUGIN_TASK_TIMEOUT`),
   - validates disconnected diagnostic path (`PLUGIN_DISCONNECTED`).
3. Updated quality pipeline:
   - `pnpm run verify:asset-management` added,
   - `mcp/scripts/check` now enforces asset probe.
4. Updated operator docs with timeout config and new verification command.

### Unit review (detailed)

- **Review scope**
  - correctness of import-image request path under fake plugin,
  - deterministic timeout/disconnect diagnostic assertions,
  - check-pipeline compatibility.
- **Issues found during review**
  1. Prettier check failed for `PenjarMcpServer.ts` after timeout-config edit.
- **Fix applied**
  1. Applied Prettier formatting and reran full `scripts/check` successfully.
- **Post-fix validation criteria**
  - `pnpm run verify:asset-management` passes independently.
  - `bash mcp/scripts/check` passes with phase-a/auth/project/file/canvas/asset probes enabled.

## Unit WS-A-13: Inspect/code handoff baseline tooling

### Planned objective

Add a dedicated inspect handoff MCP surface and automated field-level baseline verification.

### Implemented changes

1. Added server tool:
   - `mcp/packages/server/src/tools/InspectHandoffTool.ts`
   - tool name: `inspect_handoff`
   - contract fields: `hierarchy`, `layoutSemantics`, `style`, `tokenHints`.
2. Registered tool in `PenjarMcpServer` tool registry.
3. Added `mcp/scripts/verify-inspect-handoff`:
   - server startup + health wait,
   - fake plugin WebSocket session,
   - E2E verification for inspect handoff payload fields.
4. Updated quality pipeline:
   - `pnpm run verify:inspect-handoff` added,
   - `mcp/scripts/check` now enforces inspect handoff probe.

### Unit review (detailed)

- **Review scope**
  - inspect handoff field completeness in tool output,
  - end-to-end tool execution path stability,
  - check-pipeline integration with existing probes.
- **Issues found during review**
  1. None; types/build/probe/check passed on first run.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `pnpm run verify:inspect-handoff` passes independently.
  - `bash mcp/scripts/check` passes with phase-a/auth/project/file/canvas/asset/inspect probes enabled.

## Unit WS-QA-14: Probe assertion hardening (JSON contract parsing)

### Planned objective

Reduce false positives from string-match assertions in probes by moving to JSON payload parsing and typed field assertions.

### Implemented changes

1. Updated probes to parse and validate JSON payload contracts:
   - `verify-project-lifecycle`
   - `verify-file-lifecycle`
   - `verify-canvas-editing`
   - `verify-asset-management`
   - `verify-inspect-handoff`
2. Added explicit error messaging for non-JSON payloads in probe failures.

### Unit review (detailed)

- **Review scope**
  - probe determinism with stricter assertions,
  - compatibility with existing fake-plugin fixtures and `scripts/check`.
- **Issues found during review**
  1. None; all probes passed after conversion.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - full `bash mcp/scripts/check` continues to pass with JSON-based assertions enabled.

## Unit WS-A-15: File lifecycle denied/missing diagnostic gate

### Planned objective

Strengthen P0-005 baseline by adding deterministic diagnostics checks for restricted-role-style denied paths and missing-target paths.

### Implemented changes

1. Extended `mcp/scripts/verify-file-lifecycle`:
   - added fake-plugin denied response path for `rename_file` to assert `PERMISSION_DENIED`,
   - added fake-plugin missing-target response path for `rename_page` to assert `RESOURCE_NOT_FOUND`,
   - preserved JSON contract checks for success-path operations.
2. Extended `mcp/scripts/verify-phase-a`:
   - `/health` diagnostics catalog assertions now include:
     - `PERMISSION_DENIED`
     - `RESOURCE_NOT_FOUND`
3. Updated traceability docs:
   - capability matrix, parity backlog, ticket seed, and `mcp/README.md` now reference denied/missing diagnostic baseline coverage for `verify:file-lifecycle`.

### Unit review (detailed)

- **Review scope**
  - diagnostic output coverage for file lifecycle negative paths,
  - `/health` diagnostics-catalog contract consistency,
  - compatibility with full quality pipeline execution.
- **Issues found during review**
  1. Initial probe execution with `VERIFY_FILE_SKIP_BUILD=true` failed because `dist` had not yet been rebuilt with the latest diagnostics classification changes.
- **Fix applied**
  1. Re-ran `pnpm run verify:file-lifecycle` with build enabled to validate runtime behavior against current source.
  2. Re-ran `VERIFY_PHASE_A_SKIP_BUILD=true pnpm run verify:phase-a` and full `bash mcp/scripts/check` for end-to-end regression confirmation.
- **Post-fix validation criteria**
  - `pnpm run verify:file-lifecycle` passes with denied/missing diagnostic assertions enabled.
  - `VERIFY_PHASE_A_SKIP_BUILD=true pnpm run verify:phase-a` passes with expanded diagnostics catalog checks.
  - `bash mcp/scripts/check` passes with all verification probes.

## Unit WS-A-16: Canvas editing denied/missing diagnostic gate

### Planned objective

Strengthen P0-006 baseline by validating deterministic diagnostic behavior for denied and missing-shape canvas edit paths.

### Implemented changes

1. Extended `mcp/scripts/verify-canvas-editing`:
   - added fake-plugin missing-target path (`shape-missing`) and assertion for `RESOURCE_NOT_FOUND`,
   - added fake-plugin permission-denied path (`shape-readonly`) and assertion for `PERMISSION_DENIED`,
   - retained existing JSON contract checks for success-path operations (`create_rectangle`, `resize_shape`, `move_shape`, `set_fill_color`).
2. Updated traceability docs:
   - capability matrix, parity backlog, ticket seed, and `mcp/README.md` now reference denied/missing diagnostic baseline coverage for `verify:canvas-editing`.

### Unit review (detailed)

- **Review scope**
  - negative-path diagnostic emission for canvas operations,
  - probe determinism under mixed success/failure operation sequence,
  - compatibility with full `scripts/check` pipeline.
- **Issues found during review**
  1. None; probe and full pipeline passed after first implementation.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `VERIFY_CANVAS_SKIP_BUILD=true pnpm run verify:canvas-editing` passes with denied/missing diagnostic assertions enabled.
  - `bash mcp/scripts/check` passes with updated canvas probe coverage.

## Unit WS-A-17: Inspect handoff multi-scope + missing-target diagnostic gate

### Planned objective

Strengthen P0-008 baseline by validating inspect handoff contracts across selection/page scopes and adding deterministic missing-target diagnostic assertions.

### Implemented changes

1. Extended `mcp/scripts/verify-inspect-handoff`:
   - added selection-scope scenario (`includeCss=true`, `maxDepth=2`) with hierarchy/layout/style/token checks,
   - added page-scope scenario (`includeCss=false`, `maxDepth=4`) with null-style assertion,
   - added missing-target failure scenario (`maxDepth=1` probe branch) asserting `RESOURCE_NOT_FOUND` diagnostic,
   - added scenario-observation guard to ensure fake plugin received all expected request variants.
2. Updated traceability docs:
   - capability matrix, parity backlog, ticket seed, and `mcp/README.md` now reference expanded inspect probe scope/diagnostic coverage.

### Unit review (detailed)

- **Review scope**
  - scope-specific inspect payload contract stability,
  - deterministic diagnostic output for missing-target failure,
  - script robustness and pipeline compatibility.
- **Issues found during review**
  1. Initial edit introduced heredoc/function-boundary corruption inside `verify-inspect-handoff`, causing invalid JavaScript in the embedded probe.
- **Fix applied**
  1. Rewrote the `verify-inspect-handoff` script block end-to-end with explicit helper functions (`callToolText`, `callToolJson`) and single connect/teardown flow.
  2. Re-ran `VERIFY_INSPECT_SKIP_BUILD=true pnpm run verify:inspect-handoff` to confirm recovery.
- **Post-fix validation criteria**
  - `VERIFY_INSPECT_SKIP_BUILD=true pnpm run verify:inspect-handoff` passes with multi-scope and missing-target diagnostic assertions enabled.
  - `bash mcp/scripts/check` passes with updated inspect probe coverage.

## Unit WS-A-18: Project lifecycle multi-context transition gate

### Planned objective

Strengthen P0-004 baseline by validating context continuity across representative navigation transitions instead of a single snapshot.

### Implemented changes

1. Extended `mcp/scripts/verify-project-lifecycle`:
   - replaced single static response with ordered multi-context snapshots:
     - initial context (`file-1` / `page-1`, empty selection),
     - page-transition context (`file-1` / `page-2`, single selection),
     - file-transition context (`file-2` / `page-8`, empty selection),
     - detached context (`file=null`, `currentPage=null`, empty selection),
   - added explicit assertion that exactly four lifecycle snapshots were observed.
2. Updated traceability docs:
   - capability matrix, parity backlog, ticket seed, and `mcp/README.md` now reference multi-context transition coverage in `verify:project-lifecycle`.

### Unit review (detailed)

- **Review scope**
  - transition-sequence correctness and deterministic ordering,
  - context contract handling for detached/null states,
  - script stability after probe refactor.
- **Issues found during review**
  1. Initial incremental patch introduced broken function boundaries in embedded probe code (`callActiveDesignContext` path), causing invalid JavaScript structure.
- **Fix applied**
  1. Rewrote `verify-project-lifecycle` end-to-end with explicit helper function and single connect/teardown flow.
  2. Re-ran `VERIFY_PROJECT_SKIP_BUILD=true pnpm run verify:project-lifecycle` to confirm probe recovery.
- **Post-fix validation criteria**
  - `VERIFY_PROJECT_SKIP_BUILD=true pnpm run verify:project-lifecycle` passes with multi-context transition assertions.
  - `bash mcp/scripts/check` passes with updated project lifecycle coverage.

## Unit WS-A-19: Asset reconnect-recovery gate

### Planned objective

Strengthen P0-007 baseline by proving import flow recovery after timeout/disconnect interruption windows.

### Implemented changes

1. Extended `mcp/scripts/verify-asset-management`:
   - added reusable fake-plugin handler attachment for multiple WebSocket sessions,
   - preserved existing success + timeout + disconnected diagnostic checks,
   - added reconnect phase with a second plugin session and asserted recovery import success (`asset-shape-2`),
   - added explicit assertion that recovery import request reaches the reconnected plugin handler.
2. Updated traceability docs:
   - capability matrix, parity backlog, ticket seed, and `mcp/README.md` now reference reconnect-recovery baseline coverage for `verify:asset-management`.

### Unit review (detailed)

- **Review scope**
  - deterministic reconnect sequencing after disconnect diagnostic,
  - recovery import payload correctness and handler routing,
  - compatibility with existing timeout/disconnect assertions.
- **Issues found during review**
  1. None; first implementation passed targeted probe.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `VERIFY_ASSET_SKIP_BUILD=true pnpm run verify:asset-management` passes with reconnect-recovery assertions.
  - `bash mcp/scripts/check` passes with updated asset resilience coverage.

## Unit WS-A-20: File lifecycle open-page transition gate

### Planned objective

Strengthen P0-005 baseline by adding explicit page-open transition support to `file_lifecycle` and protecting it with automated probe coverage.

### Implemented changes

1. Extended `mcp/packages/server/src/tools/FileLifecycleTool.ts`:
   - added `open_page` operation to schema and operation union,
   - added lookup path by `pageId` or `pageName` (case-insensitive name match),
   - added explicit input validation for missing `pageId`/`pageName`,
   - added `penjar.openPage(targetPage)` execution and normalized response payload.
2. Extended `mcp/scripts/verify-file-lifecycle`:
   - added fake-plugin response branch for `file_lifecycle_operation: open_page`,
   - added success-path assertion for `open_page`,
   - kept existing denied/missing diagnostic assertions and included `open_page` in observed operation set.
3. Updated traceability docs:
   - capability matrix, parity backlog, ticket seed, and `mcp/README.md` now reference open-page lifecycle baseline coverage.

### Unit review (detailed)

- **Review scope**
  - `open_page` operation contract and argument validation behavior,
  - probe coverage integrity for mixed success/diagnostic scenarios,
  - compatibility with existing build and check pipeline.
- **Issues found during review**
  1. None; first implementation passed targeted probe.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `pnpm run verify:file-lifecycle` passes with open-page assertions enabled.
  - `bash mcp/scripts/check` passes with updated file lifecycle coverage.

## Unit WS-B-21: Bridge disconnect/reconnect recovery gate

### Planned objective

Close the diagnostics recovery assertion gap by adding a deterministic single-user reconnect-cycle probe around `PLUGIN_DISCONNECTED` behavior.

### Implemented changes

1. Added `mcp/scripts/verify-bridge-recovery`:
   - starts server and validates pre-connect `PLUGIN_DISCONNECTED` diagnostic,
   - checks `/health` connected-client counter before connection (`0`),
   - connects fake plugin WebSocket and verifies successful `execute_code` response,
   - checks `/health` connected-client counter after connection (`1`),
   - closes plugin and verifies `PLUGIN_DISCONNECTED` diagnostic returns,
   - checks `/health` connected-client counter after disconnect (`0`).
2. Updated quality pipeline:
   - added `pnpm run verify:bridge-recovery`,
   - integrated `VERIFY_BRIDGE_SKIP_BUILD=true pnpm run verify:bridge-recovery` into `mcp/scripts/check`.
3. Updated traceability docs:
   - capability matrix/backlog/README now reference reconnect-cycle evidence for diagnostics/health coverage.

### Unit review (detailed)

- **Review scope**
  - end-to-end reconnect-cycle determinism,
  - `/health` counter transitions versus tool diagnostics consistency,
  - pipeline integration stability with existing probes.
- **Issues found during review**
  1. None; targeted probe passed after first implementation.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `VERIFY_BRIDGE_SKIP_BUILD=true pnpm run verify:bridge-recovery` passes.
  - `bash mcp/scripts/check` passes with bridge recovery gate enabled.

## Unit WS-A-22: File lifecycle delete-path strategy diagnostic gate

### Planned objective

Codify P0-005 delete-path strategy by providing deterministic unsupported-operation signaling for page deletion requests in current plugin runtime constraints.

### Implemented changes

1. Extended diagnostics catalog (`BridgeDiagnostics`):
   - added `UNSUPPORTED_OPERATION` diagnostic code/template,
   - added message classification for `not supported` errors.
2. Extended `mcp/packages/server/src/tools/FileLifecycleTool.ts`:
   - added `delete_page` operation to the tool contract,
   - mapped `delete_page` to an explicit strategy error:
     - current runtime does not support page deletion via plugin API path,
     - users should route deletion through backend file-management APIs.
3. Extended verification coverage:
   - `mcp/scripts/verify-file-lifecycle` now asserts `UNSUPPORTED_OPERATION` for `delete_page` requests,
   - `mcp/scripts/verify-phase-a` now asserts `UNSUPPORTED_OPERATION` in `/health` diagnostics catalog.
4. Updated traceability docs:
   - capability matrix, parity backlog, ticket seed, and `mcp/README.md` now capture delete-path strategy signaling behavior.

### Unit review (detailed)

- **Review scope**
  - deterministic unsupported-operation diagnostics for delete requests,
  - diagnostics-catalog consistency with new code registration,
  - compatibility with existing lifecycle and phase-a checks.
- **Issues found during review**
  1. None; targeted `verify:file-lifecycle` and `verify:phase-a` checks passed on first implementation.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `pnpm run verify:file-lifecycle` passes with `delete_page` unsupported-operation assertions.
  - `VERIFY_PHASE_A_SKIP_BUILD=true pnpm run verify:phase-a` passes with `UNSUPPORTED_OPERATION` catalog assertion.
  - `bash mcp/scripts/check` passes with updated diagnostics coverage.

## Unit WS-B-23: Multi-user duplicate-token conflict gate

### Planned objective

Strengthen P0-003 runtime evidence by validating duplicate-token connection conflict handling and continuity of the original token-bound plugin session.

### Implemented changes

1. Extended `mcp/scripts/verify-auth-session`:
   - added duplicate-token conflict scenario:
     - opens primary plugin WebSocket with token,
     - attempts second WebSocket with same token and asserts close code `1008` + duplicate-connection reason,
     - asserts `/health` `pluginBridge.lastFailure.diagnosticCode` is `PLUGIN_CONNECTION_CONFLICT`,
     - verifies tool execution still succeeds through the primary token-bound session.
2. Updated traceability docs:
   - capability matrix, parity backlog, ticket seed, and `mcp/README.md` now reference duplicate-token conflict validation under auth/session baseline.

### Unit review (detailed)

- **Review scope**
  - deterministic duplicate-token rejection semantics,
  - conflict diagnostic propagation into health payload,
  - continuity of existing token session after conflict event.
- **Issues found during review**
  1. None; targeted auth/session probe passed after first implementation.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `VERIFY_AUTH_SKIP_BUILD=true pnpm run verify:auth-session` passes with duplicate-token conflict assertions.
  - `bash mcp/scripts/check` passes with updated auth/session coverage.

## Unit WS-A-24: Collaboration context MCP baseline

### Planned objective

Start deeper implementation scope by adding explicit MCP collaboration context support for comment-thread workflows, including deterministic diagnostics for permission and target-resolution failures.

### Implemented changes

1. Added server tool:
   - `mcp/packages/server/src/tools/CollaborationContextTool.ts`
   - tool name: `collaboration_context`
   - operations:
     - `inspect_threads`
     - `create_thread`
     - `reply_thread`
     - `set_thread_resolved`
     - `remove_thread`
2. Registered tool in `PenjarMcpServer` tool registry.
3. Added `mcp/scripts/verify-collaboration-context`:
   - validates comment-thread inspect/create/reply/resolve/remove success flows,
   - validates `PERMISSION_DENIED` and `RESOURCE_NOT_FOUND` diagnostic paths.
4. Updated quality pipeline:
   - added `pnpm run verify:collaboration-context`,
   - integrated `VERIFY_COLLAB_SKIP_BUILD=true pnpm run verify:collaboration-context` into `mcp/scripts/check`.
5. Updated traceability docs:
   - capability matrix/backlog/README now include collaboration-context baseline evidence.

### Unit review (detailed)

- **Review scope**
  - collaboration-thread operation contract correctness,
  - diagnostic behavior for denied/missing collaboration operations,
  - tool registration and check-pipeline integration.
- **Issues found during review**
  1. None; initial implementation passed targeted probe.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `pnpm run verify:collaboration-context` passes end-to-end.
  - `bash mcp/scripts/check` passes with collaboration-context gate enabled.

## Unit WS-A-25: Collaboration awareness metadata contract gate

### Planned objective

Deepen P1-001 implementation by defining explicit MCP contract coverage for collaboration presence/awareness metadata (`currentUser`, `activeUsers`) with deterministic permission diagnostics.

### Implemented changes

1. Extended collaboration tool contract:
   - `mcp/packages/server/src/tools/CollaborationContextTool.ts`
   - added operation `inspect_awareness` with optional toggles:
     - `includeCurrentUser` (default `true`)
     - `includeActiveUsers` (default `true`)
   - response includes:
     - `page` context,
     - serialized `currentUser`,
     - serialized `activeUsers` presence list,
     - `metrics` block (`activeUserCount`, `currentUserActive`, include flags).
2. Expanded collaboration probe:
   - `mcp/scripts/verify-collaboration-context`
   - validates `inspect_awareness` success payload contract,
   - validates awareness permission-failure path (`user:read` scope) with deterministic `PERMISSION_DENIED` diagnostic classification,
   - keeps existing thread workflow and `RESOURCE_NOT_FOUND`/permission diagnostics coverage.
3. Updated plugin permissions for awareness reads:
   - `mcp/packages/plugin/public/manifest.json`
   - added `user:read` permission required to read `penjar.currentUser`/`penjar.activeUsers`.
4. Updated traceability docs:
   - capability matrix, parity backlog, and `mcp/README.md` updated with awareness contract evidence and next-step guidance.

### Unit review (detailed)

- **Review scope**
  - awareness payload schema completeness for agent consumption,
  - permission diagnostics behavior when `user:read` scope is unavailable,
  - backward compatibility with existing collaboration-thread operations.
- **Issues found during review**
  1. None in logic path; awareness scenarios passed with deterministic payload and diagnostic assertions.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `VERIFY_COLLAB_SKIP_BUILD=true pnpm run verify:collaboration-context` passes with awareness success + permission-failure scenarios.
  - `bash mcp/scripts/check` passes with full parity gate set after awareness contract expansion.

## Unit WS-A-26: Export workflows format matrix + diagnostics gate

### Planned objective

Start deeper P1-002 closure by codifying export format behavior and deterministic failure semantics for `export_shape`, including artifact-save workflow coverage.

### Implemented changes

1. Hardened `export_shape` behavior:
   - `mcp/packages/server/src/tools/ExportShapeTool.ts`
   - added explicit guard for unsupported matrix path:
     - `mode=fill` with `format=svg` now fails deterministically with unsupported-operation error text,
   - added export-operation marker comment in generated plugin code for stable probe routing.
2. Added export workflow probe:
   - `mcp/scripts/verify-export-workflows`
   - validates success matrix:
     - shape export as PNG,
     - shape export as SVG,
     - fill export as PNG,
   - validates failure diagnostics:
     - unsupported matrix (`UNSUPPORTED_OPERATION`),
     - missing shape (`RESOURCE_NOT_FOUND`),
     - permission denied (`PERMISSION_DENIED`),
   - validates file-save workflow:
     - SVG export with `filePath`,
     - artifact existence/content assertion.
3. Updated quality pipeline:
   - added `pnpm run verify:export-workflows` in `mcp/package.json`,
   - integrated `VERIFY_EXPORT_SKIP_BUILD=true pnpm run verify:export-workflows` into `mcp/scripts/check`.
4. Updated traceability docs:
   - capability matrix, parity backlog, and `mcp/README.md` updated with export-workflow gate evidence.

### Unit review (detailed)

- **Review scope**
  - format-matrix behavior determinism for export workflows,
  - diagnostic classification stability across unsupported/missing/permission paths,
  - artifact-save path correctness and pipeline integration safety.
- **Issues found during review**
  1. None; targeted export probe and full check pipeline passed after first implementation.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `pnpm run verify:export-workflows` passes with matrix + diagnostic + artifact assertions.
  - `bash mcp/scripts/check` passes with export workflow gate enabled.

## Unit WS-A-27: Inspect handoff required/optional contract gate

### Planned objective

Deepen P0-008 evidence by converting inspect-handoff assertions from coarse field presence checks to explicit required/optional contract validation, including fallback semantics.

### Implemented changes

1. Expanded `mcp/scripts/verify-inspect-handoff` contract assertions:
   - added recursive hierarchy-node validation (`id`, `type`, `children[]`),
   - added explicit layout-semantics contract checks:
     - `maxDepth`,
     - `targetCount`,
     - `fallbackUsed`,
   - added token-hint array type validation,
   - added style contract branching:
     - CSS string required when `includeCss=true`,
     - `null` required when `includeCss=false`.
2. Added fallback scenario coverage:
   - selection scope with `includeCss=false`, `maxDepth=3`,
   - validates fallback behavior (`fallbackUsed=true`) and null-style response.
3. Preserved and revalidated negative path:
   - selection scope missing-target scenario retains deterministic `RESOURCE_NOT_FOUND` diagnostic assertion.
4. Updated traceability docs:
   - capability matrix, parity backlog, and `mcp/README.md` now reference required/optional inspect contract validation scope.

### Unit review (detailed)

- **Review scope**
  - inspect payload contract strictness for required/optional keys and types,
  - fallback semantics behavior in selection scope without CSS,
  - regression safety of existing diagnostic assertions.
- **Issues found during review**
  1. None; strict contract assertions passed on first implementation.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `VERIFY_INSPECT_SKIP_BUILD=true pnpm run verify:inspect-handoff` passes with strict contract assertions enabled.
  - `bash mcp/scripts/check` passes with inspect gate hardening integrated.

## Unit WS-A-28: Project lifecycle contract invariants + permission diagnostic gate

### Planned objective

Deepen P0-004 validation by hardening `active_design_context` checks from transition-only assertions to explicit contract invariants and negative-path diagnostics.

### Implemented changes

1. Extended `mcp/scripts/verify-project-lifecycle`:
   - added strict context-contract assertions:
     - `file`/`currentPage` object-vs-null invariants,
     - selection structure/type checks,
     - selection cardinality invariant (`count === ids.length === names.length`),
   - retained multi-context transition coverage:
     - initial context,
     - page transition,
     - file transition,
     - detached context.
2. Added deterministic negative-path coverage:
   - fifth scenario returns permission failure from fake plugin,
   - probe asserts `PERMISSION_DENIED` diagnostic emission for `active_design_context`.
3. Updated traceability docs:
   - capability matrix, parity backlog, and `mcp/README.md` now reference project contract-invariant + diagnostic gate scope.

### Unit review (detailed)

- **Review scope**
  - context payload contract strictness across lifecycle transitions,
  - detached-state invariants and selection cardinality checks,
  - permission-denied diagnostics behavior for lifecycle tool path.
- **Issues found during review**
  1. None; targeted probe and full check passed on first implementation.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `VERIFY_PROJECT_SKIP_BUILD=true pnpm run verify:project-lifecycle` passes with contract + diagnostic assertions.
  - `bash mcp/scripts/check` passes with hardened project lifecycle gate.

## Unit WS-A-29: Canvas payload contract + default-value gate

### Planned objective

Deepen P0-006 evidence by upgrading canvas probe checks from operation-level smoke assertions to strict payload-contract and default-value behavior validation.

### Implemented changes

1. Extended `mcp/scripts/verify-canvas-editing` assertions:
   - added structured contract validators for:
     - `create_rectangle` response shape (id/name/x/y/width/height),
     - `resize_shape` geometry payload,
     - `move_shape` geometry payload,
     - `set_fill_color` fills payload shape.
2. Added default-value scenario coverage:
   - added `create_rectangle` call without optional arguments,
   - validates default geometry semantics (`x=0`, `y=0`, `width=100`, `height=100`, default name).
3. Preserved deterministic negative-path checks:
   - missing target for resize -> `RESOURCE_NOT_FOUND`,
   - permission-denied fill update -> `PERMISSION_DENIED`.
4. Updated traceability docs:
   - capability matrix, parity backlog, and `mcp/README.md` now reference strict contract + default-value canvas gate coverage.

### Unit review (detailed)

- **Review scope**
  - canvas payload type/value contract strictness across all supported operations,
  - default-value semantics for rectangle creation without optional args,
  - regression safety of existing permission/missing diagnostics checks.
- **Issues found during review**
  1. None; targeted canvas probe and full check pipeline passed on first implementation.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `VERIFY_CANVAS_SKIP_BUILD=true pnpm run verify:canvas-editing` passes with strict contract + default-value assertions.
  - `bash mcp/scripts/check` passes with hardened canvas gate.

## Unit WS-A-30: File lifecycle contract + default/open-by-name gate

### Planned objective

Deepen P0-005 validation by converting lifecycle checks from coarse operation assertions to strict file/page contract validation with explicit default and lookup semantics.

### Implemented changes

1. Extended `mcp/scripts/verify-file-lifecycle` contract assertions:
   - added file/page contract checks for core operations:
     - `inspect`,
     - `create_page`,
     - `rename_file`,
     - `rename_page`,
     - `open_page`,
   - added inspect contract checks for:
     - `revn` type,
     - `pages[]` structure and count.
2. Added default/value-lookup scenario coverage:
   - `create_page` without `pageName` now asserted to produce default name (`Untitled page`),
   - `open_page` by `pageName` (case-insensitive path via `"COVER"`) now asserted in addition to `pageId` lookup.
3. Preserved deterministic negative-path checks:
   - rename-file denied path -> `PERMISSION_DENIED`,
   - rename-page missing target -> `RESOURCE_NOT_FOUND`,
   - delete-page strategy path -> `UNSUPPORTED_OPERATION`.
4. Updated traceability docs:
   - capability matrix, parity backlog, and `mcp/README.md` now reference strict file lifecycle contract + default/open-by-name coverage.

### Unit review (detailed)

- **Review scope**
  - file/page payload contract strictness across lifecycle operations,
  - default page naming behavior and case-insensitive page-name lookup semantics,
  - regression safety for existing denied/missing/unsupported diagnostics.
- **Issues found during review**
  1. Initial strict-contract check reused generic file/page validators for rename payloads, causing false failures (`rename_file` uses `previousName/currentName`, `rename_page` uses `previousName/currentName`).
- **Fix applied**
  1. Added dedicated validators:
     - `assertRenameFileContract`
     - `assertRenamePageContract`
     and kept generic validators for inspect/create/open payload paths.
  2. Re-ran targeted `verify:file-lifecycle` and full `scripts/check` after fix.
- **Post-fix validation criteria**
  - `VERIFY_FILE_SKIP_BUILD=true pnpm run verify:file-lifecycle` passes with strict contract/default/open-by-name assertions.
  - `bash mcp/scripts/check` passes with hardened file lifecycle gate.

## Unit WS-A-31: Asset idempotency + missing-file diagnostic gate

### Planned objective

Deepen P0-007 validation by adding idempotency and local failure-semantic checks to asset import resilience coverage.

### Implemented changes

1. Extended `mcp/scripts/verify-asset-management`:
   - added import payload contract assertions (`shapeId` type/value),
   - added repeated-import idempotency scenario (same input import twice; stable `shapeId` assertion),
   - added missing-file failure scenario asserting deterministic `RESOURCE_NOT_FOUND`,
   - retained timeout (`PLUGIN_TASK_TIMEOUT`), disconnect (`PLUGIN_DISCONNECTED`), and reconnect-recovery import checks.
2. Strengthened probe observability:
   - replaced boolean payload flags with counters for:
     - primary-session import requests,
     - recovery-session import requests.
3. Updated traceability docs:
   - capability matrix, parity backlog, and `mcp/README.md` now reference contract + idempotency + missing-file coverage.

### Unit review (detailed)

- **Review scope**
  - import payload contract strictness and deterministic JSON behavior,
  - repeated-import idempotency semantics in stable session conditions,
  - local file-precondition diagnostic behavior (`RESOURCE_NOT_FOUND`),
  - regression safety for timeout/disconnect/reconnect resilience assertions.
- **Issues found during review**
  1. None; targeted asset probe and full check pipeline passed on first implementation.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `VERIFY_ASSET_SKIP_BUILD=true pnpm run verify:asset-management` passes with contract/idempotency/missing-file assertions.
  - `bash mcp/scripts/check` passes with hardened asset management gate.

## Unit WS-A-32: Export golden-fidelity fixture gate

### Planned objective

Deepen P1-002 output-quality assurance by adding a deterministic fixture baseline for SVG export fidelity checks.

### Implemented changes

1. Added golden fixture:
   - `mcp/packages/server/data/fixtures/export-shape-golden.svg`
   - canonical expected SVG payload for export-workflow probe.
2. Extended `mcp/scripts/verify-export-workflows`:
   - now loads golden fixture and uses it as fake-plugin SVG result,
   - validates in-memory SVG export equals golden fixture,
   - validates file-saved SVG export equals golden fixture,
   - preserves existing format-matrix and diagnostics assertions.
3. Updated traceability docs:
   - capability matrix, parity backlog, and `mcp/README.md` now reference golden-fidelity regression coverage.

### Unit review (detailed)

- **Review scope**
  - deterministic SVG export regression baseline stability,
  - parity between in-memory and persisted SVG artifact outputs,
  - compatibility with existing export diagnostics matrix assertions.
- **Issues found during review**
  1. None; targeted export probe and full check pipeline passed on first implementation.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `VERIFY_EXPORT_SKIP_BUILD=true pnpm run verify:export-workflows` passes with golden-fidelity assertions.
  - `bash mcp/scripts/check` passes with hardened export workflow gate.

## Unit WS-B-33: Health diagnostics catalog structure/uniqueness gate

### Planned objective

Strengthen P0-002 operational safety by validating not only diagnostic-code presence but also health-catalog structural integrity and uniqueness constraints.

### Implemented changes

1. Extended `mcp/scripts/verify-phase-a` `/health` contract assertions:
   - endpoint field types:
     - `endpoints.websocketPort` numeric,
     - `endpoints.replPort` numeric,
   - diagnostics catalog structural checks:
     - each entry has non-empty `code`, `title`, `summary`,
     - `remediation` is non-empty array of non-empty strings,
     - diagnostic codes are unique (duplicate detection).
2. Updated traceability docs:
   - capability matrix, parity backlog, and `mcp/README.md` now explicitly reference diagnostics-catalog contract enforcement.

### Unit review (detailed)

- **Review scope**
  - `/health` diagnostics catalog shape validity under current bridge implementation,
  - duplicate-code prevention and remediation-list quality gates,
  - compatibility with full `scripts/check` pipeline.
- **Issues found during review**
  1. None; targeted phase-a probe and full check pipeline passed on first implementation.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `VERIFY_PHASE_A_SKIP_BUILD=true pnpm run verify:phase-a` passes with structural/uniqueness assertions.
  - `bash mcp/scripts/check` passes with strengthened health-contract gate.

## Unit WS-A-34: Inspect golden-fixture regression gate

### Planned objective

Deepen P0-008 schema stability by introducing fixture-based regression checks for inspect payload outputs across core scopes.

### Implemented changes

1. Added inspect golden fixtures:
   - `mcp/packages/server/data/fixtures/inspect-selection-golden.json`
   - `mcp/packages/server/data/fixtures/inspect-page-golden.json`
   - `mcp/packages/server/data/fixtures/inspect-selection-fallback-golden.json`
2. Extended `mcp/scripts/verify-inspect-handoff`:
   - now loads fixture payloads and uses them in fake-plugin responses,
   - preserves strict contract assertions for hierarchy/layout/style/token fields,
   - adds canonical deep-equality checks against fixture payloads for:
     - selection scope,
     - page scope,
     - selection-fallback scope,
   - retains deterministic missing-target diagnostic check (`RESOURCE_NOT_FOUND`).
3. Updated traceability docs:
   - capability matrix, parity backlog, and `mcp/README.md` now reference inspect golden-fixture regression coverage.

### Unit review (detailed)

- **Review scope**
  - fixture baseline consistency for inspect payload outputs,
  - compatibility of fixture-equality checks with existing strict contract assertions,
  - regression safety of missing-target diagnostic scenario.
- **Issues found during review**
  1. None; targeted inspect probe and full check pipeline passed on first implementation.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `VERIFY_INSPECT_SKIP_BUILD=true pnpm run verify:inspect-handoff` passes with fixture equality checks.
  - `bash mcp/scripts/check` passes with inspect fixture regression gate enabled.

## Unit WS-A-35: Collaboration golden-fixture regression + strict contract gate

### Planned objective

Deepen P1-001 collaboration stability by introducing fixture-based regression baselines and strict contract assertions across awareness/thread payloads.

### Implemented changes

1. Added collaboration golden fixtures:
   - `mcp/packages/server/data/fixtures/collaboration-inspect-threads-golden.json`
   - `mcp/packages/server/data/fixtures/collaboration-inspect-awareness-golden.json`
   - `mcp/packages/server/data/fixtures/collaboration-create-thread-golden.json`
   - `mcp/packages/server/data/fixtures/collaboration-reply-thread-golden.json`
   - `mcp/packages/server/data/fixtures/collaboration-set-thread-resolved-golden.json`
   - `mcp/packages/server/data/fixtures/collaboration-remove-thread-golden.json`
2. Extended `mcp/scripts/verify-collaboration-context`:
   - now loads collaboration fixtures and uses them as fake-plugin return payloads,
   - added strict payload contract validators for:
     - `inspect_threads` (`page`/`filters`/`threadCount`/`threads[]`),
     - `inspect_awareness` (`currentUser`/`activeUsers`/`metrics`),
     - `create_thread`,
     - `reply_thread`,
     - `set_thread_resolved`,
     - `remove_thread`,
   - added canonical deep-equality fixture checks for all success operations,
   - added default-value semantics assertions for inspect calls invoked without optional args:
     - `inspect_threads` defaults (`onlyYours=false`, `includeResolved=true`),
     - `inspect_awareness` defaults (`includeCurrentUser=true`, `includeActiveUsers=true`),
   - preserved deterministic diagnostics checks:
     - permission denied (`PERMISSION_DENIED`),
     - missing thread (`RESOURCE_NOT_FOUND`).
3. Updated traceability docs:
   - capability matrix, parity backlog, and `mcp/README.md` now reference collaboration strict-contract + golden-fixture regression coverage.

### Unit review (detailed)

- **Review scope**
  - fixture baseline consistency for collaboration inspect/mutation payloads,
  - strict contract compatibility for awareness/thread schemas,
  - regression safety of permission/not-found diagnostics.
- **Issues found during review**
  1. None; targeted collaboration probe and full check pipeline passed on first implementation.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `VERIFY_COLLAB_SKIP_BUILD=true pnpm run verify:collaboration-context` passes with strict contract + fixture equality assertions.
  - `bash mcp/scripts/check` passes with collaboration fixture regression gate enabled.

## Unit WS-A-36: Export PNG golden-fidelity + artifact parity gate

### Planned objective

Deepen P1-002 export stability by extending fixture-based fidelity checks from SVG-only coverage to PNG output and persisted artifact parity.

### Implemented changes

1. Added PNG golden fixture:
   - `mcp/packages/server/data/fixtures/export-shape-golden.png`
   - canonical expected PNG bytes used by export-workflow probe.
2. Extended `mcp/scripts/verify-export-workflows`:
   - now loads both `export-shape-golden.svg` and `export-shape-golden.png`,
   - validates in-memory PNG response payloads (`shape` and `fill`) match golden PNG bytes exactly,
   - validates file-saved PNG artifact (`filePath`) matches golden PNG bytes exactly,
   - preserves existing SVG in-memory + persisted fidelity checks and diagnostics matrix assertions.
3. Updated traceability docs:
   - capability matrix, parity backlog, and `mcp/README.md` now reference golden SVG/PNG fidelity regression coverage.

### Unit review (detailed)

- **Review scope**
  - PNG payload determinism for in-memory response paths (`shape` and `fill`),
  - persisted PNG artifact parity with golden bytes,
  - compatibility with existing SVG fidelity and diagnostics behavior.
- **Issues found during review**
  1. None; targeted export probe and full check pipeline passed on first implementation.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `VERIFY_EXPORT_SKIP_BUILD=true pnpm run verify:export-workflows` passes with golden SVG/PNG fidelity assertions.
  - `bash mcp/scripts/check` passes with export PNG artifact parity gate enabled.

## Unit WS-A-37: Collaboration filter/toggle semantics fixture gate

### Planned objective

Deepen P1-001 collaboration contract confidence by adding explicit filter/toggle semantics coverage for thread/awareness inspect operations.

### Implemented changes

1. Added collaboration variant fixtures:
   - `mcp/packages/server/data/fixtures/collaboration-inspect-threads-filtered-golden.json`
   - `mcp/packages/server/data/fixtures/collaboration-inspect-awareness-minimal-golden.json`
2. Extended `mcp/scripts/verify-collaboration-context`:
   - fake-plugin router now parses inspect criteria/toggle flags from generated code and returns scenario-specific fixture payloads,
   - added `inspect_threads` filtered scenario assertions:
     - `onlyYours=true`,
     - `includeResolved=false`,
   - added `inspect_awareness` minimal scenario assertions:
     - `includeCurrentUser=false`,
     - `includeActiveUsers=false`,
   - added fixture deep-equality checks for both variant scenarios,
   - preserved strict contract checks + deterministic diagnostics checks.
3. Updated traceability docs:
   - capability matrix, parity backlog, and `mcp/README.md` now reference collaboration filter/toggle semantics coverage.

### Unit review (detailed)

- **Review scope**
  - inspect filter/toggle semantics determinism in collaboration payloads,
  - compatibility with existing strict contract + fixture regression checks,
  - regression safety of permission/not-found diagnostics.
- **Issues found during review**
  1. None; targeted collaboration probe passed after first implementation.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `VERIFY_COLLAB_SKIP_BUILD=true pnpm run verify:collaboration-context` passes with filter/toggle + fixture assertions.
  - `bash mcp/scripts/check` passes with collaboration variant-fixture gate enabled.

## Unit WS-A-38: Cross-tool workflow acceptance continuity gate

### Planned objective

Reduce remaining P0 workflow-continuity risk by introducing a single-session acceptance gate that validates handoff continuity across project/file/canvas/inspect tools.

### Implemented changes

1. Added acceptance probe:
   - `mcp/scripts/verify-workflow-acceptance`
   - validates end-to-end chain in one MCP client session:
     - `active_design_context` initial anchor,
     - `file_lifecycle` inspect/create/open,
     - `canvas_editing` create/move/resize/fill,
     - `inspect_handoff` selection extract,
     - `active_design_context` final context reconciliation.
2. Integrated probe into quality pipeline:
   - added `pnpm run verify:workflow-acceptance` in `mcp/package.json`,
   - wired `VERIFY_WORKFLOW_SKIP_BUILD=true pnpm run verify:workflow-acceptance` into `mcp/scripts/check`.
3. Updated traceability docs:
   - capability matrix and parity backlog rows for P0-004/P0-005/P0-006/P0-008 now reference cross-tool acceptance-chain evidence.
   - `mcp/README.md` now documents the new probe command.

### Unit review (detailed)

- **Review scope**
  - tool-chain continuity in a single runtime session (context -> file -> canvas -> inspect),
  - payload-contract compatibility at each chain stage,
  - check-pipeline integration safety.
- **Issues found during review**
  1. None; targeted acceptance probe and full check pipeline passed on first implementation.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `pnpm run verify:workflow-acceptance` passes with chain continuity assertions.
  - `bash mcp/scripts/check` passes with workflow acceptance gate enabled.

## Unit WS-A-39: Live workspace workflow continuity probe

### Planned objective

Reduce remaining P0 live-environment uncertainty by adding a real plugin-session workflow probe that validates the project/file/canvas/inspect chain against an actual workspace context.

### Implemented changes

1. Added live workflow probe:
   - `mcp/scripts/verify-workflow-live`
   - boots MCP server and waits for a real plugin bridge connection (`/health.pluginBridge.connectedClients > 0`),
   - executes live chain:
     - `active_design_context` (pre),
     - `file_lifecycle` inspect/create/open,
     - `canvas_editing` create/move/resize/fill,
     - `inspect_handoff` page-scope extract (`includeCss=false`),
     - `file_lifecycle` inspect (post),
     - `active_design_context` (post),
   - validates strict contract and continuity invariants across chain boundaries.
2. Added optional live payload capture mode:
   - `VERIFY_WORKFLOW_LIVE_CAPTURE_DIR=<dir>`
   - stores operation payload snapshots for live fixture curation.
3. Added controlled no-plugin handling for dry-run environments:
   - `VERIFY_WORKFLOW_LIVE_ALLOW_NO_PLUGIN=true`
   - allows script to exit cleanly when no live plugin session is available (for local syntax/flow validation).
4. Added package command:
   - `pnpm run verify:workflow-live`
5. Updated traceability docs:
   - capability matrix/backlog/`mcp/README.md` now reference live workflow probe availability.

### Unit review (detailed)

- **Review scope**
  - live plugin-session precondition handling and failure guidance,
  - cross-tool continuity assertions under real workspace context,
  - compatibility with existing synthetic acceptance probe.
- **Issues found during review**
  1. No functional defects found in dry-run validation path.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `VERIFY_WORKFLOW_LIVE_SKIP_BUILD=true VERIFY_WORKFLOW_LIVE_ALLOW_NO_PLUGIN=true VERIFY_WORKFLOW_LIVE_PLUGIN_WAIT_SECS=2 pnpm run verify:workflow-live` passes (dry-run mode).
  - In live environment with connected plugin session, `pnpm run verify:workflow-live` passes with full chain assertions.

## Unit WS-A-40: Live collaboration inspect/awareness probe

### Planned objective

Reduce remaining P1-001 live-environment uncertainty by adding a real plugin-session probe for collaboration inspect/awareness payload stability and diagnostics behavior.

### Implemented changes

1. Added live collaboration probe:
   - `mcp/scripts/verify-collaboration-live`
   - boots MCP server and waits for real plugin bridge connection (`/health.pluginBridge.connectedClients > 0`),
   - validates live inspect operations:
     - `inspect_threads` (default filters),
     - `inspect_awareness` (default toggles),
     - `inspect_awareness` (minimal toggles),
   - validates deterministic missing-page diagnostic:
     - `inspect_threads` with generated missing page id -> `RESOURCE_NOT_FOUND`.
2. Added optional live payload capture mode:
   - `VERIFY_COLLAB_LIVE_CAPTURE_DIR=<dir>`
   - stores inspect payload snapshots for live-fixture curation.
3. Added controlled no-plugin handling for dry-run environments:
   - `VERIFY_COLLAB_LIVE_ALLOW_NO_PLUGIN=true`
   - allows clean exit when no live plugin session is available.
4. Added package command:
   - `pnpm run verify:collaboration-live`
5. Updated traceability docs:
   - capability matrix/backlog/`mcp/README.md` now reference live collaboration probe availability.

### Unit review (detailed)

- **Review scope**
  - live plugin-session precondition handling and diagnostic clarity,
  - collaboration inspect/awareness payload contract assertions,
  - compatibility with synthetic collaboration regression probe.
- **Issues found during review**
  1. No functional defects found in dry-run validation path.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `VERIFY_COLLAB_LIVE_SKIP_BUILD=true VERIFY_COLLAB_LIVE_ALLOW_NO_PLUGIN=true VERIFY_COLLAB_LIVE_PLUGIN_WAIT_SECS=2 pnpm run verify:collaboration-live` passes (dry-run mode).
  - In live environment with connected plugin session, `pnpm run verify:collaboration-live` passes with inspect/awareness assertions.

## Unit WS-A-41: Live export workflow probe

### Planned objective

Reduce remaining P1-002 live-environment uncertainty by adding a real plugin-session probe for export workflow behavior and artifact-save continuity.

### Implemented changes

1. Added live export probe:
   - `mcp/scripts/verify-export-live`
   - boots MCP server and waits for real plugin bridge connection (`/health.pluginBridge.connectedClients > 0`),
   - creates a live rectangle via `canvas_editing`,
   - validates export paths on that shape:
     - `export_shape` as PNG (in-memory image payload),
     - `export_shape` as SVG (in-memory text payload),
     - file-save for PNG and SVG (artifact existence + non-empty content),
   - validates deterministic missing-shape diagnostic:
     - `shapeId=missing-live-shape-*` -> `RESOURCE_NOT_FOUND`.
2. Added optional live payload capture mode:
   - `VERIFY_EXPORT_LIVE_CAPTURE_DIR=<dir>`
   - stores export response/artifact metadata for live-fixture curation.
3. Added controlled no-plugin handling for dry-run environments:
   - `VERIFY_EXPORT_LIVE_ALLOW_NO_PLUGIN=true`
   - allows clean exit when no live plugin session is available.
4. Added package command:
   - `pnpm run verify:export-live`
5. Updated traceability docs:
   - capability matrix/backlog/`mcp/README.md` now reference live export probe availability.

### Unit review (detailed)

- **Review scope**
  - live plugin-session precondition handling and failure guidance,
  - export in-memory and persisted artifact checks in real workspace context,
  - compatibility with existing synthetic export regression probe.
- **Issues found during review**
  1. No functional defects found in dry-run validation path.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `VERIFY_EXPORT_LIVE_SKIP_BUILD=true VERIFY_EXPORT_LIVE_ALLOW_NO_PLUGIN=true VERIFY_EXPORT_LIVE_PLUGIN_WAIT_SECS=2 pnpm run verify:export-live` passes (dry-run mode).
  - In live environment with connected plugin session, `pnpm run verify:export-live` passes with export assertions.

## Unit WS-A-42: Live evidence bundle + report gate

### Planned objective

Improve closure readiness by providing a single command that runs all live probes and emits a normalized evidence report for review/audit.

### Implemented changes

1. Added live evidence bundle script:
   - `mcp/scripts/verify-live-evidence`
   - runs:
     - `verify:workflow-live`
     - `verify:collaboration-live`
     - `verify:export-live`
   - writes per-probe logs and capture dirs under one evidence root.
2. Added summary outputs:
   - `summary.json`
   - `summary.md`
   - includes probe status (`captured`/`skipped`/`failed`), captured JSON count, and log paths.
3. Added execution controls:
   - `VERIFY_LIVE_EVIDENCE_ALLOW_NO_PLUGIN` (default `true`),
   - `VERIFY_LIVE_EVIDENCE_REQUIRE_CAPTURE` (default `false`),
   - `VERIFY_LIVE_EVIDENCE_SKIP_BUILD` (default `true`),
   - `VERIFY_LIVE_EVIDENCE_PLUGIN_WAIT_SECS`,
   - `VERIFY_LIVE_EVIDENCE_DIR`.
4. Added package command:
   - `pnpm run verify:live-evidence`
5. Updated traceability docs:
   - capability matrix/backlog and `mcp/README.md` now reference the live evidence bundle entrypoint.

### Unit review (detailed)

- **Review scope**
  - multi-probe orchestration behavior and status derivation logic,
  - summary artifact completeness and readability,
  - compatibility with no-plugin dry-run and live capture modes.
- **Issues found during review**
  1. Initial markdown summary template contained malformed formatting in evidence-directory lines.
  2. Initial probe-result parsing was empty because progress logs were written to stdout inside command substitution, producing invalid `summary.json` fields.
- **Fix applied**
  1. Simplified and corrected summary markdown block output to deterministic plain lines.
  2. Redirected per-probe progress logs to stderr so machine-readable probe result lines remain parse-safe.
- **Post-fix validation criteria**
  - `VERIFY_LIVE_EVIDENCE_ALLOW_NO_PLUGIN=true VERIFY_LIVE_EVIDENCE_SKIP_BUILD=true pnpm run verify:live-evidence` passes (dry-run mode) and writes summary artifacts.
  - In live environment with connected plugin session and `VERIFY_LIVE_EVIDENCE_REQUIRE_CAPTURE=true`, `pnpm run verify:live-evidence` passes with all probes in `captured` status.

## Remaining Phase A gaps after this execution

- Workflow parity for project/file/canvas/inspect domains still needs captured live fixture evidence and closure criteria sign-off (`verify:workflow-live` + `verify:live-evidence` entrypoints shipped).
- Collaboration context still needs captured live workspace fixture evidence for awareness payload stability before row closure (`verify:collaboration-live` + `verify:live-evidence` entrypoints shipped).
- Export workflows still need captured live fixture-based fidelity metrics before row closure (`verify:export-live` + `verify:live-evidence` entrypoints shipped).
- Matrix row completion claims still require merged test evidence per row.
