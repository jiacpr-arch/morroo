import { createClient } from "./server";
import type { Exam, ExamPart } from "../types";

export async function getExams(): Promise<Exam[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("exams")
    .select("*")
    .eq("status", "published")
    .order("created_at", { ascending: false });

  if (error) {
    console.error("Error fetching exams:", error);
    return [];
  }
  return (data as Exam[]) || [];
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
