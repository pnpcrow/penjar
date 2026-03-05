import { z } from "zod";
import "reflect-metadata";
import { ExecuteCodeTaskParams } from "@penjar/mcp-common";
import { PenjarMcpServer } from "../PenjarMcpServer";
import { ExecuteCodePluginTask } from "../tasks/ExecuteCodePluginTask";
import { Tool } from "../Tool";
import { TextResponse, ToolResponse } from "../ToolResponse";

export class CollaborationContextArgs {
    static schema = {
        operation: z
            .enum([
                "inspect_threads",
                "inspect_awareness",
                "create_thread",
                "reply_thread",
                "set_thread_resolved",
                "remove_thread",
            ])
            .describe("Collaboration-context operation to execute for comment-thread workflows."),
        pageId: z.string().optional().describe("Optional page ID. Defaults to current page."),
        onlyYours: z.boolean().default(false).describe("Filter for threads the current user has engaged with."),
        includeResolved: z.boolean().default(true).describe("Whether resolved threads should be included."),
        includeCurrentUser: z
            .boolean()
            .default(true)
            .describe("Whether to include current user metadata in inspect_awareness."),
        includeActiveUsers: z
            .boolean()
            .default(true)
            .describe("Whether to include active user-presence metadata in inspect_awareness."),
        threadSeqNumber: z.number().int().positive().optional().describe("Target comment-thread sequence number."),
        content: z
            .string()
            .optional()
            .describe("Thread/comment content for create_thread and reply_thread operations."),
        x: z.number().optional().describe("X coordinate for create_thread operation."),
        y: z.number().optional().describe("Y coordinate for create_thread operation."),
        resolved: z.boolean().optional().describe("Resolved flag for set_thread_resolved operation."),
    };

    operation!:
        | "inspect_threads"
        | "inspect_awareness"
        | "create_thread"
        | "reply_thread"
        | "set_thread_resolved"
        | "remove_thread";

    pageId?: string;

    onlyYours: boolean = false;

    includeResolved: boolean = true;

    includeCurrentUser: boolean = true;

    includeActiveUsers: boolean = true;

    threadSeqNumber?: number;

    content?: string;

    x?: number;

    y?: number;

    resolved?: boolean;
}

/**
 * Tool for collaboration-context operations (comment threads) in the active Penjar page context.
 */
export class CollaborationContextTool extends Tool<CollaborationContextArgs> {
    constructor(mcpServer: PenjarMcpServer) {
        super(mcpServer, CollaborationContextArgs.schema);
    }

    public getToolName(): string {
        return "collaboration_context";
    }

    public getToolDescription(): string {
        return (
            "Reads and mutates page comment-thread collaboration context. " +
            "Supported operations: inspect_threads, inspect_awareness, create_thread, " +
            "reply_thread, set_thread_resolved, remove_thread."
        );
    }

    private buildPageLookup(pageId?: string): string {
        if (pageId) {
            const encodedPageId = JSON.stringify(pageId);
            return `penjar.file?.pages?.find((page) => page.id === ${encodedPageId}) ?? null`;
        }
        return `penjar.currentPage ?? null`;
    }

    private buildCode(args: CollaborationContextArgs): string {
        const pageLookup = this.buildPageLookup(args.pageId);

        if (args.operation === "inspect_awareness") {
            const includeCurrentUser = args.includeCurrentUser ? "true" : "false";
            const includeActiveUsers = args.includeActiveUsers ? "true" : "false";
            return `
// collaboration_context_operation: inspect_awareness
const page = ${pageLookup};
if (!page) {
  throw new Error("Target page was not found.");
}
const serializeUser = (user) => {
  if (!user) {
    return null;
  }
  return {
    id: user.id ?? null,
    name: user.fullname ?? user.name ?? null,
    avatarUrl: user.avatarUrl ?? null,
    color: user.color ?? null
  };
};
const serializeActiveUser = (activeUser) => {
  const base = serializeUser(activeUser);
  if (!base) {
    return null;
  }
  return {
    ...base,
    sessionId: activeUser.sessionId ?? null,
    position: activeUser.position ?? null,
    zoom: activeUser.zoom ?? null
  };
};
const currentUser = ${includeCurrentUser} ? serializeUser(penjar.currentUser ?? null) : null;
const activeUsersRaw = Array.isArray(penjar.activeUsers) ? penjar.activeUsers : [];
const activeUsers = ${includeActiveUsers}
  ? activeUsersRaw.map((user) => serializeActiveUser(user)).filter((user) => user !== null)
  : [];
const activeUserIdSet = new Set(activeUsers.map((user) => user.id).filter((id) => id !== null));
const currentUserActive = currentUser?.id ? activeUserIdSet.has(currentUser.id) : false;
return {
  operation: "inspect_awareness",
  page: {
    id: page.id,
    name: page.name ?? null
  },
  currentUser,
  activeUsers,
  metrics: {
    includesCurrentUser: ${includeCurrentUser},
    includesActiveUsers: ${includeActiveUsers},
    activeUserCount: activeUsers.length,
    currentUserActive
  }
};
            `;
        }

        if (args.operation === "inspect_threads") {
            const onlyYours = args.onlyYours ? "true" : "false";
            const includeResolved = args.includeResolved ? "true" : "false";
            return `
// collaboration_context_operation: inspect_threads
const page = ${pageLookup};
if (!page) {
  throw new Error("Target page was not found.");
}
const criteria = { onlyYours: ${onlyYours}, showResolved: ${includeResolved} };
const threads = await page.findCommentThreads(criteria);
const serializedThreads = [];
for (const thread of threads) {
  const comments = await thread.findComments();
  const lastComment = comments.length > 0 ? comments[comments.length - 1] : null;
  serializedThreads.push({
    seqNumber: thread.seqNumber,
    resolved: thread.resolved,
    position: thread.position ?? null,
    owner: thread.owner
      ? {
          id: thread.owner.id ?? null,
          name: thread.owner.fullname ?? thread.owner.name ?? null
        }
      : null,
    commentCount: comments.length,
    lastComment: lastComment
      ? {
          content: lastComment.content ?? null
        }
      : null
  });
}
return {
  operation: "inspect_threads",
  page: {
    id: page.id,
    name: page.name ?? null
  },
  filters: {
    onlyYours: criteria.onlyYours,
    includeResolved: criteria.showResolved
  },
  threadCount: serializedThreads.length,
  threads: serializedThreads
};
            `;
        }

        if (args.operation === "create_thread") {
            if (!args.content) {
                throw new Error("content is required for create_thread operation.");
            }
            if (args.x === undefined || args.y === undefined) {
                throw new Error("x and y are required for create_thread operation.");
            }
            const content = JSON.stringify(args.content);
            return `
// collaboration_context_operation: create_thread
const page = ${pageLookup};
if (!page) {
  throw new Error("Target page was not found.");
}
const thread = await page.addCommentThread(${content}, { x: ${args.x}, y: ${args.y} });
const comments = await thread.findComments();
return {
  operation: "create_thread",
  page: {
    id: page.id,
    name: page.name ?? null
  },
  thread: {
    seqNumber: thread.seqNumber,
    resolved: thread.resolved,
    position: thread.position ?? null,
    commentCount: comments.length
  }
};
            `;
        }

        if (args.operation === "reply_thread") {
            if (args.threadSeqNumber === undefined) {
                throw new Error("threadSeqNumber is required for reply_thread operation.");
            }
            if (!args.content) {
                throw new Error("content is required for reply_thread operation.");
            }
            const content = JSON.stringify(args.content);
            return `
// collaboration_context_operation: reply_thread
const page = ${pageLookup};
if (!page) {
  throw new Error("Target page was not found.");
}
const threads = await page.findCommentThreads({ onlyYours: false, showResolved: true });
const thread = threads.find((item) => item.seqNumber === ${args.threadSeqNumber}) ?? null;
if (!thread) {
  throw new Error("Comment thread was not found.");
}
const comment = await thread.reply(${content});
const comments = await thread.findComments();
return {
  operation: "reply_thread",
  page: {
    id: page.id,
    name: page.name ?? null
  },
  thread: {
    seqNumber: thread.seqNumber,
    resolved: thread.resolved,
    commentCount: comments.length
  },
  comment: {
    content: comment.content ?? null
  }
};
            `;
        }

        if (args.operation === "set_thread_resolved") {
            if (args.threadSeqNumber === undefined) {
                throw new Error("threadSeqNumber is required for set_thread_resolved operation.");
            }
            if (args.resolved === undefined) {
                throw new Error("resolved is required for set_thread_resolved operation.");
            }
            const resolved = args.resolved ? "true" : "false";
            return `
// collaboration_context_operation: set_thread_resolved
const page = ${pageLookup};
if (!page) {
  throw new Error("Target page was not found.");
}
const threads = await page.findCommentThreads({ onlyYours: false, showResolved: true });
const thread = threads.find((item) => item.seqNumber === ${args.threadSeqNumber}) ?? null;
if (!thread) {
  throw new Error("Comment thread was not found.");
}
const previousResolved = thread.resolved;
thread.resolved = ${resolved};
return {
  operation: "set_thread_resolved",
  page: {
    id: page.id,
    name: page.name ?? null
  },
  thread: {
    seqNumber: thread.seqNumber,
    previousResolved,
    currentResolved: thread.resolved
  }
};
            `;
        }

        if (args.threadSeqNumber === undefined) {
            throw new Error("threadSeqNumber is required for remove_thread operation.");
        }

        return `
// collaboration_context_operation: remove_thread
const page = ${pageLookup};
if (!page) {
  throw new Error("Target page was not found.");
}
const threads = await page.findCommentThreads({ onlyYours: false, showResolved: true });
const thread = threads.find((item) => item.seqNumber === ${args.threadSeqNumber}) ?? null;
if (!thread) {
  throw new Error("Comment thread was not found.");
}
thread.remove();
return {
  operation: "remove_thread",
  page: {
    id: page.id,
    name: page.name ?? null
  },
  removed: {
    seqNumber: ${args.threadSeqNumber}
  }
};
        `;
    }

    protected async executeCore(args: CollaborationContextArgs): Promise<ToolResponse> {
        const taskParams: ExecuteCodeTaskParams = { code: this.buildCode(args) };
        const task = new ExecuteCodePluginTask(taskParams);
        const result = await this.mcpServer.pluginBridge.executePluginTask(task);
        return new TextResponse(JSON.stringify(result.data?.result ?? null, null, 2));
    }
}
