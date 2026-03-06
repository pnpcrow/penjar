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
   - explicit backend failure-flag precedence (`success` / `ok` / `isSuccess` / `isOk` / `is_success` / `is_ok` false), including nested error/meta container variants and mixed-alias collisions where explicit false must remain authoritative.
   - explicit backend signed-out aliases (`signedOut` / `isSignedOut` / `loggedOut` / `isLoggedOut` / `signed_out` / `is_signed_out` / `logged_out` / `is_logged_out`) for state-driven signed-out inference.
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
   - `desktop/test/parity/auth_session_parity_test.dart` now includes backend snapshot sign-in/signed-out transition coverage, required-state fallback-block coverage, multi-alias failure-flag (success / ok / isSuccess / is_success / is_ok / isOk) status mapping coverage (including dedicated success=false parity lock and explicit signed-in override parity locks for success/ok/isSuccess/is_success/is_ok/isOk plus nested failure-flag containers, code/statusCode/status_code/auth-required/session-timeout/expired-token overrides, signedOut-alias collisions, and nested authentication error-code/error-list explicit signed-in alias collisions, nested authentication detail/top-level status precedence locks, and nested signed-out error-code message mapping locks, token/session alias signed-in inference locks, explicit signed-out-vs-token/session alias precedence locks, and nested auth/session/token alias normalization locks, and signed-in alias unauthorized-code override locks (signed_in / is_signed_in / is_logged_in / isLoggedIn), and nested explicit signed-out alias override token-inference locks, error-object code token-inference override locks, and errorCode/httpStatus/http_status/SESSION_TIMEOUT/EXPIRED_TOKEN/TOKEN_EXPIRED session-expired fallback mapping locks and explicit signed-in override locks and explicit message-over-code fallback precedence locks), mixed-alias explicit-false failure-flag precedence coverage (`success=true` + `is_success=false`, including nested `errors[].is_success=false`), snake_case + logged-style camelCase signed-in/remember alias normalization coverage (including dedicated `signed_in` + `is_signed_in` + `logged_in` + `is_logged_in` + `loggedIn` + `isLoggedIn` parity locks), signed-out alias variant fallback-status coverage (`signedOut` / `isSignedOut` / `loggedOut` / `isLoggedOut` / `signed_out` / `is_signed_out` / `logged_out` / `is_logged_out`), and payload-envelope parity coverage for top-level/nested/deep wrapper paths (`payload`, `result -> payload`, `result -> data -> payload -> result -> data`) including cyclic-primary-envelope fallback to alternate wrapper paths, sibling `result`/`data` fallback when the primary chain lacks state payload, and authState envelope alias parity locks (`result.authState.signedOut`/`signed_out`/`isSignedOut`/`loggedOut`/`logged_out`/`isLoggedOut`, `data.authState.signedOut`/`signed_out`/`isSignedOut`/`loggedOut`/`logged_out`/`isLoggedOut`, `data.authState.is_signed_out`/`is_logged_out`, `result.authState.is_signed_out`/`is_logged_out`, and `data.authState.authentication.authenticated=false` token-collision precedence with deterministic signed-out fallback status (`Authentication required.`), plus explicit signed-in-false envelope aliases (`result.authState.isAuthenticated=false`, `data.authState.isAuthenticated=false`, `data.authState.loggedIn=false`, `result.authState.loggedIn=false`, `result.authState.isLoggedIn=false`, `data.authState.isLoggedIn=false`, `data.authState.is_authenticated=false`, `result.authState.is_authenticated=false`, `result.authState.signedIn=false`, `data.authState.signedIn=false`, `data.authState.authenticated=false`, `result.authState.authenticated=false`, `result.authState.signed_in=false`, `data.authState.signed_in=false`, `result.authState.is_signed_in=false`, `data.authState.is_signed_in=false`, `result.authState.logged_in=false`, `data.authState.logged_in=false`, `data.authState.is_logged_in=false`, `result.authState.is_logged_in=false`)).
14. Auth backend failure-taxonomy fallback status mapping baseline:
   - when backend auth payloads signal signed-out/failure without explicit status/message, deterministic fallback status text is now applied (`Authentication required.`, `Backend session expired.`, `Backend auth request failed.`),
   - session-expiry taxonomy coverage now includes additional backend code variants (for example `SESSION_TIMEOUT`, `EXPIRED_TOKEN`) in both signed-out detection and session-expired fallback classification,
   - snake_case auth-state aliases (`signed_in`, `is_signed_in`, `is_authenticated`, `logged_in`, `is_logged_in`, `remember_session`, `persist_session`) are now normalized for signed-in/remember inference,
   - explicit signed-out state aliases (`signedOut`, `isSignedOut`, `loggedOut`, `isLoggedOut`, `signed_out`, `is_signed_out`, `logged_out`, `is_logged_out`) are now normalized for state-driven signed-out inference and deterministic fallback status mapping (`Authentication required.`),
   - backend code extraction now includes additional status aliases (`statusCode`, `httpStatus`, `status_code`, `http_status`) for signed-out/session-expired inference compatibility, with contract/parity regression coverage for both camelCase and snake_case forms,
   - explicit failure-flag alias handling now includes additional alias keys (`ok`, `isSuccess`, `isOk`, `is_success`, `is_ok`) for signed-out inference and fallback status mapping compatibility, including mixed-alias explicit-false precedence locks (`success=true` + `is_success=false`, including nested `errors[].is_success=false`),
   - backend code normalization now uses allocation-light character scanning in compact helpers to reduce hot-path preprocessing overhead in auth code-classification paths,
   - signed-out/session-expired backend code classification is now resolved once per payload and reused across signed-in inference + fallback-status mapping paths to reduce duplicate marker scans,
   - auth state/failure alias collections are now centralized as shared parser constants to reduce alias-drift risk and repeated literal-set/list declaration overhead across detection/value-resolution paths,
   - recursive failure/status/code container traversal now applies identity-based cycle guards to avoid unbounded recursion on malformed cyclic payload graphs while preserving nested extraction behavior,
   - explicit signed-in aliases remain precedence over signed-out code/failure-flag variants, with regression coverage now including `SESSION_TIMEOUT` / `EXPIRED_TOKEN` code variants and multi-alias failure-flag (success / ok / isSuccess / is_success / is_ok / isOk) variants,
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
   - nested envelope-chain traversal is now cycle-safe and no longer bounded to fixed depth, so deeper wrapper chains are supported,
   - when one wrapper key resolves to an already-visited cyclic envelope, traversal now continues to alternate wrapper keys (`data` / `payload`) in the same payload scope,
   - sibling envelope candidates are now collected across wrapper scopes so metadata-only primary chains (for example `result.meta`) can still resolve state/status from sibling wrappers (for example `data.authState`),
   - status/code/failure extraction now also scans additional envelope candidates to avoid backend-snapshot drops when the primary wrapper chain lacks auth/workflow fields,
   - workflow-level sibling-envelope fallback regression coverage now includes non-auth flow evidence (`createProject`/`createFile`/`createRectangle`/`importAsset`/`createThread`/`generateSnippet`/`runExport`/`runHealthCheck` contract + project/file/canvas/asset/collaboration/inspect/export/diagnostics parity paths) to reduce parser drift risk outside auth-only scenarios,
   - envelope-chain extraction now covers common and deep patterns such as
     `result -> payload -> state/authState` and `result -> data -> payload -> result -> data -> authState`,
   - auth fixture matrix now includes `payload` and nested `result/payload` envelope
     coverage for sign-in and refresh-token flows, plus explicit ABI-01 authState variants:
     `data.authState.loggedIn` signed-in success, `result.authState.isLoggedIn`
     signed-in success, and `result/data.authState` signed-out fallback variants
     (`signedOut`, `signed_out`, `isSignedOut`, `loggedOut`, `logged_out`, `isLoggedOut`,
     `is_signed_out`, `is_logged_out`).
17. Refresh-token direct-wrapper signed-out parity completion:
   - auth fixture + parity suites now include direct `result/data.authState` refresh-token
     signed-out alias fallback coverage for the full alias set: `signedOut`, `signed_out`,
     `isSignedOut`, `loggedOut`, `logged_out`, `isLoggedOut`, `is_signed_out`,
     and `is_logged_out`,
   - execution evidence is recorded in `web-mcp-phase-c-execution-log.md`
     (`Unit WS-D-229`, `Unit WS-D-230`).
18. Refresh-token direct-wrapper signed-in-false parity completion:
   - auth fixture + parity suites now include direct `result/data.authState` refresh-token
     explicit false fallback coverage for `isAuthenticated`, `loggedIn`, `isLoggedIn`,
     `is_authenticated`, `signedIn`, `authenticated`, `signed_in`, `is_signed_in`,
     `logged_in`, and `is_logged_in`,
   - execution evidence is recorded in `web-mcp-phase-c-execution-log.md`
     (`Unit WS-D-231`).
19. Refresh-token direct-wrapper signed-in alias parity completion:
   - auth fixture + parity suites now include direct `result/data.authState` refresh-token
     signed-in alias success coverage for `isAuthenticated`, `loggedIn`, `isLoggedIn`,
     `is_authenticated`, `signedIn`, `authenticated`, `signed_in`, `is_signed_in`,
     `logged_in`, and `is_logged_in`,
   - execution evidence is recorded in `web-mcp-phase-c-execution-log.md`
     (`Unit WS-D-232`).
20. Restore-session direct-wrapper signed-in alias parity completion:
   - auth fixture + parity suites now include direct `result/data.authState` restore-session
     signed-in alias success coverage for `isAuthenticated`, `loggedIn`, `isLoggedIn`,
     `is_authenticated`, `signedIn`, `authenticated`, `signed_in`, `is_signed_in`,
     `logged_in`, and `is_logged_in`,
   - execution evidence is recorded in `web-mcp-phase-c-execution-log.md`
     (`Unit WS-D-233`).
21. Sign-in direct-wrapper signed-in-false parity completion:
   - auth fixture + parity suites now include direct `result/data.authState` sign-in explicit
     false fallback coverage for `isAuthenticated`, `loggedIn`, `isLoggedIn`, `is_authenticated`,
     `signedIn`, `authenticated`, `signed_in`, `is_signed_in`, `logged_in`, and
     `is_logged_in`,
   - execution evidence is recorded in `web-mcp-phase-c-execution-log.md`
     (`Unit WS-D-234`).
22. Sign-in direct-wrapper signed-out alias parity completion:
   - auth fixture + parity suites now include direct `result/data.authState` sign-in signed-out
     alias fallback coverage for `signedOut`, `signed_out`, `isSignedOut`, `loggedOut`,
     `logged_out`, `isLoggedOut`, `is_signed_out`, and `is_logged_out`,
   - execution evidence is recorded in `web-mcp-phase-c-execution-log.md`
     (`Unit WS-D-235`).
23. Restore-session direct-wrapper signed-out alias fixture matrix completion:
   - auth fixture matrix now includes direct `result.authState` restore-session signed-out
     alias fallback coverage for `signedOut` and `loggedOut`, closing the residual result-wrapper
     gap against existing `data.authState` + snake_case/`is*` signed-out coverage,
   - execution evidence is recorded in `web-mcp-phase-c-execution-log.md`
     (`Unit WS-D-236`).
24. Auth fixture matrix symmetry automation guard completion:
   - `desktop/test/contracts/workflow_contracts_test.dart` now includes an automated matrix guard
     that asserts direct `authState` alias symmetry for sign-in/refresh-token/restore-session
     across `result/data` wrappers for signed-in (`true`), signed-in (`false`), and signed-out
     alias sets,
   - execution evidence is recorded in `web-mcp-phase-c-execution-log.md`
     (`Unit WS-D-237`).
25. Parity authState matrix symmetry automation and residual gap closure:
   - `desktop/test/parity/auth_session_parity_test.dart` now includes parity-side matrix guards
     for sign-in/refresh-token/restore-session direct `authState` alias coverage, and the guard
     closed residual restore-session result-wrapper signed-out parity gaps (`signedOut`,
     `loggedOut`),
   - execution evidence is recorded in `web-mcp-phase-c-execution-log.md`
     (`Unit WS-D-238`).
26. Parity restore/refresh signed-in-false matrix symmetry automation guard completion:
   - `desktop/test/parity/auth_session_parity_test.dart` now includes an additional matrix guard
     that enforces direct `result/data.authState` explicit `false` alias symmetry for
     restore-session and refresh-token operations across the signed-in alias set
     (`isAuthenticated`, `loggedIn`, `isLoggedIn`, `is_authenticated`, `signedIn`,
     `authenticated`, `signed_in`, `is_signed_in`, `logged_in`, `is_logged_in`),
   - execution evidence is recorded in `web-mcp-phase-c-execution-log.md`
     (`Unit WS-D-239`).
27. Restore/refresh parity matrix guard deduplication and payload-filter reuse:
   - `desktop/test/parity/auth_session_parity_test.dart` now centralizes restore/refresh direct
     `authState` matrix assertions through a shared guard helper with prefiltered payload iterables,
     removing duplicated signed-out and signed-in-false matrix loops while preserving deterministic
     missing-entry reporting,
   - execution evidence is recorded in `web-mcp-phase-c-execution-log.md`
     (`Unit WS-D-240`).
28. Sign-in parity matrix guard deduplication for signed-in/signed-in-false/signed-out paths:
   - `desktop/test/parity/auth_session_parity_test.dart` now uses a shared sign-in matrix guard
     helper across all three direct `authState` matrix checks (signed-in true, signed-in false,
     signed-out true), preserving missing-entry diagnostics while reducing duplicated alias-loop
     logic,
   - execution evidence is recorded in `web-mcp-phase-c-execution-log.md`
     (`Unit WS-D-241`).
29. Cross-operation authState matrix assertion helper consolidation:
   - `desktop/test/parity/auth_session_parity_test.dart` now centralizes authState matrix entry
     detection through shared operation-level append/expect helpers reused by sign-in,
     refresh-token, restore-session, and combined restore/refresh matrix guards, reducing repeated
     wrapper/alias iteration logic while preserving deterministic failure diagnostics,
   - execution evidence is recorded in `web-mcp-phase-c-execution-log.md`
     (`Unit WS-D-242`).
30. authState matrix lookup performance indexing:
   - parity matrix assertion helpers now build per-payload-set authState entry indexes once and use
     keyed membership checks for wrapper/alias/value matrix assertions instead of repeated full
     payload scans, reducing guard evaluation overhead while keeping failure semantics unchanged,
   - execution evidence is recorded in `web-mcp-phase-c-execution-log.md`
     (`Unit WS-D-243`).
31. Auth backend contract fixture matrix guard lookup indexing and helper reuse:
   - `desktop/test/contracts/workflow_contracts_test.dart` now precomputes auth backend fixture
     matrix entries (operation/wrapper/alias/value) and reuses a shared missing-entry appender for
     signed-out (`true`), signed-in (`true`), and signed-in-false (`false`) symmetry requirements
     across `result/data` wrappers, replacing repeated fixture scans while preserving deterministic
     failure diagnostics,
   - execution evidence is recorded in `web-mcp-phase-c-execution-log.md`
     (`Unit WS-D-244`).
32. Backend code classification single-path reuse for auth-state inference:
   - `desktop/lib/contracts/remote_stub_contracts.dart` now consolidates signed-out/session-expired
     backend-code checks into a single classification path (`_classifyBackendCode`) with shared
     marker catalogs, preserving existing signed-out precedence semantics while removing duplicated
     backend-code compact/marker scans in auth-state inference,
   - execution evidence is recorded in `web-mcp-phase-c-execution-log.md`
     (`Unit WS-D-245`).
33. Backend code classification fast-path optimization for numeric auth statuses:
   - `_classifyBackendCode(...)` now short-circuits direct numeric auth status codes
     (`401`/`403`/`419`/`440`) and empty compact-code inputs before marker-loop scans, preserving
     signed-out/session-expired semantics while reducing unnecessary compact/marker traversal on
     common backend status paths,
   - execution evidence is recorded in `web-mcp-phase-c-execution-log.md`
     (`Unit WS-D-246`).
34. JWT-expired backend code variant session-expired parity completion:
   - auth parser signed-out code markers now include `JWT_EXPIRED` normalized form
     (`jwtexpired`) so code-only backend JWT-expired responses follow signed-out/session-expired
     fallback handling,
   - contract/parity suites now include JWT-expired fallback and explicit signed-in override
     regression coverage, with execution evidence recorded in
     `web-mcp-phase-c-execution-log.md` (`Unit WS-D-247`).
35. Session-expired marker cohesion and token-expiry variant parity completion:
   - auth parser marker catalogs now enforce `session-expired` -> `signed-out` inclusion by
     construction (`_backendSignedOutCodeMarkers` includes `_backendSessionExpiredCodeMarkers`),
     closing prior drift risk for variants such as `ACCESS_TOKEN_EXPIRED` and
     `REFRESH_TOKEN_EXPIRED`,
   - contract/parity suites now include `ACCESS_TOKEN_EXPIRED` / `REFRESH_TOKEN_EXPIRED`
     deterministic session-expired fallback coverage and explicit signed-in override regression
     coverage, with execution evidence recorded in `web-mcp-phase-c-execution-log.md`
     (`Unit WS-D-248`).
36. Backend code exact-marker fast-path optimization:
   - `_classifyBackendCode(...)` now uses precomputed exact-marker sets for signed-out and
     session-expired catalogs, allowing direct classification for common compact code values
     (`AUTH_REQUIRED`, `SESSION_TIMEOUT`, `REFRESH_TOKEN_EXPIRED`, etc.) before marker substring
     scans,
   - existing substring fallback behavior remains unchanged for composite code payloads, with
     execution evidence recorded in `web-mcp-phase-c-execution-log.md` (`Unit WS-D-249`).
37. Backend code marker-length short-circuit optimization:
   - classifier now precomputes minimum marker lengths for signed-out/session-expired catalogs and
     short-circuits impossible short compact inputs before substring loop scans,
   - exact-marker fast path and composite substring fallback behavior remain intact, with execution
     evidence recorded in `web-mcp-phase-c-execution-log.md` (`Unit WS-D-250`).
38. Backend code compact normalization trim-reuse optimization:
   - `_classifyBackendCode(...)` now compacts backend codes from the already-trimmed input
     (`_compactBackendCodeFromTrimmed(trimmed)`) to remove duplicate trim work inside classifier
     hot paths,
   - numeric/exact/marker-length/substring fallback behavior remains unchanged, with execution
     evidence recorded in `web-mcp-phase-c-execution-log.md` (`Unit WS-D-251`).
39. Backend code compact normalization allocation-light scan optimization:
   - `_compactBackendCodeFromTrimmed(...)` now replaces regex-based non-alphanumeric stripping with
     allocation-light character scanning while preserving lowercase + ASCII alphanumeric compact
     semantics used by `_classifyBackendCode(...)`,
   - contract/parity suites now lock delimited code variant fallback behavior
     (`REFRESH-TOKEN::EXPIRED`) to keep session-expired mapping parity stable after normalization
     path changes; execution evidence is recorded in `web-mcp-phase-c-execution-log.md`
     (`Unit WS-D-252`).
40. Backend code compact-input lowercase fast-path optimization:
   - `_compactBackendCodeFromTrimmed(...)` now returns early when the trimmed backend code is
     already lowercase ASCII alphanumeric, skipping `toLowerCase` preprocessing for compact inputs
     while preserving existing compact semantics for non-compact variants,
   - contract/parity suites now lock compact lowercase session-expiry code fallback behavior
     (`refreshtokenexpired`) to ensure parity stability across compact-input fast paths; execution
     evidence is recorded in `web-mcp-phase-c-execution-log.md` (`Unit WS-D-253`).
41. Backend code exact-marker single-map lookup optimization:
   - `_classifyBackendCode(...)` now uses `_backendExactCodeClassifications` for single-lookup
     exact marker classification (signed-out-only + session-expired) instead of dual set
     membership checks, preserving exact marker semantics while trimming exact-path lookup work,
   - contract/parity suites now lock compact lowercase signed-out marker fallback behavior
     (`unauthorized`) to keep auth-required mapping parity stable on exact compact code paths;
     execution evidence is recorded in `web-mcp-phase-c-execution-log.md` (`Unit WS-D-254`).
42. Backend code substring loop reordering optimization:
   - `_classifyBackendCode(...)` now scans session-expired markers first and signed-out-only
     markers second, avoiding duplicate session-marker scans while preserving signed-out/session
     fallback semantics,
   - contract/parity suites now lock mixed-code precedence behavior
     (`UNAUTHORIZED_REFRESH_TOKEN_EXPIRED` -> session-expired fallback) to keep deterministic
     fallback parity stable on composite marker paths; execution evidence is recorded in
     `web-mcp-phase-c-execution-log.md` (`Unit WS-D-255`).
43. Backend code uppercase-compact fast-path optimization:
   - `_compactBackendCodeFromTrimmed(...)` now detects fully ASCII alphanumeric compact inputs
     containing uppercase letters and returns direct lowercase output without entering the
     delimiter-filter buffer loop, while preserving normalization semantics for non-compact inputs,
   - contract/parity suites now lock uppercase compact signed-out marker fallback behavior
     (`UNAUTHORIZED`) to keep auth-required mapping parity stable on uppercase compact code paths;
     execution evidence is recorded in `web-mcp-phase-c-execution-log.md` (`Unit WS-D-256`).
44. Backend code non-compact ASCII lowercase-allocation reduction:
   - `_compactBackendCodeFromTrimmed(...)` now uses code-unit lowercase/filter normalization for
     non-compact ASCII inputs, avoiding full-string `toLowerCase` allocation on delimiter-heavy
     ASCII paths while preserving non-ASCII normalization fallback behavior,
   - contract/parity suites now lock delimited uppercase signed-out marker fallback behavior
     (`UNAUTHORIZED::TOKEN`) to keep auth-required mapping parity stable across non-compact ASCII
     normalization paths; execution evidence is recorded in
     `web-mcp-phase-c-execution-log.md` (`Unit WS-D-257`).
45. Backend code non-compact normalization single-pass fallback optimization:
   - `_compactBackendCodeFromTrimmed(...)` now removes separate non-ASCII pre-scan by applying
     single-pass ASCII code-unit normalization with inline non-ASCII detection, delegating to
     shared Unicode fallback helper only when needed,
   - contract/parity suites now lock delimited uppercase signed-out marker behavior with
     non-ASCII suffix (`UNAUTHORIZED::토큰`) to preserve deterministic auth-required mapping across
     fallback-path changes; execution evidence is recorded in
     `web-mcp-phase-c-execution-log.md` (`Unit WS-D-258`).
46. Backend code uppercase exact-classification fast-path optimization:
   - `_classifyBackendCode(...)` now checks `_backendUppercaseExactCodeClassifications` before
     compact normalization, short-circuiting uppercase compact exact markers without extra
     normalization/substring scans,
   - contract/parity suites now lock uppercase compact session-expired exact-marker behavior
     (`TOKENEXPIRED`) to preserve deterministic session-expired fallback mapping on the new
     fast-path; execution evidence is recorded in
     `web-mcp-phase-c-execution-log.md` (`Unit WS-D-259`).
47. Backend code raw exact-classification dual-map fast-path optimization:
   - `_classifyBackendCode(...)` now short-circuits both lowercase and uppercase compact exact
     markers via combined raw exact lookup
     (`_backendExactCodeClassifications` + `_backendUppercaseExactCodeClassifications`) before
     compact normalization,
   - contract/parity suites now lock lowercase compact exact session-expired marker behavior
     (`sessionexpired`) to preserve deterministic session-expired fallback mapping on the expanded
     raw exact fast-path; execution evidence is recorded in
     `web-mcp-phase-c-execution-log.md` (`Unit WS-D-260`).
48. Backend code raw exact-classification single-map lookup optimization:
   - `_classifyBackendCode(...)` now uses a single raw exact map
     (`_backendRawExactCodeClassifications`) that materializes lowercase and uppercase exact keys
     during initialization, reducing runtime dual-map lookup overhead on exact-code paths,
   - contract/parity suites now lock uppercase compact exact session-expired marker behavior
     (`SESSIONEXPIRED`) to preserve deterministic fallback mapping on the single-map fast-path;
     execution evidence is recorded in `web-mcp-phase-c-execution-log.md` (`Unit WS-D-261`).
49. Backend code compact uppercase-normalization ASCII fast-path optimization:
   - `_compactBackendCodeFromTrimmed(...)` now uses `_compactBackendAsciiLowercase(...)` for
     all-compact uppercase ASCII inputs, replacing `toLowerCase()` with ASCII code-unit lowering
     to reduce normalization overhead in mixed-case compact marker paths,
   - contract/parity suites now lock mixed-case compact session-expired marker behavior
     (`SessionExpired`) to preserve deterministic fallback mapping under the new ASCII fast-path;
     execution evidence is recorded in `web-mcp-phase-c-execution-log.md` (`Unit WS-D-262`).
50. Backend code Unicode-fallback early-branch optimization for compact classification:
   - `_compactBackendCodeFromTrimmed(...)` now short-circuits directly to
     `_compactBackendCodeFromTrimmedUnicodeFallback(...)` when the first non-compact character is
     non-ASCII, avoiding redundant ASCII normalization scans before Unicode fallback,
   - contract/parity suites now lock compact uppercase unauthorized code behavior with non-ASCII
     suffix (`UNAUTHORIZED토큰`) to preserve deterministic auth-required fallback mapping on the
     early Unicode-fallback path; execution evidence is recorded in
     `web-mcp-phase-c-execution-log.md` (`Unit WS-D-263`).
51. Backend code delimiter-path prefix reuse optimization for compact normalization:
   - `_compactBackendCodeFromTrimmed(...)` now reuses the pre-scanned compact prefix (`0..firstNonCompactIndex`)
     by appending it once and continuing normalization from `firstNonCompactIndex`, reducing
     duplicate prefix scan overhead on delimiter-heavy ASCII code paths,
   - contract/parity suites now lock mixed-case delimited unauthorized marker behavior
     (`Unauthorized::TOKEN`) to preserve deterministic auth-required fallback mapping across the
     optimized prefix-reuse path; execution evidence is recorded in
     `web-mcp-phase-c-execution-log.md` (`Unit WS-D-264`).
52. Backend code Unicode-suffix incremental normalization optimization for delimiter paths:
   - `_compactBackendCodeFromTrimmed(...)` now appends Unicode-lowercased compact suffix units
     from the first encountered non-ASCII index via `_appendCompactBackendUnicodeLowercasedRange(...)`,
     avoiding full-string lowercase + delimiter-path rescans after already-normalized ASCII prefix
     segments,
   - contract/parity suites now lock mixed-case delimited unauthorized marker behavior with
     non-ASCII suffix (`Unauthorized::TOKEN토큰`) to preserve deterministic auth-required fallback
     mapping on the incremental Unicode-suffix normalization path; execution evidence is recorded
     in `web-mcp-phase-c-execution-log.md` (`Unit WS-D-265`).
53. Backend code lowercase delimiter-prefix append optimization for compact normalization:
   - `_compactBackendCodeFromTrimmed(...)` now appends pre-scanned lowercase/digit compact prefix
     ranges via `_appendCompactBackendAsciiRange(...)` instead of allocating intermediate
     `substring` objects on delimiter-path normalization when no uppercase compact units exist,
   - contract/parity suites now lock lowercase delimited unauthorized marker behavior
     (`unauthorized::token`) to preserve deterministic auth-required fallback mapping on the
     substring-free lowercase prefix path; execution evidence is recorded in
     `web-mcp-phase-c-execution-log.md` (`Unit WS-D-266`).
54. Backend code delimiter-path first-marker recheck elimination optimization:
   - `_compactBackendCodeFromTrimmed(...)` now skips rechecking the already-identified first
     non-compact delimiter index by starting delimiter-path scan from
     `firstNonCompactIndex + 1`, reducing one redundant branch/classifier check per delimiter-path
     normalization call,
   - contract/parity suites now lock lowercase trailing-delimiter unauthorized marker behavior
     (`unauthorized::`) to preserve deterministic auth-required fallback mapping while exercising
     the adjusted delimiter-loop start path; execution evidence is recorded in
     `web-mcp-phase-c-execution-log.md` (`Unit WS-D-267`).
55. Backend code compact no-delimiter uppercase-tail normalization optimization:
   - `_compactBackendCodeFromTrimmed(...)` now tracks `firstUppercaseCompactIndex` during compact
     scan and, when delimiter-free compact normalization is required, lowercases only from that
     index onward while preserving known-lowercase prefix as-is,
   - `_compactBackendAsciiLowercase(...)` and `_appendCompactBackendAsciiLowercaseRange(...)` now
     support `startInclusive` to avoid redundant lowercase checks on prefix segments already known
     to be lowercase/digit compact units,
   - contract/parity suites now lock lowercase-prefix uppercase-suffix compact unauthorized marker
     behavior (`unauthorizedTOKEN`) to preserve deterministic auth-required fallback mapping on the
     start-indexed compact-uppercase normalization path; execution evidence is recorded in
     `web-mcp-phase-c-execution-log.md` (`Unit WS-D-268`).
56. Backend code delimiter-path uppercase-prefix start-index normalization optimization:
   - `_compactBackendCodeFromTrimmed(...)` now reuses `firstUppercaseCompactIndex` on
     delimiter-path prefix normalization by appending known-lowercase compact prefix segments
     (`0..firstUppercaseCompactIndex`) via `_appendCompactBackendAsciiRange(...)` and lowercasing
     only `firstUppercaseCompactIndex..firstNonCompactIndex`,
   - this removes redundant lowercase-branch checks on delimiter-path prefix units already known
     to be lowercase/digit compact characters,
   - contract/parity suites now lock lowercase-prefix uppercase-before-delimiter unauthorized
     marker behavior (`unauthoriZed::token`) to preserve deterministic auth-required fallback
     mapping on the delimiter-prefix start-indexed lowercase path; execution evidence is recorded
     in `web-mcp-phase-c-execution-log.md` (`Unit WS-D-269`).
57. Backend code compact normalization lazy-buffer allocation optimization:
   - `_compactBackendCodeFromTrimmed(...)` now lazily allocates `StringBuffer` only when compact
     characters are actually appended, avoiding unnecessary empty-buffer allocation on
     delimiter-only/no-append normalization paths,
   - existing delimiter/no-delimiter normalization semantics remain unchanged while empty compact
     results still resolve deterministically to `''`,
   - contract/parity suites now lock delimiter-only code marker behavior (`code: "::"`) to ensure
     signed-in state and status stability without unintended auth-required/session-expired fallback
     mapping on empty compact normalization output paths; execution evidence is recorded in
     `web-mcp-phase-c-execution-log.md` (`Unit WS-D-270`).
58. Backend code compact normalization lazy-buffer inline-initialization optimization:
   - `_compactBackendCodeFromTrimmed(...)` now removes the local `ensureAsciiBuffer()` closure and
     uses inline `asciiBuffer ??= StringBuffer()` initialization across prefix/unicode/delimiter
     append paths, preserving lazy allocation while reducing closure-dispatch overhead on classifier
     hot loops,
   - existing delimiter/no-delimiter normalization and Unicode fallback semantics remain unchanged
     while empty compact results still resolve deterministically to `''`,
   - contract/parity suites now lock unicode-only code marker behavior
     (`code: "\uC138\uC158\uB9CC\uB8CC"`) to ensure signed-in state and status stability without
     unintended auth-required/session-expired fallback mapping on non-ASCII-only compact-empty
     normalization paths; execution evidence is recorded in `web-mcp-phase-c-execution-log.md`
     (`Unit WS-D-271`).
59. Backend code compact normalization loop-local buffer reuse optimization:
   - `_compactBackendCodeFromTrimmed(...)` now reuses a single loop-local output buffer reference
     across delimiter-path suffix scans (`outputBuffer`) so compact/uppercase append branches avoid
     repeated null-coalescing assignment expressions on hot loop iterations,
   - existing delimiter/no-delimiter normalization and Unicode fallback semantics remain unchanged
     while compact-empty outputs still resolve deterministically to `''`,
   - contract/parity suites now lock leading-delimiter uppercase unauthorized marker behavior
     (`code: "::UNAUTHORIZED"`) to preserve deterministic auth-required fallback mapping on
     prefix-empty delimiter-path normalization and loop-local append-buffer reuse paths; execution
     evidence is recorded in `web-mcp-phase-c-execution-log.md` (`Unit WS-D-272`).
60. Backend code compact normalization length-caching optimization:
   - `_compactBackendCodeFromTrimmed(...)` now caches `trimmedCode.length` as `codeLength` and
     reuses it across scan/suffix loops and compact-uppercase normalization boundaries to reduce
     repeated length getter lookups on classifier hot paths,
   - `_compactBackendAsciiLowercase(...)` now accepts explicit `endExclusive` so no-delimiter
     compact-uppercase normalization can reuse caller-cached boundaries directly,
   - contract/parity suites now lock capitalized compact unauthorized marker behavior
     (`code: "Unauthorized"`) to preserve deterministic auth-required fallback mapping on the
     no-delimiter start-indexed lowercase path with cached boundary reuse; execution evidence is
     recorded in `web-mcp-phase-c-execution-log.md` (`Unit WS-D-273`).
61. Backend code classification marker-loop index optimization:
   - `_classifyBackendCode(...)` now replaces `for-in` marker scans with index-based loops and
     cached marker counts for both session-expired and signed-out-only marker sets to avoid
     iterator allocations on classifier hot paths,
   - session-expired marker matches now return immediately without intermediate boolean state while
     preserving session-expired precedence semantics,
   - contract/parity suites now lock capitalized compact unauthenticated marker behavior
     (`code: "Unauthenticated"`) to preserve deterministic auth-required fallback mapping on the
     signed-out-only marker scan path after loop-shape changes; execution evidence is recorded in
     `web-mcp-phase-c-execution-log.md` (`Unit WS-D-274`).
62. Backend code classification compact-length caching optimization:
   - `_classifyBackendCode(...)` now caches `compact.length` as `compactLength` and reuses it for
     compact-empty and marker-min-length guards to reduce repeated length getter lookups on
     classifier hot paths,
   - session-expired and signed-out-only marker precedence semantics remain unchanged while exact
     raw/compact classification behavior is preserved,
   - contract/parity suites now lock capitalized compact logged-out marker behavior
     (`code: "LoggedOut"`) to preserve deterministic auth-required fallback mapping on signed-out
     marker paths with compact-length guard reuse; execution evidence is recorded in
     `web-mcp-phase-c-execution-log.md` (`Unit WS-D-275`).
63. Backend code classification marker-list reference caching optimization:
   - `_classifyBackendCode(...)` now caches session-expired and signed-out marker lists as local
     references (`sessionExpiredMarkers`, `signedOutOnlyMarkers`) before index traversal to reduce
     repeated top-level list lookups on hot marker loops,
   - existing marker precedence and exact/raw code classification semantics remain unchanged,
   - contract/parity suites now lock capitalized compact auth-required marker behavior
     (`code: "AuthRequired"`) to preserve deterministic auth-required fallback mapping on
     signed-out marker paths after loop reference-caching changes; execution evidence is recorded in
     `web-mcp-phase-c-execution-log.md` (`Unit WS-D-276`).
64. Backend code classification marker-threshold local caching optimization:
   - `_classifyBackendCode(...)` now caches marker minimum-length thresholds as local values
     (`sessionExpiredMarkerMinLength`, `signedOutOnlyMarkerMinLength`) before threshold guards to
     reduce repeated top-level constant lookups on classifier hot paths,
   - existing marker precedence and exact/raw code classification semantics remain unchanged,
   - contract/parity suites now lock capitalized compact signed-out marker behavior
     (`code: "SignedOut"`) to preserve deterministic auth-required fallback mapping on signed-out
     marker paths after local threshold caching changes; execution evidence is recorded in
     `web-mcp-phase-c-execution-log.md` (`Unit WS-D-277`).
65. Backend code classification short-code early-return optimization:
   - `_classifyBackendCode(...)` now applies an early-return guard for short code values
     (`trimmed.length < _backendSignedOutCodeMarkerMinLength`) before raw-exact map lookups and
     compact normalization to skip unnecessary classification work on non-marker-length payloads,
   - existing numeric status shortcuts (`401`, `403`, `440`) and signed-out/session-expired marker
     precedence semantics remain unchanged,
   - contract/parity suites now lock capitalized compact signed-out near-miss behavior
     (`code: "SignOut"`) to preserve signed-in/status stability (no unintended auth-required
     fallback mapping) on short-code early-return paths; execution evidence is recorded in
     `web-mcp-phase-c-execution-log.md` (`Unit WS-D-278`).
66. Backend code classification long-code exact-lookup guard optimization:
   - `_classifyBackendCode(...)` now caches and reuses combined signed-out marker max length
     (`_backendSignedOutCodeMarkerMaxLength`) and skips raw/compact exact-map lookups when code
     length exceeds marker max length, reducing unnecessary exact-map probes on long classifier
     inputs while preserving substring marker evaluation paths,
   - existing numeric shortcuts (`401`, `403`, `440`), short-code early-return semantics, and
     signed-out/session-expired marker precedence remain unchanged,
   - contract/parity suites now lock capitalized compact signed-out suffix behavior
     (`code: "SignedOutSessionStateMismatch"`) to preserve deterministic auth-required fallback
     mapping on long-code exact-lookup guard paths; execution evidence is recorded in
     `web-mcp-phase-c-execution-log.md` (`Unit WS-D-279`).
67. Backend code classification marker-count static caching optimization:
   - `_classifyBackendCode(...)` now reuses top-level marker-count constants
     (`_backendSessionExpiredCodeMarkerCount`, `_backendSignedOutOnlyCodeMarkerCount`) for
     index-based marker scans, avoiding repeated per-call marker-length reads on session-expired and
     signed-out-only loops,
   - existing numeric shortcuts, short-code/long-code exact-lookup guards, and marker precedence
     semantics remain unchanged,
   - contract/parity suites now lock capitalized compact mixed marker behavior
     (`code: "UnauthorizedSessionTimeoutContinuation"`) to preserve deterministic session-expired
     fallback precedence on long mixed-marker paths; execution evidence is recorded in
     `web-mcp-phase-c-execution-log.md` (`Unit WS-D-280`).
68. Backend code classification exact-length candidate gating optimization:
   - `_classifyBackendCode(...)` now reuses precomputed marker-length catalog
     (`_backendSignedOutCodeMarkerLengths`) and only probes raw/compact exact maps when the input
     length is a known marker length, reducing unnecessary exact-map lookups on non-catalog
     lengths while preserving long/short code guards and substring marker fallback paths,
   - existing numeric shortcuts, marker precedence, and signed-out/session-expired fallback
     semantics remain unchanged,
   - contract/parity suites now lock capitalized compact signed-out length-gap suffix behavior
     (`code: "SignedOutErr"`) to preserve deterministic auth-required fallback mapping on
     non-catalog exact-length-gated paths; execution evidence is recorded in
     `web-mcp-phase-c-execution-log.md` (`Unit WS-D-281`).

## Remaining integration gaps (auth scope)

| Gap | Current state | Target integrated state | Primary evidence gate |
|---|---|---|---|
| Real backend auth request/response contract handshake | Remote-stub backend transport supports request metadata/response normalization, opt-in sign-in credential forwarding, operation-scoped auth endpoint overrides (`backendEndpointOverrides` + auth endpoint env vars), envelope-chain compatibility (`result` / `data` / `payload` including deep nested wrapper traversal with cycle-safe envelope guards), HTTP auth non-2xx payload normalization, required-state fallback blocking (`PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_REQUIRE_STATE`) which is auto-enabled for backend execution transport by default (explicit `false` opt-out supported), and diagnostics-visible fallback-policy labeling (`auth-backend-fallback: require-state|strict-schema|delegate-enabled`), but auth flow still includes simulated fallback assumptions when required-state mode is disabled | Auth contract methods bind to production backend auth envelope/schema and error semantics | `desktop/test/contracts/workflow_contracts_test.dart` + auth backend integration tests in `desktop/test/parity/auth_session_parity_test.dart` |
| Session/token persistence continuity under real backend lifecycle | Secure store path exists, but rotation/expiry behavior is still validated mainly through simulated payloads | Real backend token/session rotation and expiry handling validated with persisted secure-store state | `desktop:verify:full` with backend-auth integration fixtures/evidence |
| Backend auth error-to-UX mapping policy | Signed-out/state/status normalization is broad and now includes forced signed-out transition from previously signed-in snapshots under signed-out code/failure-flag signals, parity auth-session backend path coverage, deterministic fallback status mapping for code-only/failure-only backend auth payloads (`Authentication required.` / `Backend session expired.` / `Backend auth request failed.`), expanded session-expiry code alias handling (`SESSION_TIMEOUT`, `EXPIRED_TOKEN`, etc.), snake_case signed-in/remember alias support (`signed_in` / `is_signed_in` / `is_authenticated` / `logged_in` / `is_logged_in` / `remember_session` / `persist_session`), explicit signed-out alias support (`signedOut` / `isSignedOut` / `loggedOut` / `isLoggedOut` / `signed_out` / `is_signed_out` / `logged_out` / `is_logged_out`) with full signed-out alias variant regression coverage in contract/parity suites, backend status-code alias extraction support (`statusCode` / `httpStatus` / `status_code` / `http_status`) with camelCase/snake_case regression coverage, explicit failure-flag alias support (`ok` / `isSuccess` / `isOk` / `is_success` / `is_ok`) with mixed-alias explicit-false precedence regression coverage (`success=true` + `is_success=false`, including nested `errors[].is_success=false`), allocation-light backend code normalization path for classifier hot paths, single-pass backend code classification reuse across state/status inference, centralized auth alias constants for parser consistency, and explicit signed-in precedence regression coverage for code/failure-flag/state-alias variants while explicit backend status/message/detail remains precedence, but real backend contract mapping table is not yet fixed | Explicit backend auth failure taxonomy mapped to status text + signed-in state transitions | Execution-log unit evidence + parity gate updates |
| Rollout and fallback policy for backend auth path | Runtime mode gate, strict malformed-schema toggle wiring (`PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_SCHEMA_STRICT`), required-state toggle (`PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_REQUIRE_STATE`), diagnostics fallback-policy labeling (`auth-backend-fallback: ...`), and staged rollout/decommission checklist baseline are now codified in this plan, but production rollout execution evidence is still pending | Staged rollout execution evidence + decommission completion for simulated-path assumptions | Execution-log rollout evidence + inventory/checklist/acceptance/runbook sync |

## Backend auth rollout stages and decommission checklist

### Rollout stages

| Stage | Goal | Required gate evidence | Rollback trigger |
|---|---|---|---|
| R0: Baseline hardening (current) | Keep parser/contract safeguards active while rollout controls are observable (`auth-backend-fallback`, `auth-backend-state`, `auth-backend-schema`) | `desktop/test/contracts/workflow_contracts_test.dart`, `desktop/test/parity/auth_session_parity_test.dart`, `desktop/test/parity/remote_stub_mode_parity_test.dart`, and `pnpm run desktop:verify:full` green | Any auth parser/status regression |
| R1: Strict-schema canary | Enable `PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_SCHEMA_STRICT=true` in canary profile to block malformed backend auth payload fallback | Strict-schema parity lock + diagnostics profile label evidence (`auth-backend-schema: strict`) + full verification | Unexpected malformed-payload reject rate or auth restoration regressions |
| R2: Required-state enforcement | Enforce `PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_REQUIRE_STATE=true` in rollout profile so missing backend state cannot delegate-fallback | Required-state parity lock + diagnostics fallback-policy label evidence (`auth-backend-fallback: require-state`) + full verification | Backend response contract incompleteness causing sign-in/refresh drops |
| R3: Delegate-fallback decommission | Remove release-path dependence on `delegate-enabled` fallback assumptions for backend execution transport | Contract/parity evidence showing stable auth flows without delegate fallback + release verification green | Any production blocking flow still dependent on simulated delegate behavior |
| R4: Full backend contract promotion | Promote real backend auth contract path as default acceptance baseline for desktop auth/session | ABI-02/ABI-03 completion evidence + parity acceptance update + full verification and release smoke evidence | Backend contract mismatch affecting sign-in/restore/refresh lifecycle |

### Decommission checklist (simulated auth assumptions)

1. Confirm release profiles do not ship with `delegate-enabled` fallback policy for backend execution transport.
2. Keep strict-schema + required-state diagnostics labels visible during rollout to validate effective mode.
3. Record per-stage execution evidence in `web-mcp-phase-c-execution-log.md` with explicit commands/results.
4. Update `desktop-flutter-migration-inventory.md`, `desktop-flutter-parity-checklist.md`, and `desktop-flutter-parity-acceptance-baseline.md` when stage status changes.
5. Close runbook next-unit candidate wording only after R3 completion criteria are met.
6. Mark rollout gap row as closed only when R4 gate evidence is published.

## Execution unit sequence

### ABI-01: Backend auth envelope/schema contract lock

1. Freeze expected backend auth response envelopes for sign-in/restore/refresh flows.
2. Add contract fixtures covering success, signed-out, token-expiry, and unauthorized variants.
3. Add strict parser assertions for required auth fields/aliases per flow.
4. Status: in progress (fixture matrix baseline + `result/data/payload` envelope-chain and `authState` alias fixture coverage added in `workflow_contracts_test.dart`, including explicit signed-out envelope alias variants (`signedOut`, `signed_out`, `isSignedOut`, `is_signed_out`), logged-style signed-out envelope fixtures (`loggedOut`, `logged_out`, `isLoggedOut`, `is_logged_out`), signed-in envelope fixtures (`result.authState.isAuthenticated`, `data.authState.isAuthenticated`, `data.authState.loggedIn`, `result.authState.loggedIn`, `data.authState.isLoggedIn`, `result.authState.isLoggedIn`, `data.authState.is_authenticated`, `result.authState.is_authenticated`, `data.authState.signedIn`, `result.authState.signedIn`, `data.authState.authenticated`, `result.authState.authenticated`, `data.authState.logged_in`, `result.authState.logged_in`, `data.authState.is_logged_in`, `result.authState.is_logged_in`, `data.authState.signed_in`, `result.authState.signed_in`, `data.authState.is_signed_in`, `result.authState.is_signed_in`), deep-envelope-chain fixture coverage beyond prior bounded depth, cycle-safe envelope traversal guard coverage for malformed cyclic envelope references, cyclic-primary-envelope alternate-wrapper fallback fixture/parity coverage, sibling `result`/`data` envelope fallback fixture/parity coverage for metadata-only primary chains, cycle-safe recursive container traversal guard coverage for malformed cyclic payloads, plus contract/parity logged-style signed-out alias regression coverage (`loggedOut`, `isLoggedOut`, `logged_out`, `is_logged_out`) and dedicated signed-in parity locks (`signed_in`, `is_signed_in`, `logged_in`, `is_logged_in`, `loggedIn`, `isLoggedIn`); broader schema fixture expansion remains).

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
