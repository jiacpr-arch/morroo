/**
 * Starts the content-generator GitHub workflows (MCQ, board, blog, MEQ, long
 * case, ...) on schedule.
 *
 * GitHub's own `schedule:` triggers stopped firing for this repo in Aug 2026
 * while manual runs kept working, so Vercel cron (reliable here) calls this
 * route at each slot in lib/generator-schedule.ts and it fires a
 * workflow_dispatch for every workflow due now. The generators still run on
 * GitHub Actions; only the trigger moved.
 *
 * Env: GITHUB_DISPATCH_TOKEN — fine-grained PAT, this repo only,
 * "Actions: Read and write". GITHUB_DISPATCH_REPO overrides the target
 * ("jiacpr-arch/morroo").
 *
 * Auth: ?secret=<BLOG_GENERATE_SECRET> or Authorization: Bearer <CRON_SECRET>.
 * ?workflow=<file> dispatches one workflow now (manual catch-up).
 */

import { NextResponse } from "next/server";
import { withCronRun } from "@/lib/cron-runs";
import { GENERATOR_SLOTS, dueWorkflows } from "@/lib/generator-schedule";

export const runtime = "nodejs";
export const maxDuration = 60;

const DEFAULT_REPO = "jiacpr-arch/morroo";

function isAuthorized(request: Request): boolean {
  const url = new URL(request.url);
  const secret = url.searchParams.get("secret");
  if (secret && secret === process.env.BLOG_GENERATE_SECRET) return true;

  const auth = request.headers.get("authorization");
  return !!(
    auth &&
    process.env.CRON_SECRET &&
    auth === `Bearer ${process.env.CRON_SECRET}`
  );
}

async function dispatch(repo: string, token: string, workflow: string): Promise<string | null> {
  const res = await fetch(
    `https://api.github.com/repos/${repo}/actions/workflows/${workflow}/dispatches`,
    {
      method: "POST",
      headers: {
        Accept: "application/vnd.github+json",
        Authorization: `Bearer ${token}`,
        "X-GitHub-Api-Version": "2022-11-28",
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ ref: "main" }),
      signal: AbortSignal.timeout(15_000),
    }
  );
  if (res.status === 204) return null;
  const body = await res.text().catch(() => "");
  return `${workflow}: HTTP ${res.status} ${body.slice(0, 200)}`;
}

async function handleGet(request: Request): Promise<Response> {
  const url = new URL(request.url);
  const only = url.searchParams.get("workflow");
  const known = new Set(GENERATOR_SLOTS.map((s) => s.workflow));
  if (only && !known.has(only)) {
    return NextResponse.json({ error: `Unknown workflow "${only}"` }, { status: 400 });
  }

  const now = new Date();
  const due = only ? [only] : dueWorkflows(now);
  if (due.length === 0) {
    return NextResponse.json({ ok: true, at: now.toISOString(), dispatched: [] });
  }

  const token = process.env.GITHUB_DISPATCH_TOKEN;
  if (!token) {
    return NextResponse.json(
      { error: "GITHUB_DISPATCH_TOKEN is not set", due },
      { status: 500 }
    );
  }
  const repo = process.env.GITHUB_DISPATCH_REPO || DEFAULT_REPO;

  const results = await Promise.all(
    due.map((w) => dispatch(repo, token, w).catch((err) => `${w}: ${String(err)}`))
  );
  const failed = results.filter((r): r is string => r !== null);
  const dispatched = due.filter((_, i) => results[i] === null);

  return NextResponse.json(
    failed.length
      ? { error: failed.join("; "), dispatched, failed }
      : { ok: true, at: now.toISOString(), dispatched },
    { status: failed.length ? 502 : 200 }
  );
}

export const GET = withCronRun("dispatch-generators", handleGet, { authorize: isAuthorized });
