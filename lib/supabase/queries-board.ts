import { createClient } from "./server";
import type {
  BoardSpecialty,
  BoardExamBlueprint,
  BoardTopicCategory,
  BlueprintWithTopics,
  BoardSpecialtyMetrics,
  BoardMetricRow,
} from "../types-board";
import { buildBoardMetricsMap } from "../types-board";
import type { McqSubject, McqQuestion } from "../types-mcq";

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

/** Live exam-bank counts for every active specialty, keyed by slug.
 *  Powers the transparency badges customers see on /board and /board/[slug].
 *  Backed by the `board_specialty_metrics()` SECURITY DEFINER RPC so we can
 *  count `review` questions (which RLS hides from non-admins). Returns an
 *  empty map (callers fall back to the static count) if the RPC is missing —
 *  e.g. before the migration has been applied. */
export async function getBoardSpecialtyMetrics(): Promise<
  Record<string, BoardSpecialtyMetrics>
> {
  const supabase = await createClient();
  const { data, error } = await supabase.rpc("board_specialty_metrics");
  if (error || !data) {
    if (error) console.error("Error fetching board specialty metrics:", error);
    return {};
  }
  return buildBoardMetricsMap(data as BoardMetricRow[]);
}

export interface BoardMockSample {
  questions: McqQuestion[];
  totalTarget: number;
  totalAvailable: number;
  bySection: Array<{
    section_code: string;
    section_label_th: string;
    target: number;
    available: number;
    topics: Array<{
      slug: string;
      name_th: string;
      target: number;
      available: number;
    }>;
  }>;
}

/** Sample MCQ questions for a specialty according to the latest blueprint's
 *  section/topic distribution. Falls back gracefully when the DB has fewer
 *  questions than the blueprint targets (returns whatever is available and
 *  reports the gap so the UI can warn the user). */
export async function sampleBoardMock(
  specialtySlug: string
): Promise<BoardMockSample> {
  const supabase = await createClient();
  const blueprints = await getBoardBlueprint(specialtySlug);
  if (blueprints.length === 0) {
    return { questions: [], totalTarget: 0, totalAvailable: 0, bySection: [] };
  }

  const collected: McqQuestion[] = [];
  const seenIds = new Set<string>();
  const bySection: BoardMockSample["bySection"] = [];
  let totalTarget = 0;

  for (const bp of blueprints) {
    const sectionStats = {
      section_code: bp.section_code,
      section_label_th: bp.section_label_th,
      target: bp.question_count,
      available: 0,
      topics: [] as BoardMockSample["bySection"][number]["topics"],
    };
    totalTarget += bp.question_count;

    if (bp.topics.length === 0) {
      // No topic_categories — sample at section level
      const { data } = await supabase
        .from("mcq_questions")
        .select("*, mcq_subjects(name, name_th, icon)")
        .eq("status", "active")
        .eq("audience", "board")
        .eq("board_specialty", specialtySlug)
        .eq("board_section", bp.section_code)
        .limit(Math.max(bp.question_count * 4, 50));
      const rows = (data as McqQuestion[] | null) ?? [];
      const shuffled = rows.sort(() => Math.random() - 0.5).slice(0, bp.question_count);
      for (const q of shuffled) {
        if (!seenIds.has(q.id)) {
          seenIds.add(q.id);
          collected.push(q);
        }
      }
      sectionStats.available = shuffled.length;
    } else {
      // Sample per topic according to blueprint counts
      for (const topic of bp.topics) {
        const target = topic.total_count;
        const { data } = await supabase
          .from("mcq_questions")
          .select("*, mcq_subjects(name, name_th, icon)")
          .eq("status", "active")
          .eq("audience", "board")
          .eq("board_specialty", specialtySlug)
          .eq("board_section", bp.section_code)
          .eq("board_topic", topic.slug)
          .limit(Math.max(target * 4, 20));
        const rows = (data as McqQuestion[] | null) ?? [];
        const shuffled = rows.sort(() => Math.random() - 0.5).slice(0, target);
        for (const q of shuffled) {
          if (!seenIds.has(q.id)) {
            seenIds.add(q.id);
            collected.push(q);
          }
        }
        sectionStats.available += shuffled.length;
        sectionStats.topics.push({
          slug: topic.slug,
          name_th: topic.name_th,
          target,
          available: shuffled.length,
        });
      }
    }
    bySection.push(sectionStats);
  }

  // Final shuffle so adjacent questions aren't all from the same topic
  const finalQuestions = collected.sort(() => Math.random() - 0.5);

  return {
    questions: finalQuestions,
    totalTarget,
    totalAvailable: finalQuestions.length,
    bySection,
  };
}
