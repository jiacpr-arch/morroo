import { createClient } from "./server";
import type {
  SchoolFlashcard,
  SchoolLesson,
  SchoolQuiz,
  SchoolSystem,
  SchoolTopic,
} from "../types-school";

export async function getSchoolSystems(): Promise<SchoolSystem[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("school_systems")
    .select("*")
    .order("sort_order");
  if (error) {
    console.error("Error fetching school systems:", error);
    return [];
  }
  return (data as SchoolSystem[]) ?? [];
}

export async function getSchoolTopicsByYear(year: number): Promise<SchoolTopic[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("school_topics")
    .select("*, school_systems(*)")
    .eq("year", year)
    .order("sort_order");
  if (error) {
    console.error("Error fetching school topics:", error);
    return [];
  }
  return (data as SchoolTopic[]) ?? [];
}

export async function getSchoolTopicCounts(): Promise<{
  flashcards: Record<string, number>;
  quizzes: Record<string, number>;
}> {
  const supabase = await createClient();
  const flashcards: Record<string, number> = {};
  const quizzes: Record<string, number> = {};

  const [{ data: fc }, { data: qz }] = await Promise.all([
    supabase.from("school_flashcards").select("topic_id").eq("status", "active"),
    supabase.from("school_quizzes").select("topic_id").eq("status", "active"),
  ]);

  for (const row of (fc ?? []) as { topic_id: string }[]) {
    flashcards[row.topic_id] = (flashcards[row.topic_id] || 0) + 1;
  }
  for (const row of (qz ?? []) as { topic_id: string }[]) {
    quizzes[row.topic_id] = (quizzes[row.topic_id] || 0) + 1;
  }
  return { flashcards, quizzes };
}

export async function getSchoolFlashcards(opts: {
  topicId?: string;
  year?: number;
  limit?: number;
  randomize?: boolean;
}): Promise<SchoolFlashcard[]> {
  const supabase = await createClient();
  let query = supabase
    .from("school_flashcards")
    .select("*, school_topics!inner(year)")
    .eq("status", "active");

  if (opts.topicId) query = query.eq("topic_id", opts.topicId);
  if (opts.year) query = query.eq("school_topics.year", opts.year);
  query = query.limit(opts.limit ?? 30);

  const { data, error } = await query;
  if (error) {
    console.error("Error fetching school flashcards:", error);
    return [];
  }
  let cards = (data as SchoolFlashcard[]) ?? [];
  if (opts.randomize) cards = cards.sort(() => Math.random() - 0.5);
  return cards;
}

export async function getSchoolQuizzes(opts: {
  topicId?: string;
  year?: number;
  limit?: number;
  randomize?: boolean;
}): Promise<SchoolQuiz[]> {
  const supabase = await createClient();
  let query = supabase
    .from("school_quizzes")
    .select("*, school_topics!inner(year)")
    .eq("status", "active");

  if (opts.topicId) query = query.eq("topic_id", opts.topicId);
  if (opts.year) query = query.eq("school_topics.year", opts.year);
  query = query.limit(opts.limit ?? 20);

  const { data, error } = await query;
  if (error) {
    console.error("Error fetching school quizzes:", error);
    return [];
  }
  let quizzes = (data as SchoolQuiz[]) ?? [];
  if (opts.randomize) quizzes = quizzes.sort(() => Math.random() - 0.5);
  return quizzes;
}

export async function getSchoolLessons(opts: {
  topicId?: string;
  year?: number;
}): Promise<SchoolLesson[]> {
  const supabase = await createClient();
  let query = supabase
    .from("school_lessons")
    .select("*, school_topics!inner(year)")
    .eq("status", "active")
    .order("sort_order");
  if (opts.topicId) query = query.eq("topic_id", opts.topicId);
  if (opts.year) query = query.eq("school_topics.year", opts.year);
  const { data, error } = await query;
  if (error) {
    console.error("Error fetching school lessons:", error);
    return [];
  }
  return (data as SchoolLesson[]) ?? [];
}

export async function getSchoolLesson(id: string): Promise<SchoolLesson | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("school_lessons")
    .select("*")
    .eq("id", id)
    .eq("status", "active")
    .maybeSingle();
  if (error) {
    console.error("Error fetching school lesson:", error);
    return null;
  }
  return (data as SchoolLesson) ?? null;
}

export async function getSchoolTopicBySlug(
  systemSlug: string,
  year: number,
  topicSlug: string
): Promise<SchoolTopic | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("school_topics")
    .select("*, school_systems!inner(*)")
    .eq("year", year)
    .eq("slug", topicSlug)
    .eq("school_systems.slug", systemSlug)
    .maybeSingle();
  if (error) {
    console.error("Error fetching school topic:", error);
    return null;
  }
  return (data as SchoolTopic) ?? null;
}

// ────────────────────────────────────────────────────────────────────────────
// Personalised queries (require auth.uid())
// ────────────────────────────────────────────────────────────────────────────

/**
 * Return cards mixed across topics for an "Interleaved" session. If the user
 * has reviewed cards before, prioritise due ones; otherwise random fresh.
 */
export async function getMixedFlashcards(opts: {
  userId: string;
  year?: number;
  limit?: number;
}): Promise<SchoolFlashcard[]> {
  const supabase = await createClient();
  const limit = opts.limit ?? 20;

  // Step 1 — pull due cards (from school_progress with due_at <= now())
  const { data: due } = await supabase
    .from("school_progress")
    .select("unit_id")
    .eq("user_id", opts.userId)
    .eq("unit_type", "flashcard")
    .lte("due_at", new Date().toISOString())
    .order("due_at", { ascending: true })
    .limit(limit);

  const dueIds = (due ?? []).map((r: { unit_id: string }) => r.unit_id);
  const cards: SchoolFlashcard[] = [];

  if (dueIds.length) {
    let q = supabase
      .from("school_flashcards")
      .select("*, school_topics!inner(year)")
      .eq("status", "active")
      .in("id", dueIds);
    if (opts.year) q = q.eq("school_topics.year", opts.year);
    const { data } = await q;
    cards.push(...((data as SchoolFlashcard[]) ?? []));
  }

  // Step 2 — fill with fresh (not yet reviewed) cards
  if (cards.length < limit) {
    const { data: seenRows } = await supabase
      .from("school_progress")
      .select("unit_id")
      .eq("user_id", opts.userId)
      .eq("unit_type", "flashcard");
    const seenIds = new Set(
      (seenRows ?? []).map((r: { unit_id: string }) => r.unit_id)
    );
    let q = supabase
      .from("school_flashcards")
      .select("*, school_topics!inner(year)")
      .eq("status", "active")
      .limit(limit * 3);
    if (opts.year) q = q.eq("school_topics.year", opts.year);
    const { data: pool } = await q;
    const fresh = ((pool as SchoolFlashcard[]) ?? []).filter(
      (c) => !seenIds.has(c.id)
    );
    fresh.sort(() => Math.random() - 0.5);
    cards.push(...fresh.slice(0, limit - cards.length));
  }

  // Interleave by shuffling
  return cards.sort(() => Math.random() - 0.5);
}

export async function getMixedQuizzes(opts: {
  userId: string;
  year?: number;
  limit?: number;
}): Promise<SchoolQuiz[]> {
  const supabase = await createClient();
  const limit = opts.limit ?? 10;

  const { data: seenRows } = await supabase
    .from("school_progress")
    .select("unit_id, outcome")
    .eq("user_id", opts.userId)
    .eq("unit_type", "quiz");
  const wrongIds = (seenRows ?? [])
    .filter((r: { outcome: string }) => r.outcome === "wrong")
    .map((r: { unit_id: string }) => r.unit_id);
  const correctIds = new Set(
    (seenRows ?? [])
      .filter((r: { outcome: string }) => r.outcome === "correct")
      .map((r: { unit_id: string }) => r.unit_id)
  );

  const quizzes: SchoolQuiz[] = [];

  if (wrongIds.length) {
    let q = supabase
      .from("school_quizzes")
      .select("*, school_topics!inner(year)")
      .eq("status", "active")
      .in("id", wrongIds);
    if (opts.year) q = q.eq("school_topics.year", opts.year);
    const { data } = await q;
    quizzes.push(...((data as SchoolQuiz[]) ?? []));
  }

  if (quizzes.length < limit) {
    let q = supabase
      .from("school_quizzes")
      .select("*, school_topics!inner(year)")
      .eq("status", "active")
      .limit(limit * 3);
    if (opts.year) q = q.eq("school_topics.year", opts.year);
    const { data: pool } = await q;
    const fresh = ((pool as SchoolQuiz[]) ?? []).filter(
      (q) => !correctIds.has(q.id)
    );
    fresh.sort(() => Math.random() - 0.5);
    quizzes.push(...fresh.slice(0, limit - quizzes.length));
  }

  return quizzes.sort(() => Math.random() - 0.5);
}

export interface SchoolStreak {
  user_id: string;
  current_streak: number;
  longest_streak: number;
  last_active_date: string | null;
}

export async function getSchoolStreak(userId: string): Promise<SchoolStreak> {
  const supabase = await createClient();
  const { data } = await supabase
    .from("school_streaks")
    .select("*")
    .eq("user_id", userId)
    .maybeSingle();
  return (
    (data as SchoolStreak) ?? {
      user_id: userId,
      current_streak: 0,
      longest_streak: 0,
      last_active_date: null,
    }
  );
}

export async function getSchoolMasteryByTopic(
  userId: string
): Promise<Record<string, { seen: number; correct: number; pct: number }>> {
  const supabase = await createClient();
  // Pull quiz progress with topic info via join through school_quizzes
  const { data } = await supabase
    .from("school_progress")
    .select(
      "outcome, unit_id, school_quizzes:unit_id(topic_id)"
    )
    .eq("user_id", userId)
    .eq("unit_type", "quiz");

  type Row = { outcome: string; school_quizzes?: { topic_id: string } | null };
  const buckets: Record<string, { seen: number; correct: number }> = {};
  for (const r of (data ?? []) as Row[]) {
    const tid = r.school_quizzes?.topic_id;
    if (!tid) continue;
    const b = (buckets[tid] ??= { seen: 0, correct: 0 });
    b.seen += 1;
    if (r.outcome === "correct") b.correct += 1;
  }
  const out: Record<string, { seen: number; correct: number; pct: number }> = {};
  for (const [tid, b] of Object.entries(buckets)) {
    out[tid] = { ...b, pct: b.seen ? Math.round((b.correct / b.seen) * 100) : 0 };
  }
  return out;
}

export async function getDueCount(userId: string): Promise<number> {
  const supabase = await createClient();
  const { count } = await supabase
    .from("school_progress")
    .select("id", { count: "exact", head: true })
    .eq("user_id", userId)
    .lte("due_at", new Date().toISOString());
  return count ?? 0;
}
