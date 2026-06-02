// Admin manual trigger for board MCQ gen.
//
// Used to:
//   - Bootstrap content before any real subscriptions land
//   - Re-fill specific specialties after a deletion / quality purge
//   - Verify the pipeline end-to-end in production without a real Stripe purchase
//
// Auth: BLOG_GENERATE_SECRET (matches other admin/gen endpoints).
//
// POST /api/admin/board/gen-trigger?secret=xxx
//   body (optional):
//     { specialty_slugs?: string[], target_count?: number }
//   - omit specialty_slugs to fan-out across all active specialties under target
//   - target_count defaults to 30

import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { enqueueBoardGenJobs } from "@/lib/board/enqueue";

export const runtime = "nodejs";

export async function POST(request: NextRequest) {
  const url = new URL(request.url);
  const secret = url.searchParams.get("secret");
  if (secret !== process.env.BLOG_GENERATE_SECRET) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  let body: { specialty_slugs?: string[]; target_count?: number } = {};
  try {
    body = await request.json();
  } catch {
    /* body optional */
  }

  const admin = createAdminClient();
  const targetCount = body.target_count ?? 30;

  // Fast path: specific slugs requested — enqueue directly without scanning
  // every specialty's current count (still idempotent via unique index when no
  // stripe_session_id is set: but trigger='admin' rows skip the unique guard).
  if (body.specialty_slugs && body.specialty_slugs.length > 0) {
    const enqueued: string[] = [];
    const skipped: string[] = [];
    for (const slug of body.specialty_slugs) {
      const { count } = await admin
        .from("mcq_questions")
        .select("id", { count: "exact", head: true })
        .eq("audience", "board")
        .eq("board_specialty", slug)
        .in("status", ["active", "review"]);

      if ((count ?? 0) >= targetCount) {
        skipped.push(slug);
        continue;
      }

      const { error } = await admin.from("board_gen_jobs").insert({
        user_id: null,
        trigger: "admin",
        specialty_slug: slug,
        target_count: targetCount,
      });
      if (!error) enqueued.push(slug);
    }
    return NextResponse.json({ ok: true, enqueued, skipped_already_full: skipped });
  }

  const result = await enqueueBoardGenJobs({
    admin,
    userId: null,
    stripeSessionId: null,
    targetCount,
    trigger: "admin",
  });

  return NextResponse.json({ ok: true, ...result });
}
