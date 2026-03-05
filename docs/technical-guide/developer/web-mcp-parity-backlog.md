---
title: Web ↔ MCP Parity Backlog
desc: Prioritized backlog for closing parity gaps identified in the capability matrix.
---

# Web ↔ MCP Parity Backlog

This backlog is the execution companion to the [Web ↔ MCP Capability Matrix](/technical-guide/developer/web-mcp-capability-matrix/).

## Status legend

- **Open**: Not implemented.
- **In progress**: Implementation started, not yet complete.
- **Closed**: Implementation merged and reviewed with evidence.

## P0 backlog

| ID | Domain | Gap statement | Status | Evidence / next step |
|---|---|---|---|---|
| P0-001 | Setup/bootstrap | Fresh-machine setup fails late due to missing runtime/port checks. | Closed | Added `mcp/scripts/preflight`; wired into `scripts/setup`/`bootstrap`; automated gate added via `pnpm run verify:phase-a` and integrated into `scripts/check`. |
| P0-002 | Diagnostics/health | Operators lack a single endpoint to inspect bridge/session health and failure context. | Closed | Added `/health` endpoint with bridge counters + remediation catalog; `/health` payload contract check added in `pnpm run verify:phase-a`; reconnect recovery cycle check added in `pnpm run verify:bridge-recovery`; both enforced in `scripts/check`. |
| P0-003 | Authentication/session | Token lifecycle recovery in multi-user mode is not fully codified for clients. | Closed | Auth/session recovery contract published; `verify:auth-session` now validates missing-token failure, token-mismatch failure, reconnect-retry success flow, and duplicate-token conflict handling in multi-user mode. |
| P0-004 | Project lifecycle | End-to-end workflow continuity (project selection to active file context) is incomplete in MCP artifacts. | In progress | Extended `verify:project-lifecycle` with strict context contract assertions (selection cardinality + detached invariants), multi-context transitions, and deterministic `PERMISSION_DENIED` diagnostics. Next add real workspace-driven workflow scenarios. |
| P0-005 | File lifecycle | CRUD parity under restricted roles is not fully verified. | In progress | Extended `verify:file-lifecycle` with strict file/page contract assertions, create-page default-name checks, and name-based open-page behavior plus deterministic `PERMISSION_DENIED`/`RESOURCE_NOT_FOUND` diagnostics and `UNSUPPORTED_OPERATION` delete-path signaling. Next step: add role-restricted live integration scenarios on real environments, including backend-linked delete flow. |
| P0-006 | Canvas editing | Common geometry/style operations rely on generic code execution but lack scenario contracts. | In progress | Extended `verify:canvas-editing` with strict contract assertions for shape geometry/fill payloads, create default-value scenario checks, and deterministic `PERMISSION_DENIED`/`RESOURCE_NOT_FOUND` diagnostics. Next add real fixture snapshots against live plugin behavior. |
| P0-007 | Asset management | Import/reference behavior lacks resilience checks for connection interruptions. | In progress | Added `verify:asset-management` probe validating import success, timeout/disconnect diagnostics (`PLUGIN_TASK_TIMEOUT` / `PLUGIN_DISCONNECTED`), and reconnect-recovery import success with short timeout configuration. |
| P0-008 | Inspect/code handoff | Inspect payload completeness is not protected by contract tests. | In progress | Extended `verify:inspect-handoff` with required/optional contract assertions (hierarchy/layout/token/style), selection-fallback semantics, and deterministic `RESOURCE_NOT_FOUND` diagnostics. Next add live fixture-based schema regression tests. |

## P1 backlog

| ID | Domain | Gap statement | Status | Evidence / next step |
|---|---|---|---|---|
| P1-001 | Collaboration context | Collaboration metadata needed by agent flows is not fully specified. | In progress | Extended `collaboration_context` + `verify:collaboration-context` with `inspect_awareness` contract (current user/active users metrics) and deterministic `PERMISSION_DENIED` coverage for missing `user:read` scope. Next add live fixture checks for awareness payload stability. |
| P1-002 | Export workflows | Multi-format export behavior and error semantics need stronger diagnostics parity. | In progress | Added `verify:export-workflows` probe for PNG/SVG/fill matrix, deterministic `UNSUPPORTED_OPERATION`/`RESOURCE_NOT_FOUND`/`PERMISSION_DENIED` diagnostics, and file-save artifact checks. Next add live fixture-based fidelity metrics. |

## P2 backlog

No P2 tickets are scheduled until current P0 items are reduced, per operating rules.
