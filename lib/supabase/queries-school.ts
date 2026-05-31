import { createClient } from "./server";
import type {
  SchoolFlashcard,
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
