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
