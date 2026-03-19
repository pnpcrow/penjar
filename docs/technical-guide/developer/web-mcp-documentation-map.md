---
title: Web + MCP + Desktop Documentation Map
desc: Relationship map and update protocol for roadmap, plan, backlog, matrix, contracts, and execution logs.
---

# Web + MCP + Desktop Documentation Map

This document is the canonical navigation map to keep development continuity without gaps.

## 1) Document relationship graph

1. Strategy, phases, workstreams, and execution plan:
   - [Web + MCP + Desktop Delivery Roadmap & Plan](/technical-guide/developer/web-mcp-desktop-roadmap/)
2. Current capability status and parity backlog by workflow:
   - [Web ↔ MCP Capability Matrix](/technical-guide/developer/web-mcp-capability-matrix/)
3. Ticket-level implementation seeds:
   - [Web + MCP Phase A Ticket Seed](/technical-guide/developer/web-mcp-phase-a-ticket-seed/)
4. Unit-by-unit execution evidence:
   - [Web + MCP Phase A Execution Log](/technical-guide/developer/web-mcp-phase-a-execution-log/)
5. Contract-level invariants:
   - [Web ↔ MCP Auth/Session Recovery Contract](/technical-guide/developer/web-mcp-auth-session-recovery-contract/)
6. Desktop full-port execution artifacts:
   - [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/)
   - [Desktop Flutter Parity Baseline](/technical-guide/developer/desktop-flutter-parity-baseline/)
   - [Desktop Flutter Development Runbook](/technical-guide/developer/desktop-flutter-development-runbook/)
   - [Desktop Flutter Auth Backend Contract Integration Plan](/technical-guide/developer/desktop-flutter-auth-backend-contract-integration-plan/)
   - [Desktop Flutter Release Validation & Evidence](/technical-guide/developer/desktop-flutter-release-validation/)

## 2) Phase tracking anchors

| Phase | Planning anchor | Execution anchor | Gap tracker |
|---|---|---|---|
| Phase A | roadmap & plan | phase-a execution log | capability matrix (incl. parity backlog) |
| Phase B | roadmap & plan | (to be created at phase start) | capability matrix |
| Phase C | roadmap & plan | phase-c execution log + desktop flutter development runbook | desktop flutter parity baseline + release validation |
| Phase D | roadmap & plan | (to be created at phase start) | capability matrix |
| Phase E | roadmap & plan | (to be created at phase start) | capability matrix |

## 3) Required update flow per implementation unit

1. Implement runtime/test changes.
2. Add a unit section in the active phase execution log:
   - planned objective,
   - implemented changes,
   - detailed review (issues/fixes),
   - post-fix validation criteria.
3. Update capability matrix row notes with new evidence and next action.
4. Update parity backlog section evidence/next step (within capability matrix).
5. Update contract docs if interface/diagnostic semantics changed.
6. Update ticket-seed baseline notes if acceptance scope changed.
7. Re-run verification chain and record command outcomes.
8. For Phase C desktop units, update desktop flutter parity baseline together.

## 4) Continuity guardrails

- No matrix/backlog status promotion without merged tests and execution-log evidence.
- No unit closure without explicit review result (issues found/fixed or none).
- No contract change without updating both contract doc and relevant probes.
- No phase transition without defining next phase execution-log anchor.
- No desktop parity task is complete unless its in-scope user-facing workflows are implemented in Flutter, or explicitly blocked with a dated decommission plan for temporary non-Flutter paths.

## 5) Recommended starting points by task type

- New implementation work: capability matrix backlog → ticket seed → execution log.
- Status/reporting work: execution log → capability matrix → backlog section.
- Incident/recovery work: contract doc → diagnostics probes → execution log.
- Desktop parity planning work: roadmap phase C/D sections → WS-D workstream → matrix/backlog impact rows.
- Desktop migration execution work: roadmap full-port mandate → desktop flutter development runbook → parity baseline → execution log evidence.
- Desktop auth backend integration work: desktop flutter development runbook → auth backend contract integration plan → parity baseline → execution log evidence.
- Desktop release-readiness work: release validation → execution log → CI/release workflow evidence.

## 6) Desktop continuity coupling matrix

| Triggered document update | Required companion updates | Purpose |
|---|---|---|
| Desktop Phase C unit implementation (`web-mcp-phase-c-execution-log`) | `desktop-flutter-development-runbook` next-unit queue, `desktop-flutter-parity-baseline` | Keep implementation evidence and parity state synchronized. |
| Desktop auth backend integration plan update | `desktop-flutter-development-runbook`, `desktop-flutter-parity-baseline`, `web-mcp-phase-c-execution-log` | Keep auth integration sequencing, acceptance gates, and implementation evidence synchronized. |
| Desktop release gate/protocol change (`desktop-flutter-release-validation`) | `web-mcp-phase-c-execution-log` | Ensure release evidence requirements and executed-unit traceability stay aligned. |
| Desktop roadmap/backlog priority shift | `desktop-flutter-development-runbook` candidates, `web-mcp-phase-c-execution-log` remaining gaps | Keep active execution queue aligned with planning priority changes. |
