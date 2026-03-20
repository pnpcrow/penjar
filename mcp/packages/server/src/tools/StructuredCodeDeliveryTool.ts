import { z } from "zod";
import "reflect-metadata";
import { ExecuteCodeTaskParams } from "@penjar/mcp-common";
import { PenjarMcpServer } from "../PenjarMcpServer";
import { ExecuteCodePluginTask } from "../tasks/ExecuteCodePluginTask";
import { Tool } from "../Tool";
import { TextResponse, ToolResponse } from "../ToolResponse";

export class StructuredCodeDeliveryArgs {
    static schema = {
        format: z
            .enum(["flutter", "react", "html", "swiftui", "ir"])
            .default("ir")
            .describe(
                "Output format: 'ir' for raw intermediate representation, " +
                    "or a target framework for code generation."
            ),
        scope: z
            .enum(["selection", "page", "component"])
            .default("selection")
            .describe("Extraction scope: current selection, page root, or auto-detected component."),
        maxDepth: z
            .number()
            .int()
            .min(1)
            .max(12)
            .default(6)
            .describe("Maximum traversal depth for the component tree."),
        includeTokens: z
            .boolean()
            .default(true)
            .describe("Include design token mappings (colors, typography, spacing)."),
        includeLayout: z
            .boolean()
            .default(true)
            .describe("Include layout semantics (flex, grid, constraints)."),
        includeVariants: z
            .boolean()
            .default(false)
            .describe("Include component variant metadata if detected."),
        promptScaffold: z
            .boolean()
            .default(false)
            .describe("Wrap output in an LLM prompt scaffold for code synthesis."),
    };

    format: "flutter" | "react" | "html" | "swiftui" | "ir" = "ir";
    scope: "selection" | "page" | "component" = "selection";
    maxDepth: number = 6;
    includeTokens: boolean = true;
    includeLayout: boolean = true;
    includeVariants: boolean = false;
    promptScaffold: boolean = false;
}

/**
 * Phase E: LLM-ready structured code delivery.
 *
 * Extracts a canonical intermediate representation (IR) from the active
 * design, suitable for direct consumption by LLM code-generation agents.
 *
 * The IR includes:
 * - Component hierarchy with semantic labels
 * - Layout semantics (flex/grid/absolute positioning)
 * - Design token mappings (colors, typography, spacing, radii)
 * - Component variant metadata
 * - CSS/style information
 *
 * Output can be:
 * - Raw IR (JSON) for custom processing
 * - Framework-specific code scaffolds (Flutter, React, HTML, SwiftUI)
 * - LLM prompt scaffolds wrapping the IR for code synthesis
 */
export class StructuredCodeDeliveryTool extends Tool<StructuredCodeDeliveryArgs> {
    constructor(mcpServer: PenjarMcpServer) {
        super(mcpServer, StructuredCodeDeliveryArgs.schema);
    }

    public getToolName(): string {
        return "structured_code_delivery";
    }

    public getToolDescription(): string {
        return (
            "Extracts a structured intermediate representation (IR) from the active design " +
            "for LLM-ready code generation. Includes component hierarchy, layout semantics, " +
            "design tokens, and optional framework-specific code scaffolds."
        );
    }

    private buildExtractionCode(args: StructuredCodeDeliveryArgs): string {
        const scope = JSON.stringify(args.scope);
        const maxDepth = args.maxDepth;
        const includeTokens = args.includeTokens;
        const includeLayout = args.includeLayout;
        const includeVariants = args.includeVariants;

        return `
// structured_code_delivery: extract IR
const scope = ${scope};
const maxDepth = ${maxDepth};

// Resolve target shapes
const selectionTargets = Array.isArray(penjar.selection) ? penjar.selection : [];
const pageRoot = penjar.root ? [penjar.root] : [];

let targets;
if (scope === "selection") {
    targets = selectionTargets.length > 0 ? selectionTargets : pageRoot;
} else if (scope === "component") {
    // Auto-detect: if selection is inside a component, use the component root
    targets = selectionTargets.length > 0 ? selectionTargets : pageRoot;
    if (targets.length > 0 && targets[0].component) {
        targets = [targets[0].component];
    }
} else {
    targets = pageRoot;
}

// Build component tree with semantic labels
function buildNode(shape, depth) {
    if (depth <= 0 || !shape) return null;

    const node = {
        id: shape.id,
        name: shape.name || "unnamed",
        type: shape.type || "unknown",
        semanticRole: inferSemanticRole(shape),
    };

    // Geometry
    if (shape.x !== undefined) {
        node.bounds = {
            x: Math.round(shape.x * 100) / 100,
            y: Math.round(shape.y * 100) / 100,
            width: Math.round((shape.width || 0) * 100) / 100,
            height: Math.round((shape.height || 0) * 100) / 100,
        };
    }

    // Layout semantics
    ${includeLayout ? `
    if (shape.layoutAlign || shape.layoutWrap || shape.layoutDirection) {
        node.layout = {};
        if (shape.layoutDirection) node.layout.direction = shape.layoutDirection;
        if (shape.layoutAlign) node.layout.align = shape.layoutAlign;
        if (shape.layoutWrap) node.layout.wrap = shape.layoutWrap;
        if (shape.layoutGap) node.layout.gap = shape.layoutGap;
        if (shape.layoutPadding) node.layout.padding = shape.layoutPadding;
    }
    ` : ""}

    // Design tokens
    ${includeTokens ? `
    node.tokens = {};

    // Fill/color tokens
    if (shape.fills && shape.fills.length > 0) {
        node.tokens.fills = shape.fills.map(f => ({
            type: f.fillType || "solid",
            color: f.fillColor || f.color,
            opacity: f.fillOpacity !== undefined ? f.fillOpacity : 1,
        }));
    }

    // Typography tokens
    if (shape.fontFamily || shape.fontSize) {
        node.tokens.typography = {
            fontFamily: shape.fontFamily,
            fontSize: shape.fontSize,
            fontWeight: shape.fontWeight,
            lineHeight: shape.lineHeight,
            letterSpacing: shape.letterSpacing,
            textAlign: shape.textAlign,
        };
    }

    // Spacing tokens
    if (shape.rx || shape.ry) {
        node.tokens.borderRadius = {
            rx: shape.rx || 0,
            ry: shape.ry || 0,
        };
    }

    // Border/stroke tokens
    if (shape.strokes && shape.strokes.length > 0) {
        node.tokens.strokes = shape.strokes.map(s => ({
            color: s.strokeColor || s.color,
            width: s.strokeWidth || 1,
            type: s.strokeType || "solid",
        }));
    }

    // Remove empty tokens
    if (Object.keys(node.tokens).length === 0) delete node.tokens;
    ` : ""}

    // Variant metadata
    ${includeVariants ? `
    if (shape.componentId || shape.componentFile) {
        node.component = {
            id: shape.componentId,
            file: shape.componentFile,
            mainInstance: shape.mainInstance || false,
        };
    }
    ` : ""}

    // Text content
    if (shape.type === "text" && shape.content) {
        node.textContent = typeof shape.content === "string"
            ? shape.content.substring(0, 500)
            : String(shape.content).substring(0, 500);
    }

    // Children
    const children = shape.children || [];
    if (children.length > 0 && depth > 1) {
        node.children = children
            .map(child => buildNode(child, depth - 1))
            .filter(Boolean);
    }

    return node;
}

function inferSemanticRole(shape) {
    const name = (shape.name || "").toLowerCase();
    const type = (shape.type || "").toLowerCase();

    if (type === "text") return "text";
    if (type === "image" || type === "svg") return "image";
    if (name.includes("button") || name.includes("btn")) return "button";
    if (name.includes("input") || name.includes("field")) return "input";
    if (name.includes("card")) return "card";
    if (name.includes("header") || name.includes("nav")) return "header";
    if (name.includes("footer")) return "footer";
    if (name.includes("list") || name.includes("grid")) return "container";
    if (name.includes("icon")) return "icon";
    if (name.includes("avatar")) return "avatar";
    if (name.includes("badge") || name.includes("chip")) return "badge";
    if (name.includes("modal") || name.includes("dialog")) return "dialog";
    if (children && children.length > 0) return "container";
    return "element";
}

// Build the IR tree
const componentTree = targets.map(t => buildNode(t, maxDepth));

// Generate CSS for style reference
const cssOutput = targets.length > 0
    ? penjar.generateStyle(targets, { type: "css", includeChildren: true })
    : null;

// File/page context
const fileContext = {
    fileName: penjar.currentFile ? penjar.currentFile.name : null,
    pageName: penjar.currentPage ? penjar.currentPage.name : null,
};

return {
    operation: "structured_code_delivery",
    version: "1.0.0",
    scope,
    fileContext,
    componentTree,
    css: cssOutput,
    metadata: {
        targetCount: targets.length,
        maxDepth,
        includeTokens: ${includeTokens},
        includeLayout: ${includeLayout},
        includeVariants: ${includeVariants},
        extractedAt: new Date().toISOString(),
    },
};
        `;
    }

    protected async executeCore(args: StructuredCodeDeliveryArgs): Promise<ToolResponse> {
        const taskParams: ExecuteCodeTaskParams = {
            code: this.buildExtractionCode(args),
        };
        const task = new ExecuteCodePluginTask(taskParams);
        const result = await this.mcpServer.pluginBridge.executePluginTask(task);

        const irData = result.data?.result ?? null;

        if (args.format === "ir" && !args.promptScaffold) {
            return new TextResponse(JSON.stringify(irData, null, 2));
        }

        // Transform IR to framework-specific output or wrap in prompt scaffold
        const output = this.transformOutput(irData, args);
        return new TextResponse(output);
    }

    private transformOutput(irData: any, args: StructuredCodeDeliveryArgs): string {
        if (args.promptScaffold) {
            return this.buildPromptScaffold(irData, args.format);
        }

        switch (args.format) {
            case "flutter":
                return this.toFlutterScaffold(irData);
            case "react":
                return this.toReactScaffold(irData);
            case "html":
                return this.toHtmlScaffold(irData);
            case "swiftui":
                return this.toSwiftUIScaffold(irData);
            default:
                return JSON.stringify(irData, null, 2);
        }
    }

    private buildPromptScaffold(irData: any, format: string): string {
        const frameworkLabel = format === "ir" ? "the appropriate framework" : format;
        const irJson = JSON.stringify(irData, null, 2);

        return `You are a UI code generator. Given the following design intermediate representation (IR),
generate production-ready ${frameworkLabel} code.

## Design IR

\`\`\`json
${irJson}
\`\`\`

## Instructions

1. Translate the component tree into ${frameworkLabel} components/widgets.
2. Apply the design tokens (colors, typography, spacing, border radii) from the IR.
3. Implement the layout semantics (flex direction, alignment, gaps, padding).
4. Use semantic names from the IR for component/variable naming.
5. Include the CSS reference for style validation.

## Requirements

- Output clean, well-structured code ready for integration.
- Preserve the component hierarchy from the IR.
- Map design tokens to framework-appropriate constants/theme values.
- Handle text content faithfully.
- Add appropriate accessibility attributes.

Generate the code now:`;
    }

    private toFlutterScaffold(irData: any): string {
        if (!irData?.componentTree?.length) {
            return "// No components found in the design selection.";
        }

        const lines: string[] = [
            "import 'package:flutter/material.dart';",
            "",
        ];

        for (const node of irData.componentTree) {
            lines.push(...this.irNodeToFlutter(node, 0));
        }

        return lines.join("\n");
    }

    private irNodeToFlutter(node: any, indent: number): string[] {
        if (!node) return [];
        const pad = "  ".repeat(indent);
        const lines: string[] = [];
        const name = this.toPascalCase(node.name || "Component");

        if (indent === 0) {
            lines.push(`class ${name} extends StatelessWidget {`);
            lines.push(`  const ${name}({super.key});`);
            lines.push("");
            lines.push("  @override");
            lines.push("  Widget build(BuildContext context) {");
            lines.push(`    return ${this.flutterWidgetForNode(node, 4)};`);
            lines.push("  }");
            lines.push("}");
            lines.push("");
        }

        return lines;
    }

    private flutterWidgetForNode(node: any, indent: number): string {
        const pad = "  ".repeat(indent);
        const role = node.semanticRole || "element";
        const bounds = node.bounds || {};
        const tokens = node.tokens || {};
        const children = node.children || [];

        if (role === "text" && node.textContent) {
            const style = tokens.typography
                ? `style: TextStyle(fontSize: ${tokens.typography.fontSize ?? 14})`
                : "";
            return `Text('${this.escapeString(node.textContent)}'${style ? ", " + style : ""})`;
        }

        if (children.length === 0) {
            return `Container(\n${pad}  width: ${bounds.width || 100},\n${pad}  height: ${bounds.height || 100},\n${pad}  ${this.flutterDecoration(tokens)}\n${pad})`;
        }

        const layout = node.layout || {};
        const isRow = layout.direction === "row";
        const childWidgets = children
            .map((c: any) => `${pad}    ${this.flutterWidgetForNode(c, indent + 2)},`)
            .join("\n");

        const wrapper = isRow ? "Row" : "Column";
        return `${wrapper}(\n${pad}  children: <Widget>[\n${childWidgets}\n${pad}  ],\n${pad})`;
    }

    private flutterDecoration(tokens: any): string {
        const parts: string[] = [];
        if (tokens.fills?.length > 0) {
            const fill = tokens.fills[0];
            if (fill.color) {
                parts.push(`color: Color(0xFF${fill.color.replace("#", "")})`);
            }
        }
        if (tokens.borderRadius) {
            parts.push(
                `borderRadius: BorderRadius.circular(${tokens.borderRadius.rx || 0})`
            );
        }
        if (parts.length === 0) return "";
        return `decoration: BoxDecoration(${parts.join(", ")}),`;
    }

    private toReactScaffold(irData: any): string {
        if (!irData?.componentTree?.length) {
            return "// No components found in the design selection.";
        }

        const lines: string[] = ["import React from 'react';", ""];

        for (const node of irData.componentTree) {
            const name = this.toPascalCase(node.name || "Component");
            lines.push(`export function ${name}() {`);
            lines.push(`  return (`);
            lines.push(this.irNodeToJsx(node, 4));
            lines.push(`  );`);
            lines.push(`}`);
            lines.push("");
        }

        return lines.join("\n");
    }

    private irNodeToJsx(node: any, indent: number): string {
        const pad = "  ".repeat(indent);
        const role = node.semanticRole || "element";
        const tokens = node.tokens || {};
        const children = node.children || [];

        const style = this.tokensToReactStyle(tokens, node.bounds);

        if (role === "text" && node.textContent) {
            return `${pad}<span style={${style}}>${this.escapeString(node.textContent)}</span>`;
        }

        const tag = role === "button" ? "button" : role === "image" ? "img" : "div";
        if (children.length === 0) {
            return `${pad}<${tag} style={${style}} />`;
        }

        const childJsx = children
            .map((c: any) => this.irNodeToJsx(c, indent + 1))
            .join("\n");
        return `${pad}<${tag} style={${style}}>\n${childJsx}\n${pad}</${tag}>`;
    }

    private tokensToReactStyle(tokens: any, bounds: any): string {
        const style: Record<string, any> = {};
        if (bounds) {
            if (bounds.width) style.width = bounds.width;
            if (bounds.height) style.height = bounds.height;
        }
        if (tokens.fills?.length > 0) {
            style.backgroundColor = tokens.fills[0].color || "transparent";
        }
        if (tokens.borderRadius) {
            style.borderRadius = tokens.borderRadius.rx || 0;
        }
        if (tokens.typography) {
            if (tokens.typography.fontSize) style.fontSize = tokens.typography.fontSize;
            if (tokens.typography.fontFamily) style.fontFamily = tokens.typography.fontFamily;
        }
        return JSON.stringify(style);
    }

    private toHtmlScaffold(irData: any): string {
        if (!irData?.componentTree?.length) {
            return "<!-- No components found in the design selection. -->";
        }

        const lines: string[] = [];
        if (irData.css) {
            lines.push("<style>");
            lines.push(irData.css);
            lines.push("</style>");
            lines.push("");
        }

        for (const node of irData.componentTree) {
            lines.push(this.irNodeToHtml(node, 0));
        }

        return lines.join("\n");
    }

    private irNodeToHtml(node: any, indent: number): string {
        const pad = "  ".repeat(indent);
        const role = node.semanticRole || "element";
        const children = node.children || [];

        const tag = role === "button"
            ? "button"
            : role === "text"
            ? "span"
            : role === "image"
            ? "img"
            : role === "header"
            ? "header"
            : role === "footer"
            ? "footer"
            : "div";

        const className = this.toKebabCase(node.name || "element");

        if (role === "text" && node.textContent) {
            return `${pad}<${tag} class="${className}">${this.escapeString(node.textContent)}</${tag}>`;
        }

        if (children.length === 0) {
            return tag === "img"
                ? `${pad}<${tag} class="${className}" alt="${node.name || ""}" />`
                : `${pad}<${tag} class="${className}"></${tag}>`;
        }

        const childHtml = children
            .map((c: any) => this.irNodeToHtml(c, indent + 1))
            .join("\n");
        return `${pad}<${tag} class="${className}">\n${childHtml}\n${pad}</${tag}>`;
    }

    private toSwiftUIScaffold(irData: any): string {
        if (!irData?.componentTree?.length) {
            return "// No components found in the design selection.";
        }

        const lines: string[] = ["import SwiftUI", ""];

        for (const node of irData.componentTree) {
            const name = this.toPascalCase(node.name || "Component");
            lines.push(`struct ${name}: View {`);
            lines.push(`    var body: some View {`);
            lines.push(this.irNodeToSwiftUI(node, 8));
            lines.push(`    }`);
            lines.push(`}`);
            lines.push("");
        }

        return lines.join("\n");
    }

    private irNodeToSwiftUI(node: any, indent: number): string {
        const pad = " ".repeat(indent);
        const role = node.semanticRole || "element";
        const tokens = node.tokens || {};
        const children = node.children || [];
        const bounds = node.bounds || {};

        if (role === "text" && node.textContent) {
            let text = `${pad}Text("${this.escapeString(node.textContent)}")`;
            if (tokens.typography?.fontSize) {
                text += `\n${pad}    .font(.system(size: ${tokens.typography.fontSize}))`;
            }
            return text;
        }

        if (children.length === 0) {
            let rect = `${pad}Rectangle()`;
            if (bounds.width) rect += `\n${pad}    .frame(width: ${bounds.width}, height: ${bounds.height || bounds.width})`;
            if (tokens.fills?.length > 0 && tokens.fills[0].color) {
                rect += `\n${pad}    .foregroundColor(Color(hex: "${tokens.fills[0].color}"))`;
            }
            if (tokens.borderRadius?.rx) {
                rect += `\n${pad}    .cornerRadius(${tokens.borderRadius.rx})`;
            }
            return rect;
        }

        const layout = node.layout || {};
        const wrapper = layout.direction === "row" ? "HStack" : "VStack";
        const childViews = children
            .map((c: any) => this.irNodeToSwiftUI(c, indent + 4))
            .join("\n");
        return `${pad}${wrapper} {\n${childViews}\n${pad}}`;
    }

    private toPascalCase(str: string): string {
        return str
            .replace(/[^a-zA-Z0-9]+/g, " ")
            .split(" ")
            .filter(Boolean)
            .map((w) => w.charAt(0).toUpperCase() + w.slice(1).toLowerCase())
            .join("");
    }

    private toKebabCase(str: string): string {
        return str
            .replace(/[^a-zA-Z0-9]+/g, "-")
            .replace(/([a-z])([A-Z])/g, "$1-$2")
            .toLowerCase()
            .replace(/^-|-$/g, "");
    }

    private escapeString(str: string): string {
        return str.replace(/'/g, "\\'").replace(/"/g, '\\"').replace(/\n/g, "\\n");
    }
}
