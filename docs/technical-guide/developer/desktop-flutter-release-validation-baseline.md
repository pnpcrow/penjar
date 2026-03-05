---
title: Desktop Flutter Release Validation Baseline
desc: Release-grade installer/update/signing validation baseline for Flutter desktop distribution.
---

# Desktop Flutter Release Validation Baseline

This baseline defines minimum release validation requirements for desktop distribution targets.

## Related artifacts

- [Web + MCP + Desktop Documentation Map](/technical-guide/developer/web-mcp-documentation-map/)
- [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/)
- [Desktop Flutter Development Runbook](/technical-guide/developer/desktop-flutter-development-runbook/)
- [Desktop Flutter Parity Acceptance Baseline](/technical-guide/developer/desktop-flutter-parity-acceptance-baseline/)
- [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/)
- [Desktop Flutter Release Evidence Index](/technical-guide/developer/desktop-flutter-release-evidence-index/)

## 1) Target release channels

| Platform | Distribution target | Current status | Owner |
|---|---|---|---|
| macOS | Signed `.app` + packaged installer (`.dmg` or notarized equivalent) | Planned | Desktop Flutter Program |
| Windows | Signed installer (`.msi`/`exe`) with update channel metadata | Planned | Desktop Flutter Program |

## 2) Required validation gates

1. Build reproducibility gate:
   - deterministic version metadata,
   - reproducible build command surface documented,
   - release build artifacts archived.
2. Installer integrity gate:
   - installer launches and installs cleanly on clean host,
   - uninstall path does not leave critical runtime residues,
   - app launch succeeds after install.
3. Signing/notarization gate:
   - platform signing completed,
   - notarization/trust checks completed where required,
   - unsigned artifact distribution is blocked for production channel.
4. Update-path gate:
   - update check path validates current->next versions,
   - rollback/failed-update recovery path validated,
   - release notes/version manifest integrity validated.
5. Runtime smoke gate (post-install):
   - app boot,
   - auth entry flow render,
   - project/file interaction,
   - diagnostics panel render with contract mode visibility.

## 3) Required evidence per release candidate

1. Artifact manifest:
   - platform, version, hash, signing fingerprint.
2. Validation report:
   - gate-by-gate pass/fail summary,
   - failure diagnostics and mitigation links.
3. Update simulation report:
   - from-version -> to-version path,
   - failure injection results,
   - rollback result.
4. Traceability link pack:
   - execution log unit entry,
   - CI run URLs,
   - release checklist ticket.

## 4) Operating protocol

1. Before RC cut, confirm Flutter parity verification chain is green.
   - run release script syntax check: `pnpm run desktop:release:scripts:syntax:check`.
   - run verify test coverage check: `pnpm run desktop:test:coverage:check`.
   - run desktop command inventory check: `pnpm run desktop:docs:command-inventory:check`.
2. Run signing readiness preflight:
   - `pnpm run desktop:release:signing:readiness`
   - use strict mode when release secrets are expected: `pnpm run desktop:release:signing:readiness:strict`.
   - enforce command-hook presence when execution hooks are expected: `pnpm run desktop:release:signing:readiness:command-hooks:strict`.
   - enforce placeholder hygiene when production-grade secrets/commands are expected: `pnpm run desktop:release:signing:readiness:placeholders:strict`.
3. Execute platform-specific installer/update smoke automation:
   - preflight gate policy check:
     - `pnpm run desktop:release:smoke:gate-policy:check`.
   - local/manual entrypoints:
     - `pnpm run desktop:release:installer-smoke:macos`
     - `pnpm run desktop:release:installer-smoke:windows`
   - local signing execution entrypoints:
     - `pnpm run desktop:release:signing:run:macos`
     - `pnpm run desktop:release:signing:run:windows`
   - strict execution mode:
     - set `STRICT_SIGNING_EXECUTION=1` when invoking smoke pipeline to enforce command-backed signing/notarization.
   - signing provenance strict mode:
     - set `STRICT_SIGNING_PROVENANCE=1` (or workflow input `enforce_signing_provenance=true`) to enforce artifact hash + sign-verify command evidence.
   - standalone signing provenance checks:
     - `pnpm run desktop:release:signing:provenance:macos`
     - `pnpm run desktop:release:signing:provenance:windows`
   - windows installer strict mode:
     - set `STRICT_WINDOWS_INSTALLER_PACKAGING=1` (or workflow input `enforce_windows_installer_packaging=true`) to enforce `.msi/.exe` artifact presence.
   - windows installer naming strict mode:
     - set `STRICT_WINDOWS_INSTALLER_NAMING=1` (or workflow input `enforce_windows_installer_naming=true`) to enforce installer filename policy.
   - windows installer provenance strict mode:
     - set `STRICT_WINDOWS_INSTALLER_PROVENANCE=1` (or workflow input `enforce_windows_installer_provenance=true`) to enforce installer provenance verification and command evidence.
   - windows installer execution strict mode:
     - set `STRICT_WINDOWS_INSTALLER_EXECUTION=1` (or workflow input `enforce_windows_installer_execution=true`) to enforce installer command execution.
   - standalone Windows installer generation command check:
     - `pnpm run desktop:release:windows-installer:run`.
   - standalone Windows installer artifact check:
     - `pnpm run desktop:release:windows-installer:check`.
   - standalone Windows installer artifact check (strict packaging+naming):
     - `pnpm run desktop:release:windows-installer:check:strict`.
   - standalone Windows installer provenance check:
     - `pnpm run desktop:release:windows-installer:provenance`.
   - standalone Windows installer provenance check (strict):
     - `pnpm run desktop:release:windows-installer:provenance:strict`.
   - CI workflow entrypoint:
     - `.github/workflows/release-desktop-installer-smoke.yml` (`workflow_dispatch`).
4. Run release evidence index guard: `pnpm run desktop:release:evidence:check`.
5. Run update manifest guard: `pnpm run desktop:release:update-manifest:check`.
6. Generate and review evidence row snippets:
   - `pnpm run desktop:release:evidence:row:macos`
   - `pnpm run desktop:release:evidence:row:windows`
7. Generate and review evidence bundle summaries:
   - `pnpm run desktop:release:evidence:bundle:macos`
   - `pnpm run desktop:release:evidence:bundle:windows`
8. Generate evidence-index previews before applying table updates:
   - `pnpm run desktop:release:evidence:index:preview:macos`
   - `pnpm run desktop:release:evidence:index:preview:windows`
9. Generate and validate appcast preview:
   - `pnpm run desktop:release:appcast:generate`
   - strict platform coverage mode: `pnpm run desktop:release:appcast:generate:strict` (requires both macOS + Windows smoke reports).
   - `pnpm run desktop:release:appcast:check`
10. Publish appcast dry-run targets:
   - `pnpm run desktop:release:appcast:publish:dry-run`
11. Generate/check appcast publication bundle:
   - `pnpm run desktop:release:appcast:bundle:generate`
   - `pnpm run desktop:release:appcast:bundle:check`
12. Run external production guard:
   - `pnpm run desktop:release:appcast:external:production:guard`
   - non-dry-run publication requires explicit workflow input `allow_appcast_external_production=true`.
13. Run external publication readiness checks:
   - `pnpm run desktop:release:appcast:external:readiness`
   - use strict mode when production credentials/execution are expected: `pnpm run desktop:release:appcast:external:readiness:strict`.
   - strict production readiness additionally expects:
     - `APPCAST_EXTERNAL_IDENTITY_CHECK_COMMAND` (credential identity validation command),
     - `APPCAST_EXTERNAL_INVALIDATION_CHECK_COMMAND` (invalidation validation command),
     - `APPCAST_CACHE_INVALIDATION_COMMAND` (actual invalidation execution command).
14. Run external publication dry-run report:
   - `pnpm run desktop:release:appcast:publish:external:dry-run`
15. Record evidence in release checklist ticket and Phase C execution log.
16. Block release promotion if any required gate is missing or only manually asserted without evidence.

CI baseline note:
- `.github/workflows/tests-desktop-flutter.yml` includes `release-evidence-guard` and `release-update-manifest-guard` jobs, and uploads parity/build artifacts for audit traceability.
- `.github/workflows/tests-desktop-flutter.yml` `release-update-manifest-guard` job uploads `desktop-update-manifest-validation-report` artifact.
- `.github/workflows/tests-desktop-flutter.yml` desktop parity matrix uploads verify stage timing report artifacts (`desktop-verify-stage-timing-report-*`).
- `.github/workflows/tests-desktop-flutter.yml` desktop parity matrix uploads release script syntax report artifacts (`desktop-release-script-syntax-report-*`).
- `.github/workflows/tests-desktop-flutter.yml` desktop parity matrix uploads verify test coverage report artifacts (`desktop-verify-test-coverage-report-*`).
- `.github/workflows/tests-desktop-flutter.yml` desktop parity matrix uploads desktop command inventory report artifacts (`desktop-command-inventory-report-*`).
- `.github/workflows/release-desktop-installer-smoke.yml` includes `signing-readiness` job with optional strict enforcement via workflow input.
- `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job runs release script syntax and verify test coverage checks, and uploads `desktop-release-script-syntax-report-smoke` + `desktop-verify-test-coverage-report-smoke` artifacts.
- `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job also runs desktop command inventory checks and uploads `desktop-command-inventory-report-smoke` artifact.
- `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job also runs update manifest checks and uploads `desktop-update-manifest-validation-report-smoke` artifact.
- `desktop/scripts/verify_desktop.sh` now runs release script syntax checks, verify test coverage checks, and desktop command inventory checks before test/analyze/build phases, and executes contract/parity/mode-matrix tests through dedicated scripts to avoid duplicate suite execution.
- `desktop/scripts/verify_desktop.sh` emits verify stage timing reports (`release/reports/verify_stage_timing_report.md`) including stage-level durations and status.
- `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job runs release smoke gate policy preflight and uploads gate policy report artifact.
- `.github/workflows/release-desktop-installer-smoke.yml` supports strict signing command-hook enforcement via `enforce_signing_command_hooks` input.
- `.github/workflows/release-desktop-installer-smoke.yml` supports strict signing placeholder hygiene enforcement via `enforce_signing_placeholder_hygiene` input.
- `.github/workflows/release-desktop-installer-smoke.yml` supports strict signing execution enforcement via `enforce_signing_execution` input.
- `.github/workflows/release-desktop-installer-smoke.yml` supports strict signing provenance enforcement via `enforce_signing_provenance` input.
- `.github/workflows/release-desktop-installer-smoke.yml` supports strict Windows installer artifact enforcement via `enforce_windows_installer_packaging` input.
- `.github/workflows/release-desktop-installer-smoke.yml` supports strict Windows installer naming enforcement via `enforce_windows_installer_naming` input.
- `.github/workflows/release-desktop-installer-smoke.yml` supports strict Windows installer provenance enforcement via `enforce_windows_installer_provenance` input.
- `.github/workflows/release-desktop-installer-smoke.yml` supports strict Windows installer execution enforcement via `enforce_windows_installer_execution` input.
- `.github/workflows/release-desktop-installer-smoke.yml` builds macOS/Windows release artifacts on demand and uploads installer/update smoke archives + JSON reports.
- `.github/workflows/release-desktop-installer-smoke.yml` uploads per-platform signing pipeline reports generated during smoke execution.
- `.github/workflows/release-desktop-installer-smoke.yml` uploads per-platform signing provenance reports generated during smoke execution.
- `.github/workflows/release-desktop-installer-smoke.yml` uploads Windows installer packaging/pipeline/provenance report artifacts only on `windows` matrix runs.
- `.github/workflows/release-desktop-installer-smoke.yml` also uploads platform release-evidence row snippet artifacts generated from smoke reports.
- `.github/workflows/release-desktop-installer-smoke.yml` also uploads platform release-evidence bundle summary artifacts generated from smoke reports.
- `.github/workflows/release-desktop-installer-smoke.yml` also uploads release-evidence index preview artifacts generated from row snippets.
- `.github/workflows/release-desktop-installer-smoke.yml` runs an `appcast-preview` job that generates/checks/uploads appcast preview JSON from smoke reports.
- `.github/workflows/release-desktop-installer-smoke.yml` appcast-preview generation step enforces strict platform coverage (`APPCAST_REQUIRE_BOTH_PLATFORMS=1`) so both macOS and Windows smoke reports must be present.
- `.github/workflows/release-desktop-installer-smoke.yml` appcast-preview job also produces channel/version appcast publish dry-run targets.
- `.github/workflows/release-desktop-installer-smoke.yml` appcast-preview job also produces and validates appcast publication bundle artifacts.
- `.github/workflows/release-desktop-installer-smoke.yml` supports explicit non-dry-run external publication consent via `allow_appcast_external_production` input.
- `.github/workflows/release-desktop-installer-smoke.yml` appcast-preview job runs external production guard checks and uploads production guard report artifacts.
- `.github/workflows/release-desktop-installer-smoke.yml` supports strict external publication readiness enforcement via `enforce_appcast_external_readiness` input.
- `.github/workflows/release-desktop-installer-smoke.yml` appcast-preview job runs external publication readiness checks and uploads readiness report artifacts.
- `.github/workflows/release-desktop-installer-smoke.yml` appcast-preview readiness step accepts production identity/invalidation validation command hooks (`APPCAST_EXTERNAL_IDENTITY_CHECK_COMMAND`, `APPCAST_EXTERNAL_INVALIDATION_CHECK_COMMAND`).
- `.github/workflows/release-desktop-installer-smoke.yml` appcast-preview job optionally runs external publication stage and uploads publication report artifact.
- `desktop/scripts/check_release_evidence_index.sh` now enforces release evidence table schema (8 columns), RC+platform uniqueness, and decision value validity.
- Update manifest baseline file: `desktop/release/update_manifest.example.json`.
- Update manifest checker: `desktop/scripts/check_update_manifest.sh` (outputs `release/reports/update_manifest_validation_report.md`).
- Installer/update smoke report generator: `desktop/scripts/generate_installer_update_report.sh`.
- Release smoke gate policy checker: `desktop/scripts/check_release_smoke_gate_policy.sh`.
- Release script syntax checker: `desktop/scripts/check_release_script_syntax.sh`.
- Verify test coverage checker: `desktop/scripts/check_verify_test_coverage.sh`.
- Desktop command inventory checker: `desktop/scripts/check_desktop_command_inventory.sh`.
- Contract test runner: `desktop/scripts/run_contract_tests.sh`.
- Release evidence row generator: `desktop/scripts/generate_release_evidence_row.sh`.
- Release evidence bundle summary generator: `desktop/scripts/generate_release_evidence_bundle.sh`.
- Release evidence index updater: `desktop/scripts/update_release_evidence_index.sh`.
- Appcast preview generator/checker: `desktop/scripts/generate_appcast_from_reports.sh`, `desktop/scripts/check_appcast.sh`.
- Appcast publish dry-run script: `desktop/scripts/publish_appcast.sh`.
- Appcast publication bundle generator/checker: `desktop/scripts/generate_appcast_publication_bundle.sh`, `desktop/scripts/check_appcast_publication_bundle.sh`.
- Appcast external production guard: `desktop/scripts/guard_appcast_external_production.sh`.
- Appcast external publication readiness checker: `desktop/scripts/check_appcast_external_readiness.sh`.
- Appcast external publication runner: `desktop/scripts/publish_appcast_external.sh`.
- Signing readiness checker: `desktop/scripts/check_signing_readiness.sh`.
- Signing execution pipeline runners: `desktop/scripts/run_signing_pipeline.sh`, `desktop/scripts/run_signing_with_build.sh`.
- Signing provenance checker: `desktop/scripts/check_signing_artifact_provenance.sh`.
- Windows installer pipeline runner: `desktop/scripts/run_windows_installer_pipeline.sh`.
- Windows installer packaging checker: `desktop/scripts/check_windows_installer_packaging.sh`.
- Windows installer provenance checker: `desktop/scripts/check_windows_installer_provenance.sh`.

## 5) Implementation backlog seeds

1. Wire actual platform signing/notarization/verify commands into `PENJAR_*_SIGN_COMMAND`, `PENJAR_MACOS_NOTARIZE_COMMAND`, and `PENJAR_*_SIGN_VERIFY_COMMAND` secrets with hardened diagnostics.
2. Wire actual Windows installer generation/provenance commands into `PENJAR_WINDOWS_INSTALLER_COMMAND` and `PENJAR_WINDOWS_INSTALLER_PROVENANCE_COMMAND`.
3. Provision production external publication credentials/role wiring and validate non-dry-run invalidation command execution against target environment.
4. Promote evidence index preview automation into governed auto-apply (PR/comment gate) workflow.
