/**
 * Streak nudge cron — pushes a LINE reminder to users who missed today
 * but were active yesterday.
 *
 * Window logic (UTC):
 *   - User had at least one mcq_attempt 20h–48h ago
 *   - User has NO mcq_attempt in the last 20h
 * That maps to "active yesterday in Bangkok, not active today" when the
 * cron runs at 19:00 Asia/Bangkok (12:00 UTC).
 *
 * Schedule via vercel.json: "0 12 * * *".
 * Auth: Authorization: Bearer $CRON_SECRET (or ?secret=$BLOG_GENERATE_SECRET).
 *
 * Filtering is a single bulk query (all mcq_attempts in the last 48h for
 * every LINE-linked profile), bucketed in memory — not one exact-count
 * query per profile per window. The old per-profile version did 2 sequential
 * COUNT queries × every linked profile (478+ round trips at 239 profiles)
 * which was regularly enough to blow the 60s function budget on its own
 * (table itself is tiny — the cost was round-trip count, not row count).
 * RPC + LINE send still happen per candidate, but candidates are a small
 * fraction of linked profiles, so that part was never the bottleneck.
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendLineMessage, checkLineQuota } from "@/lib/line";
import { buildStreakNudgeFlex } from "@/lib/line-flex-templates";

export const runtime = "nodejs";
export const maxDuration = 60;

// .trim() matters: NEXT_PUBLIC_SITE_URL carries trailing whitespace in this
// Vercel project's env config, and LINE's API rejects a Flex "uri" action
// outright on a malformed/trailing-whitespace URI.
const SITE_URL = (process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com").trim();

export interface AttemptRow {
  user_id: string;
  created_at: string;
}

export interface ActivityBuckets {
  /** user_ids with an attempt at or after recentCutoffMs (still on track today). */
  activeRecent: Set<string>;
  /** user_ids with an attempt before recentCutoffMs but within the fetched window (active yesterday). */
  activeYesterday: Set<string>;
}

/** Pure so the bucketing is unit-testable without a Supabase mock. */
export function bucketAttemptsByRecency(attempts: AttemptRow[], recentCutoffMs: number): ActivityBuckets {
  const activeRecent = new Set<string>();
  const activeYesterday = new Set<string>();
  for (const a of attempts) {
    const target = new Date(a.created_at).getTime() >= recentCutoffMs ? activeRecent : activeYesterday;
    target.add(a.user_id);
  }
  return { activeRecent, activeYesterday };
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

export async function GET(request: Request) {
  if (!isAuthorized(request)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const quota = await checkLineQuota();
  if (quota.throttled) {
    return NextResponse.json({ ok: false, skipped: true, reason: "line_quota_low", remaining: quota.remaining });
  }

  const supabase = createAdminClient();
  const now = Date.now();
  const recentCutoff = new Date(now - 20 * 3600_000).toISOString(); // 20h ago
  const yesterdayCutoff = new Date(now - 48 * 3600_000).toISOString(); // 48h ago

  // Candidates: linked LINE users active in last 48h
  const { data: linked, error: linkedErr } = await supabase
    .from("profiles")
    .select("id, name, line_user_id")
    .not("line_user_id", "is", null);

  if (linkedErr) {
    return NextResponse.json({ error: linkedErr.message }, { status: 500 });
  }

  const profiles =
    (linked as Array<{ id: string; name: string | null; line_user_id: string }> | null) ?? [];

  const practiceUrl = `${SITE_URL}/nl/practice?${new URLSearchParams({
    utm_source: "line",
    utm_medium: "push",
    utm_campaign: "streak_nudge",
  }).toString()}`;

  let nudged = 0;
  let skipped = 0;

  if (profiles.length === 0) {
    return NextResponse.json({ candidates: 0, nudged, skipped });
  }

  // One query for every mcq_attempt in the full 48h window, bucketed in
  // memory below — replaces 2 sequential COUNT queries per profile (see
  // file header for why that timed out). Filtered by time only, not by
  // user_id IN (...): that scales with 48h activity volume rather than
  // total linked-profile count, and avoids an ever-growing IN-list as the
  // user base grows. Rows for non-linked users are simply never looked up
  // below.
  const { data: attempts, error: attemptsErr } = await supabase
    .from("mcq_attempts")
    .select("user_id, created_at")
    .gte("created_at", yesterdayCutoff);

  if (attemptsErr) {
    return NextResponse.json({ error: attemptsErr.message }, { status: 500 });
  }

  const recentCutoffMs = new Date(recentCutoff).getTime();
  const { activeRecent, activeYesterday } = bucketAttemptsByRecency(
    (attempts ?? []) as AttemptRow[],
    recentCutoffMs
  );

  for (const p of profiles) {
    // Skip if user already attempted in the last 20h (still on track today).
    if (activeRecent.has(p.id)) {
      skipped++;
      continue;
    }

    // Require activity in the 20–48h window (so we're not nudging users
    // who haven't shown up for many days — they get a different campaign).
    if (!activeYesterday.has(p.id)) {
      skipped++;
      continue;
    }

    const { data: streakData } = await supabase.rpc("get_user_streak", {
      p_user_id: p.id,
    });
    const streak = Number(streakData ?? 0);

    const flex = buildStreakNudgeFlex({ name: p.name, streak, practiceUrl });

    try {
      const ok = await sendLineMessage(p.line_user_id, [flex]);
      if (ok) nudged++;
    } catch (err) {
      console.error(`[streak-nudge] push failed for ${p.id}:`, err);
    }
  }

  return NextResponse.json({
    candidates: profiles.length,
    nudged,
    skipped,
  });
}
