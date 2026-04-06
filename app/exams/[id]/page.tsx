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
  const title = `${exam.title} — ข้อสอบ MEQ ${exam.category}`;
  const description = `ฝึกทำข้อสอบ MEQ แบบ Progressive Case: ${exam.title} สาขา${exam.category} 6 ตอน พร้อมเฉลยละเอียดและ AI ตรวจคำตอบ`;
  return {
    title,
    description,
    alternates: { canonical: `https://www.morroo.com/exams/${id}` },
    openGraph: {
      title,
      description,
      url: `https://www.morroo.com/exams/${id}`,
    },
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
