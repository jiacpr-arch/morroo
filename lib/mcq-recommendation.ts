import type { SupabaseClient } from "@supabase/supabase-js";
import type { McqQuestion } from "./types-mcq";

export interface RecommendationBreakdown {
  review: number;
  weak: number;
  filler: number;
  weakSubjects: Array<{
    subject_id: string;
    name_th: string;
    icon: string;
    accuracy: number;
    attempts: number;
  }>;
}

export interface RecommendationResult {
  questions: McqQuestion[];
  breakdown: RecommendationBreakdown;
}

const DEFAULT_LIMIT = 20;
const WEAK_ACCURACY_THRESHOLD = 60;
const MIN_ATTEMPTS_FOR_WEAK = 5;
const REVIEW_COOLDOWN_HOURS = 24;

interface AttemptRow {
  question_id: string;
  is_correct: boolean;
  created_at: string;
  mcq_questions: { subject_id: string | null } | null;
}

function shuffle<T>(arr: T[]): T[] {
  const out = [...arr];
  for (let i = out.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [out[i], out[j]] = [out[j], out[i]];
  }
  return out;
}

export async function getRecommendedQuestions(
  supabase: SupabaseClient,
  userId: string,
  opts: { examType?: "NL1" | "NL2"; limit?: number } = {}
): Promise<RecommendationResult> {
  const examType = opts.examType ?? "NL2";
  const limit = opts.limit ?? DEFAULT_LIMIT;

  const { data: attemptsRaw } = await supabase
    .from("mcq_attempts")
    .select("question_id, is_correct, created_at, mcq_questions!inner(subject_id)")
    .eq("user_id", userId)
    .order("created_at", { ascending: false })
    .limit(5000);

  const attempts = (attemptsRaw as unknown as AttemptRow[] | null) ?? [];

  // Cold-start: no history → balanced random mix
  if (attempts.length === 0) {
    const cold = await fetchUnseenQuestions(supabase, examType, new Set(), limit);
    return {
      questions: cold,
      breakdown: { review: 0, weak: 0, filler: cold.length, weakSubjects: [] },
    };
  }

  // Latest attempt per question (attempts are pre-sorted desc)
  const latestByQuestion = new Map<string, AttemptRow>();
  for (const a of attempts) {
    if (!latestByQuestion.has(a.question_id)) latestByQuestion.set(a.question_id, a);
  }

  const perSubject = new Map<string, { correct: number; total: number }>();
  for (const a of latestByQuestion.values()) {
    const sid = a.mcq_questions?.subject_id;
    if (!sid) continue;
    const row = perSubject.get(sid) ?? { correct: 0, total: 0 };
    row.total += 1;
    if (a.is_correct) row.correct += 1;
    perSubject.set(sid, row);
  }

  const weakSubjectIds = new Set<string>();
  for (const [sid, row] of perSubject.entries()) {
    const acc = row.total > 0 ? (row.correct / row.total) * 100 : 0;
    if (row.total >= MIN_ATTEMPTS_FOR_WEAK && acc < WEAK_ACCURACY_THRESHOLD) {
      weakSubjectIds.add(sid);
    }
  }

  // Review pool: latest attempt wrong AND older than cooldown
  const cooldownMs = REVIEW_COOLDOWN_HOURS * 3600 * 1000;
  const now = Date.now();
  const reviewIds: string[] = [];
  for (const [qid, a] of latestByQuestion.entries()) {
    if (!a.is_correct && now - new Date(a.created_at).getTime() > cooldownMs) {
      reviewIds.push(qid);
    }
  }

  const targetReview = Math.min(Math.floor(limit * 0.3), reviewIds.length);
  const targetWeak = weakSubjectIds.size > 0 ? Math.floor(limit * 0.5) : 0;
  const targetFiller = limit - targetReview - targetWeak;

  const seenIds = new Set(latestByQuestion.keys());

  const [reviewQs, weakQs, fillerQs] = await Promise.all([
    targetReview > 0 ? fetchQuestionsByIds(supabase, shuffle(reviewIds).slice(0, targetReview)) : Promise.resolve([]),
    targetWeak > 0
      ? fetchUnseenQuestions(supabase, examType, seenIds, targetWeak, Array.from(weakSubjectIds))
      : Promise.resolve([]),
    targetFiller > 0
      ? fetchUnseenQuestions(supabase, examType, seenIds, targetFiller)
      : Promise.resolve([]),
  ]);

  const combined = [...reviewQs, ...weakQs, ...fillerQs];
  // Dedupe while preserving priority order
  const seenOut = new Set<string>();
  const deduped: McqQuestion[] = [];
  for (const q of combined) {
    if (seenOut.has(q.id)) continue;
    seenOut.add(q.id);
    deduped.push(q);
  }

  // If still short (e.g. small question bank), top up with any unseen
  if (deduped.length < limit) {
    const topup = await fetchUnseenQuestions(
      supabase,
      examType,
      new Set([...seenIds, ...seenOut]),
      limit - deduped.length
    );
    deduped.push(...topup);
  }

  const weakSubjectsInfo = await buildWeakSubjectsInfo(supabase, weakSubjectIds, perSubject);

  return {
    questions: shuffle(deduped).slice(0, limit),
    breakdown: {
      review: reviewQs.length,
      weak: weakQs.length,
      filler: fillerQs.length,
      weakSubjects: weakSubjectsInfo,
    },
  };
}

async function fetchQuestionsByIds(
  supabase: SupabaseClient,
  ids: string[]
): Promise<McqQuestion[]> {
  if (ids.length === 0) return [];
  const { data } = await supabase
    .from("mcq_questions")
    .select("*, mcq_subjects(name, name_th, icon)")
    .in("id", ids)
    .eq("status", "active");
  return (data as McqQuestion[] | null) ?? [];
}

async function fetchUnseenQuestions(
  supabase: SupabaseClient,
  examType: "NL1" | "NL2",
  excludeIds: Set<string>,
  limit: number,
  subjectIds?: string[]
): Promise<McqQuestion[]> {
  // Overfetch so the client-side shuffle + exclude yields enough unseen items.
  const fetchLimit = Math.max(limit * 4, 50);
  let query = supabase
    .from("mcq_questions")
    .select("*, mcq_subjects(name, name_th, icon)")
    .eq("status", "active")
    .eq("exam_type", examType)
    .limit(fetchLimit);

  if (subjectIds && subjectIds.length > 0) {
    query = query.in("subject_id", subjectIds);
  }

  const { data } = await query;
  const rows = (data as McqQuestion[] | null) ?? [];
  const unseen = rows.filter((q) => !excludeIds.has(q.id));
  return shuffle(unseen).slice(0, limit);
}

async function buildWeakSubjectsInfo(
  supabase: SupabaseClient,
  weakIds: Set<string>,
  perSubject: Map<string, { correct: number; total: number }>
): Promise<RecommendationBreakdown["weakSubjects"]> {
  if (weakIds.size === 0) return [];
  const { data } = await supabase
    .from("mcq_subjects")
    .select("id, name_th, icon")
    .in("id", Array.from(weakIds));
  const rows = (data as Array<{ id: string; name_th: string; icon: string }> | null) ?? [];
  return rows
    .map((r) => {
      const s = perSubject.get(r.id) ?? { correct: 0, total: 0 };
      const accuracy = s.total > 0 ? Math.round((s.correct / s.total) * 100) : 0;
      return { subject_id: r.id, name_th: r.name_th, icon: r.icon, accuracy, attempts: s.total };
    })
    .sort((a, b) => a.accuracy - b.accuracy);
}
