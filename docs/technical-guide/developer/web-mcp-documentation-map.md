---
title: Web + MCP + Desktop Documentation Map
desc: Relationship map and update protocol for roadmap, plan, backlog, matrix, contracts, and execution logs.
---

# Web + MCP + Desktop Documentation Map

This document is the canonical navigation map to keep development continuity without gaps.

## 1) Document relationship graph

1. Strategy and phase intent:
   - [Web + MCP + Desktop Delivery Roadmap](/technical-guide/developer/web-mcp-desktop-roadmap/)
2. Execution sequencing and workstreams:
   - [Web + MCP + Desktop Detailed Implementation Plan](/technical-guide/developer/web-mcp-desktop-implementation-plan/)
3. Current capability status by workflow:
   - [Web ↔ MCP Capability Matrix](/technical-guide/developer/web-mcp-capability-matrix/)
4. Prioritized gap queue:
   - [Web ↔ MCP Parity Backlog](/technical-guide/developer/web-mcp-parity-backlog/)
5. Ticket-level implementation seeds:
   - [Web + MCP Phase A Ticket Seed](/technical-guide/developer/web-mcp-phase-a-ticket-seed/)
6. Unit-by-unit execution evidence:
   - [Web + MCP Phase A Execution Log](/technical-guide/developer/web-mcp-phase-a-execution-log/)
7. Contract-level invariants:
   - [Web ↔ MCP Auth/Session Recovery Contract](/technical-guide/developer/web-mcp-auth-session-recovery-contract/)
8. Desktop full-port execution artifacts:
   - [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/)
   - [Desktop Flutter Parity Checklist](/technical-guide/developer/desktop-flutter-parity-checklist/)
   - [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/)
   - [Desktop Flutter Parity Acceptance Baseline](/technical-guide/developer/desktop-flutter-parity-acceptance-baseline/)
   - [Desktop Flutter Development Runbook](/technical-guide/developer/desktop-flutter-development-runbook/)
   - [Desktop Flutter Auth Backend Contract Integration Plan](/technical-guide/developer/desktop-flutter-auth-backend-contract-integration-plan/)
   - [Desktop Flutter Release Validation Baseline](/technical-guide/developer/desktop-flutter-release-validation-baseline/)
   - [Desktop Flutter Release Evidence Index](/technical-guide/developer/desktop-flutter-release-evidence-index/)

## 2) Phase tracking anchors

| Phase | Planning anchor | Execution anchor | Gap tracker |
|---|---|---|---|
| Phase A | roadmap + implementation plan | phase-a execution log | capability matrix + parity backlog |
| Phase B | roadmap + implementation plan | (to be created at phase start) | capability matrix + parity backlog |
| Phase C | roadmap + implementation plan | web-mcp-phase-c-execution-log + desktop flutter development runbook | desktop parity checklist + migration inventory + acceptance baseline + release validation baseline + release evidence index |
| Phase D | roadmap + implementation plan | (to be created at phase start) | capability matrix + parity backlog |
| Phase E | roadmap + implementation plan | (to be created at phase start) | capability matrix + parity backlog |

## 3) Required update flow per implementation unit

1. Implement runtime/test changes.
2. Add a unit section in the active phase execution log:
   - planned objective,
   - implemented changes,
   - detailed review (issues/fixes),
   - post-fix validation criteria.
3. Update capability matrix row notes with new evidence and next action.
4. Update parity backlog row evidence/next step.
5. Update contract docs if interface/diagnostic semantics changed.
6. Update ticket-seed baseline notes if acceptance scope changed.
7. Re-run verification chain and record command outcomes.
8. For Phase C desktop units, update parity checklist + migration inventory + acceptance baseline together.

## 4) Continuity guardrails

- No matrix/backlog status promotion without merged tests and execution-log evidence.
- No unit closure without explicit review result (issues found/fixed or none).
- No contract change without updating both contract doc and relevant probes.
- No phase transition without defining next phase execution-log anchor.
- No desktop parity task is complete unless its in-scope user-facing workflows are implemented in Flutter, or explicitly blocked with a dated decommission plan for temporary non-Flutter paths.

## 5) Recommended starting points by task type

- New implementation work: backlog -> ticket seed -> execution log.
- Status/reporting work: execution log -> matrix -> backlog.
- Incident/recovery work: contract doc -> diagnostics probes -> execution log.
- Desktop parity planning work: roadmap phase C/D sections -> implementation plan WS-D -> matrix/backlog impact rows.
- Desktop migration execution work: roadmap full-port mandate -> desktop flutter development runbook -> WS-D migration inventory/decommission plan -> acceptance baseline -> execution log evidence.
- Desktop auth backend integration work: desktop flutter development runbook -> desktop flutter auth backend contract integration plan -> parity checklist/inventory/acceptance baseline -> execution log evidence.
- Desktop release-readiness work: release validation baseline -> execution log -> CI/release workflow evidence.
- Desktop release audit/reporting work: release evidence index -> execution log references -> release decision traceability.

## 6) Desktop continuity coupling matrix

| Triggered document update | Required companion updates | Purpose |
|---|---|---|
| Desktop Phase C unit implementation (`web-mcp-phase-c-execution-log`) | `desktop-flutter-development-runbook` next-unit queue, `desktop-flutter-parity-checklist`, `desktop-flutter-migration-inventory`, `desktop-flutter-parity-acceptance-baseline` | Keep implementation evidence, parity state, and migration exceptions synchronized. |
| Desktop auth backend integration plan update (`desktop-flutter-auth-backend-contract-integration-plan`) | `desktop-flutter-development-runbook`, `desktop-flutter-parity-checklist`, `desktop-flutter-migration-inventory`, `desktop-flutter-parity-acceptance-baseline`, `web-mcp-phase-c-execution-log` | Keep auth integration sequencing, acceptance gates, and implementation evidence synchronized. |
| Desktop release gate/protocol change (`desktop-flutter-release-validation-baseline`) | `desktop-flutter-release-evidence-index`, `web-mcp-phase-c-execution-log` | Ensure release evidence requirements and executed-unit traceability stay aligned. |
| Release evidence schema/report requirement change (`desktop-flutter-release-evidence-index`) | `desktop-flutter-release-validation-baseline`, `web-mcp-phase-c-execution-log` | Prevent release audits from diverging from current validation protocol. |
| Desktop roadmap/backlog priority shift (`web-mcp-parity-backlog`, roadmap/plan docs) | `desktop-flutter-development-runbook` candidates, `web-mcp-phase-c-execution-log` remaining gaps | Keep active execution queue aligned with planning priority changes. |
