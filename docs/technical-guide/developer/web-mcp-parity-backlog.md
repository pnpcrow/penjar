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
| P0-001 | Setup/bootstrap | Fresh-machine setup fails late due to missing runtime/port checks. | Closed | Added `mcp/scripts/preflight`; wired into `scripts/setup` and `pnpm run bootstrap`. |
| P0-002 | Diagnostics/health | Operators lack a single endpoint to inspect bridge/session health and failure context. | Closed | Added `/health` endpoint with bridge counters, session metrics, and remediation catalog. |
| P0-003 | Authentication/session | Token lifecycle recovery in multi-user mode is not fully codified for clients. | Open | Define renewal/reconnect flow and add integration checks for expired token scenarios. |
| P0-004 | Project lifecycle | End-to-end workflow continuity (project selection to active file context) is incomplete in MCP artifacts. | Open | Map concrete tool coverage and close missing operations with acceptance tests. |
| P0-005 | File lifecycle | CRUD parity under restricted roles is not fully verified. | Open | Add role-aware matrix tests and error-path diagnostics evidence. |
| P0-006 | Canvas editing | Common geometry/style operations rely on generic code execution but lack scenario contracts. | In progress | Add representative scenario fixtures and lock expected outputs. |
| P0-007 | Asset management | Import/reference behavior lacks resilience checks for connection interruptions. | Open | Add interruption/retry coverage and mismatch diagnostics. |
| P0-008 | Inspect/code handoff | Inspect payload completeness is not protected by contract tests. | Open | Add fixture-based checks for hierarchy/token/layout metadata coverage. |

## P1 backlog

| ID | Domain | Gap statement | Status | Evidence / next step |
|---|---|---|---|---|
| P1-001 | Collaboration context | Collaboration metadata needed by agent flows is not fully specified. | Open | Define minimum metadata contract and implement read-only MCP access where required. |
| P1-002 | Export workflows | Multi-format export behavior and error semantics need stronger diagnostics parity. | Open | Add format matrix checks and explicit failure-mode mapping. |

## P2 backlog

No P2 tickets are scheduled until current P0 items are reduced, per operating rules.
