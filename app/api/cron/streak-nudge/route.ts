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
  ) {
    return true;
  }
  return false;
}

export async function GET(request: Request) {
  if (!isAuthorized(request)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
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

  let nudged = 0;
  let skipped = 0;

  for (const p of profiles) {
    // Skip if user already attempted in the last 20h (still on track today).
    const { count: recentCount } = await supabase
      .from("mcq_attempts")
      .select("id", { count: "exact", head: true })
      .eq("user_id", p.id)
      .gte("created_at", recentCutoff);

    if ((recentCount ?? 0) > 0) {
      skipped++;
      continue;
    }

    // Require activity in the 20–48h window (so we're not nudging users
    // who haven't shown up for many days — they get a different campaign).
    const { count: yesterdayCount } = await supabase
      .from("mcq_attempts")
      .select("id", { count: "exact", head: true })
      .eq("user_id", p.id)
      .gte("created_at", yesterdayCutoff)
      .lt("created_at", recentCutoff);

    if ((yesterdayCount ?? 0) === 0) {
      skipped++;
      continue;
    }

    const { data: streakData } = await supabase.rpc("get_user_streak", {
      p_user_id: p.id,
    });
    const streak = Number(streakData ?? 0);

    const greeting = p.name ? `น้อง${p.name}` : "น้อง";
    const streakLine =
      streak >= 3
        ? `🔥 น้องมี streak ${streak} วันติด — อย่าให้ขาดวันนี้นะครับ!`
        : "📚 น้องเริ่มไว้แล้วเมื่อวาน — ทำต่อวันนี้สักข้อก็ยังดี!";

    const text = `${greeting} วันนี้ยังไม่ได้ทำข้อสอบเลย\n\n${streakLine}\n\nเปิด MorRoo → ทำข้อสอบ 5 ข้อ ใช้เวลาแค่ 5 นาที 👍`;

    try {
      const ok = await sendLineMessage(p.line_user_id, [
        { type: "text", text },
      ]);
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
