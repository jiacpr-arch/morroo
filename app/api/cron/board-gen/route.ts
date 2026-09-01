// Cron worker: process one board_gen_jobs row per tick.
//
// Scheduled in vercel.json every minute. Each invocation:
//   1. Lock the oldest queued row (status → 'running')
//   2. Run the agent for one specialty (≤ 60s window)
//   3. Mark done / error
//
// Why one specialty per tick? Vercel Hobby caps maxDuration at 60s. A full
// 30-question gen + critique fits comfortably under that for ONE specialty.
// Fanning out 11 specialties per single subscription = 11 minutes total —
// acceptable for an onboarding-time pipeline.

import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { runBoardGenAgent } from "@/lib/board/gen-agent";

export const runtime = "nodejs";
export const maxDuration = 60;

function isAuthorized(request: NextRequest): boolean {
  // Vercel cron sends Authorization: Bearer ${CRON_SECRET}.
  // Also allow the BLOG_GENERATE_SECRET as a manual override for admin testing.
  const auth = request.headers.get("authorization") ?? "";
  if (auth === `Bearer ${process.env.CRON_SECRET}`) return true;
  const url = new URL(request.url);
  const qsSecret = url.searchParams.get("secret");
  if (qsSecret && qsSecret === process.env.BLOG_GENERATE_SECRET) return true;
  return false;
}

async function processOne() {
  const admin = createAdminClient();

  // Stuck-row reaper: Vercel kills functions at maxDuration (60s) without
  // updating the row, leaving it forever in `running`. Reset anything
  // running > 90s back to `queued` so the next tick re-picks it. After
  // 3 attempts mark `error` permanently so we don't loop forever.
  const stuckCutoff = new Date(Date.now() - 90_000).toISOString();
  await admin
    .from("board_gen_jobs")
    .update({
      status: "error",
      error: "stuck in running > 90s for 3+ attempts (likely Vercel timeout)",
      completed_at: new Date().toISOString(),
    })
    .eq("status", "running")
    .lt("started_at", stuckCutoff)
    .gte("attempts", 3);
  await admin
    .from("board_gen_jobs")
    .update({ status: "queued", started_at: null })
    .eq("status", "running")
    .lt("started_at", stuckCutoff)
    .lt("attempts", 3);

  // Atomic-ish claim: pick oldest queued, flip to running.
  // Race condition: if two cron invocations overlap, the second will pick
  // the next row — acceptable for our throughput.
  const { data: candidate } = await admin
    .from("board_gen_jobs")
    .select("id, specialty_slug, target_count, attempts")
    .eq("status", "queued")
    .order("created_at", { ascending: true })
    .limit(1)
    .maybeSingle();

  if (!candidate) {
    return { picked: 0, skipped: 0 };
  }

  const { data: claimed } = await admin
    .from("board_gen_jobs")
    .update({
      status: "running",
      started_at: new Date().toISOString(),
      attempts: (candidate.attempts ?? 0) + 1,
    })
    .eq("id", candidate.id)
    .eq("status", "queued") // race guard
    .select("id")
    .maybeSingle();

  if (!claimed) {
    return { picked: 0, skipped: 1 };
  }

  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) {
    await admin
      .from("board_gen_jobs")
      .update({
        status: "error",
        error: "ANTHROPIC_API_KEY missing",
        completed_at: new Date().toISOString(),
      })
      .eq("id", candidate.id);
    return { picked: 1, error: "no_api_key" };
  }

  try {
    const result = await runBoardGenAgent({
      admin,
      apiKey,
      specialtySlug: candidate.specialty_slug,
      targetCount: candidate.target_count,
    });

    const success = result.errors.length === 0 || result.inserted_active + result.inserted_review > 0;

    await admin
      .from("board_gen_jobs")
      .update({
        status: success ? "done" : "error",
        generated_count: result.inserted_active,
        drafted_count: result.inserted_review,
        error: result.errors.length > 0 ? result.errors.join(" | ").slice(0, 500) : null,
        completed_at: new Date().toISOString(),
      })
      .eq("id", candidate.id);

    return { picked: 1, result };
  } catch (err) {
    await admin
      .from("board_gen_jobs")
      .update({
        status: "error",
        error: (err as Error).message.slice(0, 500),
        completed_at: new Date().toISOString(),
      })
      .eq("id", candidate.id);
    return { picked: 1, error: (err as Error).message };
  }
}

export async function GET(request: NextRequest) {
  if (!isAuthorized(request)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }
  const out = await processOne();
  return NextResponse.json({ ok: true, ...out });
}

// Allow POST too — admin trigger from the dashboard hits this with a body.
export async function POST(request: NextRequest) {
  if (!isAuthorized(request)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }
  const out = await processOne();
  return NextResponse.json({ ok: true, ...out });
}
