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

## Remaining Phase C setup gaps

- Role-level owners are assigned, but named individual assignees are not yet confirmed.
- All workflow domains now have Flutter parity scaffolds/harnesses, runtime-switchable in-memory/remote-stub contract boundaries, degraded-path remote-stub fault-profile gates, shared contract-bundle injection, and runtime mode parity/matrix gates, but real backend/service integration is still pending across auth/project/file/canvas/assets/collaboration/inspect/export/diagnostics.
- Desktop parity CI baseline is now configured on Linux+macOS+Windows with consolidated verification scripts, release script syntax gate, verify test coverage guard, desktop command inventory guard, de-duplicated contract/parity/mode-matrix verification chain, verify stage timing instrumentation/reporting with update-manifest stage integration, macOS build validation, verification log/app artifact upload automation, hardened release-evidence guard automation (schema + RC/platform uniqueness), update-manifest guard automation with validation report artifacts, on-demand installer/update smoke build-report workflow with preflight syntax/coverage/command-inventory/update-manifest readiness checks, automated release-evidence row snippet generation, release-evidence bundle summary automation plus bundle status guard enforcement with gate-policy dependency wiring, evidence-index preview/apply automation, strict appcast platform coverage generation/validation workflow, appcast publish dry-run automation, appcast publication bundle automation, release smoke gate-policy preflight, signing readiness gating with command-hook strict mode plus placeholder hygiene strict mode, command-hooked signing execution baseline with signing provenance gate, optional external publication dry-run stage with production consent guard and readiness gate baseline plus production identity/invalidation validation hooks, strict placeholder-hygiene enforcement, resilient publication invalidation-status reporting, and provider/readiness preflight dependency hardening for non-dry-run publication, Windows installer packaging verification baseline with strict naming gate, command-hooked Windows installer pipeline baseline, Windows installer provenance gate baseline, and platform-scoped Windows report upload normalization, but real signing/notarization command secret provisioning, actual Windows signed installer generation (`.msi`/`exe`), and external production publication credential provisioning/invalidation execution validation are not yet configured.
