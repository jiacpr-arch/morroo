import { createClient } from "./server";
import type { Exam, ExamPart } from "../types";

export async function getExams(): Promise<Exam[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("exams")
    .select("*")
    .eq("status", "published")
    .order("publish_date", { ascending: true });

  if (error) {
    console.error("Error fetching exams:", error);
    return [];
  }
  return (data as Exam[]) || [];
}

// Sort exams: newly available first, then coming soon, then older
export function sortExamsAvailableFirst(exams: Exam[], partCounts: Record<string, number>): Exam[] {
  const now = new Date();
  const threeDaysAgo = now.getTime() - 3 * 24 * 60 * 60 * 1000;
  return [...exams].sort((a, b) => {
    const aComingSoon = (partCounts[a.id] || 0) === 0 || (a.publish_date && new Date(a.publish_date + "T00:00:00") > now);
    const bComingSoon = (partCounts[b.id] || 0) === 0 || (b.publish_date && new Date(b.publish_date + "T00:00:00") > now);
    const aNew = !aComingSoon && new Date(a.created_at).getTime() > threeDaysAgo;
    const bNew = !bComingSoon && new Date(b.created_at).getTime() > threeDaysAgo;

    // 1. Newly available (within 3 days, playable) first
    if (aNew && !bNew) return -1;
    if (!aNew && bNew) return 1;

    // 2. Coming soon second
    if (aComingSoon && !bComingSoon) return -1;
    if (!aComingSoon && bComingSoon) return 1;

    // 3. Within same group: newest first
    const aDate = new Date(a.created_at);
    const bDate = new Date(b.created_at);
    return bDate.getTime() - aDate.getTime();
  });
}

export async function getExam(id: string): Promise<Exam | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("exams")
    .select("*")
    .eq("id", id)
    .eq("status", "published")
    .single();

  if (error) {
    console.error("Error fetching exam:", error);
    return null;
  }
  return data as Exam;
}

export async function getExamParts(examId: string): Promise<ExamPart[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("exam_parts")
    .select("*")
    .eq("exam_id", examId)
    .order("part_number", { ascending: true });

  if (error) {
    console.error("Error fetching exam parts:", error);
    return [];
  }
  return (data as ExamPart[]) || [];
}

export async function getAllExams(): Promise<Exam[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("exams")
    .select("*")
    .order("created_at", { ascending: false });

  if (error) {
    console.error("Error fetching all exams:", error);
    return [];
  }
  return (data as Exam[]) || [];
}

export async function getExamPartCounts(): Promise<Record<string, number>> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("exam_parts")
    .select("exam_id");

  if (error || !data) return {};

  const counts: Record<string, number> = {};
  for (const row of data) {
    counts[row.exam_id] = (counts[row.exam_id] || 0) + 1;
  }
  return counts;
}

export async function getExamWithParts(id: string): Promise<{ exam: Exam; parts: ExamPart[] } | null> {
  const [exam, parts] = await Promise.all([getExam(id), getExamParts(id)]);
  if (!exam) return null;
  return { exam, parts };
}
