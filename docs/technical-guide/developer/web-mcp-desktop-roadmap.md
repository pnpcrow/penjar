---
title: Web + MCP + Desktop Delivery Roadmap
desc: Implementation-first roadmap for fully supporting web client workflows, MCP bridge capabilities, install/setup simplicity, and a Flutter desktop app with embedded MCP.
---

# Web + MCP + Desktop Delivery Roadmap

This roadmap defines an **implementation-first** delivery strategy for the following goals:

1. Make web client + MCP bridge support complete and reliable.
2. Make installation and setup simple for operators and end users.
3. Evolve all web-client-capable workflows into a Flutter desktop app (macOS/Windows).
4. Embed MCP directly in the desktop app so users can run features without separate MCP setup.
5. Ensure deployable server environments include required user management features.
6. Persist in-progress work periodically to storage so users can resume editing safely.
7. Expose all core capabilities through MCP.
8. Provide design output that can be transformed into structured code through LLMs.

> Delivery rule: avoid skeleton-only handoffs. Features should be shipped end-to-end unless a dependency is genuinely unknown or blocked.

## Guiding principles

- **Parity before expansion**: maintain feature parity across Web, MCP, and Desktop first.
- **One-source domain logic**: keep business rules in shared services/contracts to avoid divergence.
- **Secure-by-default**: require explicit authN/authZ paths for browser, API, MCP, and desktop channels.
- **Recoverability by design**: autosave and object storage durability are baseline requirements, not optional add-ons.
- **Code generation with traceability**: every LLM-oriented export should preserve component identity, design token references, and layout semantics.

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

### Phase D — Embedded MCP in Desktop

- Integrate MCP runtime directly in desktop distribution.
- Provide one-click (or zero-config) MCP enablement for local assistant clients.
- Add MCP runtime health checks and self-healing restart behavior.

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
- **Resilience test suite**: autosave/recovery/storage durability scenarios.
- **Install scorecard**: time-to-first-run, setup failure rate, and remediation quality.
- **LLM handoff benchmark**: design-to-structured-code fidelity metrics.

## Immediate next actions

1. Publish and maintain the capability matrix as a living artifact.
2. Prioritize MCP parity gaps that block high-frequency web workflows.
3. Lock autosave + recovery SLAs and validate against storage backends.
4. Stand up a Flutter desktop spike focused on authentication, file open/save, and embedded MCP bootstrap.
5. Create an LLM export contract with golden sample fixtures for regression checks.
## Tracking artifacts published

- [Web + MCP + Desktop Detailed Implementation Plan](/technical-guide/developer/web-mcp-desktop-implementation-plan/)
- [Web ↔ MCP Capability Matrix](/technical-guide/developer/web-mcp-capability-matrix/)
- [Web ↔ MCP Parity Backlog](/technical-guide/developer/web-mcp-parity-backlog/)
- [Web + MCP Phase A Execution Log](/technical-guide/developer/web-mcp-phase-a-execution-log/)
- [Web ↔ MCP Auth/Session Recovery Contract](/technical-guide/developer/web-mcp-auth-session-recovery-contract/)
- [Web + MCP Phase A Ticket Seed](/technical-guide/developer/web-mcp-phase-a-ticket-seed/)
