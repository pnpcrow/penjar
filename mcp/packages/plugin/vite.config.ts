import { defineConfig } from "vite";
import livePreview from "vite-live-preview";

let WS_URI = process.env.WS_URI || "http://localhost:4402";
let MULTI_USER_MODE = process.env.MULTI_USER_MODE === "true";
const PLUGIN_PORT = parseInt(process.env.PENPOT_MCP_PLUGIN_PORT || "4400", 10);

console.log("Will define IS_MULTI_USER_MODE as:", JSON.stringify(MULTI_USER_MODE));
console.log("Will define PENPOT_MCP_WEBSOCKET_URL as:", JSON.stringify(WS_URI));
console.log("Will expose plugin preview on port:", PLUGIN_PORT);

export default defineConfig({
    base: "./",
    plugins: [
        livePreview({
            reload: true,
            config: {
                build: {
                    sourcemap: true,
                },
            },
        }),
    ],
    build: {
        rollupOptions: {
            input: {
                plugin: "src/plugin.ts",
                index: "./index.html",
            },
            output: {
                entryFileNames: "[name].js",
            },
        },
    },
    preview: {
        host: "0.0.0.0",
        port: PLUGIN_PORT,
        cors: true,
        allowedHosts: [],
    },
    define: {
        IS_MULTI_USER_MODE: JSON.stringify(process.env.MULTI_USER_MODE === "true"),
        PENPOT_MCP_WEBSOCKET_URL: JSON.stringify(WS_URI),
    },
});
