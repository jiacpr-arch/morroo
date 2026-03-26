import { createClient } from "./client";
import type { McqAttempt, McqSession } from "../types-mcq";

// --- Client-side save functions (called from browser components) ---

export async function saveMcqAttempt(attempt: {
  user_id: string;
  question_id: string;
  selected_answer: string;
  is_correct: boolean;
  time_spent_seconds?: number | null;
  mode: "practice" | "mock";
  session_id?: string | null;
}): Promise<McqAttempt | null> {
  const supabase = createClient();
  const { data, error } = await supabase
    .from("mcq_attempts")
    .insert({
      user_id: attempt.user_id,
      question_id: attempt.question_id,
      selected_answer: attempt.selected_answer,
      is_correct: attempt.is_correct,
      time_spent_seconds: attempt.time_spent_seconds ?? null,
      mode: attempt.mode,
      session_id: attempt.session_id ?? null,
    })
    .select()
    .single();

  if (error) {
    console.error("Error saving MCQ attempt:", error);
    return null;
  }
  return data as McqAttempt;
}

export async function createMcqSession(session: {
  user_id: string;
  mode: "practice" | "mock";
  exam_type: "NL1" | "NL2";
  subject_id?: string | null;
  total_questions: number;
  time_limit_minutes?: number | null;
}): Promise<McqSession | null> {
  const supabase = createClient();
  const { data, error } = await supabase
    .from("mcq_sessions")
    .insert({
      user_id: session.user_id,
      mode: session.mode,
      exam_type: session.exam_type,
      subject_id: session.subject_id ?? null,
      total_questions: session.total_questions,
      correct_count: 0,
      time_limit_minutes: session.time_limit_minutes ?? null,
    })
    .select()
    .single();

  if (error) {
    console.error("Error creating MCQ session:", error);
    return null;
  }
  return data as McqSession;
}

export async function updateMcqSession(
  id: string,
  updates: {
    correct_count?: number;
    completed_at?: string;
  }
): Promise<McqSession | null> {
  const supabase = createClient();
  const { data, error } = await supabase
    .from("mcq_sessions")
    .update(updates)
    .eq("id", id)
    .select()
    .single();

  if (error) {
    console.error("Error updating MCQ session:", error);
    return null;
  }
  return data as McqSession;
}
