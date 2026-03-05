---
title: Web + MCP + Desktop Detailed Implementation Plan
desc: Execution-level plan derived from the roadmap, including workstreams, milestones, owners, KPIs, and rollout controls.
---

# Web + MCP + Desktop Detailed Implementation Plan

This document turns the roadmap into an execution plan that can be tracked sprint-by-sprint.

## 0. Documentation traceability anchors

- Canonical navigation/update protocol:
  - [Web + MCP + Desktop Documentation Map](/technical-guide/developer/web-mcp-documentation-map/)
- Execution evidence anchors (current phase):
  - [Web + MCP Phase A Execution Log](/technical-guide/developer/web-mcp-phase-a-execution-log/)
  - [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/)
  - [Web ↔ MCP Capability Matrix](/technical-guide/developer/web-mcp-capability-matrix/)
  - [Web ↔ MCP Parity Backlog](/technical-guide/developer/web-mcp-parity-backlog/)
  - [Web + MCP Phase A Ticket Seed](/technical-guide/developer/web-mcp-phase-a-ticket-seed/)
  - [Web ↔ MCP Auth/Session Recovery Contract](/technical-guide/developer/web-mcp-auth-session-recovery-contract/)
  - [Desktop Flutter Parity Checklist](/technical-guide/developer/desktop-flutter-parity-checklist/)
  - [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/)
  - [Desktop Flutter Parity Acceptance Baseline](/technical-guide/developer/desktop-flutter-parity-acceptance-baseline/)

## 1. Scope and sequencing

We follow the roadmap phase order and explicitly gate each phase:

1. **Phase A**: Web + MCP foundation hardening (current active phase)
2. **Phase B**: Storage and user-management guarantees
3. **Phase C**: Flutter desktop parity
4. **Phase D**: Embedded MCP runtime in desktop
5. **Phase E**: LLM-ready structured code delivery

A phase can start implementation in parallel only when dependencies are formally marked as non-blocking.

## 1.1 Desktop full-port mandate

- Target desktop end-state is a full Flutter port for user-facing workflows.
- Hybrid legacy desktop shells are treated as temporary transition paths only when explicitly blocked.
- Any temporary non-Flutter path must include:
  - blocker reference,
  - owner,
  - removal deadline,
  - parity impact note.

## 2. Workstreams

## WS-A. Capability parity (Web ↔ MCP)

**Objective**

- Ensure every production web workflow has an MCP-equivalent operation path.

**Implementation tasks**

1. Build and maintain a living capability matrix.
2. Map each web workflow to:
   - MCP tool/API support status,
   - required auth/permission model,
   - test coverage level,
   - operational diagnostics.
3. Prioritize gaps by business frequency and user impact.
4. Close top-priority gaps with end-to-end tests.

**Deliverables**

- `web-mcp-capability-matrix.md` (living artifact)
- MCP parity backlog grouped by severity (P0/P1/P2)
- E2E parity checks for P0 workflows

## WS-B. Setup and operability

**Objective**

- Reduce time-to-first-success for developer/operator MCP setup.

**Implementation tasks**

1. Define bootstrap success criteria (fresh machine path).
2. Add environment preflight validation (ports, node/pnpm, required services).
3. Add diagnostics for common MCP bridge failures (plugin disconnected, websocket timeout, auth expiry).
4. Document one-command startup and remediation steps.

**KPIs**

- Median local setup completion time
- Setup failure rate on clean environments
- Mean time to diagnose connection failures

## WS-C. Recoverability and durability (Phase B preparation)

**Objective**

- Establish autosave/recovery implementation contract before full Phase B delivery.

**Implementation tasks**

1. Define autosave SLA (interval, max acceptable data loss window, retry policy).
2. Define restore invariants (latest valid snapshot, conflict behavior, partial-failure handling).
3. Create resilience test matrix for interruption scenarios.

## WS-D. Desktop delivery readiness

**Objective**

- De-risk and deliver desktop parity through a full Flutter port with stable contract boundaries.

**Implementation tasks**

1. Freeze API contract subset required by desktop MVP.
2. Publish parity checklist to track web workflow porting.
3. Define desktop-specific non-functional requirements (secure credential storage, crash reporting, update strategy).
4. Maintain migration inventory for remaining non-Flutter desktop paths and decommission plan per path.
5. Maintain executable workflow acceptance baseline for Flutter parity gates.

## WS-E. LLM structured export readiness

**Objective**

- Prepare code-handoff contract so desktop and MCP channels can reuse the same representation.

**Implementation tasks**

1. Define canonical intermediate representation for design-to-code handoff.
2. Select golden fixtures and expected outputs.
3. Add fidelity metrics for hierarchy, token mapping, and layout semantics.

## 3. Milestones

| Milestone | Target outcome | Primary owner role |
|---|---|---|
| M1 | Capability matrix v1 published, P0 parity gaps identified | MCP + web platform |
| M2 | Top P0 gaps closed with automated tests | MCP team |
| M3 | Setup preflight + diagnostics shipped and documented | DevEx / platform |
| M4 | Autosave/recovery SLA + resilience suite baseline approved | Backend + reliability |
| M5 | Desktop contract freeze + parity checklist baseline + full Flutter port tracking baseline | Desktop + API |
| M6 | Structured export contract + fixtures baseline | Design-to-code |

## 4. Definition of done (execution checklist)

A task is complete only when all conditions below are true:

- Runtime behavior is available end-to-end.
- Test coverage exists at the right layer (unit/integration/e2e).
- Logs/metrics/diagnostics are in place.
- Docs are updated with operation and troubleshooting notes.
- No unresolved placeholder-only stubs remain.

## 5. Risk register

| Risk | Impact | Mitigation |
|---|---|---|
| MCP parity appears complete but misses edge workflows | High | Validate with workflow-based acceptance tests and matrix review cadence |
| Setup complexity increases with local network/browser security changes | Medium | Keep diagnostics up to date and maintain browser-specific troubleshooting guidance |
| Desktop parity drifts from web semantics or remains hybrid longer than planned | High | Maintain shared contract tests, enforce parity checklist sign-off, and track non-Flutter path decommission deadlines |
| Autosave restores inconsistent state under conflicts | High | Add conflict-aware persistence contract and replay tests |
| LLM export output quality is unstable across design patterns | Medium | Use golden fixture regression gates and fidelity thresholds |

## 6. Operating cadence

- Weekly: capability matrix review and parity status update.
- Bi-weekly: top risk re-evaluation and mitigation audit.
- Per release: setup scorecard + resilience test report.

## 7. Immediate execution order

1. Publish capability matrix v0 (seed set of high-frequency workflows).
2. Mark current MCP coverage and identify P0 parity gaps.
3. Create and prioritize implementation tickets from P0 rows.
4. Add automated parity checks for the first closed P0 workflows.
