import type { Metadata } from "next";
import { faUrl } from "@/lib/firstaid/urls";
import { lessons, lessonsById } from "@/lib/firstaid/content/lessons";
import LessonReaderClient from "./LessonReaderClient";

export function generateStaticParams() {
  return (lessons as Array<{ id: string }>).map((l) => ({ lessonId: l.id }));
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ lessonId: string }>;
}): Promise<Metadata> {
  const { lessonId } = await params;
  const lesson = (lessonsById as Record<string, any>)[lessonId];
  return {
    title: lesson
      ? `บทที่ ${lesson.order}: ${lesson.title} | ปฐมพยาบาลเบื้องต้น — Jia Training Center`
      : "ไม่พบบทเรียน | ปฐมพยาบาลเบื้องต้น",
    alternates: { canonical: faUrl(`/learn/${lessonId}`) },
  };
}

export default async function Page({
  params,
}: {
  params: Promise<{ lessonId: string }>;
}) {
  const { lessonId } = await params;
  return <LessonReaderClient lessonId={lessonId} />;
}
