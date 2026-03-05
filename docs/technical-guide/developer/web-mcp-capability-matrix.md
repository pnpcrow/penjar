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
| Project lifecycle | Open project and navigate file context | Partial | P0 | `active_design_context` + `verify:project-lifecycle` now validates strict context contract invariants (file/page/selection cardinality), multi-context transitions, detached state, and deterministic `PERMISSION_DENIED` diagnostics. Next add real workspace navigation scenarios for closure. |
| File lifecycle | Create/rename/delete files | Partial | P0 | `file_lifecycle` + `verify:file-lifecycle` now validates strict file/page payload contracts, create-page default naming behavior, name-based open-page semantics, deterministic denied/missing diagnostics, and delete-path `UNSUPPORTED_OPERATION` signaling. Next add constrained-role live integration checks and backend-linked delete workflow closure. |
| Canvas editing | Create and modify shapes/components | Partial | P0 | `canvas_editing` + `verify:canvas-editing` now validates strict shape-payload contracts (geometry/fill types), create default-value semantics, and deterministic `PERMISSION_DENIED`/`RESOURCE_NOT_FOUND` diagnostics. Next add live fixture snapshot tests for closure. |
| Asset management | Browse/use/upload assets | Partial | P0 | `verify:asset-management` probe validates import path, interruption diagnostics (timeout/disconnect), and reconnect-recovery import success. Extend to live reference-consistency fixtures for closure. |
| Collaboration context | Read comments/presence/context metadata | Partial | P1 | `collaboration_context` tool + `verify:collaboration-context` probe now covers thread workflows plus `inspect_awareness` presence metadata (current user + active users) with deterministic permission/not-found diagnostics. Next add live workspace fixtures for awareness payload stability. |
| Inspect/code handoff | Extract inspect metadata for implementation | Partial | P0 | `inspect_handoff` + `verify:inspect-handoff` now validates required/optional handoff contract fields (hierarchy node shape, layout semantics, token hints, CSS/null style), selection-fallback semantics, and `RESOURCE_NOT_FOUND` diagnostics. Next add live fixture schema regression tests for closure. |
| Export workflows | Trigger export and retrieve artifacts | Partial | P1 | `verify:export-workflows` now validates PNG/SVG + fill export matrix, deterministic failure diagnostics (`UNSUPPORTED_OPERATION`, `RESOURCE_NOT_FOUND`, `PERMISSION_DENIED`), and artifact file-save path. Next add live fixture-based fidelity checks. |
| Authentication/session | Recover from token/session expiration | Partial | P0 | Contract documented; `verify:auth-session` validates missing token, mismatched token, reconnect-retry success, and duplicate-token conflict handling in multi-user mode. |
| Diagnostics/health | Detect plugin/server disconnect and recovery | Partial | P0 | `/health` endpoint + remediation catalog + automated smoke check (`verify:phase-a`) and reconnect-cycle probe (`verify:bridge-recovery`) shipped; add live-environment recovery fixtures for closure. |
| Setup/bootstrap | Clean-environment install to first successful request | Partial | P0 | `preflight` + one-command bootstrap + automated preflight gate (`verify:phase-a`) shipped; add clean-machine KPI measurements to close. |

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
