import { createClient } from "./client";
import type { McqChoice } from "../types-mcq";

// Admin-only MCQ CRUD mutations (browser client, role checked server-side by RLS)

export interface McqQuestionInput {
  subject_id: string;
  exam_type: "NL1" | "NL2";
  exam_source?: string | null;
  question_number?: number | null;
  scenario: string;
  choices: McqChoice[];
  correct_answer: string;
  explanation?: string | null;
  difficulty: "easy" | "medium" | "hard";
  topic?: string | null;
  status: "active" | "review" | "disabled";
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
