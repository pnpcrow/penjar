# Penjar MCP Server

A Model Context Protocol (MCP) server that provides Penjar integration
capabilities for AI clients supporting the model context protocol (MCP).

## Setup

1. Install Dependencies

        pnpm install

2. Build the Project

        pnpm run build

3. Run the Server

        pnpm run start

4. Check Runtime Diagnostics

        curl http://localhost:4401/health

The health payload includes plugin connection counters, pending task/session state,
and remediation hints for common bridge failures.
HTTP status remains `200`; consume the payload `status` field to detect degraded bridge state.


## Penjar Plugin API REPL

The MCP server includes a REPL interface for testing Penjar Plugin API calls.
To use it, connect to the URL reported at startup.
