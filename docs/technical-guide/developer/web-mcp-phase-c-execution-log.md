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
  1. Initial non-strict path marked provenance as fully validated when installer hash existed but provenance command hook was missing.
- **Fix applied**
  1. Updated provenance status aggregation so command-hook absence remains `warning` in non-strict mode and only becomes `validated` when provenance command executes successfully.
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

## Unit WS-D-44: Release evidence index update automation baseline

### Planned objective

Automate release-evidence index preview/apply updates from generated row snippets so release audit documentation can be updated without manual table editing errors.

### Implemented changes

1. Added release evidence index update script:
   - `desktop/scripts/update_release_evidence_index.sh`.
2. Implemented index-update semantics:
   - validates row snippet and evidence-index file existence,
   - parses row key (`RC + Platform`) and upserts table row,
   - inserts updated row at top of evidence table while preserving document body,
   - supports in-place apply mode and detached preview output mode.
3. Added root command surfaces:
   - `desktop:release:evidence:index:preview:macos`,
   - `desktop:release:evidence:index:preview:windows`,
   - `desktop:release:evidence:index:apply:macos`,
   - `desktop:release:evidence:index:apply:windows`.
4. Extended manual installer smoke workflow:
   - `.github/workflows/release-desktop-installer-smoke.yml` now generates and uploads release-evidence index preview artifacts per platform.
5. Updated release/runbook/index docs:
   - `desktop-flutter-release-validation-baseline.md` now includes index-preview review steps and updater script reference,
   - `desktop-flutter-release-evidence-index.md` maintenance rules now include preview/apply command protocol,
   - `desktop-flutter-development-runbook.md` command inventory now includes index preview/apply commands.
6. Re-ran validation commands:
   - `pnpm run desktop:release:evidence:index:preview:macos`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - correctness of markdown-table upsert targeting (RC+Platform uniqueness),
  - preview mode behavior versus in-place apply path safety,
  - CI artifact continuity for evidence-index preview outputs.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Preview command generates evidence-index markdown preview containing upserted row at table top.
  - Installer smoke workflow uploads index preview artifacts for both matrix platforms.
  - Full-fast desktop verification remains green after index-update automation integration.

## Unit WS-D-45: Appcast preview generation and validation baseline

### Planned objective

Establish executable appcast preview generation/validation pipeline from installer smoke reports to reduce update-promotion pipeline risk before publication integration.

### Implemented changes

1. Added appcast preview generator script:
   - `desktop/scripts/generate_appcast_from_reports.sh`.
2. Added appcast validation script:
   - `desktop/scripts/check_appcast.sh`.
3. Implemented appcast-generation semantics:
   - reads `update_manifest.example.json`,
   - ingests platform smoke reports (`installer_update_report_*.json`),
   - enforces version/channel consistency between manifest and smoke reports,
   - emits `appcast_preview.json` with artifact URL/hash/size metadata.
4. Added root command surfaces:
   - `desktop:release:appcast:generate`,
   - `desktop:release:appcast:check`.
5. Extended manual installer smoke workflow:
   - `.github/workflows/release-desktop-installer-smoke.yml` now includes `appcast-preview` job,
   - downloads smoke report artifacts,
   - generates/checks appcast preview,
   - uploads appcast preview artifact.
6. Updated release/runbook/index docs:
   - `desktop-flutter-release-validation-baseline.md` now includes appcast preview protocol and CI baseline note,
   - `desktop-flutter-development-runbook.md` command inventory now includes appcast commands,
   - `desktop-flutter-release-evidence-index.md` maintenance rules now include appcast preview checks.
7. Re-ran validation commands:
   - `pnpm run desktop:release:appcast:generate`,
   - `pnpm run desktop:release:appcast:check`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - consistency guards between manifest metadata and smoke report payloads,
  - appcast schema safety checks (channel/version/timestamps/URL/hash/size/platform uniqueness),
  - CI artifact continuity for appcast preview pipeline.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Appcast preview generation succeeds from smoke reports and manifest baseline.
  - Appcast checker rejects malformed appcast fields and passes generated preview.
  - Full-fast desktop verification remains green after appcast automation integration.

## Unit WS-D-46: Appcast publish dry-run automation baseline

### Planned objective

Add executable appcast publication dry-run automation so channel/version publication payloads are produced and audited before integrating external publication targets.

### Implemented changes

1. Added appcast publish dry-run script:
   - `desktop/scripts/publish_appcast.sh`.
2. Implemented publish dry-run semantics:
   - validates appcast channel/version fields,
   - writes channel latest payload (`appcast-<channel>-latest.json`),
   - writes version-pinned payload (`appcast-<channel>-<version>.json`).
3. Extended release artifact ignore/layout policy:
   - `desktop/release/.gitignore` now manages `published/` generated outputs,
   - `desktop/release/published/.gitkeep` added for stable workspace structure.
4. Added root command surface:
   - `desktop:release:appcast:publish:dry-run`.
5. Extended appcast-preview CI job:
   - `.github/workflows/release-desktop-installer-smoke.yml` now executes publish dry-run after appcast validation and uploads publish-target artifacts.
6. Updated release/runbook/index docs:
   - `desktop-flutter-release-validation-baseline.md` now includes publish dry-run step and CI note,
   - `desktop-flutter-development-runbook.md` command inventory now includes publish dry-run command,
   - `desktop-flutter-release-evidence-index.md` maintenance rules now include publish dry-run artifact checks.
7. Re-ran validation commands:
   - `pnpm run desktop:release:appcast:generate`,
   - `pnpm run desktop:release:appcast:check`,
   - `pnpm run desktop:release:appcast:publish:dry-run`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - channel/version publish-target naming determinism,
  - generated artifact handling/ignore policy safety,
  - CI continuity for dry-run publication outputs.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Dry-run publish command emits both latest and version-pinned appcast payload files.
  - Appcast-preview workflow uploads dry-run publication artifacts.
  - Full-fast desktop verification remains green after publish dry-run automation integration.

## Unit WS-D-47: Signing readiness guard and CI gate baseline

### Planned objective

Introduce explicit signing/notarization readiness preflight so missing release secrets are detected early, with optional strict workflow enforcement.

### Implemented changes

1. Added signing readiness check script:
   - `desktop/scripts/check_signing_readiness.sh`.
2. Implemented readiness report semantics:
   - validates presence of macOS/Windows signing-related environment variables,
   - emits markdown report (`release/reports/signing_readiness_report.md`),
   - supports non-strict warning mode and strict fail mode.
3. Added root command surfaces:
   - `desktop:release:signing:readiness`,
   - `desktop:release:signing:readiness:strict`.
4. Extended installer smoke workflow dispatch contract:
   - `.github/workflows/release-desktop-installer-smoke.yml` now accepts `enforce_signing_readiness` boolean input.
5. Added CI signing-readiness job:
   - new `signing-readiness` job executes readiness check with secrets wiring,
   - uploads signing readiness report artifact,
   - installer smoke matrix now depends on signing-readiness completion.
6. Updated release/runbook/index docs:
   - `desktop-flutter-release-validation-baseline.md` now includes signing readiness preflight protocol and CI baseline note,
   - `desktop-flutter-development-runbook.md` command inventory now includes signing readiness commands,
   - `desktop-flutter-release-evidence-index.md` maintenance rules now require signing readiness report attachment.
7. Re-ran validation commands:
   - `pnpm run desktop:release:appcast:generate`,
   - `pnpm run desktop:release:appcast:check`,
   - `pnpm run desktop:release:signing:readiness`,
   - `pnpm run desktop:release:appcast:publish:dry-run`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - correctness of strict/non-strict readiness mode behavior,
  - CI workflow gating behavior between signing-readiness and installer-smoke jobs,
  - report artifact continuity for release audit trail.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Non-strict readiness command emits report and warns without failing when secrets are absent.
  - Strict readiness mode is available for release-enforcement scenarios.
  - Full-fast desktop verification remains green after signing readiness gate integration.

## Unit WS-D-48: Appcast publication bundle automation baseline

### Planned objective

Standardize publication handoff metadata by generating and validating appcast publication bundle artifacts from dry-run publish outputs.

### Implemented changes

1. Added appcast publication bundle generator:
   - `desktop/scripts/generate_appcast_publication_bundle.sh`.
2. Added appcast publication bundle checker:
   - `desktop/scripts/check_appcast_publication_bundle.sh`.
3. Implemented bundle semantics:
   - reads appcast preview + published dry-run files,
   - captures per-target path/hash/size metadata,
   - enforces channel/version coherence and required latest/version target presence.
4. Added root command surfaces:
   - `desktop:release:appcast:bundle:generate`,
   - `desktop:release:appcast:bundle:check`.
5. Extended appcast-preview CI job:
   - `.github/workflows/release-desktop-installer-smoke.yml` now generates/checks publication bundle and uploads it as artifact.
6. Updated release/runbook/index docs:
   - `desktop-flutter-release-validation-baseline.md` now includes publication bundle protocol and CI note,
   - `desktop-flutter-development-runbook.md` command inventory now includes bundle commands,
   - `desktop-flutter-release-evidence-index.md` maintenance rules now include bundle artifact checks.
7. Re-ran validation commands:
   - `pnpm run desktop:release:appcast:generate`,
   - `pnpm run desktop:release:appcast:check`,
   - `pnpm run desktop:release:appcast:publish:dry-run`,
   - `pnpm run desktop:release:appcast:bundle:generate`,
   - `pnpm run desktop:release:appcast:bundle:check`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - publication bundle schema correctness and deterministic target metadata output,
  - required target presence checks (`latest` and version-pinned),
  - CI artifact continuity for publication handoff packaging.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Bundle generation emits publication metadata JSON with target hash/size entries.
  - Bundle checker validates schema and required target coverage.
  - Full-fast desktop verification remains green after bundle automation integration.

## Unit WS-D-49: Signing execution pipeline baseline integration

### Planned objective

Integrate executable signing/notarization pipeline baseline into installer smoke flow with strict enforcement toggle and per-platform reporting.

### Implemented changes

1. Added signing pipeline runners:
   - `desktop/scripts/run_signing_pipeline.sh`,
   - `desktop/scripts/run_signing_with_build.sh`.
2. Implemented signing pipeline semantics:
   - validates platform/build-mode inputs and build artifact presence,
   - supports strict/non-strict execution modes via `STRICT_SIGNING_EXECUTION`,
   - consumes command hooks (`PENJAR_MACOS_SIGN_COMMAND`, `PENJAR_MACOS_NOTARIZE_COMMAND`, `PENJAR_WINDOWS_SIGN_COMMAND`),
   - emits per-platform signing report (`release/reports/signing_report_<platform>.md`).
3. Integrated signing execution into smoke orchestrator:
   - `desktop/scripts/release_installer_update_smoke.sh` now runs signing pipeline before installer/update report generation.
4. Added root command surfaces:
   - `desktop:release:signing:run:macos`,
   - `desktop:release:signing:run:windows`.
5. Extended manual smoke workflow:
   - `.github/workflows/release-desktop-installer-smoke.yml` now accepts `enforce_signing_execution` input,
   - forwards signing command/credential env variables to smoke step,
   - uploads per-platform signing pipeline report artifacts.
6. Updated release/runbook/index docs:
   - `desktop-flutter-release-validation-baseline.md` now includes signing execution step details, strict mode guidance, and CI artifact notes,
   - `desktop-flutter-development-runbook.md` command inventory now includes signing run commands,
   - `desktop-flutter-release-evidence-index.md` maintenance rules now require signing pipeline report attachment.
7. Re-ran validation commands:
   - `pnpm run desktop:release:signing:run:macos`,
   - `cd desktop && SKIP_PUB_GET=1 ./scripts/release_installer_update_smoke.sh macos debug`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - signing pipeline strict/non-strict branch behavior and command hook safety,
  - workflow input/env propagation correctness for signing execution,
  - artifact/report continuity across smoke and release evidence chain.
- **Issues found during review**
  1. Initial root signing-run commands required pre-existing release artifacts and failed on clean environments.
  2. Artifact upload steps in installer-smoke/appcast-preview jobs were previously skipped when preceding steps failed, reducing failure triage visibility.
- **Fix applied**
  1. Added `run_signing_with_build.sh` wrapper and repointed signing-run root commands to build+run path.
  2. Added `if: always()` and `if-no-files-found: warn` for workflow artifact upload steps so logs/reports remain collectible during partial failures.
- **Post-fix validation criteria**
  - Smoke run emits signing pipeline report for executed platform.
  - Workflow supports strict signing execution toggle and uploads signing reports.
  - Full-fast desktop verification remains green after signing pipeline integration.

## Unit WS-D-50: External appcast publication stage baseline

### Planned objective

Add optional external publication stage for appcast artifacts with dry-run safety so publication-target integration can be validated before production rollout.

### Implemented changes

1. Added external publication runner:
   - `desktop/scripts/publish_appcast_external.sh`.
2. Implemented external publication semantics:
   - consumes `appcast_publication_bundle.json`,
   - supports provider routing (`none` / `s3`),
   - supports dry-run mode (`APPCAST_PUBLISH_DRY_RUN`),
   - applies cache-control policy (`latest` vs version-pinned targets),
   - emits external publication report (`release/reports/appcast_external_publication_report.md`).
3. Added root command surface:
   - `desktop:release:appcast:publish:external:dry-run`.
4. Extended manual smoke workflow dispatch contract:
   - added `publish_appcast_external`, `appcast_external_provider`, `appcast_external_dry_run` inputs.
5. Extended appcast-preview CI job:
   - optional external publication step executes when `publish_appcast_external=true`,
   - external publication report is uploaded as CI artifact.
6. Updated release/runbook/index docs:
   - `desktop-flutter-release-validation-baseline.md` now includes external publication dry-run protocol and CI baseline note,
   - `desktop-flutter-development-runbook.md` command inventory now includes external publication dry-run command,
   - `desktop-flutter-release-evidence-index.md` maintenance rules now include external publication report attachment.
7. Re-ran validation commands:
   - `pnpm run desktop:release:appcast:generate`,
   - `pnpm run desktop:release:appcast:check`,
   - `pnpm run desktop:release:appcast:publish:dry-run`,
   - `pnpm run desktop:release:appcast:bundle:generate`,
   - `pnpm run desktop:release:appcast:bundle:check`,
   - `pnpm run desktop:release:appcast:publish:external:dry-run`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - provider routing and dry-run safety behavior for external publication,
  - bundle-to-target mapping and cache-control strategy correctness,
  - CI artifact continuity for external publication reporting.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - External publication dry-run command succeeds and emits report.
  - Appcast-preview workflow exposes optional external publication stage and report artifact.
  - Full-fast desktop verification remains green after external publication stage integration.

## Unit WS-D-51: Windows installer packaging verification baseline

### Planned objective

Reduce Windows release artifact ambiguity by adding explicit `.msi/.exe` packaging verification baseline with strict enforcement toggle and report outputs.

### Implemented changes

1. Added Windows installer packaging checker:
   - `desktop/scripts/check_windows_installer_packaging.sh`.
2. Implemented checker semantics:
   - validates installer path and extension (`.msi` / `.exe`),
   - supports strict/non-strict mode,
   - emits report (`release/reports/windows_installer_packaging_report.md`).
3. Integrated checker into smoke orchestrator:
   - `desktop/scripts/release_installer_update_smoke.sh` now executes Windows installer packaging check on Windows path.
4. Added root command surface:
   - `desktop:release:windows-installer:check`.
5. Extended manual smoke workflow dispatch contract:
   - added `enforce_windows_installer_packaging` input.
6. Extended installer-smoke CI artifact set:
   - uploads Windows installer packaging report artifact with `always()` handling.
7. Updated release/runbook/index docs:
   - `desktop-flutter-release-validation-baseline.md` now includes Windows installer strict mode guidance and checker references,
   - `desktop-flutter-development-runbook.md` command inventory now includes Windows installer checker command,
   - `desktop-flutter-release-evidence-index.md` maintenance rules now include Windows installer packaging report attachment.
8. Re-ran validation commands:
   - `pnpm run desktop:release:windows-installer:check`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - strict/non-strict Windows installer artifact behavior,
  - CI input propagation and artifact upload continuity,
  - release evidence chain impact of new packaging report requirement.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Windows installer checker reports missing artifact as warning in non-strict mode.
  - Strict mode path is available for release gate enforcement.
  - Full-fast desktop verification remains green after Windows packaging verification integration.

## Unit WS-D-52: Windows installer command pipeline baseline

### Planned objective

Establish explicit command-hooked Windows installer generation pipeline with strict execution control, separated from artifact presence verification.

### Implemented changes

1. Added Windows installer pipeline runner:
   - `desktop/scripts/run_windows_installer_pipeline.sh`.
2. Implemented pipeline semantics:
   - validates build mode and runner directory context,
   - supports strict/non-strict execution mode (`STRICT_WINDOWS_INSTALLER_EXECUTION`),
   - consumes installer generation command hook (`PENJAR_WINDOWS_INSTALLER_COMMAND`),
   - exports standardized command context (`PENJAR_WINDOWS_RUNNER_DIR`, `PENJAR_WINDOWS_INSTALLER_OUTPUT_PATH`),
   - emits execution report (`release/reports/windows_installer_pipeline_report.md`).
3. Integrated pipeline into smoke orchestrator:
   - `desktop/scripts/release_installer_update_smoke.sh` now runs Windows installer pipeline before installer artifact check.
4. Added root command surface:
   - `desktop:release:windows-installer:run`.
5. Extended manual smoke workflow dispatch contract:
   - added `enforce_windows_installer_execution` input.
6. Extended installer-smoke workflow env/artifacts:
   - passes `STRICT_WINDOWS_INSTALLER_EXECUTION` and `PENJAR_WINDOWS_INSTALLER_COMMAND`,
   - uploads Windows installer pipeline report artifacts.
7. Updated release/runbook/index docs:
   - `desktop-flutter-release-validation-baseline.md` now includes strict execution guidance and pipeline runner reference,
   - `desktop-flutter-development-runbook.md` command inventory now includes Windows installer pipeline run command,
   - `desktop-flutter-release-evidence-index.md` maintenance rules now include pipeline report attachment.
8. Re-ran validation commands:
   - `pnpm run desktop:release:windows-installer:run`,
   - `pnpm run desktop:release:windows-installer:check`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - strict/non-strict execution semantics for Windows installer command hook,
  - workflow input/env wiring and artifact upload continuity,
  - coordination between installer pipeline execution and packaging verification stages.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Windows installer pipeline command emits execution report and warns in non-strict mode when context is unavailable.
  - Strict execution gate is configurable in workflow dispatch.
  - Full-fast desktop verification remains green after Windows installer pipeline integration.

## Unit WS-D-53: External appcast publication readiness gate baseline

### Planned objective

Introduce explicit external appcast publication readiness checks with strict/non-strict gating, so non-dry-run rollout preconditions are auditable before external publish execution.

### Implemented changes

1. Added external publication readiness checker:
   - `desktop/scripts/check_appcast_external_readiness.sh`.
2. Implemented readiness semantics:
   - supports strict/non-strict mode (`STRICT_APPCAST_EXTERNAL_READINESS`),
   - provider-aware checks (`none`, `s3`),
   - verifies publication bundle presence for external providers,
   - validates required S3 bucket configuration,
   - for non-dry-run mode, validates AWS CLI presence and credential signal availability (`AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY`, `AWS_PROFILE`, or role/web-identity pair),
   - records cache invalidation command absence as advisory warning,
   - emits readiness report (`release/reports/appcast_external_readiness_report.md`).
3. Added root command surface:
   - `desktop:release:appcast:external:readiness`,
   - `desktop:release:appcast:external:readiness:strict`.
4. Extended manual smoke workflow dispatch contract:
   - added `enforce_appcast_external_readiness` input.
5. Extended appcast-preview workflow stage:
   - runs readiness checker before external publication execution when `publish_appcast_external=true`,
   - passes external publication env/credential context to readiness and publish steps.
6. Extended artifact evidence chain:
   - uploads `desktop/release/reports/appcast_external_readiness_report.md` artifact.
7. Updated release/runbook/index docs:
   - `desktop-flutter-release-validation-baseline.md` now includes external readiness operating protocol and CI readiness gate references,
   - `desktop-flutter-development-runbook.md` command inventory now includes external readiness commands,
   - `desktop-flutter-release-evidence-index.md` maintenance rules now include readiness report attachment.
8. Re-ran validation commands:
   - `pnpm run desktop:release:appcast:external:readiness`,
   - `pnpm run desktop:release:appcast:external:readiness:strict`,
   - `pnpm run desktop:release:appcast:publish:external:dry-run`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - strict/non-strict readiness behavior for external publication preconditions,
  - workflow dispatch input propagation and appcast-preview stage ordering,
  - evidence artifact continuity for readiness + publication reports.
- **Issues found during review**
  1. Initial workflow patch reused the same step name (`Publish appcast to external target`) for readiness and publish stages, reducing run-log clarity.
- **Fix applied**
  1. Renamed readiness stage to `Run appcast external readiness check` for explicit traceability.
- **Post-fix validation criteria**
  - External publication readiness report is generated in dry-run/default conditions.
  - Strict readiness path can be enabled through workflow dispatch input.
  - Full-fast desktop verification remains green after readiness gate integration.

## Unit WS-D-54: Windows installer naming policy gate baseline

### Planned objective

Add explicit Windows installer filename policy validation with strict gating, so packaging evidence can assert not only artifact presence but also naming-policy compliance.

### Implemented changes

1. Extended Windows installer packaging checker:
   - `desktop/scripts/check_windows_installer_packaging.sh`.
2. Implemented naming-policy semantics:
   - added filename policy regex support (`PENJAR_WINDOWS_INSTALLER_NAME_PATTERN`, default `^PenjarInstaller\.(msi|exe)$`),
   - added strict naming mode (`STRICT_WINDOWS_INSTALLER_NAMING`),
   - added naming policy report fields (`Installer name`, `Naming policy pattern`, `Naming policy status`),
   - strict naming mode now fails when naming-policy status is not `passed`.
3. Added root command surface:
   - `desktop:release:windows-installer:check:strict` (strict packaging + strict naming).
4. Extended manual smoke workflow dispatch contract:
   - added `enforce_windows_installer_naming` input.
5. Extended installer-smoke workflow env contract:
   - passes `STRICT_WINDOWS_INSTALLER_NAMING` into smoke execution stage.
6. Updated release/runbook/index docs:
   - `desktop-flutter-development-runbook.md` command inventory now includes strict Windows installer check command,
   - `desktop-flutter-release-validation-baseline.md` now includes strict naming mode guidance and workflow input mapping,
   - `desktop-flutter-release-evidence-index.md` now requires naming policy `passed` status when strict naming mode is enabled.
7. Re-ran validation commands:
   - `pnpm run desktop:release:windows-installer:check`,
   - `cd desktop && PENJAR_WINDOWS_INSTALLER_PATH="build/windows/x64/runner/Release/installer/BadInstaller.exe" STRICT_WINDOWS_INSTALLER_NAMING=1 ./scripts/check_windows_installer_packaging.sh` (expected strict failure),
   - `PENJAR_WINDOWS_INSTALLER_PATH="build/windows/x64/runner/Release/installer/PenjarInstaller.exe" pnpm run desktop:release:windows-installer:check:strict`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - strict naming mode correctness and interaction with existing strict artifact-presence mode,
  - workflow input/env propagation for naming gate,
  - evidence/report semantics for naming-policy traceability.
- **Issues found during review**
  1. Initial strict naming implementation assigned strict-mode error context after report emission, causing report/error mismatch for strict naming failure.
- **Fix applied**
  1. Moved strict naming failure determination before report generation and persisted strict-naming failure reason in report fields.
- **Post-fix validation criteria**
  - Naming policy status is always emitted in packaging report.
  - Strict naming gate fails on invalid filename/missing artifact states.
  - Full-fast desktop verification remains green after naming-gate integration.

## Unit WS-D-55: Signing command-hook readiness gate baseline

### Planned objective

Expand signing readiness checks to cover command-hook presence, so signing execution prerequisites can be validated before installer smoke execution with explicit strict gating.

### Implemented changes

1. Extended signing readiness checker:
   - `desktop/scripts/check_signing_readiness.sh`.
2. Implemented command-hook readiness semantics:
   - added strict command-hook mode (`STRICT_SIGNING_COMMAND_HOOKS`),
   - added categorized readiness rows (`required`, `command-hook`),
   - added command-hook requirement rows (`PENJAR_MACOS_SIGN_COMMAND`, `PENJAR_MACOS_NOTARIZE_COMMAND`, `PENJAR_WINDOWS_SIGN_COMMAND`, `PENJAR_WINDOWS_INSTALLER_COMMAND`),
   - split summary counts into missing required vs missing command-hook counts.
3. Added root command surface:
   - `desktop:release:signing:readiness:command-hooks:strict`.
4. Extended manual smoke workflow dispatch contract:
   - added `enforce_signing_command_hooks` input.
5. Extended signing-readiness workflow env contract:
   - passes `STRICT_SIGNING_COMMAND_HOOKS` and all signing/installer command-hook secrets to readiness job.
6. Updated release/runbook/index docs:
   - `desktop-flutter-development-runbook.md` command inventory now includes strict signing command-hook readiness command,
   - `desktop-flutter-release-validation-baseline.md` now includes strict command-hook readiness guidance and workflow input mapping,
   - `desktop-flutter-release-evidence-index.md` now references command-hook strict readiness variant for report generation.
7. Re-ran validation commands:
   - `pnpm run desktop:release:signing:readiness`,
   - `cd desktop && STRICT_SIGNING_COMMAND_HOOKS=1 ./scripts/check_signing_readiness.sh` (expected strict failure),
   - `cd desktop && STRICT_SIGNING=1 STRICT_SIGNING_COMMAND_HOOKS=1 PENJAR_MACOS_SIGN_IDENTITY=mock PENJAR_MACOS_TEAM_ID=mock PENJAR_MACOS_NOTARY_PROFILE=mock PENJAR_WINDOWS_CERT_PATH=mock PENJAR_WINDOWS_CERT_PASSWORD=mock PENJAR_MACOS_SIGN_COMMAND='echo sign' PENJAR_MACOS_NOTARIZE_COMMAND='echo notarize' PENJAR_WINDOWS_SIGN_COMMAND='echo sign' PENJAR_WINDOWS_INSTALLER_COMMAND='echo installer' ./scripts/check_signing_readiness.sh`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - required-variable strict mode vs command-hook strict mode isolation,
  - workflow input/env propagation for readiness job,
  - report structure and summary count accuracy after category split.
- **Issues found during review**
  1. Initial fallback branch still failed readiness when `STRICT_SIGNING=1` and only command-hook items were missing, even with command-hook strict mode disabled.
- **Fix applied**
  1. Separated strict failure conditions so required-variable strict mode and command-hook strict mode fail independently according to their dedicated toggles.
- **Post-fix validation criteria**
  - Strict required-variable mode and strict command-hook mode operate independently.
  - Readiness report surfaces both missing-count dimensions.
  - Full-fast desktop verification remains green after readiness extension.

## Unit WS-D-56: External publication production consent guard baseline

### Planned objective

Introduce explicit production-consent gating for external appcast publication, so non-dry-run publication cannot execute without deliberate opt-in.

### Implemented changes

1. Added external production guard script:
   - `desktop/scripts/guard_appcast_external_production.sh`.
2. Implemented production-guard semantics:
   - reports provider/dry-run/production-consent state,
   - blocks unsupported providers for external publication stage,
   - blocks non-dry-run execution unless `ALLOW_APPCAST_EXTERNAL_PRODUCTION=1`,
   - emits guard report (`release/reports/appcast_external_production_guard_report.md`).
3. Added root command surface:
   - `desktop:release:appcast:external:production:guard`.
4. Extended manual smoke workflow dispatch contract:
   - added `allow_appcast_external_production` input.
5. Extended appcast-preview workflow stage:
   - runs production guard before readiness and external publication steps,
   - passes production-consent input to guard/readiness/publication stage env.
6. Extended artifact evidence chain:
   - uploads `desktop/release/reports/appcast_external_production_guard_report.md` artifact.
7. Updated release/runbook/index docs:
   - `desktop-flutter-development-runbook.md` command inventory now includes production guard command,
   - `desktop-flutter-release-validation-baseline.md` now includes production guard protocol and workflow input references,
   - `desktop-flutter-release-evidence-index.md` now includes production guard report attachment rule.
8. Re-ran validation commands:
   - `pnpm run desktop:release:appcast:external:production:guard`,
   - `cd desktop && APPCAST_PUBLISH_PROVIDER=s3 APPCAST_PUBLISH_DRY_RUN=0 ./scripts/guard_appcast_external_production.sh` (expected block),
   - `cd desktop && APPCAST_PUBLISH_PROVIDER=s3 APPCAST_PUBLISH_DRY_RUN=0 ALLOW_APPCAST_EXTERNAL_PRODUCTION=1 ./scripts/guard_appcast_external_production.sh`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - production-consent gate correctness for dry-run vs non-dry-run paths,
  - appcast-preview stage ordering (guard before readiness/publication),
  - report and artifact continuity for release evidence.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Non-dry-run external publication is blocked without explicit consent toggle.
  - Production guard report is generated and archived in workflow artifacts.
  - Full-fast desktop verification remains green after production guard integration.

## Unit WS-D-57: Windows installer provenance gate baseline

### Planned objective

Introduce explicit Windows installer provenance verification and strict gating, so installer smoke evidence can include artifact hash + provenance-command execution trace.

### Implemented changes

1. Added Windows installer provenance checker:
   - `desktop/scripts/check_windows_installer_provenance.sh`.
2. Implemented provenance semantics:
   - resolves installer target path (`PENJAR_WINDOWS_INSTALLER_PATH` fallback),
   - computes SHA256 hash (`shasum`/`sha256sum`),
   - supports optional provenance command hook (`PENJAR_WINDOWS_INSTALLER_PROVENANCE_COMMAND`),
   - supports strict/non-strict mode (`STRICT_WINDOWS_INSTALLER_PROVENANCE`),
   - emits provenance report (`release/reports/windows_installer_provenance_report.md`).
3. Integrated provenance checker into smoke orchestrator:
   - `desktop/scripts/release_installer_update_smoke.sh` now runs provenance checker for Windows after packaging checks.
4. Added root command surface:
   - `desktop:release:windows-installer:provenance`,
   - `desktop:release:windows-installer:provenance:strict`.
5. Extended manual smoke workflow dispatch contract:
   - added `enforce_windows_installer_provenance` input.
6. Extended installer-smoke workflow env/artifacts:
   - passes `STRICT_WINDOWS_INSTALLER_PROVENANCE` and `PENJAR_WINDOWS_INSTALLER_PROVENANCE_COMMAND`,
   - uploads Windows installer provenance report artifacts.
7. Updated release/runbook/index docs:
   - `desktop-flutter-development-runbook.md` command inventory now includes provenance check commands,
   - `desktop-flutter-release-validation-baseline.md` now includes provenance strict mode guidance and workflow input mapping,
   - `desktop-flutter-release-evidence-index.md` now includes provenance report attachment rule.
8. Re-ran validation commands:
   - `pnpm run desktop:release:windows-installer:provenance`,
   - `cd desktop && PENJAR_WINDOWS_INSTALLER_PATH="build/windows/x64/runner/Release/installer/PenjarInstaller.exe" ./scripts/check_windows_installer_provenance.sh 1` (expected strict failure: missing provenance command),
   - `cd desktop && PENJAR_WINDOWS_INSTALLER_PATH="build/windows/x64/runner/Release/installer/PenjarInstaller.exe" PENJAR_WINDOWS_INSTALLER_PROVENANCE_COMMAND='echo provenance-ok' ./scripts/check_windows_installer_provenance.sh 1`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - strict provenance gate behavior for missing artifact/command/hashing scenarios,
  - smoke workflow env propagation and artifact upload continuity,
  - report completeness for hash/provenance status fields.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Provenance report includes SHA256 and provenance command status fields.
  - Strict provenance mode fails when artifact/provenance-command requirements are unmet.
  - Full-fast desktop verification remains green after provenance gate integration.

## Unit WS-D-58: External production identity/invalidation readiness validation baseline

### Planned objective

Strengthen external publication readiness for non-dry-run mode by validating credential identity and invalidation check commands before production publication.

### Implemented changes

1. Extended external publication readiness checker:
   - `desktop/scripts/check_appcast_external_readiness.sh`.
2. Implemented production validation semantics for non-dry-run mode:
   - added identity validation command hook (`APPCAST_EXTERNAL_IDENTITY_CHECK_COMMAND`),
   - added invalidation validation command hook (`APPCAST_EXTERNAL_INVALIDATION_CHECK_COMMAND`),
   - readiness report now includes command configuration/status fields,
   - strict mode now requires identity/invalidation validation command hooks and actual invalidation execution command (`APPCAST_CACHE_INVALIDATION_COMMAND`) for non-dry-run checks.
3. Extended appcast-preview readiness step env contract:
   - `.github/workflows/release-desktop-installer-smoke.yml` now passes
     - `APPCAST_EXTERNAL_IDENTITY_CHECK_COMMAND`,
     - `APPCAST_EXTERNAL_INVALIDATION_CHECK_COMMAND`.
4. Updated release docs:
   - `desktop-flutter-release-validation-baseline.md` now documents strict production readiness command-hook expectations,
   - `desktop-flutter-release-evidence-index.md` now requires readiness report command-status fields for non-dry-run readiness evaluation.
5. Re-ran validation commands:
   - `pnpm run desktop:release:appcast:external:readiness`,
   - `cd desktop && APPCAST_PUBLISH_PROVIDER=s3 APPCAST_PUBLISH_DRY_RUN=0 APPCAST_S3_BUCKET=test-bucket STRICT_APPCAST_EXTERNAL_READINESS=1 ./scripts/check_appcast_external_readiness.sh` (expected strict failure),
   - `cd desktop && APPCAST_PUBLISH_PROVIDER=s3 APPCAST_PUBLISH_DRY_RUN=0 APPCAST_S3_BUCKET=test-bucket STRICT_APPCAST_EXTERNAL_READINESS=1 AWS_PROFILE=mock APPCAST_CACHE_INVALIDATION_COMMAND='echo invalidate' APPCAST_EXTERNAL_IDENTITY_CHECK_COMMAND='echo identity-ok' APPCAST_EXTERNAL_INVALIDATION_CHECK_COMMAND='echo invalidation-check-ok' ./scripts/check_appcast_external_readiness.sh`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - strict/non-strict readiness behavior for production identity/invalidation validation hooks,
  - workflow env propagation for new readiness command hooks,
  - readiness report completeness for command-state traceability.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Strict non-dry-run readiness fails when identity/invalidation validation hooks are missing.
  - Readiness report exposes identity/invalidation command configuration and execution status.
  - Full-fast desktop verification remains green after readiness validation extension.

## Unit WS-D-59: Release smoke gate policy preflight baseline

### Planned objective

Add an explicit gate-policy preflight to prevent inconsistent strict toggle combinations before expensive smoke/release stages run.

### Implemented changes

1. Added release smoke gate-policy checker:
   - `desktop/scripts/check_release_smoke_gate_policy.sh`.
2. Implemented preflight policy semantics:
   - normalizes boolean gate toggles from workflow/local env,
   - enforces required relationships (execution strict implies prerequisite strict hooks/gates),
   - enforces non-dry-run external publish consent requirement,
   - emits policy report (`release/reports/release_smoke_gate_policy_report.md`) with effective toggle map and required/advisory findings.
3. Added root command surface:
   - `desktop:release:smoke:gate-policy:check`.
4. Integrated policy preflight into installer smoke workflow:
   - `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job now runs preflight step before readiness checks.
5. Extended workflow artifact chain:
   - uploads `desktop/release/reports/release_smoke_gate_policy_report.md`.
6. Updated release/runbook/index docs:
   - `desktop-flutter-development-runbook.md` command inventory now includes gate-policy check command,
   - `desktop-flutter-release-validation-baseline.md` now includes preflight gate-policy protocol, CI note, and script index reference,
   - `desktop-flutter-release-evidence-index.md` now includes gate-policy report attachment rule.
7. Re-ran validation commands:
   - `pnpm run desktop:release:smoke:gate-policy:check`,
   - `cd desktop && STRICT_SIGNING_EXECUTION=1 ./scripts/check_release_smoke_gate_policy.sh` (expected failure: missing strict signing command-hook gate),
   - `cd desktop && STRICT_SIGNING_EXECUTION=1 STRICT_SIGNING_COMMAND_HOOKS=1 STRICT_WINDOWS_INSTALLER_EXECUTION=1 STRICT_WINDOWS_INSTALLER_PACKAGING=1 STRICT_WINDOWS_INSTALLER_PROVENANCE=1 PUBLISH_APPCAST_EXTERNAL=1 APPCAST_PUBLISH_DRY_RUN=0 ALLOW_APPCAST_EXTERNAL_PRODUCTION=1 STRICT_APPCAST_EXTERNAL_READINESS=1 ./scripts/check_release_smoke_gate_policy.sh`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - strict-toggle dependency correctness in policy rules,
  - workflow preflight placement and artifact continuity,
  - local command parity with workflow policy checks.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Invalid strict-toggle combinations fail preflight immediately.
  - Gate-policy report captures effective toggle map and findings.
  - Full-fast desktop verification remains green after preflight integration.

## Unit WS-D-60: Signing artifact provenance gate baseline

### Planned objective

Add signing artifact provenance verification to smoke flow, so platform signing evidence includes artifact hash and sign-verify command execution trace.

### Implemented changes

1. Added signing provenance checker:
   - `desktop/scripts/check_signing_artifact_provenance.sh`.
2. Implemented provenance semantics:
   - supports macOS/Windows artifact-path resolution with override paths,
   - computes deterministic artifact SHA256 (file/dir-aware hashing),
   - supports platform verify command hooks (`PENJAR_MACOS_SIGN_VERIFY_COMMAND`, `PENJAR_WINDOWS_SIGN_VERIFY_COMMAND`),
   - supports strict/non-strict mode (`STRICT_SIGNING_PROVENANCE`),
   - emits platform provenance reports (`release/reports/signing_artifact_provenance_macos.md`, `release/reports/signing_artifact_provenance_windows.md`).
3. Integrated signing provenance checker into smoke orchestrator:
   - `desktop/scripts/release_installer_update_smoke.sh` now runs signing provenance checks immediately after signing pipeline execution.
4. Extended installer-smoke workflow dispatch/env/artifacts:
   - added `enforce_signing_provenance` input,
   - passes `STRICT_SIGNING_PROVENANCE`, `PENJAR_MACOS_SIGN_VERIFY_COMMAND`, `PENJAR_WINDOWS_SIGN_VERIFY_COMMAND`,
   - uploads signing provenance report artifacts per platform.
5. Extended gate-policy preflight dependencies:
   - `check_release_smoke_gate_policy.sh` now validates `STRICT_SIGNING_PROVENANCE` dependency on signing execution/command-hook strict gates.
6. Added root command surface:
   - `desktop:release:signing:provenance:macos`,
   - `desktop:release:signing:provenance:windows`.
7. Updated release/runbook/index docs:
   - `desktop-flutter-development-runbook.md` now includes signing provenance commands and updated next-gap wording,
   - `desktop-flutter-release-validation-baseline.md` now includes signing provenance strict mode and workflow/script references,
   - `desktop-flutter-release-evidence-index.md` now includes signing provenance report attachment rule.
8. Re-ran validation commands:
   - `pnpm run desktop:release:signing:provenance:macos`,
   - `cd desktop && PENJAR_MACOS_SIGN_ARTIFACT_PATH="/tmp/penjar-signing-macos.bin" ./scripts/check_signing_artifact_provenance.sh macos 1` (expected strict failure without verify command),
   - `cd desktop && PENJAR_MACOS_SIGN_ARTIFACT_PATH="/tmp/penjar-signing-macos.bin" PENJAR_MACOS_SIGN_VERIFY_COMMAND='echo verify-ok' ./scripts/check_signing_artifact_provenance.sh macos 1`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - strict provenance behavior across missing artifact/hash/verify-command branches,
  - smoke workflow env/artifact integration for signing provenance evidence,
  - policy-preflight dependency enforcement for new strict signing provenance toggle.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Signing provenance report always includes artifact hash and verify-command state.
  - Strict signing provenance mode fails when verify evidence is incomplete.
  - Full-fast desktop verification remains green after signing provenance integration.

## Unit WS-D-61: Windows report upload scope normalization

### Planned objective

Reduce installer-smoke artifact noise by scoping Windows-only report uploads to Windows matrix runs.

### Implemented changes

1. Updated workflow artifact upload conditions:
   - `.github/workflows/release-desktop-installer-smoke.yml`.
2. Normalized matrix-scoped upload policy:
   - `Upload Windows installer packaging report` now runs only when `matrix.label == 'windows'`,
   - `Upload Windows installer pipeline report` now runs only when `matrix.label == 'windows'`,
   - `Upload Windows installer provenance report` now runs only when `matrix.label == 'windows'`.
3. Updated release validation baseline docs:
   - `desktop-flutter-release-validation-baseline.md` now documents Windows-only upload scope for Windows installer report artifacts.
4. Re-ran validation commands:
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - workflow artifact upload condition correctness in installer smoke matrix,
  - regression risk on report artifact naming and downstream evidence expectations,
  - documentation consistency with matrix-scoped upload behavior.
- **Issues found during review**
  1. Existing workflow attempted Windows-only report uploads on macOS matrix leg, generating repeated warning noise (`if-no-files-found: warn`).
- **Fix applied**
  1. Added matrix-scoped `if` guards (`matrix.label == 'windows'`) to all Windows-only report upload steps.
- **Post-fix validation criteria**
  - macOS matrix leg no longer attempts Windows-only report uploads.
  - Windows matrix leg continues to upload all Windows installer report artifacts.
  - Full-fast desktop verification remains green after workflow condition normalization.

## Unit WS-D-62: Release evidence bundle summary automation baseline

### Planned objective

Add platform-level release evidence bundle summaries so smoke outputs can be reviewed through a single status document per platform.

### Implemented changes

1. Added release evidence bundle summary generator:
   - `desktop/scripts/generate_release_evidence_bundle.sh`.
2. Implemented bundle summary semantics:
   - aggregates installer report metadata (version/artifact hash when available),
   - summarizes signing/signing-provenance and gate-policy statuses,
   - summarizes Windows-specific packaging/pipeline/provenance statuses on Windows platform bundles,
   - emits platform summary reports (`release/reports/release_evidence_bundle_macos.md`, `release/reports/release_evidence_bundle_windows.md`).
3. Added root command surface:
   - `desktop:release:evidence:bundle:macos`,
   - `desktop:release:evidence:bundle:windows`.
4. Integrated bundle generation into installer smoke workflow:
   - `.github/workflows/release-desktop-installer-smoke.yml` now generates bundle summaries per matrix leg after row generation.
5. Extended workflow artifact chain:
   - uploads `desktop/release/reports/release_evidence_bundle_${platform}.md`.
6. Updated release/runbook/index docs:
   - `desktop-flutter-development-runbook.md` now includes evidence bundle commands,
   - `desktop-flutter-release-validation-baseline.md` now includes evidence bundle review protocol and CI/script references,
   - `desktop-flutter-release-evidence-index.md` now includes evidence bundle summary attachment rule.
7. Re-ran validation commands:
   - `pnpm run desktop:release:evidence:bundle:macos`,
   - `pnpm run desktop:release:evidence:bundle:windows`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - bundle summary generation coverage for platform-specific report sets,
  - workflow generation/upload sequencing and artifact naming continuity,
  - documentation alignment for new summary artifacts in promotion checklist.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Platform bundle summaries are generated consistently from available smoke reports.
  - Installer smoke workflow publishes bundle summary artifacts for each platform.
  - Full-fast desktop verification remains green after bundle-summary automation integration.

## Unit WS-D-63: Release script syntax gate baseline

### Planned objective

Introduce a dedicated release-script syntax gate and integrate it into canonical desktop verification to catch shell syntax regressions before test/build stages.

### Implemented changes

1. Added release script syntax checker:
   - `desktop/scripts/check_release_script_syntax.sh`.
2. Implemented syntax-gate semantics:
   - scans top-level `desktop/scripts/*.sh`,
   - runs `bash -n` against each script,
   - emits syntax report (`release/reports/release_script_syntax_report.md`) with checked/failed script lists.
3. Integrated syntax gate into canonical verification chain:
   - `desktop/scripts/verify_desktop.sh` now runs release script syntax checks before test/analyze/build phases.
4. Added root command surface:
   - `desktop:release:scripts:syntax:check`.
5. Extended CI artifact chain:
   - `.github/workflows/tests-desktop-flutter.yml` now uploads release script syntax reports per platform matrix run.
6. Updated release/runbook/index docs:
   - `desktop-flutter-development-runbook.md` command inventory now includes release script syntax check command,
   - `desktop-flutter-release-validation-baseline.md` now includes syntax gate protocol and CI/script references,
   - `desktop-flutter-release-evidence-index.md` now includes release script syntax report attachment rule.
7. Re-ran validation commands:
   - `pnpm run desktop:release:scripts:syntax:check`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - syntax checker coverage and failure semantics across release scripts,
  - verify-chain ordering impact (syntax gate before tests),
  - CI artifact continuity for syntax reports across matrix platforms.
- **Issues found during review**
  1. None.
- **Fix applied**
  1. Not required.
- **Post-fix validation criteria**
  - Syntax regressions in release scripts fail verification before test/build stages.
  - Syntax reports are generated and uploaded in desktop CI matrix jobs.
  - Full-fast desktop verification remains green after syntax-gate integration.

## Unit WS-D-64: Verification test-chain de-duplication baseline

### Planned objective

Reduce duplicate test execution time in desktop verification while preserving full coverage and mode-matrix behavior.

### Implemented changes

1. Added dedicated contract-test runner:
   - `desktop/scripts/run_contract_tests.sh`.
2. Implemented contract-runner semantics:
   - executes only `test/contracts/desktop_contract_bundle_test.dart` and `test/contracts/workflow_contracts_test.dart`,
   - preserves `FLUTTER_NO_PUB=1` behavior for CI/local fast loops.
3. Optimized canonical verification chain:
   - `desktop/scripts/verify_desktop.sh` now runs:
     - release script syntax checks,
     - contract tests (`run_contract_tests.sh`),
     - parity tests (`run_parity_tests.sh`),
     - mode matrix tests (`run_mode_matrix_tests.sh`),
     - analyze/build.
   - removed redundant whole-suite `flutter test --no-pub` invocation that overlapped parity/mode matrix runs.
4. Added root command surface:
   - `desktop:test:contracts`,
   - `desktop:test:contracts:no-pub`.
5. Updated release/runbook docs:
   - `desktop-flutter-development-runbook.md` command inventory now includes contract test commands,
   - `desktop-flutter-release-validation-baseline.md` now documents de-duplicated verify-chain test routing and contract-runner script index reference.
6. Re-ran validation commands:
   - `pnpm run desktop:test:contracts:no-pub`,
   - `pnpm run desktop:test:parity:no-pub`,
   - `pnpm run desktop:test:mode-matrix:no-pub`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - test coverage parity after removing whole-suite duplicate run in `verify_desktop.sh`,
  - `--no-pub` behavior consistency across contract/parity/matrix scripts,
  - documentation and command surface alignment for maintainers.
- **Issues found during review**
  1. `verify_desktop.sh` executed parity and widget coverage multiple times because it ran full-suite tests before parity/mode-matrix scripts.
- **Fix applied**
  1. Replaced whole-suite test execution with dedicated contract-test runner to keep unique coverage only once while retaining matrix checks.
- **Post-fix validation criteria**
  - Contract, parity, and mode-matrix suites all pass under `FLUTTER_NO_PUB=1`.
  - Full-fast desktop verification remains green with the optimized test chain.
  - Release evidence guard remains green after verify-chain refactor.

## Unit WS-D-65: Verify test coverage guard baseline

### Planned objective

Prevent test omission regressions by validating that canonical verify runners cover every desktop test file and only allow intentional duplicate coverage paths.

### Implemented changes

1. Added verify test coverage checker:
   - `desktop/scripts/check_verify_test_coverage.sh`.
2. Implemented coverage-guard semantics:
   - scans `test/**/*_test.dart`,
   - parses runner references from `run_contract_tests.sh`, `run_parity_tests.sh`, and `run_mode_matrix_tests.sh`,
   - fails when uncovered tests or missing referenced tests are detected,
   - allows explicit duplicate-coverage exceptions via `VERIFY_TEST_COVERAGE_ALLOW_DUPLICATES` (default: `test/widget_test.dart`),
   - emits report (`release/reports/verify_test_coverage_report.md`) with discovered/covered/uncovered/missing/duplicate sections.
3. Integrated coverage guard into canonical verification:
   - `desktop/scripts/verify_desktop.sh` now runs `check_verify_test_coverage.sh` before test execution.
4. Added root command surface:
   - `desktop:test:coverage:check`.
5. Extended desktop CI artifact chain:
   - `.github/workflows/tests-desktop-flutter.yml` now uploads verify test coverage report artifacts (`desktop-verify-test-coverage-report-*`) for each matrix run.
6. Updated release/runbook/index docs:
   - `desktop-flutter-development-runbook.md` command inventory now includes verify test coverage command,
   - `desktop-flutter-release-validation-baseline.md` now includes verify coverage protocol and CI/script references,
   - `desktop-flutter-release-evidence-index.md` now includes verify test coverage report attachment rule.
7. Re-ran validation commands:
   - `pnpm run desktop:test:coverage:check`,
   - `cd desktop && VERIFY_TEST_COVERAGE_ALLOW_DUPLICATES='' ./scripts/check_verify_test_coverage.sh` (expected failure: unexpected duplicate widget coverage),
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - completeness of test discovery vs runner coverage mappings,
  - expected duplicate-coverage handling for mode matrix widget test,
  - verify-chain and CI artifact integration stability.
- **Issues found during review**
  1. Without explicit duplicate allowance, mode matrix widget test appears as duplicate coverage and should fail guard.
- **Fix applied**
  1. Added default duplicate allowlist (`test/widget_test.dart`) with env override support to keep intentional mode-matrix duplication while still detecting accidental duplicates.
- **Post-fix validation criteria**
  - Verify coverage guard fails on uncovered tests/missing references/unexpected duplicates.
  - Verify coverage report is generated in local and CI runs.
  - Full-fast desktop verification remains green after coverage guard integration.

## Unit WS-D-66: Release smoke readiness preflight hardening

### Planned objective

Ensure release smoke workflow always performs script-syntax and verify-coverage preflight checks before signing readiness and smoke execution.

### Implemented changes

1. Hardened release smoke preflight chain:
   - `.github/workflows/release-desktop-installer-smoke.yml` `signing-readiness` job now runs:
     - `./scripts/check_release_script_syntax.sh`,
     - `./scripts/check_verify_test_coverage.sh`,
     before gate-policy and signing-readiness checks.
2. Extended smoke workflow artifacts:
   - uploads `desktop-release-script-syntax-report-smoke` (`release_script_syntax_report.md`),
   - uploads `desktop-verify-test-coverage-report-smoke` (`verify_test_coverage_report.md`).
3. Updated release baseline docs:
   - `desktop-flutter-release-validation-baseline.md` now documents smoke preflight coverage/syntax checks and artifact names in CI baseline notes.
4. Re-ran validation commands:
   - `pnpm run desktop:release:scripts:syntax:check`,
   - `pnpm run desktop:test:coverage:check`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - smoke workflow preflight ordering and failure propagation before signing checks,
  - artifact traceability for newly added preflight reports,
  - baseline documentation consistency with workflow behavior.
- **Issues found during review**
  1. Release smoke workflow did not independently enforce script-syntax and verify-coverage guards if desktop parity CI was bypassed.
- **Fix applied**
  1. Added explicit preflight guard steps and artifact uploads inside smoke `signing-readiness` job.
- **Post-fix validation criteria**
  - Smoke workflow fails early when syntax/coverage guards fail.
  - Smoke workflow consistently publishes preflight report artifacts.
  - Full-fast desktop verification remains green after workflow hardening.

## Unit WS-D-67: Release evidence index schema + uniqueness guard hardening

### Planned objective

Harden release evidence index validation so malformed rows and duplicated RC/platform keys are blocked before promotion decisions.

### Implemented changes

1. Extended evidence index checker input contract:
   - `desktop/scripts/check_release_evidence_index.sh` now accepts optional index-file path argument for testability (`default` remains canonical docs path).
2. Implemented schema + uniqueness validation:
   - enforces exact 8-column table schema for data rows,
   - validates required RC/platform/decision fields are non-empty,
   - validates decision value starts with `promoted` or `blocked`,
   - enforces RC+platform uniqueness across rows,
   - keeps promoted-row placeholder/TBD guards and now also verifies promoted required evidence fields are non-empty.
3. Updated release baseline docs:
   - `desktop-flutter-release-validation-baseline.md` now documents stronger `check_release_evidence_index.sh` guarantees (schema, uniqueness, decision validity).
4. Re-ran validation commands:
   - `cd desktop && ./scripts/check_release_evidence_index.sh`,
   - `cd desktop && ./scripts/check_release_evidence_index.sh <temp-duplicate-index>` (expected failure: duplicate RC+platform),
   - `cd desktop && ./scripts/check_release_evidence_index.sh <temp-malformed-index>` (expected failure: invalid column count),
   - `cd desktop && SKIP_PUB_GET=1 INCLUDE_BUILD=1 ./scripts/verify_desktop.sh`.

### Unit review (detailed)

- **Review scope**
  - evidence table row parsing robustness and schema constraints,
  - duplicate RC/platform detection behavior,
  - compatibility of stricter checks with existing placeholder rows.
- **Issues found during review**
  1. Previous checker accepted malformed table rows and duplicated RC/platform rows, enabling silent release evidence drift.
- **Fix applied**
  1. Added strict row schema and uniqueness checks with explicit error reporting line numbers.
- **Post-fix validation criteria**
  - Duplicate RC/platform rows fail the evidence check.
  - Malformed table rows fail the evidence check.
  - Full-fast desktop verification remains green with stricter evidence checks.

## Unit WS-D-68: Strict appcast platform coverage guard

### Planned objective

Prevent appcast preview generation from succeeding with partial platform evidence by enforcing both macOS and Windows smoke report presence in strict mode.

### Implemented changes

1. Extended appcast generator strict mode:
   - `desktop/scripts/generate_appcast_from_reports.sh` now supports `APPCAST_REQUIRE_BOTH_PLATFORMS` (`1/true/yes/on`) to require both `macos` and `windows` reports.
2. Added strict command surface:
   - `desktop:release:appcast:generate:strict` (`APPCAST_REQUIRE_BOTH_PLATFORMS=1`).
3. Hardened smoke workflow appcast generation:
   - `.github/workflows/release-desktop-installer-smoke.yml` `appcast-preview` generation step now sets `APPCAST_REQUIRE_BOTH_PLATFORMS=1`.
4. Updated runbook/release baseline docs:
   - `desktop-flutter-development-runbook.md` command inventory now includes strict appcast generate command,
   - `desktop-flutter-release-validation-baseline.md` now documents strict appcast generation protocol and CI strict coverage behavior.
5. Re-ran validation commands:
   - `pnpm run desktop:release:appcast:generate`,
   - `pnpm run desktop:release:appcast:generate:strict` (expected failure with only macOS smoke report),
   - strict-pass synthetic scenario using temporary dual-platform report set (`APPCAST_REQUIRE_BOTH_PLATFORMS=1 ./scripts/generate_appcast_from_reports.sh ...`),
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - strict mode failure semantics for partial platform reports,
  - smoke workflow enforcement placement for appcast generation,
  - command and documentation discoverability for strict mode operations.
- **Issues found during review**
  1. Appcast generation previously accepted single-platform report sets, allowing partial release metadata to pass.
- **Fix applied**
  1. Added strict both-platform requirement and enforced it in smoke workflow appcast generation step.
- **Post-fix validation criteria**
  - Strict appcast generation fails when either macOS or Windows report is missing.
  - Strict appcast generation passes with valid dual-platform report set.
  - Full-fast desktop verification remains green after strict appcast coverage integration.

## Unit WS-D-69: Desktop command inventory guard baseline

### Planned objective

Prevent command-surface drift between desktop release docs and executable package scripts by enforcing command inventory consistency.

### Implemented changes

1. Added desktop command inventory checker:
   - `desktop/scripts/check_desktop_command_inventory.sh`.
2. Implemented inventory-guard semantics:
   - scans desktop runbook + release validation baseline docs for `pnpm run <command>` entries,
   - validates each detected command exists in `package.json` `scripts`,
   - fails when missing commands are detected (or when no commands are discovered),
   - emits inventory report (`release/reports/desktop_command_inventory_report.md`) with source references.
3. Integrated inventory guard into canonical verification:
   - `desktop/scripts/verify_desktop.sh` now runs command inventory checks before test/analyze/build phases.
4. Added root command surface:
   - `desktop:docs:command-inventory:check`.
5. Extended CI/smoke artifact chains:
   - `.github/workflows/tests-desktop-flutter.yml` now uploads `desktop-command-inventory-report-*` artifacts,
   - `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness preflight now runs command inventory checks and uploads `desktop-command-inventory-report-smoke`.
6. Updated release/runbook/index docs:
   - `desktop-flutter-development-runbook.md` command inventory now includes desktop command inventory check command,
   - `desktop-flutter-release-validation-baseline.md` now documents inventory protocol, CI notes, and script index reference,
   - `desktop-flutter-release-evidence-index.md` now includes desktop command inventory report attachment rule.
7. Re-ran validation commands:
   - `pnpm run desktop:docs:command-inventory:check`,
   - `cd desktop && ./scripts/check_desktop_command_inventory.sh <tmp-report> ../package.json <tmp-doc-with-fake-command>` (expected failure: missing command),
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - document command extraction correctness across runbook/baseline docs,
  - missing-command failure semantics and report traceability,
  - verify-chain and workflow preflight integration stability.
- **Issues found during review**
  1. Docs and package command surfaces could drift without a machine-enforced check, causing runbook commands to break silently.
- **Fix applied**
  1. Added automated inventory guard and wired it into verify + CI + smoke preflight.
- **Post-fix validation criteria**
  - Missing doc-referenced commands fail inventory checks.
  - Inventory reports are generated in local verify, desktop CI, and smoke preflight runs.
  - Full-fast desktop verification remains green after inventory-guard integration.

## Unit WS-D-70: Update manifest validation report hardening

### Planned objective

Improve update-manifest validation robustness and traceability by replacing text parsing with JSON validation and publishing explicit validation reports in CI/smoke preflight.

### Implemented changes

1. Hardened update manifest checker implementation:
   - `desktop/scripts/check_update_manifest.sh` now uses JSON parsing (`python`) instead of `sed` extraction.
2. Implemented validation report semantics:
   - supports optional report output path argument (`default: release/reports/update_manifest_validation_report.md`),
   - emits field-level and check-level status report,
   - validates required fields, semver-like version, channel, timestamp, https URLs, platform URL suffixes, and macOS/Windows URL distinctness.
3. Extended desktop CI update-manifest guard artifacts:
   - `.github/workflows/tests-desktop-flutter.yml` `release-update-manifest-guard` job now uploads `desktop-update-manifest-validation-report`.
4. Extended smoke signing-readiness preflight:
   - `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job now runs `check_update_manifest.sh`,
   - uploads `desktop-update-manifest-validation-report-smoke`.
5. Updated release/index docs:
   - `desktop-flutter-release-validation-baseline.md` now documents update-manifest validation report artifacts and checker output path,
   - `desktop-flutter-release-evidence-index.md` now includes update manifest validation report attachment rule.
6. Applied Python compatibility hardening:
   - removed runtime-evaluated builtin generic annotations from python snippets in
     `check_update_manifest.sh` and `check_desktop_command_inventory.sh` to preserve compatibility on runners with Python < 3.9.
7. Re-ran validation commands:
   - `pnpm run desktop:release:update-manifest:check`,
   - `cd desktop && ./scripts/check_update_manifest.sh <temp-invalid-manifest> release/reports/update_manifest_validation_report_test.md` (expected failure: invalid channel),
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - parser robustness against JSON formatting changes,
  - report generation on pass/fail paths,
  - CI/smoke workflow artifact continuity for update-manifest validation evidence.
- **Issues found during review**
  1. Previous `sed`-based parsing was brittle for JSON structure/format variation and produced no explicit validation report artifact.
  2. Builtin-generic type annotations in inline python snippets could reduce compatibility on runners using older Python versions.
- **Fix applied**
  1. Replaced parsing with JSON validation and added report generation plus artifact uploads in both CI update-manifest guard and smoke preflight.
  2. Removed runtime-evaluated builtin generic annotations from inline python snippets.
- **Post-fix validation criteria**
  - Invalid manifest values fail with explicit report output.
  - Update manifest validation reports are published in CI and smoke preflight workflows.
  - Full-fast desktop verification remains green after checker hardening.

## Unit WS-D-71: Signing placeholder hygiene strict mode

### Planned objective

Reduce false-ready signing states by detecting placeholder/dummy signing inputs and allowing strict failure enforcement in release smoke workflows.

### Implemented changes

1. Extended signing readiness checker:
   - `desktop/scripts/check_signing_readiness.sh` now supports strict placeholder mode via `STRICT_SIGNING_PLACEHOLDERS` (or fourth positional argument).
2. Implemented placeholder semantics:
   - detects placeholder-like values (`echo ...`, `<...>`, `todo/tbd/placeholder/changeme/replace_me/example/dummy/sample` patterns),
   - tracks placeholder counts separately for required fields and command hooks,
   - writes placeholder counts into signing readiness report,
   - fails in strict placeholder mode when placeholder values are present.
3. Added root command surface:
   - `desktop:release:signing:readiness:placeholders:strict`.
4. Extended release smoke workflow controls:
   - `.github/workflows/release-desktop-installer-smoke.yml` now supports `enforce_signing_placeholder_hygiene` input,
   - passes `STRICT_SIGNING_PLACEHOLDERS` into gate-policy and signing-readiness checks.
5. Extended gate-policy preflight dependencies:
   - `desktop/scripts/check_release_smoke_gate_policy.sh` now models `STRICT_SIGNING_PLACEHOLDERS` and requires `STRICT_SIGNING_COMMAND_HOOKS=1` when enabled.
6. Updated release/runbook/index docs:
   - `desktop-flutter-development-runbook.md` command inventory now includes placeholder strict signing readiness command,
   - `desktop-flutter-release-validation-baseline.md` now documents placeholder strict mode and workflow input support,
   - `desktop-flutter-release-evidence-index.md` now includes placeholder strict variant in signing readiness evidence rule.
7. Re-ran validation commands:
   - `pnpm run desktop:release:signing:readiness`,
   - strict expected-fail scenario with placeholder signing command in strict mode,
   - strict pass scenario with non-placeholder signing readiness values,
   - `cd desktop && STRICT_SIGNING_PLACEHOLDERS=1 ./scripts/check_release_smoke_gate_policy.sh` (expected failure without strict command-hook gate),
   - `cd desktop && STRICT_SIGNING_PLACEHOLDERS=1 STRICT_SIGNING_COMMAND_HOOKS=1 ./scripts/check_release_smoke_gate_policy.sh`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - placeholder detection accuracy and strict-mode failure behavior,
  - gate-policy dependency coherence for new strict toggle,
  - documentation alignment for new strict command/workflow input.
- **Issues found during review**
  1. Signing readiness could report non-missing but placeholder/dummy values as effectively ready.
- **Fix applied**
  1. Added placeholder status detection/counting and strict placeholder failure mode with workflow+policy integration.
- **Post-fix validation criteria**
  - Placeholder values are explicitly marked in readiness reports.
  - Strict placeholder mode fails on placeholder values.
  - Gate policy blocks strict placeholder mode when strict command-hook gate is disabled.
  - Full-fast desktop verification remains green after placeholder-hygiene integration.

## Unit WS-D-72: Verify stage timing instrumentation baseline

### Planned objective

Add stage-level timing instrumentation to desktop verification so performance regressions can be tracked through consistent local/CI evidence artifacts.

### Implemented changes

1. Instrumented canonical verify chain:
   - `desktop/scripts/verify_desktop.sh` now records per-stage status/duration (pub-get, syntax/coverage/inventory checks, contract/parity/mode-matrix tests, analyze, optional build).
2. Implemented timing report semantics:
   - emits `release/reports/verify_stage_timing_report.md`,
   - includes overall status, total duration, and stage-level timing table,
   - records skipped stages explicitly (`pub get` when skipped, macOS build when not requested),
   - writes report on both success/failure via `EXIT` trap.
3. Extended desktop CI artifact chain:
   - `.github/workflows/tests-desktop-flutter.yml` now uploads `desktop-verify-stage-timing-report-*` artifacts per matrix run.
4. Updated release/index docs:
   - `desktop-flutter-release-validation-baseline.md` now documents verify timing report generation and CI artifact names,
   - `desktop-flutter-release-evidence-index.md` now includes verify stage timing report attachment rule.
5. Re-ran validation commands:
   - `pnpm run desktop:verify:full:fast`,
   - validated generated timing report content (`release/reports/verify_stage_timing_report.md`),
   - `pnpm run desktop:release:evidence:check`.

### Unit review (detailed)

- **Review scope**
  - timing instrumentation correctness and exit-path resilience,
  - stage coverage completeness including skipped-path handling,
  - CI artifact continuity for timing evidence.
- **Issues found during review**
  1. Performance insights were only inferred from raw logs; there was no normalized stage timing artifact for trend tracking.
- **Fix applied**
  1. Added stage-timed execution wrapper/report generation in `verify_desktop.sh` and wired report upload in desktop CI matrix.
- **Post-fix validation criteria**
  - Verify runs always generate timing report artifacts.
  - Stage-level timing/status entries cover each canonical verify stage.
  - Full-fast desktop verification remains green after instrumentation.

## Unit WS-D-73: Canonical verify update-manifest gate integration

### Planned objective

Align canonical desktop verification with release guard expectations by executing update-manifest validation in the verify chain and publishing matrix-level manifest validation artifacts.

### Implemented changes

1. Extended canonical verify preflight chain:
   - `desktop/scripts/verify_desktop.sh` now runs `check_update_manifest.sh` as a timed stage before contract/parity/mode-matrix tests.
2. Extended desktop CI matrix artifacts:
   - `.github/workflows/tests-desktop-flutter.yml` now uploads `desktop-update-manifest-validation-report-*` artifacts from verify matrix jobs.
3. Updated release baseline docs:
   - `desktop-flutter-release-validation-baseline.md` now documents verify-chain update-manifest execution and matrix artifact publication.
4. Re-ran validation commands:
   - `pnpm run desktop:release:update-manifest:check`,
   - `pnpm run desktop:verify:full:fast`,
   - validated verify timing report includes `update manifest check` stage,
   - `pnpm run desktop:release:evidence:check`.

### Unit review (detailed)

- **Review scope**
  - verify-stage ordering impact after adding update-manifest check,
  - CI artifact continuity for per-platform matrix verify outputs,
  - compatibility with existing standalone update-manifest guard job.
- **Issues found during review**
  1. Update-manifest validation existed as standalone guard, but canonical verify chain did not enforce it, allowing local/fast verification to miss manifest regressions.
- **Fix applied**
  1. Added update-manifest check into canonical verify preflight and aligned matrix artifact publication accordingly.
- **Post-fix validation criteria**
  - Canonical verify fails when update manifest validation fails.
  - Verify timing reports include update-manifest stage data.
  - Full-fast desktop verification remains green after verify-chain integration.

## Unit WS-D-74: Release evidence bundle status guard baseline

### Planned objective

Add automated status validation for release evidence bundle summaries so risky/missing report states can be surfaced (and optionally enforced) before promotion decisions.

### Implemented changes

1. Added release evidence bundle checker:
   - `desktop/scripts/check_release_evidence_bundle.sh`.
2. Implemented bundle-check semantics:
   - parses `release_evidence_bundle_{platform}.md` status table rows,
   - classifies statuses into `ok` / `risky` / `critical`,
   - fails on critical statuses always,
   - supports strict mode via `STRICT_RELEASE_EVIDENCE_BUNDLE` (or positional argument) to fail on risky statuses as well,
   - emits check reports (`release/reports/release_evidence_bundle_check_macos.md`, `release/reports/release_evidence_bundle_check_windows.md`).
3. Added root command surface:
   - `desktop:release:evidence:bundle:check:macos`,
   - `desktop:release:evidence:bundle:check:windows`,
   - `desktop:release:evidence:bundle:check:macos:strict`,
   - `desktop:release:evidence:bundle:check:windows:strict`.
4. Extended installer smoke workflow:
   - added `enforce_release_evidence_bundle` workflow input,
   - installer matrix now runs bundle check after bundle generation,
   - uploads `desktop-release-evidence-bundle-check-*` artifacts.
5. Updated release/runbook/index docs:
   - `desktop-flutter-development-runbook.md` command inventory now includes bundle-check commands,
   - `desktop-flutter-release-validation-baseline.md` now includes bundle-check protocol, strict mode, workflow input, artifact chain, and script index reference,
   - `desktop-flutter-release-evidence-index.md` now includes bundle-check report attachment rule.
6. Re-ran validation commands:
   - `pnpm run desktop:release:evidence:bundle:check:macos`,
   - `pnpm run desktop:release:evidence:bundle:check:windows`,
   - `pnpm run desktop:release:evidence:bundle:check:macos:strict` (expected failure: simulated status),
   - strict-pass synthetic scenario using temporary all-pass bundle report,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - bundle status parsing/classification reliability,
  - strict/non-strict failure semantics and report generation,
  - smoke workflow enforcement wiring and artifact continuity.
- **Issues found during review**
  1. Bundle summaries were generated for review but lacked automated pass/fail evaluation, so risky states could remain unnoticed without manual inspection.
- **Fix applied**
  1. Added bundle-check script and integrated optional strict enforcement into smoke workflow.
- **Post-fix validation criteria**
  - Critical statuses in bundle summaries always fail checks.
  - Strict mode fails on risky statuses.
  - Bundle-check reports are generated and uploaded in smoke workflow.
  - Full-fast desktop verification remains green after bundle-check integration.

## Unit WS-D-75: Bundle strict gate-policy dependency wiring

### Planned objective

Ensure strict release evidence bundle enforcement is coherently modeled in smoke gate-policy preflight and workflow toggle propagation.

### Implemented changes

1. Extended gate-policy toggle model:
   - `desktop/scripts/check_release_smoke_gate_policy.sh` now reads `STRICT_RELEASE_EVIDENCE_BUNDLE`.
2. Added strict dependency checks:
   - `STRICT_RELEASE_EVIDENCE_BUNDLE` now requires:
     - `STRICT_SIGNING_PROVENANCE=1`,
     - `STRICT_WINDOWS_INSTALLER_PROVENANCE=1`.
3. Extended gate-policy report output:
   - release smoke gate policy report now includes effective `STRICT_RELEASE_EVIDENCE_BUNDLE` value.
4. Fixed workflow preflight env propagation:
   - `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness gate-policy step now passes `STRICT_RELEASE_EVIDENCE_BUNDLE: ${{ inputs.enforce_release_evidence_bundle }}`.
5. Updated release baseline docs:
   - `desktop-flutter-release-validation-baseline.md` now documents bundle strict dependencies inside gate-policy preflight behavior.
6. Re-ran validation commands:
   - `cd desktop && STRICT_RELEASE_EVIDENCE_BUNDLE=1 ./scripts/check_release_smoke_gate_policy.sh` (expected failure: missing strict provenance toggles),
   - `cd desktop && STRICT_RELEASE_EVIDENCE_BUNDLE=1 STRICT_SIGNING_PROVENANCE=1 STRICT_SIGNING_EXECUTION=1 STRICT_SIGNING_COMMAND_HOOKS=1 STRICT_WINDOWS_INSTALLER_PROVENANCE=1 STRICT_WINDOWS_INSTALLER_EXECUTION=1 ./scripts/check_release_smoke_gate_policy.sh`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - workflow input to gate-policy env propagation completeness,
  - dependency coherence for strict release evidence bundle mode,
  - report transparency for new strict toggle.
- **Issues found during review**
  1. `enforce_release_evidence_bundle` input existed for bundle check execution but was not propagated to gate-policy preflight, so dependency enforcement was bypassed.
- **Fix applied**
  1. Added `STRICT_RELEASE_EVIDENCE_BUNDLE` propagation and explicit provenance dependency checks in gate-policy script.
- **Post-fix validation criteria**
  - Gate-policy preflight fails when strict bundle mode is enabled without strict provenance prerequisites.
  - Gate-policy report includes strict bundle toggle value.
  - Full-fast desktop verification remains green after dependency wiring fix.

## Unit WS-D-76: External appcast command-hygiene and publication reporting hardening

### Planned objective

Reduce external publication false-readiness risk by enforcing placeholder command-hygiene in strict readiness mode and ensuring publication failure paths preserve actionable report evidence.

### Implemented changes

1. Hardened external readiness command hygiene:
   - `desktop/scripts/check_appcast_external_readiness.sh` now validates placeholder patterns for:
     - `APPCAST_EXTERNAL_IDENTITY_CHECK_COMMAND`,
     - `APPCAST_EXTERNAL_INVALIDATION_CHECK_COMMAND`,
     - `APPCAST_CACHE_INVALIDATION_COMMAND`.
2. Added strict placeholder enforcement semantics:
   - strict readiness mode now treats placeholder command hooks as required failures,
   - readiness report now includes:
     - cache invalidation command configuration/status,
     - placeholder command finding count.
3. Hardened external publication failure reporting:
   - `desktop/scripts/publish_appcast_external.sh` now captures AWS upload/invalidation command failures without losing report generation,
   - publication report now includes invalidation command configuration and execution status.
4. Updated release baseline docs:
   - `desktop-flutter-release-validation-baseline.md` now documents strict readiness placeholder command rejection behavior.
5. Re-ran validation commands:
   - strict expected-fail scenario with placeholder external commands in non-dry-run mode (with local fake AWS shim/credentials),
   - strict pass scenario with non-placeholder external commands in non-dry-run mode (with local fake AWS shim/credentials),
   - dry-run external publication report path validation,
   - non-dry-run expected-fail publication scenario with failing invalidation command while preserving publication report output,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - strict external readiness quality gates against placeholder/dummy command hooks,
  - publication-stage error capture/report durability,
  - documentation alignment with strengthened readiness/publication semantics.
- **Issues found during review**
  1. Strict external readiness previously allowed placeholder command hooks if present, which could mask unprovisioned production validation/invalidation wiring.
  2. External publication stage could terminate on command failure before explicit invalidation-status evidence was recorded in report output.
- **Fix applied**
  1. Added placeholder command detection and strict enforcement in external readiness checker.
  2. Added guarded command execution branches in external publication runner so failure context is persisted in report output.
- **Post-fix validation criteria**
  - Strict external readiness fails when placeholder command hooks are configured.
  - Strict external readiness can pass with non-placeholder hooks under non-dry-run simulation.
  - External publication report contains invalidation execution status for both success and failure paths.
  - Full-fast desktop verification remains green after hardening.

## Unit WS-D-77: External publication gate-policy provider/readiness hardening

### Planned objective

Prevent non-dry-run external publication from bypassing readiness enforcement by hardening gate-policy preflight relationships around provider configuration and strict readiness requirements.

### Implemented changes

1. Extended gate-policy provider model:
   - `desktop/scripts/check_release_smoke_gate_policy.sh` now reads normalized `APPCAST_PUBLISH_PROVIDER`.
2. Added required external publication policy checks:
   - `PUBLISH_APPCAST_EXTERNAL=1` now requires provider configuration (`APPCAST_PUBLISH_PROVIDER != none`),
   - unsupported provider values are blocked at preflight,
   - non-dry-run external publication now requires `STRICT_APPCAST_EXTERNAL_READINESS=1`.
3. Added advisory policy check:
   - warns when provider is configured while external publication stage is disabled.
4. Extended gate-policy report transparency:
   - report now includes effective `APPCAST_PUBLISH_PROVIDER` value.
5. Wired workflow env propagation:
   - `.github/workflows/release-desktop-installer-smoke.yml` gate-policy preflight step now passes `APPCAST_PUBLISH_PROVIDER: ${{ inputs.appcast_external_provider }}`.
6. Updated release baseline docs:
   - `desktop-flutter-release-validation-baseline.md` now documents provider/readiness dependency checks in gate-policy preflight.
7. Re-ran validation commands:
   - `cd desktop && PUBLISH_APPCAST_EXTERNAL=1 APPCAST_PUBLISH_PROVIDER=none ./scripts/check_release_smoke_gate_policy.sh` (expected failure),
   - `cd desktop && PUBLISH_APPCAST_EXTERNAL=1 APPCAST_PUBLISH_PROVIDER=s3 APPCAST_PUBLISH_DRY_RUN=0 ALLOW_APPCAST_EXTERNAL_PRODUCTION=1 STRICT_APPCAST_EXTERNAL_READINESS=0 ./scripts/check_release_smoke_gate_policy.sh` (expected failure),
   - `cd desktop && PUBLISH_APPCAST_EXTERNAL=1 APPCAST_PUBLISH_PROVIDER=s3 APPCAST_PUBLISH_DRY_RUN=0 ALLOW_APPCAST_EXTERNAL_PRODUCTION=1 STRICT_APPCAST_EXTERNAL_READINESS=1 ./scripts/check_release_smoke_gate_policy.sh`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - external publication provider/preflight wiring consistency,
  - non-dry-run readiness-enforcement bypass risk,
  - report observability for provider-level toggles.
- **Issues found during review**
  1. Gate policy previously allowed `publish_appcast_external=true` with provider unset (`none`), resulting in inert external publication stage despite enabled publish toggle.
  2. Gate policy previously allowed non-dry-run external publication without strict readiness enforcement, enabling readiness-check warnings to be ignored.
- **Fix applied**
  1. Added provider configuration/validity requirements for external publication.
  2. Added mandatory strict-readiness dependency for non-dry-run external publication.
- **Post-fix validation criteria**
  - Provider-missing/unsupported configurations fail in gate-policy preflight.
  - Non-dry-run external publication fails in preflight unless strict readiness is enabled.
  - Gate-policy report includes provider value for audit traceability.
  - Full-fast desktop verification remains green after policy hardening.

## Unit WS-D-78: Windows installer command-hygiene strict enforcement

### Planned objective

Reduce false-positive Windows release readiness by blocking placeholder installer/provenance command hooks in strict execution and strict provenance paths.

### Implemented changes

1. Hardened Windows installer pipeline command checks:
   - `desktop/scripts/run_windows_installer_pipeline.sh` now detects placeholder command patterns in `PENJAR_WINDOWS_INSTALLER_COMMAND`,
   - strict execution mode now fails when placeholder commands are detected,
   - non-strict mode now marks placeholder command execution as skipped simulation with explicit report diagnostics.
2. Hardened Windows installer provenance command checks:
   - `desktop/scripts/check_windows_installer_provenance.sh` now detects placeholder command patterns in `PENJAR_WINDOWS_INSTALLER_PROVENANCE_COMMAND`,
   - strict provenance mode now fails when placeholder commands are detected,
   - provenance report now records placeholder status alongside command execution status.
3. Extended report observability:
   - pipeline report now includes `Installer command placeholder status`,
   - provenance report now includes `Provenance command placeholder status`.
4. Updated release baseline docs:
   - `desktop-flutter-release-validation-baseline.md` now documents strict Windows execution/provenance placeholder-hygiene enforcement.
5. Re-ran validation commands:
   - strict expected-fail Windows installer pipeline scenario with placeholder installer command,
   - strict pass Windows installer pipeline scenario with non-placeholder installer command,
   - strict expected-fail Windows installer provenance scenario with placeholder provenance command,
   - strict pass Windows installer provenance scenario with non-placeholder provenance command,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - strict Windows installer execution/provenance placeholder command bypass risk,
  - report-level transparency for placeholder command findings,
  - compatibility with existing strict/non-strict execution semantics.
- **Issues found during review**
  1. Strict Windows installer execution previously accepted placeholder command hooks if commands returned success, allowing simulated command wiring to look production-ready.
  2. Strict Windows installer provenance previously accepted placeholder provenance command hooks under the same condition.
- **Fix applied**
  1. Added shared placeholder-pattern detection logic in Windows installer pipeline/provenance scripts and gated strict modes accordingly.
  2. Added explicit placeholder status fields in generated reports for audit traceability.
- **Post-fix validation criteria**
  - Strict Windows installer pipeline fails when installer command hooks are placeholders.
  - Strict Windows installer provenance fails when provenance command hooks are placeholders.
  - Strict pass cases remain green with non-placeholder hooks.
  - Full-fast desktop verification remains green after hardening.

## Unit WS-D-79: Signing readiness provenance hook coverage expansion

### Planned objective

Close signing readiness blind spots by enforcing presence/hygiene checks for sign-verify and Windows installer provenance command hooks before strict provenance gates are enabled.

### Implemented changes

1. Expanded signing readiness command-hook inventory:
   - `desktop/scripts/check_signing_readiness.sh` now validates additional command hooks:
     - `PENJAR_MACOS_SIGN_VERIFY_COMMAND`,
     - `PENJAR_WINDOWS_SIGN_VERIFY_COMMAND`,
     - `PENJAR_WINDOWS_INSTALLER_PROVENANCE_COMMAND`.
2. Wired workflow readiness env propagation:
   - `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness step now passes all three provenance-related command-hook secrets.
3. Updated release baseline docs:
   - `desktop-flutter-release-validation-baseline.md` now documents readiness coverage for sign-verify/provenance hooks and CI-level propagation.
4. Re-ran validation commands:
   - strict expected-fail signing readiness scenario with provenance command hooks intentionally missing,
   - strict pass signing readiness scenario with all command hooks populated by non-placeholder values,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - signing readiness command-hook completeness against strict provenance requirements,
  - workflow secret propagation alignment for readiness checks,
  - documentation traceability for new readiness criteria.
- **Issues found during review**
  1. Strict signing command-hook checks previously omitted sign-verify/provenance command hooks, allowing provenance strict-mode prerequisites to be partially unvalidated at readiness time.
- **Fix applied**
  1. Added sign-verify/provenance hooks to readiness checker and wired matching workflow env propagation.
- **Post-fix validation criteria**
  - Strict command-hook readiness fails when provenance-related hooks are missing.
  - Strict command-hook readiness passes when all hooks are present and non-placeholder.
  - Full-fast desktop verification remains green after readiness coverage expansion.

## Unit WS-D-80: Signing provenance verify-command placeholder hardening

### Planned objective

Prevent strict signing provenance validation from accepting placeholder verify commands that can return success without real signature verification.

### Implemented changes

1. Hardened signing provenance command hygiene:
   - `desktop/scripts/check_signing_artifact_provenance.sh` now detects placeholder patterns in platform verify commands:
     - `PENJAR_MACOS_SIGN_VERIFY_COMMAND`,
     - `PENJAR_WINDOWS_SIGN_VERIFY_COMMAND`.
2. Added strict failure semantics via provenance status path:
   - placeholder verify commands are now marked as failed verification and therefore fail strict provenance checks.
3. Extended provenance report transparency:
   - signing provenance report now includes `Verify command placeholder status`.
4. Updated release baseline docs:
   - `desktop-flutter-release-validation-baseline.md` now documents strict provenance placeholder-hygiene enforcement.
5. Re-ran validation commands:
   - strict expected-fail signing provenance scenario with placeholder Windows verify command,
   - strict pass signing provenance scenario with non-placeholder Windows verify command,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - strict signing provenance resilience against placeholder verify commands,
  - provenance report observability for placeholder detection,
  - compatibility with existing strict/relaxed provenance semantics.
- **Issues found during review**
  1. Strict provenance checks previously executed configured verify commands verbatim, so placeholder commands like `echo ...` could falsely satisfy strict verification.
- **Fix applied**
  1. Added verify-command placeholder detection and strict failure propagation in signing provenance script.
- **Post-fix validation criteria**
  - Strict provenance fails when verify command hooks are placeholders.
  - Strict provenance passes when verify commands are non-placeholder and executable.
  - Full-fast desktop verification remains green after provenance hardening.

## Unit WS-D-81: Signing execution placeholder command hardening

### Planned objective

Prevent strict signing execution from accepting placeholder sign/notarize command hooks that can return success without performing real signing operations.

### Implemented changes

1. Hardened signing pipeline command hygiene:
   - `desktop/scripts/run_signing_pipeline.sh` now detects placeholder patterns in:
     - `PENJAR_MACOS_SIGN_COMMAND`,
     - `PENJAR_MACOS_NOTARIZE_COMMAND`,
     - `PENJAR_WINDOWS_SIGN_COMMAND`.
2. Added strict failure semantics:
   - strict signing execution mode now fails when placeholder sign/notarize commands are detected.
3. Extended execution report transparency:
   - signing pipeline reports now include:
     - `Sign command placeholder status`,
     - `Notarize command placeholder status` (macOS).
4. Added non-strict warning behavior:
   - placeholder commands in non-strict mode now produce explicit warning outcomes rather than looking like clean execution.
5. Updated release baseline docs:
   - `desktop-flutter-release-validation-baseline.md` now documents strict signing execution placeholder-hygiene behavior.
6. Re-ran validation commands:
   - strict expected-fail Windows signing pipeline scenario with placeholder sign command,
   - strict pass Windows signing pipeline scenario with non-placeholder sign command,
   - strict expected-fail macOS signing pipeline scenario with placeholder notarize command,
   - strict pass macOS signing pipeline scenario with non-placeholder sign/notarize commands,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - strict signing execution resilience against placeholder command hooks,
  - report observability for placeholder findings,
  - non-strict warning-path fidelity.
- **Issues found during review**
  1. Strict signing execution previously treated placeholder sign/notarize command hooks as valid when they returned success.
- **Fix applied**
  1. Added sign/notarize placeholder detection logic and strict failure propagation in signing pipeline execution script.
  2. Added placeholder status fields and non-strict warning path for clearer audit signals.
- **Post-fix validation criteria**
  - Strict signing execution fails when sign/notarize hooks are placeholders.
  - Strict signing execution passes with non-placeholder command hooks.
  - Full-fast desktop verification remains green after execution hardening.

## Unit WS-D-82: Production external publication strict evidence dependency

### Planned objective

Harden production external publication governance by requiring strict release evidence bundle enforcement before allowing non-dry-run external publication paths.

### Implemented changes

1. Extended gate-policy required dependency:
   - `desktop/scripts/check_release_smoke_gate_policy.sh` now requires `STRICT_RELEASE_EVIDENCE_BUNDLE=1` whenever:
     - `PUBLISH_APPCAST_EXTERNAL=1`,
     - `APPCAST_PUBLISH_DRY_RUN=0`.
2. Updated release baseline docs:
   - `desktop-flutter-release-validation-baseline.md` now documents that non-dry-run external publication preflight requires both strict external readiness and strict release evidence bundle enforcement.
3. Re-ran validation commands:
   - `cd desktop && PUBLISH_APPCAST_EXTERNAL=1 APPCAST_PUBLISH_PROVIDER=s3 APPCAST_PUBLISH_DRY_RUN=0 ALLOW_APPCAST_EXTERNAL_PRODUCTION=1 STRICT_APPCAST_EXTERNAL_READINESS=1 ./scripts/check_release_smoke_gate_policy.sh` (expected failure),
   - `cd desktop && PUBLISH_APPCAST_EXTERNAL=1 APPCAST_PUBLISH_PROVIDER=s3 APPCAST_PUBLISH_DRY_RUN=0 ALLOW_APPCAST_EXTERNAL_PRODUCTION=1 STRICT_APPCAST_EXTERNAL_READINESS=1 STRICT_RELEASE_EVIDENCE_BUNDLE=1 STRICT_SIGNING_PROVENANCE=1 STRICT_SIGNING_EXECUTION=1 STRICT_SIGNING_COMMAND_HOOKS=1 STRICT_WINDOWS_INSTALLER_PROVENANCE=1 STRICT_WINDOWS_INSTALLER_EXECUTION=1 ./scripts/check_release_smoke_gate_policy.sh`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - production external publication dependency completeness,
  - coherence with existing strict evidence/provenance dependency chain,
  - documentation traceability for new gating rule.
- **Issues found during review**
  1. Non-dry-run external publication could previously pass preflight without strict release evidence bundle enforcement, leaving residual risk of warning/simulated evidence statuses.
- **Fix applied**
  1. Added mandatory strict release evidence bundle dependency for non-dry-run external publication in gate-policy preflight.
- **Post-fix validation criteria**
  - Non-dry-run external publication preflight fails without strict release evidence bundle enforcement.
  - Preflight passes when strict release evidence bundle and its transitive dependencies are satisfied.
  - Full-fast desktop verification remains green after dependency hardening.

## Unit WS-D-83: Windows provenance-packaging gate-policy dependency

### Planned objective

Ensure strict Windows installer provenance enforcement always runs on top of strict packaging validation rather than as an isolated toggle.

### Implemented changes

1. Extended Windows strict dependency model:
   - `desktop/scripts/check_release_smoke_gate_policy.sh` now requires `STRICT_WINDOWS_INSTALLER_PACKAGING=1` when `STRICT_WINDOWS_INSTALLER_PROVENANCE=1`.
2. Updated release baseline docs:
   - `desktop-flutter-release-validation-baseline.md` now documents the provenance-to-packaging dependency in gate-policy preflight behavior.
3. Re-ran validation commands:
   - `cd desktop && STRICT_WINDOWS_INSTALLER_PROVENANCE=1 STRICT_WINDOWS_INSTALLER_EXECUTION=1 ./scripts/check_release_smoke_gate_policy.sh` (expected failure),
   - `cd desktop && STRICT_WINDOWS_INSTALLER_PROVENANCE=1 STRICT_WINDOWS_INSTALLER_EXECUTION=1 STRICT_WINDOWS_INSTALLER_PACKAGING=1 ./scripts/check_release_smoke_gate_policy.sh`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - coherence between strict Windows provenance and packaging gates,
  - risk of provenance checks running without installer artifact policy enforcement,
  - documentation traceability for updated dependency graph.
- **Issues found during review**
  1. Strict Windows installer provenance could previously be enabled without strict packaging validation, weakening the artifact policy baseline under provenance mode.
- **Fix applied**
  1. Added explicit gate-policy dependency requiring strict packaging when strict provenance is enabled.
- **Post-fix validation criteria**
  - Gate-policy preflight fails when strict Windows provenance is enabled without strict packaging.
  - Gate-policy preflight passes when strict provenance, execution, and packaging toggles are coherently enabled.
  - Full-fast desktop verification remains green after dependency hardening.

## Unit WS-D-84: Signing execution placeholder-hygiene gate dependency

### Planned objective

Ensure strict signing execution cannot be enabled without strict placeholder-hygiene enforcement in gate-policy preflight.

### Implemented changes

1. Extended signing strict dependency model:
   - `desktop/scripts/check_release_smoke_gate_policy.sh` now requires `STRICT_SIGNING_PLACEHOLDERS=1` whenever `STRICT_SIGNING_EXECUTION=1`.
2. Updated release baseline docs:
   - `desktop-flutter-release-validation-baseline.md` now documents that `enforce_signing_execution=true` requires `enforce_signing_placeholder_hygiene=true` in gate-policy preflight.
3. Re-ran validation commands:
   - `cd desktop && STRICT_SIGNING_EXECUTION=1 STRICT_SIGNING_COMMAND_HOOKS=1 ./scripts/check_release_smoke_gate_policy.sh` (expected failure),
   - `cd desktop && STRICT_SIGNING_EXECUTION=1 STRICT_SIGNING_COMMAND_HOOKS=1 STRICT_SIGNING_PLACEHOLDERS=1 ./scripts/check_release_smoke_gate_policy.sh`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - signing execution and placeholder-hygiene gate dependency coherence,
  - preflight-level prevention of weak strict-execution configurations,
  - documentation traceability for new dependency.
- **Issues found during review**
  1. Strict signing execution could previously be enabled while placeholder hygiene remained disabled, permitting placeholder required values to survive preflight.
- **Fix applied**
  1. Added explicit gate-policy dependency requiring strict placeholder hygiene for strict signing execution.
- **Post-fix validation criteria**
  - Gate-policy preflight fails when strict signing execution is enabled without strict placeholder hygiene.
  - Gate-policy preflight passes when strict signing execution, command-hook enforcement, and placeholder hygiene are coherently enabled.
  - Full-fast desktop verification remains green after dependency hardening.

## Unit WS-D-85: Windows naming gate-policy integration and dependency hardening

### Planned objective

Close gate-policy coverage gaps for Windows installer naming enforcement and ensure strict provenance mode always includes strict naming constraints.

### Implemented changes

1. Extended gate-policy toggle model:
   - `desktop/scripts/check_release_smoke_gate_policy.sh` now reads `STRICT_WINDOWS_INSTALLER_NAMING`.
2. Added strict naming dependency checks:
   - `STRICT_WINDOWS_INSTALLER_NAMING=1` now requires:
     - `STRICT_WINDOWS_INSTALLER_EXECUTION=1`,
     - `STRICT_WINDOWS_INSTALLER_PACKAGING=1`.
3. Added strict provenance-to-naming dependency:
   - `STRICT_WINDOWS_INSTALLER_PROVENANCE=1` now requires `STRICT_WINDOWS_INSTALLER_NAMING=1`.
4. Extended gate-policy report transparency:
   - report now includes effective `STRICT_WINDOWS_INSTALLER_NAMING` value.
5. Wired workflow preflight env propagation:
   - `.github/workflows/release-desktop-installer-smoke.yml` gate-policy preflight now passes `STRICT_WINDOWS_INSTALLER_NAMING: ${{ inputs.enforce_windows_installer_naming }}`.
6. Updated release baseline docs:
   - `desktop-flutter-release-validation-baseline.md` now documents strict Windows naming dependency graph and provenance-to-naming requirement in gate-policy preflight.
7. Re-ran validation commands:
   - `cd desktop && STRICT_WINDOWS_INSTALLER_NAMING=1 STRICT_WINDOWS_INSTALLER_EXECUTION=1 ./scripts/check_release_smoke_gate_policy.sh` (expected failure),
   - `cd desktop && STRICT_WINDOWS_INSTALLER_PROVENANCE=1 STRICT_WINDOWS_INSTALLER_EXECUTION=1 STRICT_WINDOWS_INSTALLER_PACKAGING=1 ./scripts/check_release_smoke_gate_policy.sh` (expected failure),
   - `cd desktop && STRICT_WINDOWS_INSTALLER_PROVENANCE=1 STRICT_WINDOWS_INSTALLER_EXECUTION=1 STRICT_WINDOWS_INSTALLER_PACKAGING=1 STRICT_WINDOWS_INSTALLER_NAMING=1 ./scripts/check_release_smoke_gate_policy.sh`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - gate-policy coverage completeness for Windows naming toggle,
  - strict provenance dependency coherence with naming/packaging constraints,
  - workflow/env propagation alignment and report observability.
- **Issues found during review**
  1. `enforce_windows_installer_naming` existed at workflow level but was not modeled in gate-policy preflight, creating a policy visibility gap.
  2. Strict Windows provenance mode could previously bypass strict naming enforcement in gate-policy preflight.
- **Fix applied**
  1. Added naming toggle parsing/reporting + dependency checks in gate-policy script.
  2. Added workflow env propagation for naming toggle and provenance-to-naming dependency enforcement.
- **Post-fix validation criteria**
  - Gate-policy preflight fails when strict naming is enabled without strict packaging.
  - Gate-policy preflight fails when strict provenance is enabled without strict naming.
  - Gate-policy preflight passes when strict execution/packaging/naming/provenance dependencies are coherently enabled.
  - Full-fast desktop verification remains green after policy hardening.

## Unit WS-D-86: Signing readiness dependency integration in gate-policy preflight

### Planned objective

Ensure strict signing execution/provenance gates cannot be enabled without strict signing-readiness enforcement in preflight policy checks.

### Implemented changes

1. Extended gate-policy toggle model:
   - `desktop/scripts/check_release_smoke_gate_policy.sh` now reads `STRICT_SIGNING` (mapped from workflow `enforce_signing_readiness`).
2. Added signing readiness dependency checks:
   - `STRICT_SIGNING_EXECUTION=1` now requires `STRICT_SIGNING=1`.
   - `STRICT_SIGNING_PROVENANCE=1` now requires `STRICT_SIGNING=1`.
3. Extended gate-policy report transparency:
   - report now includes effective `STRICT_SIGNING` value.
4. Wired workflow preflight env propagation:
   - `.github/workflows/release-desktop-installer-smoke.yml` gate-policy preflight now passes `STRICT_SIGNING: ${{ inputs.enforce_signing_readiness }}`.
5. Updated release baseline docs:
   - `desktop-flutter-release-validation-baseline.md` now documents readiness dependency for strict signing execution/provenance.
6. Re-ran validation commands:
   - `cd desktop && STRICT_SIGNING_EXECUTION=1 STRICT_SIGNING_COMMAND_HOOKS=1 STRICT_SIGNING_PLACEHOLDERS=1 ./scripts/check_release_smoke_gate_policy.sh` (expected failure),
   - `cd desktop && STRICT_SIGNING_PROVENANCE=1 STRICT_SIGNING_EXECUTION=1 STRICT_SIGNING_COMMAND_HOOKS=1 STRICT_SIGNING_PLACEHOLDERS=1 ./scripts/check_release_smoke_gate_policy.sh` (expected failure),
   - `cd desktop && STRICT_SIGNING=1 STRICT_SIGNING_PROVENANCE=1 STRICT_SIGNING_EXECUTION=1 STRICT_SIGNING_COMMAND_HOOKS=1 STRICT_SIGNING_PLACEHOLDERS=1 ./scripts/check_release_smoke_gate_policy.sh`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - strict signing gate dependency coherence with readiness gate,
  - workflow/env propagation completeness for readiness toggle,
  - policy report observability for readiness state.
- **Issues found during review**
  1. Strict signing execution/provenance could previously be enabled in gate-policy preflight while strict signing readiness remained disabled, weakening prerequisite enforcement visibility.
- **Fix applied**
  1. Added strict readiness dependency checks for strict signing execution/provenance.
  2. Added readiness toggle propagation and report visibility in gate-policy preflight.
- **Post-fix validation criteria**
  - Gate-policy preflight fails when strict signing execution/provenance are enabled without strict signing readiness.
  - Gate-policy preflight passes when strict signing readiness/execution/provenance dependencies are coherently enabled.
  - Full-fast desktop verification remains green after dependency hardening.

## Unit WS-D-87: Shared placeholder-hygiene helper refactor

### Planned objective

Reduce duplicated placeholder command-detection logic across release/signing/windows/appcast scripts to improve policy consistency and lower maintenance risk.

### Implemented changes

1. Added shared helper module:
   - new `desktop/scripts/lib/placeholder_hygiene.sh` with `is_placeholder_command` implementation.
2. Refactored appcast readiness script:
   - `desktop/scripts/check_appcast_external_readiness.sh` now sources shared helper instead of local duplicate logic.
3. Refactored signing scripts:
   - `desktop/scripts/run_signing_pipeline.sh` now sources shared helper.
   - `desktop/scripts/check_signing_artifact_provenance.sh` now sources shared helper.
4. Refactored Windows installer scripts:
   - `desktop/scripts/run_windows_installer_pipeline.sh` now sources shared helper.
   - `desktop/scripts/check_windows_installer_provenance.sh` now sources shared helper.
5. Updated release baseline docs:
   - `desktop-flutter-release-validation-baseline.md` script index now includes shared helper path.
6. Re-ran validation commands:
   - `bash -n` syntax checks for all refactored scripts and helper,
   - strict expected-fail + strict pass checks for:
     - external readiness placeholder command path,
     - signing execution placeholder command path,
     - signing provenance placeholder verify-command path,
     - Windows installer pipeline/provenance placeholder command paths,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - placeholder-hygiene logic drift across scripts,
  - refactor safety around sourced helper path resolution,
  - behavior parity for strict fail/pass scenarios after deduplication.
- **Issues found during review**
  1. Placeholder command detection logic was duplicated across multiple scripts, creating drift risk for future rule changes.
- **Fix applied**
  1. Centralized placeholder command detection into shared helper and migrated all relevant scripts to source it via script-relative paths.
- **Post-fix validation criteria**
  - Refactored scripts preserve existing strict fail/pass behavior for placeholder detection.
  - Syntax checks pass for helper and all migrated scripts.
  - Full-fast desktop verification remains green after helper refactor.

## Unit WS-D-88: Release smoke gate-policy contract automation baseline

### Planned objective

Protect increasingly complex gate-policy dependency rules from silent regressions by adding an executable contract check with expected fail/pass profiles and wiring it into canonical verify + CI artifact chains.

### Implemented changes

1. Added gate-policy contract checker:
   - new `desktop/scripts/check_release_smoke_gate_policy_contract.sh`,
   - executes deterministic expected fail/pass profiles against `check_release_smoke_gate_policy.sh`,
   - emits `release/reports/release_smoke_gate_policy_contract_report.md`.
2. Integrated into canonical verify chain:
   - `desktop/scripts/verify_desktop.sh` now runs `release smoke gate policy contract check` stage before test/analyze/build phases.
3. Added root command surface:
   - `desktop:release:smoke:gate-policy:contract:check`.
4. Extended CI/workflow artifact chain:
   - `.github/workflows/tests-desktop-flutter.yml` verify matrix now uploads `desktop-release-smoke-gate-policy-contract-report-*` artifacts.
   - `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job now runs gate-policy contract checker and uploads `desktop-release-smoke-gate-policy-contract-report`.
5. Updated continuity docs:
   - `desktop-flutter-development-runbook.md` command inventory now includes gate-policy contract command.
   - `desktop-flutter-release-validation-baseline.md` protocol/CI/script-index notes now include contract checker stage + artifacts.
   - `desktop-flutter-release-evidence-index.md` now includes gate-policy contract report attachment requirement.
6. Re-ran validation commands:
   - syntax checks (`bash -n`) for contract checker + helper + refactored scripts,
   - expected fail/pass scenarios for appcast/signing/windows placeholder-hygiene paths after helper sourcing refactor,
   - re-ran contract checker after baseline-case execution-path correction to confirm non-noop baseline behavior,
   - `pnpm run desktop:release:smoke:gate-policy:contract:check`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - gate-policy dependency regression detectability,
  - verify-chain and CI artifact integration completeness for contract report,
  - continuity document linkage across runbook/baseline/evidence index/execution log.
- **Issues found during review**
  1. Gate-policy dependency complexity had grown significantly, but no deterministic contract automation existed to detect accidental rule regressions.
  2. Initial contract-checker baseline case passed a `true` token into `env`, which could bypass actual gate-policy checker execution and produce false-green baseline status.
- **Fix applied**
  1. Added contract checker with explicit expected fail/pass policy profiles and integrated it into canonical verify + CI artifact paths.
  2. Corrected baseline-case execution path in `check_release_smoke_gate_policy_contract.sh` to run `check_release_smoke_gate_policy.sh` directly when no env overrides are supplied.
- **Post-fix validation criteria**
  - Contract checker fails on dependency regressions and passes on coherent strict profile.
  - Baseline-default contract case executes the real gate-policy checker path (no no-op command substitution).
  - Verify chain includes contract checker stage and remains green.
  - CI/workflow artifact chain retains gate-policy contract report outputs.

## Unit WS-D-89: Recursive release-script syntax coverage hardening

### Planned objective

Ensure release-script syntax gating covers shared helper modules under nested script directories so syntax regressions in helper layers cannot bypass preflight checks.

### Implemented changes

1. Hardened release-script syntax scanner scope:
   - updated `desktop/scripts/check_release_script_syntax.sh` to scan `desktop/scripts/**/*.sh` recursively instead of top-level-only scanning.
   - report metadata now includes `Scan mode: recursive` to make scope explicit in generated artifacts.
2. Updated continuity documentation:
   - `desktop-flutter-release-validation-baseline.md` script index now documents recursive syntax coverage and explicit inclusion of `desktop/scripts/lib/`.
3. Re-ran validation commands:
   - `cd desktop && ./scripts/check_release_script_syntax.sh`,
   - `cd desktop && rg -n "scripts/lib/placeholder_hygiene.sh|Scan mode: recursive" release/reports/release_script_syntax_report.md`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - syntax-gate coverage boundaries for nested helper scripts,
  - report traceability of scanner scope for audit/debug use,
  - downstream verify-chain compatibility after scanner scope expansion.
- **Issues found during review**
  1. Existing syntax scanner used `find ... -maxdepth 1`, so nested helper scripts (for example `scripts/lib/placeholder_hygiene.sh`) were excluded from syntax preflight coverage.
- **Fix applied**
  1. Switched syntax scanner to recursive shell-script discovery and added explicit recursive-scan metadata in generated report.
- **Post-fix validation criteria**
  - Generated syntax report includes recursive scan marker and helper-script path entries.
  - Release evidence guard remains green after syntax-gate scope expansion.
  - Full-fast desktop verification remains green with recursive syntax scanning enabled.

## Unit WS-D-90: Release-script syntax contract gate integration

### Planned objective

Add an executable contract suite for release-script syntax checking so recursive-scan guarantees (including nested failure detection) are regression-tested in verify and CI artifact chains.

### Implemented changes

1. Added release-script syntax contract checker:
   - new `desktop/scripts/check_release_script_syntax_contract.sh`,
   - executes deterministic cases for:
     - recursive valid nested script pass,
     - recursive nested syntax-failure detection,
     - empty-directory pass behavior,
   - emits `release/reports/release_script_syntax_contract_report.md`.
2. Integrated into canonical verify chain:
   - `desktop/scripts/verify_desktop.sh` now runs `release script syntax contract check` immediately after base syntax check.
3. Added root command surface:
   - `desktop:release:scripts:syntax:contract:check`.
4. Extended CI/workflow artifact chain:
   - `.github/workflows/tests-desktop-flutter.yml` verify matrix now uploads `desktop-release-script-syntax-contract-report-*` artifacts.
   - `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job now runs release-script syntax contract checker and uploads `desktop-release-script-syntax-contract-report-smoke`.
5. Updated continuity docs:
   - `desktop-flutter-development-runbook.md` command inventory now includes script-syntax contract command.
   - `desktop-flutter-release-validation-baseline.md` operating protocol/CI/script-index notes now include syntax-contract gate stage + artifacts.
   - `desktop-flutter-release-evidence-index.md` now includes syntax-contract report attachment requirement.
6. Re-ran validation commands:
   - syntax checks (`bash -n`) for updated/new scripts,
   - `pnpm run desktop:release:scripts:syntax:contract:check`,
   - `cd desktop && rg -n "recursive-valid-nested-pass|recursive-invalid-nested-fail|empty-directory-pass|Status: passed" release/reports/release_script_syntax_contract_report.md`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - deterministic regression detection for recursive syntax-scan behavior,
  - verify/CI artifact continuity for new contract report,
  - release-doc linkage coverage for new command/report requirement.
- **Issues found during review**
  1. Recursive syntax scanning was enabled, but no contract-level regression suite existed to assert nested pass/fail semantics and empty-directory behavior.
- **Fix applied**
  1. Added release-script syntax contract checker and integrated it into verify + CI artifact + documentation chains.
- **Post-fix validation criteria**
  - Contract report includes all expected case rows with passing status.
  - Verify chain executes syntax-contract stage and remains green.
  - CI/workflow documentation and evidence requirements include syntax-contract report path.

## Unit WS-D-91: Release evidence attachment-reference guard hardening

### Planned objective

Prevent silent documentation regressions where required verification report attachment requirements are removed from release evidence index while table schema checks still pass.

### Implemented changes

1. Hardened release evidence index checker:
   - `desktop/scripts/check_release_evidence_index.sh` now validates presence of required attachment references for core verification reports:
     - `release_script_syntax_report.md`,
     - `release_script_syntax_contract_report.md`,
     - `verify_test_coverage_report.md`,
     - `desktop_command_inventory_report.md`,
     - `update_manifest_validation_report.md`,
     - `verify_stage_timing_report.md`,
     - `release_evidence_bundle_check_macos.md`,
     - `release_evidence_bundle_check_windows.md`,
     - `release_smoke_gate_policy_contract_report.md`.
2. Updated continuity baseline:
   - `desktop-flutter-release-validation-baseline.md` now documents that release evidence checker enforces required attachment references in addition to schema/uniqueness/decision rules.
3. Re-ran validation commands:
   - `bash -n desktop/scripts/check_release_evidence_index.sh`,
   - `pnpm run desktop:release:evidence:check`,
   - negative-case validation using temporary index file with removed `release_script_syntax_contract_report.md` reference (expected failure confirmed),
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - release evidence checker coverage for checklist-level attachment requirements,
  - false-green risk when checklist references drift from required artifact set,
  - compatibility with existing index validation and verify chain.
- **Issues found during review**
  1. Existing checker validated table rows only; required attachment checklist references could be removed without failing guard checks.
- **Fix applied**
  1. Added required attachment-reference validation list to release evidence checker and verified expected fail behavior when a required reference is missing.
- **Post-fix validation criteria**
  - Baseline evidence index passes with all required attachment references present.
  - Guard fails deterministically when a required attachment reference is removed.
  - Full-fast desktop verification remains green after checker hardening.

## Unit WS-D-92: Release evidence index contract gate integration

### Planned objective

Add executable contract tests for release evidence index guard behavior (baseline pass + representative fail modes) and wire the contract report into verify, CI artifacts, and evidence requirements.

### Implemented changes

1. Added release evidence index contract checker:
   - new `desktop/scripts/check_release_evidence_index_contract.sh`,
   - runs deterministic cases for:
     - baseline current index pass,
     - missing required attachment reference fail,
     - duplicate RC+platform key fail,
   - emits `release/reports/release_evidence_index_contract_report.md`.
2. Integrated into canonical verify chain:
   - `desktop/scripts/verify_desktop.sh` now runs `release evidence index contract check` after release smoke gate-policy contract check.
3. Added root command surface:
   - `desktop:release:evidence:contract:check`.
4. Extended CI/workflow artifact chain:
   - `.github/workflows/tests-desktop-flutter.yml` verify matrix now uploads `desktop-release-evidence-index-contract-report-*` artifacts.
   - `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job now runs release evidence index contract checker and uploads `desktop-release-evidence-index-contract-report-smoke`.
5. Hardened evidence requirements alignment:
   - `check_release_evidence_index.sh` required attachment list now also enforces `release/reports/release_evidence_index_contract_report.md`.
   - `desktop-flutter-release-evidence-index.md` now requires:
     - pre-promotion `desktop:release:evidence:contract:check` execution,
     - contract report attachment (`release/reports/release_evidence_index_contract_report.md`).
6. Updated continuity docs:
   - `desktop-flutter-development-runbook.md` command inventory includes evidence-index contract command.
   - `desktop-flutter-release-validation-baseline.md` operating protocol/CI/script-index notes include evidence-index contract gate + artifacts.
7. Re-ran validation commands:
   - syntax checks (`bash -n`) for updated/new scripts,
   - `pnpm run desktop:release:evidence:contract:check`,
   - `cd desktop && rg -n "baseline-current-index-pass|missing-required-attachment-fail|duplicate-rc-platform-fail|Status: passed" release/reports/release_evidence_index_contract_report.md`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - deterministic contract coverage for evidence-index checker behavior,
  - verify/CI artifact continuity for evidence-index contract reports,
  - synchronization between evidence-check guard rules and evidence-index documentation requirements.
- **Issues found during review**
  1. Evidence-index checker hardening existed, but no contract-level regression suite ensured ongoing enforcement of fail modes (missing attachment / duplicate key).
  2. New contract report path was not yet enforced as required attachment in the evidence-index guard.
  3. Initial contract-script implementation used `sed -i ''` for in-place edits, which is BSD-specific and non-portable to Linux CI runners.
- **Fix applied**
  1. Added evidence-index contract checker with baseline/fail-profile cases and integrated it into verify + CI artifact chains.
  2. Added evidence-index contract report path to required attachment references and documentation requirements.
  3. Replaced in-place edit logic with portable `awk` + `mv` rewrite flow for cross-platform runner compatibility.
- **Post-fix validation criteria**
  - Contract report includes baseline + fail-mode case rows with passing contract status.
  - Evidence-index guard enforces contract-report attachment requirement.
  - Contract checker remains portable across macOS/Linux shell environments used by local + CI flows.
  - Full-fast desktop verification remains green with evidence-index contract stage enabled.

## Unit WS-D-93: Desktop command inventory contract gate integration

### Planned objective

Add executable contract tests for desktop command inventory checks so command-surface drift in package/docs relationships is caught by deterministic pass/fail profiles and surfaced through verify/CI evidence artifacts.

### Implemented changes

1. Added desktop command inventory contract checker:
   - new `desktop/scripts/check_desktop_command_inventory_contract.sh`,
   - runs deterministic cases for:
     - baseline docs/scripts pass,
     - missing package script mapping fail,
     - docs without `pnpm run` commands fail,
   - emits `release/reports/desktop_command_inventory_contract_report.md`.
2. Integrated into canonical verify chain:
   - `desktop/scripts/verify_desktop.sh` now runs `desktop command inventory contract check` after base command inventory check.
3. Added root command surface:
   - `desktop:docs:command-inventory:contract:check`.
4. Extended CI/workflow artifact chain:
   - `.github/workflows/tests-desktop-flutter.yml` verify matrix now uploads `desktop-command-inventory-contract-report-*` artifacts.
   - `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job now runs command-inventory contract checker and uploads `desktop-command-inventory-contract-report-smoke`.
5. Hardened evidence requirements alignment:
   - `check_release_evidence_index.sh` required attachment list now enforces `release/reports/desktop_command_inventory_contract_report.md`.
   - `desktop-flutter-release-evidence-index.md` now requires command-inventory contract report attachment.
6. Updated continuity docs:
   - `desktop-flutter-development-runbook.md` command inventory includes contract-check command.
   - `desktop-flutter-release-validation-baseline.md` operating protocol/CI/script-index notes now include command-inventory contract stage + artifacts.
7. Re-ran validation commands:
   - syntax checks (`bash -n`) for updated/new scripts,
   - `pnpm run desktop:docs:command-inventory:contract:check`,
   - `cd desktop && rg -n "baseline-current-docs-pass|missing-script-fail|no-command-docs-fail|Status: passed" release/reports/desktop_command_inventory_contract_report.md`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - deterministic guard-regression detection for command inventory behavior,
  - verify/CI artifact continuity for command-inventory contract reports,
  - synchronization between evidence requirements and newly added contract report path.
- **Issues found during review**
  1. Existing command inventory checker lacked contract-level fail-profile automation, increasing regression risk for package/docs command-surface drift.
  2. New contract report path was not yet enforced in release evidence required attachment checks.
  3. Initial contract-script revision assumed `python3` directly, which could fail in environments that expose only `python`.
- **Fix applied**
  1. Added command inventory contract checker and integrated it into verify + CI artifact flows.
  2. Added command-inventory contract report path to evidence-index requirements and guard enforcement list.
  3. Added runtime fallback logic (`python3` -> `python`) for portable contract-script execution.
- **Post-fix validation criteria**
  - Contract report contains expected baseline/fail-mode case rows with passing contract status.
  - Verify chain executes command-inventory contract stage and remains green.
  - Contract checker remains portable across environments with either `python3` or `python`.
  - Evidence-index guard enforces command-inventory contract report attachment requirement.

## Unit WS-D-94: Update manifest contract gate integration

### Planned objective

Add executable contract tests for update-manifest validation logic so baseline/fail profiles are regression-checked and linked into verify, CI artifacts, and evidence requirements.

### Implemented changes

1. Added update manifest contract checker:
   - new `desktop/scripts/check_update_manifest_contract.sh`,
   - runs deterministic cases for:
     - baseline manifest pass,
     - invalid JSON fail,
     - missing required field fail,
     - insecure artifact URL fail,
     - identical platform artifact URL fail,
   - emits `release/reports/update_manifest_contract_report.md`.
2. Integrated into canonical verify chain:
   - `desktop/scripts/verify_desktop.sh` now runs `update manifest contract check` after base update-manifest check.
3. Added root command surface:
   - `desktop:release:update-manifest:contract:check`.
4. Extended CI/workflow artifact chain:
   - `.github/workflows/tests-desktop-flutter.yml` verify matrix now uploads `desktop-update-manifest-contract-report-*` artifacts.
   - `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job now runs update-manifest contract checker and uploads `desktop-update-manifest-contract-report-smoke`.
5. Hardened evidence requirements alignment:
   - `check_release_evidence_index.sh` required attachment list now enforces `release/reports/update_manifest_contract_report.md`.
   - `desktop-flutter-release-evidence-index.md` now requires:
     - pre-promotion `desktop:release:update-manifest:contract:check` execution,
     - contract report attachment (`release/reports/update_manifest_contract_report.md`).
6. Updated continuity docs:
   - `desktop-flutter-development-runbook.md` command inventory now includes update-manifest contract command.
   - `desktop-flutter-release-validation-baseline.md` operating protocol/CI/script-index notes now include update-manifest contract gate + artifacts.
7. Re-ran validation commands:
   - syntax checks (`bash -n`) for updated/new scripts,
   - `pnpm run desktop:release:update-manifest:contract:check`,
   - `cd desktop && rg -n "baseline-example-pass|invalid-json-fail|missing-required-field-fail|insecure-artifact-url-fail|identical-platform-urls-fail|Status: passed" release/reports/update_manifest_contract_report.md`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - deterministic regression coverage for update-manifest validation behavior,
  - verify/CI artifact continuity for update-manifest contract reports,
  - synchronization between evidence requirements and update-manifest contract report path.
- **Issues found during review**
  1. Existing update-manifest checker lacked contract-level fail-profile automation for JSON/required-field/url-rule regressions.
  2. Update-manifest contract report path was not yet enforced in release evidence required attachment checks.
- **Fix applied**
  1. Added update-manifest contract checker and integrated it into verify + CI artifact chains.
  2. Added update-manifest contract report path to evidence requirements and guard enforcement list.
- **Post-fix validation criteria**
  - Contract report contains all expected pass/fail case rows with passing contract status.
  - Verify chain executes update-manifest contract stage and remains green.
  - Evidence-index guard enforces update-manifest contract report attachment requirement.

## Unit WS-D-95: Verify test coverage contract gate integration

### Planned objective

Add executable contract tests for verify-test-coverage guard behavior so coverage-regression fail modes are enforced via deterministic case profiles and linked into verify, CI artifacts, and evidence requirements.

### Implemented changes

1. Added verify test coverage contract checker:
   - new `desktop/scripts/check_verify_test_coverage_contract.sh`,
   - runs deterministic workspace-scoped cases for:
     - baseline pass,
     - uncovered test fail,
     - missing referenced test fail,
     - unexpected duplicate reference fail,
     - allowed duplicate reference pass,
   - emits `release/reports/verify_test_coverage_contract_report.md`.
2. Integrated into canonical verify chain:
   - `desktop/scripts/verify_desktop.sh` now runs `verify test coverage contract check` immediately after base coverage check.
3. Added root command surface:
   - `desktop:test:coverage:contract:check`.
4. Extended CI/workflow artifact chain:
   - `.github/workflows/tests-desktop-flutter.yml` verify matrix now uploads `desktop-verify-test-coverage-contract-report-*` artifacts.
   - `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job now runs verify-test-coverage contract checker and uploads `desktop-verify-test-coverage-contract-report-smoke`.
5. Hardened evidence requirements alignment:
   - `check_release_evidence_index.sh` required attachment list now enforces `release/reports/verify_test_coverage_contract_report.md`.
   - `desktop-flutter-release-evidence-index.md` now requires verify-test-coverage contract report attachment.
6. Updated continuity docs:
   - `desktop-flutter-development-runbook.md` command inventory includes coverage-contract command.
   - `desktop-flutter-release-validation-baseline.md` operating protocol/CI/script-index notes include verify-test-coverage contract stage + artifacts.
7. Re-ran validation commands:
   - syntax checks (`bash -n`) for updated/new scripts,
   - `pnpm run desktop:test:coverage:contract:check`,
   - `cd desktop && rg -n "baseline-pass|uncovered-test-fail|missing-referenced-test-fail|unexpected-duplicate-fail|allowed-duplicate-pass|Status: passed" release/reports/verify_test_coverage_contract_report.md`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - deterministic regression coverage for verify-test-coverage fail/pass modes,
  - verify/CI artifact continuity for coverage-contract reports,
  - synchronization between evidence requirements and coverage-contract report path.
- **Issues found during review**
  1. Existing coverage checker lacked contract-level regression automation for uncovered/missing/duplicate edge cases.
  2. Coverage contract report path was not yet enforced in release evidence required attachment checks.
- **Fix applied**
  1. Added verify-test-coverage contract checker and integrated it into verify + CI artifact chains.
  2. Added coverage-contract report path to evidence requirements and guard enforcement list.
- **Post-fix validation criteria**
  - Contract report includes expected baseline/fail-mode case rows with passing contract status.
  - Verify chain executes coverage-contract stage and remains green.
  - Evidence-index guard enforces verify-test-coverage contract report attachment requirement.

## Unit WS-D-96: Tests workflow update-manifest contract guard extension

### Planned objective

Ensure the dedicated `release-update-manifest-guard` CI job enforces contract-level update-manifest validation (not only base validation) and preserves artifact traceability for both report types.

### Implemented changes

1. Extended dedicated update-manifest guard workflow job:
   - `.github/workflows/tests-desktop-flutter.yml` `release-update-manifest-guard` now runs:
     - `./scripts/check_update_manifest.sh`,
     - `./scripts/check_update_manifest_contract.sh`.
2. Extended artifact traceability in the same job:
   - uploads existing `desktop-update-manifest-validation-report`,
   - additionally uploads `desktop-update-manifest-contract-report` (`release/reports/update_manifest_contract_report.md`).
3. Updated continuity baseline:
   - `desktop-flutter-release-validation-baseline.md` CI note now explicitly documents contract-check execution and artifact upload in `release-update-manifest-guard`.
4. Re-ran validation commands:
   - `pnpm run desktop:release:update-manifest:check`,
   - `pnpm run desktop:release:update-manifest:contract:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - consistency between dedicated update-manifest CI guard job and canonical verify contract enforcement,
  - artifact traceability completeness for update-manifest validation domain.
- **Issues found during review**
  1. The dedicated `release-update-manifest-guard` job enforced only base validation and did not execute/upload contract validation output.
- **Fix applied**
  1. Added update-manifest contract execution and contract report artifact upload to dedicated guard job.
- **Post-fix validation criteria**
  - Dedicated update-manifest guard job definition includes both base + contract validation stages.
  - Both validation and contract report artifacts are retained for audit traceability.
  - Full-fast desktop verification remains green after workflow extension.

## Unit WS-D-97: Tests workflow release-evidence contract guard extension

### Planned objective

Ensure the dedicated `release-evidence-guard` CI job enforces contract-level release-evidence checks and preserves contract report artifact traceability for audit workflows.

### Implemented changes

1. Extended dedicated release-evidence guard workflow job:
   - `.github/workflows/tests-desktop-flutter.yml` `release-evidence-guard` now runs:
     - `./scripts/check_release_evidence_index.sh`,
     - `./scripts/check_release_evidence_index_contract.sh`.
2. Added dedicated contract artifact upload:
   - same job now uploads `desktop-release-evidence-index-contract-report-guard` (`release/reports/release_evidence_index_contract_report.md`).
3. Updated continuity baseline:
   - `desktop-flutter-release-validation-baseline.md` CI notes now explicitly document release-evidence guard contract execution and artifact upload.
4. Re-ran validation commands:
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:release:evidence:contract:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - consistency between dedicated release-evidence CI guard job and canonical verify contract enforcement,
  - dedicated evidence-guard contract artifact retention for traceability.
- **Issues found during review**
  1. The dedicated `release-evidence-guard` job enforced only base evidence checks and lacked contract-level execution/artifact retention.
- **Fix applied**
  1. Added release-evidence contract check execution and dedicated contract report artifact upload to `release-evidence-guard`.
- **Post-fix validation criteria**
  - Dedicated release-evidence guard job includes both base + contract validation stages.
  - Contract report artifact is retained by dedicated guard job.
  - Full-fast desktop verification remains green after workflow extension.

## Unit WS-D-98: Release-evidence checker duplicate-key path performance hardening

### Planned objective

Reduce unnecessary file I/O in release evidence checker duplicate-key validation while preserving existing failure semantics and evidence guard behavior.

### Implemented changes

1. Optimized duplicate-key detection path in `desktop/scripts/check_release_evidence_index.sh`:
   - replaced temp-file + per-row `grep` lookups with in-memory newline-delimited key tracking,
   - preserved identical error semantics for duplicate `RC+platform` detection.
2. Updated continuity baseline:
   - `desktop-flutter-release-validation-baseline.md` now notes in-memory duplicate-key tracking in release evidence checker implementation.
3. Re-ran validation commands:
   - `bash -n desktop/scripts/check_release_evidence_index.sh`,
   - `pnpm run desktop:release:evidence:check`,
   - negative duplicate-key validation using temporary index file with duplicated row (expected failure confirmed),
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - duplicate-key detection correctness after optimization,
  - guard-performance improvement via reduced per-row file I/O,
  - compatibility with existing release evidence validation flows.
- **Issues found during review**
  1. Existing duplicate-key check used temp-file persistence and per-row `grep`, causing avoidable I/O amplification as index size grows.
  2. Initial optimization draft using associative arrays was not compatible with macOS default Bash (3.2), causing `declare -A` runtime failure.
- **Fix applied**
  1. Replaced temp-file/`grep` duplicate tracking with portable in-memory newline-delimited key set matching, avoiding per-row file I/O while keeping behavior unchanged.
  2. Removed associative-array dependency to preserve compatibility across macOS/Linux environments.
- **Post-fix validation criteria**
  - Baseline evidence index still passes.
  - Duplicate-row negative case still fails with duplicate-key error.
  - Full-fast desktop verification remains green after optimization.

## Unit WS-D-99: Verify-test-coverage set-diff performance optimization

### Planned objective

Reduce per-file membership-check overhead in verify-test-coverage guard by replacing repeated `grep` scans with sorted set-diff operations.

### Implemented changes

1. Optimized uncovered/missing reference detection in `desktop/scripts/check_verify_test_coverage.sh`:
   - replaced per-row `grep -Fxq` loops with sorted set-diff via:
     - `comm -23` for uncovered tests,
     - `comm -13` for missing referenced tests.
2. Updated continuity baseline:
   - `desktop-flutter-release-validation-baseline.md` now documents set-diff (`comm`) comparison strategy in verify test coverage checker notes.
3. Re-ran validation commands:
   - `bash -n desktop/scripts/check_verify_test_coverage.sh`,
   - `pnpm run desktop:test:coverage:check`,
   - `pnpm run desktop:test:coverage:contract:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - correctness preservation for uncovered/missing reference detection,
  - performance impact of replacing repeated membership scans with set-diff operations,
  - compatibility with existing contract-check and verify chains.
- **Issues found during review**
  1. Existing implementation used per-row `grep` membership checks against full files, causing avoidable repeated scans as test inventory grows.
- **Fix applied**
  1. Switched uncovered/missing detection to sorted set-diff (`comm`) operations while preserving output sections and failure semantics.
- **Post-fix validation criteria**
  - Coverage checker output remains semantically identical for pass/fail conditions.
  - Coverage contract checker remains green after implementation change.
  - Full-fast desktop verification remains green after optimization.

## Unit WS-D-100: Release-evidence base-check reportability and CI artifact propagation

### Planned objective

Add first-class report output for the release-evidence base checker and propagate that report through verify/smoke/guard workflows so evidence validation outcomes remain auditable without log scraping.

### Implemented changes

1. Extended base checker report output in `desktop/scripts/check_release_evidence_index.sh`:
   - added default report output path `release/reports/release_evidence_index_check_report.md`,
   - preserved index-file-first CLI compatibility while adding optional report-file parameter,
   - emits structured report sections for validated rows, required attachment checks, and accumulated errors,
   - still enforces schema/decision/uniqueness/attachment constraints and now includes `release/reports/release_evidence_index_check_report.md` in required attachment references.
2. Updated contract checker assertions in `desktop/scripts/check_release_evidence_index_contract.sh`:
   - each case now passes explicit temporary report path into base checker,
   - contract rows now validate both log assertions and report assertions.
3. Extended canonical verify chain:
   - `desktop/scripts/verify_desktop.sh` now runs `check_release_evidence_index.sh` before contract check.
4. Propagated report artifact uploads in CI:
   - `.github/workflows/tests-desktop-flutter.yml`
     - verify matrix uploads `desktop-release-evidence-index-check-report-*`,
     - `release-evidence-guard` uploads `desktop-release-evidence-index-check-report-guard`.
   - `.github/workflows/release-desktop-installer-smoke.yml`
     - signing-readiness now runs `check_release_evidence_index.sh`,
     - uploads `desktop-release-evidence-index-check-report-smoke`.
5. Synced release evidence/baseline docs:
   - `desktop-flutter-release-evidence-index.md` maintenance rules now include attachment requirement for `release/reports/release_evidence_index_check_report.md`.
   - `desktop-flutter-release-validation-baseline.md` protocol/CI/script notes now include base-check report generation and artifact retention details.
6. Re-ran validation commands:
   - `bash -n desktop/scripts/check_release_evidence_index.sh`,
   - `bash -n desktop/scripts/check_release_evidence_index_contract.sh`,
   - `pnpm run desktop:release:evidence:check`,
   - `pnpm run desktop:release:evidence:contract:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - base-check report completeness for pass/fail diagnostics,
  - contract-level regression coverage for report assertions,
  - verify/smoke/guard CI artifact traceability for base evidence checks,
  - document-to-script attachment requirement consistency.
- **Issues found during review**
  1. Base release-evidence checker did not emit a dedicated markdown report, forcing audit consumers to rely on console logs.
  2. Contract checker validated only logs and did not assert base-check report content.
  3. CI retained release-evidence contract reports but lacked base-check report artifacts across verify/smoke/guard paths.
  4. Evidence-index maintenance rules and checker required-attachment lists were not synchronized for a base-check report artifact.
  5. Initial contract patch introduced a backtick-quoted report pattern string that broke shell parsing (`unexpected EOF while looking for matching \``) during syntax review.
- **Fix applied**
  1. Added deterministic base-check report emission with row/attachment/error sections and preserved guard semantics.
  2. Extended contract cases to assert report content in addition to log expectations.
  3. Added base-check execution/artifact upload coverage in verify matrix, dedicated evidence guard, and installer smoke signing-readiness.
  4. Added release-evidence base-check report path to maintenance rules and checker-required attachment references.
  5. Replaced fragile backtick-bearing assertion text with parser-safe pattern matching and re-ran shell syntax checks before full verification.
- **Post-fix validation criteria**
  - `desktop:release:evidence:check` generates `release_evidence_index_check_report.md` and passes on baseline index.
  - `desktop:release:evidence:contract:check` remains green with report assertions enabled.
  - `desktop:verify:full:fast` remains green with new base-check stage in verify chain.
  - Doc-declared attachment list remains aligned with checker-required attachment references.

## Unit WS-D-101: Release-evidence contract coverage expansion for base-check attachment requirement

### Planned objective

Close contract regression risk for the newly required base-check report attachment reference by adding a dedicated negative case to the release-evidence contract suite.

### Implemented changes

1. Extended contract case setup in `desktop/scripts/check_release_evidence_index_contract.sh`:
   - added `setup_missing_check_report_attachment_case`,
   - removes `release/reports/release_evidence_index_check_report.md` reference from case index fixture.
2. Added dedicated contract case:
   - `missing-evidence-check-report-attachment-fail`,
   - expects base checker failure plus log/report assertion hit for missing base-check report attachment reference.
3. Synced baseline script note:
   - `desktop-flutter-release-validation-baseline.md` now states that release-evidence contract checker includes missing-base-check-report attachment regression coverage.
4. Re-ran validation commands:
   - `bash -n desktop/scripts/check_release_evidence_index_contract.sh`,
   - `pnpm run desktop:release:evidence:contract:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - regression completeness for required attachment list evolution,
  - signal quality of contract report rows for missing base-check attachment path.
- **Issues found during review**
  1. Existing contract suite covered missing generic attachment and duplicate-key failures, but did not explicitly guard the newly introduced `release_evidence_index_check_report.md` attachment requirement.
- **Fix applied**
  1. Added an explicit missing-base-check-report negative case and assertion checks in the release-evidence contract suite.
  2. Updated baseline script-note documentation to prevent ambiguity about current contract coverage scope.
- **Post-fix validation criteria**
  - Contract suite fails when base-check report attachment reference is removed from index.
  - Contract suite remains green on current baseline index.
  - Full-fast desktop verification remains green after contract-case extension.

## Unit WS-D-102: Release-evidence missing-index failure-report contract coverage

### Planned objective

Ensure the base release-evidence checker's missing-index failure path stays audited by contract tests, including guaranteed failed-report emission semantics.

### Implemented changes

1. Added missing-index fixture setup in `desktop/scripts/check_release_evidence_index_contract.sh`:
   - new `setup_missing_index_file_case` removes the prepared case index file before checker invocation.
2. Added dedicated contract case:
   - `missing-index-file-fail`,
   - asserts failure log pattern (`missing index file:`) and report status pattern (`Status: failed`).
3. Synced baseline script note:
   - `desktop-flutter-release-validation-baseline.md` now states that release-evidence contract checker covers both missing-base-check-report attachment and missing-index-file regressions.
4. Re-ran validation commands:
   - `bash -n desktop/scripts/check_release_evidence_index_contract.sh`,
   - `pnpm run desktop:release:evidence:contract:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - contract coverage for base-check failure-report path when source index is unavailable,
  - report/log assertion accuracy for missing-index failures.
- **Issues found during review**
  1. Previous contract suite did not explicitly validate missing-index handling despite base checker now emitting structured failure reports for that path.
- **Fix applied**
  1. Added missing-index-file contract case with both log and report assertions.
  2. Updated baseline documentation note to reflect current contract coverage scope.
- **Post-fix validation criteria**
  - Contract suite fails when index file is absent and confirms failed-report status is emitted.
  - Contract suite remains green on baseline repository state.
  - Full-fast desktop verification remains green after new failure-path coverage.

## Unit WS-D-103: Release-evidence invalid-decision contract regression coverage

### Planned objective

Add explicit contract protection for invalid decision values in release evidence rows so decision-enum guard behavior cannot regress silently.

### Implemented changes

1. Added invalid-decision fixture setup in `desktop/scripts/check_release_evidence_index_contract.sh`:
   - new `setup_invalid_decision_case` rewrites the first RC row decision field to `reviewing`.
2. Added dedicated contract case:
   - `invalid-decision-fail`,
   - asserts failure log/report pattern `has invalid decision value`.
3. Synced baseline script note:
   - `desktop-flutter-release-validation-baseline.md` now states that release-evidence contract checker includes invalid-decision regression coverage.
4. Re-ran validation commands:
   - `bash -n desktop/scripts/check_release_evidence_index_contract.sh`,
   - `pnpm run desktop:release:evidence:contract:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - decision-value enum guard coverage in contract suite,
  - fixture rewrite correctness for table-row decision mutation.
- **Issues found during review**
  1. Contract suite previously lacked an explicit negative case proving that non-`promoted`/`blocked` decision values are rejected.
- **Fix applied**
  1. Added invalid-decision fixture mutation and failure case with log/report assertions.
  2. Updated baseline documentation note to keep contract coverage description current.
- **Post-fix validation criteria**
  - Contract suite fails when decision field deviates from allowed values.
  - Contract suite remains green on baseline index.
  - Full-fast desktop verification remains green after case expansion.

## Unit WS-D-104: Release-evidence promoted-placeholder hygiene contract coverage

### Planned objective

Add explicit contract regression coverage for promoted-row evidence hygiene so `TBD`/`placeholder` values cannot slip into promoted decisions without guard failure.

### Implemented changes

1. Added promoted-placeholder fixture setup in `desktop/scripts/check_release_evidence_index_contract.sh`:
   - new `setup_promoted_placeholder_case` rewrites first RC row decision to `promoted` while preserving placeholder evidence fields.
2. Added dedicated contract case:
   - `promoted-placeholder-row-fail`,
   - asserts failure log/report pattern `promoted row includes TBD field(s)`.
3. Synced baseline script note:
   - `desktop-flutter-release-validation-baseline.md` now includes promoted-placeholder regression coverage in release-evidence contract checker description.
4. Re-ran validation commands:
   - `bash -n desktop/scripts/check_release_evidence_index_contract.sh`,
   - `pnpm run desktop:release:evidence:contract:check`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - promoted-row evidence hygiene failure path coverage (`TBD` / placeholder detection),
  - fixture mutation correctness for promoted decision override.
- **Issues found during review**
  1. Contract suite did not explicitly guarantee regression protection for promoted rows containing placeholder evidence values.
- **Fix applied**
  1. Added promoted-placeholder negative case with log/report assertion checks.
  2. Updated baseline documentation note to maintain accurate contract coverage inventory.
- **Post-fix validation criteria**
  - Contract suite fails when placeholder evidence rows are marked `promoted`.
  - Contract suite remains green on baseline index.
  - Full-fast desktop verification remains green after coverage extension.

## Unit WS-D-105: Operation-scoped remote-stub blocking profile wiring

### Planned objective

Start backend-transport rollout prep by evolving remote-stub fault controls from global-unavailable-only behavior to operation-scoped blocking so adapter behavior can model partial backend degradation.

### Implemented changes

1. Extended remote-stub fault model in `desktop/lib/contracts/remote_stub_contracts.dart`:
   - `RemoteStubFaultProfile` now supports `blockedOperations` (`Set<String>`),
   - added `blocksOperation(String operation)` helper with case-insensitive matching,
   - existing `unavailable` behavior remains as global fail-closed switch.
2. Updated all remote-stub contract adapters to use operation-scoped checks:
   - auth/project/canvas/assets/collaboration/inspect/export/diagnostics wrappers now gate each mutation via `faultProfile.blocksOperation('<operation-id>')`.
3. Wired environment-driven blocked-operation profile in `desktop/lib/contracts/desktop_contract_bundle.dart`:
   - added parser for comma-separated `PENJAR_DESKTOP_REMOTE_STUB_BLOCKED_OPERATIONS`,
   - `DesktopContractBundle.fromEnvironment()` now injects parsed operation set into `RemoteStubFaultProfile`.
4. Added regression tests:
   - `desktop/test/contracts/desktop_contract_bundle_test.dart`: `remote-stub blocked operations profile blocks selected operations`.
   - `desktop/test/contracts/workflow_contracts_test.dart`: `block only configured operations when blockedOperations is set`.
5. Synced continuity docs:
   - `desktop-flutter-migration-inventory.md`: desktop shell/runtime blocker now mentions operation-scoped remote-stub blocked-operation profile.
   - `desktop-flutter-parity-acceptance-baseline.md`: CI anchor now documents `PENJAR_DESKTOP_REMOTE_STUB_BLOCKED_OPERATIONS`.
   - `desktop-flutter-development-runbook.md`: next-unit candidate now references backend transport client wiring on top of operation-scoped profile.
6. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/desktop_contract_bundle_test.dart test/contracts/workflow_contracts_test.dart`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - correctness of operation-scoped blocked-operation matching,
  - non-regression of existing global unavailable behavior,
  - environment wiring continuity from shell bootstrap to contract bundle.
- **Issues found during review**
  1. Remote-stub fault behavior previously allowed only all-or-nothing unavailable mode, limiting backend adapter rehearsal for partial-operation outages.
  2. Environment wiring had no channel to inject operation-scoped degradation profile into runtime contract bundle.
- **Fix applied**
  1. Added operation-scoped block-set support in `RemoteStubFaultProfile` and rewired all adapter checks to operation IDs.
  2. Added `PENJAR_DESKTOP_REMOTE_STUB_BLOCKED_OPERATIONS` parsing and bundle injection path.
  3. Added targeted contract tests validating selective blocking while non-targeted operations still execute.
- **Post-fix validation criteria**
  - Selective operation blocks are enforced in remote-stub mode without globally blocking all operations.
  - Global unavailable profile behavior remains unchanged.
  - Full-fast desktop verification remains green after runtime fault-model extension.

## Unit WS-D-106: Scripted transport-client injection baseline for remote-stub adapters

### Planned objective

Establish backend-transport wiring seam in remote-stub adapters by introducing an injectable transport client path, while preserving current sync contract signatures and existing degraded-path guard behavior.

### Implemented changes

1. Added transport client abstractions in `desktop/lib/contracts/remote_stub_contracts.dart`:
   - `RemoteStubTransportRequest`, `RemoteStubTransportResult`, `RemoteStubTransportClient`,
   - `RemoteStubNoopTransportClient` (default pass-through),
   - `RemoteStubScriptedTransportClient` (operation-scoped scripted blocking for transport simulation).
2. Added shared operation preflight helper:
   - `_allowRemoteStubOperation(...)` now evaluates both:
     - fault-profile blocks (`unavailable` + `blockedOperations`),
     - transport-client denial results.
3. Rewired all remote-stub adapters to use injected transport client:
   - auth/project/canvas/assets/collaboration/inspect/export/diagnostics contracts now accept `transportClient`,
   - constructors default to `const RemoteStubNoopTransportClient()` to preserve existing behavior.
4. Extended bundle/runtime environment wiring in `desktop/lib/contracts/desktop_contract_bundle.dart`:
   - `DesktopContractBundle.fromMode(...)` now accepts `remoteStubTransportClient`,
   - `DesktopContractBundle.remoteStub(...)` forwards a shared transport client to all remote-stub adapters,
   - `DesktopContractBundle.fromEnvironment()` now parses:
     - `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BLOCKED_OPERATIONS`,
     - `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BLOCK_REASON`,
     - and builds scripted/noop transport client accordingly.
5. Added regression tests:
   - `desktop/test/contracts/desktop_contract_bundle_test.dart`:
     - `remote-stub transport client blocks selected operations independently`.
   - `desktop/test/contracts/workflow_contracts_test.dart`:
     - `transport client blocks configured operations`.
6. Synced continuity docs:
   - `desktop-flutter-migration-inventory.md` now notes scripted transport-client injection path in shell/runtime blocker.
   - `desktop-flutter-parity-acceptance-baseline.md` now documents transport simulation env vars.
   - `desktop-flutter-development-runbook.md` next-unit candidate now points to replacing scripted transport with real backend transport implementation.
7. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/desktop_contract_bundle_test.dart test/contracts/workflow_contracts_test.dart`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - compatibility of new transport seam with existing contract signatures and parity harnesses,
  - non-regression of fault-profile behavior after introducing transport preflight,
  - runtime environment wiring correctness for transport simulation configuration.
- **Issues found during review**
  1. Remote-stub adapters had no transport-client seam, forcing all degraded behavior into fault-profile logic and limiting backend-transport rollout readiness.
  2. Bundle/environment wiring could not distribute a shared transport simulation profile across all adapters.
- **Fix applied**
  1. Introduced transport client interface + noop/scripted implementations and integrated them into adapter preflight.
  2. Added bundle-level shared transport-client injection path and environment parser for scripted blocking configuration.
  3. Added contract tests to verify transport-level blocking operates independently from fault-profile blocking.
- **Post-fix validation criteria**
  - Existing remote-stub behaviors remain unchanged with noop transport client.
  - Scripted transport client can block selected operations without enabling global unavailable mode.
  - Full-fast desktop verification remains green after transport seam integration.

## Unit WS-D-107: Remote-stub operation catalog normalization and matching-path optimization

### Planned objective

Improve remote-stub operation matching reliability/performance by introducing a canonical operation ID catalog and reducing repeated per-check normalization overhead.

### Implemented changes

1. Added canonical operation ID catalog in `desktop/lib/contracts/remote_stub_contracts.dart`:
   - new `RemoteStubOperationIds` constant class covering all remote-stub mutation operation IDs,
   - adapters now reference catalog constants instead of repeating raw string literals.
2. Added normalized-operation set cache:
   - introduced `_normalizedOperationSetCache` + `_normalizedOperationSet(...)` helper (Expando-backed),
   - `RemoteStubFaultProfile.blocksOperation(...)` and `RemoteStubScriptedTransportClient._isBlocked(...)` now use cached normalized sets instead of per-call nested normalization loops.
3. Tightened environment blocked-operation parsing:
   - `desktop/lib/contracts/desktop_contract_bundle.dart` `_parseBlockedOperations(...)` now accepts optional allowed-operation set,
   - env-driven blocked-operation lists (`PENJAR_DESKTOP_REMOTE_STUB_BLOCKED_OPERATIONS`, `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BLOCKED_OPERATIONS`) are filtered against `RemoteStubOperationIds.all`.
4. Synced continuity docs:
   - `desktop-flutter-parity-acceptance-baseline.md` now documents catalog-based filtering for environment-driven operation lists.
5. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/desktop_contract_bundle_test.dart test/contracts/workflow_contracts_test.dart`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - operation ID consistency across adapters/fault-profile/transport profile,
  - runtime cost of repeated operation normalization in block checks,
  - robustness of env-driven blocked-operation parsing against unsupported IDs.
- **Issues found during review**
  1. Operation IDs were duplicated as raw literals across many adapter methods, increasing typo risk and drift potential.
  2. Fault-profile and scripted transport matching repeatedly normalized entire blocked-operation sets on each check path.
  3. Initial optimization attempt used class-level `late final` normalization caches, which conflicted with `const` constructor constraints and caused compile failures.
- **Fix applied**
  1. Centralized operation IDs under `RemoteStubOperationIds`.
  2. Replaced per-call normalization loops with Expando-backed normalized-set cache helpers.
  3. Reworked optimization approach from instance `late final` caches to global cache helper to preserve `const` constructor compatibility.
  4. Added allowed-operation filtering for env parsing to drop unsupported operation keys.
- **Post-fix validation criteria**
  - Adapter operation checks compile and run using canonical operation IDs.
  - Fault-profile/transport blocked-operation checks remain case-insensitive and functionally equivalent.
  - Full-fast desktop verification remains green after optimization.

## Unit WS-D-108: Remote-stub runtime profile visibility wiring

### Planned objective

Expose effective remote-stub degradation profile (fault + transport) through bundle/runtime/UI surfaces so manual/automated parity validation can verify active degraded-path configuration without reading environment inputs directly.

### Implemented changes

1. Added bundle-level runtime profile model in `desktop/lib/contracts/desktop_contract_bundle.dart`:
   - introduced `DesktopRemoteStubProfile` (unavailable/fault blocks/transport blocks/reason),
   - added `_buildRemoteStubProfile(...)` helper and `remoteStubProfile` field on `DesktopContractBundle`,
   - `fromMode`/`remoteStub` now propagate computed profile from fault profile + transport client.
2. Extended shell/diagnostics UI visibility in `desktop/lib/main.dart`:
   - shell header now shows `Remote Profile: ...` chip in remote-stub mode when profile is non-empty,
   - diagnostics panel now accepts `remoteProfileLabel` and renders `Remote profile: ...` line with dedicated key (`diagnostics-remote-profile`).
3. Added/updated regression tests:
   - `desktop/test/contracts/desktop_contract_bundle_test.dart` now verifies `remoteStubProfile` population for:
     - in-memory mode (`null`),
     - remote-stub default,
     - unavailable fault profile,
     - blocked-operations profile,
     - scripted transport profile.
   - parity tests:
     - `desktop/test/parity/remote_stub_mode_parity_test.dart` asserts `Remote profile: none`,
     - `desktop/test/parity/remote_stub_unavailable_parity_test.dart` asserts `Remote profile: unavailable`.
4. Synced continuity docs:
   - `desktop-flutter-migration-inventory.md` now notes diagnostics-visible remote profile summary in shell/runtime blocker.
   - `desktop-flutter-parity-acceptance-baseline.md` now records diagnostics remote profile summary requirement.
5. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/desktop_contract_bundle_test.dart test/contracts/workflow_contracts_test.dart test/parity/remote_stub_mode_parity_test.dart test/parity/remote_stub_unavailable_parity_test.dart`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - correctness of computed bundle remote profile across fault/transport combinations,
  - diagnostics/shell visibility of active remote profile state in remote-stub mode,
  - parity test stability after UI metadata expansion.
- **Issues found during review**
  1. Remote-stub degraded profile was configured internally but not surfaced as explicit runtime metadata, making fault-scenario validation dependent on indirect status text checks.
- **Fix applied**
  1. Added explicit bundle-level remote profile model and propagated it into UI metadata surfaces.
  2. Added parity assertions for default (`none`) and unavailable profile visibility in diagnostics workflow.
- **Post-fix validation criteria**
  - Remote-stub runtime profile is observable in diagnostics parity surface.
  - Existing remote-stub behavioral checks remain green.
  - Full-fast desktop verification remains green after metadata/visibility extension.

## Unit WS-D-109: Transport profile interface extraction for adapter decoupling

### Planned objective

Reduce bundle-to-transport coupling by replacing concrete transport-type checks with interface-level transport profile exposure, so future real backend transport clients can integrate without bundle-layer type branching.

### Implemented changes

1. Added transport profile abstraction in `desktop/lib/contracts/remote_stub_contracts.dart`:
   - new `RemoteStubTransportProfile` model (`blockedOperations`, `blockedReason`, `isEmpty`),
   - `RemoteStubTransportClient` now exposes `profile` getter (default empty profile),
   - `RemoteStubScriptedTransportClient` now overrides `profile` to return normalized blocked-operation metadata.
2. Removed concrete-type branching in bundle profile builder:
   - `desktop/lib/contracts/desktop_contract_bundle.dart` `_buildRemoteStubProfile(...)` now consumes `transportClient.profile` rather than `is RemoteStubScriptedTransportClient` checks.
3. Extended transport-profile regression assertion:
   - `desktop/test/contracts/workflow_contracts_test.dart` now validates scripted transport profile getter values (`blockedOperations`, `blockedReason`).
4. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/desktop_contract_bundle_test.dart test/contracts/workflow_contracts_test.dart`,
   - `pnpm run desktop:verify:full:fast`.

### Unit review (detailed)

- **Review scope**
  - bundle profile builder decoupling from specific transport implementation types,
  - transport metadata contract stability for future transport implementations.
- **Issues found during review**
  1. Bundle profile construction was coupled to scripted transport concrete type, limiting extensibility for future transport client variants.
- **Fix applied**
  1. Introduced interface-level transport profile contract and rewired bundle profile construction to consume it.
  2. Added regression assertion for scripted transport profile metadata.
- **Post-fix validation criteria**
  - Bundle profile builder no longer depends on scripted transport concrete type checks.
  - Scripted transport continues to expose blocked-operation metadata correctly.
  - Full-fast desktop verification remains green after interface extraction.

## Unit WS-D-110: HTTP health-probe transport integration for remote-stub adapters

### Planned objective

Introduce a real backend transport path for runtime-switchable remote-stub adapters by adding HTTP health-probe transport client wiring, while preserving sync contract signatures and remote-profile visibility surfaces.

### Implemented changes

1. Added HTTP transport client implementation in `desktop/lib/contracts/remote_stub_contracts.dart`:
   - extended `RemoteStubTransportProfile` with `transportLabel`,
   - added `RemoteStubHttpTransportProbeRequest`, `RemoteStubHttpTransportProbeResult`, and `RemoteStubHttpTransportProbe` injection contract,
   - implemented default synchronous curl probe (`_defaultHttpTransportProbe`) and HTTP status-code parsing helper,
   - added `RemoteStubHttpTransportClient` with configurable `healthUrl`, timeout, allowed status codes, and blocked reason.
2. Extended runtime environment transport selection in `desktop/lib/contracts/desktop_contract_bundle.dart`:
   - `DesktopContractBundle.fromEnvironment()` transport path now supports:
     - `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_HEALTH_URL`,
     - `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_TIMEOUT_MS`,
     - `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_ALLOWED_STATUS_CODES`,
     - existing `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BLOCK_REASON`,
   - when health URL is configured, bundle now builds `RemoteStubHttpTransportClient`,
   - scripted blocked-operation transport path (`PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BLOCKED_OPERATIONS`) remains as fallback when HTTP health URL is not configured,
   - `DesktopRemoteStubProfile` now includes `transportLabel` and renders it in `summaryLabel`.
3. Added regression tests:
   - `desktop/test/contracts/workflow_contracts_test.dart`:
     - `http transport client blocks operations when probe fails`,
     - `http transport client allows operations when probe succeeds`.
   - `desktop/test/contracts/desktop_contract_bundle_test.dart`:
     - `remote-stub profile exposes http transport label`.
4. Synced continuity docs:
   - `desktop-flutter-migration-inventory.md` desktop shell/runtime blocker now reflects HTTP health-probe transport wiring.
   - `desktop-flutter-parity-checklist.md` diagnostics row now includes HTTP transport gating baseline.
   - `desktop-flutter-parity-acceptance-baseline.md` now documents HTTP transport env controls and scripted fallback behavior.
   - `desktop-flutter-development-runbook.md` next-unit candidate now targets workflow-specific backend payload transport mapping on top of health-probe gating.
5. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/desktop_contract_bundle_test.dart test/contracts/workflow_contracts_test.dart`,
   - `cd desktop && flutter test test/parity/remote_stub_mode_parity_test.dart test/parity/remote_stub_unavailable_parity_test.dart`,
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - correctness of sync-safe real transport gating behavior under successful/failed backend probes,
  - runtime environment selection precedence between HTTP transport and scripted fallback transport,
  - remote profile visibility coverage for transport path metadata.
- **Issues found during review**
  1. Remote-stub transport seam remained scripted-only and did not exercise a real backend reachability path.
  2. Remote profile metadata could not expose the configured transport backend path for diagnostics/parity evidence.
  3. Environment transport controls lacked timeout and accepted-status tuning for health checks.
- **Fix applied**
  1. Implemented `RemoteStubHttpTransportClient` with injectable probe contract and default curl-based health probe.
  2. Added transport label propagation from transport profile into bundle remote profile summary surface.
  3. Added HTTP transport env parsing (`HEALTH_URL`, `TIMEOUT_MS`, `ALLOWED_STATUS_CODES`) with scripted transport fallback and regression coverage.
- **Post-fix validation criteria**
  - Failed HTTP probe blocks remote-stub mutation operations with deterministic status surface.
  - Successful HTTP probe preserves existing remote-stub delegated behavior.
  - Remote profile summary surfaces transport label when HTTP transport is configured.
  - Full desktop verification gate (`desktop:verify:full`) remains green after transport integration.

## Unit WS-D-111: Workflow-level backend request metadata mapping for remote-stub transport

### Planned objective

Complete workflow-specific backend payload transport integration by mapping every remote-stub operation to explicit backend request metadata (workflow, method, endpoint, payload) while preserving existing synchronous contract signatures and degraded-path behavior.

### Implemented changes

1. Expanded transport request contract in `desktop/lib/contracts/remote_stub_contracts.dart`:
   - `RemoteStubTransportRequest` now carries `workflow`, `method`, `endpoint`, and `payload` metadata in addition to `operation`.
   - added `RemoteStubBackendRoute` + `RemoteStubBackendRouteCatalog` for operation-to-endpoint/method mapping across auth/project/file/canvas/assets/collaboration/inspect/export/diagnostics domains.
2. Rewired operation preflight to request-driven transport execution:
   - `_allowRemoteStubOperation(...)` now receives `RemoteStubTransportRequest` directly rather than operation ID only.
   - all remote-stub adapter `_allowOperation(...)` helpers now build transport requests via `_buildTransportRequest(...)`.
3. Added workflow payload mapping for all operations:
   - auth/project/file/canvas/assets/collaboration/inspect/export/diagnostics mutation operations now populate backend request payload metadata per operation.
   - auth sign-in payload is sanitized (`passwordLength`) instead of sending raw password content.
4. Extended HTTP transport probe request visibility:
   - `RemoteStubHttpTransportProbeRequest` now exposes `workflow/method/endpoint/payload` via forwarded transport request metadata.
   - `RemoteStubHttpTransportClient` now forwards full transport request metadata to probe hooks.
5. Added/updated regression tests:
   - `desktop/test/contracts/workflow_contracts_test.dart`:
     - new `maps all operations to backend request metadata` test validates:
       - all `RemoteStubOperationIds.all` operations emit transport requests,
       - no operation falls back to default route endpoint,
       - representative route-method-payload assertions (auth/project/delete/export).
     - existing HTTP transport tests now verify workflow/method/endpoint/payload metadata in probe callbacks.
6. Synced continuity docs:
   - `desktop-flutter-migration-inventory.md` now reflects workflow-level backend request metadata mapping completion.
   - `desktop-flutter-parity-checklist.md` now includes backend request metadata mapping status in workflow notes.
   - `desktop-flutter-parity-acceptance-baseline.md` now documents transport-request metadata parity contract.
   - `desktop-flutter-development-runbook.md` next-unit candidate now targets real backend execution/response mapping on top of current request metadata path.
7. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/workflow_contracts_test.dart test/contracts/desktop_contract_bundle_test.dart`,
   - `cd desktop && flutter test test/parity/remote_stub_mode_parity_test.dart test/parity/remote_stub_unavailable_parity_test.dart`,
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - completeness of operation-to-backend route mapping coverage across all workflow domains,
  - correctness of transport-request metadata propagation into HTTP probe hooks,
  - non-regression of existing remote-stub blocked/unavailable/decorated-status behavior.
- **Issues found during review**
  1. Remote-stub transport path previously exposed only operation IDs, leaving no route/payload contract for backend execution handoff.
  2. HTTP probe callbacks could not inspect per-operation request shape, making backend request parity validation impossible.
  3. Sign-in payload mapping risked over-sharing sensitive material if raw password were propagated.
- **Fix applied**
  1. Added backend route catalog + request metadata carrier and rewired all adapters to emit request-shaped transport metadata.
  2. Extended HTTP probe request contract to include workflow/method/endpoint/payload views and added assertion coverage.
  3. Enforced sanitized auth payload mapping by recording `passwordLength` instead of password plaintext.
- **Post-fix validation criteria**
  - Every operation in `RemoteStubOperationIds.all` emits a mapped backend request metadata record.
  - HTTP probe hooks can assert endpoint/method/payload parity per operation.
  - Existing remote-stub behavior and full desktop verification gate remain green after metadata integration.

## Unit WS-D-112: Remote-stub backend execution transport integration

### Planned objective

Integrate real backend endpoint execution into the remote-stub transport path so operation-level requests are executed against backend URLs and backend errors are propagated into workflow status surfaces, while preserving existing health-gate and fallback behavior.

### Implemented changes

1. Extended HTTP transport model in `desktop/lib/contracts/remote_stub_contracts.dart`:
   - added `RemoteStubHttpBackendExecutionRequest`, `RemoteStubHttpBackendExecutionResult`, and `RemoteStubHttpBackendExecutionProbe`,
   - added backend endpoint URL resolution helper and curl response parser (`_parseCurlHttpResponse`) with backend error message extraction (`_extractBackendErrorMessage`),
   - implemented default backend execution probe (`_defaultHttpBackendExecutionProbe`) that:
     - executes operation endpoint requests with method + JSON payload via curl,
     - supports optional bearer token auth header,
     - treats non-2xx responses as transport denial with backend error detail propagation.
2. Upgraded `RemoteStubHttpTransportClient` behavior:
   - now supports optional backend execution configuration:
     - `backendBaseUrl`,
     - `backendTimeout`,
     - `backendBlockedReason`,
     - `backendAuthToken`,
     - injected `executionProbe`,
   - preserves existing health probe gating before backend execution,
   - supports three runtime paths:
     - health-only,
     - backend-only,
     - health+backend chained,
   - transport profile label now supports composite health/backend labels.
3. Extended environment wiring in `desktop/lib/contracts/desktop_contract_bundle.dart`:
   - `DesktopContractBundle.fromEnvironment()` transport parser now supports:
     - `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_BASE_URL`,
     - `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_TIMEOUT_MS`,
     - `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_AUTH_TOKEN`,
     - `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_BLOCK_REASON`,
   - HTTP transport is now activated when either health URL or backend base URL is configured.
4. Added regression coverage:
   - `desktop/test/contracts/workflow_contracts_test.dart`:
     - `http transport client blocks operation on backend execution error`,
     - `http transport client executes backend request and allows operation on success`.
   - `desktop/test/contracts/desktop_contract_bundle_test.dart`:
     - `remote-stub profile exposes backend execution transport label`.
5. Synced continuity docs:
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`,
   - `desktop-flutter-development-runbook.md` (next candidate refresh).
6. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/workflow_contracts_test.dart test/contracts/desktop_contract_bundle_test.dart`,
   - `cd desktop && flutter test test/parity/remote_stub_mode_parity_test.dart test/parity/remote_stub_unavailable_parity_test.dart`,
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - backend execution path correctness (endpoint URL composition, method/payload forwarding, non-2xx failure handling),
  - health-gate + backend-execution chaining behavior and fallback compatibility,
  - transport profile/diagnostics visibility continuity after backend execution integration.
- **Issues found during review**
  1. Request-metadata-only transport path still could not execute real endpoints, leaving backend integration blocked at simulation layer.
  2. Backend error payloads were not propagated into workflow status surfaces, reducing actionable diagnostics during remote-stub execution failures.
  3. Initial implementation pass introduced an extra duplicated trailing block in `RemoteStubHttpTransportClient` section, creating potential compile risk.
- **Fix applied**
  1. Added execution probe contract and default curl-based backend execution path with JSON payload forwarding and auth-token support.
  2. Added backend error-detail extraction and propagation into blocked transport status messages.
  3. Removed duplicated trailing block during review and re-ran focused + full verification.
- **Post-fix validation criteria**
  - backend execution errors block operations with deterministic backend-derived status text.
  - backend execution success path preserves existing remote-stub delegate behavior.
  - full verification gate (`desktop:verify:full`) remains green after backend execution integration.

## Unit WS-D-113: Remote-stub backend response-driven state mutation integration

### Planned objective

Replace in-memory delegate-first mutation behavior in remote-stub adapters with backend response-driven state transitions when backend success payload is available, while preserving existing synchronous signatures, degraded-path behavior, and delegate fallback compatibility.

### Implemented changes

1. Extended transport success contract payload propagation in `desktop/lib/contracts/remote_stub_contracts.dart`:
   - `RemoteStubTransportResult` now carries optional `responsePayload`,
   - `RemoteStubHttpBackendExecutionResult` now carries optional `responsePayload`,
   - added payload-aware factories:
     - `RemoteStubTransportResult.allowedWithPayload(...)`,
     - `RemoteStubHttpBackendExecutionResult.allowedWithPayload(...)`.
2. Added backend success-body extraction + propagation in HTTP backend execution path:
   - introduced `_extractBackendSuccessPayload(...)` JSON map extractor for 2xx responses,
   - `_defaultHttpBackendExecutionProbe(...)` now forwards decoded success payload when available,
   - `RemoteStubHttpTransportClient.execute(...)` now propagates backend response payload into transport result.
3. Reworked remote-stub adapter mutation flow across all workflow domains:
   - `_allowRemoteStubOperation(...)` now returns `RemoteStubTransportResult?` instead of boolean gate,
   - all remote-stub adapters now keep per-domain state snapshots and apply blocked-status overrides on top of snapshot state,
   - added backend response parsers + coercion helpers for all domain states:
     - auth/project/canvas/assets/collaboration/inspect/export/diagnostics,
   - mutation operations now:
     - apply backend response payload state when present,
     - skip delegate mutation in that branch,
     - preserve delegate fallback when backend payload is absent.
4. Expanded contract regression coverage in `desktop/test/contracts/workflow_contracts_test.dart`:
   - updated `http transport client executes backend request and allows operation on success` to assert backend-driven project state snapshot application,
   - added `applies backend response payload snapshots across all workflow adapters`,
   - added `skips auth delegate mutation when backend response snapshot is present`.
5. Synced continuity docs:
   - `desktop-flutter-development-runbook.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`.
6. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/workflow_contracts_test.dart test/contracts/desktop_contract_bundle_test.dart`,
   - `cd desktop && flutter test test/parity/remote_stub_mode_parity_test.dart test/parity/remote_stub_unavailable_parity_test.dart`,
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - correctness of transport success payload propagation from backend execution to adapter layer,
  - domain-state parser safety and fallback behavior under partial/malformed payloads,
  - non-regression of degraded-path blocking/status override behavior and parity coverage.
- **Issues found during review**
  1. Successful backend execution path still returned allow-only signal, so adapter state mutations remained delegate-driven.
  2. Initial full verification pass failed static analysis due two hygiene issues introduced during refactor:
     - unnecessary cast in asset parser,
     - unnecessary string escapes in test fixture payload.
  3. Delegate-bypass behavior under backend payload success was not explicitly asserted in tests, creating regression risk.
  4. Optional selected-index normalization initially coerced negative values to `0`, which could incorrectly auto-select an item when backend snapshot intended no selection (`-1`).
- **Fix applied**
  1. Added payload propagation contracts and wired HTTP backend success-body extraction through transport results.
  2. Added domain-specific backend payload parsers and state-snapshot application flow across all remote-stub adapters.
  3. Removed unnecessary cast/string escapes and re-ran full verification.
  4. Added explicit test proving delegate sign-in mutation is skipped when backend auth snapshot payload is present.
  5. Corrected optional index clamp behavior to preserve backend `-1` no-selection semantics for optional selected-index fields.
- **Post-fix validation criteria**
  - backend success payload can deterministically drive visible contract state transitions in all workflow domains.
  - blocked/unavailable transport behavior and decorated status surfaces remain intact.
  - full verification gate (`desktop:verify:full`) passes after response-driven integration.

## Unit WS-D-114: Desktop shell section-route/state restoration bridge baseline

### Planned objective

Establish a concrete Flutter shell route/state bridge baseline by wiring section-route initialization and restart restoration semantics into the desktop shell runtime, so navigation state can be carried through route seed + restoration without reintroducing contract-state regressions.

### Implemented changes

1. Extended shell app bootstrap in `desktop/lib/main.dart`:
   - `PenjarDesktopApp` now accepts `initialSectionId` (default from `PENJAR_DESKTOP_INITIAL_SECTION`),
   - `MaterialApp` now enables restoration scope (`restorationScopeId: 'penjar-desktop'`),
   - `DesktopShellPage` now receives route-seed section ID from app bootstrap.
2. Added section-route mapping + restoration state bridge in desktop shell state:
   - introduced `_sectionIndexFromId(...)` mapper from section ID to navigation index,
   - migrated shell selected-section state to `RestorableInt`,
   - added `RestorationMixin` with `restorationId` and `selected_section_index` registration,
   - initialization now applies route-seed only when serialized restoration data is absent (`bucket?.contains(...)` guard),
   - preserved existing contract-bundle/state wiring and nav interaction flow.
3. Expanded route/state regression coverage:
   - `desktop/test/widget_test.dart`:
     - added `desktop shell honors initial section route id`,
   - `desktop/test/parity/parity_test_utils.dart`:
     - `pumpDesktopApp(...)` now accepts `initialSectionId`,
   - `desktop/test/parity/shell_contract_persistence_parity_test.dart`:
     - added `selected workflow section is restored after app restart` (uses `tester.restartAndRestore()`).
4. Synced continuity docs:
   - `desktop-flutter-development-runbook.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`.
5. Re-ran validation commands:
   - `cd desktop && flutter test test/widget_test.dart test/parity/shell_contract_persistence_parity_test.dart`,
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - route-seed section ID mapping correctness + fallback behavior,
  - restoration lifecycle correctness under first launch vs restart restore,
  - non-regression of shell workflow contract persistence behavior.
- **Issues found during review**
  1. Initial implementation attempted to set `RestorableInt.value` in `initState` before registration, causing restoration assertion failure (`isRegistered`).
  2. Initial route-seed application logic used `oldBucket == null`, which could clobber restored selection data on restart.
  3. Route-state parity assertion initially relied on section title text, which can produce false positives because nav labels also include section names.
- **Fix applied**
  1. Moved route-seed initialization into `restoreState` after `registerForRestoration(...)`.
  2. Added serialized-state presence guard (`bucket?.contains('selected_section_index')`) to prevent overriding restored selection.
  3. Tightened parity assertion to panel key-level validation (`inspect-panel`) before and after restart restore.
- **Post-fix validation criteria**
  - initial section-route seeding honors valid section IDs and safely defaults to shell route for unknown IDs.
  - selected section survives `restartAndRestore()` in parity coverage.
  - full verification gate (`desktop:verify:full`) remains green after restoration bridge integration.

## Unit WS-D-115: Remote-stub backend envelope/schema compatibility normalization

### Planned objective

Improve remote-stub backend response compatibility by normalizing nested success-envelope parsing (`result`/`data`) and status aliases (`message`/`detail`) so response-driven state transitions remain stable as backend payload wrappers evolve.

### Implemented changes

1. Extended backend response parser helpers in `desktop/lib/contracts/remote_stub_contracts.dart`:
   - added `_extractBackendEnvelopePayload(...)` to unwrap envelope-level payloads (`result`, `data`),
   - updated `_extractBackendStatePayload(...)` to resolve state payload from both root and envelope scopes,
   - added `_hasBackendStatus(...)` helper and expanded `_resolveBackendStatusValue(...)` to include `status`, `message`, `detail` across root/envelope/state scopes.
2. Updated all domain parser paths (auth/project/canvas/assets/collaboration/inspect/export/diagnostics):
   - now read envelope-aware state payloads,
   - now detect status aliases consistently before deciding whether backend payload is actionable,
   - preserve existing fallback behavior when backend payload lacks state/status semantics.
3. Added regression coverage in `desktop/test/contracts/workflow_contracts_test.dart`:
   - new test `supports nested backend response envelopes and message aliases` verifies:
     - auth payload via `data.authState` + root `message`,
     - project payload via `result.workflowState` + nested `message`.
4. Synced continuity docs:
   - `desktop-flutter-development-runbook.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`.
5. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/workflow_contracts_test.dart test/contracts/desktop_contract_bundle_test.dart`,
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - compatibility of response-driven mutation path with nested backend success envelopes,
  - status-text propagation coverage across alternate backend status keys,
  - non-regression of existing remote-stub transport/degraded-path behavior.
- **Issues found during review**
  1. Existing parser flow assumed root-level state payloads and could ignore backend snapshots wrapped under `result` or `data`.
  2. Status propagation depended on `status` key only, which reduced compatibility with backends returning `message` or `detail`.
  3. Without envelope-specific regression tests, parser drift risk remained high for future backend schema updates.
- **Fix applied**
  1. Added envelope unwrapping helper and dual-scope state payload lookup.
  2. Expanded status resolution logic to include alias keys across root/envelope/state scopes.
  3. Added contract-level regression test covering nested envelope + alias behavior and re-ran full verification.
- **Post-fix validation criteria**
  - response-driven state transitions work for both root and nested envelope payload schemas.
  - backend status text remains visible when backend uses `status` or `message` aliases.
  - full verification gate (`desktop:verify:full`) remains green after parser compatibility normalization.

## Unit WS-D-116: Remote-stub auth snapshot store/seed persistence seam

### Planned objective

Reduce auth/session continuity risk by introducing an explicit remote-stub auth snapshot persistence seam (load/save + startup seed path) so durable session persistence can later be wired to platform-secure storage without refactoring core contract adapters.

### Implemented changes

1. Added auth snapshot store abstraction in `desktop/lib/contracts/remote_stub_contracts.dart`:
   - introduced `RemoteStubAuthStateStore` interface (`load`/`save`),
   - added `RemoteStubNoopAuthStateStore` (default no-op behavior),
   - added `RemoteStubMemoryAuthStateStore` for deterministic test/storage seam validation.
2. Integrated snapshot store into `RemoteStubAuthSessionContract`:
   - constructor now accepts `authStateStore` and optional `initialState`,
   - contract now hydrates `_stateSnapshot` from `initialState` or store `load()` on startup,
   - `_resolveNextState(...)` now persists normalized auth state through `authStateStore.save(...)` after successful state transition,
   - added status-prefix normalization helper to persist undecorated status text.
3. Added startup seed plumbing in `desktop/lib/contracts/desktop_contract_bundle.dart`:
   - from-environment parser now supports `PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_JSON`,
   - added safe JSON coercion helpers and auth-state parser (`authState` nested or root keys),
   - `DesktopContractBundle.fromMode(...)` and `.remoteStub(...)` now accept/pass `remoteStubAuthInitialState` / `authInitialState`.
4. Added regression coverage:
   - `desktop/test/contracts/workflow_contracts_test.dart`:
     - added `restores and persists auth snapshot through auth state store`,
   - `desktop/test/contracts/desktop_contract_bundle_test.dart`:
     - added `fromMode forwards remote-stub auth initial state snapshot`.
5. Synced continuity docs:
   - `desktop-flutter-development-runbook.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`.
6. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/workflow_contracts_test.dart test/contracts/desktop_contract_bundle_test.dart`,
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - auth snapshot store seam correctness (load/save timing + prefix normalization),
  - startup seed safety for environment-driven auth-state payloads,
  - non-regression of remote-stub auth behavior and bundle mode wiring.
- **Issues found during review**
  1. Remote-stub auth adapter had no persistence seam, forcing all auth continuity behavior to in-process lifecycle only.
  2. Persisting decorated status text would risk repeated prefix artifacts or UI-format coupling in storage payloads.
  3. Startup JSON seed parsing needed defensive coercion/fallback to avoid malformed input destabilizing bundle creation.
- **Fix applied**
  1. Added explicit auth-state store interface + default noop implementation and integrated load/save flow in remote-stub auth contract.
  2. Added undecorated-status persistence path (`_undecorateAuthState(...)`) before storing snapshots.
  3. Added robust JSON coercion helpers in bundle parser with null-safe fallback behavior.
  4. Added targeted regression tests for both adapter-level snapshot persistence and bundle-level initial-state forwarding.
- **Post-fix validation criteria**
  - auth contract can restore from injected/store snapshot and persist updated snapshots after successful transitions.
  - bundle-mode wiring can seed remote-stub auth state without breaking existing mode behavior.
  - full verification gate (`desktop:verify:full`) remains green after auth snapshot seam integration.

## Unit WS-D-117: Remote-stub file-backed auth snapshot persistence path

### Planned objective

Advance auth/session continuity from seam-only to executable persistence by adding a file-backed auth snapshot store path for remote-stub mode, while keeping secure-store migration open as a follow-up.

### Implemented changes

1. Added file-backed auth store in `desktop/lib/contracts/remote_stub_contracts.dart`:
   - introduced `RemoteStubFileAuthStateStore(path)` implementing `RemoteStubAuthStateStore`,
   - `load()` now reads/parses snapshot JSON safely (missing/invalid file falls back to null),
   - `save()` now writes normalized auth snapshot JSON with recursive parent-directory creation.
2. Added environment wiring in `desktop/lib/contracts/desktop_contract_bundle.dart`:
   - introduced `PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_PATH`,
   - added `_buildRemoteStubAuthStateStoreFromEnvironment()` to resolve noop vs file store,
   - extended `DesktopContractBundle.fromMode(...)` / `.remoteStub(...)` signatures to pass configurable `RemoteStubAuthStateStore`.
3. Expanded regression coverage:
   - `desktop/test/contracts/workflow_contracts_test.dart`:
     - added `file auth state store loads and saves snapshots`,
   - `desktop/test/contracts/desktop_contract_bundle_test.dart`:
     - added `remote-stub bundle forwards auth state store persistence seam`.
4. Synced continuity docs:
   - `desktop-flutter-development-runbook.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`.
5. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/workflow_contracts_test.dart test/contracts/desktop_contract_bundle_test.dart`,
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - file-backed auth snapshot store correctness (read/write safety + invalid-input handling),
  - bundle wiring precedence and compatibility with existing auth seed/state-store seam,
  - non-regression of contract/parity/verification chain after persistence-path extension.
- **Issues found during review**
  1. Auth snapshot seam lacked an executable persistence implementation path, limiting restart continuity to injected in-memory fixtures.
  2. File I/O error paths (missing file, malformed JSON, directory absence) needed explicit graceful handling to avoid startup failures.
  3. Bundle factory wiring had no auth-state-store parameter path, so environment-driven file store could not be injected into remote-stub auth contract.
- **Fix applied**
  1. Implemented `RemoteStubFileAuthStateStore` with defensive load/save behavior and path normalization.
  2. Added from-environment auth-state-store resolver and threaded store dependency through bundle mode/factory paths.
  3. Added contract-level regression tests for direct file store behavior and bundle-level store wiring.
- **Post-fix validation criteria**
  - file-backed auth snapshot path reads/writes deterministic state without destabilizing startup on invalid/missing file.
  - remote-stub bundle can inject auth-state-store dependency and persist auth transitions through the configured seam.
  - full verification gate (`desktop:verify:full`) remains green after file-backed path integration.

## Unit WS-D-118: Command-hook secure-store bridge for remote-stub auth snapshots

### Planned objective

Bridge remote-stub auth snapshot persistence into OS credential-store workflows by adding a command-hook auth store mode (load/save command controls), so teams can wire platform keychain/credential-manager commands before first-class native plugin integration.

### Implemented changes

1. Added command-hook auth store path in `desktop/lib/contracts/remote_stub_contracts.dart`:
   - introduced command execution model:
     - `RemoteStubCommandExecutionRequest`,
     - `RemoteStubCommandExecutionResult`,
     - `RemoteStubCommandRunner` + default shell runner (`sh -c` / `cmd /C`),
   - added `RemoteStubCommandAuthStateStore`:
     - `load()` executes configured load command and parses JSON stdout into auth snapshot,
     - `save()` executes configured save command with serialized snapshot in `PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_JSON` env.
2. Extended bundle environment wiring in `desktop/lib/contracts/desktop_contract_bundle.dart`:
   - auth-state store resolver now supports:
     - `PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_LOAD_COMMAND`,
     - `PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_SAVE_COMMAND`,
   - precedence: command-hook store -> file store -> noop store.
3. Expanded regression coverage:
   - `desktop/test/contracts/workflow_contracts_test.dart`:
     - `command auth state store loads and saves via command runner`,
     - `command auth state store returns null on failed load command`,
   - `desktop/test/contracts/desktop_contract_bundle_test.dart`:
     - `remote-stub bundle supports command auth state store seam`.
4. Synced continuity docs:
   - `desktop-flutter-development-runbook.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`.
5. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/workflow_contracts_test.dart test/contracts/desktop_contract_bundle_test.dart`,
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - command-hook auth store correctness (load/save command invocation + env payload),
  - platform-safe default command runner behavior across non-Windows/Windows shells,
  - non-regression of existing file/noop auth store paths and full verification chain.
- **Issues found during review**
  1. File/env-based auth store path still required manual file plumbing and did not directly bridge to platform-secure credential workflows.
  2. Command execution path needed deterministic, testable behavior without invoking real shell commands in unit tests.
  3. Bundle resolver needed explicit precedence rules to avoid ambiguous store selection when multiple auth persistence controls are set.
- **Fix applied**
  1. Implemented command-hook store model and shell runner abstraction.
  2. Added injectable command runner and contract tests with deterministic fake runner assertions.
  3. Added explicit command->file->noop resolver precedence in bundle auth store builder.
- **Post-fix validation criteria**
  - remote-stub auth snapshot load/save can be driven by command hooks for secure-store bridge integration.
  - command-hook path is regression-covered without depending on real shell/environment side effects.
  - full verification gate (`desktop:verify:full`) remains green after command-hook bridge integration.

## Unit WS-D-119: Launch-argument deep-link/window-route parser baseline

### Planned objective

Reduce desktop shell route-interoperability gap by introducing a deterministic launch-argument parser for section-route deep links, so native app launches can map protocol/route payloads into Flutter shell initial navigation without manual environment toggles.

### Implemented changes

1. Added launch-route parser bridge in `desktop/lib/main.dart`:
   - switched bootstrap entrypoint to `main(List<String> args)`,
   - introduced `resolveInitialSectionId(...)` as canonical section-route resolver,
   - added parser support for:
     - `--penjar-section=<section-id>`,
     - `--penjar-route=<route-or-uri>`,
     - direct `penjar://...` route arguments.
2. Added route normalization and validation:
   - introduced known-section ID validation against `kSections` to reject unknown route payloads,
   - parser now supports host/path/query route forms (for example `penjar://section/auth`, `penjar://open?section=inspect`, `/workspace/section/export`).
3. Wired parser output into shell initialization:
   - `PenjarDesktopApp` now receives parser-resolved initial section from entrypoint,
   - existing `PENJAR_DESKTOP_INITIAL_SECTION` environment fallback remains preserved when launch args are absent/invalid.
4. Expanded regression coverage in `desktop/test/widget_test.dart`:
   - `resolveInitialSectionId prioritizes launch args over env section`,
   - `resolveInitialSectionId parses penjar deep-link routes`,
   - `desktop shell honors launch route parser output`.
5. Re-ran validation commands:
   - `cd desktop && flutter test test/widget_test.dart test/parity/shell_contract_persistence_parity_test.dart`,
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - launch-time deep-link section-route parsing correctness across argument forms,
  - compatibility with existing section restoration and env-seeded startup behavior,
  - non-regression of shell parity flows and full desktop verification chain.
- **Issues found during review**
  1. Shell startup route override relied on compile-time env (`PENJAR_DESKTOP_INITIAL_SECTION`) only, which is not suitable for runtime protocol/launch payload handoff.
  2. Route payload shapes vary (CLI flag, URI host/path, query-based section key), requiring a single deterministic parser to avoid divergent startup behavior.
  3. Unknown/invalid route payloads needed strict validation to prevent invalid navigation state initialization.
- **Fix applied**
  1. Added a centralized launch-route parser with deterministic precedence (launch args first, env fallback second).
  2. Implemented URI/path/query parsing coverage for `penjar://...` and `--penjar-route=...` payload forms.
  3. Enforced section allowlist validation against shell section catalog before applying startup route.
- **Post-fix validation criteria**
  - desktop shell can initialize from protocol/route launch arguments in a deterministic, test-covered way.
  - invalid launch-route payloads fall back safely without corrupting initial shell state.
  - parity persistence behavior and full verification gate remain green after launch-route parser integration.

## Unit WS-D-120: macOS deep-link protocol registration and host route channel bridge

### Planned objective

Advance deep-link/window-route interoperability beyond launch-argument parsing by wiring macOS `penjar://` protocol events into Flutter runtime through a host route channel, so app-open deep links can update shell section state in both startup and running-app scenarios.

### Implemented changes

1. Added host launch-route channel handling in `desktop/lib/main.dart`:
   - introduced channel constant `penjar/desktop/launch_route`,
   - `DesktopShellPage` now:
     - calls `consumeLaunchRoute` during init,
     - subscribes to host-pushed `onLaunchRoute` method calls,
     - reuses section-route parser to apply validated section navigation updates.
2. Added macOS host bridge in runner code:
   - `desktop/macos/Runner/AppDelegate.swift`:
     - introduced `DesktopLaunchRouteBridge`,
     - handles `application(_:open:)` URL events and forwards route to channel,
     - supports pending-route consumption via `consumeLaunchRoute`.
   - `desktop/macos/Runner/MainFlutterWindow.swift`:
     - configures launch-route bridge channel using Flutter binary messenger at startup.
3. Added macOS URL-scheme registration:
   - `desktop/macos/Runner/Info.plist` now includes `CFBundleURLTypes` for `penjar` scheme.
4. Expanded regression coverage:
   - `desktop/test/widget_test.dart`:
     - added `desktop shell consumes pending launch route from host channel`.
5. Re-ran validation commands:
   - `cd desktop && flutter test test/widget_test.dart`,
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - channel-based host route delivery correctness (`consumeLaunchRoute` + `onLaunchRoute`),
  - macOS runner integration correctness (URL event capture + channel dispatch + URL scheme registration),
  - non-regression of shell route restoration and desktop verification chain.
- **Issues found during review**
  1. Initial channel-consumption widget test asserted a non-existent auth panel key (`auth-panel`), producing a false-negative test failure.
  2. Host bridge needed graceful no-plugin handling in Dart test/non-native contexts.
  3. URL event delivery required both protocol registration and runtime channel bridge; either one alone leaves partial behavior.
- **Fix applied**
  1. Corrected widget assertion key to `auth-session-panel`.
  2. Added `MissingPluginException`/`PlatformException` guards around channel consumption path.
  3. Implemented macOS URL-scheme registration + AppDelegate/MainFlutterWindow channel bridge wiring as a single unit.
- **Post-fix validation criteria**
  - macOS deep-link URL events can be forwarded to Flutter shell route handling through a test-covered channel contract.
  - startup and runtime shell section updates preserve existing route-validation safeguards.
  - full verification gate (`desktop:verify:full`) remains green after macOS runner/channel integration.

## Unit WS-D-121: Host-pushed route event regression coverage and route-apply no-op guard

### Planned objective

Harden the newly added host launch-route channel path by adding explicit runtime `onLaunchRoute` event regression coverage and reducing unnecessary rebuild churn when host-pushed routes resolve to the currently selected section.

### Implemented changes

1. Added route-apply performance guard in `desktop/lib/main.dart`:
   - `_applyLaunchRoute(...)` now computes target section index once and exits early when current index already matches target.
2. Expanded host-channel runtime coverage in `desktop/test/widget_test.dart`:
   - added `desktop shell applies host-pushed launch route events`,
   - test injects `onLaunchRoute` platform message on `penjar/desktop/launch_route` and verifies live section switch.
3. Preserved existing host launch-route path coverage:
   - pending route pull (`consumeLaunchRoute`) test remains in place.
4. Re-ran validation commands:
   - `cd desktop && flutter test test/widget_test.dart`,
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - host channel runtime push path correctness (`onLaunchRoute` platform message handling),
  - route-apply behavior under repeated/same-section events,
  - non-regression of desktop shell and full verification chain.
- **Issues found during review**
  1. Existing tests covered pending-route consumption but did not assert live host-push event handling path.
  2. Route application always triggered `setState` even when target route matched current section, causing avoidable rebuild work.
- **Fix applied**
  1. Added explicit runtime host-push event widget regression test.
  2. Added same-index short-circuit in `_applyLaunchRoute(...)`.
- **Post-fix validation criteria**
  - host-pushed `onLaunchRoute` events are validated in automated tests.
  - repeated/same-section route events no longer trigger unnecessary state updates.
  - full verification gate remains green after route-event hardening.

## Unit WS-D-122: flutter_secure_storage-backed native auth snapshot adapter path

### Planned objective

Advance auth/session persistence from command/file bridge paths to first-class native credential-store integration by adding a flutter_secure_storage-backed remote-stub auth state adapter that supports secure startup preload and persisted snapshot writes without breaking the current synchronous contract surface.

### Implemented changes

1. Added secure snapshot auth-state adapter in `desktop/lib/contracts/remote_stub_contracts.dart`:
   - introduced `RemoteStubSecureSnapshotAuthStateStore`,
   - store model:
     - synchronous `load()` from cached startup snapshot,
     - `save()` updates cache immediately and persists snapshot JSON asynchronously via injected writer callback.
2. Extended bundle environment loading in `desktop/lib/contracts/desktop_contract_bundle.dart`:
   - added secure-store env controls:
     - `PENJAR_DESKTOP_REMOTE_STUB_AUTH_SECURE_STORAGE_ENABLED`,
     - `PENJAR_DESKTOP_REMOTE_STUB_AUTH_SECURE_STORAGE_KEY` (optional key override),
   - added async builder path using `flutter_secure_storage`,
   - added `DesktopContractBundle.loadFromEnvironment(...)` for async startup bootstrap.
3. Updated app startup in `desktop/lib/main.dart`:
   - `main(...)` now performs async initialization (`WidgetsFlutterBinding.ensureInitialized()` + `DesktopContractBundle.loadFromEnvironment()`),
   - app now starts with preloaded secure-store snapshot when secure-store mode is enabled.
4. Added/expanded regression coverage:
   - `desktop/test/contracts/workflow_contracts_test.dart`:
     - `secure snapshot auth state store caches state and writes asynchronously`,
     - `secure snapshot auth state store ignores writer failures`,
   - `desktop/test/contracts/desktop_contract_bundle_test.dart`:
     - `remote-stub bundle supports secure auth state store seam`.
5. Added plugin dependency + generated platform wiring:
   - `desktop/pubspec.yaml` + `desktop/pubspec.lock` include `flutter_secure_storage`,
   - generated macOS/Windows plugin registrant files and CocoaPods workspace/project files updated.
6. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/workflow_contracts_test.dart test/contracts/desktop_contract_bundle_test.dart test/widget_test.dart`,
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - secure-store adapter correctness under synchronous contract constraints,
  - async startup bootstrap safety and compatibility with existing mode/env controls,
  - plugin integration regressions across desktop verification chain.
- **Issues found during review**
  1. Initial secure-store seam test used `refreshToken` expectation inconsistent with delegate-state behavior after snapshot preload and failed on expected status.
  2. Analyzer failed with `unnecessary_underscores` in async writer error callback path.
  3. Native plugin integration required generated platform project/registrant updates to keep macOS/Windows builds consistent.
- **Fix applied**
  1. Reworked secure-store seam test to assert persistence via explicit `signIn` transition.
  2. Normalized callback parameter naming in async error handler to satisfy analyzer.
  3. Applied generated plugin/Pod/Xcode workspace updates after dependency integration.
- **Post-fix validation criteria**
  - remote-stub auth snapshot path can preload from and persist to native secure storage through flutter_secure_storage seam.
  - secure-store write failures do not break in-memory auth-state continuity.
  - full verification gate (`desktop:verify:full`) remains green with plugin-enabled desktop workspace.

## Unit WS-D-123: Remote profile auth-store mode visibility hardening

### Planned objective

Improve secure-store rollout observability by exposing active auth snapshot persistence mode in remote profile diagnostics (`auth-store` label), so runtime verification can clearly distinguish noop/file/command/secure-store paths during degraded-path reviews.

### Implemented changes

1. Extended remote profile model in `desktop/lib/contracts/desktop_contract_bundle.dart`:
   - added `authStoreLabel` field to `DesktopRemoteStubProfile`,
   - updated `isEmpty`/`summaryLabel` handling to include auth-store metadata.
2. Added auth-store descriptor mapping:
   - `_describeAuthStateStore(...)` now maps store type to profile label:
     - `secure-storage`,
     - `command-hook`,
     - `file`,
     - empty for noop.
3. Wired auth-store metadata through profile builder/factory flow:
   - `_buildRemoteStubProfile(...)` now receives `authStateStore`,
   - fromMode/remoteStub default profile generation now includes auth-store label context.
4. Expanded regression coverage:
   - `desktop/test/contracts/desktop_contract_bundle_test.dart`:
     - added `remote-stub profile exposes auth store label for secure store`.
5. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/desktop_contract_bundle_test.dart test/contracts/workflow_contracts_test.dart`,
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - remote profile metadata correctness for auth-store mode classification,
  - compatibility with existing profile summary/emptiness semantics,
  - non-regression of contract/parity/build verification chain.
- **Issues found during review**
  1. Secure-store path activation had no explicit runtime profile signal, increasing troubleshooting time when validating rollout environments.
  2. Profile summary visibility focused on transport/fault dimensions only, leaving auth persistence mode opaque.
- **Fix applied**
  1. Added auth-store labeling into profile model and summary rendering.
  2. Threaded auth-state-store instance into default profile builder path and validated secure-store label via unit test.
- **Post-fix validation criteria**
  - runtime remote profile summary includes auth-store mode when non-noop persistence is active.
  - default noop path remains profile-empty to avoid noise in baseline in-memory/remote-stub diagnostics.
  - full verification gate remains green after profile metadata extension.

## Unit WS-D-124: Windows running-instance launch-route relay baseline

### Planned objective

Reduce cross-platform deep-link interoperability gap by adding Windows running-instance launch-route relay handling so secondary launches with Penjar route payloads can hand off route context to an already running desktop shell instance.

### Implemented changes

1. Added Windows launch-route extraction/relay logic in `desktop/windows/runner/main.cpp`:
   - extracts route payload from:
     - `--penjar-route=...`,
     - `--penjar-section=...` (normalized to `penjar://section/<id>`),
     - direct `penjar://...` argument.
   - detects existing app window (`Penjar Desktop`) and relays route via `WM_COPYDATA`.
2. Added running-instance route ingestion in `desktop/windows/runner/flutter_window.cpp`:
   - handles `WM_COPYDATA` payloads with route relay marker,
   - forwards route into Flutter runtime via method channel call:
     - channel: `penjar/desktop/launch_route`,
     - method: `onLaunchRoute`.
3. Kept Dart-side host event handling path unchanged but exercised through existing channel route tests/verification chain.
4. Re-ran validation command:
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - Windows secondary-launch route extraction and relay behavior,
  - host->Flutter route forwarding compatibility with existing launch-route channel contract,
  - non-regression of desktop verification chain after runner updates.
- **Issues found during review**
  1. Windows deep-link path had no running-instance route handoff baseline after macOS protocol/channel integration.
  2. Secondary launches with route payload risked opening disconnected new flows without explicit relay path.
- **Fix applied**
  1. Implemented route extraction + existing-window relay via `WM_COPYDATA` in main runner startup path.
  2. Implemented `WM_COPYDATA` handling in Flutter window host and route-forward channel invocation (`onLaunchRoute`).
- **Post-fix validation criteria**
  - Windows running instance can receive relayed route payload and forward it to Flutter channel handling path.
  - route relay baseline aligns with existing Dart launch-route parser and host-channel event contract.
  - full verification gate remains green after Windows runner relay integration.

## Unit WS-D-125: Secure-store rollout hardening with strict/fallback and legacy mirror controls

### Planned objective

Harden secure credential-store rollout by adding explicit strict/fallback policy and optional legacy mirror-write mode for remote-stub auth snapshots, enabling phased migration from command/file persistence paths to secure storage with reduced rollback risk.

### Implemented changes

1. Added composite auth-store primitive in `desktop/lib/contracts/remote_stub_contracts.dart`:
   - introduced `RemoteStubCompositeAuthStateStore(primary, secondary)`,
   - load strategy: primary-first with secondary fallback,
   - save strategy: mirrored write to both stores.
2. Extended secure-store async resolver in `desktop/lib/contracts/desktop_contract_bundle.dart`:
   - secure-store path now builds from existing legacy resolver baseline (`command`/`file`/`noop`) and supports:
     - strict mode: `PENJAR_DESKTOP_REMOTE_STUB_AUTH_SECURE_STORAGE_STRICT`,
     - legacy mirror mode: `PENJAR_DESKTOP_REMOTE_STUB_AUTH_SECURE_STORAGE_MIRROR_LEGACY`.
   - when secure read fails:
     - non-strict mode falls back to legacy store,
     - strict mode keeps secure store path active.
   - mirror mode composes secure + legacy via `RemoteStubCompositeAuthStateStore`.
3. Extended remote profile auth-store labeling:
   - composite secure+legacy mirror path now surfaces as `secure-storage+legacy-mirror`.
4. Expanded regression coverage:
   - `desktop/test/contracts/workflow_contracts_test.dart`:
     - added `composite auth state store falls back to secondary load and mirrors save`,
   - `desktop/test/contracts/desktop_contract_bundle_test.dart`:
     - added `remote-stub profile exposes auth store mirror label`.
5. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/workflow_contracts_test.dart test/contracts/desktop_contract_bundle_test.dart`,
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - secure-store rollout resiliency under storage-read failures,
  - mirrored write continuity with legacy persistence during migration,
  - profile-level visibility of migration mode and non-regression of full verification chain.
- **Issues found during review**
  1. Secure-store enablement had limited policy control when initial secure read failed (all-or-nothing behavior).
  2. Migration path lacked built-in dual-write option for safe transition away from legacy command/file stores.
- **Fix applied**
  1. Added strict/fallback policy controls in async secure-store resolver.
  2. Added composite auth-state store for secure+legacy mirror migration mode.
  3. Added diagnostic label for mirror mode to improve runtime rollout observability.
- **Post-fix validation criteria**
  - secure-store rollout can choose strict vs fallback behavior on startup read failures.
  - mirror migration mode keeps secure and legacy snapshots synchronized through shared save path.
  - full verification gate remains green after secure-store hardening extension.

## Unit WS-D-126: Windows protocol-registration command hook baseline for installer pipeline

### Planned objective

Close the remaining Windows deep-link packaging gap by adding protocol-registration command-hook support into the Windows installer pipeline baseline so release-time validation/reporting can track URL-scheme registration readiness in the same strict placeholder-hygiene flow as signing/installer/provenance hooks.

### Implemented changes

1. Extended Windows installer pipeline command surface in `desktop/scripts/run_windows_installer_pipeline.sh`:
   - added protocol hook env controls:
     - `PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND`,
     - `PENJAR_WINDOWS_PROTOCOL_SCHEME` (default `penjar`),
     - `PENJAR_WINDOWS_PROTOCOL_TARGET_PATH` (default runner executable path),
   - added placeholder-hygiene detection + strict-mode failure policy for protocol hook command,
   - added protocol registration status/error fields to generated pipeline report.
2. Updated signing-readiness diagnostics inventory in `desktop/scripts/check_signing_readiness.sh`:
   - added command-hook readiness row for `PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND`.
3. Updated release-validation baseline in `docs/technical-guide/developer/desktop-flutter-release-validation-baseline.md`:
   - documented optional protocol registration command hook and override envs in Windows release flow,
   - expanded backlog seed wording from installer/provenance-only to installer/provenance/protocol-registration wiring.
4. Updated continuity docs for cross-document state alignment:
   - `desktop-flutter-development-runbook.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`.
5. Re-ran validation commands:
   - `pnpm run desktop:release:windows-installer:run`,
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - Windows installer pipeline command-hook completeness for deep-link protocol registration,
  - strict placeholder-hygiene behavior and report diagnostics parity,
  - continuity-document consistency for remaining-gap tracking.
- **Issues found during review**
  1. Windows installer pipeline baseline tracked installer/provenance hooks only, leaving protocol registration outside strict/reported command-hook governance.
  2. Signing readiness report omitted protocol registration command visibility, creating release-audit blind spots.
  3. Continuity documents still treated protocol registration as entirely pending despite hook-baseline implementation.
- **Fix applied**
  1. Added protocol command hook execution path with strict failure/warning behavior and report fields in installer pipeline script.
  2. Added protocol command-hook row in signing-readiness diagnostics output.
  3. Synchronized runbook/inventory/checklist/acceptance-baseline wording to reflect baseline completion plus remaining real-command provisioning gap.
- **Post-fix validation criteria**
  - Windows installer pipeline now reports protocol registration command configuration/execution status in release report output.
  - strict mode now fails when protocol command is placeholder/failed (same governance level as installer hook).
  - remaining gaps now focus on real production command wiring rather than missing baseline protocol-hook surface.

## Unit WS-D-127: Secure-store default-on rollout and auth-store diagnostics telemetry baseline

### Planned objective

Advance remote-stub auth persistence migration by promoting flutter_secure_storage rollout to default-on mode, while preserving explicit legacy opt-out and improving diagnostics visibility of rollout/fallback state through profile auth-store labeling.

### Implemented changes

1. Added secure-store rollout mode parser in `desktop/lib/contracts/desktop_contract_bundle.dart`:
   - introduced `RemoteStubSecureStorageRolloutMode` (`defaultOn`, `explicitOn`, `explicitOff`),
   - env parser now treats empty `PENJAR_DESKTOP_REMOTE_STUB_AUTH_SECURE_STORAGE_ENABLED` as `defaultOn`.
2. Hardened async auth-store resolver and profile labeling flow:
   - refactored async resolver to return both selected store + diagnostics label,
   - default-on/explicit-on secure-store paths now surface rollout suffix labels in remote profile (`auth-store`),
   - secure read error in non-strict mode now falls back to legacy store with explicit fallback label,
   - explicit opt-out path (`..._SECURE_STORAGE_ENABLED=false`) now reports disabled rollout label.
3. Extended profile builder seam:
   - `_buildRemoteStubProfile(...)` now accepts auth-store label override so runtime profile diagnostics reflect rollout decision state, not only store type.
4. Added rollout parser regression coverage:
   - `desktop/test/contracts/desktop_contract_bundle_test.dart`:
     - `secure storage rollout mode parser defaults on and supports explicit opt-out`.
5. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/desktop_contract_bundle_test.dart test/contracts/workflow_contracts_test.dart`,
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - default-on secure-store rollout behavior under env unset/explicit toggle conditions,
  - fallback safety when secure-store startup read fails in non-strict mode,
  - diagnostics visibility of rollout/fallback/degradation state for runtime troubleshooting.
- **Issues found during review**
  1. Secure-store adoption still required explicit enable flag, leaving migration default state on legacy command/file/noop paths.
  2. Runtime profile diagnostics exposed store type only, without rollout-policy/fallback context.
  3. Legacy fallback from secure read failures had no explicit profile marker, reducing incident triage clarity.
- **Fix applied**
  1. Added rollout-mode parser with default-on semantics for secure-store enablement.
  2. Added resolver result object carrying profile auth-store override label and wired it into `loadFromEnvironment(...)`.
  3. Added reason-labeled legacy fallback/disabled labels and rollout suffixes for secure-store paths.
  4. Added parser regression tests and verified full desktop chain.
- **Post-fix validation criteria**
  - `PENJAR_DESKTOP_REMOTE_STUB_AUTH_SECURE_STORAGE_ENABLED` unset now resolves secure-store rollout by default.
  - explicit opt-out (`false`/`off`) keeps legacy auth-store path active with diagnostics label clarity.
  - fallback from secure read failures in non-strict mode is visible through profile auth-store labeling.
  - full verification gate remains green after rollout-policy and diagnostics updates.

## Unit WS-D-128: Desktop document continuity coupling matrix and release-linkage hardening

### Planned objective

Reduce documentation handoff gaps by explicitly codifying document-to-document coupling rules for desktop Flutter implementation/release work, so parity/release records remain synchronized during long-running autonomous execution.

### Implemented changes

1. Added desktop continuity coupling matrix in `docs/technical-guide/developer/web-mcp-documentation-map.md`:
   - mapped trigger document updates to required companion artifacts (execution log, runbook, checklist, migration inventory, acceptance baseline, release validation/evidence docs).
2. Hardened release evidence index linkage in `docs/technical-guide/developer/desktop-flutter-release-evidence-index.md`:
   - expanded related artifacts to include documentation map + parity/migration/acceptance docs,
   - added explicit continuity linkage protocol for synchronized updates across release validation + execution log + parity/migration docs.
3. Aligned release validation artifact graph in `docs/technical-guide/developer/desktop-flutter-release-validation-baseline.md`:
   - added direct related-artifact link to parity checklist for clearer release-to-parity traceability.
4. Re-ran validation command:
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - document graph completeness across desktop implementation/parity/release artifacts,
  - update-order clarity needed for autonomous multi-unit execution without handoff drift.
- **Issues found during review**
  1. Release evidence and validation docs were linked, but update coupling rules were implicit and prone to omission under rapid unit iterations.
  2. Documentation map lacked a concrete trigger-to-companion matrix for desktop-specific artifact synchronization.
  3. Release validation related-artifact list did not directly surface parity checklist linkage.
- **Fix applied**
  1. Added explicit coupling matrix to documentation map.
  2. Added continuity linkage protocol and broader artifact links to release evidence index.
  3. Added parity checklist link to release validation baseline for direct trace path.
- **Post-fix validation criteria**
  - desktop doc updates now have explicit companion-update rules for implementation and release flows.
  - release evidence/validation/parity/migration documents now form a directly navigable continuity loop.
  - full desktop verification chain remains green after documentation coupling updates.

## Unit WS-D-129: Legacy auth-store retirement strict-enforcement control baseline

### Planned objective

Introduce enforceable retirement control for legacy command/file auth-store fallback paths so secure-store rollout can be hardened before full legacy-path removal, even when fallback or explicit secure-store opt-out flags are present.

### Implemented changes

1. Added legacy retirement mode control in `desktop/lib/contracts/desktop_contract_bundle.dart`:
   - introduced `RemoteStubLegacyAuthStoreRetirementMode` (`allowLegacy`, `enforceSecure`),
   - added env parser for `PENJAR_DESKTOP_REMOTE_STUB_AUTH_LEGACY_RETIREMENT_STRICT`.
2. Hardened async auth-store resolver behavior:
   - when retirement strict mode is enabled, secure-store path is enforced even if:
     - `PENJAR_DESKTOP_REMOTE_STUB_AUTH_SECURE_STORAGE_ENABLED=false`,
     - secure-store startup read fails in non-strict mode.
   - profile auth-store labels now include retirement/read-error suffixes when strict retirement enforcement overrides legacy fallback/disable behavior.
3. Added parser regression coverage:
   - `desktop/test/contracts/desktop_contract_bundle_test.dart`:
     - `legacy auth-store retirement mode parser supports strict toggle`.
4. Updated continuity docs for parity/migration tracking:
   - `desktop-flutter-development-runbook.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`.
5. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/desktop_contract_bundle_test.dart test/contracts/workflow_contracts_test.dart`,
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - enforceability of legacy fallback retirement policy under secure-store read failures and explicit opt-out flags,
  - diagnostics visibility when retirement enforcement overrides configured legacy path.
- **Issues found during review**
  1. Legacy fallback remained available in non-strict secure-store read-error scenarios, delaying hardening before path removal.
  2. Explicit secure-store opt-out could still keep legacy path active even during retirement-hardening phases.
  3. Existing diagnostics lacked explicit marker when secure-store path was enforced by retirement policy.
- **Fix applied**
  1. Added retirement strict mode parser + control path.
  2. Applied retirement enforcement to both explicit-disable and read-error fallback branches.
  3. Added profile label suffixes for retirement-enforced and read-error-secure scenarios.
- **Post-fix validation criteria**
  - retirement strict mode can force secure-store path regardless of legacy disable/fallback triggers.
  - runtime profile auth-store labels surface retirement-enforcement state for troubleshooting.
  - contract tests and full desktop verification chain remain green after enforcement baseline integration.

## Unit WS-D-130: Windows protocol-registration strict release gate policy integration

### Planned objective

Harden Windows deep-link release readiness by introducing strict protocol-registration gate controls across installer pipeline, release smoke gate policy checks, and workflow dispatch wiring, so missing/failing protocol registration commands are explicitly blockable in strict release paths.

### Implemented changes

1. Extended Windows installer pipeline strict controls in `desktop/scripts/run_windows_installer_pipeline.sh`:
   - added `STRICT_WINDOWS_PROTOCOL_REGISTRATION` handling,
   - strict protocol mode now fails when:
     - runner directory is missing for protocol stage,
     - protocol register command is missing,
     - protocol register command is placeholder,
     - protocol register command execution fails.
   - added strict protocol mode visibility in pipeline report output.
2. Extended release smoke gate policy checks:
   - `desktop/scripts/check_release_smoke_gate_policy.sh` now includes `STRICT_WINDOWS_PROTOCOL_REGISTRATION`,
   - added required dependency:
     - `STRICT_WINDOWS_PROTOCOL_REGISTRATION=1` -> `STRICT_WINDOWS_INSTALLER_EXECUTION=1`,
   - extended strict evidence bundle dependency:
     - `STRICT_RELEASE_EVIDENCE_BUNDLE=1` now also requires `STRICT_WINDOWS_PROTOCOL_REGISTRATION=1`.
3. Extended gate policy contract coverage in `desktop/scripts/check_release_smoke_gate_policy_contract.sh`:
   - added failure case for strict protocol gate without strict installer execution,
   - updated full strict profile case to include strict protocol gate.
4. Wired workflow-dispatch control + secret propagation in `.github/workflows/release-desktop-installer-smoke.yml`:
   - added input: `enforce_windows_protocol_registration`,
   - propagated `STRICT_WINDOWS_PROTOCOL_REGISTRATION` to gate-policy + installer smoke jobs,
   - propagated `PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND` secret into signing-readiness and installer smoke jobs.
5. Updated continuity docs for release/parity/migration alignment:
   - `desktop-flutter-release-validation-baseline.md`,
   - `desktop-flutter-development-runbook.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`.
6. Re-ran validation commands:
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - protocol registration strictness behavior in installer pipeline,
  - release smoke gate-policy dependency correctness and regression-contract coverage,
  - workflow input/secret propagation consistency for protocol registration command hooks.
- **Issues found during review**
  1. Protocol registration command path existed, but strict release policy lacked a dedicated enforceable gate toggle.
  2. Gate-policy contract coverage did not assert protocol strictness dependency shape.
  3. Workflow dispatch and signing-readiness wiring did not fully propagate protocol registration controls/secrets.
- **Fix applied**
  1. Added strict protocol gate mode and failure conditions in installer pipeline script.
  2. Added protocol gate dependency checks + contract regression case.
  3. Added workflow input/env/secret wiring for protocol registration strict path.
  4. Synchronized release/parity/migration/runbook docs with strict protocol control baseline.
- **Post-fix validation criteria**
  - strict protocol registration gate can block release-smoke flow when protocol command readiness/execution is invalid.
  - gate-policy contract now covers protocol strictness dependency regressions.
  - workflow dispatch supports explicit protocol strictness control and secret wiring.
  - full desktop verification chain remains green after policy integration.

## Unit WS-D-131: Windows protocol-registration helper script baseline

### Planned objective

Provide an executable baseline template for Windows URL protocol registration so production command-hook provisioning can adopt a shared, reviewable script instead of ad-hoc inline registry commands.

### Implemented changes

1. Added helper script `desktop/scripts/register_windows_protocol.ps1`:
   - registers protocol under `HKCU\\Software\\Classes\\<scheme>`,
   - validates target executable path before registration,
   - supports env-driven overrides:
     - `PENJAR_WINDOWS_PROTOCOL_SCHEME`,
     - `PENJAR_WINDOWS_PROTOCOL_TARGET_PATH`,
   - writes launch command format:
     - `"<target>" "%1"`.
2. Updated release/parity continuity docs:
   - `desktop-flutter-release-validation-baseline.md`,
   - `desktop-flutter-development-runbook.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`,
   to include helper-script baseline references.
3. Re-ran validation command:
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - helper-script safety and portability for command-hook adoption,
  - document traceability for production protocol provisioning workflows.
- **Issues found during review**
  1. Protocol registration hook existed but lacked a canonical script template, increasing risk of one-off registry command drift.
  2. Release/parity docs referenced command-hook controls without a concrete baseline script artifact.
- **Fix applied**
  1. Added PowerShell helper script with input validation and deterministic HKCU registration path.
  2. Added helper-script references across release/parity/migration/runbook docs.
- **Post-fix validation criteria**
  - teams now have a canonical script baseline for `PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND` wiring.
  - documentation now links strict protocol gate + command hook + helper script in one traceable chain.
  - full desktop verification chain remains green after helper baseline addition.

## Unit WS-D-132: Conditional protocol hook enforcement in signing readiness strict mode

### Planned objective

Prevent over-enforcement regressions by making Windows protocol register command-hook strictness conditional on protocol strict gate intent, so generic strict signing-command-hook checks remain compatible when protocol registration is not explicitly enforced.

### Implemented changes

1. Updated signing-readiness checker in `desktop/scripts/check_signing_readiness.sh`:
   - added protocol strict input support:
     - `STRICT_WINDOWS_PROTOCOL_REGISTRATION` (or fifth positional argument),
   - protocol command hook category is now:
     - `command-hook` when protocol strict mode is enabled,
     - `optional-command-hook` when protocol strict mode is disabled.
2. Updated release smoke workflow wiring in `.github/workflows/release-desktop-installer-smoke.yml`:
   - signing-readiness step now passes `STRICT_WINDOWS_PROTOCOL_REGISTRATION` input value to readiness checker.
3. Updated release validation docs:
   - `desktop-flutter-release-validation-baseline.md` now documents conditional protocol-hook requirement semantics for signing readiness.
4. Re-ran validation command:
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - strict command-hook enforcement compatibility between signing-readiness and protocol strict gate,
  - workflow env propagation correctness for conditional protocol-hook enforcement.
- **Issues found during review**
  1. Protocol command hook could be treated as globally strict-required under strict command-hook mode, even when protocol strict gate was not intended.
  2. Signing-readiness workflow step did not pass protocol strict toggle, preventing context-aware requirement handling.
- **Fix applied**
  1. Added conditional category handling for protocol command hook in readiness checker.
  2. Propagated protocol strict input into workflow signing-readiness step.
  3. Updated release validation baseline wording to match conditional enforcement behavior.
- **Post-fix validation criteria**
  - strict signing command-hook mode no longer over-requires protocol hook unless protocol strict gate is enabled.
  - protocol strict enforcement still requires protocol command hook through signing-readiness + gate-policy chain.
  - full desktop verification chain remains green after conditional-enforcement adjustment.

## Unit WS-D-133: Legacy auth-store hard-removal guard automation baseline

### Planned objective

Prepare command/file auth-store hard removal execution by adding an explicit decommission guard + contract gate into desktop verification so legacy auth-store inputs can be policy-blocked before physical path removal.

### Implemented changes

1. Added legacy decommission guard script `desktop/scripts/check_auth_store_legacy_decommission.sh`:
   - supports strict mode `STRICT_AUTH_STORE_LEGACY_DECOMMISSION=1`,
   - enforces in strict mode:
     - `PENJAR_DESKTOP_REMOTE_STUB_AUTH_LEGACY_RETIREMENT_STRICT=1` required,
     - rejects legacy auth-store inputs:
       - `PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_PATH`,
       - `PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_LOAD_COMMAND`,
       - `PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_SAVE_COMMAND`,
       - `PENJAR_DESKTOP_REMOTE_STUB_AUTH_SECURE_STORAGE_MIRROR_LEGACY=1`.
2. Added contract coverage `desktop/scripts/check_auth_store_legacy_decommission_contract.sh`:
   - baseline pass,
   - strict pass (no legacy inputs),
   - strict fail cases for legacy path/commands/mirror and missing retirement strict flag.
3. Integrated guard into verification chain:
   - `desktop/scripts/verify_desktop.sh` now runs:
     - legacy decommission check,
     - legacy decommission contract check.
4. Added root command entrypoints in `package.json`:
   - `desktop:auth-store:legacy-decommission:check`,
   - `desktop:auth-store:legacy-decommission:contract:check`.
5. Updated continuity docs:
   - `desktop-flutter-development-runbook.md` command inventory + next-unit wording,
   - `desktop-flutter-release-validation-baseline.md` operating protocol + CI verify-script note,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`.
6. Re-ran validation commands:
   - `pnpm run desktop:verify:full`.

### Unit review (detailed)

- **Review scope**
  - legacy auth-store removal readiness policy coverage,
  - contract regression protection for strict decommission semantics,
  - verify-chain integration impact and non-regression.
- **Issues found during review**
  1. Legacy command/file auth-store hard-removal objective lacked an executable guard to block stale env-based legacy path usage.
  2. Existing runtime retirement strict mode enforcement lacked an independent policy/contract gate in release-time verification workflow.
  3. Verify chain did not provide dedicated report artifacts for legacy decommission readiness status.
- **Fix applied**
  1. Added dedicated legacy decommission checker with strict/advisory modes and report output.
  2. Added multi-case contract check script for strict policy regression detection.
  3. Wired both checks into `verify_desktop.sh` and root script inventory.
  4. Synchronized runbook/release/parity/migration docs to include new guard baseline.
- **Post-fix validation criteria**
  - strict legacy decommission mode fails when legacy auth-store inputs remain configured.
  - contract checker validates strict decommission dependency semantics and key fail scenarios.
  - full desktop verification chain remains green after guard integration.

## Unit WS-D-134: Legacy auth-store runtime physical decommission execution

### Planned objective

Execute physical runtime decommission for legacy command/file/mirror auth-store paths so remote-stub auth-store environment resolution no longer consumes those inputs, and promote decommission checks to strict verification baselines.

### Implemented changes

1. Updated auth-store runtime resolution in `desktop/lib/contracts/desktop_contract_bundle.dart`:
   - removed environment-based legacy auth-store resolution paths for:
     - `PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_PATH`,
     - `PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_LOAD_COMMAND`,
     - `PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_SAVE_COMMAND`,
     - `PENJAR_DESKTOP_REMOTE_STUB_AUTH_SECURE_STORAGE_MIRROR_LEGACY`,
     - `PENJAR_DESKTOP_REMOTE_STUB_AUTH_LEGACY_RETIREMENT_STRICT`.
   - `loadFromEnvironment` now resolves secure-store path directly (or noop fallback for explicit secure-storage disable / non-strict read-fallback) without legacy store composition.
2. Updated decommission guard semantics:
   - `desktop/scripts/check_auth_store_legacy_decommission.sh` strict mode now blocks legacy command/file/mirror env usage without requiring retirement strict flag.
   - `desktop/scripts/check_auth_store_legacy_decommission_contract.sh` now includes dedicated strict fail coverage for save-command legacy path.
3. Promoted strict decommission checks in verification chains:
   - `desktop/scripts/verify_desktop.sh` now runs decommission check with `STRICT_AUTH_STORE_LEGACY_DECOMMISSION=1`.
   - `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job now runs strict decommission check + contract check and uploads:
     - `desktop-auth-store-legacy-decommission-report-smoke`,
     - `desktop-auth-store-legacy-decommission-contract-report-smoke`.
4. Updated contract test expectations:
   - `desktop/test/contracts/desktop_contract_bundle_test.dart` removed legacy-retirement-mode parser assertions aligned with runtime decommission changes.
5. Updated continuity docs:
   - `desktop-flutter-development-runbook.md`,
   - `desktop-flutter-release-validation-baseline.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`.
6. Re-ran validation commands:
   - `cd desktop && ./scripts/check_auth_store_legacy_decommission_contract.sh`
   - `cd desktop && FLUTTER_NO_PUB=1 flutter test test/contracts/desktop_contract_bundle_test.dart`
   - `pnpm run desktop:verify:full`

### Unit review (detailed)

- **Review scope**
  - runtime decommission completeness for legacy auth-store env paths,
  - strictness consistency between local/CI verification chains and decommission guard semantics,
  - continuity document synchronization after runtime behavior shift.
- **Issues found during review**
  1. Runtime auth-store resolver still consumed legacy command/file/mirror env inputs despite decommission guard baseline.
  2. Strict decommission guard still depended on retirement strict flag, creating an unnecessary dependency after runtime physical decommission.
  3. Installer smoke signing-readiness baseline lacked dedicated decommission report artifacts.
- **Fix applied**
  1. Removed legacy command/file/mirror + retirement-strict env resolution from runtime auth-store environment path.
  2. Simplified strict decommission guard dependency to direct legacy-input rejection.
  3. Enabled strict decommission checks in `verify_desktop.sh` and smoke workflow signing-readiness job with artifact upload coverage.
  4. Updated runbook/release/parity/migration/acceptance docs for consistent runtime/verification status.
- **Post-fix validation criteria**
  - remote-stub auth-store runtime environment resolution no longer references legacy command/file/mirror env paths.
  - strict decommission checks fail on legacy inputs without additional retirement-flag dependencies.
  - local full verify and targeted auth-store contract tests remain green after decommission execution.

## Unit WS-D-135: Auth-store runtime decommission source-level regression guard

### Planned objective

Prevent legacy auth-store env-path regression by adding source-level runtime decommission checks (with contract coverage) into local verification and smoke CI signing-readiness flow.

### Implemented changes

1. Added runtime source-level decommission checker `desktop/scripts/check_auth_store_runtime_decommission.sh`:
   - scans runtime auth-store resolver source (`lib/contracts/desktop_contract_bundle.dart`) for retired legacy env tokens,
   - fails when any retired token is found,
   - outputs report artifact `release/reports/auth_store_runtime_decommission_report.md`.
2. Added contract checker `desktop/scripts/check_auth_store_runtime_decommission_contract.sh`:
   - baseline pass against current runtime source,
   - synthetic clean fixture pass,
   - synthetic legacy-token fixture fail.
3. Integrated into verification chain:
   - `desktop/scripts/verify_desktop.sh` now runs runtime decommission base + contract checks.
4. Added root command entrypoints in `package.json`:
   - `desktop:auth-store:runtime-decommission:check`,
   - `desktop:auth-store:runtime-decommission:contract:check`.
5. Integrated into smoke signing-readiness workflow:
   - `.github/workflows/release-desktop-installer-smoke.yml` now runs runtime decommission base + contract checks and uploads:
     - `desktop-auth-store-runtime-decommission-report-smoke`,
     - `desktop-auth-store-runtime-decommission-contract-report-smoke`.
6. Updated continuity docs:
   - `desktop-flutter-development-runbook.md`,
   - `desktop-flutter-release-validation-baseline.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`.
7. Re-ran validation commands:
   - `cd desktop && ./scripts/check_auth_store_runtime_decommission_contract.sh`
   - `pnpm run desktop:verify:full`

### Unit review (detailed)

- **Review scope**
  - regression resistance for runtime legacy auth-store decommission,
  - verification-chain and smoke workflow artifact continuity for decommission checks.
- **Issues found during review**
  1. Runtime decommission execution lacked a source-level guard, so legacy env keys could be reintroduced without immediate failure.
  2. Smoke signing-readiness baseline had no dedicated source-level decommission report coverage.
- **Fix applied**
  1. Added runtime source scanner + contract guard for retired legacy auth-store tokens.
  2. Wired base + contract checks into `verify_desktop.sh` and smoke signing-readiness workflow artifact path.
  3. Updated runbook/release/parity/migration/acceptance docs to include new command and CI/report continuity.
- **Post-fix validation criteria**
  - runtime auth-store source fails verification if retired legacy env tokens are reintroduced.
  - verify/smoke pipelines emit dedicated runtime decommission report artifacts.
  - full desktop verification chain remains green after guard integration.

## Unit WS-D-136: Backend auth alias normalization for token/session payloads

### Planned objective

Advance backend auth contract integration by normalizing common backend auth alias fields (`remember/session/auth/token` variants) into remote-stub auth state parsing so backend payload shapes map reliably to Flutter auth/session state.

### Implemented changes

1. Updated backend auth parser in `desktop/lib/contracts/remote_stub_contracts.dart`:
   - extended auth field recognition aliases:
     - remember aliases: `remember`, `persistSession`,
     - signed-in aliases: `isAuthenticated`, `authenticated`,
     - credential/session hints: `accessToken`, `token`, `sessionToken`, `refreshToken`, `sessionId`, `user`.
   - added explicit precedence rule:
     - explicit signed-out fields (`signedIn=false` / alias false) override token/session inferred signed-in state.
2. Added/updated contract tests in `desktop/test/contracts/workflow_contracts_test.dart`:
   - token/session alias payload infers signed-in state,
   - explicit signed-out backend payload overrides token/session aliases.
3. Updated continuity docs:
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`.
4. Re-ran validation commands:
   - `cd desktop && FLUTTER_NO_PUB=1 flutter test test/contracts/workflow_contracts_test.dart`
   - `pnpm run desktop:verify:full`

### Unit review (detailed)

- **Review scope**
  - backend auth payload compatibility breadth for common alias field shapes,
  - signed-in inference safety and explicit override correctness.
- **Issues found during review**
  1. Existing backend auth parser required narrow field names (`rememberSession`, `signedIn`) and ignored common token/session alias shapes.
  2. Credential-driven signed-in inference path needed explicit signed-out override guard to avoid false-positive sign-in state.
- **Fix applied**
  1. Added alias-aware field resolution + credential/user-hint inference in backend auth parser.
  2. Added explicit signed-out override precedence handling.
  3. Added dedicated contract tests for alias inference and explicit override behavior.
- **Post-fix validation criteria**
  - backend auth payloads using common alias/token/session fields now update auth state consistently.
  - explicit signed-out backend flags always override inferred signed-in state.
  - contract test suite and full desktop verification remain green after parser expansion.

## Unit WS-D-137: Nested backend auth payload alias normalization

### Planned objective

Extend backend auth compatibility beyond flat payload aliases by supporting nested backend auth/session/token envelopes, reducing schema-friction before full backend auth contract integration.

### Implemented changes

1. Expanded auth alias resolution in `desktop/lib/contracts/remote_stub_contracts.dart`:
   - added source-aware alias helpers across multiple nested maps.
   - added nested source extraction support from auth state payload:
     - `auth` / `authentication`,
     - `session` / `sessionState` / `sessionInfo`,
     - `tokens` / `tokenState` / `credentials`.
   - remember/signed-in alias resolution now scans nested sources,
   - credential/session inference now scans nested token/session sources,
   - explicit signed-out alias still takes precedence over token/session inference.
2. Added contract tests in `desktop/test/contracts/workflow_contracts_test.dart`:
   - nested auth/session/tokens payload alias normalization (restore-session path),
   - nested explicit signed-out alias override over token inference (refresh-token path).
3. Updated continuity docs:
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`.
4. Re-ran validation commands:
   - `cd desktop && FLUTTER_NO_PUB=1 flutter test test/contracts/workflow_contracts_test.dart`
   - `pnpm run desktop:verify:full`

### Unit review (detailed)

- **Review scope**
  - nested backend auth payload compatibility and alias coverage,
  - inference correctness for nested token/session hints versus explicit signed-out flags.
- **Issues found during review**
  1. Existing alias normalization focused on flat payload keys and missed common nested `authentication/session/tokens` layouts.
  2. Nested token/session payloads needed the same explicit signed-out override guarantees as flat payloads.
- **Fix applied**
  1. Added multi-source alias resolution helpers and nested source extraction in auth parser.
  2. Extended has-field/inference logic to include nested auth/session/token maps.
  3. Added dedicated nested-path contract tests for positive normalization and explicit override precedence.
- **Post-fix validation criteria**
  - nested backend auth/session/token payloads now normalize into auth state consistently.
  - explicit signed-out aliases continue to override inferred signed-in state in nested payloads.
  - targeted contract tests and full desktop verification remain green after nested normalization.

## Unit WS-D-138: Backend signed-out error-code normalization for auth state

### Planned objective

Close a backend auth integration gap where signed-out semantics are communicated through backend error codes (without explicit `signedIn=false` payload fields), ensuring auth state normalization remains accurate under token/session-expiry responses.

### Implemented changes

1. Extended auth parser code-signal handling in `desktop/lib/contracts/remote_stub_contracts.dart`:
   - added backend code extraction across payload layers:
     - `code`, `errorCode`, `reasonCode` from response/envelope/state.
   - added signed-out code detector normalization for common variants:
     - `AUTH_REQUIRED`, `UNAUTHORIZED`, `UNAUTHENTICATED`,
     - `TOKEN_EXPIRED`, `SESSION_EXPIRED`,
     - `INVALID_TOKEN`, `SIGNED_OUT`, `LOGGED_OUT`.
   - signed-in inference now applies signed-out error-code precedence when explicit signed-in alias is absent.
2. Added contract tests in `desktop/test/contracts/workflow_contracts_test.dart`:
   - signed-out error codes override token/session inference.
   - explicit signed-in state still overrides signed-out code when backend payload explicitly declares signed-in state.
3. Updated continuity docs:
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`.
4. Re-ran validation commands:
   - `cd desktop && FLUTTER_NO_PUB=1 flutter test test/contracts/workflow_contracts_test.dart`
   - `pnpm run desktop:verify:full`

### Unit review (detailed)

- **Review scope**
  - auth signed-out semantics when backend responses rely on error-code signaling,
  - precedence behavior between explicit signed-in fields and signed-out error-code hints.
- **Issues found during review**
  1. Signed-in inference from token/session hints could misclassify auth state when backend returned expiry/unauthorized codes without explicit `signedIn=false`.
  2. Code-signaled signed-out semantics needed to coexist with explicit signed-in field precedence for mixed payloads.
- **Fix applied**
  1. Added backend code extraction + signed-out code classification.
  2. Applied code-based signed-out precedence only when explicit signed-in alias is absent.
  3. Added targeted contract tests for both error-code override and explicit-state precedence.
- **Post-fix validation criteria**
  - auth parser now normalizes backend signed-out code signals into signed-out auth state when explicit signed-in fields are missing.
  - explicit signed-in backend fields remain authoritative over code-based fallback inference.
  - targeted contract tests and full desktop verification remain green after code-signal integration.

## Unit WS-D-139: Nested backend signed-out code precedence normalization

### Planned objective

Ensure signed-out error-code semantics remain consistent when backend error codes are provided inside nested auth payload structures, closing a remaining schema-compatibility gap for backend auth integration.

### Implemented changes

1. Extended backend-code extraction in `desktop/lib/contracts/remote_stub_contracts.dart`:
   - `_resolveBackendCodeValue(...)` now supports additional nested payload sources.
   - auth parser now passes nested auth/session/token sources into backend-code extraction.
2. Preserved precedence behavior:
   - explicit signed-in aliases remain authoritative,
   - nested signed-out code signals apply when explicit signed-in aliases are absent.
3. Added contract tests in `desktop/test/contracts/workflow_contracts_test.dart`:
   - nested signed-out error code overrides token inference,
   - nested explicit signed-in alias overrides nested signed-out code.
4. Re-ran validation commands:
   - `cd desktop && FLUTTER_NO_PUB=1 flutter test test/contracts/workflow_contracts_test.dart`
   - `pnpm run desktop:verify:full`

### Unit review (detailed)

- **Review scope**
  - nested error-code extraction coverage for auth normalization,
  - precedence stability between explicit auth aliases and nested code signals.
- **Issues found during review**
  1. Signed-out code extraction previously focused on response/envelope/state layers and could miss nested `authentication`/related payload code fields.
  2. Nested code-signal behavior needed dedicated contract coverage to prevent precedence regression.
- **Fix applied**
  1. Added nested payload support to backend-code extraction path.
  2. Added dedicated nested error-code precedence contract tests.
  3. Confirmed verify chain remains green after nested code extraction expansion.
- **Post-fix validation criteria**
  - nested signed-out backend codes now correctly participate in auth signed-in inference.
  - explicit signed-in aliases continue to override nested signed-out code hints.
  - targeted contract tests and full desktop verification remain green after nested code normalization.

## Unit WS-D-140: Backend auth error-container code normalization

### Planned objective

Close a backend auth compatibility gap where signed-out semantics are emitted through nested `error`/`errors` container payloads (object/list forms), ensuring the auth parser consistently applies signed-out code precedence.

### Implemented changes

1. Extended backend code extraction logic in `desktop/lib/contracts/remote_stub_contracts.dart`:
   - added `_resolveBackendCodeFromPayload(...)` and `_resolveBackendCodeFromContainer(...)`,
   - normalized code extraction across direct fields plus nested `error` / `errors` / `failure` / `failures` container structures.
2. Preserved auth inference precedence:
   - explicit signed-in aliases remain authoritative,
   - code-based signed-out fallback still applies only when explicit signed-in aliases are absent.
3. Added contract tests in `desktop/test/contracts/workflow_contracts_test.dart`:
   - backend `error` object code overrides token/session inference,
   - nested `errors` list code still respects explicit signed-in aliases.
4. Updated continuity docs:
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`.
5. Re-ran validation commands:
   - `cd desktop && FLUTTER_NO_PUB=1 flutter test test/contracts/workflow_contracts_test.dart`
   - `pnpm run desktop:verify:full`

### Unit review (detailed)

- **Review scope**
  - backend auth signed-out code extraction behavior for nested error container payloads,
  - precedence safety between explicit signed-in aliases and container-derived code signals.
- **Issues found during review**
  1. Backend code extraction handled direct code fields but could miss nested `error`/`errors` container structures used by common API error envelopes.
  2. Missing container coverage introduced a risk of false signed-in inference when token/session hints were present alongside containerized signed-out codes.
- **Fix applied**
  1. Added container-aware backend code extraction helpers for object/list error payload variants.
  2. Added contract tests covering both container-driven signed-out override and explicit signed-in precedence protection.
  3. Re-validated targeted contract tests and full desktop verification chain after parser extension.
- **Post-fix validation criteria**
  - signed-out backend code semantics are now recognized from direct and nested error container payloads.
  - explicit signed-in aliases continue to override code-based fallback inference.
  - targeted contract tests and full desktop verification remain green after error-container normalization.

## Unit WS-D-141: Numeric backend auth code normalization

### Planned objective

Close a backend auth compatibility gap where signed-out semantics are provided as numeric status/error codes (`401`, `403`, `419`, `440`) instead of string aliases, while preserving explicit signed-in precedence.

### Implemented changes

1. Extended backend code coercion/extraction in `desktop/lib/contracts/remote_stub_contracts.dart`:
   - added `_coerceBackendCodeString(...)` for string+numeric code normalization,
   - applied numeric-aware coercion to direct and nested backend code extraction paths.
2. Extended signed-out code classification:
   - `_backendCodeIndicatesSignedOut(...)` now treats `401`, `403`, `419`, and `440` as signed-out code signals.
3. Added contract tests in `desktop/test/contracts/workflow_contracts_test.dart`:
   - numeric unauthorized backend code overrides token/session inference,
   - explicit signed-in aliases remain authoritative over numeric signed-out codes.
4. Updated continuity docs:
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`.
5. Re-ran validation commands:
   - `cd desktop && FLUTTER_NO_PUB=1 flutter test test/contracts/workflow_contracts_test.dart`
   - `pnpm run desktop:verify:full`

### Unit review (detailed)

- **Review scope**
  - backend auth normalization behavior for numeric signed-out error/status code semantics,
  - precedence stability between explicit signed-in aliases and numeric code-based fallback.
- **Issues found during review**
  1. Existing code extraction normalized string values only, so numeric backend codes could be ignored and allow false signed-in inference.
  2. Numeric unauthorized/session-expiry semantics needed explicit classification coverage to align parser behavior with common backend responses.
- **Fix applied**
  1. Added numeric-capable backend code coercion and wired it through direct+nested code extraction paths.
  2. Added signed-out numeric marker handling for common unauthorized/session-expiry values.
  3. Added dedicated contract tests for numeric-code override and explicit signed-in precedence behavior.
- **Post-fix validation criteria**
  - numeric backend signed-out codes now correctly participate in auth signed-in inference.
  - explicit signed-in aliases continue to override code-based fallback inference (including numeric codes).
  - targeted contract tests and full desktop verification remain green after numeric code normalization.

## Unit WS-D-142: Nested backend auth status-detail normalization

### Planned objective

Close a backend auth observability gap where user-facing status/detail text is emitted only inside nested `error`/`errors` containers, ensuring auth state status text remains accurate even when top-level status aliases are absent.

### Implemented changes

1. Extended backend status parsing in `desktop/lib/contracts/remote_stub_contracts.dart`:
   - `_hasBackendStatus(...)` and `_resolveBackendStatusValue(...)` now support optional additional payload sources,
   - added nested status extraction helpers:
     - `_resolveBackendStatusFromPayload(...)`,
     - `_resolveBackendStatusFromContainer(...)`.
2. Applied status parsing in auth path with nested sources:
   - auth parser now forwards nested auth/session/token sources into status detection/resolution.
3. Preserved status precedence:
   - top-level `response/envelope/state` status aliases still resolve before nested auth container details.
4. Added contract tests in `desktop/test/contracts/workflow_contracts_test.dart`:
   - nested `errors` list `detail` updates status when top-level status is missing,
   - top-level message remains authoritative over nested error detail.
5. Updated continuity docs:
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`.
6. Re-ran validation commands:
   - `cd desktop && FLUTTER_NO_PUB=1 flutter test test/contracts/workflow_contracts_test.dart`
   - `pnpm run desktop:verify:full`

### Unit review (detailed)

- **Review scope**
  - auth status/detail message parity for nested backend error payload shapes,
  - precedence integrity between top-level and nested status message sources.
- **Issues found during review**
  1. Status resolution previously focused on top-level aliases and could miss nested auth error list/detail messages.
  2. Missing nested status extraction created stale status text risk during backend-auth failure handling.
- **Fix applied**
  1. Added nested status extraction helpers for direct + containerized message/detail aliases.
  2. Extended auth status detection/resolution to include nested auth/session/token payload sources.
  3. Added contract tests that cover both nested-status fallback and top-level precedence safeguards.
- **Post-fix validation criteria**
  - nested backend error/status detail text now resolves into auth status when top-level status is absent.
  - top-level status aliases remain authoritative when both top-level and nested status messages are present.
  - targeted contract tests and full desktop verification remain green after nested status normalization.

## Unit WS-D-143: Auth backend integration documentation coupling plan baseline

### Planned objective

Close continuity-risk in remaining auth integration work by publishing an explicit backend-auth integration execution plan and wiring it across runbook/inventory/checklist/acceptance/documentation-map references.

### Implemented changes

1. Added a new execution-plan artifact:
   - `docs/technical-guide/developer/desktop-flutter-auth-backend-contract-integration-plan.md`
   - includes objective/exit-criteria, current baseline snapshot, remaining integration gaps, phased execution units (`ABI-01..03`), validation protocol, and document coupling requirements.
2. Linked the new plan into related desktop continuity docs:
   - `desktop-flutter-development-runbook.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`.
3. Extended documentation-map coupling rules:
   - `web-mcp-documentation-map.md` now includes auth backend integration work as a recommended starting path and explicit companion-update policy row.
4. Updated migration/checklist wording to point pending full backend auth integration toward the new plan anchor.

### Unit review (detailed)

- **Review scope**
  - continuity integrity for remaining backend auth integration tasks,
  - cross-doc navigation completeness for auth integration planning and execution evidence.
- **Issues found during review**
  1. Remaining-gap statements referenced pending full backend auth integration without a dedicated execution-plan anchor.
  2. Runbook and continuity docs lacked an explicit coupling rule for auth integration plan updates, increasing risk of drift between planning and execution evidence.
- **Fix applied**
  1. Published dedicated auth backend integration plan with phased units and exit criteria.
  2. Added explicit cross-links in runbook/inventory/checklist/acceptance artifacts.
  3. Added documentation-map coupling rule so future plan edits require synchronized companion updates.
- **Post-fix validation criteria**
  - remaining backend auth integration now has a single authoritative execution-plan anchor.
  - continuity docs provide explicit bidirectional navigation between planning, execution evidence, and acceptance gates.
  - subsequent auth-integration units can be executed without ad-hoc scope reconstruction.

## Unit WS-D-144: Auth backend contract fixture matrix baseline

### Planned objective

Start `ABI-01` execution by adding a fixture-style auth backend contract matrix that locks normalized signed-in/status precedence behavior before real backend auth binding.

### Implemented changes

1. Added auth backend fixture-case model and operation invoker in:
   - `desktop/test/contracts/workflow_contracts_test.dart`
   - `_AuthBackendFixtureCase`
   - `_invokeAuthBackendFixtureOperation(...)`
2. Added fixture-matrix tests in existing RemoteStub auth contract suite:
   - nested alias normalization fixture,
   - numeric unauthorized-code override fixture,
   - error-container override with explicit signed-in precedence fixture,
   - nested status-detail fallback fixture,
   - top-level status precedence fixture.
3. Updated continuity docs for fixture baseline visibility:
   - `desktop-flutter-auth-backend-contract-integration-plan.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`.
4. Re-ran validation commands:
   - `cd desktop && FLUTTER_NO_PUB=1 flutter test test/contracts/workflow_contracts_test.dart`
   - `pnpm run desktop:verify:full`

### Unit review (detailed)

- **Review scope**
  - auth backend normalization regression-safety via table-driven fixture coverage,
  - precedence integrity across alias/code/error-container/status fallback scenarios.
- **Issues found during review**
  1. Existing auth normalization tests were broad but distributed; there was no single fixture-matrix anchor tied to `ABI-01` execution plan progression.
  2. Without a compact fixture matrix, upcoming real backend-auth binding work risked precedence regressions being detected late.
- **Fix applied**
  1. Added fixture-case model + operation invoker to keep auth contract fixtures concise and reusable.
  2. Added fixture-matrix cases that pin critical precedence behavior across signed-in inference and status resolution.
  3. Synced plan/inventory/checklist/acceptance docs to reflect fixture-matrix baseline as active `ABI-01` progress.
- **Post-fix validation criteria**
  - fixture matrix now provides a single regression anchor for backend auth normalization semantics.
  - `ABI-01` progress is traceable in both execution log and auth integration plan.
  - targeted contract tests and full desktop verification remain green after fixture-matrix integration.

## Unit WS-D-145: Auth fixture matrix schema-envelope expansion

### Planned objective

Advance `ABI-01` by expanding auth fixture-matrix coverage to include `result/data` response envelopes and `authState` alias payload variants across sign-in/restore/refresh operations.

### Implemented changes

1. Extended auth fixture matrix in `desktop/test/contracts/workflow_contracts_test.dart`:
   - added sign-in `result` envelope + `authState` alias success fixture,
   - added restore-session `data` envelope explicit signed-out override fixture,
   - added refresh-token `data` envelope nested error detail/code fixture.
2. Reused existing fixture invocation framework:
   - `_AuthBackendFixtureCase`,
   - `_invokeAuthBackendFixtureOperation(...)`.
3. Updated continuity docs:
   - `desktop-flutter-auth-backend-contract-integration-plan.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`.
4. Re-ran validation commands:
   - `cd desktop && FLUTTER_NO_PUB=1 flutter test test/contracts/workflow_contracts_test.dart`
   - `pnpm run desktop:verify:full`

### Unit review (detailed)

- **Review scope**
  - schema-envelope compatibility for auth fixture matrix (`result` / `data` / `authState`),
  - operation-level precedence behavior across sign-in/restore/refresh fixture paths.
- **Issues found during review**
  1. Initial fixture matrix baseline lacked explicit envelope/alias cases for common backend response wrapping patterns.
  2. ABI-01 progress required operation-diverse fixture evidence before real backend binding work begins.
- **Fix applied**
  1. Added envelope/alias fixtures spanning sign-in, restore-session, and refresh-token flows.
  2. Preserved precedence checks for signed-out override, explicit signed-in authority, and status-detail extraction under envelope wrapping.
  3. Synchronized planning and continuity docs to reflect expanded ABI-01 fixture scope.
- **Post-fix validation criteria**
  - auth fixture matrix now covers direct+nested payloads plus `result/data` envelope and `authState` alias forms.
  - ABI-01 plan progress is explicitly reflected in auth integration planning artifacts.
  - targeted contract tests and full desktop verification remain green after schema-envelope fixture expansion.

## Unit WS-D-146: Auth explicit failure-flag precedence normalization

### Planned objective

Prevent false signed-in inference under backend payloads that include credential hints but explicitly signal operation failure via `success` / `ok` / `isSuccess = false`.

### Implemented changes

1. Added explicit-failure detection helper in `desktop/lib/contracts/remote_stub_contracts.dart`:
   - `_containsExplicitFalseInSources(...)`.
2. Applied failure-flag precedence in auth inference path:
   - auth inference now suppresses token/user signed-in fallback when explicit failure flags resolve to `false`,
   - explicit signed-in aliases remain authoritative when provided.
3. Added contract tests in `desktop/test/contracts/workflow_contracts_test.dart`:
   - explicit failure flag overrides token/session inference,
   - explicit signed-in alias overrides failure-flag fallback.
4. Re-ran validation commands:
   - `cd desktop && FLUTTER_NO_PUB=1 flutter test test/contracts/workflow_contracts_test.dart`
   - `pnpm run desktop:verify:full`
5. Updated continuity docs:
   - `desktop-flutter-auth-backend-contract-integration-plan.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`.

### Unit review (detailed)

- **Review scope**
  - signed-in inference safety when backend responses include explicit failure booleans,
  - precedence compatibility between failure flags and explicit signed-in aliases.
- **Issues found during review**
  1. Signed-in fallback based on token/user hints could remain permissive when backend explicitly flagged failure (`success=false`) without code markers.
  2. Failure-flag handling needed to preserve existing explicit signed-in override semantics.
- **Fix applied**
  1. Added explicit-false flag detection across response/envelope/auth sources.
  2. Folded failure-flag signal into inferred signed-in decision path.
  3. Added dedicated tests for both failure override and explicit signed-in precedence compatibility.
- **Post-fix validation criteria**
  - explicit failure flags now prevent token/user-only signed-in inference when explicit signed-in aliases are absent.
  - explicit signed-in aliases continue to remain authoritative over fallback signals.
  - targeted contract tests and full desktop verification remain green after failure-flag precedence integration.

## Unit WS-D-147: Nested failure-flag container normalization

### Planned objective

Extend failure-flag precedence handling to nested payload containers (`error`, `meta`, envelope/state/auth wrappers) so backend failure booleans are not missed when not surfaced at top-level.

### Implemented changes

1. Extended explicit-false detection in `desktop/lib/contracts/remote_stub_contracts.dart`:
   - `_containsExplicitFalseInSources(...)` now delegates to recursive container traversal.
   - added `_containsExplicitFalseInContainer(...)` with map/list traversal over common wrapper/container aliases:
     - `error`, `errors`, `failure`, `failures`, `meta`, `result`, `data`, `state`, `auth`, `authentication`, `session`, `tokens`.
2. Added contract tests in `desktop/test/contracts/workflow_contracts_test.dart`:
   - nested failure flag in auth error container overrides token/session inference,
   - explicit signed-in alias continues to override nested failure-flag signal.
3. Re-ran validation commands:
   - `cd desktop && FLUTTER_NO_PUB=1 flutter test test/contracts/workflow_contracts_test.dart`
   - `pnpm run desktop:verify:full`
4. Updated continuity docs:
   - `desktop-flutter-auth-backend-contract-integration-plan.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`.

### Unit review (detailed)

- **Review scope**
  - nested failure-flag detection coverage across auth payload wrappers,
  - precedence compatibility between nested failure signals and explicit signed-in aliases.
- **Issues found during review**
  1. Initial failure-flag logic only checked direct alias keys per source and could miss nested `error/meta` boolean flags.
  2. Missing nested failure detection risked fallback signed-in inference on wrapped backend failure responses.
- **Fix applied**
  1. Implemented recursive container traversal for explicit-false flag detection.
  2. Added dedicated nested failure-flag contract tests for override and precedence safety.
  3. Re-validated full desktop verification chain after recursive detection integration.
- **Post-fix validation criteria**
  - explicit failure flags are now detected at both top-level and nested container levels.
  - explicit signed-in aliases remain authoritative over nested failure-flag fallback.
  - targeted contract tests and full desktop verification remain green after nested failure-flag normalization.

## Unit WS-D-148: Strict malformed auth schema fallback gate

### Planned objective

Add a strict contract-level safeguard that blocks delegate auth fallback when backend auth payload is present but malformed/unparseable, preventing false simulated signed-in transitions during backend integration.

### Implemented changes

1. Extended `RemoteStubAuthSessionContract` in `desktop/lib/contracts/remote_stub_contracts.dart`:
   - added constructor option: `strictBackendSchema` (default `false`),
   - `_resolveNextState(...)` now:
     - keeps existing behavior by default (delegate fallback),
     - in strict mode, when backend payload is non-empty but parser returns null, returns decorated current state with status `Backend auth schema validation failed.` and skips delegate fallback.
2. Added contract tests in `desktop/test/contracts/workflow_contracts_test.dart`:
   - malformed backend payload falls back to delegate by default,
   - malformed backend payload blocks delegate fallback in strict schema mode.
3. Re-ran validation commands:
   - `cd desktop && FLUTTER_NO_PUB=1 flutter test test/contracts/workflow_contracts_test.dart`
   - `pnpm run desktop:verify:full`
4. Updated continuity docs:
   - `desktop-flutter-auth-backend-contract-integration-plan.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`.

### Unit review (detailed)

- **Review scope**
  - malformed backend auth payload handling semantics during fallback path resolution,
  - backward-compatibility (default mode) vs strict integration-safety mode behavior.
- **Issues found during review**
  1. Unparseable non-empty backend auth payloads could fall through to delegate fallback and produce simulated signed-in transitions that mask backend schema issues.
  2. Integration-hardening path needed strict behavior without breaking existing default contract fallback semantics.
- **Fix applied**
  1. Added strict schema mode branch in auth state resolution that blocks delegate fallback on malformed backend payloads.
  2. Added dedicated tests for default compatibility and strict-mode safeguard behavior.
  3. Synced continuity docs to record strict fallback gate availability in auth integration baseline.
- **Post-fix validation criteria**
  - default behavior remains backward-compatible for existing non-strict flows.
  - strict mode now prevents delegate fallback on malformed non-empty backend auth payloads.
  - targeted contract tests and full desktop verification remain green after strict schema gate integration.

## Unit WS-D-149: Desktop bundle strict backend schema wiring

### Planned objective

Promote strict malformed-backend-auth schema safeguards from contract-only scope into the Desktop contract-bundle runtime boundary, so strict mode can be selected through bundle factories and environment-driven runtime loading paths.

### Implemented changes

1. Extended strict-schema runtime wiring in `desktop/lib/contracts/desktop_contract_bundle.dart`:
   - added environment parser: `_remoteStubAuthBackendSchemaStrictModeFromEnvironment()`,
   - `DesktopContractBundle.fromEnvironment()` now reads `PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_SCHEMA_STRICT` and forwards strict mode through `fromMode(...)`,
   - `DesktopContractBundle.loadFromEnvironment()` forwards the same strict mode env toggle,
   - `DesktopContractBundle.fromMode(...)` and `DesktopContractBundle.remoteStub(...)` now carry strict backend-auth schema options into `RemoteStubAuthSessionContract(strictBackendSchema: ...)`.
2. Added bundle-level forwarding regression coverage in `desktop/test/contracts/desktop_contract_bundle_test.dart`:
   - transport-client fixture helper: `_BundleBackendResponseTransportClient`,
   - new test: `fromMode forwards strict backend auth schema mode`,
   - verifies default/non-strict malformed-backend payload fallback compatibility vs strict-mode fallback blocking and status behavior.
3. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/desktop_contract_bundle_test.dart test/contracts/workflow_contracts_test.dart`
   - `pnpm run desktop:verify:full`
4. Updated continuity docs:
   - `desktop-flutter-auth-backend-contract-integration-plan.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`.

### Unit review (detailed)

- **Review scope**
  - contract-bundle-to-auth-contract strict-schema option propagation,
  - runtime env toggle continuity between sync (`fromEnvironment`) and async (`loadFromEnvironment`) bundle creation paths,
  - backward-compatibility and strict-mode behavior separation.
- **Issues found during review**
  1. Strict malformed-schema guard existed at auth-contract level but required explicit bundle/runtime wiring to be practically selectable during runtime mode composition.
  2. Initial wiring review found `fromEnvironment()` strict-mode propagation missing, which could create behavior drift between sync and async bundle resolution paths.
- **Fix applied**
  1. Added strict-schema option propagation across `fromMode(...)` and `remoteStub(...)` bundle factories.
  2. Added env-driven strict-mode parsing and forwarding in both `fromEnvironment()` and `loadFromEnvironment()`.
  3. Added bundle-level regression test covering non-strict compatibility and strict-mode failure handling.
- **Post-fix validation criteria**
  - non-strict mode continues delegate fallback on malformed backend auth payloads.
  - strict mode blocks malformed-payload fallback and surfaces `[remote-stub] Backend auth schema validation failed.`.
  - targeted contract tests and full desktop verification remain green after runtime strict-schema wiring.

## Unit WS-D-150: Strict backend schema diagnostics profile labeling

### Planned objective

Expose strict backend-auth schema mode in desktop remote profile diagnostics so runtime strict-mode state is visible without inspecting code/env directly.

### Implemented changes

1. Extended remote profile model/wiring in `desktop/lib/contracts/desktop_contract_bundle.dart`:
   - `DesktopRemoteStubProfile` now includes `authBackendSchemaLabel`,
   - profile `isEmpty` and `summaryLabel` now account for schema label (`auth-backend-schema: ...`),
   - `_buildRemoteStubProfile(...)` now derives `authBackendSchemaLabel` from strict-schema mode.
2. Propagated strict-schema profile labeling through bundle factory paths:
   - `DesktopContractBundle.fromMode(...)` -> `_buildRemoteStubProfile(...)`,
   - `DesktopContractBundle.remoteStub(...)` -> `_buildRemoteStubProfile(...)`,
   - `DesktopContractBundle.loadFromEnvironment(...)` profile build now carries strict-schema mode.
3. Added bundle-level diagnostics regression test in `desktop/test/contracts/desktop_contract_bundle_test.dart`:
   - `remote-stub profile exposes strict backend auth schema label`.
4. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/desktop_contract_bundle_test.dart test/contracts/workflow_contracts_test.dart`
   - `pnpm run desktop:verify:full`
5. Updated continuity docs:
   - `desktop-flutter-auth-backend-contract-integration-plan.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`,
   - `desktop-flutter-development-runbook.md`.

### Unit review (detailed)

- **Review scope**
  - strict backend schema runtime observability in diagnostics profile surface,
  - non-strict compatibility for existing profile summary behavior,
  - strict-mode propagation continuity across bundle factory/profile build paths.
- **Issues found during review**
  1. Strict malformed-schema mode could be enabled, but diagnostics summary only exposed auth-store/transport/fault context and did not show strict-schema mode explicitly.
  2. Without profile-level strict-schema labeling, troubleshooting backend auth schema failures required cross-checking env/runtime configuration manually.
- **Fix applied**
  1. Added dedicated `authBackendSchemaLabel` field and summary rendering in `DesktopRemoteStubProfile`.
  2. Wired strict-schema mode into all profile builder call sites used by mode/environment bundle factories.
  3. Added dedicated contract test to lock strict-schema label visibility behavior.
- **Post-fix validation criteria**
  - strict-schema enabled bundles now expose `auth-backend-schema: strict` in remote profile summary.
  - existing non-strict profile behavior remains unchanged.
  - targeted contract tests and full desktop verification remain green after diagnostics label integration.

## Unit WS-D-151: Strict schema profile label parity UI coverage

### Planned objective

Lock strict backend-schema diagnostics visibility at parity UI level so the `Remote profile` surface in Flutter desktop reliably reflects strict-schema runtime mode.

### Implemented changes

1. Added parity UI regression test in `desktop/test/parity/remote_stub_mode_parity_test.dart`:
   - new case: `remote-stub mode surfaces strict backend schema profile label`,
   - builds remote-stub contracts with `remoteStubAuthStrictBackendSchema: true`,
   - verifies diagnostics section renders `Remote profile: auth-backend-schema: strict`.
2. Kept existing remote-stub parity scenario intact:
   - baseline profile summary remains `Remote profile: none` in non-strict configuration.
3. Updated continuity docs:
   - `desktop-flutter-auth-backend-contract-integration-plan.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`,
   - `desktop-flutter-development-runbook.md`.
4. Re-ran validation commands:
   - `cd desktop && flutter test test/parity/remote_stub_mode_parity_test.dart test/contracts/desktop_contract_bundle_test.dart`
   - `pnpm run desktop:verify:full`

### Unit review (detailed)

- **Review scope**
  - diagnostics UI surface parity for strict backend-schema profile labeling,
  - coexistence of strict and non-strict profile rendering semantics.
- **Issues found during review**
  1. Strict-schema profile labeling was implemented at contract/profile layer but lacked parity UI test evidence, leaving risk of future UI formatting or binding regressions.
  2. Without UI-level lock, diagnostics-facing visibility guarantees depended only on lower-layer contract tests.
- **Fix applied**
  1. Added dedicated parity UI test for strict-schema profile label rendering.
  2. Preserved existing non-strict `Remote profile: none` scenario in the same parity suite.
  3. Synced continuity docs to record parity evidence anchor for strict-schema diagnostics labeling.
- **Post-fix validation criteria**
  - diagnostics UI now has explicit parity regression coverage for strict-schema profile visibility.
  - strict and non-strict remote profile rendering behavior remain simultaneously validated.
  - targeted parity+contract tests and full desktop verification remain green after coverage addition.

## Unit WS-D-152: Strict malformed-auth parity UI behavior lock

### Planned objective

Add parity UI coverage for strict-mode malformed backend auth payload handling so sign-in behavior (fallback blocked + validation-failure status surface) is enforced at Flutter workflow surface level.

### Implemented changes

1. Extended `desktop/test/parity/remote_stub_mode_parity_test.dart`:
   - added `_StrictSchemaMalformedAuthTransportClient` test transport helper,
   - added test: `strict schema mode blocks malformed auth sign-in fallback`,
   - asserts strict-mode sign-in renders `Status: [remote-stub] Backend auth schema validation failed.` and does not render simulated signed-in status.
2. Updated continuity docs:
   - `desktop-flutter-auth-backend-contract-integration-plan.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`,
   - `desktop-flutter-development-runbook.md`.
3. Re-ran validation commands:
   - `cd desktop && flutter test test/parity/remote_stub_mode_parity_test.dart test/contracts/workflow_contracts_test.dart`
   - `pnpm run desktop:verify:full`

### Unit review (detailed)

- **Review scope**
  - strict malformed-auth fallback-block behavior at parity UI workflow level,
  - auth status text/UX surfacing for strict-mode malformed backend responses.
- **Issues found during review**
  1. Contract tests covered strict malformed-auth behavior, but parity UI tests did not explicitly lock the same behavior in user-facing auth panel interactions.
  2. Without parity-level assertion, future UI wiring changes could accidentally mask strict fallback-block semantics despite contract-level correctness.
- **Fix applied**
  1. Added strict malformed-auth parity test with operation-scoped malformed backend payload injection.
  2. Added explicit assertions for failure status rendering and simulated-sign-in suppression.
  3. Synced continuity docs to record strict malformed-auth parity coverage anchor.
- **Post-fix validation criteria**
  - strict malformed backend auth payload sign-in path is now parity-locked at UI level.
  - strict-mode auth failure status remains visible and simulated sign-in fallback remains blocked.
  - targeted parity+contract tests and full desktop verification remain green after parity lock integration.

## Unit WS-D-153: Strict malformed-auth parity coverage expansion (restore/refresh)

### Planned objective

Expand strict malformed-auth parity UI coverage beyond sign-in by locking restore-session and refresh-token malformed-payload fallback behavior at workflow surface level.

### Implemented changes

1. Extended parity transport helper in `desktop/test/parity/remote_stub_mode_parity_test.dart`:
   - `_StrictSchemaMalformedAuthTransportClient` now supports configurable malformed operation set.
2. Added parity test:
   - `strict schema mode blocks malformed restore/refresh auth fallback`.
   - validates strict-mode malformed backend payload handling for:
     - `restoreSession`,
     - `refreshToken`.
   - asserts status remains `[remote-stub] Backend auth schema validation failed.` and simulated restore/refresh success statuses are absent.
3. Updated continuity docs:
   - `desktop-flutter-auth-backend-contract-integration-plan.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`,
   - `desktop-flutter-development-runbook.md`.
4. Re-ran validation commands:
   - `cd desktop && flutter test test/parity/remote_stub_mode_parity_test.dart test/contracts/workflow_contracts_test.dart`
   - `pnpm run desktop:verify:full`

### Unit review (detailed)

- **Review scope**
  - parity UI strict-mode malformed-auth behavior coverage completeness across auth operations,
  - simulated restore/refresh fallback suppression under strict schema mode.
- **Issues found during review**
  1. Prior parity lock covered strict malformed sign-in behavior only; restore-session and refresh-token strict malformed behavior remained uncovered at UI layer.
  2. Missing operation coverage left parity-level regression risk for restore/refresh fallback semantics.
- **Fix applied**
  1. Generalized parity transport helper to inject malformed payloads by operation.
  2. Added strict restore/refresh malformed behavior test with explicit status and negative-success assertions.
  3. Updated continuity docs to reflect expanded strict malformed-auth parity coverage scope.
- **Post-fix validation criteria**
  - strict malformed-auth parity coverage now spans sign-in, restore-session, and refresh-token workflows.
  - strict-mode fallback suppression is enforced across all primary auth entry operations at parity UI level.
  - targeted parity+contract tests and full desktop verification remain green after coverage expansion.

## Unit WS-D-154: Opt-in backend credential-forwarding path for sign-in transport

### Planned objective

Unblock ABI-02 real backend auth handshake readiness by adding an explicit opt-in path to forward raw sign-in credentials to backend transport requests, while preserving existing default sanitized payload behavior.

### Implemented changes

1. Extended auth contract transport payload policy in `desktop/lib/contracts/remote_stub_contracts.dart`:
   - added `RemoteStubAuthSessionContract.forwardSignInCredentials` (default `false`),
   - introduced `_signInTransportPayload(...)` helper,
   - default sign-in payload remains sanitized (`email`, `passwordLength`),
   - when enabled, payload additionally includes raw `password`.
2. Extended desktop bundle runtime wiring in `desktop/lib/contracts/desktop_contract_bundle.dart`:
   - added env toggle parser: `PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_FORWARD_CREDENTIALS`,
   - `fromEnvironment()` / `loadFromEnvironment()` now forward this toggle,
   - `fromMode(...)` / `remoteStub(...)` now carry auth sign-in credential-forwarding option into `RemoteStubAuthSessionContract`.
3. Added contract regression coverage:
   - `desktop/test/contracts/workflow_contracts_test.dart`:
     - strengthened metadata baseline to assert default sign-in payload excludes `password`,
     - added `auth sign-in payload forwards password only when enabled`.
   - `desktop/test/contracts/desktop_contract_bundle_test.dart`:
     - added `fromMode forwards auth sign-in credential payload mode`.
4. Updated continuity docs:
   - `desktop-flutter-auth-backend-contract-integration-plan.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`,
   - `desktop-flutter-development-runbook.md`.
5. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/workflow_contracts_test.dart test/contracts/desktop_contract_bundle_test.dart`
   - `pnpm run desktop:verify:full`

### Unit review (detailed)

- **Review scope**
  - auth transport payload policy compatibility between sanitized default and backend-ready credential-forwarding mode,
  - runtime/bundle propagation of credential-forwarding toggle.
- **Issues found during review**
  1. Existing sign-in transport mapping intentionally sanitized payloads (`passwordLength` only), which prevented direct backend credential handshake readiness in remote-stub backend execution mode.
  2. There was no runtime-configurable path to opt into raw password forwarding for integration-stage backend binding tests.
- **Fix applied**
  1. Added explicit opt-in raw password forwarding with safe default-off behavior.
  2. Propagated toggle through both sync/async bundle environment loading and explicit mode factories.
  3. Added regression tests locking default sanitized behavior and opt-in forwarding behavior.
- **Post-fix validation criteria**
  - default sign-in payload remains sanitized and unchanged for existing paths.
  - opt-in mode now forwards raw password for backend handshake integration scenarios.
  - targeted contract tests and full desktop verification remain green after credential-forwarding integration.

## Unit WS-D-155: Credential-forwarding diagnostics profile visibility

### Planned objective

Expose sign-in credential-forwarding runtime mode in diagnostics remote profile summary so operators can verify whether raw credential forwarding is enabled during backend integration validation.

### Implemented changes

1. Extended profile model in `desktop/lib/contracts/desktop_contract_bundle.dart`:
   - `DesktopRemoteStubProfile` now includes `authSignInPayloadLabel`,
   - profile summary now renders `auth-sign-in-payload: forwarded` when forwarding is enabled,
   - profile emptiness evaluation now accounts for forwarding label.
2. Propagated forwarding label through bundle profile builders:
   - `_buildRemoteStubProfile(...)` now accepts `authForwardSignInCredentials`,
   - `fromMode(...)`, `remoteStub(...)`, and `loadFromEnvironment(...)` profile construction paths now forward credential-mode context.
3. Added regression tests:
   - `desktop/test/contracts/desktop_contract_bundle_test.dart`:
     - `remote-stub profile exposes forwarded auth sign-in payload label`.
   - `desktop/test/parity/remote_stub_mode_parity_test.dart`:
     - `remote-stub mode surfaces forwarded auth sign-in payload profile label`.
4. Updated continuity docs:
   - `desktop-flutter-auth-backend-contract-integration-plan.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`,
   - `desktop-flutter-development-runbook.md`.
5. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/desktop_contract_bundle_test.dart test/parity/remote_stub_mode_parity_test.dart test/contracts/workflow_contracts_test.dart`
   - `pnpm run desktop:verify:full`

### Unit review (detailed)

- **Review scope**
  - runtime diagnostics observability for auth credential-forwarding mode,
  - profile summary compatibility when forwarding is disabled vs enabled.
- **Issues found during review**
  1. Credential-forwarding toggle was available, but diagnostics remote profile did not expose forwarding state, reducing runtime configuration observability during backend-auth integration.
  2. Lack of profile-surface visibility increased risk of misconfigured integration runs being misinterpreted.
- **Fix applied**
  1. Added forwarding-mode profile label and summary rendering.
  2. Wired forwarding-mode context into all profile build call paths.
  3. Added both contract-level and parity-UI regression tests for forwarding label visibility.
- **Post-fix validation criteria**
  - enabled forwarding mode is now diagnostics-visible as `auth-sign-in-payload: forwarded`.
  - default disabled mode preserves existing profile behavior (no forwarding label).
  - targeted tests and full desktop verification remain green after profile visibility integration.

## Unit WS-D-156: Backend auth signed-out precedence hardening for prior signed-in snapshots

### Planned objective

Reduce ABI-02 backend-auth integration risk by enforcing signed-out precedence even when the
current auth snapshot is already signed-in, and by normalizing HTTP backend auth non-2xx responses
into parser-consumable payload snapshots so auth-state/status rules run consistently.

### Implemented changes

1. Hardened auth parser + HTTP auth error handling in
   `desktop/lib/contracts/remote_stub_contracts.dart`:
   - added `_isAuthOperation(...)` helper for auth operation classification,
   - `_defaultHttpBackendExecutionProbe(...)` now normalizes auth non-2xx responses into payload
     snapshots with `code`/`message` fields so auth parser flows run,
   - `_authStateFromBackendPayload(...)` signed-in resolution now forces signed-out when backend
     signed-out code or explicit failure-flag signals are present and explicit signed-in aliases are
     absent.
2. Added/expanded regression coverage in
   `desktop/test/contracts/workflow_contracts_test.dart`:
   - `http transport client applies auth backend error payload snapshots from execution probe`,
   - `auth backend signed-out error codes force signed-out from signed-in snapshot`,
   - `auth backend explicit failure flag forces signed-out from signed-in snapshot`.
3. Added parity UI coverage in `desktop/test/parity/remote_stub_mode_parity_test.dart`:
   - `backend signed-out response forces signed-out state after prior sign-in`.
4. Updated continuity docs:
   - `desktop-flutter-auth-backend-contract-integration-plan.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`,
   - `desktop-flutter-development-runbook.md`.
5. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/workflow_contracts_test.dart test/parity/remote_stub_mode_parity_test.dart test/contracts/desktop_contract_bundle_test.dart`
   - `pnpm run desktop:verify:full`

### Unit review (detailed)

- **Review scope**
  - signed-out precedence behavior when auth snapshot is already signed-in,
  - backend auth error-path consistency between transport and auth parser status/state handling.
- **Issues found during review**
  1. Prior signed-out inference logic could retain `signedIn=true` from previous snapshot when
     backend signed-out code/failure signals were present without explicit `signedIn` aliases.
  2. HTTP backend auth non-2xx responses were primarily surfaced as transport-block status text,
     reducing parser-driven auth-state/status normalization consistency.
- **Fix applied**
  1. Updated auth signed-in resolution logic to force signed-out under signed-out code/failure
     signals unless explicit signed-in alias is provided.
  2. Normalized auth non-2xx HTTP responses into auth payload snapshots (`code`/`message`) so auth
     parser contract rules execute on backend error-path responses.
  3. Added contract + parity regression tests that lock signed-in -> signed-out transitions for
     backend unauthorized/failure responses.
- **Post-fix validation criteria**
  - backend signed-out signals now clear prior signed-in snapshots unless explicit signed-in state
    is provided by backend payload.
  - backend-auth error-path state/status handling remains parser-driven and parity-covered.
  - targeted tests and full desktop verification remain green after signed-out precedence hardening.

## Unit WS-D-157: Optional required-state backend auth fallback gate and diagnostics visibility

### Planned objective

Further reduce ABI-02 simulated-fallback risk by introducing an explicit runtime gate that requires
backend auth state payloads for auth operations, preventing delegate fallback on empty/malformed
backend responses, while exposing this mode in diagnostics profile and parity coverage.

### Implemented changes

1. Extended auth contract fallback policy in
   `desktop/lib/contracts/remote_stub_contracts.dart`:
   - added `RemoteStubAuthSessionContract.requireBackendState` (default `false`),
   - when enabled, auth operations with missing/malformed backend state payload now surface
     `Backend auth state payload required.` instead of delegate fallback mutation.
2. Extended desktop bundle/runtime wiring in
   `desktop/lib/contracts/desktop_contract_bundle.dart`:
   - added env toggle parser `PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_REQUIRE_STATE`,
   - `fromEnvironment()` / `loadFromEnvironment()` / `fromMode(...)` / `remoteStub(...)` now
     propagate required-state auth mode.
3. Added diagnostics profile visibility for required-state mode:
   - `DesktopRemoteStubProfile` now includes `authBackendStateLabel`,
   - profile summary now renders `auth-backend-state: required` when enabled.
4. Added/expanded regression coverage:
   - `desktop/test/contracts/workflow_contracts_test.dart`:
     - `auth backend required-state mode blocks delegate fallback on empty payload`,
     - `auth backend required-state mode blocks delegate fallback on malformed payload`.
   - `desktop/test/contracts/desktop_contract_bundle_test.dart`:
     - `fromMode forwards required backend auth state mode`,
     - `remote-stub profile exposes required auth backend state label`.
   - `desktop/test/parity/remote_stub_mode_parity_test.dart`:
     - `remote-stub mode surfaces required backend auth state profile label`,
     - `required backend auth state mode blocks empty sign-in delegate fallback`.
5. Updated continuity docs:
   - `desktop-flutter-auth-backend-contract-integration-plan.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`,
   - `desktop-flutter-development-runbook.md`.
6. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/workflow_contracts_test.dart test/contracts/desktop_contract_bundle_test.dart test/parity/remote_stub_mode_parity_test.dart`
   - `pnpm run desktop:verify:full`

### Unit review (detailed)

- **Review scope**
  - simulated delegate-fallback leakage risk under backend payload gaps,
  - runtime observability of backend-required auth mode at diagnostics surface.
- **Issues found during review**
  1. Auth backend integration path still allowed delegate fallback under empty/malformed backend
     payloads in non-strict mode, preserving simulated behavior risk during integration runs.
  2. There was no diagnostics-visible profile signal to confirm whether backend-required auth mode
     was active.
- **Fix applied**
  1. Added optional required-state gate to block delegate fallback for missing/malformed backend
     auth state payloads.
  2. Wired required-state mode through bundle factories/environment loading and profile builders.
  3. Added contract + parity regression coverage for required-state behavior and profile visibility.
- **Post-fix validation criteria**
  - required-state mode now blocks simulated delegate fallback on backend auth payload gaps.
  - diagnostics profile now surfaces `auth-backend-state: required` when mode is enabled.
  - targeted tests and full desktop verification remain green after required-state gate integration.

## Unit WS-D-158: Backend execution transport auto-required auth-state gate default

### Planned objective

Reduce backend-auth integration misconfiguration risk by auto-enabling required backend-auth state
mode whenever backend execution transport is configured, while preserving explicit runtime opt-out
for controlled fallback testing.

### Implemented changes

1. Extended required-state resolution policy in
   `desktop/lib/contracts/desktop_contract_bundle.dart`:
   - `remoteStubAuthRequireBackendState` / `authRequireBackendState` inputs are now nullable
     tri-state controls,
   - when unset, backend execution transport (`http-backend:` profile) auto-enables required-state
     auth mode,
   - explicit `false` still opts out.
2. Updated environment parsing behavior:
   - `PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_REQUIRE_STATE` parser now returns nullable state
     (`null` when unset) so auto-default can apply.
3. Added regression coverage:
   - `desktop/test/contracts/desktop_contract_bundle_test.dart`:
     - `fromMode auto-enables required backend auth state mode for backend execution transport`,
     - `fromMode allows explicit opt-out from auto required backend auth state mode`.
   - `desktop/test/parity/remote_stub_mode_parity_test.dart`:
     - `backend execution transport auto-enables required backend auth state mode`.
4. Updated continuity docs:
   - `desktop-flutter-auth-backend-contract-integration-plan.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`,
   - `desktop-flutter-development-runbook.md`.
5. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/desktop_contract_bundle_test.dart test/parity/remote_stub_mode_parity_test.dart test/contracts/workflow_contracts_test.dart`
   - `pnpm run desktop:verify:full`

### Unit review (detailed)

- **Review scope**
  - backend-auth required-state mode activation defaults under backend execution transport,
  - explicit opt-out compatibility and profile/UX behavior.
- **Issues found during review**
  1. Required-state mode depended on explicit manual toggle, so backend execution runs could still
     unintentionally fall back to simulated behavior when configuration was incomplete.
  2. Auto-default behavior needed to preserve explicit override control for targeted fallback tests.
- **Fix applied**
  1. Added auto-default required-state activation keyed off backend execution transport profile.
  2. Introduced nullable env/factory input semantics so unset uses auto-default and explicit `false`
     remains supported.
  3. Added contract + parity tests covering auto-default and explicit opt-out behavior.
- **Post-fix validation criteria**
  - backend execution transport now defaults to required-state auth mode.
  - explicit opt-out still restores prior fallback behavior when intentionally configured.
  - targeted tests and full desktop verification remain green after auto-default integration.

## Unit WS-D-159: Auth-session parity backend integration coverage expansion

### Planned objective

Strengthen ABI-02 parity evidence by expanding `auth_session_parity_test.dart` from scaffold-only
interaction checks to backend-oriented auth state transition and required-state fallback-block
coverage.

### Implemented changes

1. Extended parity suite in `desktop/test/parity/auth_session_parity_test.dart`:
   - added backend snapshot transition coverage:
     - `auth/session parity applies backend auth snapshots and signed-out transitions`,
   - added required-state fallback-block coverage:
     - `auth/session parity required-state mode blocks empty backend payload fallback`.
2. Added backend parity test transport helper:
   - `_AuthBackendParityTransportClient` for backend sign-in snapshot + unauthorized refresh payload
     transition simulation.
3. Updated continuity docs:
   - `desktop-flutter-auth-backend-contract-integration-plan.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`,
   - `desktop-flutter-development-runbook.md`.
4. Re-ran validation commands:
   - `cd desktop && flutter test test/parity/auth_session_parity_test.dart test/parity/remote_stub_mode_parity_test.dart test/contracts/desktop_contract_bundle_test.dart`
   - `pnpm run desktop:verify:full`

### Unit review (detailed)

- **Review scope**
  - parity evidence completeness for backend-auth state transitions in auth/session workflow,
  - required-state fallback-block verification at auth/session parity entrypoint.
- **Issues found during review**
  1. `auth_session_parity_test.dart` previously validated scaffold interactions only, with no
     backend-oriented transition assertions.
  2. Required-state fallback-block behavior was covered in remote-stub mode parity, but not in the
     dedicated auth/session parity suite.
- **Fix applied**
  1. Added backend snapshot + unauthorized refresh signed-out transition test in auth/session parity
     suite.
  2. Added required-state empty-payload fallback-block test in auth/session parity suite.
  3. Synced continuity docs to reflect expanded auth-session parity evidence baseline.
- **Post-fix validation criteria**
  - auth/session parity suite now directly covers backend snapshot transition and signed-out refresh
    behavior.
  - required-state fallback-block behavior is now anchored in both remote-stub mode and dedicated
    auth/session parity suites.
  - targeted tests and full desktop verification remain green after parity evidence expansion.

## Unit WS-D-160: Auth backend code-only failure taxonomy fallback status mapping

### Planned objective

Close backend-auth UX consistency gaps by enforcing deterministic fallback status mapping when
backend auth payloads signal signed-out/failure states without explicit status/message/detail text,
while preserving explicit status precedence and existing signed-in override rules.

### Implemented changes

1. Updated auth backend status resolution in `desktop/lib/contracts/remote_stub_contracts.dart`:
   - promoted explicit-status resolution reuse via `_tryResolveBackendStatusValue(...)`,
   - added auth-specific fallback status resolver path (`_resolveAuthBackendStatusValue(...)`),
   - introduced deterministic fallback taxonomy mapping when explicit status is absent:
     - signed-out unauthorized/auth-required codes -> `Authentication required.`,
     - session-expiry codes (`TOKEN_EXPIRED`, `419`, `440`, etc.) -> `Backend session expired.`,
     - explicit backend failure flags (`success/ok/isSuccess=false`) -> `Backend auth request failed.`,
   - preserved precedence rules:
     - explicit backend status/message/detail still wins,
     - explicit signed-in aliases suppress failure fallback status mapping.
2. Expanded auth contract regression coverage in
   `desktop/test/contracts/workflow_contracts_test.dart`:
   - `auth backend code-only unauthorized payload maps authentication-required fallback status`,
   - `auth backend code-only token-expired payload maps session-expired fallback status`,
   - `auth backend failure flag without status maps auth-request-failed fallback status`,
   - `auth backend explicit message keeps precedence over code-based fallback mapping`.
3. Expanded parity evidence in `desktop/test/parity/auth_session_parity_test.dart`:
   - added `auth/session parity maps code-only backend failure to deterministic auth-required status`
     with dedicated backend transport fixture for code-only refresh failure.
4. Updated continuity docs:
   - `desktop-flutter-auth-backend-contract-integration-plan.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`,
   - `desktop-flutter-development-runbook.md`.
5. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/workflow_contracts_test.dart test/parity/auth_session_parity_test.dart`
   - `pnpm run desktop:verify:full`

### Unit review (detailed)

- **Review scope**
  - deterministic UX/status behavior under backend code-only and failure-flag-only auth payloads,
  - precedence safety (explicit backend status/message should not regress),
  - parity visibility of code-only backend failure mapping.
- **Issues found during review**
  1. Backend auth parser could force signed-out state via code/failure flags but still retain stale
     prior status text when backend omitted explicit status/message/detail, causing ambiguous UX.
  2. Existing parity coverage validated backend signed-out transitions and required-state behavior,
     but did not lock code-only failure status text exposure in the auth/session parity suite.
- **Fix applied**
  1. Added auth-specific fallback status taxonomy resolver that activates only when explicit status
     is missing and signed-out/failure signals are present.
  2. Added contract regressions for code-only unauthorized/session-expired and failure-flag-only
     payloads plus explicit-status precedence retention.
  3. Added dedicated auth/session parity test for code-only backend failure status rendering.
- **Post-fix validation criteria**
  - auth status text is deterministic for code-only/failure-only backend auth payloads.
  - explicit backend status/message/detail precedence remains unchanged.
  - targeted tests and full desktop verification remain green after fallback taxonomy integration.

## Unit WS-D-161: Session-expiry backend code variant taxonomy expansion

### Planned objective

Eliminate backend auth code-variant drift by extending session-expiry taxonomy handling so
`SESSION_TIMEOUT` / `EXPIRED_TOKEN` style backend codes are normalized to the same signed-out +
session-expired fallback path as existing `TOKEN_EXPIRED` mappings.

### Implemented changes

1. Expanded auth backend code-taxonomy markers in
   `desktop/lib/contracts/remote_stub_contracts.dart`:
   - `_backendCodeIndicatesSignedOut(...)` now recognizes additional session-expiry variants:
     - `sessiontimeout`,
     - `sessiontimedout`,
     - `expiredtoken`,
     - `expiredsession`.
   - `_backendCodeIndicatesSessionExpired(...)` now mirrors the same variant markers so status
     fallback consistently resolves to `Backend session expired.` when explicit status is absent.
2. Added contract regressions in `desktop/test/contracts/workflow_contracts_test.dart`:
   - `auth backend code-only session-timeout payload maps session-expired fallback status`,
   - `auth backend code-only expired-token payload maps session-expired fallback status`.
3. Added parity coverage in `desktop/test/parity/auth_session_parity_test.dart`:
   - new backend transport fixture `_AuthBackendSessionTimeoutParityTransportClient`,
   - `auth/session parity maps session-timeout backend failure to deterministic session-expired status`.
4. Updated continuity docs:
   - `desktop-flutter-auth-backend-contract-integration-plan.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`,
   - `desktop-flutter-development-runbook.md`.
5. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/workflow_contracts_test.dart test/parity/auth_session_parity_test.dart`
   - `pnpm run desktop:verify:full`

### Unit review (detailed)

- **Review scope**
  - backend auth code-variant compatibility for signed-out/session-expired inference,
  - parity visibility for session-timeout variant mapping,
  - regression impact across full verification chain.
- **Issues found during review**
  1. Prior taxonomy primarily recognized `TOKEN_EXPIRED`/`SESSION_EXPIRED` patterns; backend
     variants like `SESSION_TIMEOUT`/`EXPIRED_TOKEN` could bypass signed-out detection and allow
     stale signed-in inference when token/session hints were present.
  2. Auth/session parity suite did not explicitly lock session-timeout variant behavior.
- **Fix applied**
  1. Added session-timeout/expired-token variants to both signed-out and session-expired classifier
     helpers.
  2. Added contract regressions for variant codes and parity UI coverage for session-timeout status
     mapping.
- **Post-fix validation criteria**
  - session-timeout/expired-token backend codes now force signed-out inference and deterministic
    `Backend session expired.` fallback status when explicit backend status is absent.
  - parity and contract tests both lock variant behavior.
  - targeted tests and full desktop verification remain green after taxonomy expansion.

## Unit WS-D-162: Signed-in precedence regression lock for session-expiry code variants

### Planned objective

Harden precedence safety for newly added session-expiry code variants by explicitly locking the rule
that backend signed-in aliases override signed-out code inference (including `SESSION_TIMEOUT` /
`EXPIRED_TOKEN` cases).

### Implemented changes

1. Added dedicated precedence regression tests in
   `desktop/test/contracts/workflow_contracts_test.dart`:
   - `auth backend explicit signed-in state overrides session-timeout code variant`,
   - `auth backend explicit signed-in state overrides expired-token code variant`.
2. Kept runtime behavior unchanged:
   - existing parser precedence rule (explicit signed-in alias > signed-out code inference) already
     handled these scenarios; this unit formalizes the regression lock.
3. Updated continuity docs:
   - `desktop-flutter-auth-backend-contract-integration-plan.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`,
   - `desktop-flutter-development-runbook.md`.
4. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/workflow_contracts_test.dart`
   - `pnpm run desktop:verify:full`

### Unit review (detailed)

- **Review scope**
  - explicit signed-in precedence safety after session-expiry code taxonomy expansion,
  - regression exposure risk for future parser refactors,
  - end-to-end verification stability.
- **Issues found during review**
  1. After expanding variant detection (`SESSION_TIMEOUT` / `EXPIRED_TOKEN`), there was no direct
     regression test proving explicit signed-in aliases still override those variant codes.
  2. Existing signed-in precedence tests covered numeric/auth-required paths, but not the newly added
     session-expiry variants.
- **Fix applied**
  1. Added dedicated signed-in precedence tests for `SESSION_TIMEOUT` and `EXPIRED_TOKEN`.
  2. Synchronized continuity docs so variant-coverage claims include precedence-lock evidence.
- **Post-fix validation criteria**
  - explicit signed-in aliases remain authoritative over session-expiry code variants.
  - variant taxonomy expansion is now guarded by both signed-out mapping tests and signed-in override
    regression tests.
  - targeted tests and full desktop verification remain green after precedence-lock coverage updates.

## Unit WS-D-163: Backend status-code alias extraction for auth signed-out inference

### Planned objective

Close backend schema-compatibility gaps where auth failure semantics are delivered via status-code
alias fields (`statusCode`, `httpStatus`, snake_case variants) instead of canonical `code` /
`errorCode` keys.

### Implemented changes

1. Extended backend code extraction in
   `desktop/lib/contracts/remote_stub_contracts.dart`:
   - `_resolveBackendCodeFromPayload(...)` now includes:
     - `statusCode`,
     - `httpStatus`,
     - `status_code`,
     - `http_status`.
2. Added contract regressions in `desktop/test/contracts/workflow_contracts_test.dart`:
   - `auth backend statusCode unauthorized payload maps authentication-required fallback status`,
   - `auth backend httpStatus session-expired payload maps session-expired fallback status`,
   - `auth backend explicit signed-in state overrides statusCode unauthorized variant`.
3. Added parity coverage in `desktop/test/parity/auth_session_parity_test.dart`:
   - new backend transport fixture `_AuthBackendStatusCodeParityTransportClient`,
   - `auth/session parity maps statusCode backend failure to deterministic auth-required status`.
4. Updated continuity docs:
   - `desktop-flutter-auth-backend-contract-integration-plan.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`,
   - `desktop-flutter-development-runbook.md`.
5. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/workflow_contracts_test.dart test/parity/auth_session_parity_test.dart`
   - `pnpm run desktop:verify:full`

### Unit review (detailed)

- **Review scope**
  - backend code-alias compatibility for auth signed-out/session-expired inference,
  - precedence safety under status-code aliases,
  - parity visibility of status-code alias behavior.
- **Issues found during review**
  1. Auth code extraction previously depended on `code` / `errorCode` / `reasonCode`; backend payloads
     using `statusCode`/`httpStatus` could bypass signed-out taxonomy and leave stale auth state.
  2. Existing tests did not lock alias-key behavior at contract/parity layers.
- **Fix applied**
  1. Added `statusCode`/`httpStatus` plus snake_case aliases to direct code extraction.
  2. Added contract regressions for unauthorized + session-expired alias scenarios and signed-in
     precedence override case.
  3. Added auth/session parity case proving statusCode-driven fallback status rendering.
- **Post-fix validation criteria**
  - backend auth status-code aliases now participate in signed-out/session-expired inference.
  - explicit signed-in aliases remain authoritative over alias-driven signed-out inference.
  - targeted tests and full desktop verification remain green after alias extraction expansion.

## Unit WS-D-164: Snake-case status alias parity lock and code-normalization hot-path optimization

### Planned objective

Harden backend auth alias compatibility by explicitly covering snake_case status aliases
(`status_code`, `http_status`) in contract/parity regression suites and reduce repeated classifier
overhead by caching backend code-normalization regex allocation.

### Implemented changes

1. Added micro-optimization in `desktop/lib/contracts/remote_stub_contracts.dart`:
   - introduced shared regex cache `final RegExp _backendCodeCompactPattern = RegExp(r'[^a-z0-9]');`,
   - updated `_compactBackendCode(...)` to reuse cached regex instead of allocating per call.
2. Expanded contract regressions in `desktop/test/contracts/workflow_contracts_test.dart`:
   - `auth backend status_code unauthorized payload maps authentication-required fallback status`,
   - `auth backend http_status session-expired payload maps session-expired fallback status`,
   - `auth backend explicit signed-in state overrides status_code unauthorized variant`.
3. Expanded parity evidence in `desktop/test/parity/auth_session_parity_test.dart`:
   - new backend fixture `_AuthBackendStatusCodeSnakeCaseParityTransportClient`,
   - `auth/session parity maps status_code backend failure to deterministic auth-required status`.
4. Updated continuity docs:
   - `desktop-flutter-auth-backend-contract-integration-plan.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`,
   - `desktop-flutter-development-runbook.md`.
5. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/workflow_contracts_test.dart test/parity/auth_session_parity_test.dart`
   - `pnpm run desktop:verify:full`

### Unit review (detailed)

- **Review scope**
  - snake_case alias extraction correctness for signed-out/session-expired inference,
  - precedence safety for snake_case unauthorized signals,
  - parser hot-path allocation behavior for backend code normalization.
- **Issues found during review**
  1. Prior WS-D-163 locked camelCase aliases primarily; snake_case alias paths needed dedicated
     regression tests to prevent silent key-shape drift.
  2. `_compactBackendCode(...)` created a new `RegExp` object on each call, introducing avoidable
     repeated allocation in frequently executed auth-classifier paths.
- **Fix applied**
  1. Added explicit snake_case contract + parity regression coverage.
  2. Cached backend code-normalization regex as shared helper constant and reused it in compacting.
- **Post-fix validation criteria**
  - snake_case status aliases now have direct contract/parity evidence for signed-out/session-expired
    inference and signed-in precedence compatibility.
  - backend code-normalization path now reuses cached regex allocation.
  - targeted tests and full desktop verification remain green after compatibility + optimization updates.

## Unit WS-D-165: Snake-case failure-flag alias compatibility and precedence lock

### Planned objective

Close remaining backend auth failure-flag shape drift by supporting snake_case explicit failure-flag
aliases (`is_success`, `is_ok`) for signed-out/fallback status inference and locking precedence
behavior through contract/parity regressions.

### Implemented changes

1. Expanded explicit failure-flag alias handling in
   `desktop/lib/contracts/remote_stub_contracts.dart`:
   - `_authStateFromBackendPayload(...)` now includes snake_case keys in explicit-false detection:
     - `is_success`,
     - `is_ok`.
2. Added contract regressions in `desktop/test/contracts/workflow_contracts_test.dart`:
   - `auth backend snake-case failure flag without status maps auth-request-failed fallback status`,
   - `auth backend explicit signed-in state overrides snake-case failure flag`.
3. Added parity evidence in `desktop/test/parity/auth_session_parity_test.dart`:
   - new backend fixture `_AuthBackendFailureFlagSnakeCaseParityTransportClient`,
   - `auth/session parity maps snake-case failure flag to deterministic auth-failed status`.
4. Updated continuity docs:
   - `desktop-flutter-auth-backend-contract-integration-plan.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`,
   - `desktop-flutter-development-runbook.md`.
5. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/workflow_contracts_test.dart test/parity/auth_session_parity_test.dart`
   - `pnpm run desktop:verify:full`

### Unit review (detailed)

- **Review scope**
  - backend explicit failure-flag alias compatibility for snake_case payloads,
  - deterministic fallback status behavior for failure-flag-only auth payloads,
  - precedence safety when explicit signed-in aliases and snake_case failure flags coexist.
- **Issues found during review**
  1. Failure-flag inference previously covered `success` / `ok` / `isSuccess`, but backend payloads
     using `is_success` / `is_ok` could bypass deterministic signed-out/fallback mapping.
  2. Contract/parity suites did not lock explicit signed-in precedence for snake_case failure-flag
     variants, creating regression risk for future parser refactors.
- **Fix applied**
  1. Added snake_case failure-flag aliases to explicit-false inference path.
  2. Added contract regressions for fallback status mapping and signed-in precedence override on
     snake_case failure-flag payloads.
  3. Added auth/session parity regression proving deterministic auth-failed status rendering under
     snake_case failure-flag backend responses.
- **Post-fix validation criteria**
  - snake_case failure-flag aliases now participate in signed-out/fallback status inference.
  - explicit signed-in aliases remain authoritative over snake_case failure-flag signals.
  - targeted tests and full desktop verification remain green after alias compatibility expansion.

## Unit WS-D-166: CamelCase `isOk` failure-flag alias parity lock

### Planned objective

Close remaining explicit failure-flag compatibility drift by adding camelCase `isOk` alias support
to auth signed-out/fallback inference and locking corresponding contract/parity regression coverage.

### Implemented changes

1. Expanded explicit failure-flag alias list in
   `desktop/lib/contracts/remote_stub_contracts.dart`:
   - `_authStateFromBackendPayload(...)` now recognizes:
     - `isOk`.
2. Added contract regressions in `desktop/test/contracts/workflow_contracts_test.dart`:
   - `auth backend isOk failure flag without status maps auth-request-failed fallback status`,
   - `auth backend explicit signed-in state overrides isOk failure flag`.
3. Added parity evidence in `desktop/test/parity/auth_session_parity_test.dart`:
   - new backend fixture `_AuthBackendFailureFlagIsOkParityTransportClient`,
   - `auth/session parity maps isOk failure flag to deterministic auth-failed status`.
4. Updated continuity docs:
   - `desktop-flutter-auth-backend-contract-integration-plan.md`,
   - `desktop-flutter-migration-inventory.md`,
   - `desktop-flutter-parity-checklist.md`,
   - `desktop-flutter-parity-acceptance-baseline.md`,
   - `desktop-flutter-development-runbook.md`.
5. Re-ran validation commands:
   - `cd desktop && flutter test test/contracts/workflow_contracts_test.dart test/parity/auth_session_parity_test.dart`
   - `pnpm run desktop:verify:full`

### Unit review (detailed)

- **Review scope**
  - explicit failure-flag alias compatibility for camelCase backend payloads,
  - deterministic fallback status behavior for `isOk=false` payloads,
  - precedence safety when explicit signed-in aliases and `isOk` failure signals coexist.
- **Issues found during review**
  1. Parser explicit-false alias handling included `success` / `ok` / `isSuccess` and snake_case
     forms, but not camelCase `isOk`, allowing some backend failure payloads to bypass fallback
     status/sign-out inference.
  2. Contract/parity suites lacked dedicated `isOk` regression coverage, leaving alias-shape drift
     risk for future parser changes.
- **Fix applied**
  1. Added `isOk` to explicit failure-flag alias detection.
  2. Added contract regressions for `isOk` fallback mapping and signed-in precedence override.
  3. Added auth/session parity regression for deterministic auth-failed status under `isOk=false`.
- **Post-fix validation criteria**
  - `isOk` now participates in explicit failure-flag signed-out/fallback inference.
  - explicit signed-in aliases remain authoritative over `isOk` failure signals.
  - targeted tests and full desktop verification remain green after alias expansion.

## Remaining Phase C setup gaps

- Role-level owners are assigned, but named individual assignees are not yet confirmed.
- All workflow domains now have Flutter parity scaffolds/harnesses, runtime-switchable in-memory/remote-stub contract boundaries, degraded-path remote-stub fault-profile gates (global unavailable + operation-scoped blocked-operation profiles), scripted transport-client injection seam, HTTP health-probe transport gating path, canonical operation-ID catalog + env list filtering, transport-profile interface abstraction, bundle/UI-visible remote profile metadata (including auth-store mode label, strict backend-schema label, required backend-state label, and forwarding payload label) with parity UI coverage, shared contract-bundle injection, operation-level backend request metadata mapping, backend endpoint execution wiring with error propagation, backend response-driven state mutation integration, shell section-route initialization/restoration bridge baseline plus launch-argument deep-link parser bridge, macOS protocol/channel route-dispatch baseline, Windows running-instance route relay baseline, Windows protocol-registration command-hook baseline in installer flow with strict release gate control and helper script template, backend envelope/schema compatibility normalization, auth snapshot store/seed seam, flutter_secure_storage-backed native credential-store adapter path with strict rollout/fallback controls, secure-store default-on rollout policy, runtime legacy auth-store command/file/mirror path physical decommission execution, legacy auth-store decommission guard automation baseline, runtime source-level auth-store decommission guard automation baseline, backend auth normalization baseline (flat+nested alias payloads + flat+nested signed-out error-code precedence + nested error/error-list container extraction + numeric unauthorized/session-expiry code handling + status-code alias extraction (`statusCode` / `httpStatus` / `status_code` / `http_status`) with camelCase/snake_case regression coverage + nested status-detail message extraction + explicit failure-flag precedence including nested failure-flag containers and additional aliases (`isOk` / `is_success` / `is_ok`) + forced signed-out transition from prior signed-in snapshots under signed-out code/failure signals + HTTP auth non-2xx payload normalization path + strict malformed-backend-auth schema fallback gate + runtime bundle strict-schema wiring with `PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_SCHEMA_STRICT` env toggle + optional required-state toggle `PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_REQUIRE_STATE` with diagnostics-visible `auth-backend-state: required` profile surface and backend execution transport auto-default enablement (explicit `false` opt-out supported) + optional credential-forwarding toggle `PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_FORWARD_CREDENTIALS` with default sanitized payload policy + diagnostics-visible strict-schema/profile forwarding labels + strict-label parity UI coverage including strict malformed-payload auth behavior, required-state fallback blocking behavior, auto-required-state backend transport behavior, backend unauthorized refresh signed-out transition, auth-session parity backend integration coverage in `desktop/test/parity/auth_session_parity_test.dart` including statusCode/status_code unauthorized mapping and snake-case/isOk failure-flag auth-failed mapping, deterministic code-only/failure-only fallback status mapping (`Authentication required.` / `Backend session expired.` / `Backend auth request failed.`) with explicit-status precedence, expanded session-expiry code variant normalization (`SESSION_TIMEOUT` / `EXPIRED_TOKEN`), explicit signed-in precedence regression lock coverage for those variants plus statusCode/status_code unauthorized and snake-case/isOk failure-flag variants, cached backend code-normalization regex helper usage, and auth backend contract fixture matrix baseline including `result/data` envelope + `authState` alias coverage), runtime mode parity/matrix gates, and document continuity coupling matrix/release-linkage protocol baseline are implemented, and backend-auth integration plan anchor is now published (`desktop-flutter-auth-backend-contract-integration-plan.md`), but production Windows protocol-registration command provisioning with signed installer chain wiring and full backend auth contract integration are still pending.
- Desktop parity CI baseline is now configured on Linux+macOS+Windows with consolidated verification scripts, release script syntax gate plus syntax-contract regression guard, verify test coverage guard plus coverage-contract regression guard (set-diff optimized uncovered/missing detection), auth-store legacy decommission guard + contract regression guard, auth-store runtime decommission guard + contract regression guard, desktop command inventory guard plus command-inventory contract regression guard, de-duplicated contract/parity/mode-matrix verification chain, verify stage timing instrumentation/reporting with update-manifest stage integration plus update-manifest contract regression guard and gate-policy contract-check integration, macOS build validation, verification log/app artifact upload automation, hardened release-evidence guard automation (schema + RC/platform uniqueness + required attachment-reference checks with in-memory duplicate-key tracking + base-check markdown report emission) plus evidence-index contract regression guard (including dedicated missing-base-check-report attachment, missing-index-file, invalid-decision, and promoted-placeholder cases, dedicated tests workflow release-evidence guard base+contract enforcement/upload, and parity matrix base-check artifact retention), update-manifest guard automation with validation + contract report artifacts (including dedicated tests workflow update-manifest guard job contract enforcement/upload), on-demand installer/update smoke build-report workflow with preflight syntax/coverage/command-inventory/update-manifest readiness checks plus gate-policy contract check, automated release-evidence row snippet generation, release-evidence bundle summary automation plus bundle status guard enforcement with gate-policy dependency wiring, evidence-index preview/apply automation, strict appcast platform coverage generation/validation workflow, appcast publish dry-run automation, appcast publication bundle automation, release smoke gate-policy preflight, signing readiness gating with expanded command-hook/placeholder hygiene coverage (including sign-verify/provenance hooks) plus gate-policy strict readiness dependency for execution/provenance, command-hooked signing execution baseline with strict sign/notarize placeholder-hygiene enforcement plus gate-policy placeholder dependency plus signing provenance gate with strict verify-command placeholder hygiene enforcement, optional external publication dry-run stage with production consent guard and readiness gate baseline plus production identity/invalidation validation hooks, strict placeholder-hygiene enforcement, resilient publication invalidation-status reporting, and provider/readiness preflight dependency hardening for non-dry-run publication with strict release-evidence bundle dependency, Windows installer packaging verification baseline with strict naming gate, command-hooked Windows installer pipeline baseline with strict placeholder-hygiene enforcement, Windows installer provenance gate baseline with strict placeholder-hygiene enforcement plus strict packaging+naming dependency, and platform-scoped Windows report upload normalization with shared placeholder-hygiene helper reuse, but real signing/notarization command secret provisioning, actual Windows signed installer generation (`.msi`/`exe`), and external production publication credential provisioning/invalidation execution validation are not yet configured.
