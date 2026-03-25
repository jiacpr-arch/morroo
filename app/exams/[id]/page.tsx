import { notFound } from "next/navigation";
import ExamPlayer from "@/components/ExamPlayer";
import { getExam, getExamParts } from "@/lib/supabase/queries";
import type { Metadata } from "next";

export async function generateMetadata({
  params,
}: {
  params: Promise<{ id: string }>;
}): Promise<Metadata> {
  const { id } = await params;
  const exam = await getExam(id);
  if (!exam) return { title: "ไม่พบข้อสอบ" };
  return {
    title: exam.title,
    description: `ข้อสอบ MEQ: ${exam.title} - ${exam.category} - 6 ตอน`,
  };
}

export default async function ExamPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const exam = await getExam(id);
  if (!exam) notFound();

  const parts = await getExamParts(id);

  return <ExamPlayer exam={exam} parts={parts} />;
}
