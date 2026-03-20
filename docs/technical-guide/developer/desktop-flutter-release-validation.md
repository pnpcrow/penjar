---
title: Desktop Flutter Release Validation & Evidence
desc: Release-grade validation baseline and traceable evidence index for Flutter desktop distribution.
---

# Desktop Flutter Release Validation & Evidence

This document consolidates release validation requirements and release evidence tracking
for desktop distribution targets. It replaces the previously separate release validation
baseline and release evidence index documents.

## Related artifacts

- [Web + MCP + Desktop Documentation Map](/technical-guide/developer/web-mcp-documentation-map/)
- [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/)
- [Desktop Flutter Development Runbook](/technical-guide/developer/desktop-flutter-development-runbook/)
- [Desktop Flutter Parity Baseline](/technical-guide/developer/desktop-flutter-parity-baseline/)

## 1) Target release channels

| Platform | Distribution target | Current status | Owner |
|---|---|---|---|
| macOS | Signed `.app` + packaged installer (`.dmg` or notarized equivalent) | Planned | Desktop Flutter Program |
| Windows | Signed installer (`.msi`/`exe`) with update channel metadata | Planned | Desktop Flutter Program |

## 2) Required validation gates

1. **Build reproducibility gate**: Deterministic version metadata, reproducible build command surface documented, release build artifacts archived.
2. **Installer integrity gate**: Clean host install, clean uninstall, app launch succeeds after install.
3. **Signing/notarization gate**: Platform signing completed, notarization/trust checks completed, unsigned artifact distribution blocked for production channel.
4. **Update-path gate**: Current→next version check, rollback/failed-update recovery validated, release notes/version manifest integrity validated.
5. **Runtime smoke gate** (post-install): App boot, auth entry flow render, project/file interaction, diagnostics panel render with contract mode visibility.

## 3) Required evidence per release candidate

1. **Artifact manifest**: Platform, version, hash, signing fingerprint.
2. **Validation report**: Gate-by-gate pass/fail summary, failure diagnostics and mitigation links.
3. **Update simulation report**: From-version → to-version path, failure injection results, rollback result.
4. **Traceability link pack**: Execution log unit entry, CI run URLs, release checklist ticket.

## 4) Release evidence table

| RC | Version | Platform | Artifact manifest | Installer/Update report | CI run | Execution log reference | Decision |
|---|---|---|---|---|---|---|---|
| RC-PLACEHOLDER | 0.0.0-placeholder | macOS | TBD | TBD | TBD | TBD | blocked (placeholder) |
| RC-PLACEHOLDER | 0.0.0-placeholder | Windows | TBD | TBD | TBD | TBD | blocked (placeholder) |

## 5) Operating protocol

1. Before RC cut, confirm Flutter parity verification chain is green:
   - `pnpm run desktop:release:scripts:syntax:check` / `...:contract:check`
   - `pnpm run desktop:test:coverage:check` / `...:contract:check`
   - `STRICT_AUTH_STORE_LEGACY_DECOMMISSION=1 pnpm run desktop:auth-store:legacy-decommission:check` / `...:contract:check`
   - `pnpm run desktop:auth-store:runtime-decommission:check` / `...:contract:check`
   - `pnpm run desktop:docs:command-inventory:check` / `...:contract:check`
   - `pnpm run desktop:release:windows-installer:contract:check`
2. Run signing readiness preflight:
   - `pnpm run desktop:release:signing:readiness` (with optional strict/command-hooks/placeholders variants)
3. Execute platform-specific installer/update smoke automation:
   - `pnpm run desktop:release:installer-smoke:macos` / `...:windows`
   - Signing execution: `pnpm run desktop:release:signing:run:macos` / `...:windows`
   - Strict modes: `STRICT_SIGNING_EXECUTION=1`, `STRICT_SIGNING_PROVENANCE=1`, `STRICT_WINDOWS_INSTALLER_PACKAGING=1`, `STRICT_WINDOWS_INSTALLER_NAMING=1`, `STRICT_WINDOWS_INSTALLER_PROVENANCE=1`, `STRICT_WINDOWS_INSTALLER_EXECUTION=1`, `STRICT_WINDOWS_PROTOCOL_REGISTRATION=1`
4. Run release evidence checks: `pnpm run desktop:release:evidence:check` / `...:contract:check`
5. Run update manifest checks: `pnpm run desktop:release:update-manifest:check` / `...:contract:check`
6. Run release smoke gate policy contract guard: `pnpm run desktop:release:smoke:gate-policy:contract:check`
7. Generate evidence row snippets: `pnpm run desktop:release:evidence:row:macos` / `...:windows`
8. Generate evidence bundle summaries: `pnpm run desktop:release:evidence:bundle:macos` / `...:windows`
9. Generate evidence-index previews: `pnpm run desktop:release:evidence:index:preview:macos` / `...:windows`
10. Generate/check appcast: `pnpm run desktop:release:appcast:generate` / `...:check`
11. Publish appcast dry-run: `pnpm run desktop:release:appcast:publish:dry-run`
12. Generate/check appcast publication bundle: `pnpm run desktop:release:appcast:bundle:generate` / `...:check`
13. Run external production guard: `pnpm run desktop:release:appcast:external:production:guard`
14. Run external publication readiness: `pnpm run desktop:release:appcast:external:readiness`
15. Record evidence in release checklist ticket and Phase C execution log.
16. Block release promotion if any required gate is missing or only manually asserted without evidence.

## 6) Evidence maintenance rules

1. Do not mark `promoted` unless all required baseline gates are evidenced.
2. Keep one row per `RC + platform` pair.
3. Add latest entry at top for quick audit visibility.
4. Keep artifact/report links immutable after promotion.
5. Run release evidence + update manifest checks before release promotion.
6. Attach all required reports (signing, installer, provenance, evidence bundle, gate policy, script syntax, test coverage, command inventory, update manifest, stage timing) before promotion decision.

## 7) CI baselines

- `.github/workflows/tests-desktop-flutter.yml`: `release-evidence-guard` and `release-update-manifest-guard` jobs, parity/build artifact uploads.
- `.github/workflows/release-desktop-installer-smoke.yml`: `workflow_dispatch` entrypoint with `signing-readiness` and `appcast-preview` jobs, platform-specific smoke reports, evidence row/bundle/index artifacts.
- Canonical verification chain: `desktop/scripts/verify_desktop.sh`.

## 8) Key scripts reference

| Purpose | Script |
|---|---|
| Release evidence index check | `desktop/scripts/check_release_evidence_index.sh` |
| Update manifest check | `desktop/scripts/check_update_manifest.sh` |
| Installer/update smoke report | `desktop/scripts/generate_installer_update_report.sh` |
| Release smoke gate policy | `desktop/scripts/check_release_smoke_gate_policy.sh` |
| Signing readiness | `desktop/scripts/check_signing_readiness.sh` |
| Signing execution pipeline | `desktop/scripts/run_signing_pipeline.sh` |
| Signing provenance | `desktop/scripts/check_signing_artifact_provenance.sh` |
| Windows installer pipeline | `desktop/scripts/run_windows_installer_pipeline.sh` |
| Windows installer packaging | `desktop/scripts/check_windows_installer_packaging.sh` |
| Appcast preview generator | `desktop/scripts/generate_appcast_from_reports.sh` |
| Appcast publication bundle | `desktop/scripts/generate_appcast_publication_bundle.sh` |
| External publication runner | `desktop/scripts/publish_appcast_external.sh` |
| Release evidence row generator | `desktop/scripts/generate_release_evidence_row.sh` |
| Release evidence bundle generator | `desktop/scripts/generate_release_evidence_bundle.sh` |

## 9) Implementation backlog seeds

1. Wire actual platform signing/notarization/verify commands into `PENJAR_*_SIGN_COMMAND`, `PENJAR_MACOS_NOTARIZE_COMMAND`, and `PENJAR_*_SIGN_VERIFY_COMMAND` secrets.
2. Wire actual Windows installer generation/provenance/protocol-registration commands into `PENJAR_WINDOWS_INSTALLER_COMMAND`, `PENJAR_WINDOWS_INSTALLER_PROVENANCE_COMMAND`, and `PENJAR_WINDOWS_PROTOCOL_REGISTER_COMMAND`.
3. Provision production external publication credentials/role wiring and validate non-dry-run invalidation command execution.
4. Promote evidence index preview automation into governed auto-apply (PR/comment gate) workflow.

## Continuity linkage protocol

1. When adding/removing release evidence requirements, update validation gates in this document in the same unit.
2. When a release gate outcome changes status, add or update corresponding unit evidence in [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/).
3. When release evidence changes affect parity acceptance scope, update [Desktop Flutter Parity Baseline](/technical-guide/developer/desktop-flutter-parity-baseline/) together.
