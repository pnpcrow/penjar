---
title: Web + MCP Phase A Ticket Seed
desc: Prioritized implementation ticket seeds derived from P0 parity backlog rows.
---

# Web + MCP Phase A Ticket Seed

This document converts the current P0 backlog rows into implementation-ready ticket seeds.

## Priority order

1. `P0-003` Authentication/session recovery integration
2. `P0-004` Project lifecycle parity
3. `P0-005` File lifecycle role/error parity
4. `P0-006` Canvas editing scenario contracts
5. `P0-007` Asset interruption/retry resilience
6. `P0-008` Inspect/code handoff contract tests

## Ticket seeds

### TKT-P0-003-A: Multi-user auth recovery integration scenarios

- Source backlog item: `P0-003`
- Goal: validate token-missing and token-mismatch runtime recovery paths.
- Scope:
  - missing token tool-call failure path,
  - mismatched token path (MCP token vs plugin token),
  - successful retry after reconnect.
- Acceptance criteria:
  1. automated integration scenarios run in CI and fail on regression,
  2. each auth diagnostic code is linked to deterministic client action,
  3. recovery path is documented in operator/client troubleshooting docs.

Current baseline note:
- Negative runtime probes for `AUTH_TOKEN_MISSING` and `AUTH_TOKEN_EXPIRED_OR_MISMATCH`
  are implemented in `pnpm run verify:auth-session`.
- Reconnect-retry success flow is also validated in `pnpm run verify:auth-session`.
- Duplicate-token connection conflict handling (`PLUGIN_CONNECTION_CONFLICT`) is validated in `pnpm run verify:auth-session`.

### TKT-P0-004-A: Project lifecycle parity contract

- Source backlog item: `P0-004`
- Goal: ensure end-to-end continuity from project selection to active file context.
- Scope:
  - baseline workflow fixture definitions,
  - MCP capability mapping for each step,
  - acceptance checks for context preservation.
- Acceptance criteria:
  1. workflow fixtures are versioned and executable,
  2. missing capability rows are either implemented or explicitly blocked with dependency notes,
  3. parity evidence is linked in capability matrix.

Current baseline note:
- `active_design_context` tool and `verify:project-lifecycle` probe validate entry-point plus multi-context transitions (page move, file switch, detached context).

### TKT-P0-005-A: File lifecycle role/error matrix

- Source backlog item: `P0-005`
- Goal: verify CRUD behavior under restricted roles and failure modes.
- Scope:
  - role matrix (`owner/editor/viewer`-equivalent policy),
  - create/rename/delete success and denied paths,
  - error diagnostics consistency.
- Acceptance criteria:
  1. role-aware tests cover all CRUD operations,
  2. denied paths emit stable actionable errors,
  3. docs capture expected behavior per role class.

Current baseline note:
- `file_lifecycle` tool and `verify:file-lifecycle` probe cover inspect/create_page/rename_file/rename_page/open_page paths, deterministic denied/missing diagnostics (`PERMISSION_DENIED`, `RESOURCE_NOT_FOUND`), and explicit delete-path strategy signaling (`UNSUPPORTED_OPERATION` for `delete_page` requests).

### TKT-P0-006-A: Canvas operation scenario fixtures

- Source backlog item: `P0-006`
- Goal: establish scenario contracts for common geometry/style operations.
- Scope:
  - canonical fixture set for shape creation, transforms, style updates,
  - expected output snapshots,
  - mismatch triage rubric.
- Acceptance criteria:
  1. scenario fixtures execute without manual steps,
  2. snapshot differences are reviewable and deterministic,
  3. parity row can reference fixture evidence.

Current baseline note:
- `canvas_editing` tool and `verify:canvas-editing` probe cover create_rectangle/resize_shape/move_shape/set_fill_color flows and deterministic denied/missing diagnostics (`PERMISSION_DENIED`, `RESOURCE_NOT_FOUND`).

### TKT-P0-007-A: Asset interruption and retry resilience

- Source backlog item: `P0-007`
- Goal: validate asset import/reference behavior across disconnect/reconnect windows.
- Scope:
  - interruption injection points,
  - retry behavior and idempotency checks,
  - mismatch diagnostics requirements.
- Acceptance criteria:
  1. interruption tests cover at least connect-loss and timeout cases,
  2. retries avoid duplicate/partial asset corruption,
  3. diagnostics include remediation path for operators.

Current baseline note:
- `verify:asset-management` validates import_image success, interruption diagnostics for timeout/disconnect flows, and reconnect-recovery import success.

### TKT-P0-008-A: Inspect output contract tests

- Source backlog item: `P0-008`
- Goal: lock inspect payload completeness for design-to-code workflows.
- Scope:
  - fixture-based validation of hierarchy/token/layout fields,
  - required vs optional field contract table,
  - regression gate for payload shape changes.
- Acceptance criteria:
  1. contract tests fail on missing required fields,
  2. output schema changes require explicit contract update,
  3. matrix evidence links to merged contract tests.

Current baseline note:
- `inspect_handoff` tool and `verify:inspect-handoff` probe validate selection/page scope handoff fields and deterministic missing-target diagnostics (`RESOURCE_NOT_FOUND`).

## Sequencing notes

- `TKT-P0-003-A` should start first because auth recovery failures block all higher-layer flows.
- `TKT-P0-004-A` and `TKT-P0-005-A` can run in parallel once auth integration scaffolding exists.
- `TKT-P0-006-A` / `TKT-P0-007-A` / `TKT-P0-008-A` can be staged by team capacity after lifecycle coverage is stable.
