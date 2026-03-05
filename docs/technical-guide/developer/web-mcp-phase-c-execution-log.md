---
title: Web + Desktop Phase C Execution Log
desc: Detailed implementation record and unit-by-unit review log for Phase C Flutter desktop full-port work.
---

# Web + Desktop Phase C Execution Log

This log records execution work for Phase C tasks from the
[Detailed Implementation Plan](/technical-guide/developer/web-mcp-desktop-implementation-plan/).

## Linked planning and tracking artifacts

- Navigation and update protocol:
  - [Web + MCP + Desktop Documentation Map](/technical-guide/developer/web-mcp-documentation-map/)
- Upstream planning:
  - [Web + MCP + Desktop Delivery Roadmap](/technical-guide/developer/web-mcp-desktop-roadmap/)
  - [Web + MCP + Desktop Detailed Implementation Plan](/technical-guide/developer/web-mcp-desktop-implementation-plan/)
- Desktop full-port execution artifacts:
  - [Desktop Flutter Parity Checklist](/technical-guide/developer/desktop-flutter-parity-checklist/)
  - [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/)
  - [Desktop Flutter Parity Acceptance Baseline](/technical-guide/developer/desktop-flutter-parity-acceptance-baseline/)

## Execution baseline

- Active plan scope: **WS-D (Desktop delivery readiness)** in Phase C.
- Work date: **2026-03-05**.
- Delivery rule applied: Flutter full-port mandate (temporary non-Flutter paths require blocker, owner, and removal deadline).

## Unit WS-D-01: Phase C logging bootstrap

### Planned objective

Create a dedicated Phase C execution log anchor to prevent desktop full-port work from being mixed with Phase A MCP parity logs.

### Implemented changes

1. Added this document (`web-mcp-phase-c-execution-log.md`) as the primary execution ledger for Phase C desktop work.
2. Linked this log to roadmap/plan/documentation-map and desktop parity/inventory artifacts.

### Unit review (detailed)

- **Review scope**
  - Document discoverability from existing roadmap/plan/map chain.
  - Phase ownership clarity (Phase A vs Phase C).
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Phase C work units are recorded here instead of Phase A log.

## Unit WS-D-02: Desktop parity checklist + migration inventory bootstrap

### Planned objective

Create concrete Phase C execution artifacts required by the Flutter full-port mandate so desktop work can be tracked at workflow and component levels.

### Implemented changes

1. Added workflow-level checklist:
   - [Desktop Flutter Parity Checklist](/technical-guide/developer/desktop-flutter-parity-checklist/)
   - includes domain rows, status legend, owner/evidence fields, and per-row completion criteria.
2. Added component-level migration inventory:
   - [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/)
   - includes blocker/owner/removal-date policy for temporary non-Flutter paths.
3. Linked artifacts into continuity chain:
   - `web-mcp-documentation-map.md` Phase C anchor updated to this execution log plus checklist/inventory trackers.
   - roadmap, detailed implementation plan, and developer index now include direct links to new Phase C artifacts.

### Unit review (detailed)

- **Review scope**
  - discoverability from roadmap/plan/index,
  - readiness for owner assignment and evidence attachment,
  - compliance with full-port guardrails (blocker/owner/removal date requirements).
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - New Phase C artifacts are reachable from documentation map, roadmap, implementation plan, and developer index.
  - Checklist/inventory are ready for immediate owner/status population in next Phase C execution unit.

## Unit WS-D-03: Flutter workspace baseline scan

### Planned objective

Record an objective repository baseline for Flutter full-port readiness so Phase C bootstrap scope starts from explicit evidence.

### Implemented changes

1. Performed repository scan for Flutter artifacts:
   - searched for `*.dart`, `pubspec.yaml`, `pubspec.lock`.
2. Result:
   - no Flutter module artifacts detected in current repository state.
3. Updated migration inventory with concrete baseline row:
   - `Flutter workspace bootstrap` row added with status `Blocked` and blocker `Bootstrap task not started`.

### Unit review (detailed)

- **Review scope**
  - scan coverage for standard Flutter entry artifacts,
  - inventory consistency with observed repository state.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Migration inventory includes an evidence-backed bootstrap row for Flutter workspace creation.

## Unit WS-D-04: Desktop surface codebase mapping and ownership baseline

### Planned objective

Remove placeholder risk from Phase C artifacts by mapping each workflow to concrete current code paths and adding explicit blocker/owner/removal-date fields required by the full-port guardrail.

### Implemented changes

1. Performed desktop-scope codebase mapping for workflow surfaces:
   - routed entrypoints (`frontend/src/app/main/ui.cljs`, `frontend/src/app/main/ui/routes.cljs`),
   - auth/session (`frontend/src/app/main/ui/auth.cljs`, `frontend/src/app/main/data/auth.cljs`),
   - dashboard/file/workspace/inspect/export/collaboration/diagnostics representative paths.
2. Expanded [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/) rows from placeholder state to concrete component/path entries:
   - added blocker, owner, removal date, status, and evidence columns for each workflow area.
   - aligned inventory coverage with checklist workflow domains (asset/collaboration/inspect included).
3. Updated [Desktop Flutter Parity Checklist](/technical-guide/developer/desktop-flutter-parity-checklist/) to enforce continuity:
   - all workflow rows now include explicit owner and evidence link.
   - status set to `Blocked` with blocker rationale in notes while Flutter workspace bootstrap remains incomplete.

### Unit review (detailed)

- **Review scope**
  - inventory-rule compliance (`blocker`, `owner`, `removal date` required),
  - workflow-to-codebase traceability (no placeholder-only domain rows),
  - checklist/inventory linkage consistency.
- **Issues found during review**
  1. Migration inventory had placeholder rows (`TBD`) that violated its own acceptance rule for temporary non-Flutter paths.
  2. Workflow checklist rows lacked direct ownership/evidence mapping, creating a reporting gap between status and migration plan.
- **Fix applied**
  1. Replaced placeholder inventory rows with concrete web implementation paths and explicit owner/removal-date baseline targets.
  2. Linked each checklist workflow row to migration inventory and added blocker notes tied to the Flutter bootstrap dependency.
- **Post-fix validation criteria**
  - Phase C parity checklist and migration inventory no longer depend on placeholder-only (`TBD`) fields for workflow rows.
  - Every workflow area now has a traceable path from checklist -> migration inventory -> execution log.

## Unit WS-D-05: Flutter parity acceptance baseline definition and link propagation

### Planned objective

Close the acceptance-definition gap by introducing an executable Flutter parity gate baseline and connecting it across the Phase C documentation chain.

### Implemented changes

1. Added [Desktop Flutter Parity Acceptance Baseline](/technical-guide/developer/desktop-flutter-parity-acceptance-baseline/):
   - workflow-level gate table aligned with parity checklist domains,
   - initial per-workflow Flutter test target paths (`desktop/test/parity/*`),
   - gate status legend and execution protocol.
2. Connected baseline document to Phase C artifacts:
   - added links in documentation map, implementation plan, roadmap tracking section, developer index, parity checklist, and migration inventory.
3. Updated Phase C traceability narrative:
   - acceptance gates are now explicit requirements for moving workflow rows to `Done`,
   - checklist/inventory now form a full chain with acceptance baseline and execution log evidence.

### Unit review (detailed)

- **Review scope**
  - workflow coverage parity between checklist and acceptance baseline,
  - document-chain completeness (map/plan/roadmap/index/checklist/inventory),
  - gate readiness semantics for blocked vs planned workflows.
- **Issues found during review**
  1. Acceptance requirements existed only as prose in checklist completion criteria, not as an executable gate inventory.
  2. Phase C navigation chain did not have a dedicated acceptance-gate anchor, causing possible drift between migration status and test readiness.
- **Fix applied**
  1. Created an explicit acceptance baseline table with per-workflow gate target and owner mapping.
  2. Added cross-links across all primary planning/navigation docs to ensure single-path discoverability.
- **Post-fix validation criteria**
  - Every parity checklist workflow row has a corresponding acceptance gate baseline row.
  - Phase C desktop documentation chain includes acceptance baseline as a first-class artifact.

## Unit WS-D-06: Flutter desktop workspace bootstrap execution

### Planned objective

Move Phase C from documentation-only readiness into executable desktop implementation readiness by creating and validating a real Flutter desktop workspace baseline.

### Implemented changes

1. Created Flutter desktop module at repository root:
   - command: `flutter create --platforms=macos,windows --project-name penjar_desktop --org app.penjar desktop`
   - generated `desktop/lib`, `desktop/test`, `desktop/macos`, `desktop/windows`.
2. Corrected template metadata to Penjar baseline naming:
   - updated Flutter project description and desktop README wording,
   - updated macOS product display name to `Penjar Desktop`,
   - updated Windows window title and product metadata display name to `Penjar Desktop`.
3. Added root-level execution scripts for desktop baseline checks:
   - `pnpm run desktop:test`
   - `pnpm run desktop:analyze`
   - `pnpm run desktop:build:macos:debug`
4. Executed baseline validation chain:
   - `flutter test` passed,
   - `flutter analyze` passed with no issues,
   - `flutter build macos --debug` passed and produced `Penjar Desktop.app`.

### Unit review (detailed)

- **Review scope**
  - module creation completeness for target platforms (macOS/Windows),
  - branding consistency against Penjar naming,
  - repeatable verification entrypoints from repository root.
- **Issues found during review**
  1. Generated template metadata remained generic (`A new Flutter project`, lowercase app display names), which was inconsistent with Penjar desktop branding baseline.
  2. Desktop validation commands were not wired to root scripts, reducing repeatability in multi-workspace workflows.
- **Fix applied**
  1. Updated project description/README plus macOS and Windows display metadata to `Penjar Desktop`.
  2. Added root `package.json` scripts for desktop test/analyze/build execution.
- **Post-fix validation criteria**
  - `desktop/` workspace exists with macOS and Windows targets.
  - Root scripts execute and pass for test/analyze/macos-debug-build.
  - Migration inventory bootstrap row can move to `Done` and workflow rows to `Not started` (no longer blocked by module absence).

## Unit WS-D-07: Desktop shell runtime baseline implementation

### Planned objective

Replace template counter UI with a meaningful Penjar desktop shell baseline so Phase C can move from workspace setup to active runtime migration.

### Implemented changes

1. Replaced `desktop/lib/main.dart` default counter app with `PenjarDesktopApp` shell:
   - app title/branding set to `Penjar Desktop`,
   - left-side `NavigationRail` for workflow groups,
   - content panel with status and owner context per section.
2. Updated widget tests to validate shell behavior:
   - verifies app title and default shell section,
   - verifies section switch interaction through navigation keys.
3. Re-ran desktop validation chain after shell changes:
   - `pnpm run desktop:test`,
   - `pnpm run desktop:analyze`,
   - `pnpm run desktop:build:macos:debug`.
4. Updated migration inventory:
   - `Desktop shell/runtime` row promoted from `Not started` to `In progress`.

### Unit review (detailed)

- **Review scope**
  - correctness of new shell runtime structure,
  - regression impact on tests/analyzer/build,
  - traceability update in migration inventory status.
- **Issues found during review**
  1. Initial test update missed `ValueKey` import in `widget_test.dart`, causing test/analyzer failure.
- **Fix applied**
  1. Added `package:flutter/widgets.dart` import and reran all desktop validation commands.
- **Post-fix validation criteria**
  - Desktop shell runtime loads and section switching is verified by test.
  - Analyzer reports zero issues.
  - macOS debug build succeeds with `Penjar Desktop.app` output.

## Unit WS-D-08: Auth/session Flutter surface scaffold and parity harness

### Planned objective

Start real workflow migration for Phase C by implementing an executable Flutter auth/session surface and wiring a dedicated parity harness aligned with the acceptance baseline.

### Implemented changes

1. Expanded `desktop/lib/main.dart` auth section from static description to interactive scaffold:
   - email/password input fields,
   - remember-session toggle,
   - action buttons for sign-in, session restore, token refresh,
   - status output area with deterministic states for test assertions.
2. Added dedicated auth parity test harness:
   - `desktop/test/parity/auth_session_parity_test.dart`,
   - validates auth workflow interactions and expected status transitions.
3. Added root script for parity-only test execution:
   - `pnpm run desktop:test:parity`.
4. Re-ran desktop verification chain:
   - `pnpm run desktop:test`,
   - `pnpm run desktop:test:parity`,
   - `pnpm run desktop:analyze`,
   - `pnpm run desktop:build:macos:debug`.
5. Updated Phase C trackers:
   - migration inventory `Auth/session UI` row moved to `In progress`,
   - parity checklist `Authentication/session` row moved to `In progress`,
   - acceptance baseline `Authentication/session` gate moved to `In progress`.

### Unit review (detailed)

- **Review scope**
  - correctness and testability of auth/session scaffold interactions,
  - parity harness reliability in constrained test viewport,
  - tracker consistency across checklist/inventory/acceptance baseline.
- **Issues found during review**
  1. Initial auth scaffold layout overflowed in default widget-test viewport, making action buttons partially off-screen and causing tap misses.
  2. Parity test assumed visibility for all controls without accounting for scrollable interaction on smaller viewport constraints.
- **Fix applied**
  1. Wrapped details panel in `SingleChildScrollView` with bounded minimum height via `LayoutBuilder` + `ConstrainedBox`.
  2. Added `ensureVisible` steps in parity test before tapping controls to guarantee hit-test reliability.
- **Post-fix validation criteria**
  - Auth parity test passes consistently under default test viewport.
  - Full desktop test/analyze/build chain remains green after auth scaffold introduction.
  - Tracker documents consistently represent auth/session as `In progress`.

## Unit WS-D-09: Project/file lifecycle Flutter surface scaffold and parity harness

### Planned objective

Continue Phase C workflow migration by implementing executable project/file lifecycle interaction scaffolds and parity harnesses that align with the acceptance baseline.

### Implemented changes

1. Extended `desktop/lib/main.dart` with `ProjectLifecyclePanel`:
   - project creation and project selection interactions,
   - file creation and delete-first-file interactions,
   - deterministic status output for parity assertions.
2. Updated project section shell metadata:
   - `Project & File Lifecycle` section status moved to `In progress` in the Flutter shell.
3. Added parity harness files:
   - `desktop/test/parity/project_lifecycle_parity_test.dart`,
   - `desktop/test/parity/file_lifecycle_parity_test.dart`.
4. Hardened parity command determinism:
   - updated `pnpm run desktop:test:parity` to target explicit parity test files.
5. Re-ran desktop verification chain:
   - `pnpm run desktop:test`,
   - `pnpm run desktop:test:parity`,
   - `pnpm run desktop:analyze`,
   - `pnpm run desktop:build:macos:debug`.
6. Updated Phase C trackers:
   - migration inventory rows `Project lifecycle` and `File lifecycle` moved to `In progress`,
   - parity checklist rows `Project lifecycle` and `File lifecycle` moved to `In progress`,
   - acceptance baseline gates for project/file moved to `In progress`.

### Unit review (detailed)

- **Review scope**
  - project/file scaffold behavior correctness,
  - parity harness coverage for create/select/create/delete flows,
  - repeatability of parity command execution.
- **Issues found during review**
  1. Combined parity runner output was ambiguous about per-file execution order, reducing confidence in CI/debug readability.
- **Fix applied**
  1. Replaced directory-level parity command with explicit test-file invocation list for deterministic coverage visibility.
- **Post-fix validation criteria**
  - Dedicated project and file parity tests pass when run individually and through parity aggregate script.
  - Full desktop chain remains green after project/file scaffold introduction.
  - Trackers consistently represent project/file rows as `In progress`.

## Unit WS-D-10: Canvas editing Flutter surface scaffold and parity harness

### Planned objective

Start canvas-specific Phase C migration by adding executable shape-edit interaction scaffolds and a dedicated canvas parity harness.

### Implemented changes

1. Extended `desktop/lib/main.dart` with `CanvasEditingPanel`:
   - rectangle creation,
   - move and resize interactions,
   - fill color toggle,
   - selected-shape metrics and status output for deterministic assertions.
2. Updated shell section metadata:
   - `Canvas, Assets, Collaboration` section status moved to `In progress`.
3. Added canvas parity harness:
   - `desktop/test/parity/canvas_editing_parity_test.dart`.
4. Updated parity runner script:
   - included canvas parity harness in `pnpm run desktop:test:parity` explicit test list.
5. Re-ran desktop verification chain:
   - `pnpm run desktop:test`,
   - `pnpm run desktop:test:parity`,
   - `pnpm run desktop:analyze`,
   - `pnpm run desktop:build:macos:debug`.
6. Updated Phase C trackers:
   - migration inventory row `Canvas interaction` moved to `In progress`,
   - parity checklist row `Canvas editing` moved to `In progress`,
   - acceptance baseline gate `Canvas editing` moved to `In progress`.

### Unit review (detailed)

- **Review scope**
  - canvas scaffold behavior correctness under create/move/resize/fill actions,
  - parity test coverage for state transitions and metrics updates,
  - compatibility with existing desktop test/analyze/build chain.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Canvas parity test passes and asserts geometry/style transitions.
  - Desktop chain remains green with canvas scaffold merged.
  - Tracker docs consistently represent canvas migration as `In progress`.

## Unit WS-D-11: Asset management Flutter surface scaffold and parity harness

### Planned objective

Advance Phase C by implementing executable asset-management interactions in Flutter desktop and attaching a dedicated parity harness aligned with the acceptance baseline.

### Implemented changes

1. Refined workflow sectioning in `desktop/lib/main.dart`:
   - split previous combined `Canvas, Assets, Collaboration` section into:
     - `Canvas Editing` (`canvas`),
     - `Asset Management` (`assets`).
2. Added `AssetManagementPanel` scaffold:
   - asset import (name + type),
   - asset selection,
   - asset usage counter updates,
   - asset removal,
   - deterministic status/metrics output for tests.
3. Added dedicated parity harness:
   - `desktop/test/parity/asset_management_parity_test.dart`.
4. Updated parity runner command:
   - appended asset parity harness to explicit list in `pnpm run desktop:test:parity`.
5. Re-ran desktop verification chain:
   - `pnpm run desktop:test`,
   - `pnpm run desktop:test:parity`,
   - `pnpm run desktop:analyze`,
   - `pnpm run desktop:build:macos:debug`.
6. Updated Phase C trackers:
   - migration inventory row `Asset management` moved to `In progress`,
   - parity checklist row `Asset management` moved to `In progress`,
   - acceptance baseline gate `Asset management` moved to `In progress`.

### Unit review (detailed)

- **Review scope**
  - asset scaffold behavior correctness for import/select/use/remove lifecycle,
  - parity harness determinism for status and metrics assertions,
  - regression impact on desktop analysis/build chain.
- **Issues found during review**
  1. `flutter analyze` reported deprecation on `DropdownButtonFormField.value` in Flutter 3.41.
- **Fix applied**
  1. Replaced deprecated `value` usage with `initialValue` in asset type selector and re-ran validation chain.
- **Post-fix validation criteria**
  - Asset parity test passes and validates key interaction transitions.
  - Analyzer reports zero issues after deprecation fix.
  - Tracker docs consistently represent asset management as `In progress`.

## Unit WS-D-12: Collaboration context Flutter surface scaffold and parity harness

### Planned objective

Start collaboration-specific Phase C migration by adding executable presence/thread interaction scaffolds and a dedicated collaboration parity harness.

### Implemented changes

1. Extended workflow sectioning in `desktop/lib/main.dart`:
   - added `Collaboration Context` section (`collaboration`) with status `In progress`.
2. Added `CollaborationContextPanel` scaffold:
   - peer presence connect/disconnect toggle,
   - thread creation with validation,
   - thread selection and resolution lifecycle,
   - deterministic summary/status outputs for parity assertions.
3. Added dedicated collaboration parity harness:
   - `desktop/test/parity/collaboration_context_parity_test.dart`.
4. Updated parity runner command:
   - appended collaboration parity harness to explicit list in `pnpm run desktop:test:parity`.
5. Re-ran desktop verification chain:
   - `pnpm run desktop:test`,
   - `pnpm run desktop:test:parity`,
   - `pnpm run desktop:analyze`,
   - `pnpm run desktop:build:macos:debug`.
6. Updated Phase C trackers:
   - migration inventory row `Collaboration context` moved to `In progress`,
   - parity checklist row `Collaboration context` moved to `In progress`,
   - acceptance baseline gate `Collaboration context` moved to `In progress`.

### Unit review (detailed)

- **Review scope**
  - collaboration scaffold correctness for presence and thread lifecycles,
  - parity harness stability for state transition assertions,
  - regression impact on desktop chain and tracker consistency.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Collaboration parity test passes and validates presence/thread transitions.
  - Desktop chain remains green after collaboration scaffold merge.
  - Tracker docs consistently represent collaboration as `In progress`.

## Unit WS-D-13: Inspect/code handoff Flutter surface scaffold and parity harness

### Planned objective

Start inspect-specific Phase C migration by adding executable metadata/snippet handoff interactions and a dedicated inspect parity harness.

### Implemented changes

1. Extended `desktop/lib/main.dart` workflow sectioning:
   - added `Inspect & Code Handoff` section (`inspect`) with status `In progress`.
2. Added `InspectHandoffPanel` scaffold:
   - inspect element-id input and code-target selector,
   - snippet generation and metadata copy actions,
   - deterministic metadata/snippet/status outputs for parity assertions.
3. Added dedicated inspect parity harness:
   - `desktop/test/parity/inspect_handoff_parity_test.dart`.
4. Updated parity runner command:
   - appended inspect parity harness to explicit list in `pnpm run desktop:test:parity`.
5. Fixed cross-suite regression found during unit review:
   - set `NavigationRail.scrollable` to prevent vertical overflow at default widget-test viewport after navigation rows increased.
6. Re-ran desktop verification chain:
   - `pnpm run desktop:test`,
   - `pnpm run desktop:test:parity`,
   - `pnpm run desktop:analyze`,
   - `pnpm run desktop:build:macos:debug`.
7. Updated Phase C trackers:
   - migration inventory row `Inspect/code handoff` moved to `In progress`,
   - parity checklist row `Inspect/code handoff` moved to `In progress`,
   - acceptance baseline gate `Inspect/code handoff` moved to `In progress`.

### Unit review (detailed)

- **Review scope**
  - inspect scaffold correctness for metadata/snippet handoff actions,
  - parity harness determinism for failure/success transitions,
  - global shell stability after navigation expansion.
- **Issues found during review**
  1. `NavigationRail` overflowed by 40 pixels in 800x600 test viewport, causing broad suite instability.
- **Fix applied**
  1. Enabled `scrollable: true` on `NavigationRail` and reran full verification chain.
- **Post-fix validation criteria**
  - Inspect parity test passes with expected status/snippet transitions.
  - No navigation overflow errors remain in widget/parity suites.
  - Tracker docs consistently represent inspect migration as `In progress`.

## Unit WS-D-14: Export workflow Flutter surface scaffold and parity harness

### Planned objective

Start export-specific Phase C migration by implementing executable export option/output/save interactions and a dedicated export parity harness.

### Implemented changes

1. Extended `desktop/lib/main.dart` workflow sectioning:
   - moved `Export Workflows` section (`export`) from `Not started` to `In progress`.
2. Added `ExportWorkflowPanel` scaffold:
   - output file-name input and export format/scale selectors,
   - include-background toggle,
   - run export, save latest artifact, and clear artifacts actions,
   - deterministic artifact summary/status outputs for parity assertions.
3. Added dedicated export parity harness:
   - `desktop/test/parity/export_workflow_parity_test.dart`.
4. Updated parity runner command:
   - appended export parity harness to explicit list in `pnpm run desktop:test:parity`.
5. Re-ran desktop verification chain:
   - `pnpm run desktop:test`,
   - `pnpm run desktop:test:parity`,
   - `pnpm run desktop:analyze`,
   - `pnpm run desktop:build:macos:debug`.
6. Updated Phase C trackers:
   - migration inventory row `Export UX` moved to `In progress`,
   - parity checklist row `Export workflows` moved to `In progress`,
   - acceptance baseline gate `Export workflows` moved to `In progress`.

### Unit review (detailed)

- **Review scope**
  - export scaffold correctness across validate/export/save/clear interactions,
  - parity harness reliability for artifact/state assertions,
  - regression impact on existing desktop validation chain.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Export parity test passes and validates artifact lifecycle transitions.
  - Desktop chain remains green with export scaffold merged.
  - Tracker docs consistently represent export migration as `In progress`.

## Unit WS-D-15: Diagnostics/recovery Flutter surface scaffold and parity harness

### Planned objective

Start diagnostics-specific Phase C migration by implementing executable runtime-health/reconnect/remediation interactions and a dedicated diagnostics parity harness.

### Implemented changes

1. Extended `desktop/lib/main.dart` workflow sectioning:
   - moved `Diagnostics & Recovery` section (`diagnostics`) from `Not started` to `In progress`.
2. Added `DiagnosticsRecoveryPanel` scaffold:
   - health-check action,
   - simulated disconnect and reconnect attempt flow,
   - recovery-guide action,
   - deterministic connectivity summary/status outputs for parity assertions.
3. Added dedicated diagnostics parity harness:
   - `desktop/test/parity/diagnostics_recovery_parity_test.dart`.
4. Updated parity runner command:
   - appended diagnostics parity harness to explicit list in `pnpm run desktop:test:parity`.
5. Re-ran desktop verification chain:
   - `pnpm run desktop:test`,
   - `pnpm run desktop:test:parity`,
   - `pnpm run desktop:analyze`,
   - `pnpm run desktop:build:macos:debug`.
6. Updated Phase C trackers:
   - migration inventory row `Diagnostics/recovery UX` moved to `In progress`,
   - parity checklist row `Diagnostics/recovery` moved to `In progress`,
   - acceptance baseline gate `Diagnostics/recovery` moved to `In progress`.

### Unit review (detailed)

- **Review scope**
  - diagnostics scaffold correctness for healthy/degraded/recovered state transitions,
  - parity harness stability for connectivity and remediation assertions,
  - regression impact on full desktop validation chain.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Diagnostics parity test passes and validates reconnect/remediation flow.
  - Desktop chain remains green after diagnostics scaffold merge.
  - Tracker docs consistently represent diagnostics migration as `In progress`.

## Unit WS-D-16: Desktop Flutter parity CI workflow baseline

### Planned objective

Close the CI execution gap for desktop parity gates by adding an automated workflow that runs Flutter test/parity/analyze commands whenever desktop scope changes.

### Implemented changes

1. Added dedicated GitHub Actions workflow:
   - `.github/workflows/tests-desktop-flutter.yml`.
2. Configured desktop-targeted trigger scope:
   - `pull_request` and `push` on `develop/staging/main`,
   - path filters for `desktop/**`, root `package.json`, and the workflow file itself.
3. Added parity CI job (`Desktop Flutter Parity`) on `ubuntu-latest`:
   - checkout,
   - Flutter setup via `subosito/flutter-action@v2`,
   - `flutter pub get`,
   - full desktop test suite,
   - explicit parity gate suite (`desktop/test/parity/*.dart` list),
   - `flutter analyze`.
4. Re-ran local command parity with CI command set:
   - `pnpm run desktop:test:parity`,
   - `pnpm run desktop:analyze`.

### Unit review (detailed)

- **Review scope**
  - workflow trigger correctness for desktop-related changes,
  - CI command parity with locally validated gate commands,
  - impact on existing multi-workflow CI structure.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Desktop Flutter parity/test/analyze commands are automatically scheduled in CI for desktop-scope changes.
  - Local gate commands remain green with same command set used by the new CI job.

## Unit WS-D-17: Export/diagnostics contract boundary extraction

### Planned objective

Start stabilizing desktop contract boundaries (WS-D objective) by extracting export and diagnostics interaction logic out of UI widgets into dedicated in-memory contract adapters with unit-test coverage.

### Implemented changes

1. Added contract module:
   - `desktop/lib/contracts/workflow_contracts.dart`.
2. Implemented export contract baseline:
   - `ExportWorkflowContract` interface,
   - `InMemoryExportWorkflowContract` adapter,
   - request/artifact/state models for deterministic export lifecycle handling.
3. Implemented diagnostics contract baseline:
   - `DiagnosticsRecoveryContract` interface,
   - `InMemoryDiagnosticsRecoveryContract` adapter,
   - state model for health/disconnect/reconnect/remediation transitions.
4. Refactored Flutter panels to use contract adapters:
   - `ExportWorkflowPanel` now delegates run/save/clear operations to export contract,
   - `DiagnosticsRecoveryPanel` now delegates health/reconnect/remediation operations to diagnostics contract.
5. Added contract unit tests:
   - `desktop/test/contracts/workflow_contracts_test.dart`.
6. Re-ran desktop verification chain:
   - `pnpm run desktop:test`,
   - `pnpm run desktop:test:parity`,
   - `pnpm run desktop:analyze`,
   - `pnpm run desktop:build:macos:debug`.
7. Updated migration/parity trackers:
   - export and diagnostics notes now explicitly reference in-memory contract boundary baseline.

### Unit review (detailed)

- **Review scope**
  - correctness of extracted contract state transitions independent from UI widgets,
  - regression impact of UI refactor on parity harnesses,
  - consistency of tracker notes with new contract-boundary baseline.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Contract unit tests pass for export and diagnostics state transitions.
  - Existing parity tests pass with UI delegating to contract adapters.
  - Desktop test/analyze/build chain remains green after extraction.

## Unit WS-D-18: Auth/session contract boundary extraction

### Planned objective

Continue WS-D contract-boundary hardening by extracting auth/session interaction rules out of UI widget state into an explicit in-memory contract with unit-test coverage.

### Implemented changes

1. Extended contract module:
   - `desktop/lib/contracts/workflow_contracts.dart`.
2. Implemented auth contract baseline:
   - `AuthSessionContract` interface,
   - `InMemoryAuthSessionContract` adapter,
   - request/state models for remember-session, sign-in, restore-session, and token-refresh transitions.
3. Refactored `AuthSessionPanel` to use contract adapter:
   - sign-in/restore/refresh/remember flows now delegate to auth contract,
   - UI now renders status and remember toggle state from contract snapshot.
4. Added auth contract unit tests:
   - expanded `desktop/test/contracts/workflow_contracts_test.dart` with auth validation and lifecycle coverage.
5. Re-ran desktop verification chain:
   - `pnpm run desktop:test`,
   - `pnpm run desktop:test:parity`,
   - `pnpm run desktop:analyze`,
   - `pnpm run desktop:build:macos:debug`.
6. Updated migration/parity trackers:
   - auth notes now explicitly reference in-memory contract boundary baseline.

### Unit review (detailed)

- **Review scope**
  - correctness of auth state transitions after contract extraction,
  - parity regression risk on existing auth widget interactions,
  - consistency between tracker notes and implementation state.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Auth parity test remains green with contract-driven state.
  - Auth contract unit tests pass for validation and lifecycle transitions.
  - Desktop test/analyze/build chain remains green after extraction.

## Unit WS-D-19: Project/file contract boundary extraction

### Planned objective

Extend WS-D contract-boundary hardening to project/file lifecycle flows by extracting project selection and file create/delete rules out of widget-local mutable state into an in-memory contract adapter.

### Implemented changes

1. Extended contract module:
   - `desktop/lib/contracts/workflow_contracts.dart`.
2. Implemented project/file contract baseline:
   - `ProjectLifecycleContract` interface,
   - `InMemoryProjectLifecycleContract` adapter,
   - project/state models covering project create/switch and file create/delete transitions.
3. Refactored `ProjectLifecyclePanel` to use contract adapter:
   - project/file actions now delegate to contract methods,
   - selected project summary/list/status are now rendered from contract state snapshot.
4. Added project/file contract unit tests:
   - expanded `desktop/test/contracts/workflow_contracts_test.dart` with lifecycle and invalid-index coverage.
5. Re-ran desktop verification chain:
   - `pnpm run desktop:test`,
   - `pnpm run desktop:test:parity`,
   - `pnpm run desktop:analyze`,
   - `pnpm run desktop:build:macos:debug`.
6. Updated migration/parity trackers:
   - project and file notes now explicitly reference in-memory contract boundary baseline.

### Unit review (detailed)

- **Review scope**
  - correctness of project/file state transitions after contract extraction,
  - parity regression risk for existing project/file widget interactions,
  - consistency between tracker notes and implementation state.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Project/file parity tests remain green with contract-driven state.
  - Project/file contract unit tests pass for lifecycle and guard paths.
  - Desktop test/analyze/build chain remains green after extraction.

## Unit WS-D-20: Parity runner consolidation and CI no-pub optimization

### Planned objective

Reduce parity-maintenance drift and improve validation runtime efficiency by centralizing parity test target definitions and removing redundant dependency resolution in CI steps.

### Implemented changes

1. Added canonical parity runner script:
   - `desktop/scripts/run_parity_tests.sh`.
2. Updated root parity command to use canonical script:
   - `package.json` `desktop:test:parity` now executes `cd desktop && ./scripts/run_parity_tests.sh`.
3. Updated desktop CI workflow to consume canonical parity runner:
   - `.github/workflows/tests-desktop-flutter.yml` parity step now runs `FLUTTER_NO_PUB=1 ./scripts/run_parity_tests.sh`.
4. Applied CI runtime optimization:
   - desktop test step now uses `flutter test --no-pub`,
   - desktop analyze step now uses `flutter analyze --no-pub`,
   - parity runner supports `FLUTTER_NO_PUB=1` mode.
5. Updated acceptance baseline CI anchor:
   - canonical parity test-file source now documented as `desktop/scripts/run_parity_tests.sh`.
6. Re-ran desktop verification chain:
   - `pnpm run desktop:test`,
   - `pnpm run desktop:test:parity`,
   - `pnpm run desktop:analyze`,
   - `pnpm run desktop:build:macos:debug`.

### Unit review (detailed)

- **Review scope**
  - consistency between local parity command and CI parity target set,
  - robustness of parity-runner shell implementation under strict shell options,
  - regression impact on desktop validation chain.
- **Issues found during review**
  1. Initial parity runner used `set -u` with empty array expansion, causing `unbound variable` failure when no optional args were enabled.
- **Fix applied**
  1. Switched script strict mode from `set -euo pipefail` to `set -eo pipefail` and re-ran full validation chain.
- **Post-fix validation criteria**
  - Root parity command and CI workflow both execute through one canonical parity script.
  - Parity/analyze/build validation chain remains green after runner consolidation.
  - CI no-pub optimization path is compatible with existing desktop commands.

## Unit WS-D-21: Canvas contract boundary extraction

### Planned objective

Continue WS-D contract-boundary extraction by moving canvas create/select/move/resize/fill rules from widget-local state into an explicit in-memory contract adapter with unit-test coverage.

### Implemented changes

1. Extended contract module:
   - `desktop/lib/contracts/workflow_contracts.dart`.
2. Implemented canvas contract baseline:
   - `CanvasEditingContract` interface,
   - `InMemoryCanvasEditingContract` adapter,
   - canvas shape/state models and guard paths for invalid selection.
3. Refactored `CanvasEditingPanel` to use contract adapter:
   - create/select/move/resize/fill actions now delegate to contract methods,
   - selected-shape metrics/status are now rendered from contract state snapshot.
4. Added canvas contract unit tests:
   - expanded `desktop/test/contracts/workflow_contracts_test.dart` with lifecycle and invalid-selection coverage.
5. Re-ran desktop verification chain:
   - `pnpm run desktop:test`,
   - `pnpm run desktop:test:parity`,
   - `pnpm run desktop:analyze`,
   - `pnpm run desktop:build:macos:debug`.
6. Updated migration/parity trackers:
   - canvas notes now explicitly reference in-memory contract boundary baseline.

### Unit review (detailed)

- **Review scope**
  - correctness of canvas state transitions after contract extraction,
  - parity regression risk for existing canvas widget interactions,
  - consistency between tracker notes and implementation state.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Canvas parity test remains green with contract-driven state.
  - Canvas contract unit tests pass for lifecycle and guard paths.
  - Desktop test/analyze/build chain remains green after extraction.

## Unit WS-D-22: Asset-management contract boundary extraction

### Planned objective

Continue WS-D contract-boundary extraction by moving asset import/select/use/remove rules from widget-local mutable state into an explicit in-memory contract adapter with unit-test coverage.

### Implemented changes

1. Extended contract module:
   - `desktop/lib/contracts/workflow_contracts.dart`.
2. Implemented asset contract baseline:
   - `AssetManagementContract` interface,
   - `InMemoryAssetManagementContract` adapter,
   - asset/state models and guard paths for duplicate imports and invalid selection.
3. Refactored `AssetManagementPanel` to use contract adapter:
   - import/select/use/remove actions now delegate to contract methods,
   - selected-asset metrics/status are now rendered from contract state snapshot.
4. Added asset contract unit tests:
   - expanded `desktop/test/contracts/workflow_contracts_test.dart` with lifecycle and invalid-selection coverage.
5. Re-ran desktop verification chain:
   - `pnpm run desktop:test`,
   - `pnpm run desktop:test:parity`,
   - `pnpm run desktop:analyze`,
   - `pnpm run desktop:build:macos:debug`.
6. Updated migration/parity trackers:
   - asset-management notes now explicitly reference in-memory contract boundary baseline.

### Unit review (detailed)

- **Review scope**
  - correctness of asset-management state transitions after contract extraction,
  - parity regression risk for existing asset widget interactions,
  - consistency between tracker notes and implementation state.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Asset parity test remains green with contract-driven state.
  - Asset contract unit tests pass for lifecycle and guard paths.
  - Desktop test/analyze/build chain remains green after extraction.

## Unit WS-D-23: Collaboration-context contract boundary extraction

### Planned objective

Continue WS-D contract-boundary extraction by moving collaboration presence/thread rules from widget-local mutable state into an explicit in-memory contract adapter with unit-test coverage.

### Implemented changes

1. Extended contract module:
   - `desktop/lib/contracts/workflow_contracts.dart`.
2. Implemented collaboration contract baseline:
   - `CollaborationContextContract` interface,
   - `InMemoryCollaborationContextContract` adapter,
   - thread/state models and guard path for invalid thread selection.
3. Refactored `CollaborationContextPanel` to use contract adapter:
   - peer presence toggle and thread create/select/resolve actions now delegate to contract methods,
   - active session/thread counts and status are now rendered from contract state snapshot.
4. Added collaboration contract unit tests:
   - expanded `desktop/test/contracts/workflow_contracts_test.dart` with presence/thread lifecycle and invalid-selection coverage.
5. Re-ran desktop verification chain:
   - `pnpm run desktop:test`,
   - `pnpm run desktop:test:parity`,
   - `pnpm run desktop:analyze`,
   - `pnpm run desktop:build:macos:debug`.
6. Updated migration/parity trackers:
   - collaboration notes now explicitly reference in-memory contract boundary baseline.

### Unit review (detailed)

- **Review scope**
  - correctness of collaboration state transitions after contract extraction,
  - parity regression risk for existing collaboration widget interactions,
  - consistency between tracker notes and implementation state.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Collaboration parity test remains green with contract-driven state.
  - Collaboration contract unit tests pass for lifecycle and guard paths.
  - Desktop test/analyze/build chain remains green after extraction.

## Unit WS-D-24: Inspect/handoff contract boundary extraction

### Planned objective

Continue WS-D contract-boundary extraction by moving inspect metadata/snippet handoff rules from widget-local mutable state into an explicit in-memory contract adapter with unit-test coverage.

### Implemented changes

1. Extended contract module:
   - `desktop/lib/contracts/workflow_contracts.dart`.
2. Implemented inspect contract baseline:
   - `InspectHandoffContract` interface,
   - `InMemoryInspectHandoffContract` adapter,
   - inspect state model and snippet-generation/copy-metadata transition rules.
3. Refactored `InspectHandoffPanel` to use contract adapter:
   - target selection and snippet/copy actions now delegate to contract methods,
   - target/snippet/status fields are now rendered from contract state snapshot.
4. Added inspect contract unit tests:
   - expanded `desktop/test/contracts/workflow_contracts_test.dart` with snippet-generation and metadata-copy coverage.
5. Re-ran desktop verification chain:
   - `pnpm run desktop:test`,
   - `pnpm run desktop:test:parity`,
   - `pnpm run desktop:analyze`,
   - `pnpm run desktop:build:macos:debug`.
6. Updated migration/parity trackers:
   - inspect notes now explicitly reference in-memory contract boundary baseline.

### Unit review (detailed)

- **Review scope**
  - correctness of inspect state transitions after contract extraction,
  - parity regression risk for existing inspect widget interactions,
  - consistency between tracker notes and implementation state.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Inspect parity test remains green with contract-driven state.
  - Inspect contract unit tests pass for lifecycle and guard paths.
  - Desktop test/analyze/build chain remains green after extraction.

## Unit WS-D-25: Shared contract-bundle injection and navigation persistence

### Planned objective

Eliminate per-panel contract re-instantiation and strengthen migration readiness by introducing a shared desktop contract bundle that is injected from shell scope, so workflow state can persist across section navigation and future backend adapters can be wired in one place.

### Implemented changes

1. Added contract bundle module:
   - `desktop/lib/contracts/desktop_contract_bundle.dart`.
2. Implemented in-memory bundle factory:
   - `DesktopContractBundle.inMemory()` creates all workflow contract adapters once at shell scope.
3. Refactored shell composition to dependency injection:
   - `DesktopShellPage` now owns one `DesktopContractBundle`,
   - workflow panels receive contracts via constructor injection instead of constructing local defaults.
4. Updated workflow panels for injectable contracts:
   - auth/project/canvas/asset/collaboration/inspect/export/diagnostics panels now accept optional contract inputs and bind state to injected instances.
5. Added regression tests for bundle/persistence behavior:
   - `desktop/test/contracts/desktop_contract_bundle_test.dart`,
   - `desktop/test/parity/shell_contract_persistence_parity_test.dart`.
6. Updated canonical parity runner:
   - `desktop/scripts/run_parity_tests.sh` now includes shell persistence parity test.
7. Re-ran desktop verification chain:
   - `pnpm run desktop:test`,
   - `pnpm run desktop:test:parity`,
   - `pnpm run desktop:analyze`,
   - `pnpm run desktop:build:macos:debug`.

### Unit review (detailed)

- **Review scope**
  - correctness of shared contract lifetime across navigation,
  - regression risk from panel constructor/injection changes,
  - parity coverage for persistence expectations.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Contract bundle unit test passes and verifies reusable contract wiring.
  - Shell persistence parity test passes and confirms status continuity across section switches.
  - Desktop test/analyze/build chain remains green after injection refactor.

## Unit WS-D-26: Verification-chain script consolidation

### Planned objective

Reduce redundant command maintenance and improve local/CI verification performance by consolidating desktop validation commands into one script that runs `pub get` once and reuses `--no-pub` for subsequent steps.

### Implemented changes

1. Added canonical verification script:
   - `desktop/scripts/verify_desktop.sh`.
2. Implemented consolidated chain in script:
   - `flutter pub get`,
   - `flutter test --no-pub`,
   - `FLUTTER_NO_PUB=1 ./scripts/run_parity_tests.sh`,
   - `flutter analyze --no-pub`,
   - optional `INCLUDE_BUILD=1` path for `flutter build macos --debug --no-pub`.
3. Updated root command surface:
   - added `desktop:verify`,
   - added `desktop:verify:full`,
   - added `desktop:test:parity:no-pub`.
4. Updated desktop CI workflow:
   - `.github/workflows/tests-desktop-flutter.yml` now runs `./scripts/verify_desktop.sh` as one verification step.
5. Updated acceptance baseline CI anchor:
   - documented canonical verification script path.
6. Re-ran consolidated full verification:
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - correctness and completeness of consolidated verification chain,
  - parity between local and CI execution paths,
  - runtime efficiency improvements from `--no-pub` reuse.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Consolidated verification script passes with full mode (`INCLUDE_BUILD=1`).
  - CI workflow and local verification now share one canonical command chain.
  - Command maintenance drift risk is reduced by centralizing verification orchestration.

## Unit WS-D-27: Parity test utility consolidation

### Planned objective

Improve parity-suite maintainability and reduce repetitive test setup code by introducing shared parity test utilities for app pump and workflow-section navigation.

### Implemented changes

1. Added parity test utility module:
   - `desktop/test/parity/parity_test_utils.dart`.
2. Implemented shared helpers:
   - `pumpDesktopApp(WidgetTester tester)`,
   - `openWorkflowSection(WidgetTester tester, String sectionId)`.
3. Refactored parity tests to use shared helpers:
   - auth/project/file/canvas/asset/collaboration/inspect/export/diagnostics/shell-persistence parity tests now consume utility helpers instead of repeating pump/navigation boilerplate.
4. Re-ran consolidated full verification:
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - correctness of refactored parity test navigation behavior,
  - regression risk from shared helper abstraction,
  - compatibility with existing parity runner and verify scripts.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - All parity tests pass after helper-based refactor.
  - Full verification chain remains green with build path included.
  - Parity suite navigation semantics remain unchanged while setup duplication is reduced.

## Unit WS-D-28: Runtime contract mode baseline

### Planned objective

Prepare backend-adapter rollout path by introducing runtime-selectable contract mode wiring (`in-memory` vs `remote-stub`) while keeping current behavior stable.

### Implemented changes

1. Extended desktop contract bundle model:
   - `desktop/lib/contracts/desktop_contract_bundle.dart`.
2. Added runtime mode enum and parser:
   - `DesktopContractMode` with `inMemory` and `remoteStub`,
   - env parser via `PENJAR_DESKTOP_CONTRACT_MODE`.
3. Added environment-aware bundle factory:
   - `DesktopContractBundle.fromEnvironment()`,
   - `DesktopContractBundle.remoteStub()` baseline path (currently mapped to in-memory adapters with explicit stub intent).
4. Updated shell initialization:
   - `DesktopShellPage` now loads contract bundle through environment factory.
5. Added runtime mode visibility in shell UI:
   - contract mode chip rendered in section metadata (`Contract Mode: in-memory|remote-stub`).
6. Added/expanded tests:
   - `desktop/test/contracts/desktop_contract_bundle_test.dart` now verifies mode parser aliases and in-memory mode baseline.
   - `desktop/test/widget_test.dart` now validates contract mode chip visibility.
7. Re-ran consolidated full verification:
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - correctness of runtime mode resolution and fallback behavior,
  - regression risk on shell metadata rendering after chip expansion,
  - compatibility with existing parity and verify chains.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Mode parser and shell mode indicators are covered by tests.
  - Full verification chain remains green with runtime-mode changes applied.
  - Contract mode switch path exists for upcoming remote adapter integration.

## Unit WS-D-29: Diagnostics contract-mode observability

### Planned objective

Improve runtime observability by surfacing active contract mode directly in diagnostics workflow output so mode-related behavior can be verified during manual and automated validation.

### Implemented changes

1. Extended diagnostics panel wiring:
   - `DesktopShellPage` now passes active `contractModeLabel` to `DiagnosticsRecoveryPanel`.
2. Updated diagnostics summary rendering:
   - diagnostics summary now includes `Contract mode: ...` prefix before connectivity metrics.
3. Expanded diagnostics parity coverage:
   - `desktop/test/parity/diagnostics_recovery_parity_test.dart` now asserts contract-mode label visibility.
4. Re-ran consolidated full verification:
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - correctness of diagnostics mode label propagation from shell bundle,
  - regression risk on diagnostics parity assertions after summary-text change,
  - compatibility with consolidated verification script flow.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Diagnostics parity test validates contract-mode visibility.
  - Full verification chain remains green with diagnostics summary extension.
  - Contract mode is visible in both shell metadata chips and diagnostics summary.

## Unit WS-D-30: Remote-stub adapter boundary implementation

### Planned objective

Replace placeholder remote-mode mapping with dedicated remote-stub contract adapters so runtime mode switching has real behavioral separation and parity coverage before backend transport wiring.

### Implemented changes

1. Added dedicated remote-stub adapter module:
   - `desktop/lib/contracts/remote_stub_contracts.dart`.
2. Implemented remote-stub wrappers for all workflow contracts:
   - auth/project/file-canvas/assets/collaboration/inspect/export/diagnostics wrappers now preserve payloads while prefixing status surface with `[remote-stub]`.
3. Updated contract bundle routing:
   - `desktop/lib/contracts/desktop_contract_bundle.dart` now maps `DesktopContractBundle.remoteStub()` to remote-stub adapters (not in-memory direct mapping),
   - added `DesktopContractBundle.fromMode(...)` for explicit mode-based construction.
4. Improved app-level testability for mode-specific parity:
   - `desktop/lib/main.dart` now accepts optional injected `DesktopContractBundle` in `PenjarDesktopApp` and `DesktopShellPage`,
   - `desktop/test/parity/parity_test_utils.dart` now supports bundle injection in `pumpDesktopApp(...)`.
5. Expanded contract and parity coverage:
   - `desktop/test/contracts/desktop_contract_bundle_test.dart` now verifies remote-stub adapter wiring and mode routing,
   - `desktop/test/contracts/workflow_contracts_test.dart` now validates remote-stub status-prefix behavior across all workflow domains,
   - added `desktop/test/parity/remote_stub_mode_parity_test.dart` for end-to-end runtime mode and status-surface verification.
6. Updated canonical parity runner:
   - `desktop/scripts/run_parity_tests.sh` now includes `remote_stub_mode_parity_test.dart`.
7. Updated Phase C tracker artifacts for continuity:
   - `desktop-flutter-parity-checklist.md` notes now reflect runtime-switchable in-memory/remote-stub contract boundaries,
   - `desktop-flutter-migration-inventory.md` now records runtime mode routing + parity gate in desktop shell/runtime row and runtime-switchable boundary notes across workflow rows,
   - `desktop-flutter-parity-acceptance-baseline.md` now includes a cross-cutting contract runtime mode gate row and CI anchor note.
8. Re-ran consolidated full verification:
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - correctness of remote-stub adapter separation from in-memory baseline,
  - regression risk from app-root bundle injection changes,
  - parity runner stability after adding remote mode gate.
- **Issues found during review**
  1. `remote_stub_mode_parity_test.dart` initially failed because `auth-sign-in` tap target could be off-screen under test viewport constraints, causing missed tap and downstream expectation failure.
- **Fix applied**
  1. Added `tester.ensureVisible(...)` before tapping `auth-sign-in` and diagnostics action buttons in remote mode parity test.
- **Post-fix validation criteria**
  - Remote-stub contract bundle tests validate dedicated adapter wiring and prefixed status semantics.
  - Remote mode parity test passes inside canonical parity runner.
  - Full verification chain remains green (`desktop:test`, parity runner, `desktop:analyze`, macOS debug build).

## Unit WS-D-31: Contract-mode matrix verification in canonical chain

### Planned objective

Prevent regressions in environment-driven contract-mode routing by validating desktop shell rendering under both default (`in-memory`) and env-switched (`remote-stub`) modes inside the canonical verification chain.

### Implemented changes

1. Added contract-mode matrix runner:
   - `desktop/scripts/run_mode_matrix_tests.sh`.
2. Implemented matrix test flow:
   - `flutter test test/widget_test.dart` (default mode),
   - `flutter test --dart-define=PENJAR_DESKTOP_CONTRACT_MODE=remote-stub test/widget_test.dart`.
3. Extended canonical verification script:
   - `desktop/scripts/verify_desktop.sh` now runs `FLUTTER_NO_PUB=1 ./scripts/run_mode_matrix_tests.sh` between parity and analyze steps.
4. Updated root desktop command surface:
   - added `desktop:test:mode-matrix`,
   - added `desktop:test:mode-matrix:no-pub`.
5. Updated widget-mode assertion semantics:
   - `desktop/test/widget_test.dart` now derives expected contract mode through `DesktopContractMode.fromEnv(const String.fromEnvironment(...)).label`, so the same widget test validates both modes.
6. Updated acceptance baseline execution anchor:
   - `desktop-flutter-parity-acceptance-baseline.md` now references mode-matrix script linkage in verification chain.
7. Re-ran consolidated full verification:
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - correctness of env-driven mode resolution under test runtime flags,
  - regression risk on existing widget parity expectations after mode-neutral assertion refactor,
  - verification-chain performance/consistency impact of added matrix step.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Widget-level contract mode assertions pass in both default and remote-stub matrix runs.
  - Canonical `desktop:verify:full` remains green with additional mode-matrix stage.
  - Mode-routing regressions are now caught before analyze/build stages in one chain.

## Unit WS-D-32: Desktop CI platform matrix expansion (Linux + macOS)

### Planned objective

Reduce desktop release-risk by extending CI coverage from Linux-only verification to a Linux+macOS matrix, with macOS build validation enabled in the same canonical verification chain.

### Implemented changes

1. Expanded desktop CI workflow matrix:
   - `.github/workflows/tests-desktop-flutter.yml` now defines a two-platform job matrix:
     - `linux` (`ubuntu-latest`, `INCLUDE_BUILD=0`),
     - `macos` (`macos-latest`, `INCLUDE_BUILD=1`).
2. Kept canonical verification entrypoint unchanged:
   - each matrix job runs `desktop/scripts/verify_desktop.sh`,
   - build stage toggled through `INCLUDE_BUILD` matrix variable.
3. Updated acceptance baseline CI notes:
   - `desktop-flutter-parity-acceptance-baseline.md` now records Linux parity chain + macOS parity/build matrix baseline.
4. Re-ran local full verification prior to commit:
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - correctness of matrix wiring and environment-variable propagation,
  - risk of divergence between Linux and macOS validation paths,
  - consistency of CI documentation with workflow behavior.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Workflow defines Linux and macOS jobs using one canonical verification script.
  - macOS path now executes build validation in CI through `INCLUDE_BUILD=1`.
  - Local full verification remains green after matrix workflow update.

## Unit WS-D-33: Desktop development continuity runbook linkage

### Planned objective

Strengthen long-running desktop migration continuity by adding a desktop-specific execution runbook and wiring it into all Phase C navigation anchors so future units can resume without document-gap drift.

### Implemented changes

1. Added desktop runbook artifact:
   - `docs/technical-guide/developer/desktop-flutter-development-runbook.md`.
2. Runbook scope includes:
   - session-start protocol,
   - per-unit execution loop,
   - required Phase C log schema,
   - verification/CI alignment policy,
   - handoff checklist and next-unit candidates.
3. Linked runbook into canonical documentation map:
   - `web-mcp-documentation-map.md` now references runbook in relationship graph and Phase C anchor semantics.
4. Linked runbook into implementation/entry anchors:
   - `web-mcp-desktop-implementation-plan.md` traceability anchors now include runbook,
   - `developer/index.md` implementation-planning link set now includes runbook.
5. Linked runbook into Phase C tracker docs:
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`.
6. Re-ran canonical desktop verification chain:
   - `pnpm run desktop:verify`.

### Unit review (detailed)

- **Review scope**
  - correctness/completeness of cross-document runbook linkage,
  - risk of broken navigation anchors in developer entrypoints,
  - consistency of runbook protocol with existing Phase C execution policy.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Runbook is reachable from documentation map, implementation plan, and developer index.
  - Phase C parity/inventory/acceptance artifacts all link back to runbook.
  - Desktop verification chain remains green after docs continuity update.

## Unit WS-D-34: Desktop CI Windows parity matrix coverage

### Planned objective

Close the remaining CI matrix coverage gap by extending the desktop verification workflow to include a Windows runner for parity/analyze coverage while preserving canonical script execution.

### Implemented changes

1. Expanded desktop CI workflow matrix:
   - `.github/workflows/tests-desktop-flutter.yml` now includes:
     - `windows` (`windows-latest`, `INCLUDE_BUILD=0`) in addition to Linux/macOS entries.
2. Preserved canonical verification flow:
   - Windows job also runs `desktop/scripts/verify_desktop.sh` through matrix variable injection.
3. Updated acceptance baseline CI anchor:
   - `desktop-flutter-parity-acceptance-baseline.md` now documents Linux + macOS + Windows matrix baseline semantics.
4. Re-ran local verification chain before unit closure:
   - `pnpm run desktop:verify`.

### Unit review (detailed)

- **Review scope**
  - correctness of matrix expansion syntax and runner mapping,
  - risk of script-path divergence on Windows runner,
  - consistency between CI workflow and acceptance-baseline documentation.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Desktop CI workflow now includes a Windows parity chain path.
  - Linux/macOS entries remain unchanged and still use canonical verification script.
  - Acceptance baseline reflects three-platform matrix status.

## Unit WS-D-35: Verification-chain fast path (`SKIP_PUB_GET`) optimization

### Planned objective

Reduce repeated local verification latency by allowing dependency-resolution skipping when lock/dependency state is unchanged, without altering CI-safe default behavior.

### Implemented changes

1. Added optional fast-path gate to canonical verifier:
   - `desktop/scripts/verify_desktop.sh` now skips `flutter pub get` when `SKIP_PUB_GET=1`.
2. Kept default behavior stable:
   - without `SKIP_PUB_GET`, verification chain still runs `flutter pub get` before tests.
3. Expanded root command surface for faster local iteration:
   - added `desktop:verify:fast`,
   - added `desktop:verify:full:fast`.
4. Updated continuity/runbook anchors:
   - `desktop-flutter-development-runbook.md` command list and verification policy now include fast-path usage.
5. Updated acceptance baseline CI/protocol notes:
   - `desktop-flutter-parity-acceptance-baseline.md` now documents `SKIP_PUB_GET` fast-path commands for local use.
6. Re-ran verification with fast path:
   - `pnpm run desktop:verify:fast`.

### Unit review (detailed)

- **Review scope**
  - correctness of fast-path guard logic and default-path preservation,
  - regression risk from new root command variants,
  - documentation accuracy for when fast path is safe to use.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `desktop:verify:fast` completes successfully and preserves test/analyze behavior.
  - Default `desktop:verify` path still performs dependency resolution.
  - Docs clearly restrict fast path to unchanged dependency state.

## Unit WS-D-36: Release validation baseline documentation and linkage

### Planned objective

Establish a concrete release-readiness baseline for desktop distribution by defining installer/signing/update validation gates and wiring the new artifact into all Phase C continuity anchors.

### Implemented changes

1. Added release validation baseline artifact:
   - `docs/technical-guide/developer/desktop-flutter-release-validation-baseline.md`.
2. Baseline content defines:
   - platform release targets (macOS/Windows),
   - required gates (build reproducibility, installer integrity, signing/notarization, update path, runtime smoke),
   - required evidence bundle per release candidate,
   - operating protocol and backlog seeds.
3. Linked baseline into core Phase C navigation:
   - `web-mcp-documentation-map.md`,
   - `web-mcp-desktop-implementation-plan.md`,
   - `developer/index.md`.
4. Linked baseline into desktop tracker/runbook artifacts:
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`,
   - `desktop-flutter-development-runbook.md`.
5. Updated runbook next-unit candidates after baseline publication:
   - shifted from baseline definition to evidence/index automation candidates.
6. Re-ran canonical verification fast path:
   - `pnpm run desktop:verify:fast`.

### Unit review (detailed)

- **Review scope**
  - completeness of release validation gates and evidence requirements,
  - cross-document linkage integrity for desktop continuity navigation,
  - consistency between newly documented release scope and existing remaining-gap statements.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Release baseline is reachable from documentation map, implementation plan, developer index, and Phase C tracker docs.
  - Remaining gaps now reference execution/automation readiness rather than missing baseline definition.
  - Fast verification chain remains green after documentation expansion.

## Unit WS-D-37: Remote-stub fault-profile boundary and degraded-path parity

### Planned objective

Increase backend-adapter readiness by giving remote-stub mode an executable degraded-path profile (`remote bridge unavailable`) so blocked-mutation behavior can be validated before real transport integration.

### Implemented changes

1. Extended remote-stub contract adapter model:
   - `desktop/lib/contracts/remote_stub_contracts.dart` now defines `RemoteStubFaultProfile`.
2. Added blocked-operation behavior in remote-stub contracts:
   - all mutating workflow operations now return deterministic `[remote-stub] Remote bridge unavailable: <operation>.` status when profile `unavailable=true`,
   - mutating delegate state is preserved (no unintended local mutation) under blocked profile.
3. Extended bundle wiring for fault-profile injection:
   - `desktop/lib/contracts/desktop_contract_bundle.dart` now supports:
     - `DesktopContractBundle.remoteStub(faultProfile: ...)`,
     - `DesktopContractBundle.fromMode(..., remoteStubFaultProfile: ...)`,
     - env-driven degraded mode via `PENJAR_DESKTOP_REMOTE_STUB_UNAVAILABLE`.
4. Expanded contract-level coverage:
   - `desktop/test/contracts/desktop_contract_bundle_test.dart` now verifies blocked behavior via unavailable fault profile.
   - `desktop/test/contracts/workflow_contracts_test.dart` now verifies blocked mutation semantics across auth/project/canvas/asset/collaboration/inspect/export/diagnostics remote-stub adapters.
5. Added degraded-path parity gate:
   - `desktop/test/parity/remote_stub_unavailable_parity_test.dart`.
6. Updated canonical parity runner list:
   - `desktop/scripts/run_parity_tests.sh` now includes `remote_stub_unavailable_parity_test.dart`.
7. Updated acceptance baseline CI anchor notes:
   - `desktop-flutter-parity-acceptance-baseline.md` now references remote-stub unavailable-profile parity gate.
8. Re-ran canonical full verification (fast path):
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - correctness of blocked-operation behavior under unavailable remote-stub profile,
  - regression risk on existing remote-stub nominal parity behavior,
  - parity-runner stability after adding degraded-path test.
- **Issues found during review**
  1. Initial implementation returned blocked status only from method return values; state getter continued reading delegate `Idle` status, causing contract/parity assertions to fail after UI re-render.
- **Fix applied**
  1. Added per-adapter status override state (`_statusOverride`) in all remote-stub contracts so blocked-operation status persists across subsequent state reads until next successful delegate operation clears override.
- **Post-fix validation criteria**
  - Unavailable-profile contract tests confirm blocked mutations and deterministic status semantics.
  - New degraded-path parity test passes in canonical parity suite.
  - Full verification chain remains green with fault-profile expansion.

## Unit WS-D-38: Release evidence index baseline

### Planned objective

Close release-audit traceability gaps by introducing a canonical release evidence index document and linking it into the Phase C documentation chain.

### Implemented changes

1. Added release evidence index artifact:
   - `docs/technical-guide/developer/desktop-flutter-release-evidence-index.md`.
2. Defined evidence index schema and table baseline:
   - RC/version/platform records,
   - artifact manifest links,
   - installer/update report links,
   - CI run links,
   - execution-log references,
   - promotion/block decisions.
3. Linked evidence index into release baseline:
   - `desktop-flutter-release-validation-baseline.md` related artifacts now include release evidence index,
   - backlog seed updated from document creation to evidence-index automation.
4. Linked evidence index into Phase C continuity map:
   - `web-mcp-documentation-map.md`,
   - `web-mcp-desktop-implementation-plan.md`,
   - `developer/index.md`,
   - `desktop-flutter-development-runbook.md`.
5. Re-ran canonical fast verification chain:
   - `pnpm run desktop:verify:fast`.

### Unit review (detailed)

- **Review scope**
  - adequacy of evidence fields for release audit traceability,
  - cross-document link integrity after adding new artifact,
  - consistency of remaining-gap statements with newly published evidence baseline.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Evidence index is reachable from release baseline, documentation map, implementation plan, developer index, and runbook.
  - Release baseline backlog now targets automation instead of baseline creation.
  - Fast verification chain remains green after documentation expansion.

## Unit WS-D-39: Release evidence guard automation (baseline)

### Planned objective

Add executable guardrails for release evidence quality so accidental promotion records with placeholder/TBD fields are blocked before release decisions.

### Implemented changes

1. Added release evidence check script:
   - `desktop/scripts/check_release_evidence_index.sh`.
2. Implemented baseline validations:
   - ensures release evidence index file exists,
   - enforces decision column contains `promoted` or `blocked`,
   - blocks `promoted` rows containing `TBD` or `placeholder` values.
3. Added root command surface:
   - `desktop:release:evidence:check`.
4. Updated release docs and runbook:
   - `desktop-flutter-release-evidence-index.md` maintenance rules now include the check command,
   - `desktop-flutter-release-validation-baseline.md` operating protocol now includes evidence-guard execution,
   - `desktop-flutter-development-runbook.md` canonical command list now includes evidence-guard check.
5. Re-ran verification and guard commands:
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:fast`.

### Unit review (detailed)

- **Review scope**
  - correctness of evidence-index row parsing and decision validation,
  - false-positive risk on placeholder blocked rows,
  - consistency between automation command and release documentation protocol.
- **Issues found during review**
  1. Initial implementation used bash lowercase expansion (`${var,,}`), which is unsupported on macOS default bash (3.x), causing script failure.
- **Fix applied**
  1. Replaced lowercase conversion with POSIX-compatible `tr '[:upper:]' '[:lower:]'` pipeline.
- **Post-fix validation criteria**
  - Evidence guard passes on current baseline placeholder entries (`blocked` rows).
  - Guard fails when invalid promoted rows contain placeholder/TBD data.
  - Fast verification chain remains green after release guard integration.

## Unit WS-D-40: CI artifact upload and release-evidence guard job integration

### Planned objective

Reduce release-traceability gaps by adding CI-level verification artifact uploads and wiring release-evidence guard execution into desktop CI workflow.

### Implemented changes

1. Extended desktop CI workflow execution model:
   - `.github/workflows/tests-desktop-flutter.yml` now captures parity job output logs per matrix platform (`linux`, `macos`, `windows`) via `tee`.
2. Added CI artifact upload automation:
   - uploads per-platform verification log artifacts,
   - uploads macOS debug app artifact from build-enabled matrix leg.
3. Added CI release evidence guard job:
   - new `release-evidence-guard` job executes `desktop/scripts/check_release_evidence_index.sh` on CI.
4. Expanded workflow path filters:
   - release evidence baseline/index and Phase C execution log changes now trigger the desktop CI workflow.
5. Updated docs for CI anchor continuity:
   - `desktop-flutter-parity-acceptance-baseline.md` now notes verification log + macOS artifact upload behavior,
   - `desktop-flutter-release-validation-baseline.md` now notes CI release-evidence guard job presence.
6. Re-ran local validation chain:
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:fast`.

### Unit review (detailed)

- **Review scope**
  - correctness of workflow matrix artifact-path handling,
  - risk of CI job dependency/tooling mismatches for evidence guard execution,
  - consistency between CI behavior and release/parity documentation anchors.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Desktop CI publishes verification logs across matrix runs.
  - macOS build leg uploads debug app artifact for audit/reference.
  - Release evidence guard runs as dedicated CI job on relevant doc/workflow changes.

## Unit WS-D-41: Update-manifest guard automation baseline

### Planned objective

Introduce executable baseline checks for desktop update manifest quality so release metadata errors can be caught automatically before promotion.

### Implemented changes

1. Added update manifest baseline file:
   - `desktop/release/update_manifest.example.json`.
2. Added update manifest guard script:
   - `desktop/scripts/check_update_manifest.sh`.
3. Implemented baseline validations:
   - required fields presence (`version`, `channel`, `publishedAt`, artifact URLs, release-notes URL),
   - semver-like version format check,
   - channel enum check (`stable|beta|dev`),
   - ISO8601 UTC timestamp check,
   - HTTPS URL enforcement.
4. Added root command surface:
   - `desktop:release:update-manifest:check`.
5. Added CI guard job:
   - `.github/workflows/tests-desktop-flutter.yml` now includes `release-update-manifest-guard` job.
6. Updated release/runbook documentation:
   - `desktop-flutter-release-validation-baseline.md` now requires running update-manifest guard in operating protocol and documents CI guard presence,
   - `desktop-flutter-development-runbook.md` command list now includes update-manifest guard,
   - `desktop-flutter-release-evidence-index.md` maintenance rules now include update-manifest guard execution.
7. Re-ran guard and verification commands:
   - `pnpm run desktop:release:update-manifest:check`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:fast`.

### Unit review (detailed)

- **Review scope**
  - correctness of manifest field extraction/validation semantics in shell script,
  - CI guard integration consistency with existing desktop/release jobs,
  - alignment of release protocol docs with new automation command.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Update-manifest guard passes for baseline example manifest.
  - CI workflow runs dedicated update-manifest guard job.
  - Fast verification chain remains green after update-manifest automation integration.

## Unit WS-D-42: Installer/update smoke pipeline baseline

### Planned objective

Reduce desktop release pipeline gaps by adding executable installer/update smoke automation that builds platform outputs and emits traceable report artifacts.

### Implemented changes

1. Added installer/update smoke report generator:
   - `desktop/scripts/generate_installer_update_report.sh`.
2. Added installer/update smoke orchestrator:
   - `desktop/scripts/release_installer_update_smoke.sh`.
3. Implemented report-generation semantics:
   - validates update manifest through `check_update_manifest.sh`,
   - packages platform build outputs into zip archive artifacts,
   - computes SHA-256 archive hash,
   - emits JSON report with version/channel/publishedAt/artifact/report trace fields.
4. Added root command surfaces:
   - `desktop:release:installer-smoke:macos`,
   - `desktop:release:installer-smoke:windows`.
5. Added manual CI smoke workflow:
   - `.github/workflows/release-desktop-installer-smoke.yml` (`workflow_dispatch`) with macOS/Windows matrix execution and artifact upload.
6. Updated release/runbook/index docs for continuity:
   - `desktop-flutter-release-validation-baseline.md` now includes smoke workflow protocol and backlog delta updates,
   - `desktop-flutter-development-runbook.md` command inventory and CI policy now include installer smoke entrypoint,
   - `desktop-flutter-release-evidence-index.md` maintenance rules now require smoke report artifact links before promotion.
7. Re-ran validation commands:
   - `pnpm run desktop:release:update-manifest:check`,
   - `pnpm run desktop:release:evidence:check`,
   - `cd desktop && SKIP_PUB_GET=1 ./scripts/release_installer_update_smoke.sh macos debug`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - correctness of installer smoke script orchestration and platform/mode argument guards,
  - report archive/hash generation and manifest-to-report field mapping integrity,
  - documentation and workflow continuity with release validation protocol.
- **Issues found during review**
  1. Initial archive writer preserved host path separators in ZIP entries, which can create inconsistent internal paths between macOS and Windows smoke outputs.
- **Fix applied**
  1. Normalized ZIP entry paths to `/` and added explicit empty-archive guard in `generate_installer_update_report.sh`.
- **Post-fix validation criteria**
  - Smoke command generates archive + JSON report for macOS build output.
  - Manual smoke workflow is available with macOS/Windows matrix jobs and report/archive uploads.
  - Full-fast desktop verification remains green after smoke automation integration.

## Unit WS-D-43: Release evidence row generation automation

### Planned objective

Eliminate manual release-evidence table row drafting by generating per-platform markdown row snippets directly from installer/update smoke reports.

### Implemented changes

1. Added release evidence row generator:
   - `desktop/scripts/generate_release_evidence_row.sh`.
2. Implemented row-generation semantics:
   - validates required smoke report fields (`platform`, `version`, archive path/hash),
   - maps platform labels to evidence-table format (`macOS`/`Windows`),
   - emits markdown row with escaped table cell values,
   - supports CI run URL / execution log ref / decision overrides.
3. Extended manual installer smoke workflow:
   - `.github/workflows/release-desktop-installer-smoke.yml` now accepts `rc_id` input,
   - generates release evidence row snippets after smoke report generation,
   - uploads row snippet artifacts per platform.
4. Added root command surfaces:
   - `desktop:release:evidence:row:macos`,
   - `desktop:release:evidence:row:windows`.
5. Updated release/runbook/index docs:
   - `desktop-flutter-release-validation-baseline.md` protocol now includes row-generation review before evidence recording,
   - `desktop-flutter-release-evidence-index.md` maintenance rules now include row-generation command,
   - `desktop-flutter-development-runbook.md` command inventory now includes evidence-row generation commands.
6. Re-ran validation commands:
   - `pnpm run desktop:release:update-manifest:check`,
   - `cd desktop && SKIP_PUB_GET=1 ./scripts/release_installer_update_smoke.sh macos debug`,
   - `pnpm run desktop:release:evidence:row:macos`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - correctness of smoke-report JSON parsing and required field enforcement,
  - row formatting safety for markdown table insertion,
  - CI artifact continuity for generated row snippets.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - `desktop:release:evidence:row:macos` generates stable markdown row snippet from smoke report.
  - Installer smoke workflow uploads report/archive/row triplet artifacts per matrix platform.
  - Full-fast desktop verification remains green after row-generation automation integration.

## Remaining Phase C setup gaps

- Role-level owners are assigned, but named individual assignees are not yet confirmed.
- All workflow domains now have Flutter parity scaffolds/harnesses, runtime-switchable in-memory/remote-stub contract boundaries, degraded-path remote-stub fault-profile gates, shared contract-bundle injection, and runtime mode parity/matrix gates, but real backend/service integration is still pending across auth/project/file/canvas/assets/collaboration/inspect/export/diagnostics.
- Desktop parity CI baseline is now configured on Linux+macOS+Windows with consolidated verification scripts, macOS build validation, verification log/app artifact upload automation, release-evidence guard automation, update-manifest guard automation, on-demand installer/update smoke build-report workflow, and automated release-evidence row snippet generation, but signed installer packaging/notarization and automated production update-promotion/appcast publication pipelines are not yet configured.
