---
title: Web + MCP + Desktop Delivery Roadmap & Plan
desc: Implementation-first roadmap and execution plan for web client workflows, MCP bridge capabilities, install/setup simplicity, and a Flutter desktop app with embedded MCP.
---

# Web + MCP + Desktop Delivery Roadmap

This roadmap defines an **implementation-first** delivery strategy for the following goals:

1. Make web client + MCP bridge support complete and reliable.
2. Make installation and setup simple for operators and end users.
3. Fully port all desktop user-facing workflows into a Flutter desktop app (macOS/Windows).
4. Embed MCP directly in the desktop app so users can run features without separate MCP setup.
5. Ensure deployable server environments include required user management features.
6. Persist in-progress work periodically to storage so users can resume editing safely.
7. Expose all core capabilities through MCP.
8. Provide design output that can be transformed into structured code through LLMs.

> Delivery rule: avoid skeleton-only handoffs. Features should be shipped end-to-end unless a dependency is genuinely unknown or blocked.

## Documentation continuity

Use the [Web + MCP + Desktop Documentation Map](/technical-guide/developer/web-mcp-documentation-map/)
as the canonical navigation and update protocol across roadmap, plan, backlog, matrix, contracts, and execution logs.

## Guiding principles

- **Parity before expansion**: maintain feature parity across Web, MCP, and Desktop first.
- **One-source domain logic**: keep business rules in shared services/contracts to avoid divergence.
- **Secure-by-default**: require explicit authN/authZ paths for browser, API, MCP, and desktop channels.
- **Recoverability by design**: autosave and object storage durability are baseline requirements, not optional add-ons.
- **Code generation with traceability**: every LLM-oriented export should preserve component identity, design token references, and layout semantics.
- **Flutter full-port mandate**: desktop user-facing workflows are delivered via Flutter implementation, not hybrid legacy shells, except explicitly blocked temporary paths with removal dates.

## Target architecture

### 1) Client surfaces

- **Web client**: current primary UI surface.
- **Desktop client (Flutter)**:
  - Shared API contracts with web backend.
  - Local UX shell for native app behavior (windowing, filesystem integrations, OS keychain support).
  - Embedded MCP runtime to avoid external MCP process setup for most users.

### 2) Service layer

- Backend services remain source of truth for:
  - identity and access,
  - collaboration state,
  - file/project metadata,
  - export/code-generation jobs,
  - storage orchestration.

### 3) MCP capability layer

- MCP endpoints should cover:
  - project/file CRUD,
  - design object traversal and edits,
  - asset management,
  - inspect/export/code handoff,
  - automation hooks required by agent workflows.

### 4) Persistence

- Autosave writes to durable storage at scheduled intervals and on key lifecycle events.
- Restore pipeline supports crash/session recovery by replaying the latest valid persisted state.

## Implementation phases

### Phase A — Foundation hardening (Web + MCP bridge)

- Define a capability matrix for Web features vs MCP features.
- Close all gaps where web functionality has no MCP equivalent.
- Standardize MCP auth model (token lifecycle, rotation, expiration recovery UX).
- Add setup simplifications:
  - single-command local bootstrap,
  - env validation checks,
  - clear diagnostics for MCP connectivity failures.

**Exit criteria**

- Every production web workflow has a documented and tested MCP operation path.
- Fresh developer/operator setup can be completed from clean environment with concise documented steps.

### Phase B — Storage and user-management guarantees

- Enforce required user-management flows in deployable server profile:
  - registration/invite,
  - login/session handling,
  - role/permission boundaries,
  - audit-friendly account lifecycle actions.
- Strengthen autosave policy:
  - periodic in-session snapshots,
  - conflict-aware persistence,
  - resumable drafts after network/process interruption.
- Verify storage durability behavior in object storage deployments.

**Exit criteria**

- Editing sessions survive expected interruption scenarios with bounded data loss.
- User-management requirements are covered by integration tests and deployment docs.

### Phase C — Flutter desktop parity

- Build Flutter desktop shell for macOS/Windows.
- Implement backend connectivity using the same contract as web clients.
- Port all supported web workflows with parity checklist and acceptance tests.
- Add desktop-native quality features:
  - secure local credential storage,
  - auto-update channel,
  - robust crash reporting.

**Exit criteria**

- Feature parity matrix indicates no critical missing workflow compared to web baseline.
- Desktop app can be installed and first-run configured without manual MCP tooling.
- Desktop release scope is fully Flutter-rendered/Flutter-controlled for user-facing workflows included in the parity checklist.

### Phase D — Embedded MCP in Desktop

- Integrate MCP runtime directly in desktop distribution.
- Provide one-click (or zero-config) MCP enablement for local assistant clients.
- Add MCP runtime health checks and self-healing restart behavior.
- Maintain Flutter-native desktop runtime as the primary distribution path while embedding MCP.

**Exit criteria**

- Users can call MCP features from desktop installation without separate bridge setup.
- Observability confirms stable MCP runtime behavior under normal desktop usage.

### Phase E — LLM-ready structured code delivery

- Define canonical intermediate representation for design-to-code extraction.
- Ensure exports contain:
  - layout semantics,
  - component hierarchy,
  - token/variant mappings,
  - inspect metadata.
- Add LLM-facing packaging formats and prompt scaffolds for reliable code synthesis.

**Exit criteria**

- Representative design samples can be transformed into structured code with consistent component mapping and minimal manual cleanup.

## Definition of done policy (implementation-first)

A task is considered complete only when:

1. Runtime behavior is implemented end-to-end.
2. Tests validate expected behavior at the appropriate level (unit/integration/e2e).
3. Observability and operational diagnostics are included.
4. User/developer documentation is updated.
5. No placeholder-only stubs are merged unless explicitly marked as blocked with dependency notes.

## Suggested delivery tracking artifacts

- **Capability matrix**: Web ↔ MCP ↔ Desktop parity table.
- **Desktop parity acceptance baseline**: workflow-level Flutter parity gates and evidence expectations.
- **Resilience test suite**: autosave/recovery/storage durability scenarios.
- **Install scorecard**: time-to-first-run, setup failure rate, and remediation quality.
- **LLM handoff benchmark**: design-to-structured-code fidelity metrics.

## Workstreams

### WS-A. Capability parity (Web ↔ MCP)

**Objective**: Ensure every production web workflow has an MCP-equivalent operation path.

**Tasks**

1. Build and maintain a living capability matrix.
2. Map each web workflow to MCP tool/API support status, required auth/permission model, test coverage level, and operational diagnostics.
3. Prioritize gaps by business frequency and user impact.
4. Close top-priority gaps with end-to-end tests.

**Deliverables**: `web-mcp-capability-matrix.md` (living artifact), E2E parity checks for P0 workflows.

### WS-B. Setup and operability

**Objective**: Reduce time-to-first-success for developer/operator MCP setup.

**Tasks**

1. Define bootstrap success criteria (fresh machine path).
2. Add environment preflight validation (ports, node/pnpm, required services).
3. Add diagnostics for common MCP bridge failures (plugin disconnected, websocket timeout, auth expiry).
4. Document one-command startup and remediation steps.

**KPIs**: Median local setup completion time, setup failure rate on clean environments, mean time to diagnose connection failures.

### WS-C. Recoverability and durability (Phase B preparation)

**Objective**: Establish autosave/recovery implementation contract before full Phase B delivery.

**Tasks**

1. Define autosave SLA (interval, max acceptable data loss window, retry policy).
2. Define restore invariants (latest valid snapshot, conflict behavior, partial-failure handling).
3. Create resilience test matrix for interruption scenarios.

### WS-D. Desktop delivery readiness

**Objective**: De-risk and deliver desktop parity through a full Flutter port with stable contract boundaries.

**Tasks**

1. Freeze API contract subset required by desktop MVP.
2. Publish parity checklist to track web workflow porting.
3. Define desktop-specific non-functional requirements (secure credential storage, crash reporting, update strategy).
4. Maintain migration inventory for remaining non-Flutter desktop paths and decommission plan per path.
5. Maintain executable workflow acceptance baseline for Flutter parity gates.

### WS-E. LLM structured export readiness

**Objective**: Prepare code-handoff contract so desktop and MCP channels can reuse the same representation.

**Tasks**

1. Define canonical intermediate representation for design-to-code handoff.
2. Select golden fixtures and expected outputs.
3. Add fidelity metrics for hierarchy, token mapping, and layout semantics.

## Desktop full-port mandate

- Target desktop end-state is a full Flutter port for user-facing workflows.
- Hybrid legacy desktop shells are treated as temporary transition paths only when explicitly blocked.
- Any temporary non-Flutter path must include: blocker reference, owner, removal deadline, parity impact note.

## Milestones

| Milestone | Target outcome | Primary owner role |
|---|---|---|
| M1 | Capability matrix v1 published, P0 parity gaps identified | MCP + web platform |
| M2 | Top P0 gaps closed with automated tests | MCP team |
| M3 | Setup preflight + diagnostics shipped and documented | DevEx / platform |
| M4 | Autosave/recovery SLA + resilience suite baseline approved | Backend + reliability |
| M5 | Desktop contract freeze + parity checklist baseline + full Flutter port tracking baseline | Desktop + API |
| M6 | Structured export contract + fixtures baseline | Design-to-code |

## Risk register

| Risk | Impact | Mitigation |
|---|---|---|
| MCP parity appears complete but misses edge workflows | High | Validate with workflow-based acceptance tests and matrix review cadence |
| Setup complexity increases with local network/browser security changes | Medium | Keep diagnostics up to date and maintain browser-specific troubleshooting guidance |
| Desktop parity drifts from web semantics or remains hybrid longer than planned | High | Maintain shared contract tests, enforce parity checklist sign-off, and track non-Flutter path decommission deadlines |
| Autosave restores inconsistent state under conflicts | High | Add conflict-aware persistence contract and replay tests |
| LLM export output quality is unstable across design patterns | Medium | Use golden fixture regression gates and fidelity thresholds |

## Operating cadence

- Weekly: capability matrix review and parity status update.
- Bi-weekly: top risk re-evaluation and mitigation audit.
- Per release: setup scorecard + resilience test report.

## Immediate next actions

1. Publish capability matrix v0 (seed set of high-frequency workflows).
2. Mark current MCP coverage and identify P0 parity gaps.
3. Create and prioritize implementation tickets from P0 rows.
4. Add automated parity checks for the first closed P0 workflows.

## Tracking artifacts

- [Web + MCP + Desktop Documentation Map](/technical-guide/developer/web-mcp-documentation-map/)
- [Web ↔ MCP Capability Matrix](/technical-guide/developer/web-mcp-capability-matrix/)
- [Web + MCP Phase A Execution Log](/technical-guide/developer/web-mcp-phase-a-execution-log/)
- [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/)
- [Web ↔ MCP Auth/Session Recovery Contract](/technical-guide/developer/web-mcp-auth-session-recovery-contract/)
- [Web + MCP Phase A Ticket Seed](/technical-guide/developer/web-mcp-phase-a-ticket-seed/)
- [Desktop Flutter Parity Baseline](/technical-guide/developer/desktop-flutter-parity-baseline/)
- [Desktop Flutter Release Validation](/technical-guide/developer/desktop-flutter-release-validation/)
