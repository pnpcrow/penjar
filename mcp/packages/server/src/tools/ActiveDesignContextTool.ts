import "reflect-metadata";
import { ExecuteCodeTaskParams } from "@penjar/mcp-common";
import { PenjarMcpServer } from "../PenjarMcpServer";
import { ExecuteCodePluginTask } from "../tasks/ExecuteCodePluginTask";
import { EmptyToolArgs, Tool } from "../Tool";
import { TextResponse, ToolResponse } from "../ToolResponse";

/**
 * Returns a compact summary of the currently active design context.
 *
 * This gives MCP clients a deterministic starting point for project/file/page
 * operations before executing broader workflow changes.
 */
export class ActiveDesignContextTool extends Tool<EmptyToolArgs> {
    constructor(mcpServer: PenjarMcpServer) {
        super(mcpServer, EmptyToolArgs.schema);
    }

    public getToolName(): string {
        return "active_design_context";
    }

    public getToolDescription(): string {
        return (
            "Returns the active Penjar design context summary, including file metadata, current page, " +
            "and current selection. Use this first to anchor project/file workflow operations."
        );
    }

    protected async executeCore(args: EmptyToolArgs): Promise<ToolResponse> {
        const taskParams: ExecuteCodeTaskParams = {
            code: `
const file = penjar.file ?? null;
const pages = Array.isArray(penjar.pages) ? penjar.pages : [];
const currentPage = penjar.currentPage ?? null;
const selection = Array.isArray(penjar.selection) ? penjar.selection : [];

return {
  file: file
    ? {
        id: file.id,
        name: file.name ?? null,
        pageCount: pages.length
      }
    : null,
  currentPage: currentPage
    ? {
        id: currentPage.id,
        name: currentPage.name ?? null
      }
    : null,
  selection: {
    count: selection.length,
    ids: selection.map((shape) => shape.id),
    names: selection.map((shape) => shape.name ?? null)
  }
};
            `,
        };

        const task = new ExecuteCodePluginTask(taskParams);
        const result = await this.mcpServer.pluginBridge.executePluginTask(task);
        const context = result.data?.result ?? null;
        return new TextResponse(JSON.stringify(context, null, 2));
    }
}
