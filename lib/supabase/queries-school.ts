import { createClient } from "./server";
import type {
  SchoolFlashcard,
  SchoolLesson,
  SchoolQuiz,
  SchoolSystem,
  SchoolTopic,
  SchoolConcept,
  SchoolCase,
  SchoolCaseStage,
  SchoolBook,
  SchoolBookChapter,
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

/** Full-text book for a topic (one per topic), with chapters ordered. */
export async function getSchoolBookByTopic(
  topicId: string
): Promise<{ book: SchoolBook; chapters: SchoolBookChapter[] } | null> {
  const supabase = await createClient();
  const { data: book, error } = await supabase
    .from("school_books")
    .select("*")
    .eq("topic_id", topicId)
    .eq("status", "active")
    .maybeSingle();
  if (error) {
    console.error("Error fetching school book:", error);
    return null;
  }
  if (!book) return null;
  const chapters = await getSchoolBookChapters((book as SchoolBook).id);
  return { book: book as SchoolBook, chapters };
}

/** A single book by id + its chapters. Returns null if not found/active. */
export async function getSchoolBook(
  id: string
): Promise<{ book: SchoolBook; chapters: SchoolBookChapter[] } | null> {
  const supabase = await createClient();
  const { data: book, error } = await supabase
    .from("school_books")
    .select("*")
    .eq("id", id)
    .eq("status", "active")
    .maybeSingle();
  if (error) {
    console.error("Error fetching school book:", error);
    return null;
  }
  if (!book) return null;
  const chapters = await getSchoolBookChapters((book as SchoolBook).id);
  return { book: book as SchoolBook, chapters };
}

async function getSchoolBookChapters(
  bookId: string
): Promise<SchoolBookChapter[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("school_book_chapters")
    .select("*")
    .eq("book_id", bookId)
    .order("sort_order");
  if (error) {
    console.error("Error fetching school book chapters:", error);
    return [];
  }
  return (data as SchoolBookChapter[]) ?? [];
}

/** Map of topic_id → book_id for every active book (for "read book" shortcuts). */
export async function getSchoolBookMap(): Promise<Record<string, string>> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("school_books")
    .select("id, topic_id")
    .eq("status", "active");
  if (error) {
    console.error("Error fetching school book map:", error);
    return {};
  }
  const map: Record<string, string> = {};
  for (const r of (data as { id: string; topic_id: string }[]) ?? []) {
    map[r.topic_id] = r.id;
  }
  return map;
}

export async function getSchoolTopic(id: string): Promise<SchoolTopic | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("school_topics")
    .select("*, school_systems(*)")
    .eq("id", id)
    .maybeSingle();
  if (error) {
    console.error("Error fetching school topic:", error);
    return null;
  }
  return (data as SchoolTopic) ?? null;
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
 * Adaptive: cards from `weak_subjects` (systems the user said they struggle
 * with) are over-sampled.
 */
export async function getMixedFlashcards(opts: {
  userId: string;
  year?: number;
  limit?: number;
  weakSystemIds?: string[];
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

  // Step 2 — fill with fresh (not yet reviewed) cards, biased toward weak systems
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
      .select("*, school_topics!inner(year, system_id)")
      .eq("status", "active")
      .limit(limit * 4);
    if (opts.year) q = q.eq("school_topics.year", opts.year);
    const { data: pool } = await q;
    type RowWithTopic = SchoolFlashcard & { school_topics?: { system_id?: string } };
    const fresh = ((pool as RowWithTopic[]) ?? []).filter(
      (c) => !seenIds.has(c.id)
    );
    // Bias: weak system cards get duplicated weight in shuffling
    const weakSet = new Set(opts.weakSystemIds ?? []);
    const weighted: SchoolFlashcard[] = [];
    for (const c of fresh) {
      const inWeak = weakSet.size && c.school_topics?.system_id && weakSet.has(c.school_topics.system_id);
      weighted.push(c);
      if (inWeak) weighted.push(c); // bias 2x
    }
    weighted.sort(() => Math.random() - 0.5);
    const seen = new Set(cards.map((c) => c.id));
    for (const c of weighted) {
      if (cards.length >= limit) break;
      if (seen.has(c.id)) continue;
      cards.push(c);
      seen.add(c.id);
    }
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

// ────────────────────────────────────────────────────────────────────────────
// Phase 5 — Concepts (cross-subject tags)
// ────────────────────────────────────────────────────────────────────────────

export async function getSchoolConcepts(): Promise<SchoolConcept[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("school_concepts")
    .select("*")
    .order("name_en");
  if (error) {
    console.error("Error fetching concepts:", error);
    return [];
  }
  return (data as SchoolConcept[]) ?? [];
}

export async function getSchoolConceptBySlug(
  slug: string
): Promise<SchoolConcept | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("school_concepts")
    .select("*")
    .eq("slug", slug)
    .maybeSingle();
  if (error) {
    console.error("Error fetching concept:", error);
    return null;
  }
  return (data as SchoolConcept) ?? null;
}

interface LinkedUnit {
  unit_type: "flashcard" | "quiz" | "lesson" | "case_stage";
  unit_id: string;
}

export async function getConceptLinkedUnits(
  conceptId: string
): Promise<LinkedUnit[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("school_concept_links")
    .select("unit_type, unit_id")
    .eq("concept_id", conceptId);
  if (error) return [];
  return (data as LinkedUnit[]) ?? [];
}

export async function getConceptsForUnit(
  unitType: "flashcard" | "quiz" | "lesson" | "case_stage",
  unitId: string
): Promise<SchoolConcept[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("school_concept_links")
    .select("school_concepts(*)")
    .eq("unit_type", unitType)
    .eq("unit_id", unitId);
  if (error || !data) return [];
  type Row = { school_concepts: SchoolConcept | null };
  return (data as Row[])
    .map((r) => r.school_concepts)
    .filter((c): c is SchoolConcept => !!c);
}

// ────────────────────────────────────────────────────────────────────────────
// Phase 5 — Integrated Cases
// ────────────────────────────────────────────────────────────────────────────

export async function getSchoolCases(): Promise<SchoolCase[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("school_cases")
    .select("*, school_systems(*)")
    .eq("status", "active")
    .order("title");
  if (error) {
    console.error("Error fetching cases:", error);
    return [];
  }
  return (data as SchoolCase[]) ?? [];
}

export async function getSchoolCase(id: string): Promise<SchoolCase | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("school_cases")
    .select("*, school_systems(*)")
    .eq("id", id)
    .eq("status", "active")
    .maybeSingle();
  if (error) {
    console.error("Error fetching case:", error);
    return null;
  }
  return (data as SchoolCase) ?? null;
}

export async function getSchoolCaseStages(
  caseId: string
): Promise<SchoolCaseStage[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("school_case_stages")
    .select("*")
    .eq("case_id", caseId)
    .order("stage_order");
  if (error) {
    console.error("Error fetching case stages:", error);
    return [];
  }
  return (data as SchoolCaseStage[]) ?? [];
}

// ────────────────────────────────────────────────────────────────────────────
// Phase 9 — Visual Summaries
// ────────────────────────────────────────────────────────────────────────────

export async function getSchoolVisuals(opts: {
  topicId?: string;
  year?: number;
  limit?: number;
}): Promise<SchoolVisual[]> {
  const supabase = await createClient();
  let query = supabase
    .from("school_visuals")
    .select("*, school_topics!inner(year, name_th, name_en)")
    .eq("status", "active")
    .order("sort_order");
  if (opts.topicId) query = query.eq("topic_id", opts.topicId);
  if (opts.year) query = query.eq("school_topics.year", opts.year);
  if (opts.limit) query = query.limit(opts.limit);
  const { data, error } = await query;
  if (error) {
    console.error("Error fetching school visuals:", error);
    return [];
  }
  return (data as SchoolVisual[]) ?? [];
}

export async function getSchoolVisual(
  id: string
): Promise<SchoolVisual | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("school_visuals")
    .select("*, school_topics(*, school_systems(*))")
    .eq("id", id)
    .eq("status", "active")
    .maybeSingle();
  if (error) {
    console.error("Error fetching school visual:", error);
    return null;
  }
  return (data as SchoolVisual) ?? null;
}

export async function getFlashcardsByIds(
  ids: string[]
): Promise<SchoolFlashcard[]> {
  if (!ids.length) return [];
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("school_flashcards")
    .select("*")
    .in("id", ids)
    .eq("status", "active");
  if (error) {
    console.error("Error fetching flashcards by ids:", error);
    return [];
  }
  // Preserve order of `ids`
  const map = new Map<string, SchoolFlashcard>(
    ((data as SchoolFlashcard[]) ?? []).map((c) => [c.id, c])
  );
  return ids.map((id) => map.get(id)).filter((x): x is SchoolFlashcard => !!x);
}
