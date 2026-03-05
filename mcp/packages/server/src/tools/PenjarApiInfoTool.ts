import { z } from "zod";
import { Tool } from "../Tool";
import "reflect-metadata";
import type { ToolResponse } from "../ToolResponse";
import { TextResponse } from "../ToolResponse";
import { PenjarMcpServer } from "../PenjarMcpServer";
import { ApiDocs } from "../ApiDocs";

/**
 * Arguments class for the PenjarApiInfoTool
 */
export class PenjarApiInfoArgs {
    static schema = {
        type: z.string().min(1, "Type name cannot be empty"),
        member: z.string().optional(),
    };

    /**
     * The API type name to retrieve information for.
     */
    type!: string;

    /**
     * The specific member name to retrieve (optional).
     */
    member?: string;
}

/**
 * Tool for retrieving Penjar API documentation information.
 *
 * This tool provides access to API type documentation loaded from YAML files,
 * allowing retrieval of either full type documentation or specific member details.
 */
export class PenjarApiInfoTool extends Tool<PenjarApiInfoArgs> {
    private static readonly MAX_FULL_TEXT_CHARS = 2000;
    private readonly apiDocs: ApiDocs;

    /**
     * Creates a new PenjarApiInfo tool instance.
     *
     * @param mcpServer - The MCP server instance
     */
    constructor(mcpServer: PenjarMcpServer, apiDocs: ApiDocs) {
        super(mcpServer, PenjarApiInfoArgs.schema);
        this.apiDocs = apiDocs;
    }

    public getToolName(): string {
        return "penjar_api_info";
    }

    public getToolDescription(): string {
        return (
            "Retrieves Penjar API documentation for types and their members." +
            "Be sure to read the 'Penjar High-Level Overview' first."
        );
    }

    protected async executeCore(args: PenjarApiInfoArgs): Promise<ToolResponse> {
        const apiType = this.apiDocs.getType(args.type);

        if (!apiType) {
            throw new Error(`API type "${args.type}" not found`);
        }

        if (args.member) {
            // return specific member documentation
            const memberDoc = apiType.getMember(args.member);
            if (!memberDoc) {
                throw new Error(`Member "${args.member}" not found in type "${args.type}"`);
            }
            return new TextResponse(memberDoc);
        } else {
            // return full text or overview based on length
            const fullText = apiType.getFullText();
            if (fullText.length <= PenjarApiInfoTool.MAX_FULL_TEXT_CHARS) {
                return new TextResponse(fullText);
            } else {
                return new TextResponse(
                    apiType.getOverviewText() +
                        "\n\nMember details not provided (too long). " +
                        "Call this tool with a member name for more information."
                );
            }
        }
    }
}
