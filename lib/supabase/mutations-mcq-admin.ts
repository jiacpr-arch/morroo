import { createClient } from "./client";
import type { McqChoice, McqChoiceExplanation } from "../types-mcq";

// Admin-only MCQ CRUD mutations (browser client, role checked server-side by RLS)

export interface McqDetailedExplanation {
  summary: string;
  reason: string;
  choices: McqChoiceExplanation[];
  key_takeaway: string;
}

export interface McqQuestionInput {
  subject_id: string;
  // Student-only — null for board questions
  exam_type?: "NL1" | "NL2" | null;
  exam_source?: string | null;
  question_number?: number | null;
  scenario: string;
  choices: McqChoice[];
  correct_answer: string;
  explanation?: string | null;
  // Per-choice "why" reasoning shown on the answer pages (jsonb column).
  detailed_explanation?: McqDetailedExplanation | null;
  is_ai_enhanced?: boolean;
  ai_notes?: string | null;
  difficulty: "easy" | "medium" | "hard";
  topic?: string | null;
  status: "active" | "review" | "disabled";
  // Board fields — set when audience='board'
  audience?: "student" | "board";
  board_specialty?: string | null;
  board_subspecialty?: string | null;
  board_section?: string | null;
  board_topic?: string | null;
  board_age_group?: "peds" | "adult" | "mixed" | null;
  board_level?: number | null;
  reference_source?: string | null;
}

export async function createMcqQuestion(
  data: McqQuestionInput
): Promise<{ id: string } | null> {
  const supabase = createClient();
  const { data: row, error } = await supabase
    .from("mcq_questions")
    .insert(data)
    .select("id")
    .single();
  if (error) {
    console.error("Error creating MCQ question:", error);
    return null;
  }
  return row as { id: string };
}

export async function updateMcqQuestion(
  id: string,
  data: Partial<McqQuestionInput>
): Promise<boolean> {
  const supabase = createClient();
  const { error } = await supabase
    .from("mcq_questions")
    .update(data)
    .eq("id", id);
  if (error) {
    console.error("Error updating MCQ question:", error);
    return false;
  }
  return true;
}

export async function updateMcqQuestionStatus(
  id: string,
  status: "active" | "review" | "disabled"
): Promise<boolean> {
  const supabase = createClient();
  const { error } = await supabase
    .from("mcq_questions")
    .update({ status })
    .eq("id", id);
  if (error) {
    console.error("Error updating MCQ status:", error);
    return false;
  }
  return true;
}

export async function deleteMcqQuestion(id: string): Promise<boolean> {
  // Soft delete: set status = 'disabled'
  return updateMcqQuestionStatus(id, "disabled");
}

export async function bulkUpdateMcqQuestionStatus(
  ids: string[],
  status: "active" | "review" | "disabled"
): Promise<{ ok: number; failed: number }> {
  if (ids.length === 0) return { ok: 0, failed: 0 };
  const supabase = createClient();
  const { error, count } = await supabase
    .from("mcq_questions")
    .update({ status }, { count: "exact" })
    .in("id", ids);
  if (error) {
    console.error("Bulk status update failed:", error);
    return { ok: 0, failed: ids.length };
  }
  const ok = count ?? ids.length;
  return { ok, failed: ids.length - ok };
}
