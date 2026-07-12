import { notFound } from "next/navigation";
import { getExam, getExamParts } from "@/lib/supabase/queries";
import AnswerClient from "./AnswerClient";
import type { Metadata } from "next";

export async function generateMetadata({
  params,
}: {
  params: Promise<{ id: string }>;
}): Promise<Metadata> {
  const { id } = await params;
  const exam = await getExam(id);
  if (!exam) return { title: "ไม่พบเฉลย" };
  return {
    title: `เฉลย: ${exam.title}`,
    description: `เฉลยข้อสอบ MEQ: ${exam.title} พร้อม Key Points`,
  };
}

export default async function AnswerPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const exam = await getExam(id);
  if (!exam) notFound();

  const parts = await getExamParts(id);

  return <AnswerClient exam={exam} parts={parts} />;
}
