import { createClient } from "./server";
import type { McqSubject, McqQuestion } from "../types-mcq";

export async function getMcqSubjects(): Promise<McqSubject[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("mcq_subjects")
    .select("*")
    .order("name_th", { ascending: true });

  if (error) {
    console.error("Error fetching MCQ subjects:", error);
    return [];
  }
  return (data as McqSubject[]) || [];
}

export async function getMcqQuestions(options?: {
  subjectId?: string;
  examType?: string;
  limit?: number;
  randomize?: boolean;
}): Promise<McqQuestion[]> {
  const supabase = await createClient();
  let query = supabase
    .from("mcq_questions")
    .select("*, mcq_subjects(name, name_th, icon)")
    .eq("status", "active");

  if (options?.subjectId) {
    query = query.eq("subject_id", options.subjectId);
  }
  if (options?.examType) {
    query = query.eq("exam_type", options.examType);
  }

  const limit = options?.limit || 50;
  query = query.limit(limit);

  const { data, error } = await query;

  if (error) {
    console.error("Error fetching MCQ questions:", error);
    return [];
  }

  let questions = (data as McqQuestion[]) || [];

  // Shuffle if randomize
  if (options?.randomize) {
    questions = questions.sort(() => Math.random() - 0.5);
  }

  return questions;
}

export async function getMcqQuestion(id: string): Promise<McqQuestion | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("mcq_questions")
    .select("*, mcq_subjects(name, name_th, icon)")
    .eq("id", id)
    .eq("status", "active")
    .single();

  if (error) {
    console.error("Error fetching MCQ question:", error);
    return null;
  }
  return data as McqQuestion;
}

export async function getFreeAttemptsCount(
  userId: string,
  subjectId?: string
): Promise<number> {
  const supabase = await createClient();
  let query = supabase
    .from("mcq_attempts")
    .select("id", { count: "exact", head: true })
    .eq("user_id", userId);

  if (subjectId) {
    // Join with mcq_questions to filter by subject
    const { data: qids } = await supabase
      .from("mcq_questions")
      .select("id")
      .eq("subject_id", subjectId)
      .eq("status", "active");

    const ids = (qids ?? []).map((q: { id: string }) => q.id);
    if (ids.length === 0) return 0;
    query = query.in("question_id", ids);
  }

  const { count } = await query;
  return count ?? 0;
}

export async function getMcqSubjectCounts(): Promise<Record<string, number>> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("mcq_questions")
    .select("subject_id")
    .eq("status", "active");

  if (error || !data) return {};

  const counts: Record<string, number> = {};
  for (const row of data) {
    counts[row.subject_id] = (counts[row.subject_id] || 0) + 1;
  }
  return counts;
}

/** Get count + metadata + difficulty breakdown of AI-generated questions added today */
export async function getTodayNewQuestions(): Promise<{
  count: number;
  difficulty: { easy: number; medium: number; hard: number };
  subjectId: string | null;
  subjectNameTh: string | null;
  subjectIcon: string | null;
}> {
  const supabase = await createClient();
  const todayStart = new Date();
  todayStart.setHours(0, 0, 0, 0);

  const { data, error } = await supabase
    .from("mcq_questions")
    .select("subject_id, difficulty, mcq_subjects(name_th, icon)")
    .eq("status", "active")
    .eq("exam_source", "AI-generated-daily")
    .gte("created_at", todayStart.toISOString());

  if (error || !data || data.length === 0) {
    return {
      count: 0,
      difficulty: { easy: 0, medium: 0, hard: 0 },
      subjectId: null,
      subjectNameTh: null,
      subjectIcon: null,
    };
  }

  // Count by difficulty
  const difficulty = { easy: 0, medium: 0, hard: 0 };
  for (const row of data) {
    const d = (row as { difficulty: string }).difficulty;
    if (d === "easy") difficulty.easy++;
    else if (d === "hard") difficulty.hard++;
    else difficulty.medium++;
  }

  const first = data[0] as McqQuestion;
  const subject = first.mcq_subjects;

  return {
    count: data.length,
    difficulty,
    subjectId: first.subject_id,
    subjectNameTh: subject?.name_th ?? null,
    subjectIcon: subject?.icon ?? null,
  };
}
