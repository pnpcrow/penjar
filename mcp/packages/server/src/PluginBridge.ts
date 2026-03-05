import * as http from "http";
import { PluginTaskResponse, PluginTaskResult } from "@penjar/mcp-common";
import { WebSocket, WebSocketServer } from "ws";
import { PluginTask } from "./PluginTask";
import {
    BridgeDiagnosticCode,
    buildBridgeDiagnostic,
    getBridgeDiagnosticTemplates,
    getErrorMessage,
} from "./BridgeDiagnostics";
import { createLogger } from "./logger";
import type { PenjarMcpServer } from "./PenjarMcpServer";

interface ClientConnection {
    socket: WebSocket;
    userToken: string | null;
}

interface BridgeFailureSnapshot {
    at: string;
    message: string;
    diagnosticCode?: BridgeDiagnosticCode;
}

interface BridgeDisconnectSnapshot {
    at: string;
    code: number;
    reason: string;
    userToken: string | null;
}

interface BridgeTimeoutSnapshot {
    at: string;
    taskId: string;
    timeoutSecs: number;
}

export interface PluginBridgeHealthSnapshot {
    websocketPort: number;
    taskTimeoutSecs: number;
    connectedClients: number;
    connectedTokenSessions: number;
    pendingTasks: number;
    lastConnectionAt: string | null;
    lastDisconnect: BridgeDisconnectSnapshot | null;
    lastTaskTimeout: BridgeTimeoutSnapshot | null;
    lastFailure: BridgeFailureSnapshot | null;
}

/**
 * Manages WebSocket connections to Penjar plugin instances and handles plugin tasks
 * over these connections.
 */
export class PluginBridge {
    private readonly logger = createLogger("PluginBridge");
    private readonly wsServer: WebSocketServer;
    private readonly connectedClients: Map<WebSocket, ClientConnection> = new Map();
    private readonly clientsByToken: Map<string, ClientConnection> = new Map();
    private readonly pendingTasks: Map<string, PluginTask<any, any>> = new Map();
    private readonly taskTimeouts: Map<string, NodeJS.Timeout> = new Map();

    private lastConnectionAt: string | null = null;
    private lastDisconnect: BridgeDisconnectSnapshot | null = null;
    private lastTaskTimeout: BridgeTimeoutSnapshot | null = null;
    private lastFailure: BridgeFailureSnapshot | null = null;

    constructor(
        public readonly mcpServer: PenjarMcpServer,
        private port: number,
        private taskTimeoutSecs: number = 30
    ) {
        this.wsServer = new WebSocketServer({ port: port });
        this.setupWebSocketHandlers();
    }

    private nowIso(): string {
        return new Date().toISOString();
    }

    private recordFailure(error: unknown): Error {
        const message = getErrorMessage(error);
        const normalized = error instanceof Error ? error : new Error(message);
        const diagnostic = buildBridgeDiagnostic(normalized);
        this.lastFailure = {
            at: this.nowIso(),
            message,
            diagnosticCode: diagnostic?.code,
        };
        return normalized;
    }

    private unregisterConnection(ws: WebSocket): ClientConnection | undefined {
        const connection = this.connectedClients.get(ws);
        this.connectedClients.delete(ws);
        if (connection?.userToken) {
            const indexed = this.clientsByToken.get(connection.userToken);
            if (indexed?.socket === ws) {
                this.clientsByToken.delete(connection.userToken);
            }
        }
        return connection;
    }

    /**
     * Sets up WebSocket connection handlers for plugin communication.
     *
     * Manages client connections and provides bidirectional communication
     * channel between the MCP mcpServer and Penjar plugin instances.
     */
    private setupWebSocketHandlers(): void {
        this.wsServer.on("connection", (ws: WebSocket, request: http.IncomingMessage) => {
            // extract userToken from query parameters
            const url = new URL(request.url!, `ws://${request.headers.host}`);
            const userToken = url.searchParams.get("userToken");

            // require userToken if running in multi-user mode
            if (this.mcpServer.isMultiUserMode() && !userToken) {
                this.logger.warn("Connection attempt without userToken in multi-user mode - rejecting");
                ws.close(1008, "Missing userToken parameter");
                return;
            }

            if (userToken && this.clientsByToken.has(userToken)) {
                const duplicateMessage = "Duplicate connection for given user token; close previous connection first.";
                this.logger.warn(duplicateMessage);
                this.recordFailure(new Error(duplicateMessage));
                ws.close(1008, duplicateMessage);
                return;
            }

            if (userToken) {
                this.logger.info("New WebSocket connection established (token provided)");
            } else {
                this.logger.info("New WebSocket connection established");
            }

            // register the client connection with both indexes
            const connection: ClientConnection = { socket: ws, userToken };
            this.connectedClients.set(ws, connection);
            if (userToken) {
                this.clientsByToken.set(userToken, connection);
            }
            this.lastConnectionAt = this.nowIso();

            ws.on("message", (data: Buffer) => {
                this.logger.debug("Received WebSocket message: %s", data.toString());
                try {
                    if (data.toString() === "keep-alive") {
                        ws.send("keep-alive");
                        return;
                    }
                    const response: PluginTaskResponse<any> = JSON.parse(data.toString());
                    this.handlePluginTaskResponse(response);
                } catch (error) {
                    this.recordFailure(error);
                    this.logger.error(error, "Failure while processing WebSocket message");
                }
            });

            ws.on("close", (code: number, reason: Buffer) => {
                const reasonText = reason.toString() || "No reason provided";
                this.logger.info("WebSocket connection closed: code=%d reason=%s", code, reasonText);

                const closedConnection = this.unregisterConnection(ws);
                this.lastDisconnect = {
                    at: this.nowIso(),
                    code,
                    reason: reasonText,
                    userToken: closedConnection?.userToken ?? null,
                };

                if (code !== 1000 && code !== 1001) {
                    this.recordFailure(new Error(`WebSocket closed unexpectedly (code ${code}): ${reasonText}`));
                }
            });

            ws.on("error", (error) => {
                this.recordFailure(error);
                this.logger.error(error, "WebSocket connection error");
                this.unregisterConnection(ws);
            });
        });

        this.logger.info("WebSocket mcpServer started on port %d", this.port);
    }

    /**
     * Handles responses from the plugin for completed tasks.
     *
     * Finds the pending task by ID and resolves or rejects its promise
     * based on the execution result.
     *
     * @param response - The plugin task response containing ID and result
     */
    private handlePluginTaskResponse(response: PluginTaskResponse<any>): void {
        const task = this.pendingTasks.get(response.id);
        if (!task) {
            this.logger.info(`Received response for unknown task ID: ${response.id}`);
            return;
        }

        // clear the timeout and remove the task from pending tasks
        const timeoutHandle = this.taskTimeouts.get(response.id);
        if (timeoutHandle) {
            clearTimeout(timeoutHandle);
            this.taskTimeouts.delete(response.id);
        }
        this.pendingTasks.delete(response.id);

        // resolve or reject the task's promise based on the result
        if (response.success) {
            task.resolveWithResult({ data: response.data });
        } else {
            const error = new Error(response.error || "Task execution failed (details not provided)");
            this.recordFailure(error);
            task.rejectWithError(error);
        }

        this.logger.info(`Task ${response.id} completed: success=${response.success}`);
    }

    /**
     * Determines the client connection to use for executing a task.
     *
     * In single-user mode, returns the single connected client.
     * In multi-user mode, returns the client matching the session's userToken.
     *
     * @returns The client connection to use
     * @throws Error if no suitable connection is found or if configuration is invalid
     */
    private getClientConnection(): ClientConnection {
        if (this.mcpServer.isMultiUserMode()) {
            const sessionContext = this.mcpServer.getSessionContext();
            if (!sessionContext?.userToken) {
                throw new Error("No userToken found in session context. Multi-user mode requires authentication.");
            }

            const connection = this.clientsByToken.get(sessionContext.userToken);
            if (!connection) {
                throw new Error(
                    "No plugin instance connected for user token. Please ensure the plugin is running and connected with the correct token."
                );
            }

            return connection;
        }

        // single-user mode: return the single connected client
        if (this.connectedClients.size === 0) {
            throw new Error(
                "No Penjar plugin instances are currently connected. Please ensure the plugin is running and connected."
            );
        }
        if (this.connectedClients.size > 1) {
            throw new Error(
                `Multiple (${this.connectedClients.size}) Penjar MCP Plugin instances are connected. ` +
                    "Ask the user to ensure that only one instance is connected at a time."
            );
        }

        // return the first (and only) connection
        const connection = this.connectedClients.values().next().value;
        return <ClientConnection>connection;
    }

    public getHealthSnapshot(): PluginBridgeHealthSnapshot {
        return {
            websocketPort: this.port,
            taskTimeoutSecs: this.taskTimeoutSecs,
            connectedClients: this.connectedClients.size,
            connectedTokenSessions: this.clientsByToken.size,
            pendingTasks: this.pendingTasks.size,
            lastConnectionAt: this.lastConnectionAt,
            lastDisconnect: this.lastDisconnect,
            lastTaskTimeout: this.lastTaskTimeout,
            lastFailure: this.lastFailure,
        };
    }

    public getKnownDiagnostics() {
        return getBridgeDiagnosticTemplates();
    }

    /**
     * Executes a plugin task by sending it to connected clients.
     *
     * Registers the task for result correlation and returns a promise
     * that resolves when the plugin responds with the execution result.
     *
     * @param task - The plugin task to execute
     * @throws Error if no plugin instances are connected or available
     */
    public async executePluginTask<TResult extends PluginTaskResult<any>>(
        task: PluginTask<any, TResult>
    ): Promise<TResult> {
        let connection: ClientConnection;
        try {
            // get the appropriate client connection based on mode
            connection = this.getClientConnection();
        } catch (error) {
            throw this.recordFailure(error);
        }

        // register the task for result correlation
        this.pendingTasks.set(task.id, task);

        // send task to the selected client
        const requestMessage = JSON.stringify(task.toRequest());
        if (connection.socket.readyState !== WebSocket.OPEN) {
            // WebSocket is not open
            this.pendingTasks.delete(task.id);
            throw this.recordFailure(new Error("Plugin instance is disconnected. Task could not be sent."));
        }

        try {
            connection.socket.send(requestMessage);
        } catch (error) {
            this.pendingTasks.delete(task.id);
            throw this.recordFailure(error);
        }

        // set up a timeout to reject the task if no response is received
        const timeoutHandle = setTimeout(() => {
            const pendingTask = this.pendingTasks.get(task.id);
            if (pendingTask) {
                const timeoutError = new Error(`Task ${task.id} timed out after ${this.taskTimeoutSecs} seconds`);
                this.pendingTasks.delete(task.id);
                this.taskTimeouts.delete(task.id);
                this.lastTaskTimeout = {
                    at: this.nowIso(),
                    taskId: task.id,
                    timeoutSecs: this.taskTimeoutSecs,
                };
                this.recordFailure(timeoutError);
                pendingTask.rejectWithError(timeoutError);
            }
        }, this.taskTimeoutSecs * 1000);

        this.taskTimeouts.set(task.id, timeoutHandle);
        this.logger.info(`Sent task ${task.id} to connected client`);

        return await task.getResultPromise();
    }
}
