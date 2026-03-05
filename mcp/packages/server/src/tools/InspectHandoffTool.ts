import { z } from "zod";
import "reflect-metadata";
import { ExecuteCodeTaskParams } from "@penjar/mcp-common";
import { PenjarMcpServer } from "../PenjarMcpServer";
import { ExecuteCodePluginTask } from "../tasks/ExecuteCodePluginTask";
import { Tool } from "../Tool";
import { TextResponse, ToolResponse } from "../ToolResponse";

export class InspectHandoffArgs {
    static schema = {
        scope: z
            .enum(["selection", "page"])
            .default("selection")
            .describe("Handoff scope: current selection or the active page root."),
        includeCss: z.boolean().default(true).describe("Whether to include generated CSS output."),
        maxDepth: z
            .number()
            .int("maxDepth must be an integer")
            .min(1, "maxDepth must be >= 1")
            .max(8, "maxDepth must be <= 8")
            .default(3)
            .describe("Maximum depth for hierarchy extraction."),
    };

    scope: "selection" | "page" = "selection";

    includeCss: boolean = true;

    maxDepth: number = 3;
}

/**
 * Tool for inspect/code handoff extraction with stable output keys.
 */
export class InspectHandoffTool extends Tool<InspectHandoffArgs> {
    constructor(mcpServer: PenjarMcpServer) {
        super(mcpServer, InspectHandoffArgs.schema);
    }

    public getToolName(): string {
        return "inspect_handoff";
    }

    public getToolDescription(): string {
        return (
            "Extracts handoff-ready inspect data (hierarchy, layout semantics, CSS) " +
            "for either the current selection or the active page."
        );
    }

    private buildCode(args: InspectHandoffArgs): string {
        const scope = JSON.stringify(args.scope);
        const includeCss = args.includeCss ? "true" : "false";
        const maxDepth = args.maxDepth;

        return `
// inspect_handoff_operation: extract
const scope = ${scope};
const includeCss = ${includeCss};
const maxDepth = ${maxDepth};

const selectionTargets = Array.isArray(penjar.selection) ? penjar.selection : [];
const defaultTarget = penjar.root ? [penjar.root] : [];
const targets = scope === "selection" ? (selectionTargets.length > 0 ? selectionTargets : defaultTarget) : defaultTarget;

const hierarchy = targets.map((shape) => penjarUtils.shapeStructure(shape, maxDepth));
const style = includeCss && targets.length > 0
  ? penjar.generateStyle(targets, { type: "css", includeChildren: true })
  : null;

return {
  operation: "inspect_handoff",
  scope,
  hierarchy,
  layoutSemantics: {
    maxDepth,
    targetCount: targets.length,
    fallbackUsed: scope === "selection" && selectionTargets.length === 0
  },
  style,
  tokenHints: []
};
        `;
    }

    protected async executeCore(args: InspectHandoffArgs): Promise<ToolResponse> {
        const taskParams: ExecuteCodeTaskParams = { code: this.buildCode(args) };
        const task = new ExecuteCodePluginTask(taskParams);
        const result = await this.mcpServer.pluginBridge.executePluginTask(task);
        return new TextResponse(JSON.stringify(result.data?.result ?? null, null, 2));
    }
}
