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
2. Execute platform-specific installer/signing/update validation.
3. Run release evidence index guard: `pnpm run desktop:release:evidence:check`.
4. Run update manifest guard: `pnpm run desktop:release:update-manifest:check`.
5. Record evidence in release checklist ticket and Phase C execution log.
6. Block release promotion if any required gate is missing or only manually asserted without evidence.

CI baseline note:
- `.github/workflows/tests-desktop-flutter.yml` includes `release-evidence-guard` and `release-update-manifest-guard` jobs, and uploads parity/build artifacts for audit traceability.
- Update manifest baseline file: `desktop/release/update_manifest.example.json`.

## 5) Implementation backlog seeds

1. Add CI/release workflow for macOS signed packaging and validation report artifact upload.
2. Add CI/release workflow for Windows signed installer packaging and validation report artifact upload.
3. Add scripted update simulation harness for desktop channel manifests.
4. Automate release evidence index updates linking artifact manifests and validation reports.
