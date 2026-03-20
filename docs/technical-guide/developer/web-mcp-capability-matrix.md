---
title: Web ↔ MCP Capability Matrix
desc: Living matrix for tracking workflow parity between the web client and MCP capabilities.
---

# Web ↔ MCP Capability Matrix

This is the execution artifact for Phase A in the Web + MCP + Desktop roadmap.

## Related execution artifacts

- Navigation and update protocol:
  - [Web + MCP + Desktop Documentation Map](/technical-guide/developer/web-mcp-documentation-map/)
- Planning anchors:
  - [Web + MCP + Desktop Delivery Roadmap & Plan](/technical-guide/developer/web-mcp-desktop-roadmap/)
- Execution/detail anchors:
  - [Web + MCP Phase A Execution Log](/technical-guide/developer/web-mcp-phase-a-execution-log/)

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
| Project lifecycle | Open project and navigate file context | Partial | P0 | `active_design_context` + `verify:project-lifecycle` now validates strict context contract invariants (file/page/selection cardinality), multi-context transitions, detached state, and deterministic `PERMISSION_DENIED` diagnostics; plus cross-tool acceptance chain evidence via `verify:workflow-acceptance`. `verify:workflow-live` is now available for real plugin-session/live-workspace continuity checks. |
| File lifecycle | Create/rename/delete files | Partial | P0 | `file_lifecycle` + `verify:file-lifecycle` now validates strict file/page payload contracts, create-page default naming behavior, name-based open-page semantics, deterministic denied/missing diagnostics, and delete-path `UNSUPPORTED_OPERATION` signaling; cross-tool acceptance chain (`verify:workflow-acceptance`) now covers create/open continuity into canvas + inspect handoff, and `verify:workflow-live` provides live workspace chain validation entrypoint. |
| Canvas editing | Create and modify shapes/components | Partial | P0 | `canvas_editing` + `verify:canvas-editing` now validates strict shape-payload contracts (geometry/fill types), create default-value semantics, and deterministic `PERMISSION_DENIED`/`RESOURCE_NOT_FOUND` diagnostics; cross-tool acceptance chain (`verify:workflow-acceptance`) validates downstream inspect handoff continuity after canvas mutations, and `verify:workflow-live` extends this to live plugin sessions. |
| Asset management | Browse/use/upload assets | Partial | P0 | `verify:asset-management` now validates import payload contract, repeated-import idempotency, missing-file `RESOURCE_NOT_FOUND`, interruption diagnostics (timeout/disconnect), and reconnect-recovery import success. Extend to live reference-consistency fixtures for closure. |
| Collaboration context | Read comments/presence/context metadata | Partial | P1 | `collaboration_context` + `verify:collaboration-context` now validates strict payload contracts across threads/awareness operations, awareness/thread filter-toggle semantics, deterministic permission/not-found diagnostics, and golden JSON fixture regression baselines for inspect/create/reply/resolve/remove flows; `verify:collaboration-live` now provides live-session inspect/awareness contract + missing-page diagnostic checks with payload capture mode. Next add captured live fixture evidence for row closure. |
| Inspect/code handoff | Extract inspect metadata for implementation | Partial | P0 | `inspect_handoff` + `verify:inspect-handoff` now validates required/optional handoff contract fields, selection-fallback semantics, `RESOURCE_NOT_FOUND` diagnostics, and golden JSON fixture regression baseline for core scopes; cross-tool acceptance chain (`verify:workflow-acceptance`) validates selection-scope handoff after file/canvas transition sequence, while `verify:workflow-live` validates page-scope handoff in live sessions. Next add live fixture schema regression tests for closure. |
| Export workflows | Trigger export and retrieve artifacts | Partial | P1 | `verify:export-workflows` now validates PNG/SVG + fill export matrix, deterministic failure diagnostics (`UNSUPPORTED_OPERATION`, `RESOURCE_NOT_FOUND`, `PERMISSION_DENIED`), artifact file-save path, and golden SVG/PNG fixture fidelity regression for in-memory + persisted outputs; `verify:export-live` now provides live-session PNG/SVG + artifact-save + missing-shape diagnostic checks with capture mode. Next add captured live fidelity evidence for row closure. |
| Authentication/session | Recover from token/session expiration | Partial | P0 | Contract documented; `verify:auth-session` validates missing token, mismatched token, reconnect-retry success, and duplicate-token conflict handling in multi-user mode. |
| Diagnostics/health | Detect plugin/server disconnect and recovery | Partial | P0 | `/health` endpoint + remediation catalog + automated smoke check (`verify:phase-a`) now validates diagnostic catalog structure/uniqueness + endpoint contracts, and reconnect-cycle probe (`verify:bridge-recovery`) is shipped; add live-environment recovery fixtures for closure. |
| Setup/bootstrap | Clean-environment install to first successful request | Partial | P0 | `preflight` + one-command bootstrap + automated preflight gate (`verify:phase-a`) shipped; add clean-machine KPI measurements to close. |

## Parity backlog

This backlog tracks prioritized gap-closure items derived from the matrix rows above.

### Backlog status legend

- **Open**: Not implemented.
- **In progress**: Implementation started, not yet complete.
- **Closed**: Implementation merged and reviewed with evidence.

### P0 backlog

| ID | Domain | Gap statement | Status | Evidence / next step |
|---|---|---|---|---|
| P0-001 | Setup/bootstrap | Fresh-machine setup fails late due to missing runtime/port checks. | Closed | Added `mcp/scripts/preflight`; wired into `scripts/setup`/`bootstrap`; automated gate added via `pnpm run verify:phase-a` and integrated into `scripts/check`. |
| P0-002 | Diagnostics/health | Operators lack a single endpoint to inspect bridge/session health and failure context. | Closed | Added `/health` endpoint with bridge counters + remediation catalog; `verify:phase-a` now enforces payload contract + diagnostics catalog structure/uniqueness checks; reconnect recovery cycle check added in `pnpm run verify:bridge-recovery`; all enforced in `scripts/check`. |
| P0-003 | Authentication/session | Token lifecycle recovery in multi-user mode is not fully codified for clients. | Closed | Auth/session recovery contract published; `verify:auth-session` now validates missing-token failure, token-mismatch failure, reconnect-retry success flow, and duplicate-token conflict handling in multi-user mode. |
| P0-004 | Project lifecycle | End-to-end workflow continuity (project selection to active file context) is incomplete in MCP artifacts. | In progress | Extended `verify:project-lifecycle` with strict context contract assertions, multi-context transitions, deterministic `PERMISSION_DENIED` diagnostics, and cross-tool acceptance chain coverage. Next add captured live fixture evidence and closure criteria. |
| P0-005 | File lifecycle | CRUD parity under restricted roles is not fully verified. | In progress | Extended `verify:file-lifecycle` with strict file/page contract assertions, create-page default-name checks, and name-based open-page behavior plus deterministic diagnostics. Next step: add role-restricted live integration scenarios. |
| P0-006 | Canvas editing | Common geometry/style operations rely on generic code execution but lack scenario contracts. | In progress | Extended `verify:canvas-editing` with strict contract assertions for shape geometry/fill payloads, create default-value scenario checks, and deterministic diagnostics. Next add real fixture snapshots against live plugin behavior. |
| P0-007 | Asset management | Import/reference behavior lacks resilience checks for connection interruptions. | In progress | Extended `verify:asset-management` with import payload-contract assertions, repeated-import idempotency check, missing-file diagnostics, timeout/disconnect diagnostics, and reconnect-recovery import success. |
| P0-008 | Inspect/code handoff | Inspect payload completeness is not protected by contract tests. | In progress | Extended `verify:inspect-handoff` with required/optional contract assertions, selection-fallback semantics, deterministic diagnostics, and golden JSON fixture regression checks. Next add live fixture-based schema regression tests. |

### P1 backlog

| ID | Domain | Gap statement | Status | Evidence / next step |
|---|---|---|---|---|
| P1-001 | Collaboration context | Collaboration metadata needed by agent flows is not fully specified. | In progress | Extended `verify:collaboration-context` with strict contract assertions, awareness/thread filter-toggle semantics, and golden JSON fixture regression gates; `verify:collaboration-live` adds live checks. Next add captured live workspace fixture evidence. |
| P1-002 | Export workflows | Multi-format export behavior and error semantics need stronger diagnostics parity. | In progress | Extended `verify:export-workflows` with PNG/SVG/fill matrix checks, deterministic diagnostics, file-save artifact checks, and golden fixture fidelity regression gates; `verify:export-live` adds live checks. Next add captured live fixture-based fidelity metrics. |

### P2 backlog

No P2 tickets are scheduled until current P0 items are reduced, per operating rules.

### Live evidence capture note

- For P0/P1 rows requiring live workspace proof, run `pnpm run verify:live-evidence` and attach generated summary/report artifacts as closure evidence.

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

## Live evidence capture entrypoint

- Use `pnpm run verify:live-evidence` to execute live probes (`workflow`, `collaboration`, `export`) and generate a summary report (`summary.json`/`summary.md`) for closure evidence curation.
