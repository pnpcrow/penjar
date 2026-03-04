---
title: Web ↔ MCP Capability Matrix
desc: Living matrix for tracking workflow parity between the web client and MCP capabilities.
---

# Web ↔ MCP Capability Matrix

This is the execution artifact for Phase A in the Web + MCP + Desktop roadmap.

## Status legend

- **Complete**: Supported end-to-end with documented usage and tests.
- **Partial**: Exists but incomplete (missing edge behavior, auth, diagnostics, or tests).
- **Missing**: No practical MCP path for this workflow.
- **Unknown**: Needs verification.

## Prioritization model

- **P0**: High-frequency workflow and/or blocks primary user jobs.
- **P1**: Important but has workaround.
- **P2**: Nice to have or low-frequency.

## Matrix (v0 seed)

| Domain | Representative web workflow | MCP parity status | Priority | Notes / next action |
|---|---|---|---|---|
| Project lifecycle | Open project and navigate file context | Partial | P0 | Verify MCP workflow continuity from project selection to active file context. |
| File lifecycle | Create/rename/delete files | Partial | P0 | Confirm CRUD parity and permission/error behavior in constrained roles. |
| Canvas editing | Create and modify shapes/components | Partial | P0 | Ensure object creation + updates cover common geometry and style operations. |
| Asset management | Browse/use/upload assets | Partial | P0 | Validate media import and reference consistency under MCP operations. |
| Collaboration context | Read comments/presence/context metadata | Unknown | P1 | Clarify which collaboration metadata is required by agent workflows. |
| Inspect/code handoff | Extract inspect metadata for implementation | Partial | P0 | Add explicit contract tests for inspect output completeness. |
| Export workflows | Trigger export and retrieve artifacts | Partial | P1 | Verify multi-format export coverage and error reporting path. |
| Authentication/session | Recover from token/session expiration | Missing | P0 | Define token lifecycle and renewal UX for MCP clients. |
| Diagnostics/health | Detect plugin/server disconnect and recovery | Partial | P0 | Add health endpoint + operator-facing troubleshooting mapping. |
| Setup/bootstrap | Clean-environment install to first successful request | Partial | P0 | Add preflight checks and step-by-step failure remediation. |

## Gap-closure operating rules

1. A row can be moved to **Complete** only after:
   - parity behavior is verified end-to-end,
   - tests are merged,
   - operational diagnostics and docs are updated.
2. P0 rows are always resolved before introducing new P2 capabilities.
3. Any production incident tied to a row automatically escalates its priority by one level for the next planning cycle.

## Review protocol

- Weekly update owner: MCP maintainers + web workflow owner.
- Required evidence for status changes:
  - merged implementation reference,
  - test evidence,
  - docs/diagnostics update reference.
