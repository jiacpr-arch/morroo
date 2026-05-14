import { createClient } from "./server";
import type {
  BoardSpecialty,
  BoardExamBlueprint,
  BoardTopicCategory,
  BlueprintWithTopics,
} from "../types-board";
import type { McqSubject } from "../types-mcq";

export async function getBoardSpecialties(): Promise<BoardSpecialty[]> {
  const supabase = await createClient();
  // Returns both published and unpublished — landing shows "เร็วๆนี้" badge for !is_published
  const { data, error } = await supabase
    .from("board_specialties")
    .select("*")
    .eq("is_active", true)
    .order("display_order", { ascending: true });
  if (error) {
    console.error("Error fetching board specialties:", error);
    return [];
  }
  return (data as BoardSpecialty[]) || [];
}

export async function getBoardSpecialty(
  slug: string
): Promise<BoardSpecialty | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("board_specialties")
    .select("*")
    .eq("slug", slug)
    .eq("is_active", true)
    .single();
  if (error) return null;
  return data as BoardSpecialty;
}

export async function getBoardBlueprint(
  specialtySlug: string,
  examYear?: number
): Promise<BlueprintWithTopics[]> {
  const supabase = await createClient();
  let bpQuery = supabase
    .from("board_exam_blueprints")
    .select("*")
    .eq("specialty_slug", specialtySlug)
    .order("display_order", { ascending: true });
  if (examYear) bpQuery = bpQuery.eq("exam_year", examYear);

  const { data: blueprints, error } = await bpQuery;
  if (error || !blueprints || blueprints.length === 0) return [];

  // Use the latest year if examYear was not specified
  const latestYear = examYear
    ? examYear
    : Math.max(...blueprints.map((b: BoardExamBlueprint) => b.exam_year));
  const filtered = (blueprints as BoardExamBlueprint[]).filter(
    (b) => b.exam_year === latestYear
  );
  if (filtered.length === 0) return [];

  const ids = filtered.map((b) => b.id);
  const { data: topics } = await supabase
    .from("board_topic_categories")
    .select("*")
    .in("blueprint_id", ids)
    .order("display_order", { ascending: true });

  const topicsByBp = new Map<string, BoardTopicCategory[]>();
  for (const t of (topics as BoardTopicCategory[]) ?? []) {
    const list = topicsByBp.get(t.blueprint_id) ?? [];
    list.push(t);
    topicsByBp.set(t.blueprint_id, list);
  }

  return filtered.map((bp) => ({
    ...bp,
    topics: topicsByBp.get(bp.id) ?? [],
  }));
}

export async function getBoardSubjects(
  specialtySlug: string
): Promise<McqSubject[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("mcq_subjects")
    .select("*")
    .eq("audience", "board")
    .eq("board_specialty", specialtySlug)
    .order("name_th", { ascending: true });
  if (error) {
    console.error("Error fetching board subjects:", error);
    return [];
  }
  return (data as McqSubject[]) || [];
}

export async function getBoardQuestionStats(
  specialtySlug: string
): Promise<{ total: number; bySection: Record<string, number> }> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("mcq_questions")
    .select("board_section")
    .eq("status", "active")
    .eq("audience", "board")
    .eq("board_specialty", specialtySlug);
  if (error || !data) return { total: 0, bySection: {} };
  const bySection: Record<string, number> = {};
  for (const row of data as Array<{ board_section: string | null }>) {
    const key = row.board_section ?? "_unsectioned";
    bySection[key] = (bySection[key] || 0) + 1;
  }
  return { total: data.length, bySection };
}
