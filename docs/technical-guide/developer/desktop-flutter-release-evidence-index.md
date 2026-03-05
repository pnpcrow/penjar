---
title: Desktop Flutter Release Evidence Index
desc: Traceable index of desktop release candidate validation evidence across platforms.
---

# Desktop Flutter Release Evidence Index

This index tracks release validation evidence for desktop release candidates.

## Related artifacts

- [Desktop Flutter Release Validation Baseline](/technical-guide/developer/desktop-flutter-release-validation-baseline/)
- [Desktop Flutter Development Runbook](/technical-guide/developer/desktop-flutter-development-runbook/)
- [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/)

## Evidence record schema

Each release candidate record should include:

1. RC identifier and target version.
2. Platform artifact manifest (hash, signing fingerprint, output path).
3. Installer/update validation report links.
4. CI workflow run links.
5. Execution log unit reference.
6. Release decision (`promoted` / `blocked`) with reason.

## Release evidence table

| RC | Version | Platform | Artifact manifest | Installer/Update report | CI run | Execution log reference | Decision |
|---|---|---|---|---|---|---|---|
| RC-PLACEHOLDER | 0.0.0-placeholder | macOS | TBD | TBD | TBD | TBD | blocked (placeholder) |
| RC-PLACEHOLDER | 0.0.0-placeholder | Windows | TBD | TBD | TBD | TBD | blocked (placeholder) |

## Maintenance rules

1. Do not mark `promoted` unless all required baseline gates are evidenced.
2. Keep one row per `RC + platform` pair.
3. Add latest entry at top for quick audit visibility.
4. Keep artifact/report links immutable after promotion.
5. Run `pnpm run desktop:release:evidence:check` before release promotion.
6. Run `pnpm run desktop:release:update-manifest:check` before release promotion.
7. Attach installer/update smoke report artifact links from `.github/workflows/release-desktop-installer-smoke.yml` before promotion review.
8. Generate platform row snippets from smoke reports with `pnpm run desktop:release:evidence:row:macos` and `pnpm run desktop:release:evidence:row:windows`, then review before table update.
9. Generate evidence-index previews with `pnpm run desktop:release:evidence:index:preview:macos` and `pnpm run desktop:release:evidence:index:preview:windows`, then apply updates via `desktop:release:evidence:index:apply:macos` and `desktop:release:evidence:index:apply:windows` only after reviewer sign-off.
10. Generate/check appcast preview (`pnpm run desktop:release:appcast:generate`, `pnpm run desktop:release:appcast:check`) before promotion decision.
11. Generate appcast publish dry-run targets (`pnpm run desktop:release:appcast:publish:dry-run`) and attach artifact links before promotion decision.
12. Attach signing readiness report from `pnpm run desktop:release:signing:readiness` (or strict variants including `desktop:release:signing:readiness:strict` / `desktop:release:signing:readiness:command-hooks:strict` / `desktop:release:signing:readiness:placeholders:strict`) before promotion decision, including placeholder count fields when placeholder strict mode is enabled.
13. Generate/check appcast publication bundle (`pnpm run desktop:release:appcast:bundle:generate`, `pnpm run desktop:release:appcast:bundle:check`) and attach artifact link before promotion decision.
14. Attach platform signing pipeline reports (`release/reports/signing_report_macos.md`, `release/reports/signing_report_windows.md`) before promotion decision.
15. Attach platform signing provenance reports (`release/reports/signing_artifact_provenance_macos.md`, `release/reports/signing_artifact_provenance_windows.md`) before promotion decision when provenance gate is enabled.
16. Attach external publication report (`release/reports/appcast_external_publication_report.md`) when external publication stage is executed.
17. Attach Windows installer packaging report (`release/reports/windows_installer_packaging_report.md`) before promotion decision, and require naming policy status to be `passed` when strict naming mode is enabled.
18. Attach Windows installer pipeline report (`release/reports/windows_installer_pipeline_report.md`) before promotion decision.
19. Attach external publication readiness report (`release/reports/appcast_external_readiness_report.md`) when external publication stage is executed, including identity/invalidation check status fields when non-dry-run readiness is evaluated.
20. Attach external production guard report (`release/reports/appcast_external_production_guard_report.md`) when external publication stage is executed.
21. Attach Windows installer provenance report (`release/reports/windows_installer_provenance_report.md`) before promotion decision when installer smoke is executed.
22. Attach release smoke gate policy report (`release/reports/release_smoke_gate_policy_report.md`) before promotion decision.
23. Attach platform release evidence bundle summaries (`release/reports/release_evidence_bundle_macos.md`, `release/reports/release_evidence_bundle_windows.md`) before promotion decision.
24. Attach release script syntax report (`release/reports/release_script_syntax_report.md`) before promotion decision.
25. Attach verify test coverage report (`release/reports/verify_test_coverage_report.md`) before promotion decision.
26. Attach desktop command inventory report (`release/reports/desktop_command_inventory_report.md`) before promotion decision.
27. Attach update manifest validation report (`release/reports/update_manifest_validation_report.md`) before promotion decision.
28. Attach verify stage timing report (`release/reports/verify_stage_timing_report.md`) before promotion decision.
