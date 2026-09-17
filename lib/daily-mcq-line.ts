/**
 * Daily MCQ in LINE — answer-in-chat postback handler + shared helpers.
 *
 * Wires up the postback buttons rendered by buildDailyMcqBubble (in
 * lib/line-flex-templates.ts): action "daily_answer", data format
 * `action=daily_answer&d=<quiz_date>&c=<A-E>&q=<question id>`.
 *
 * Security: `d` and `c` are the only inputs trusted for scoring. The graded
 * question is always re-derived server-side from get_daily_mcq(d) — never
 * from the client-controlled `q` — so a forged `q` can't let someone answer
 * a question they already know the answer to. `d` is only accepted for
 * today or yesterday (Asia/Bangkok), closing old cards after one day.
 *
 * Idempotent: daily_quiz_answers has a unique (line_user_id, quiz_date), and
 * the insert uses upsert+ignoreDuplicates so a double-tap (or a retried LINE
 * webhook delivery) always re-reads and replies with the first answer given,
 * never double-scores or double-issues the streak-5 reward.
 */

import type { SupabaseClient } from "@supabase/supabase-js";
import type { LineMessage } from "@/lib/line";
import { parseData } from "@/lib/ads-autofix-line";
import { getOrCreateLeadFromChannel } from "@/lib/lead-channel";
import { issueRedeemCode } from "@/lib/redeem";
import {
  buildDailyMcqResultFlex,
  type DailyMcqQuestionData,
} from "@/lib/line-flex-templates";
import type { McqQuestion } from "@/lib/types-mcq";

const DAILY_ACTION = "daily_answer";
const STREAK_CAMPAIGN = "daily_mcq_streak5";
const STREAK_TARGET = 5;
const VALID_ANSWERS = new Set(["A", "B", "C", "D", "E"]);
// .trim() matters here: NEXT_PUBLIC_SITE_URL carries trailing whitespace in
// this Vercel project's env config, and every URL built from SITE_URL below
// ends up inside a LINE Flex "uri" action, which LINE's API validates
// strictly and rejects outright on a malformed/trailing-whitespace URI
// (confirmed against the live API). Every other Flex builder in
// lib/line-flex-templates.ts already trims for the same reason.
const SITE_URL = (process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com").trim();

// Leads that have already converted — don't hand out another trial.
const CONVERTED_STAGES = new Set(["redeemed", "paid"]);

function txt(text: string): LineMessage {
  return { type: "text", text };
}

/** Today's calendar date in Asia/Bangkok, as YYYY-MM-DD. */
export function bangkokToday(): string {
  return new Intl.DateTimeFormat("en-CA", { timeZone: "Asia/Bangkok" }).format(
    new Date()
  );
}

/** Shift a YYYY-MM-DD calendar date by `days` (may be negative). */
export function shiftQuizDate(dateStr: string, days: number): string {
  const d = new Date(`${dateStr}T00:00:00Z`);
  d.setUTCDate(d.getUTCDate() + days);
  return d.toISOString().slice(0, 10);
}

/** Build the "ทำในเว็บ" / "ดูเฉลยละเอียด" deep link, tagged for attribution. */
export function dailyPracticeUrl(
  questionId: string,
  quizDate: string,
  content: string
): string {
  const params = new URLSearchParams({
    q: questionId,
    utm_source: "line",
    utm_medium: "daily_mcq",
    utm_campaign: quizDate,
    utm_content: content,
  });
  return `${SITE_URL}/nl/practice?${params.toString()}`;
}

function dailyShareUrl(questionId: string, quizDate: string): string {
  const url = dailyPracticeUrl(questionId, quizDate, "share");
  const text = `📚 ลองตอบข้อสอบ MCQ ประจำวันนี้ดูสิ!\n${url}`;
  return `https://line.me/R/share?text=${encodeURIComponent(text)}`;
}

export type DailyQuestionFull = McqQuestion & { quiz_date: string };

/**
 * Load the full row (choices, correct_answer, explanation) for the day's
 * question, resolved via get_daily_mcq(quizDate) — the single canonical
 * source of "which question is today's", shared with the broadcast route.
 */
export async function loadDailyQuestion(
  supabase: SupabaseClient,
  quizDate: string
): Promise<DailyQuestionFull | null> {
  const { data: daily, error: rpcError } = await supabase.rpc("get_daily_mcq", {
    p_date: quizDate,
  });
  if (rpcError) {
    console.error("[daily-mcq-line] get_daily_mcq failed:", rpcError);
    return null;
  }
  const id = (daily as { id: string }[] | null)?.[0]?.id;
  if (!id) return null;

  const { data, error } = await supabase
    .from("mcq_questions")
    .select("*, mcq_subjects(name, name_th, icon)")
    .eq("id", id)
    .single();

  if (error || !data) {
    console.error("[daily-mcq-line] question lookup failed:", error);
    return null;
  }
  return { ...(data as McqQuestion), quiz_date: quizDate };
}

/**
 * Load the Friday "hard question of the week" via get_weekly_hard_mcq(quizDate)
 * — same deterministic-per-date lookup as loadDailyQuestion, filtered to
 * difficulty='hard' on the DB side.
 */
export async function loadHardQuestion(
  supabase: SupabaseClient,
  quizDate: string
): Promise<DailyQuestionFull | null> {
  const { data: weekly, error: rpcError } = await supabase.rpc("get_weekly_hard_mcq", {
    p_date: quizDate,
  });
  if (rpcError) {
    console.error("[daily-mcq-line] get_weekly_hard_mcq failed:", rpcError);
    return null;
  }
  const id = (weekly as { id: string }[] | null)?.[0]?.id;
  if (!id) return null;

  const { data, error } = await supabase
    .from("mcq_questions")
    .select("*, mcq_subjects(name, name_th, icon)")
    .eq("id", id)
    .single();

  if (error || !data) {
    console.error("[daily-mcq-line] hard question lookup failed:", error);
    return null;
  }
  return { ...(data as McqQuestion), quiz_date: quizDate };
}

export interface DailyMcqAudienceMember {
  lineUserId: string;
  name: string | null;
}

/** Days a newly linked LINE user gets the daily card before silence counts. */
export const DAILY_GRACE_DAYS = 14;

/**
 * "Everyone starts in; silence opts you out." A user who linked LINE (or,
 * lacking that timestamp, signed up) within DAILY_GRACE_DAYS is treated as
 * active regardless of history — they can't have answered a card they never
 * received. Falls back to createdAt because line_linked_at was added later
 * and is null for older rows.
 */
export function isWithinGrace(
  linkedAt: string | null,
  createdAt: string | null,
  now = Date.now()
): boolean {
  const anchor = linkedAt ?? createdAt;
  if (!anchor) return false;
  return now - new Date(anchor).getTime() < DAILY_GRACE_DAYS * 86400_000;
}

/**
 * Who the Mon-Fri daily/hard-question push goes to: LINE-linked users who
 * (a) answered the daily card in LINE, or (b) attempted any MCQ, in the last
 * `days` days, or (c) linked LINE within DAILY_GRACE_DAYS (see isWithinGrace).
 * Replaces a broadcast-to-everyone that was mostly landing on people who
 * never opened it (30/236 answered in 30 days).
 */
export async function getActiveDailyAudience(
  supabase: SupabaseClient,
  days = 30
): Promise<DailyMcqAudienceMember[]> {
  const sinceIso = new Date(Date.now() - days * 86400_000).toISOString();

  const [{ data: linked }, { data: answeredRows }] = await Promise.all([
    supabase
      .from("profiles")
      .select("id, name, line_user_id, line_linked_at, created_at")
      .not("line_user_id", "is", null),
    supabase.from("daily_quiz_answers").select("line_user_id").gte("created_at", sinceIso),
  ]);

  const profiles = (linked ?? []) as {
    id: string;
    name: string | null;
    line_user_id: string;
    line_linked_at: string | null;
    created_at: string | null;
  }[];
  const byId = new Map<string, string | null>();

  for (const row of (answeredRows ?? []) as { line_user_id: string }[]) {
    if (row.line_user_id) byId.set(row.line_user_id, byId.get(row.line_user_id) ?? null);
  }

  if (profiles.length > 0) {
    const { data: attemptRows } = await supabase
      .from("mcq_attempts")
      .select("user_id")
      .in(
        "user_id",
        profiles.map((p) => p.id)
      )
      .gte("created_at", sinceIso);
    const activeUserIds = new Set(
      ((attemptRows ?? []) as { user_id: string }[]).map((r) => r.user_id)
    );
    for (const p of profiles) {
      if (activeUserIds.has(p.id) || isWithinGrace(p.line_linked_at, p.created_at)) {
        byId.set(p.line_user_id, p.name ?? byId.get(p.line_user_id) ?? null);
      }
    }
  }

  return [...byId.entries()].map(([lineUserId, name]) => ({ lineUserId, name }));
}

/**
 * Per-user answer counts for the Friday "สัปดาห์นี้คุณตอบไป X ข้อ" line —
 * counts daily_quiz_answers from this week's Monday (Asia/Bangkok) through
 * today, keyed by line_user_id.
 */
/** Monday (YYYY-MM-DD) of the calendar week containing `quizDate`. */
export function mondayOfWeek(quizDate: string): string {
  const weekday = new Date(`${quizDate}T00:00:00Z`).getUTCDay(); // 0=Sun..6=Sat
  const mondayOffset = weekday === 0 ? -6 : 1 - weekday;
  return shiftQuizDate(quizDate, mondayOffset);
}

export async function getWeeklyAnswerCounts(
  supabase: SupabaseClient,
  quizDate: string
): Promise<Map<string, number>> {
  const monday = mondayOfWeek(quizDate);

  const { data, error } = await supabase
    .from("daily_quiz_answers")
    .select("line_user_id")
    .gte("quiz_date", monday)
    .lte("quiz_date", quizDate);

  const counts = new Map<string, number>();
  if (error || !data) return counts;
  for (const row of data as { line_user_id: string }[]) {
    if (!row.line_user_id) continue;
    counts.set(row.line_user_id, (counts.get(row.line_user_id) ?? 0) + 1);
  }
  return counts;
}

export function toBubbleQuestionData(
  question: DailyQuestionFull
): DailyMcqQuestionData {
  return {
    id: question.id,
    scenario: question.scenario,
    difficulty: question.difficulty,
    examType: question.exam_type ?? "NL2",
    subjectNameTh: question.mcq_subjects?.name_th ?? "",
    subjectIcon: question.mcq_subjects?.icon ?? "🩺",
    quizDate: question.quiz_date,
    choices: question.choices,
  };
}

/**
 * Handle a `daily_answer` postback. Returns null (never handled) for any
 * other action, so it composes safely after handleAdsAutofixPostback in the
 * webhook — both return null for actions that aren't theirs.
 */
export async function handleDailyMcqPostback(
  supabase: SupabaseClient,
  lineUserId: string,
  rawData: string
): Promise<LineMessage[] | null> {
  const params = parseData(rawData);
  if (params.action !== DAILY_ACTION) return null;

  const quizDate = params.d;
  const choice = params.c;
  const today = bangkokToday();
  const yesterday = shiftQuizDate(today, -1);

  if (!quizDate || (quizDate !== today && quizDate !== yesterday)) {
    return [
      txt(
        "โจทย์ข้อนี้หมดเวลาแล้ว รอข้อใหม่พรุ่งนี้ 7 โมงเช้า 🌅\n\nหรือฝึกต่อได้เลยที่นี่:\n" +
          `${SITE_URL}/nl/practice?utm_source=line&utm_medium=daily_mcq&utm_content=expired`
      ),
    ];
  }
  if (!VALID_ANSWERS.has(choice)) return null;

  const question = await loadDailyQuestion(supabase, quizDate);
  if (!question) {
    return [txt("ขออภัย ตอนนี้ระบบหาโจทย์ข้อนี้ไม่เจอ ลองใหม่อีกครั้งนะครับ 🙏")];
  }

  // Best-effort: attach the answer to a morroo account if this LINE user has
  // linked one, so it also counts toward their normal practice stats.
  // profiles.line_user_id has no DB-level unique constraint, so take at
  // most one match rather than .maybeSingle() (which throws on >1 row).
  const { data: linkedProfiles } = await supabase
    .from("profiles")
    .select("id")
    .eq("line_user_id", lineUserId)
    .limit(1);
  const userId = linkedProfiles?.[0]?.id as string | undefined;

  const isCorrect = choice === question.correct_answer;

  const { data: inserted, error: insertError } = await supabase
    .from("daily_quiz_answers")
    .upsert(
      {
        line_user_id: lineUserId,
        question_id: question.id,
        quiz_date: quizDate,
        selected_answer: choice,
        is_correct: isCorrect,
        user_id: userId ?? null,
      },
      { onConflict: "line_user_id,quiz_date", ignoreDuplicates: true }
    )
    .select();

  if (insertError) {
    console.error("[daily-mcq-line] answer upsert failed:", insertError);
    return [txt("เกิดข้อผิดพลาด ลองกดตอบใหม่อีกครั้งนะครับ 🙏")];
  }

  // ignoreDuplicates makes a repeat tap return 0 rows — re-read the
  // already-stored answer so both taps show the identical result.
  const isNewAnswer = (inserted?.length ?? 0) > 0;
  let stored: { selected_answer: string; is_correct: boolean } = {
    selected_answer: choice,
    is_correct: isCorrect,
  };
  if (!isNewAnswer) {
    const { data: existing } = await supabase
      .from("daily_quiz_answers")
      .select("selected_answer, is_correct")
      .eq("line_user_id", lineUserId)
      .eq("quiz_date", quizDate)
      .maybeSingle();
    if (existing) stored = existing;
  } else if (userId) {
    // Mirror into mcq_attempts so it also feeds the user's normal stats —
    // only on the first answer for this quiz_date, never on a repeat tap.
    const { error: attemptError } = await supabase.from("mcq_attempts").insert({
      user_id: userId,
      question_id: question.id,
      selected_answer: choice,
      is_correct: isCorrect,
      mode: "practice",
    });
    if (attemptError) {
      console.error("[daily-mcq-line] mcq_attempts mirror failed:", attemptError);
    }
  }

  const [{ data: streakData }, { data: statsData }] = await Promise.all([
    supabase.rpc("daily_quiz_streak", {
      p_line_user_id: lineUserId,
      p_date: quizDate,
    }),
    supabase.rpc("daily_quiz_stats", { p_date: quizDate }),
  ]);
  const streak = (streakData as number | null) ?? 0;
  const stats = (statsData as { total: number; correct: number }[] | null)?.[0] ?? null;

  const correctChoice = question.choices.find(
    (c) => c.label === question.correct_answer
  );

  const replies: LineMessage[] = [
    buildDailyMcqResultFlex({
      isCorrect: stored.is_correct,
      correctLabel: question.correct_answer,
      correctText: correctChoice?.text ?? "",
      explanation: question.explanation,
      streak,
      stats,
      practiceUrl: dailyPracticeUrl(
        question.id,
        quizDate,
        stored.is_correct ? "result_correct" : "result_wrong"
      ),
      shareUrl: dailyShareUrl(question.id, quizDate),
      needsLink: !userId,
      liffUrl: `${SITE_URL}/line/liff`,
    }),
  ];

  // Streak-5 reward — only on the answer that actually reaches the
  // milestone, and only once per lead ever (checked via redeem_codes,
  // not just in-memory, so a duplicate webhook delivery can't double-issue).
  if (isNewAnswer && streak === STREAK_TARGET) {
    const rewardText = await maybeIssueStreakReward(supabase, lineUserId);
    if (rewardText) replies.push(txt(rewardText));
  }

  return replies;
}

async function maybeIssueStreakReward(
  supabase: SupabaseClient,
  lineUserId: string
): Promise<string | null> {
  const leadId = await getOrCreateLeadFromChannel({
    channel: "line",
    channelUserId: lineUserId,
  });
  if (!leadId) return null;

  const { data: lead } = await supabase
    .from("leads")
    .select("stage")
    .eq("id", leadId)
    .maybeSingle();
  if (lead && CONVERTED_STAGES.has(lead.stage)) return null;

  const { data: existingCode } = await supabase
    .from("redeem_codes")
    .select("code")
    .eq("lead_id", leadId)
    .eq("campaign", STREAK_CAMPAIGN)
    .limit(1)
    .maybeSingle();
  if (existingCode) return null;

  try {
    // issueRedeemCode creates its own admin client internally — fine, it's
    // the same service-role connection as `supabase` here.
    const issued = await issueRedeemCode({
      rewardType: "monthly_1m",
      source: "line_oa",
      campaign: STREAK_CAMPAIGN,
      leadId,
    });

    await supabase
      .from("leads")
      .update({ stage: "code_issued", updated_at: new Date().toISOString() })
      .eq("id", leadId);

    return [
      "🎁 ตอบครบ 5 วันติด! นี่คือโค้ดทดลองใช้ฟรี 1 เดือนสำหรับน้องเลย",
      "",
      `โค้ด: ${issued.code}`,
      "",
      "กดลิงก์นี้แล้ว login ด้วย LINE รับสิทธิ์ได้ทันทีครับ 🩺",
      `${SITE_URL}/redeem/${issued.code}`,
      "(โค้ดหมดอายุใน 7 วัน)",
    ].join("\n");
  } catch (err) {
    console.error("[daily-mcq-line] issueRedeemCode failed:", err);
    return null;
  }
}
