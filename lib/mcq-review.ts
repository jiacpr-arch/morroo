/**
 * MCQ "ทบทวนข้อที่ผิด" — spaced repetition over questions the user got wrong.
 *
 * State lives in `mcq_review_queue` (supabase/migrations/20260925_mcq_review_queue.sql),
 * one row per (user, question) still under review. Interval math reuses the
 * School SM-2 scheduler (lib/school/srs.ts) with its correct/wrong outcomes;
 * this file adds the queue rules on top:
 *   - wrong answer, not queued      → enters the queue, due in 1 day
 *   - wrong answer, queued          → lapse: interval resets to 1 day, ease drops
 *   - correct answer, due           → interval grows (× ease factor)
 *   - correct answer, not yet due   → no change (early reviews don't count)
 *   - correct answer, not queued    → no change
 *   - next interval > GRADUATE_AFTER_DAYS → removed from the queue
 *
 * "Due" is day-granular in Asia/Bangkok: anything due before the end of the
 * user's current Bangkok day counts, so the morning LINE reminder's count
 * matches what the practice page serves later that day.
 */

import type { SupabaseClient } from "@supabase/supabase-js";
import { nextSrsState } from "./school/srs";
import { MCQ_PUBLIC_SELECT, type McqPublicQuestion } from "./mcq-public";

// Due questions are read with the caller's user-scoped client — no answer key
// (see lib/mcq-public.ts); McqPractice reveals per question.
type McqQuestion = McqPublicQuestion;

/** A correct review that would push the interval past this graduates the question. */
export const GRADUATE_AFTER_DAYS = 60;
const INITIAL_EASE = 2.5;
const INITIAL_INTERVAL_DAYS = 1;
const BANGKOK_OFFSET_MS = 7 * 3600_000;
const DAY_MS = 24 * 3600_000;

export interface McqReviewRow {
  ease_factor: number;
  interval_days: number;
  due_at: string;
  lapses: number;
  review_count: number;
}

export type McqReviewUpdate =
  | { action: "none" }
  | { action: "delete" }
  | {
      action: "upsert";
      row: McqReviewRow & { last_reviewed_at: string | null };
    };

/** Start of the next Asia/Bangkok calendar day, as a UTC instant. */
export function bangkokDayEnd(now: Date = new Date()): Date {
  const local = now.getTime() + BANGKOK_OFFSET_MS;
  const nextLocalMidnight = Math.floor(local / DAY_MS) * DAY_MS + DAY_MS;
  return new Date(nextLocalMidnight - BANGKOK_OFFSET_MS);
}

/**
 * The queue (and ?mode=review) is NL-only: getDueReviewQuestions serves
 * audience='student' questions, so only those may enter the queue — otherwise
 * the badge / LINE reminder count questions the review page never shows.
 * Browser writers already gate on the session audience; server writers (LINE
 * daily quiz) must check the question itself.
 */
export function isReviewQueueAudience(question: { audience?: string | null }): boolean {
  return question.audience === "student";
}

export function isReviewDue(dueAt: string | Date, now: Date = new Date()): boolean {
  return new Date(dueAt).getTime() < bangkokDayEnd(now).getTime();
}

/** Pure queue transition for one answer — see file header for the rules. */
export function nextMcqReviewState(
  current: McqReviewRow | null,
  isCorrect: boolean,
  now: Date = new Date()
): McqReviewUpdate {
  if (!current) {
    if (isCorrect) return { action: "none" };
    const due = new Date(now.getTime() + INITIAL_INTERVAL_DAYS * DAY_MS);
    return {
      action: "upsert",
      row: {
        ease_factor: INITIAL_EASE,
        interval_days: INITIAL_INTERVAL_DAYS,
        due_at: due.toISOString(),
        lapses: 0,
        review_count: 0,
        last_reviewed_at: null,
      },
    };
  }

  if (isCorrect && !isReviewDue(current.due_at, now)) return { action: "none" };

  const next = nextSrsState(
    { ease_factor: Number(current.ease_factor), interval_days: current.interval_days },
    isCorrect ? "correct" : "wrong",
    now
  );
  if (isCorrect && next.interval_days > GRADUATE_AFTER_DAYS) {
    return { action: "delete" };
  }
  return {
    action: "upsert",
    row: {
      ease_factor: next.ease_factor,
      interval_days: next.interval_days,
      due_at: next.due_at.toISOString(),
      lapses: current.lapses + (isCorrect ? 0 : 1),
      review_count: current.review_count + 1,
      last_reviewed_at: now.toISOString(),
    },
  };
}

/**
 * Apply one answer to the queue. Works with either the browser client (RLS
 * limits it to the user's own rows) or the service-role client. Never throws
 * — the queue is a side effect of answering and must not block the UI or the
 * LINE reply.
 */
export async function recordMcqReviewOutcome(
  supabase: SupabaseClient,
  userId: string,
  questionId: string,
  isCorrect: boolean,
  now: Date = new Date()
): Promise<void> {
  try {
    const { data: current, error } = await supabase
      .from("mcq_review_queue")
      .select("ease_factor, interval_days, due_at, lapses, review_count")
      .eq("user_id", userId)
      .eq("question_id", questionId)
      .maybeSingle();
    if (error) throw error;

    const update = nextMcqReviewState(current as McqReviewRow | null, isCorrect, now);
    if (update.action === "none") return;

    if (update.action === "delete") {
      const { error: delError } = await supabase
        .from("mcq_review_queue")
        .delete()
        .eq("user_id", userId)
        .eq("question_id", questionId);
      if (delError) throw delError;
      return;
    }

    const { error: upsertError } = await supabase.from("mcq_review_queue").upsert(
      {
        user_id: userId,
        question_id: questionId,
        ...update.row,
        updated_at: now.toISOString(),
      },
      { onConflict: "user_id,question_id" }
    );
    if (upsertError) throw upsertError;
  } catch (err) {
    console.error("[mcq-review] queue update failed:", err);
  }
}

/**
 * Number of active student questions due for review today — drives the toggle
 * badge. Same filter as getDueReviewQuestions and the mcq_review_due_counts
 * RPC so the badge, the LINE reminder and the review page agree.
 */
export async function getMcqReviewDueCount(
  supabase: SupabaseClient,
  userId: string,
  now: Date = new Date()
): Promise<number> {
  const { count, error } = await supabase
    .from("mcq_review_queue")
    .select("question_id, mcq_questions!inner(status, audience)", {
      count: "exact",
      head: true,
    })
    .eq("user_id", userId)
    .eq("mcq_questions.status", "active")
    .eq("mcq_questions.audience", "student")
    .lt("due_at", bangkokDayEnd(now).toISOString());
  if (error) {
    console.error("[mcq-review] due count failed:", error);
    return 0;
  }
  return count ?? 0;
}

/** Due questions for ?mode=review, most overdue first. */
export async function getDueReviewQuestions(
  supabase: SupabaseClient,
  userId: string,
  opts: { limit?: number; now?: Date } = {}
): Promise<McqQuestion[]> {
  const limit = opts.limit ?? 20;
  const { data: dueRows, error } = await supabase
    .from("mcq_review_queue")
    .select("question_id")
    .eq("user_id", userId)
    .lt("due_at", bangkokDayEnd(opts.now).toISOString())
    .order("due_at", { ascending: true })
    // Overfetch a little: deactivated questions are dropped below.
    .limit(limit * 2);
  if (error) {
    console.error("[mcq-review] due fetch failed:", error);
    return [];
  }
  const ids = ((dueRows as { question_id: string }[] | null) ?? []).map((r) => r.question_id);
  if (ids.length === 0) return [];

  const { data: qs } = await supabase
    .from("mcq_questions")
    .select(MCQ_PUBLIC_SELECT)
    .in("id", ids)
    .eq("status", "active")
    .eq("audience", "student");
  const byId = new Map(((qs as unknown as McqQuestion[] | null) ?? []).map((q) => [q.id, q]));
  return ids
    .map((id) => byId.get(id))
    .filter((q): q is McqQuestion => !!q)
    .slice(0, limit);
}
