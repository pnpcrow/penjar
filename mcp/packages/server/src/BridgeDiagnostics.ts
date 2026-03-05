export type BridgeDiagnosticCode =
    | "PLUGIN_DISCONNECTED"
    | "PLUGIN_TASK_TIMEOUT"
    | "AUTH_TOKEN_MISSING"
    | "AUTH_TOKEN_EXPIRED_OR_MISMATCH"
    | "PLUGIN_CONNECTION_CONFLICT"
    | "PERMISSION_DENIED"
    | "RESOURCE_NOT_FOUND"
    | "UNSUPPORTED_OPERATION";

export interface BridgeDiagnostic {
    code: BridgeDiagnosticCode;
    title: string;
    summary: string;
    remediation: string[];
}

const DIAGNOSTIC_TEMPLATES: Record<BridgeDiagnosticCode, BridgeDiagnostic> = {
    PLUGIN_DISCONNECTED: {
        code: "PLUGIN_DISCONNECTED",
        title: "Penjar MCP plugin is not connected",
        summary:
            "The MCP server could not dispatch the request because no active plugin WebSocket connection was available.",
        remediation: [
            "Open the Penjar MCP plugin UI in an active design file.",
            "Click 'Connect to MCP server' and keep the plugin UI open.",
            "If the issue persists, inspect browser console and server logs for WebSocket close reasons.",
        ],
    },
    PLUGIN_TASK_TIMEOUT: {
        code: "PLUGIN_TASK_TIMEOUT",
        title: "Plugin task timed out",
        summary: "The plugin did not respond before the server-side timeout window elapsed.",
        remediation: [
            "Retry with a smaller operation scope (fewer selected objects or simpler script).",
            "Verify the plugin UI is responsive and still connected.",
            "Increase timeout only after confirming the operation is genuinely long-running.",
        ],
    },
    AUTH_TOKEN_MISSING: {
        code: "AUTH_TOKEN_MISSING",
        title: "Missing user token in multi-user mode",
        summary: "The request does not carry a user token in a context where authentication is mandatory.",
        remediation: [
            "Reconnect through /mcp or /sse with the required userToken query parameter.",
            "Ensure the plugin connects with the same userToken in the WebSocket URL.",
            "Regenerate the token if it was not persisted by the client session.",
        ],
    },
    AUTH_TOKEN_EXPIRED_OR_MISMATCH: {
        code: "AUTH_TOKEN_EXPIRED_OR_MISMATCH",
        title: "Token has no active plugin session",
        summary: "A token was provided, but no plugin session is currently registered for it.",
        remediation: [
            "Reconnect the plugin using the same token used by the MCP client request.",
            "Refresh/reissue the token if it may have expired or rotated.",
            "Close stale plugin tabs and reconnect from a single active tab.",
        ],
    },
    PLUGIN_CONNECTION_CONFLICT: {
        code: "PLUGIN_CONNECTION_CONFLICT",
        title: "Conflicting plugin connections detected",
        summary: "The server detected multiple or duplicate plugin sessions and cannot route requests safely.",
        remediation: [
            "Keep exactly one plugin connection per server session in single-user mode.",
            "In multi-user mode, keep one plugin connection per user token.",
            "Disconnect duplicate sessions, then reconnect only the intended tab.",
        ],
    },
    PERMISSION_DENIED: {
        code: "PERMISSION_DENIED",
        title: "Operation blocked by permission policy",
        summary: "The requested operation requires a permission that is not currently granted for this context.",
        remediation: [
            "Confirm the user/session has the required permission scope (for example content:write).",
            "Retry only after switching to a role with the required write privileges.",
            "If policy is expected to allow the operation, review backend role mapping and plugin permissions.",
        ],
    },
    RESOURCE_NOT_FOUND: {
        code: "RESOURCE_NOT_FOUND",
        title: "Target resource was not found",
        summary: "The requested file/page/shape target could not be resolved in the active context.",
        remediation: [
            "Refresh context and verify the target ID still exists.",
            "Use context-inspection tools to list active file/page/selection state before retrying.",
            "Handle deleted/moved resources explicitly in calling workflows.",
        ],
    },
    UNSUPPORTED_OPERATION: {
        code: "UNSUPPORTED_OPERATION",
        title: "Operation is not supported in current runtime",
        summary: "The requested operation is not available through the current Penjar MCP plugin/runtime API surface.",
        remediation: [
            "Check the tool contract for supported operations in the current version.",
            "Use a supported alternative workflow path for this mutation.",
            "If the operation is required, route through backend APIs or schedule plugin/runtime feature expansion.",
        ],
    },
};

export function getBridgeDiagnosticTemplates(): BridgeDiagnostic[] {
    return Object.values(DIAGNOSTIC_TEMPLATES);
}

export function getErrorMessage(error: unknown): string {
    if (error instanceof Error) {
        return error.message;
    }

    return String(error);
}

export function classifyBridgeErrorMessage(message: string): BridgeDiagnosticCode | undefined {
    if (message.includes("timed out after")) {
        return "PLUGIN_TASK_TIMEOUT";
    }

    if (message.includes("No userToken found in session context")) {
        return "AUTH_TOKEN_MISSING";
    }

    if (message.includes("No plugin instance connected for user token")) {
        return "AUTH_TOKEN_EXPIRED_OR_MISMATCH";
    }

    if (
        message.includes("No Penjar plugin instances are currently connected") ||
        message.includes("Plugin instance is disconnected")
    ) {
        return "PLUGIN_DISCONNECTED";
    }

    if (message.includes("Multiple (") || message.includes("Duplicate connection for given user token")) {
        return "PLUGIN_CONNECTION_CONFLICT";
    }

    const normalized = message.toLowerCase();
    if (
        normalized.includes("permission") ||
        normalized.includes("not allowed") ||
        normalized.includes("content:write")
    ) {
        return "PERMISSION_DENIED";
    }

    if (normalized.includes("not found") || normalized.includes("was not found")) {
        return "RESOURCE_NOT_FOUND";
    }

    if (normalized.includes("not supported")) {
        return "UNSUPPORTED_OPERATION";
    }

    return undefined;
}

export function buildBridgeDiagnostic(error: unknown): BridgeDiagnostic | undefined {
    const code = classifyBridgeErrorMessage(getErrorMessage(error));
    if (!code) {
        return undefined;
    }
    return DIAGNOSTIC_TEMPLATES[code];
}

export function formatBridgeDiagnostic(diagnostic: BridgeDiagnostic): string {
    const lines = [
        `[Diagnostic ${diagnostic.code}] ${diagnostic.title}`,
        diagnostic.summary,
        "Suggested remediation:",
        ...diagnostic.remediation.map((item, index) => `${index + 1}. ${item}`),
    ];

    return lines.join("\n");
}
