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
- [Desktop Flutter Auth Backend Contract Integration Plan](/technical-guide/developer/desktop-flutter-auth-backend-contract-integration-plan/)
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
   - `pnpm run desktop:test:contracts`
   - `pnpm run desktop:test:contracts:no-pub`
   - `pnpm run desktop:test:coverage:check`
   - `pnpm run desktop:test:coverage:contract:check`
   - `pnpm run desktop:auth-store:legacy-decommission:check`
   - `pnpm run desktop:auth-store:legacy-decommission:contract:check`
   - `pnpm run desktop:auth-store:runtime-decommission:check`
   - `pnpm run desktop:auth-store:runtime-decommission:contract:check`
   - `pnpm run desktop:docs:command-inventory:check`
   - `pnpm run desktop:docs:command-inventory:contract:check`
   - `pnpm run desktop:test:parity`
   - `pnpm run desktop:test:mode-matrix`
   - `pnpm run desktop:release:evidence:check`
   - `pnpm run desktop:release:evidence:contract:check`
   - `pnpm run desktop:release:update-manifest:check`
   - `pnpm run desktop:release:update-manifest:contract:check`
   - `pnpm run desktop:release:scripts:syntax:check`
   - `pnpm run desktop:release:scripts:syntax:contract:check`
   - `pnpm run desktop:release:installer-smoke:macos`
   - `pnpm run desktop:release:installer-smoke:windows`
   - `pnpm run desktop:release:evidence:row:macos`
   - `pnpm run desktop:release:evidence:row:windows`
   - `pnpm run desktop:release:evidence:bundle:macos`
   - `pnpm run desktop:release:evidence:bundle:windows`
   - `pnpm run desktop:release:evidence:bundle:check:macos`
   - `pnpm run desktop:release:evidence:bundle:check:windows`
   - `pnpm run desktop:release:evidence:bundle:check:macos:strict`
   - `pnpm run desktop:release:evidence:bundle:check:windows:strict`
   - `pnpm run desktop:release:evidence:index:preview:macos`
   - `pnpm run desktop:release:evidence:index:preview:windows`
   - `pnpm run desktop:release:evidence:index:apply:macos`
   - `pnpm run desktop:release:evidence:index:apply:windows`
   - `pnpm run desktop:release:appcast:generate`
   - `pnpm run desktop:release:appcast:generate:strict`
   - `pnpm run desktop:release:appcast:check`
   - `pnpm run desktop:release:appcast:publish:dry-run`
   - `pnpm run desktop:release:appcast:bundle:generate`
   - `pnpm run desktop:release:appcast:bundle:check`
   - `pnpm run desktop:release:smoke:gate-policy:check`
   - `pnpm run desktop:release:smoke:gate-policy:contract:check`
   - `pnpm run desktop:release:appcast:external:production:guard`
   - `pnpm run desktop:release:appcast:external:readiness`
   - `pnpm run desktop:release:appcast:external:readiness:strict`
   - `pnpm run desktop:release:appcast:publish:external:dry-run`
   - `pnpm run desktop:release:signing:readiness`
   - `pnpm run desktop:release:signing:readiness:strict`
   - `pnpm run desktop:release:signing:readiness:command-hooks:strict`
   - `pnpm run desktop:release:signing:readiness:placeholders:strict`
   - `pnpm run desktop:release:signing:provenance:macos`
   - `pnpm run desktop:release:signing:provenance:windows`
   - `pnpm run desktop:release:signing:run:macos`
   - `pnpm run desktop:release:signing:run:windows`
   - `pnpm run desktop:release:windows-installer:run`
   - `pnpm run desktop:release:windows-installer:check`
   - `pnpm run desktop:release:windows-installer:check:strict`
   - `pnpm run desktop:release:windows-installer:provenance`
   - `pnpm run desktop:release:windows-installer:provenance:strict`

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
- Installer/update smoke workflow should use canonical smoke entrypoint: `desktop/scripts/release_installer_update_smoke.sh`.

## 6) Handoff checklist

Before pausing or transferring work:

1. Ensure working tree is clean or clearly explain pending deltas.
2. Record completed unit IDs and validation outcomes in execution log.
3. Update remaining-gap bullets with precise current state.
4. Document immediate next unit candidate with rationale.

## 7) Current next-unit candidates

Latest auth evidence lock: `Unit WS-D-284` optimizes unchanged-compact exact probing in
`_classifyBackendCode(...)` by skipping compact exact-map lookup when compact normalization reuses
the trimmed input reference, and locks lowercase compact marker-length-candidate near-miss
`code: "granttoken"` signed-in/status stability behavior (no unintended
auth-required/session-expired fallback) in contract/parity suites; execution evidence is recorded
in `web-mcp-phase-c-execution-log.md` (`Unit WS-D-284`).

Latest release pipeline evidence lock: `Unit WS-D-345` extends strict numeric near-match regression
coverage to modulo-xor-assignment numeric aliases (`"1%=1"`, `"1^=1"`) in installer/protocol paths,
locking exact numeric strict alias boundary (`"1"` only) behavior; execution evidence is recorded
in `web-mcp-phase-c-execution-log.md` (`Unit WS-D-345`).

1. Backend auth contract integration for Flutter desktop auth/session workflows (replace remaining remote-stub simulated fallback assumptions with real backend session/token contract wiring; strict malformed-schema runtime toggle is already available via `PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_SCHEMA_STRICT`, exposed in remote profile summary as `auth-backend-schema: strict`, strict malformed-payload auth behavior is parity-covered in `desktop/test/parity/remote_stub_mode_parity_test.dart`, optional required backend-state gate is available via `PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_REQUIRE_STATE` and surfaced as `auth-backend-state: required`; backend fallback policy visibility is surfaced as `auth-backend-fallback: require-state` / `strict-schema` / `delegate-enabled` (auto-enabled by default for backend execution transport, explicit `false` opt-out supported), auth-session parity backend integration coverage is now anchored in `desktop/test/parity/auth_session_parity_test.dart` (including payload-envelope wrapper parity for `payload`, nested `result -> payload`, and deep `result -> data -> payload -> result -> data` paths, plus cyclic-primary-envelope alternate-wrapper fallback coverage, sibling `result`/`data` fallback coverage for metadata-only primary chains, dedicated signed-in normalization locks across `signed_in`/`is_signed_in`/`logged_in`/`is_logged_in`/`loggedIn`/`isLoggedIn`, and ABI-01 fixture-aligned logged-style `authState` envelope coverage including `result.authState.isAuthenticated`, `data.authState.isAuthenticated`, `data.authState.loggedIn`, `result.authState.loggedIn`, `data.authState.isLoggedIn`, `result.authState.isLoggedIn`, `data.authState.is_authenticated`, `result.authState.is_authenticated`, `data.authState.signedIn`, `result.authState.signedIn`, `data.authState.authenticated`, `result.authState.authenticated`, `data.authState.logged_in`, `result.authState.logged_in`, `data.authState.is_logged_in`, `result.authState.is_logged_in`, `data.authState.signed_in`, `result.authState.signed_in`, `data.authState.is_signed_in`, `result.authState.is_signed_in`, `result.authState.signedOut/signed_out/isSignedOut/loggedOut/logged_out/isLoggedOut`, `data.authState.signedOut/signed_out/isSignedOut/loggedOut/logged_out/isLoggedOut`, `data.authState.is_signed_out/is_logged_out`, `result.authState.is_signed_out/is_logged_out`, and explicit signed-out-over-token precedence via `data.authState.authentication.authenticated=false`, including deterministic signed-out fallback status `Authentication required.`, plus explicit signed-in-false envelope aliases (`result.authState.isAuthenticated=false`, `data.authState.isAuthenticated=false`, `data.authState.loggedIn=false`, `result.authState.loggedIn=false`, `result.authState.isLoggedIn=false`, `data.authState.isLoggedIn=false`, `data.authState.is_authenticated=false`, `result.authState.is_authenticated=false`, `result.authState.signedIn=false`, `data.authState.signedIn=false`, `data.authState.authenticated=false`, `result.authState.authenticated=false`, `result.authState.signed_in=false`, `data.authState.signed_in=false`, `result.authState.is_signed_in=false`, `data.authState.is_signed_in=false`, `result.authState.logged_in=false`, `data.authState.logged_in=false`, `data.authState.is_logged_in=false`, `result.authState.is_logged_in=false`)), opt-in sign-in credential forwarding is available via `PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_FORWARD_CREDENTIALS` while default payload remains sanitized and forwarding state is exposed as `auth-sign-in-payload: forwarded`, operation-scoped auth backend endpoint overrides are now supported via transport (`backendEndpointOverrides`) and env wiring (`PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_ENDPOINT_*`) with diagnostics-visible override count label (`http-backend-overrides:N`), backend response envelope compatibility now includes `payload` plus deep nested `result/data/payload` chain traversal with cycle-safe envelope guards, cyclic-primary-wrapper fallback to alternate envelope keys, and sibling envelope-candidate fallback for auth/workflow state extraction, with project/file/canvas/asset/collaboration/inspect/export/diagnostics workflow sibling-fallback regression coverage now locked in contract/parity suites, signed-out precedence now forces transition from prior signed-in snapshots with backend unauthorized/failure signals, deterministic code-only/failure-only fallback status mapping is now enforced as `Authentication required.` / `Backend session expired.` / `Backend auth request failed.` when explicit backend status/message is absent, session-expiry variant codes such as `SESSION_TIMEOUT` / `EXPIRED_TOKEN` are now normalized to the same session-expired UX path, backend status-code aliases (`statusCode` / `httpStatus` / `status_code` / `http_status`), snake_case signed-in/remember aliases (`signed_in` / `is_signed_in` / `is_authenticated` / `logged_in` / `is_logged_in` / `remember_session` / `persist_session`), explicit signed-out aliases (`signedOut` / `isSignedOut` / `loggedOut` / `isLoggedOut` / `signed_out` / `is_signed_out` / `logged_out` / `is_logged_out`), and failure-flag aliases (`ok` / `isSuccess` / `isOk` / `is_success` / `is_ok`) plus mixed-alias explicit-false precedence coverage (`success=true` + `is_success=false`, including nested `errors[].is_success=false`) are now included in parser inference with camelCase/snake_case regression coverage, including direct `success`/`is_ok` auth-failed mapping and explicit signed-in override parity/contract regression locks for success/ok/isSuccess/is_success/is_ok/isOk plus nested failure-flag containers, code/statusCode/status_code/auth-required/session-timeout/expired-token overrides, signedOut-alias collisions, and nested authentication error-code/error-list explicit signed-in alias collisions, nested authentication detail/top-level status precedence locks, and nested signed-out error-code message mapping locks, token/session alias signed-in inference locks, explicit signed-out-vs-token/session alias precedence locks, and nested auth/session/token alias normalization locks, and signed-in alias unauthorized-code override locks (signed_in / is_signed_in / is_logged_in / isLoggedIn), and nested explicit signed-out alias override token-inference locks, error-object code token-inference override locks, and errorCode/httpStatus/http_status/SESSION_TIMEOUT/EXPIRED_TOKEN/TOKEN_EXPIRED session-expired fallback mapping locks and explicit signed-in override locks and explicit message-over-code fallback precedence locks, backend code normalization path uses allocation-light character scanning for classifier hot paths, signed-out/session-expired code classification is computed once per payload and reused across state/status inference paths, auth alias sets/lists are centralized in parser constants to reduce drift, recursive failure/status/code container traversal now applies identity-based cycle guards for malformed cyclic payload safety, signed-out alias variant regressions are locked in contract/parity suites, and explicit signed-in precedence regression cases for those code/failure-flag/state-alias variants are now locked in contract tests; staged rollout/decommission criteria are now codified in the plan and the next gap is publishing per-stage execution evidence), executed via [Desktop Flutter Auth Backend Contract Integration Plan](/technical-guide/developer/desktop-flutter-auth-backend-contract-integration-plan/).
2. Production Windows protocol-registration command provisioning and signed installer wiring validation (command-hook + strict protocol gate + PowerShell helper baseline are complete; real registry/installer command secrets and release execution evidence remain pending).
3. Real command wiring for signed packaging/notarization/verification in installer smoke workflow (`PENJAR_*_SIGN_COMMAND`, `PENJAR_*_SIGN_VERIFY_COMMAND` paths).
4. Real Windows signed installer generation (`.msi/.exe`) command chain and provenance command/secret wiring.
5. External appcast publication production rollout with real credentials/invalidation execution.
