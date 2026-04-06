// Use --webpack flag to avoid Turbopack workspace root detection issues
// (sandbox CWD is /Users/apple which is another Next.js project)
const WORKTREE = "/Users/apple/Desktop/morroo/.claude/worktrees/nice-leakey";

try {
  process.chdir(WORKTREE);
} catch (e) {
  // chdir may fail in some sandbox environments
}

process.argv = [
  process.execPath,
  "/Users/apple/Desktop/morroo/node_modules/next/dist/bin/next",
  "dev",
  WORKTREE,
  "--webpack",
];
require("/Users/apple/Desktop/morroo/node_modules/next/dist/bin/next");
