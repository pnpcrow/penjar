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
2. Run signing readiness preflight:
   - `pnpm run desktop:release:signing:readiness`
   - use strict mode when release secrets are expected: `pnpm run desktop:release:signing:readiness:strict`.
3. Execute platform-specific installer/update smoke automation:
   - local/manual entrypoints:
     - `pnpm run desktop:release:installer-smoke:macos`
     - `pnpm run desktop:release:installer-smoke:windows`
   - CI workflow entrypoint:
     - `.github/workflows/release-desktop-installer-smoke.yml` (`workflow_dispatch`).
4. Run release evidence index guard: `pnpm run desktop:release:evidence:check`.
5. Run update manifest guard: `pnpm run desktop:release:update-manifest:check`.
6. Generate and review evidence row snippets:
   - `pnpm run desktop:release:evidence:row:macos`
   - `pnpm run desktop:release:evidence:row:windows`
7. Generate evidence-index previews before applying table updates:
   - `pnpm run desktop:release:evidence:index:preview:macos`
   - `pnpm run desktop:release:evidence:index:preview:windows`
8. Generate and validate appcast preview:
   - `pnpm run desktop:release:appcast:generate`
   - `pnpm run desktop:release:appcast:check`
9. Publish appcast dry-run targets:
   - `pnpm run desktop:release:appcast:publish:dry-run`
10. Record evidence in release checklist ticket and Phase C execution log.
11. Block release promotion if any required gate is missing or only manually asserted without evidence.

CI baseline note:
- `.github/workflows/tests-desktop-flutter.yml` includes `release-evidence-guard` and `release-update-manifest-guard` jobs, and uploads parity/build artifacts for audit traceability.
- `.github/workflows/release-desktop-installer-smoke.yml` includes `signing-readiness` job with optional strict enforcement via workflow input.
- `.github/workflows/release-desktop-installer-smoke.yml` builds macOS/Windows release artifacts on demand and uploads installer/update smoke archives + JSON reports.
- `.github/workflows/release-desktop-installer-smoke.yml` also uploads platform release-evidence row snippet artifacts generated from smoke reports.
- `.github/workflows/release-desktop-installer-smoke.yml` also uploads release-evidence index preview artifacts generated from row snippets.
- `.github/workflows/release-desktop-installer-smoke.yml` runs an `appcast-preview` job that generates/checks/uploads appcast preview JSON from smoke reports.
- `.github/workflows/release-desktop-installer-smoke.yml` appcast-preview job also produces channel/version appcast publish dry-run targets.
- Update manifest baseline file: `desktop/release/update_manifest.example.json`.
- Installer/update smoke report generator: `desktop/scripts/generate_installer_update_report.sh`.
- Release evidence row generator: `desktop/scripts/generate_release_evidence_row.sh`.
- Release evidence index updater: `desktop/scripts/update_release_evidence_index.sh`.
- Appcast preview generator/checker: `desktop/scripts/generate_appcast_from_reports.sh`, `desktop/scripts/check_appcast.sh`.
- Appcast publish dry-run script: `desktop/scripts/publish_appcast.sh`.
- Signing readiness checker: `desktop/scripts/check_signing_readiness.sh`.

## 5) Implementation backlog seeds

1. Extend installer smoke workflow with platform signing/notarization steps backed by release secrets.
2. Promote Windows runner output from app-directory bundle to signed installer package (`.msi`/`exe`) artifact.
3. Add external publication integration for appcast outputs (object storage upload + rollout controls).
4. Promote evidence index preview automation into governed auto-apply (PR/comment gate) workflow.
