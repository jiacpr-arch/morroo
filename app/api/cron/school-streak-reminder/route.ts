/**
 * School streak reminder — pings users whose current_streak >= 2 but who
 * haven't reviewed anything today (Bangkok time). Sends a LINE message if
 * a line_user_id is linked.
 *
 * Schedule: 0 13 * * * UTC = 20:00 Asia/Bangkok — late enough to catch
 * "you'll lose your streak at midnight" feeling.
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
  // Asia/Bangkok = UTC+7
  const tzNow = new Date(now.getTime() + 7 * 60 * 60 * 1000);
  return tzNow.toISOString().slice(0, 10);
}

export async function GET(request: Request) {
  if (!isAuthorized(request)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const supabase = createAdminClient();
  const today = todayBangkok();
  // Streaks active (current_streak >= 2) that did NOT touch today
  const { data: streaks, error } = await supabase
    .from("school_streaks")
    .select("user_id, current_streak, last_active_date")
    .gte("current_streak", 2)
    .neq("last_active_date", today)
    .limit(500);
  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  let sent = 0;
  for (const s of streaks ?? []) {
    const { data: prof } = await supabase
      .from("profiles")
      .select("line_user_id, name")
      .eq("id", s.user_id)
      .maybeSingle();
    if (!prof?.line_user_id) continue;
    const msg = `🔥 Streak ${s.current_streak} วันของ ${prof.name ?? "คุณ"} เกือบหายแล้ว!\nทบทวน flashcard เร็วๆ ที่ https://www.morroo.com/school/daily — แค่ 5 นาที`;
    try {
      await sendLineMessage(prof.line_user_id, [{ type: "text", text: msg }]);
      sent += 1;
    } catch {
      // Non-blocking
    }
  }

  return NextResponse.json({ ok: true, candidates: streaks?.length ?? 0, sent });
}
