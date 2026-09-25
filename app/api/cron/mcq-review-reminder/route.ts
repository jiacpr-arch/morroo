/**
 * MCQ review reminder cron — pushes "วันนี้มี N ข้อที่ถึงรอบทบทวน" to LINE-linked
 * users whose NL spaced-repetition queue (mcq_review_queue, see
 * lib/mcq-review.ts) has questions due before the end of today (Bangkok).
 *
 * Only users with an mcq_attempt in the last ACTIVE_WINDOW_DAYS are pinged —
 * long-lapsed users belong to the re-engage campaign, and LINE's monthly
 * message quota is tight (see 20260917_line_volume_cuts.sql).
 *
 * Schedule via vercel.json: "30 1 * * *" = 08:30 Asia/Bangkok.
 * Auth: Authorization: Bearer $CRON_SECRET (or ?secret=$BLOG_GENERATE_SECRET).
 *
 * Candidate selection is one RPC (mcq_review_due_counts) that joins the
 * queue, active questions, LINE-linked profiles and recent activity and
 * returns one row per user with their due count — no per-user queries.
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendLineMessage, checkLineQuota } from "@/lib/line";
import { buildMcqReviewReminderFlex } from "@/lib/line-flex-templates";
import { bangkokDayEnd } from "@/lib/mcq-review";
import { withCronRun } from "@/lib/cron-runs";

export const runtime = "nodejs";
export const maxDuration = 60;

// .trim() matters: NEXT_PUBLIC_SITE_URL carries trailing whitespace in this
// Vercel project's env config, and LINE's API rejects a Flex "uri" action
// outright on a malformed/trailing-whitespace URI.
const SITE_URL = (process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com").trim();

const ACTIVE_WINDOW_DAYS = 14;
// LINE pushes run in small parallel batches so a few hundred recipients
// still fit comfortably inside maxDuration.
const SEND_CONCURRENCY = 10;

interface DueCountRow {
  user_id: string;
  line_user_id: string;
  name: string | null;
  due_count: number | string;
}

function isAuthorized(request: Request): boolean {
  const url = new URL(request.url);
  const secret = url.searchParams.get("secret");
  if (secret && secret === process.env.BLOG_GENERATE_SECRET) return true;

  const auth = request.headers.get("authorization");
  if (
    auth &&
    process.env.CRON_SECRET &&
    auth === `Bearer ${process.env.CRON_SECRET}`
  ) {
    return true;
  }
  return false;
}

async function handleGet(request: Request) {
  if (!isAuthorized(request)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const quota = await checkLineQuota();
  if (quota.throttled) {
    return NextResponse.json({ ok: false, skipped: true, reason: "line_quota_low", remaining: quota.remaining });
  }

  const supabase = createAdminClient();
  const now = new Date();

  const { data, error } = await supabase.rpc("mcq_review_due_counts", {
    p_cutoff: bangkokDayEnd(now).toISOString(),
    p_active_since: new Date(now.getTime() - ACTIVE_WINDOW_DAYS * 86400_000).toISOString(),
  });
  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  // bigint comes back from PostgREST as a number or string depending on size.
  const candidates = ((data as DueCountRow[] | null) ?? [])
    .map((r) => ({ ...r, due_count: Number(r.due_count) }))
    .filter((r) => r.line_user_id && r.due_count > 0);

  const reviewUrl = `${SITE_URL}/nl/practice?${new URLSearchParams({
    mode: "review",
    utm_source: "line",
    utm_medium: "push",
    utm_campaign: "mcq_review_reminder",
  }).toString()}`;

  let sent = 0;
  for (let i = 0; i < candidates.length; i += SEND_CONCURRENCY) {
    const batch = candidates.slice(i, i + SEND_CONCURRENCY);
    const results = await Promise.all(
      batch.map(async (c) => {
        const flex = buildMcqReviewReminderFlex({
          name: c.name,
          dueCount: c.due_count,
          reviewUrl,
        });
        try {
          return await sendLineMessage(c.line_user_id, [flex]);
        } catch (err) {
          console.error(`[mcq-review-reminder] push failed for ${c.user_id}:`, err);
          return false;
        }
      })
    );
    sent += results.filter(Boolean).length;
  }

  return NextResponse.json({ ok: true, candidates: candidates.length, sent });
}

export const GET = withCronRun("mcq-review-reminder", handleGet, {
  authorize: isAuthorized,
});
