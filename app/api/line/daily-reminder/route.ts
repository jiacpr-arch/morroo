import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { broadcastLineMessages } from "@/lib/line";
import {
  buildDailyMcqFlex,
  buildDailyMcqCarousel,
  buildDailyMcqBubble,
  buildCasegameTeaserBubble,
  buildWeekRecapBubble,
} from "@/lib/line-flex-templates";
import {
  bangkokToday,
  shiftQuizDate,
  dailyPracticeUrl,
  loadDailyQuestion,
  toBubbleQuestionData,
} from "@/lib/daily-mcq-line";

export const runtime = "nodejs";

export async function POST(request: Request) {
  const { searchParams } = new URL(request.url);
  if (searchParams.get("secret") !== process.env.BLOG_GENERATE_SECRET) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const supabase = createAdminClient();
  const quizDate = bangkokToday();

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

  // New questions added in the last 24h — NL only, matches this broadcast's
  // audience (was: every active question, including Board).
  const { count: newCount } = await supabase
    .from("mcq_questions")
    .select("id", { count: "exact", head: true })
    .eq("status", "active")
    .eq("audience", "student")
    .gte("created_at", new Date(Date.now() - 86400_000).toISOString());

  const mcqBubble = buildDailyMcqBubble({
    question: toBubbleQuestionData(question),
    practiceUrl: dailyPracticeUrl(question.id, quizDate, "broadcast"),
    yesterdayStats,
    newCount: newCount ?? 0,
  });

  // Weekday-of quizDate, computed from the date string itself (not
  // new Date().getDay()) so it's never off-by-one relative to the Bangkok
  // date this broadcast is actually about. 0 = Sunday, 6 = Saturday.
  const weekday = new Date(`${quizDate}T00:00:00Z`).getUTCDay();

  let message;
  let variant: "weekday" | "saturday" | "sunday_recap" | "sunday_plain" = "weekday";

  if (weekday === 6) {
    variant = "saturday";
    message = buildDailyMcqCarousel(
      [buildCasegameTeaserBubble(), mcqBubble],
      `📚 ข้อสอบประจำวัน + 🎮 เคสจำลองฟรีวันเสาร์`
    );
  } else if (weekday === 0) {
    const recapEnd = shiftQuizDate(quizDate, -1); // Saturday: end of the 7-day window
    const { data: recapRows } = await supabase.rpc("daily_quiz_week_recap", {
      p_end: recapEnd,
    });
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

    if (recap && recap.answers >= 10) {
      variant = "sunday_recap";
      message = buildDailyMcqCarousel(
        [
          buildWeekRecapBubble({
            answers: recap.answers,
            participants: recap.participants,
            hardestDate: recap.hardest_date,
            hardestPct: recap.hardest_pct,
            streak5Count: recap.streak5_count,
          }),
          mcqBubble,
        ],
        `📊 สรุปสัปดาห์นี้ + 📚 ข้อสอบประจำวัน`
      );
    } else {
      variant = "sunday_plain";
      message = buildDailyMcqFlex({
        question: toBubbleQuestionData(question),
        practiceUrl: dailyPracticeUrl(question.id, quizDate, "broadcast"),
        yesterdayStats,
        newCount: newCount ?? 0,
      });
    }
  } else {
    message = buildDailyMcqFlex({
      question: toBubbleQuestionData(question),
      practiceUrl: dailyPracticeUrl(question.id, quizDate, "broadcast"),
      yesterdayStats,
      newCount: newCount ?? 0,
    });
  }

  const result = await broadcastLineMessages([message]);

  return NextResponse.json({
    ok: result.ok,
    error: result.error,
    quizDate,
    questionId: question.id,
    variant,
  });
}
