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
- [Desktop Flutter Parity Checklist](/technical-guide/developer/desktop-flutter-parity-checklist/)
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
   - run release script syntax contract check: `pnpm run desktop:release:scripts:syntax:contract:check`.
   - run verify test coverage check: `pnpm run desktop:test:coverage:check`.
   - run verify test coverage contract check: `pnpm run desktop:test:coverage:contract:check`.
   - run auth-store legacy decommission check (strict): `STRICT_AUTH_STORE_LEGACY_DECOMMISSION=1 pnpm run desktop:auth-store:legacy-decommission:check`.
   - run auth-store legacy decommission contract check: `pnpm run desktop:auth-store:legacy-decommission:contract:check`.
   - run auth-store runtime decommission check: `pnpm run desktop:auth-store:runtime-decommission:check`.
   - run auth-store runtime decommission contract check: `pnpm run desktop:auth-store:runtime-decommission:contract:check`.
   - run desktop command inventory check: `pnpm run desktop:docs:command-inventory:check`.
   - run desktop command inventory contract check: `pnpm run desktop:docs:command-inventory:contract:check`.
   - run Windows installer pipeline contract check: `pnpm run desktop:release:windows-installer:contract:check`.
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
     - strict execution checks reject placeholder sign/notarize command hooks (for example `echo ...`, `<...>`, `todo`/`tbd` markers).
   - signing provenance strict mode:
     - set `STRICT_SIGNING_PROVENANCE=1` (or workflow input `enforce_signing_provenance=true`) to enforce artifact hash + sign-verify command evidence.
     - strict provenance checks reject placeholder verify command hooks (for example `echo ...`, `<...>`, `todo`/`tbd` markers).
   - signing readiness command hooks also include provenance verification hooks:
     - `PENJAR_MACOS_SIGN_VERIFY_COMMAND`,
     - `PENJAR_WINDOWS_SIGN_VERIFY_COMMAND`,
     - `PENJAR_WINDOWS_INSTALLER_PROVENANCE_COMMAND`.
   - signing readiness checks require protocol register command hook (`PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND`) when `STRICT_WINDOWS_PROTOCOL_REGISTRATION=1`.
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
   - windows protocol registration strict mode:
     - set `STRICT_WINDOWS_PROTOCOL_REGISTRATION=1` (or workflow input `enforce_windows_protocol_registration=true`) to enforce protocol registration command execution.
   - strict Windows installer execution/provenance/protocol-registration modes reject placeholder command hooks (for example `echo ...`, `<...>`, `todo`/`tbd` markers).
   - standalone Windows installer generation command check:
     - `pnpm run desktop:release:windows-installer:run`.
   - optional Windows protocol registration command hook:
     - `PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND` (installer/pipeline-time URL protocol registration command),
     - optional overrides: `PENJAR_WINDOWS_PROTOCOL_SCHEME`, `PENJAR_WINDOWS_PROTOCOL_TARGET_PATH`.
     - helper script baseline: `desktop/scripts/register_windows_protocol.ps1` (HKCU protocol registration template for `penjar://`).
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
4. Run release evidence index guard suite:
   - `pnpm run desktop:release:evidence:check`
   - output report: `release/reports/release_evidence_index_check_report.md`
   - `pnpm run desktop:release:evidence:contract:check`
5. Run update manifest guard suite:
   - `pnpm run desktop:release:update-manifest:check`
   - `pnpm run desktop:release:update-manifest:contract:check`
6. Run release smoke gate policy contract guard: `pnpm run desktop:release:smoke:gate-policy:contract:check`.
7. Generate and review evidence row snippets:
   - `pnpm run desktop:release:evidence:row:macos`
   - `pnpm run desktop:release:evidence:row:windows`
8. Generate and review evidence bundle summaries:
   - `pnpm run desktop:release:evidence:bundle:macos`
   - `pnpm run desktop:release:evidence:bundle:windows`
   - check bundle status summaries:
     - `pnpm run desktop:release:evidence:bundle:check:macos`
     - `pnpm run desktop:release:evidence:bundle:check:windows`
   - strict bundle check mode (fails on risky summary statuses):
     - `pnpm run desktop:release:evidence:bundle:check:macos:strict`
     - `pnpm run desktop:release:evidence:bundle:check:windows:strict`
9. Generate evidence-index previews before applying table updates:
   - `pnpm run desktop:release:evidence:index:preview:macos`
   - `pnpm run desktop:release:evidence:index:preview:windows`
10. Generate and validate appcast preview:
   - `pnpm run desktop:release:appcast:generate`
   - strict platform coverage mode: `pnpm run desktop:release:appcast:generate:strict` (requires both macOS + Windows smoke reports).
   - `pnpm run desktop:release:appcast:check`
11. Publish appcast dry-run targets:
   - `pnpm run desktop:release:appcast:publish:dry-run`
12. Generate/check appcast publication bundle:
   - `pnpm run desktop:release:appcast:bundle:generate`
   - `pnpm run desktop:release:appcast:bundle:check`
13. Run external production guard:
   - `pnpm run desktop:release:appcast:external:production:guard`
   - non-dry-run publication requires explicit workflow input `allow_appcast_external_production=true`.
14. Run external publication readiness checks:
   - `pnpm run desktop:release:appcast:external:readiness`
   - use strict mode when production credentials/execution are expected: `pnpm run desktop:release:appcast:external:readiness:strict`.
   - strict production readiness additionally expects:
     - `APPCAST_EXTERNAL_IDENTITY_CHECK_COMMAND` (credential identity validation command),
     - `APPCAST_EXTERNAL_INVALIDATION_CHECK_COMMAND` (invalidation validation command),
     - `APPCAST_CACHE_INVALIDATION_COMMAND` (actual invalidation execution command).
   - strict mode also rejects placeholder command hooks (for example `echo ...`, `<...>`, `todo`/`tbd` markers) for identity/invalidation/invalidation-execution checks.
15. Run external publication dry-run report:
   - `pnpm run desktop:release:appcast:publish:external:dry-run`
16. Record evidence in release checklist ticket and Phase C execution log.
17. Block release promotion if any required gate is missing or only manually asserted without evidence.

CI baseline note:
- `.github/workflows/tests-desktop-flutter.yml` includes `release-evidence-guard` and `release-update-manifest-guard` jobs, and uploads parity/build artifacts for audit traceability.
- `.github/workflows/tests-desktop-flutter.yml` `release-evidence-guard` job runs release evidence base + contract checks and uploads `desktop-release-evidence-index-check-report-guard` and `desktop-release-evidence-index-contract-report-guard` artifacts.
- `.github/workflows/tests-desktop-flutter.yml` `release-update-manifest-guard` job uploads `desktop-update-manifest-validation-report` artifact.
- `.github/workflows/tests-desktop-flutter.yml` `release-update-manifest-guard` job also runs update manifest contract checks and uploads `desktop-update-manifest-contract-report` artifact.
- `.github/workflows/tests-desktop-flutter.yml` desktop parity matrix uploads verify stage timing report artifacts (`desktop-verify-stage-timing-report-*`).
- `.github/workflows/tests-desktop-flutter.yml` desktop parity matrix uploads release script syntax report artifacts (`desktop-release-script-syntax-report-*`).
- `.github/workflows/tests-desktop-flutter.yml` desktop parity matrix uploads release script syntax contract report artifacts (`desktop-release-script-syntax-contract-report-*`).
- `.github/workflows/tests-desktop-flutter.yml` desktop parity matrix uploads verify test coverage report artifacts (`desktop-verify-test-coverage-report-*`).
- `.github/workflows/tests-desktop-flutter.yml` desktop parity matrix uploads verify test coverage contract report artifacts (`desktop-verify-test-coverage-contract-report-*`).
- `.github/workflows/tests-desktop-flutter.yml` desktop parity matrix uploads desktop command inventory report artifacts (`desktop-command-inventory-report-*`).
- `.github/workflows/tests-desktop-flutter.yml` desktop parity matrix uploads desktop command inventory contract report artifacts (`desktop-command-inventory-contract-report-*`).
- `.github/workflows/tests-desktop-flutter.yml` desktop parity matrix uploads update manifest validation report artifacts (`desktop-update-manifest-validation-report-*`).
- `.github/workflows/tests-desktop-flutter.yml` desktop parity matrix uploads update manifest contract report artifacts (`desktop-update-manifest-contract-report-*`).
- `.github/workflows/tests-desktop-flutter.yml` desktop parity matrix uploads release smoke gate policy contract report artifacts (`desktop-release-smoke-gate-policy-contract-report-*`).
- `.github/workflows/tests-desktop-flutter.yml` desktop parity matrix uploads windows installer pipeline contract report artifacts (`desktop-windows-installer-pipeline-contract-report-*`).
- `.github/workflows/tests-desktop-flutter.yml` desktop parity matrix uploads release evidence index check report artifacts (`desktop-release-evidence-index-check-report-*`).
- `.github/workflows/tests-desktop-flutter.yml` desktop parity matrix uploads release evidence index contract report artifacts (`desktop-release-evidence-index-contract-report-*`).
- `.github/workflows/release-desktop-installer-smoke.yml` includes `signing-readiness` job with optional strict enforcement via workflow input.
- `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job runs release script syntax and verify test coverage checks, and uploads `desktop-release-script-syntax-report-smoke` + `desktop-verify-test-coverage-report-smoke` artifacts.
- `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job also runs verify test coverage contract checks and uploads `desktop-verify-test-coverage-contract-report-smoke` artifact.
- `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job also runs auth-store legacy decommission checks in strict mode and uploads `desktop-auth-store-legacy-decommission-report-smoke` artifact.
- `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job also runs auth-store legacy decommission contract checks and uploads `desktop-auth-store-legacy-decommission-contract-report-smoke` artifact.
- `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job also runs auth-store runtime decommission checks and uploads `desktop-auth-store-runtime-decommission-report-smoke` artifact.
- `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job also runs auth-store runtime decommission contract checks and uploads `desktop-auth-store-runtime-decommission-contract-report-smoke` artifact.
- `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job also runs release script syntax contract checks and uploads `desktop-release-script-syntax-contract-report-smoke` artifact.
- `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job also runs desktop command inventory checks and uploads `desktop-command-inventory-report-smoke` artifact.
- `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job also runs desktop command inventory contract checks and uploads `desktop-command-inventory-contract-report-smoke` artifact.
- `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job also runs update manifest checks and uploads `desktop-update-manifest-validation-report-smoke` artifact.
- `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job also runs update manifest contract checks and uploads `desktop-update-manifest-contract-report-smoke` artifact.
- `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job also runs release smoke gate policy contract checks and uploads `desktop-release-smoke-gate-policy-contract-report` artifact.
- `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job also runs windows installer pipeline contract checks and uploads `desktop-windows-installer-pipeline-contract-report-smoke` artifact.
- `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job now runs release evidence index base + contract checks and uploads `desktop-release-evidence-index-check-report-smoke` and `desktop-release-evidence-index-contract-report-smoke` artifacts.
- `desktop/scripts/verify_desktop.sh` now runs release script syntax checks, release script syntax contract checks, verify test coverage checks, verify test coverage contract checks, strict auth-store legacy decommission checks (`STRICT_AUTH_STORE_LEGACY_DECOMMISSION=1`), auth-store legacy decommission contract checks, auth-store runtime decommission checks, auth-store runtime decommission contract checks, desktop command inventory checks, desktop command inventory contract checks, update manifest checks, update manifest contract checks, release smoke gate policy contract checks, Windows installer pipeline contract checks, release evidence index base checks, and release evidence index contract checks before test/analyze/build phases, and executes contract/parity/mode-matrix tests through dedicated scripts to avoid duplicate suite execution.
- `desktop/scripts/verify_desktop.sh` emits verify stage timing reports (`release/reports/verify_stage_timing_report.md`) including stage-level durations and status.
- `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness job runs release smoke gate policy preflight and uploads gate policy report artifact.
- `.github/workflows/release-desktop-installer-smoke.yml` supports strict signing command-hook enforcement via `enforce_signing_command_hooks` input.
- `.github/workflows/release-desktop-installer-smoke.yml` supports strict signing placeholder hygiene enforcement via `enforce_signing_placeholder_hygiene` input.
- `.github/workflows/release-desktop-installer-smoke.yml` signing-readiness command-hook checks include sign-verify/provenance hooks by default (`PENJAR_MACOS_SIGN_VERIFY_COMMAND`, `PENJAR_WINDOWS_SIGN_VERIFY_COMMAND`, `PENJAR_WINDOWS_INSTALLER_PROVENANCE_COMMAND`), and require `PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND` when `enforce_windows_protocol_registration=true`.
- `.github/workflows/release-desktop-installer-smoke.yml` supports strict signing execution enforcement via `enforce_signing_execution` input.
- `.github/workflows/release-desktop-installer-smoke.yml` gate-policy preflight now requires `enforce_signing_placeholder_hygiene=true` when `enforce_signing_execution=true`.
- `.github/workflows/release-desktop-installer-smoke.yml` gate-policy preflight now requires `enforce_signing_readiness=true` when `enforce_signing_execution=true` or `enforce_signing_provenance=true`.
- `.github/workflows/release-desktop-installer-smoke.yml` strict signing execution checks now enforce placeholder-hygiene for sign/notarize command hooks.
- `.github/workflows/release-desktop-installer-smoke.yml` supports strict signing provenance enforcement via `enforce_signing_provenance` input.
- `.github/workflows/release-desktop-installer-smoke.yml` signing provenance checks now enforce verify-command placeholder hygiene in strict mode.
- `.github/workflows/release-desktop-installer-smoke.yml` supports strict Windows installer artifact enforcement via `enforce_windows_installer_packaging` input.
- `.github/workflows/release-desktop-installer-smoke.yml` supports strict Windows installer naming enforcement via `enforce_windows_installer_naming` input.
- `.github/workflows/release-desktop-installer-smoke.yml` supports strict Windows installer provenance enforcement via `enforce_windows_installer_provenance` input.
- `.github/workflows/release-desktop-installer-smoke.yml` supports strict Windows installer execution enforcement via `enforce_windows_installer_execution` input.
- `.github/workflows/release-desktop-installer-smoke.yml` supports strict Windows protocol registration enforcement via `enforce_windows_protocol_registration` input.
- `.github/workflows/release-desktop-installer-smoke.yml` strict Windows installer execution/provenance/protocol-registration checks now include placeholder-hygiene enforcement for command hooks.
- `.github/workflows/release-desktop-installer-smoke.yml` gate-policy preflight now requires `STRICT_WINDOWS_INSTALLER_PACKAGING=1` when `STRICT_WINDOWS_INSTALLER_PROVENANCE=1`.
- `.github/workflows/release-desktop-installer-smoke.yml` gate-policy preflight now models `STRICT_WINDOWS_INSTALLER_NAMING` and requires:
  - `STRICT_WINDOWS_INSTALLER_NAMING=1` -> `STRICT_WINDOWS_INSTALLER_EXECUTION=1` + `STRICT_WINDOWS_INSTALLER_PACKAGING=1`,
  - `STRICT_WINDOWS_INSTALLER_PROVENANCE=1` -> `STRICT_WINDOWS_INSTALLER_NAMING=1`.
- `.github/workflows/release-desktop-installer-smoke.yml` gate-policy preflight now requires `STRICT_WINDOWS_INSTALLER_EXECUTION=1` when `STRICT_WINDOWS_PROTOCOL_REGISTRATION=1`.
- `.github/workflows/release-desktop-installer-smoke.yml` supports strict release evidence bundle enforcement via `enforce_release_evidence_bundle` input.
- `.github/workflows/release-desktop-installer-smoke.yml` gate-policy preflight now models `STRICT_RELEASE_EVIDENCE_BUNDLE` dependencies (`STRICT_SIGNING_PROVENANCE=1`, `STRICT_WINDOWS_INSTALLER_PROVENANCE=1`, and `STRICT_WINDOWS_PROTOCOL_REGISTRATION=1`).
- `.github/workflows/release-desktop-installer-smoke.yml` gate-policy preflight now requires configured external provider when `publish_appcast_external=true`, and for non-dry-run external publication requires `enforce_appcast_external_readiness=true` plus `enforce_release_evidence_bundle=true`.
- `.github/workflows/release-desktop-installer-smoke.yml` builds macOS/Windows release artifacts on demand and uploads installer/update smoke archives + JSON reports.
- `.github/workflows/release-desktop-installer-smoke.yml` uploads per-platform signing pipeline reports generated during smoke execution.
- `.github/workflows/release-desktop-installer-smoke.yml` uploads per-platform signing provenance reports generated during smoke execution.
- `.github/workflows/release-desktop-installer-smoke.yml` uploads Windows installer packaging/pipeline/provenance report artifacts only on `windows` matrix runs.
- `.github/workflows/release-desktop-installer-smoke.yml` also uploads platform release-evidence row snippet artifacts generated from smoke reports.
- `.github/workflows/release-desktop-installer-smoke.yml` also uploads platform release-evidence bundle summary artifacts generated from smoke reports.
- `.github/workflows/release-desktop-installer-smoke.yml` also checks and uploads platform release-evidence bundle check reports (`desktop-release-evidence-bundle-check-*`).
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
- `.github/workflows/release-desktop-installer-smoke.yml` strict external readiness mode now enforces placeholder-hygiene checks for identity/invalidation/cache-invalidation command hooks.
- `.github/workflows/release-desktop-installer-smoke.yml` appcast-preview job optionally runs external publication stage and uploads publication report artifact.
- `desktop/scripts/check_release_evidence_index.sh` now enforces release evidence table schema (8 columns), RC+platform uniqueness, decision value validity, and required attachment references for core verification reports (with in-memory duplicate-key tracking to avoid per-row file I/O), and emits `release/reports/release_evidence_index_check_report.md` for traceable pass/fail diagnostics.
- Update manifest baseline file: `desktop/release/update_manifest.example.json`.
- Update manifest checker: `desktop/scripts/check_update_manifest.sh` (outputs `release/reports/update_manifest_validation_report.md`).
- Update manifest contract checker: `desktop/scripts/check_update_manifest_contract.sh`.
- Installer/update smoke report generator: `desktop/scripts/generate_installer_update_report.sh`.
- Release smoke gate policy checker: `desktop/scripts/check_release_smoke_gate_policy.sh`.
- Release smoke gate policy contract checker: `desktop/scripts/check_release_smoke_gate_policy_contract.sh`.
- Release script syntax checker: `desktop/scripts/check_release_script_syntax.sh` (recursive scan across `desktop/scripts/**/*.sh`, including shared helper modules under `desktop/scripts/lib/`).
- Release script syntax contract checker: `desktop/scripts/check_release_script_syntax_contract.sh`.
- Verify test coverage checker: `desktop/scripts/check_verify_test_coverage.sh` (sorted set-diff comparison for uncovered/missing references via `comm`).
- Verify test coverage contract checker: `desktop/scripts/check_verify_test_coverage_contract.sh`.
- Desktop command inventory checker: `desktop/scripts/check_desktop_command_inventory.sh`.
- Desktop command inventory contract checker: `desktop/scripts/check_desktop_command_inventory_contract.sh`.
- Windows installer pipeline contract checker: `desktop/scripts/check_windows_installer_pipeline_contract.sh`.
  - contract matrix now includes strict installer execution cases (missing/placeholder/clear
    command) and strict installer + protocol placeholder interaction coverage.
  - contract matrix now also locks debug build-mode runner resolution and strict protocol missing
    command behavior in debug mode.
  - contract matrix now also locks strict missing-runner failure behavior for installer strict mode
    and strict protocol mode across release/debug build modes.
  - contract matrix now also locks strict non-zero command failure behavior for installer/protocol
    command execution paths across release/debug build modes.
  - contract matrix now also locks strict installer + protocol non-zero interaction failures across
    release/debug build modes.
  - contract matrix now also locks non-strict warning behavior for installer/protocol command
    failures and placeholder command paths in release mode.
  - contract matrix now also locks non-strict warning behavior for installer/protocol command
    failures and placeholder command paths in debug mode.
  - strict protocol mode now has dedicated regression coverage proving installer command non-zero
    failures remain non-blocking when protocol registration succeeds (release/debug).
  - strict protocol mode now also has dedicated regression coverage for installer placeholder
    interactions that remain non-blocking when protocol registration succeeds (release/debug).
  - contract matrix now also locks strict and strict-protocol toggle alias parsing (`true|yes|strict`)
    for deterministic strict-mode behavior.
  - alias matrix coverage now explicitly includes remaining `yes/strict/true` interaction paths
    across strict installer and strict protocol release/debug scenarios.
  - pipeline runtime path now caches runner-directory existence state (`runner_exists`) for branch
    reuse and revalidates before protocol-stage execution to avoid stale-state regressions when
    installer commands mutate runner artifacts.
  - contract matrix now also locks release/debug strict-protocol behavior when installer commands
    remove runner artifacts before protocol-stage evaluation, preserving simulated/non-blocking
    protocol status semantics.
  - contract matrix now also locks case-insensitive strict/strict-protocol alias parsing
    (`YES`/`TRUE`/`StRiCt`/`YeS`) for deterministic strict-mode semantics across release/debug
    scenarios.
  - strict toggle parser now trims leading/trailing whitespace before lowercase normalization, and
    contract coverage explicitly locks whitespace alias handling (`" yes "`, `" true "`).
  - contract matrix now also locks tab-wrapped strict alias handling (`"\tYES\t"`, `"\tTRUE\t"`)
    to prevent whitespace-class normalization regressions.
  - contract matrix now also locks newline-wrapped strict alias handling (`"\nYES\n"`,
    `"\nTRUE\n"`) to prevent whitespace-class normalization regressions.
  - strict toggle runtime parser now uses builtin case-pattern matching after trim normalization to
    avoid repeated external lowercase command execution while preserving strict semantics.
  - contract matrix now also locks whitespace-wrapped numeric strict alias handling (`" 1 "`) for
    strict installer/protocol deterministic fail semantics.
  - contract matrix now also locks carriage-return-wrapped strict alias handling (`"\rYES\r"`,
    `"\rTRUE\r"`) to prevent Windows-style line-ending normalization regressions.
  - contract matrix now also locks form-feed/vertical-tab wrapped strict alias handling
    (`"\fYES\f"`, `"\vTRUE\v"`) to prevent remaining whitespace-class trim regressions.
  - contract report row rendering now escapes control-character, backslash, and pipe content in
    case/result cells so mismatch diagnostics remain Markdown-table safe.
  - markdown cell escaping path now uses a subshell-free helper handoff (shared escaped buffer)
    instead of per-cell command substitutions to reduce shell overhead in large matrices.
  - run-case report/log assertion checks now use bash internal string containment over loaded
    artifacts, avoiding repeated external `grep` process invocations per matrix case.
  - contract matrix now also locks non-strict guard alias behavior (`false`, `off`, and
    whitespace-wrapped ` false `) so strict parser inference does not overmatch unknown/negative
    toggle values for installer/protocol paths.
  - contract matrix now also locks CRLF-wrapped strict alias handling (`"\r\nYES\r\n"`,
    `"\r\nTRUE\r\n"`) to prevent mixed Windows line-ending boundary regressions.
  - strict toggle runtime parser now resolves trim normalization through a shared normalized buffer
    instead of command-substitution return path to reduce subshell overhead while preserving alias
    inference behavior.
  - contract matrix now also locks whitespace-wrapped numeric zero alias behavior (`" 0 "`) so
    installer/protocol strict parser inference keeps zero-valued toggles explicitly non-strict.
  - contract matrix now also locks near-match alias behavior (`truee`, `yesplease`, `strict-mode`)
    so strict parser inference remains exact-match based and does not overmatch prefixed/suffixed
    variants.
  - contract checker now performs pipeline-script preflight (file existence + executable bit)
    before running matrix cases, failing fast with explicit diagnostics on invalid local script
    state.
  - contract checker temp workspace path now uses single scratch-root allocation + per-case
    subdirectories (with exit trap cleanup) instead of per-case `mktemp -d`, reducing matrix
    filesystem/process overhead while preserving isolation.
  - contract matrix now also locks near-match alias placeholder-warning behavior (`truee`) so
    installer/protocol command-placeholder paths remain non-strict warning flows rather than strict
    failures.
  - contract checker now validates case-name uniqueness before executing matrix cases, failing fast
    on duplicate case IDs to prevent ambiguous report rows and hidden regression coverage drift.
  - contract matrix now also locks newline-wrapped uppercase near-match alias behavior
    (`"\nTRUEE\n"`) so trim + case normalization still preserves exact-match strict boundaries.
  - contract matrix now also locks numeric near-match alias behavior (`"01"`, `"1.0"`) so strict
    numeric alias inference stays exact (`"1"`) and does not broaden to non-canonical variants.
  - contract matrix now also locks signed/exponent numeric near-match alias behavior (`"+1"`,
    `"1e0"`) so strict numeric alias inference remains exact (`"1"`) without numeric parser drift.
  - contract matrix now also locks base-notation numeric near-match alias behavior (`"0x1"`,
    `"0b1"`) so strict numeric alias inference cannot drift into radix-style coercion paths.
  - contract matrix now also locks uppercase base-notation numeric near-match alias behavior
    (`"0X1"`, `"0B1"`) so case normalization changes cannot broaden strict numeric acceptance.
  - contract matrix now also locks separator/locale numeric near-match alias behavior (`"1_0"`,
    `"1,0"`) so numeric formatting/coercion paths cannot widen strict numeric alias acceptance.
  - contract matrix now also locks quoted numeric near-match alias behavior (`"\"1\""`, `"'1'"`)
    so accidental quoting in env wiring cannot widen strict numeric alias acceptance.
  - contract matrix now also locks wrapper-form numeric near-match alias behavior (`"(1)"`,
    `"[1]"`) so accidental wrapper formatting cannot widen strict numeric alias acceptance.
  - contract matrix now also locks trim-wrapped numeric near-match alias behavior (`" 1.0 "`,
    `"\\t+1\\t"`) so trim normalization cannot widen strict numeric alias acceptance.
  - contract matrix now also locks internal-separator numeric near-match alias behavior (`"1 0"`,
    `"1\\n0"`) so token-boundary parsing cannot widen strict numeric alias acceptance.
  - contract matrix now also locks control-separator numeric near-match alias behavior (`"1\\r0"`,
    `"1\\t0"`) so control-character token boundaries cannot widen strict numeric alias acceptance.
  - contract matrix now also locks expression-style numeric near-match alias behavior (`"1+0"`,
    `"1-0"`) so expression-like numeric values cannot widen strict numeric alias acceptance.
  - contract matrix now also locks arithmetic-operator numeric near-match alias behavior
    (`"1*1"`, `"1/1"`) so operator-style numeric values cannot widen strict numeric alias acceptance.
  - contract matrix now also locks extended arithmetic numeric near-match alias behavior
    (`"1%1"`, `"1^1"`) so extended operator-style numeric values cannot widen strict acceptance.
  - contract matrix now also locks bitwise-expression numeric near-match alias behavior
    (`"1&1"`, `"1|1"`) so bitwise-style numeric values cannot widen strict acceptance.
  - contract matrix now also locks comparison-expression numeric near-match alias behavior
    (`"1<1"`, `"1>1"`) so comparison-style numeric values cannot widen strict acceptance.
  - contract matrix now also locks equality-expression numeric near-match alias behavior
    (`"1==1"`, `"1!=1"`) so equality-style numeric values cannot widen strict acceptance.
  - contract matrix now also locks logical-expression numeric near-match alias behavior
    (`"1&&1"`, `"1||1"`) so logical-style numeric values cannot widen strict acceptance.
  - contract matrix now also locks shift-expression numeric near-match alias behavior
    (`"1<<1"`, `"1>>1"`) so shift-style numeric values cannot widen strict acceptance.
  - contract matrix now also locks inclusive-comparison numeric near-match alias behavior
    (`"1<=1"`, `"1>=1"`) so inclusive-comparison values cannot widen strict acceptance.
  - contract matrix now also locks strict-equality numeric near-match alias behavior
    (`"1===1"`, `"1!==1"`) so strict-equality values cannot widen strict acceptance.
  - contract matrix now also locks nullish-optional numeric near-match alias behavior
    (`"1??1"`, `"1?.1"`) so nullish/optional values cannot widen strict acceptance.
  - contract matrix now also locks assignment-expression numeric near-match alias behavior
    (`"1+=0"`, `"1-=0"`) so assignment-style values cannot widen strict acceptance.
  - contract matrix now also locks multiplicative-assignment numeric near-match alias behavior
    (`"1*=1"`, `"1/=1"`) so multiplicative-assignment values cannot widen strict acceptance.
  - contract matrix now also locks modulo-xor-assignment numeric near-match alias behavior
    (`"1%=1"`, `"1^=1"`) so modulo/xor-assignment values cannot widen strict acceptance.
  - contract matrix now also locks bitwise-and-or-assignment numeric near-match alias behavior
    (`"1&=1"`, `"1|=1"`) so bitwise-and/or-assignment values cannot widen strict acceptance.
  - contract matrix now also locks shift-assignment numeric near-match alias behavior
    (`"1<<=1"`, `"1>>=1"`) so shift-assignment values cannot widen strict acceptance.
  - contract matrix now also locks logical-assignment numeric near-match alias behavior
    (`"1&&=1"`, `"1||=1"`) so logical-assignment values cannot widen strict acceptance.
  - assertion scanning in `desktop/scripts/check_windows_installer_pipeline_contract.sh` now uses
    fixed-string file checks (`grep -Fq`) for report/log pattern verification instead of loading
    full file contents into shell variables per case.
- Contract test runner: `desktop/scripts/run_contract_tests.sh`.
- Release evidence row generator: `desktop/scripts/generate_release_evidence_row.sh`.
- Release evidence bundle summary generator: `desktop/scripts/generate_release_evidence_bundle.sh`.
- Release evidence bundle checker: `desktop/scripts/check_release_evidence_bundle.sh`.
- Release evidence index updater: `desktop/scripts/update_release_evidence_index.sh`.
- Release evidence index contract checker: `desktop/scripts/check_release_evidence_index_contract.sh` (includes missing-base-check-report attachment, missing-index-file, invalid-decision, and promoted-placeholder regression cases).
- Appcast preview generator/checker: `desktop/scripts/generate_appcast_from_reports.sh`, `desktop/scripts/check_appcast.sh`.
- Appcast publish dry-run script: `desktop/scripts/publish_appcast.sh`.
- Appcast publication bundle generator/checker: `desktop/scripts/generate_appcast_publication_bundle.sh`, `desktop/scripts/check_appcast_publication_bundle.sh`.
- Appcast external production guard: `desktop/scripts/guard_appcast_external_production.sh`.
- Appcast external publication readiness checker: `desktop/scripts/check_appcast_external_readiness.sh`.
- Appcast external publication runner: `desktop/scripts/publish_appcast_external.sh`.
- Shared placeholder command-hygiene helper: `desktop/scripts/lib/placeholder_hygiene.sh`.
- Signing readiness checker: `desktop/scripts/check_signing_readiness.sh`.
- Signing execution pipeline runners: `desktop/scripts/run_signing_pipeline.sh`, `desktop/scripts/run_signing_with_build.sh`.
- Signing provenance checker: `desktop/scripts/check_signing_artifact_provenance.sh`.
- Windows installer pipeline runner: `desktop/scripts/run_windows_installer_pipeline.sh`.
- Windows installer packaging checker: `desktop/scripts/check_windows_installer_packaging.sh`.
- Windows installer provenance checker: `desktop/scripts/check_windows_installer_provenance.sh`.

## 5) Implementation backlog seeds

1. Wire actual platform signing/notarization/verify commands into `PENJAR_*_SIGN_COMMAND`, `PENJAR_MACOS_NOTARIZE_COMMAND`, and `PENJAR_*_SIGN_VERIFY_COMMAND` secrets with hardened diagnostics.
2. Wire actual Windows installer generation/provenance/protocol-registration commands into `PENJAR_WINDOWS_INSTALLER_COMMAND`, `PENJAR_WINDOWS_INSTALLER_PROVENANCE_COMMAND`, and `PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND`.
3. Provision production external publication credentials/role wiring and validate non-dry-run invalidation command execution against target environment.
4. Promote evidence index preview automation into governed auto-apply (PR/comment gate) workflow.
