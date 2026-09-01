/**
 * School review reminder — pings users who have spaced-repetition cards due
 * (due_at <= now) but who have NOT reviewed anything yet today (Bangkok time)
 * and have a linked LINE account. Complements school-streak-reminder by
 * nudging people to clear their SRS queue before cards pile up.
 *
 * Schedule: 0 11 * * * UTC = 18:00 Asia/Bangkok (see vercel.json).
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendLineMessage } from "@/lib/line";

export const runtime = "nodejs";
export const maxDuration = 60;

function isAuthorized(request: Request): boolean {
  const url = new URL(request.url);
  const secret = url.searchParams.get("secret");
  if (secret && secret === process.env.BLOG_GENERATE_SECRET) return true;
  const auth = request.headers.get("authorization");
  if (
    auth &&
    process.env.CRON_SECRET &&
    auth === `Bearer ${process.env.CRON_SECRET}`
  )
    return true;
  return false;
}

function todayBangkok(): string {
  const now = new Date();
  const tzNow = new Date(now.getTime() + 7 * 60 * 60 * 1000); // UTC+7
  return tzNow.toISOString().slice(0, 10);
}

export async function GET(request: Request) {
  if (!isAuthorized(request)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const supabase = createAdminClient();
  const nowIso = new Date().toISOString();
  const today = todayBangkok();

  // Users with at least one card due now — count per user.
  const { data: dueRows, error } = await supabase
    .from("school_progress")
    .select("user_id")
    .lte("due_at", nowIso)
    .limit(2000);
  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  const dueCountByUser = new Map<string, number>();
  for (const r of (dueRows ?? []) as { user_id: string }[]) {
    dueCountByUser.set(r.user_id, (dueCountByUser.get(r.user_id) ?? 0) + 1);
  }
  const userIds = [...dueCountByUser.keys()];
  if (userIds.length === 0) {
    return NextResponse.json({ ok: true, candidates: 0, sent: 0 });
  }

  // Batch-fetch profiles (only those with a linked LINE account) and streaks.
  const [{ data: profiles }, { data: streaks }] = await Promise.all([
    supabase
      .from("profiles")
      .select("id, line_user_id, name")
      .in("id", userIds)
      .not("line_user_id", "is", null),
    supabase
      .from("school_streaks")
      .select("user_id, last_active_date")
      .in("user_id", userIds),
  ]);

  // Skip users who already studied today (no need to nudge).
  const activeToday = new Set(
    ((streaks ?? []) as { user_id: string; last_active_date: string | null }[])
      .filter((s) => s.last_active_date === today)
      .map((s) => s.user_id)
  );

  let sent = 0;
  for (const prof of (profiles ?? []) as {
    id: string;
    line_user_id: string | null;
    name: string | null;
  }[]) {
    if (!prof.line_user_id || activeToday.has(prof.id)) continue;
    const due = dueCountByUser.get(prof.id) ?? 0;
    if (due === 0) continue;
    const msg = `⏰ มีการ์ด ${due} ใบใกล้ลืมรอทบทวนอยู่ ${prof.name ?? "คุณ"}!\nทบทวนตอนนี้จำได้แม่นกว่า — https://www.morroo.com/school/review (แค่ไม่กี่นาที)`;
    try {
      await sendLineMessage(prof.line_user_id, [{ type: "text", text: msg }]);
      sent += 1;
    } catch {
      // Non-blocking
    }
  }

  return NextResponse.json({ ok: true, candidates: userIds.length, sent });
}
