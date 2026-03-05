---
title: Web ↔ MCP Auth/Session Recovery Contract
desc: Token lifecycle and recovery contract for multi-user MCP sessions, including diagnostics mapping and validation requirements.
---

# Web ↔ MCP Auth/Session Recovery Contract

This document defines the Phase A contract for auth/session recovery in multi-user MCP mode.

## Related execution artifacts

- Navigation and update protocol:
  - [Web + MCP + Desktop Documentation Map](/technical-guide/developer/web-mcp-documentation-map/)
- Planning and evidence chain:
  - [Web + MCP + Desktop Detailed Implementation Plan](/technical-guide/developer/web-mcp-desktop-implementation-plan/)
  - [Web ↔ MCP Capability Matrix](/technical-guide/developer/web-mcp-capability-matrix/)
  - [Web ↔ MCP Parity Backlog](/technical-guide/developer/web-mcp-parity-backlog/)
  - [Web + MCP Phase A Execution Log](/technical-guide/developer/web-mcp-phase-a-execution-log/)

## 1. Scope

- Applies to multi-user MCP server mode (`--multi-user`).
- Covers token presence, token/session mismatch, and reconnect behavior.
- Excludes identity provider internals and token issuance UI.

## 2. Token lifecycle states

1. **Issued**: client has a user token from the upstream auth flow.
2. **Bound (HTTP/SSE)**: MCP request channel includes `userToken`.
3. **Bound (Plugin WS)**: plugin WebSocket connects with the same `userToken`.
4. **Operational**: MCP tool calls are routed to the matching plugin session.
5. **Expired/Mismatched**: HTTP/SSE token no longer maps to an active plugin token session.
6. **Recovered**: token refreshed/reissued and both channels rebound.

## 3. Recovery protocol

1. Client receives a tool error mapped to one of:
   - `AUTH_TOKEN_MISSING`
   - `AUTH_TOKEN_EXPIRED_OR_MISMATCH`
2. Client initiates recovery:
   - obtain a valid token (refresh/reissue),
   - reconnect MCP HTTP/SSE channel with the new token,
   - reconnect plugin WebSocket with the same token.
3. Client retries the failed operation only after both channels report connected/healthy.

## 4. Server and client responsibilities

### Server

- Must reject multi-user plugin connections without `userToken`.
- Must route plugin tasks by token-bound session context.
- Must expose auth-related diagnostics in `/health` diagnostics catalog.

### Client/plugin

- Must send the same token on both MCP and plugin channels.
- Must trigger reconnect on auth diagnostics instead of blind retries.
- Must avoid parallel stale/new token sessions for the same user context.

## 5. Diagnostics mapping contract

| Diagnostic code | Meaning | Required client action |
|---|---|---|
| `AUTH_TOKEN_MISSING` | MCP request lacks required token in multi-user mode | Reconnect MCP channel with token, then reconnect plugin with same token |
| `AUTH_TOKEN_EXPIRED_OR_MISMATCH` | Token exists but no matching plugin token session | Refresh/reissue token, reconnect both channels with identical token |
| `PLUGIN_CONNECTION_CONFLICT` | Duplicate/competing plugin session prevents safe routing | Close stale session, keep one active session per token, reconnect |

## 6. Validation requirements (Phase A)

1. Contract validation (implemented):
   - `/health` diagnostics catalog must contain auth-related diagnostic codes.
   - enforced by `pnpm run verify:phase-a`.
2. Runtime integration validation (pending):
   - simulate token-missing tool call path,
   - simulate expired/mismatched token path,
   - verify deterministic recovery after reconnect.

## 7. Current status and next step

- Current status: **Baseline implemented**.
- Implemented runtime evidence:
  - `pnpm run verify:auth-session` covers
    - missing-token failure (`AUTH_TOKEN_MISSING`),
    - token-mismatch failure (`AUTH_TOKEN_EXPIRED_OR_MISMATCH`),
    - reconnect-retry success flow after plugin token-session binding.
- Next step: extend scenarios to include real token rotation/expiry simulation in full end-to-end environments.
