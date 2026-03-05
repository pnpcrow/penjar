---
title: Desktop Flutter Development Runbook
desc: Continuity runbook for executing and reviewing Phase C Flutter desktop units without handoff gaps.
---

# Desktop Flutter Development Runbook

This runbook defines the repeatable execution loop for the Flutter desktop full-port program.

## Related artifacts

- [Web + MCP + Desktop Documentation Map](/technical-guide/developer/web-mcp-documentation-map/)
- [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/)
- [Desktop Flutter Parity Checklist](/technical-guide/developer/desktop-flutter-parity-checklist/)
- [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/)
- [Desktop Flutter Parity Acceptance Baseline](/technical-guide/developer/desktop-flutter-parity-acceptance-baseline/)
- [Desktop Flutter Release Validation Baseline](/technical-guide/developer/desktop-flutter-release-validation-baseline/)
- [Desktop Flutter Release Evidence Index](/technical-guide/developer/desktop-flutter-release-evidence-index/)
- [Web + MCP + Desktop Detailed Implementation Plan](/technical-guide/developer/web-mcp-desktop-implementation-plan/)

## 1) Session start protocol

1. Confirm current branch/worktree state and identify latest Phase C commit context.
2. Read the tail of the [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/) to resume from the most recent WS-D unit.
3. Identify one explicit implementation unit (scope, files, validation target, expected docs updates).
4. Verify canonical commands are available:
   - `pnpm run desktop:verify`
   - `pnpm run desktop:verify:fast`
   - `pnpm run desktop:verify:full`
   - `pnpm run desktop:verify:full:fast`
   - `pnpm run desktop:test:parity`
   - `pnpm run desktop:test:mode-matrix`
   - `pnpm run desktop:release:evidence:check`

## 2) Unit execution loop

For each WS-D unit, execute in this order:

1. Implement code/workflow changes.
2. Run focused tests for touched scope.
3. Run canonical full verification (`pnpm run desktop:verify:full`).
4. Perform explicit review:
   - identify failures/regressions,
   - apply fixes,
   - re-run full verification.
5. Update continuity documents in the same unit:
   - Phase C execution log (required),
   - parity checklist,
   - migration inventory,
   - acceptance baseline.
6. Commit unit with message aligned to objective/scope.

## 3) Required Phase C log schema per unit

Every unit entry must contain:

1. `Planned objective`.
2. `Implemented changes` with concrete file-level evidence.
3. `Unit review (detailed)`:
   - review scope,
   - issues found,
   - fixes applied,
   - post-fix validation criteria.
4. Explicit verification command evidence (`desktop:verify:full` expected).

## 4) Verification policy

- Fast loop (`desktop:verify` / `desktop:verify:fast`) is allowed while iterating.
- Closure gate requires `desktop:verify:full` green status.
- Mode routing changes must validate matrix behavior via verification chain (`run_mode_matrix_tests.sh`).
- Workflow-level UI changes must remain covered in parity suite (`run_parity_tests.sh`).

## 5) CI alignment policy

- CI must keep using canonical script entrypoint: `desktop/scripts/verify_desktop.sh`.
- CI matrix should include Linux parity and macOS parity+build at minimum.
- Any local verification command-chain change requires same-unit CI/doc synchronization.

## 6) Handoff checklist

Before pausing or transferring work:

1. Ensure working tree is clean or clearly explain pending deltas.
2. Record completed unit IDs and validation outcomes in execution log.
3. Update remaining-gap bullets with precise current state.
4. Document immediate next unit candidate with rationale.

## 7) Current next-unit candidates

1. Backend transport wiring for runtime-switchable contract adapters.
2. Windows/macOS build artifact and signing pipeline validation policy.
3. Release evidence index CI artifact upload automation.
