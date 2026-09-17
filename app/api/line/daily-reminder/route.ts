/**
 * LINE reminder schedule v2 — one route, branches on Bangkok day-of-week.
 * Hit by 3 separate pg_cron schedules (see supabase/migrations/
 * 20260917_line_reminder_schedule_v2.sql):
 *
 *   Mon-Thu 07:00  push to active players only  — daily MCQ card
 *   Fri     07:00  push to active players only  — weekly hard question
 *   Sat     09:00  broadcast to everyone         — MEQ/long-case teaser
 *   Sun     19:00  broadcast to everyone         — new long case + week recap
 *
 * Why push (not broadcast) on weekdays: engagement data showed ~30/236
 * LINE-linked users ever answer the daily card in a given month — broadcasting
 * it to everyone was most of the OA's monthly message volume for very little
 * return, and contributed to the Aug 2026 quota exhaustion.
 */
import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { broadcastLineMessages, sendLineMessage } from "@/lib/line";
import {
  buildDailyMcqFlex,
  buildDailyMcqCarousel,
  buildWeeklyHardMcqFlex,
  buildCasegameTeaserBubble,
  buildWeekRecapBubble,
  buildNewLongCaseBubble,
} from "@/lib/line-flex-templates";
import {
  bangkokToday,
  shiftQuizDate,
  dailyPracticeUrl,
  loadDailyQuestion,
  loadHardQuestion,
  toBubbleQuestionData,
  getActiveDailyAudience,
  getWeeklyAnswerCounts,
} from "@/lib/daily-mcq-line";

export const runtime = "nodejs";
export const maxDuration = 60;

const SITE_URL = (process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com").trim();

async function handleWeekday(supabase: ReturnType<typeof createAdminClient>, quizDate: string) {
  const question = await loadDailyQuestion(supabase, quizDate);
  if (!question) {
    return NextResponse.json({ error: "No daily question available" }, { status: 500 });
  }

  const yesterday = shiftQuizDate(quizDate, -1);
  const { data: yesterdayStatsRows } = await supabase.rpc("daily_quiz_stats", {
    p_date: yesterday,
  });
  const yesterdayStats =
    (yesterdayStatsRows as { total: number; correct: number }[] | null)?.[0] ?? null;

  const { count: newCount } = await supabase
    .from("mcq_questions")
    .select("id", { count: "exact", head: true })
    .eq("status", "active")
    .eq("audience", "student")
    .gte("created_at", new Date(Date.now() - 86400_000).toISOString());

  const message = buildDailyMcqFlex({
    question: toBubbleQuestionData(question),
    practiceUrl: dailyPracticeUrl(question.id, quizDate, "push"),
    yesterdayStats,
    newCount: newCount ?? 0,
  });

  const audience = await getActiveDailyAudience(supabase);
  let sent = 0;
  let failed = 0;
  for (const member of audience) {
    try {
      const ok = await sendLineMessage(member.lineUserId, [message]);
      if (ok) sent += 1;
      else failed += 1;
    } catch (err) {
      console.error("[daily-reminder] push failed for", member.lineUserId, err);
      failed += 1;
    }
  }

  return NextResponse.json({
    variant: "weekday_push",
    quizDate,
    questionId: question.id,
    candidates: audience.length,
    sent,
    failed,
  });
}

async function handleFriday(supabase: ReturnType<typeof createAdminClient>, quizDate: string) {
  const question = await loadHardQuestion(supabase, quizDate);
  if (!question) {
    return NextResponse.json({ error: "No hard question available" }, { status: 500 });
  }

  const audience = await getActiveDailyAudience(supabase);
  const weeklyCounts = await getWeeklyAnswerCounts(supabase, quizDate);

  let sent = 0;
  let failed = 0;
  for (const member of audience) {
    const message = buildWeeklyHardMcqFlex({
      question: toBubbleQuestionData(question),
      practiceUrl: dailyPracticeUrl(question.id, quizDate, "push_hard"),
      weeklyAnswered: weeklyCounts.get(member.lineUserId) ?? 0,
    });
    try {
      const ok = await sendLineMessage(member.lineUserId, [message]);
      if (ok) sent += 1;
      else failed += 1;
    } catch (err) {
      console.error("[daily-reminder] hard-question push failed for", member.lineUserId, err);
      failed += 1;
    }
  }

  return NextResponse.json({
    variant: "friday_hard_question",
    quizDate,
    questionId: question.id,
    candidates: audience.length,
    sent,
    failed,
  });
}

async function handleSaturday(quizDate: string) {
  const message = buildDailyMcqCarousel(
    [buildCasegameTeaserBubble()],
    "🎮 เคสจำลอง MEQ/Long Case ฟรีวันนี้ — ไม่ต้องสมัคร"
  );
  const result = await broadcastLineMessages([message]);
  return NextResponse.json({ variant: "saturday_casegame", quizDate, ok: result.ok, error: result.error });
}

async function handleSunday(supabase: ReturnType<typeof createAdminClient>, quizDate: string) {
  const { data: latest } = await supabase
    .from("long_cases")
    .select("id, title, specialty")
    .eq("is_published", true)
    .order("published_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  const recapEnd = shiftQuizDate(quizDate, -1);
  const { data: recapRows } = await supabase.rpc("daily_quiz_week_recap", { p_end: recapEnd });
  const recap = (
    recapRows as
      | {
          answers: number;
          participants: number;
          hardest_date: string | null;
          hardest_pct: number | null;
          streak5_count: number;
        }[]
      | null
  )?.[0];

  const bubbles: Record<string, unknown>[] = [];
  if (latest) {
    bubbles.push(
      buildNewLongCaseBubble({
        title: latest.title,
        specialty: latest.specialty ?? "",
        url: `${SITE_URL}/longcase/${latest.id}?utm_source=line&utm_medium=daily_mcq&utm_campaign=sun_longcase`,
      })
    );
  }
  if (recap && recap.answers >= 10) {
    bubbles.push(
      buildWeekRecapBubble({
        answers: recap.answers,
        participants: recap.participants,
        hardestDate: recap.hardest_date,
        hardestPct: recap.hardest_pct,
        streak5Count: recap.streak5_count,
      })
    );
  }

  if (bubbles.length === 0) {
    return NextResponse.json({ variant: "sunday_longcase", quizDate, ok: true, message: "Nothing to send" });
  }

  const message = buildDailyMcqCarousel(bubbles, "🩺 Long Case ใหม่ประจำสัปดาห์ + สรุปสัปดาห์นี้");
  const result = await broadcastLineMessages([message]);
  return NextResponse.json({
    variant: "sunday_longcase",
    quizDate,
    longCaseId: latest?.id ?? null,
    ok: result.ok,
    error: result.error,
  });
}

export async function POST(request: Request) {
  const { searchParams } = new URL(request.url);
  if (searchParams.get("secret") !== process.env.BLOG_GENERATE_SECRET) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const supabase = createAdminClient();
  const quizDate = bangkokToday();
  // Weekday of quizDate, computed from the date string itself (not
  // new Date().getDay()) so it's never off-by-one relative to the Bangkok
  // date this run is actually about. 0 = Sunday, 6 = Saturday.
  const weekday = new Date(`${quizDate}T00:00:00Z`).getUTCDay();

  if (weekday === 6) return handleSaturday(quizDate);
  if (weekday === 0) return handleSunday(supabase, quizDate);
  if (weekday === 5) return handleFriday(supabase, quizDate);
  return handleWeekday(supabase, quizDate);
}
