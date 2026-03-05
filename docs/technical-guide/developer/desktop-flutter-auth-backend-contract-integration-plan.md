---
title: Desktop Flutter Auth Backend Contract Integration Plan
desc: Execution plan for completing real backend auth/session contract wiring in Flutter desktop.
---

# Desktop Flutter Auth Backend Contract Integration Plan

This plan defines the concrete execution path for closing the remaining Flutter desktop
auth/session gap: replacing remote-stub simulated auth transitions with real backend contract
integration while preserving current parity safeguards.

## Related artifacts

- [Web + MCP + Desktop Documentation Map](/technical-guide/developer/web-mcp-documentation-map/)
- [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/)
- [Desktop Flutter Development Runbook](/technical-guide/developer/desktop-flutter-development-runbook/)
- [Desktop Flutter Migration Inventory](/technical-guide/developer/desktop-flutter-migration-inventory/)
- [Desktop Flutter Parity Checklist](/technical-guide/developer/desktop-flutter-parity-checklist/)
- [Desktop Flutter Parity Acceptance Baseline](/technical-guide/developer/desktop-flutter-parity-acceptance-baseline/)

## Objective and exit criteria

### Objective

Deliver production-grade backend auth/session contract wiring for Flutter desktop auth workflows:
sign-in, restore-session, token-refresh, and signed-out recovery paths.

### Exit criteria

1. Flutter auth contract consumes real backend auth endpoints for sign-in/restore/refresh flows.
2. Session/token lifecycle is persisted through secure desktop credential path without legacy
   env-driven auth-store fallbacks.
3. Backend failure/signed-out semantics are mapped consistently to Flutter auth state and user
   status text.
4. Auth parity gate passes with backend-integrated path in local+CI verification.
5. Execution-log evidence and continuity docs reflect final integrated behavior and removed
   temporary fallback assumptions.

## Current baseline snapshot (completed)

1. Runtime-switchable contract boundary (`in-memory` vs `remote-stub`) and backend request metadata path.
2. Backend response-driven auth state mutation with nested alias normalization.
3. Signed-out precedence normalization across:
   - direct + nested code aliases,
   - containerized `error` / `errors` payloads,
   - numeric unauthorized/session-expiry codes,
   - nested error/status detail messages,
   - explicit backend failure-flag precedence (`success` / `ok` / `isSuccess` / `isOk` / `is_success` / `is_ok` false), including nested error/meta container variants.
   - explicit backend signed-out aliases (`signedOut` / `isSignedOut` / `signed_out` / `is_signed_out`) for state-driven signed-out inference.
4. Secure-store auth snapshot path and runtime legacy auth-store decommission guards.
5. Auth backend contract fixture matrix baseline in `desktop/test/contracts/workflow_contracts_test.dart` (ABI-01 bootstrap).
6. Full verification chain (`desktop:verify:full`) and parity harness integrated in CI.
7. Contract-level strict backend schema fallback gate in `RemoteStubAuthSessionContract` (`strictBackendSchema`) for malformed backend auth payload handling.
   - strict-mode malformed-payload auth behavior (`sign-in` / `restore-session` / `refresh-token`) is parity-covered in `desktop/test/parity/remote_stub_mode_parity_test.dart`.
8. Runtime contract-bundle strict-mode wiring:
   - `DesktopContractBundle.fromMode(...)` forwards strict backend schema mode to remote-stub auth contract construction.
   - `DesktopContractBundle.fromEnvironment()` / `loadFromEnvironment()` can enable strict mode through `PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_SCHEMA_STRICT`.
9. Diagnostics-visible strict-mode profile labeling:
   - remote profile summary now surfaces `auth-backend-schema: strict` when strict backend auth schema mode is enabled.
   - strict-mode profile label visibility is covered in parity UI test `desktop/test/parity/remote_stub_mode_parity_test.dart`.
10. Opt-in sign-in credential forwarding path for backend binding:
   - default auth transport payload remains sanitized (`passwordLength` only),
   - optional raw password forwarding is available via `PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_FORWARD_CREDENTIALS` through bundle/runtime wiring.
   - diagnostics remote profile can surface forwarding state as `auth-sign-in-payload: forwarded`.
11. Backend auth signed-out/error normalization hardening:
   - signed-out signals (error-code / failure-flag) now force signed-out transition even from previously signed-in snapshots when explicit signed-in aliases are absent.
   - HTTP backend auth non-2xx responses are normalized into auth payload snapshots (including `code` / `message`) so auth parser state/error rules can run instead of transport-only block status.
   - parity UI coverage now includes signed-in -> signed-out transition on backend unauthorized refresh (`desktop/test/parity/remote_stub_mode_parity_test.dart`).
12. Optional backend-auth required-state runtime gate:
   - `RemoteStubAuthSessionContract.requireBackendState` blocks delegate fallback when backend auth state payload is missing/malformed,
   - runtime toggle is available via `PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_REQUIRE_STATE`,
   - backend execution transport mode now auto-enables required-state gate by default (explicit `false` still opts out),
   - diagnostics remote profile can surface `auth-backend-state: required`,
   - diagnostics remote profile now surfaces backend fallback policy label as
     `auth-backend-fallback: require-state|strict-schema|delegate-enabled` for backend execution transport,
   - parity UI coverage now includes required-state fallback blocking behavior and backend execution
     transport fallback-policy label visibility (`require-state`, `delegate-enabled`,
     `strict-schema`).
13. Auth-session parity backend integration coverage expansion:
   - `desktop/test/parity/auth_session_parity_test.dart` now includes backend snapshot sign-in/signed-out transition coverage, required-state fallback-block coverage, snake-case/isOk failure-flag status mapping coverage, snake_case signed-in/remember alias normalization coverage, signed-out alias variant fallback-status coverage (`signedOut` / `isSignedOut` / `signed_out` / `is_signed_out`), and payload-envelope parity coverage for top-level/nested wrapper paths (`payload`, `result -> payload`).
14. Auth backend failure-taxonomy fallback status mapping baseline:
   - when backend auth payloads signal signed-out/failure without explicit status/message, deterministic fallback status text is now applied (`Authentication required.`, `Backend session expired.`, `Backend auth request failed.`),
   - session-expiry taxonomy coverage now includes additional backend code variants (for example `SESSION_TIMEOUT`, `EXPIRED_TOKEN`) in both signed-out detection and session-expired fallback classification,
   - snake_case auth-state aliases (`signed_in`, `is_authenticated`, `remember_session`, `persist_session`) are now normalized for signed-in/remember inference,
   - explicit signed-out state aliases (`signedOut`, `isSignedOut`, `signed_out`, `is_signed_out`) are now normalized for state-driven signed-out inference and deterministic fallback status mapping (`Authentication required.`),
   - backend code extraction now includes additional status aliases (`statusCode`, `httpStatus`, `status_code`, `http_status`) for signed-out/session-expired inference compatibility, with contract/parity regression coverage for both camelCase and snake_case forms,
   - explicit failure-flag alias handling now includes additional alias keys (`isOk`, `is_success`, `is_ok`) for signed-out inference and fallback status mapping compatibility,
   - backend code normalization regex allocation is now cached as a shared helper constant to reduce repeated runtime compile overhead in auth code-classification paths,
   - signed-out/session-expired backend code classification is now resolved once per payload and reused across signed-in inference + fallback-status mapping paths to reduce duplicate marker scans,
   - auth state/failure alias collections are now centralized as shared parser constants to reduce alias-drift risk and repeated literal-set/list declaration overhead across detection/value-resolution paths,
   - explicit signed-in aliases remain precedence over signed-out code/failure-flag variants, with regression coverage now including `SESSION_TIMEOUT` / `EXPIRED_TOKEN` code variants and snake-case/isOk failure-flag variants,
   - explicit backend status/message/detail still takes precedence over fallback mapping.
15. Backend auth endpoint override readiness for transport binding:
   - `RemoteStubHttpTransportClient` now supports operation-scoped backend endpoint overrides through `backendEndpointOverrides`,
   - transport profile label now surfaces override count as `http-backend-overrides:N`,
   - runtime auth-operation endpoint overrides are wired from environment:
     - `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_ENDPOINT_SET_REMEMBER_SESSION`,
     - `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_ENDPOINT_SIGN_IN`,
     - `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_ENDPOINT_RESTORE_SESSION`,
     - `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_ENDPOINT_REFRESH_TOKEN`.
16. Backend envelope-chain compatibility expansion:
   - backend response envelope extraction now supports `payload` alongside `result`/`data`,
   - nested envelope-chain unwrapping is now supported for common patterns such as
     `result -> payload -> state/authState`,
   - auth fixture matrix now includes `payload` and nested `result/payload` envelope
     coverage for sign-in and refresh-token flows.

## Remaining integration gaps (auth scope)

| Gap | Current state | Target integrated state | Primary evidence gate |
|---|---|---|---|
| Real backend auth request/response contract handshake | Remote-stub backend transport supports request metadata/response normalization, opt-in sign-in credential forwarding, operation-scoped auth endpoint overrides (`backendEndpointOverrides` + auth endpoint env vars), envelope-chain compatibility (`result` / `data` / `payload` including nested wrapper unwrapping), HTTP auth non-2xx payload normalization, required-state fallback blocking (`PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_REQUIRE_STATE`) which is auto-enabled for backend execution transport by default (explicit `false` opt-out supported), and diagnostics-visible fallback-policy labeling (`auth-backend-fallback: require-state|strict-schema|delegate-enabled`), but auth flow still includes simulated fallback assumptions when required-state mode is disabled | Auth contract methods bind to production backend auth envelope/schema and error semantics | `desktop/test/contracts/workflow_contracts_test.dart` + auth backend integration tests in `desktop/test/parity/auth_session_parity_test.dart` |
| Session/token persistence continuity under real backend lifecycle | Secure store path exists, but rotation/expiry behavior is still validated mainly through simulated payloads | Real backend token/session rotation and expiry handling validated with persisted secure-store state | `desktop:verify:full` with backend-auth integration fixtures/evidence |
| Backend auth error-to-UX mapping policy | Signed-out/state/status normalization is broad and now includes forced signed-out transition from previously signed-in snapshots under signed-out code/failure-flag signals, parity auth-session backend path coverage, deterministic fallback status mapping for code-only/failure-only backend auth payloads (`Authentication required.` / `Backend session expired.` / `Backend auth request failed.`), expanded session-expiry code alias handling (`SESSION_TIMEOUT`, `EXPIRED_TOKEN`, etc.), snake_case signed-in/remember alias support (`signed_in` / `is_authenticated` / `remember_session` / `persist_session`), explicit signed-out alias support (`signedOut` / `isSignedOut` / `signed_out` / `is_signed_out`) with full signed-out alias variant regression coverage in contract/parity suites, backend status-code alias extraction support (`statusCode` / `httpStatus` / `status_code` / `http_status`) with camelCase/snake_case regression coverage, explicit failure-flag alias support (`isOk` / `is_success` / `is_ok`) with regression coverage, cached backend code normalization regex for classifier hot paths, single-pass backend code classification reuse across state/status inference, centralized auth alias constants for parser consistency, and explicit signed-in precedence regression coverage for code/failure-flag/state-alias variants while explicit backend status/message/detail remains precedence, but real backend contract mapping table is not yet fixed | Explicit backend auth failure taxonomy mapped to status text + signed-in state transitions | Execution-log unit evidence + parity gate updates |
| Rollout and fallback policy for backend auth path | Runtime mode gate, strict malformed-schema toggle wiring (`PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_SCHEMA_STRICT`), required-state toggle (`PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_REQUIRE_STATE`), and diagnostics fallback-policy labeling (`auth-backend-fallback: ...`) exist, but backend-auth rollout stage/decommission criteria are not codified | Staged rollout criteria + decommission checklist for simulated-path assumptions | Inventory/checklist/acceptance baseline sync + runbook next-unit updates |

## Execution unit sequence

### ABI-01: Backend auth envelope/schema contract lock

1. Freeze expected backend auth response envelopes for sign-in/restore/refresh flows.
2. Add contract fixtures covering success, signed-out, token-expiry, and unauthorized variants.
3. Add strict parser assertions for required auth fields/aliases per flow.
4. Status: in progress (fixture matrix baseline + `result/data/payload` envelope-chain and `authState` alias fixture coverage added in `workflow_contracts_test.dart`, including explicit signed-out envelope alias variants (`signedOut`, `is_signed_out`); broader schema fixture expansion remains).

### ABI-02: Real auth transport binding and state persistence continuity

1. Bind auth workflow methods to real backend route/contract handshake path.
2. Validate secure-store restore/save/refresh behavior under backend-integrated scenarios.
3. Enforce signed-out precedence policy with backend-integrated fixtures.

### ABI-03: Parity gate promotion and fallback decommission tightening

1. Promote backend-integrated auth parity gate to required acceptance path.
2. Remove or explicitly scope temporary simulated auth assumptions in parity notes.
3. Update release/readiness guidance if backend auth integration changes verification policy.

## Validation protocol per unit

1. Run targeted contract tests for auth parser/transport changes.
2. Run `pnpm run desktop:verify:full` before unit closure.
3. Record in execution log:
   - planned objective,
   - implemented changes (file-level),
   - unit review (scope/issues/fixes/post-fix criteria),
   - verification evidence.

## Documentation coupling requirements

When this plan changes, update in the same unit:

1. `desktop-flutter-migration-inventory.md` (Auth/session row blocker/notes).
2. `desktop-flutter-parity-checklist.md` (Auth/session row status notes).
3. `desktop-flutter-parity-acceptance-baseline.md` (Auth acceptance gate wording).
4. `web-mcp-phase-c-execution-log.md` (unit evidence + remaining-gap precision).
5. `desktop-flutter-development-runbook.md` (next-unit candidate ordering/notes).
