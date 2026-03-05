import { z } from "zod";
import "reflect-metadata";
import { ExecuteCodeTaskParams } from "@penjar/mcp-common";
import { PenjarMcpServer } from "../PenjarMcpServer";
import { ExecuteCodePluginTask } from "../tasks/ExecuteCodePluginTask";
import { Tool } from "../Tool";
import { TextResponse, ToolResponse } from "../ToolResponse";

export class FileLifecycleArgs {
    static schema = {
        operation: z
            .enum(["inspect", "create_page", "rename_file", "rename_page", "open_page", "delete_page"])
            .describe("Lifecycle operation to execute on the active Penjar file/page context."),
        fileName: z.string().optional().describe("Target file name for the rename_file operation."),
        pageName: z
            .string()
            .optional()
            .describe("Target page name for create_page, rename_page, or open_page operations."),
        pageId: z
            .string()
            .optional()
            .describe("Optional page ID for rename_page/open_page. Defaults to current page for rename_page."),
    };

    operation!: "inspect" | "create_page" | "rename_file" | "rename_page" | "open_page" | "delete_page";

    fileName?: string;

    pageName?: string;

    pageId?: string;
}

/**
 * Tool for file/page lifecycle operations in the active Penjar context.
 */
export class FileLifecycleTool extends Tool<FileLifecycleArgs> {
    constructor(mcpServer: PenjarMcpServer) {
        super(mcpServer, FileLifecycleArgs.schema);
    }

    public getToolName(): string {
        return "file_lifecycle";
    }

    public getToolDescription(): string {
        return (
            "Inspects or mutates active file/page lifecycle state. " +
            "Supported operations: inspect, create_page, rename_file, rename_page, open_page, delete_page (strategy only)."
        );
    }

    private buildCode(args: FileLifecycleArgs): string {
        if (args.operation === "inspect") {
            return `
// file_lifecycle_operation: inspect
const file = penjar.file ?? null;
const pages = Array.isArray(file?.pages) ? file.pages : [];
return {
  operation: "inspect",
  file: file
    ? {
        id: file.id,
        name: file.name ?? null,
        revn: file.revn ?? null,
        pageCount: pages.length,
        pages: pages.map((page) => ({ id: page.id, name: page.name ?? null }))
      }
    : null
};
            `;
        }

        if (args.operation === "create_page") {
            const pageName = JSON.stringify(args.pageName ?? "Untitled page");
            return `
// file_lifecycle_operation: create_page
const page = penjar.createPage();
page.name = ${pageName};
return {
  operation: "create_page",
  createdPage: {
    id: page.id,
    name: page.name ?? null
  },
  file: penjar.file
    ? {
        id: penjar.file.id,
        name: penjar.file.name ?? null,
        pageCount: Array.isArray(penjar.file.pages) ? penjar.file.pages.length : null
      }
    : null
};
            `;
        }

        if (args.operation === "rename_file") {
            if (!args.fileName) {
                throw new Error("fileName is required for rename_file operation.");
            }
            const fileName = JSON.stringify(args.fileName);
            return `
// file_lifecycle_operation: rename_file
if (!penjar.file) {
  throw new Error("No active file context.");
}
const previousName = penjar.file.name ?? null;
penjar.file.name = ${fileName};
return {
  operation: "rename_file",
  file: {
    id: penjar.file.id,
    previousName,
    currentName: penjar.file.name ?? null
  }
};
            `;
        }

        if (args.operation === "rename_page") {
            if (!args.pageName) {
                throw new Error("pageName is required for rename_page operation.");
            }

            const pageName = JSON.stringify(args.pageName);
            const pageId = args.pageId ? JSON.stringify(args.pageId) : null;
            const pageLookup = pageId
                ? `penjar.file?.pages?.find((page) => page.id === ${pageId}) ?? null`
                : `penjar.currentPage ?? null`;

            return `
// file_lifecycle_operation: rename_page
const targetPage = ${pageLookup};
if (!targetPage) {
  throw new Error("Target page was not found.");
}
const previousName = targetPage.name ?? null;
targetPage.name = ${pageName};
return {
  operation: "rename_page",
  page: {
    id: targetPage.id,
    previousName,
    currentName: targetPage.name ?? null
  }
};
        `;
        }

        if (args.operation === "delete_page") {
            throw new Error(
                "delete_page is not supported by the current Penjar Plugin API runtime. " +
                    "Use backend file-management APIs for page deletion."
            );
        }

        if (!args.pageId && !args.pageName) {
            throw new Error("Either pageId or pageName is required for open_page operation.");
        }

        const pageId = args.pageId ? JSON.stringify(args.pageId) : null;
        const pageName = args.pageName ? JSON.stringify(args.pageName.toLowerCase()) : null;
        const pageLookup = pageId
            ? `penjar.file?.pages?.find((page) => page.id === ${pageId}) ?? null`
            : `penjar.file?.pages?.find((page) => (page.name ?? "").toLowerCase() === ${pageName}) ?? null`;

        return `
// file_lifecycle_operation: open_page
const targetPage = ${pageLookup};
if (!targetPage) {
  throw new Error("Target page was not found.");
}
penjar.openPage(targetPage);
return {
  operation: "open_page",
  page: {
    id: targetPage.id,
    name: targetPage.name ?? null
  },
  file: penjar.file
    ? {
        id: penjar.file.id,
        name: penjar.file.name ?? null
      }
    : null
};
        `;
    }

    protected async executeCore(args: FileLifecycleArgs): Promise<ToolResponse> {
        const taskParams: ExecuteCodeTaskParams = { code: this.buildCode(args) };
        const task = new ExecuteCodePluginTask(taskParams);
        const result = await this.mcpServer.pluginBridge.executePluginTask(task);
        return new TextResponse(JSON.stringify(result.data?.result ?? null, null, 2));
    }
}
