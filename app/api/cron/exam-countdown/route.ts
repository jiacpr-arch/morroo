/**
 * Exam countdown cron — เตือน 30/7/1 วันก่อนสอบ ศรว. เฉพาะคนที่ระดับ
 * (profiles.target_exam) ตรงกับรอบนั้น (NL1→step 1, NL2→2, NL3→3, both→ทุกขั้น).
 *
 * - ส่งเฉพาะรอบที่ confirmed ใน lib/exam-dates.ts
 * - คนที่ยังไม่ตั้งระดับ (null) และ board ไม่ได้รับ — ประหยัดโควต้า LINE
 * - กันส่งซ้ำด้วย exam_reminder_log (PK user_id, round_key, days_before):
 *   INSERT ก่อนส่ง, conflict 23505 = ส่งไปแล้ว, ส่งไม่สำเร็จทุกช่องทาง = ลบ log
 * - ช่องทาง: LINE ถ้าผูกบัญชีและโควต้าพอ ไม่งั้น Web Push (ไม่ส่งซ้ำสองช่องทาง)
 *
 * Schedule via vercel.json: "5 1 * * *" (08:05 ICT).
 * Auth: Authorization: Bearer $CRON_SECRET (or ?secret=$BLOG_GENERATE_SECRET).
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendLineMessage, checkLineQuota } from "@/lib/line";
import { withCronRun } from "@/lib/cron-runs";
import { isPushConfigured, sendPushToUser } from "@/lib/push";
import { toLiffUri } from "@/lib/line-links";
import { examStepsForTarget } from "@/lib/exam-level";
import { countdownBody, countdownTitle, dueReminders } from "@/lib/exam-reminders";

export const runtime = "nodejs";
export const maxDuration = 60;

const SITE_URL = (process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com").trim();

function isAuthorized(request: Request): boolean {
  const url = new URL(request.url);
  const secret = url.searchParams.get("secret");
  if (secret && secret === process.env.BLOG_GENERATE_SECRET) return true;

  const auth = request.headers.get("authorization");
  return !!(auth && process.env.CRON_SECRET && auth === `Bearer ${process.env.CRON_SECRET}`);
}

async function handleGet(_request: Request) {
  const due = dueReminders(new Date());
  if (due.length === 0) {
    return NextResponse.json({ ok: true, due: 0, sent: 0 });
  }

  const supabase = createAdminClient();
  const { data, error } = await supabase
    .from("profiles")
    .select("id, name, line_user_id, target_exam")
    .in("target_exam", ["NL1", "NL2", "NL3", "both"]);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  const profiles =
    (data as Array<{ id: string; name: string | null; line_user_id: string | null; target_exam: string }> | null) ?? [];

  const quota = await checkLineQuota();
  const lineAvailable = !quota.throttled;
  const pushOn = isPushConfigured();

  let sentLine = 0;
  let sentPush = 0;
  let skipped = 0;
  let failed = 0;

  for (const reminder of due) {
    const { round, daysBefore, roundKey } = reminder;
    const title = countdownTitle(round, daysBefore);
    const body = countdownBody(round, daysBefore);
    const practiceUrl = `${SITE_URL}/nl/practice?${new URLSearchParams({
      utm_source: "line",
      utm_medium: "push",
      utm_campaign: "exam_countdown",
    }).toString()}`;

    for (const p of profiles) {
      if (!examStepsForTarget(p.target_exam).includes(round.step)) continue;

      const canLine = !!p.line_user_id && lineAvailable;
      if (!canLine && !pushOn) {
        skipped++;
        continue;
      }

      const { error: logErr } = await supabase
        .from("exam_reminder_log")
        .insert({ user_id: p.id, round_key: roundKey, days_before: daysBefore });
      if (logErr) {
        if (logErr.code !== "23505") {
          console.error("[exam-countdown] log insert failed:", logErr.message);
          failed++;
        } else {
          skipped++; // already reminded
        }
        continue;
      }

      let delivered = false;
      try {
        if (canLine && p.line_user_id) {
          delivered = await sendLineMessage(p.line_user_id, [
            { type: "text", text: `${title}\n${body}\n\nทำข้อสอบเลย 👉 ${toLiffUri(practiceUrl)}` },
          ]);
          if (delivered) sentLine++;
        } else {
          const res = await sendPushToUser(supabase, p.id, {
            title,
            body,
            url: `/nl/practice?utm_source=webpush&utm_medium=push&utm_campaign=exam_countdown`,
            tag: `exam-countdown-${roundKey}`,
          });
          delivered = res.sent > 0;
          if (delivered) sentPush++;
        }
      } catch (err) {
        console.error(`[exam-countdown] send failed for ${p.id}:`, err);
      }

      if (!delivered) {
        failed++;
        // Milestones are date-exact, so free the key to let a manual re-run
        // the same day retry.
        await supabase
          .from("exam_reminder_log")
          .delete()
          .eq("user_id", p.id)
          .eq("round_key", roundKey)
          .eq("days_before", daysBefore);
      }
    }
  }

  return NextResponse.json({
    ok: true,
    due: due.length,
    candidates: profiles.length,
    sentLine,
    sentPush,
    skipped,
    failed,
    lineThrottled: !lineAvailable,
  });
}

export const GET = withCronRun("exam-countdown", handleGet, { authorize: isAuthorized });
