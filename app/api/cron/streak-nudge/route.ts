/**
 * Streak nudge cron — reminds users who missed today but were active
 * yesterday, over LINE or (fallback) Web Push.
 *
 * Window logic (UTC):
 *   - User had at least one mcq_attempt 20h–48h ago
 *   - User has NO mcq_attempt in the last 20h
 * That maps to "active yesterday in Bangkok, not active today" when the
 * cron runs at 19:00 Asia/Bangkok (12:00 UTC).
 *
 * Channel (one per user, never both — see pickNudgeChannel):
 *   - LINE-linked users get the LINE Flex card, as before.
 *   - Users without a LINE link (or when the LINE monthly quota is nearly
 *     spent) get a Web Push to every device they opted in on the profile
 *     page. Push is a no-op when VAPID env vars are unset (lib/push.ts).
 *
 * Schedule via vercel.json: "0 12 * * *".
 * Auth: Authorization: Bearer $CRON_SECRET (or ?secret=$BLOG_GENERATE_SECRET).
 *
 * Filtering is a single bulk query (all mcq_attempts in the last 48h),
 * bucketed in memory — not one exact-count query per profile per window. The
 * old per-profile version did 2 sequential COUNT queries × every linked
 * profile (478+ round trips at 239 profiles) which was regularly enough to
 * blow the 60s function budget on its own (table itself is tiny — the cost
 * was round-trip count, not row count). RPC + send still happen per
 * candidate, but candidates are a small fraction of users, so that part was
 * never the bottleneck.
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendLineMessage, checkLineQuota } from "@/lib/line";
import { buildStreakNudgeFlex } from "@/lib/line-flex-templates";
import { withCronRun } from "@/lib/cron-runs";
import {
  isPushConfigured,
  sendPushToSubscriptions,
  type PushPayload,
  type PushSubscriptionRow,
} from "@/lib/push";

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

/**
 * One channel per user so nobody is nudged twice: LINE wins when the user is
 * linked and LINE quota allows; otherwise Web Push if they have a device
 * subscribed; otherwise nothing.
 */
export function pickNudgeChannel(opts: {
  hasLine: boolean;
  lineAvailable: boolean;
  hasPush: boolean;
}): "line" | "push" | null {
  if (opts.hasLine && opts.lineAvailable) return "line";
  if (opts.hasPush) return "push";
  return null;
}

/** Web Push version of buildStreakNudgeFlex — same tone, much shorter. */
export function buildStreakNudgePush(streak: number): PushPayload {
  const urgent = streak >= 3;
  return {
    title: urgent
      ? `🔥 สตรีค ${streak} วันติด — อย่าให้ขาดวันนี้!`
      : "⏰ วันนี้ยังไม่ได้ทำข้อสอบเลย",
    body: "ทำข้อสอบ 5 ข้อ ใช้เวลาแค่ 5 นาที 👍",
    // Relative: the service worker resolves it against its own origin.
    url: `/nl/practice?${new URLSearchParams({
      utm_source: "webpush",
      utm_medium: "push",
      utm_campaign: "streak_nudge",
    }).toString()}`,
    tag: "streak-nudge",
  };
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
  const lineAvailable = !quota.throttled;
  const pushOn = isPushConfigured();
  if (!lineAvailable && !pushOn) {
    return NextResponse.json({ ok: false, skipped: true, reason: "line_quota_low", remaining: quota.remaining });
  }

  const supabase = createAdminClient();
  const now = Date.now();
  const recentCutoff = new Date(now - 20 * 3600_000).toISOString(); // 20h ago
  const yesterdayCutoff = new Date(now - 48 * 3600_000).toISOString(); // 48h ago

  // LINE-linked profiles (needed even when LINE is throttled, to know who
  // is linked — the push fallback then covers them).
  const { data: linked, error: linkedErr } = await supabase
    .from("profiles")
    .select("id, name, line_user_id")
    .not("line_user_id", "is", null);

  if (linkedErr) {
    return NextResponse.json({ error: linkedErr.message }, { status: 500 });
  }

  const profiles =
    (linked as Array<{ id: string; name: string | null; line_user_id: string }> | null) ?? [];
  const lineById = new Map(profiles.map((p) => [p.id, p]));

  const practiceUrl = `${SITE_URL}/nl/practice?${new URLSearchParams({
    utm_source: "line",
    utm_medium: "push",
    utm_campaign: "streak_nudge",
  }).toString()}`;

  let nudged = 0;
  let pushed = 0;
  let skipped = 0;

  // One query for every mcq_attempt in the full 48h window, bucketed in
  // memory below — replaces 2 sequential COUNT queries per profile (see
  // file header for why that timed out). Filtered by time only, not by
  // user_id IN (...): that scales with 48h activity volume rather than
  // total user count.
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

  // Active yesterday (20–48h) but not in the last 20h. Users who haven't
  // shown up for many days get a different campaign.
  const eligible = [...activeYesterday].filter((id) => !activeRecent.has(id));

  // Push subscriptions only for eligible users LINE won't cover.
  const subsByUser = new Map<string, PushSubscriptionRow[]>();
  const needPush = pushOn
    ? eligible.filter((id) => !(lineById.has(id) && lineAvailable))
    : [];
  if (needPush.length > 0) {
    const { data: subs, error: subsErr } = await supabase
      .from("push_subscriptions")
      .select("id, user_id, endpoint, p256dh, auth")
      .in("user_id", needPush);
    if (subsErr) {
      // Push is additive — don't fail the LINE nudges over it.
      console.error("[streak-nudge] push_subscriptions query failed:", subsErr.message);
    }
    for (const s of (subs ?? []) as PushSubscriptionRow[]) {
      const list = subsByUser.get(s.user_id) ?? [];
      list.push(s);
      subsByUser.set(s.user_id, list);
    }
  }

  for (const userId of eligible) {
    const lineProfile = lineById.get(userId);
    const channel = pickNudgeChannel({
      hasLine: !!lineProfile,
      lineAvailable,
      hasPush: subsByUser.has(userId),
    });
    if (!channel) {
      skipped++;
      continue;
    }

    const { data: streakData } = await supabase.rpc("get_user_streak", {
      p_user_id: userId,
    });
    const streak = Number(streakData ?? 0);

    try {
      if (channel === "line" && lineProfile) {
        const flex = buildStreakNudgeFlex({ name: lineProfile.name, streak, practiceUrl });
        const ok = await sendLineMessage(lineProfile.line_user_id, [flex]);
        if (ok) nudged++;
      } else {
        const res = await sendPushToSubscriptions(
          supabase,
          subsByUser.get(userId) ?? [],
          buildStreakNudgePush(streak)
        );
        if (res.sent > 0) pushed++;
      }
    } catch (err) {
      console.error(`[streak-nudge] ${channel} send failed for ${userId}:`, err);
    }
  }

  return NextResponse.json({
    candidates: profiles.length,
    eligible: eligible.length,
    nudged,
    pushed,
    skipped,
    lineThrottled: !lineAvailable,
  });
}

export const GET = withCronRun("streak-nudge", handleGet, { authorize: isAuthorized });
