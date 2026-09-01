import { supabase } from "./supabase";

export interface AssessmentChoice {
  id: string;
  text: string;
}

export interface AssessmentQuestion {
  id: string;
  topic: string;
  difficulty: string;
  question: string;
  choices: AssessmentChoice[];
  correctId: string;
  explanation: string;
  reference: string | null;
}

export interface AssessmentSet {
  id: string;
  title: string;
  selectionMode: string; // "set" (use all) | "pool" (sample by difficulty)
  selectionConfig: Record<string, number> | null;
}

function shuffle<T>(arr: T[]): T[] {
  const a = [...arr];
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}

interface QuestionRow {
  id: string;
  topic: string;
  difficulty: string;
  question: string;
  choices: unknown;
  correct_id: string;
  explanation: string | null;
  reference: string | null;
}

function mapQuestion(row: QuestionRow): AssessmentQuestion {
  return {
    id: row.id,
    topic: row.topic,
    difficulty: row.difficulty,
    question: row.question,
    choices: Array.isArray(row.choices) ? (row.choices as AssessmentChoice[]) : [],
    correctId: row.correct_id,
    explanation: row.explanation ?? "",
    reference: row.reference ?? null,
  };
}

export async function getAssessmentSets(): Promise<AssessmentSet[]> {
  try {
    const { data, error } = await supabase
      .from("acls_assessment_sets")
      .select("id, title, sort_order, active, selection_mode, selection_config")
      .eq("active", true)
      .order("sort_order");
    if (error) throw error;
    return (data ?? []).map((s) => ({
      id: s.id as string,
      title: (s.title as string) ?? s.id,
      selectionMode: (s.selection_mode as string) ?? "set",
      selectionConfig: (s.selection_config as Record<string, number> | null) ?? null,
    }));
  } catch {
    return [];
  }
}

// Returns the set plus its questions. For "pool" sets, samples N per difficulty
// (per selection_config) and shuffles — call from a dynamic (per-request) page
// so each attempt gets a fresh draw.
export async function getExamQuestions(
  setId: string
): Promise<{ set: AssessmentSet | null; questions: AssessmentQuestion[] }> {
  const sets = await getAssessmentSets();
  const set = sets.find((s) => s.id === setId) ?? null;
  if (!set) return { set: null, questions: [] };

  try {
    const { data, error } = await supabase
      .from("acls_assessment_questions")
      .select("id, topic, difficulty, question, choices, correct_id, explanation, reference, q_number")
      .eq("set_id", setId)
      .eq("active", true)
      .order("q_number");
    if (error) throw error;
    const all = (data ?? []).map((r) => mapQuestion(r as QuestionRow));

    if (set.selectionMode === "pool" && set.selectionConfig) {
      const picked: AssessmentQuestion[] = [];
      for (const [difficulty, n] of Object.entries(set.selectionConfig)) {
        const bucket = shuffle(all.filter((q) => q.difficulty === difficulty));
        picked.push(...bucket.slice(0, n));
      }
      return { set, questions: shuffle(picked) };
    }
    return { set, questions: all };
  } catch {
    return { set, questions: [] };
  }
}
