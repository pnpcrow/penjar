import { z } from "zod";
import "reflect-metadata";
import { ExecuteCodeTaskParams } from "@penjar/mcp-common";
import { PenjarMcpServer } from "../PenjarMcpServer";
import { ExecuteCodePluginTask } from "../tasks/ExecuteCodePluginTask";
import { Tool } from "../Tool";
import { TextResponse, ToolResponse } from "../ToolResponse";

export class CanvasEditingArgs {
    static schema = {
        operation: z
            .enum(["create_rectangle", "resize_shape", "move_shape", "set_fill_color"])
            .describe("Canvas editing operation to execute."),
        shapeId: z.string().optional().describe("Target shape ID for non-creation operations."),
        name: z.string().optional().describe("Shape name for create_rectangle."),
        x: z.number().optional().describe("X coordinate for create/move operations."),
        y: z.number().optional().describe("Y coordinate for create/move operations."),
        width: z.number().optional().describe("Width for create/resize operations."),
        height: z.number().optional().describe("Height for create/resize operations."),
        fillColor: z.string().optional().describe("Fill color for create/set_fill_color operations."),
    };

    operation!: "create_rectangle" | "resize_shape" | "move_shape" | "set_fill_color";

    shapeId?: string;

    name?: string;

    x?: number;

    y?: number;

    width?: number;

    height?: number;

    fillColor?: string;
}

/**
 * Tool for common canvas editing operations with explicit operation contracts.
 */
export class CanvasEditingTool extends Tool<CanvasEditingArgs> {
    constructor(mcpServer: PenjarMcpServer) {
        super(mcpServer, CanvasEditingArgs.schema);
    }

    public getToolName(): string {
        return "canvas_editing";
    }

    public getToolDescription(): string {
        return "Performs common canvas editing operations: create rectangle, resize shape, move shape, and set fill color.";
    }

    private requireShapeId(args: CanvasEditingArgs): string {
        if (!args.shapeId) {
            throw new Error(`shapeId is required for ${args.operation} operation.`);
        }
        return args.shapeId;
    }

    private buildCode(args: CanvasEditingArgs): string {
        if (args.operation === "create_rectangle") {
            const name = JSON.stringify(args.name ?? "Generated rectangle");
            const x = args.x ?? 0;
            const y = args.y ?? 0;
            const width = args.width ?? 100;
            const height = args.height ?? 100;
            const fillColor = args.fillColor ? JSON.stringify(args.fillColor) : null;
            const fillStmt = fillColor ? `rect.fills = [{ fillColor: ${fillColor} }];` : "";

            return `
// canvas_editing_operation: create_rectangle
const rect = penjar.createRectangle();
rect.name = ${name};
rect.x = ${x};
rect.y = ${y};
rect.resize(${width}, ${height});
${fillStmt}
penjar.root.appendChild(rect);
return {
  operation: "create_rectangle",
  shape: {
    id: rect.id,
    name: rect.name ?? null,
    x: rect.x,
    y: rect.y,
    width: rect.width,
    height: rect.height
  }
};
            `;
        }

        if (args.operation === "resize_shape") {
            const shapeId = JSON.stringify(this.requireShapeId(args));
            if (args.width === undefined || args.height === undefined) {
                throw new Error("width and height are required for resize_shape operation.");
            }
            return `
// canvas_editing_operation: resize_shape
const shape = penjarUtils.findShapeById(${shapeId});
if (!shape) {
  throw new Error("Target shape was not found.");
}
shape.resize(${args.width}, ${args.height});
return {
  operation: "resize_shape",
  shape: {
    id: shape.id,
    width: shape.width,
    height: shape.height
  }
};
            `;
        }

        if (args.operation === "move_shape") {
            const shapeId = JSON.stringify(this.requireShapeId(args));
            if (args.x === undefined || args.y === undefined) {
                throw new Error("x and y are required for move_shape operation.");
            }
            return `
// canvas_editing_operation: move_shape
const shape = penjarUtils.findShapeById(${shapeId});
if (!shape) {
  throw new Error("Target shape was not found.");
}
shape.x = ${args.x};
shape.y = ${args.y};
return {
  operation: "move_shape",
  shape: {
    id: shape.id,
    x: shape.x,
    y: shape.y
  }
};
            `;
        }

        const shapeId = JSON.stringify(this.requireShapeId(args));
        if (!args.fillColor) {
            throw new Error("fillColor is required for set_fill_color operation.");
        }
        const fillColor = JSON.stringify(args.fillColor);
        return `
// canvas_editing_operation: set_fill_color
const shape = penjarUtils.findShapeById(${shapeId});
if (!shape) {
  throw new Error("Target shape was not found.");
}
shape.fills = [{ fillColor: ${fillColor} }];
return {
  operation: "set_fill_color",
  shape: {
    id: shape.id,
    fills: shape.fills
  }
};
        `;
    }

    protected async executeCore(args: CanvasEditingArgs): Promise<ToolResponse> {
        const taskParams: ExecuteCodeTaskParams = { code: this.buildCode(args) };
        const task = new ExecuteCodePluginTask(taskParams);
        const result = await this.mcpServer.pluginBridge.executePluginTask(task);
        return new TextResponse(JSON.stringify(result.data?.result ?? null, null, 2));
    }
}
