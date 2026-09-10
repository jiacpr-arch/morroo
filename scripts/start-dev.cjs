// Use --webpack flag to avoid Turbopack workspace root detection issues
// (sandbox CWD is /Users/apple which is another Next.js project)
const path = require("node:path");

const PROJECT_ROOT = path.resolve(__dirname, "..");
const NEXT_BIN = path.join(PROJECT_ROOT, "node_modules/next/dist/bin/next");

try {
  process.chdir(PROJECT_ROOT);
} catch (e) {
  // chdir may fail in some sandbox environments
}

process.argv = [process.execPath, NEXT_BIN, "dev", PROJECT_ROOT, "--webpack"];
require(NEXT_BIN);
