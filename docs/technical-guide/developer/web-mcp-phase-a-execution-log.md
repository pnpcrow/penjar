---
title: Web + MCP Phase A Execution Log
desc: Detailed implementation record and unit-by-unit review log for Phase A delivery work.
---

# Web + MCP Phase A Execution Log

This log records execution work for Phase A tasks from the
[Detailed Implementation Plan](/technical-guide/developer/web-mcp-desktop-implementation-plan/).

## Execution baseline

- Active plan scope: **WS-B (Setup and operability)** in Phase A.
- Work date: **2026-03-04**.
- Delivery rule applied: implementation-first (runtime + diagnostics + docs, then review).

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
4. Added plugin preview port configurability through `PENPOT_MCP_PLUGIN_PORT` in `mcp/packages/plugin/vite.config.ts`.

### Unit review (detailed)

- **Review scope**
  - Script behavior consistency (`preflight` vs setup/bootstrap flow).
  - Port model consistency between preflight checks and actual runtime.
- **Issues found during review**
  1. Preflight allowed overriding plugin port, but plugin runtime initially did not read that variable.
  2. Preflight hard-failed when `corepack` was missing, even when `pnpm` was already installed and usable.
- **Fix applied**
  1. Added `PENPOT_MCP_PLUGIN_PORT` support in plugin Vite config and startup logs.
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
4. Updated `mcp/packages/server/src/PenpotMcpServer.ts`:
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
   - documented `PENPOT_MCP_PLUGIN_PORT`.
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

## Remaining Phase A gaps after this execution

- Authentication/session lifecycle automation tests are still open.
- Workflow parity for project/file/canvas/inspect domains still needs contract-level acceptance tests.
- Matrix row completion claims still require merged test evidence per row.
