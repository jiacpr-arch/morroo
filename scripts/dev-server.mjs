// Wrapper: sets CWD to the worktree before starting Next.js dev server
// Needed because the preview tool may start with an invalid CWD
import { chdir } from "node:process";
import { createRequire } from "node:module";

chdir("/Users/apple/Desktop/morroo/.claude/worktrees/nice-leakey");
const require = createRequire(import.meta.url);
require("/Users/apple/Desktop/morroo/node_modules/next/dist/bin/next");
