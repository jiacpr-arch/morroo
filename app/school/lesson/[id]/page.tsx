import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ArrowLeft, BookOpen } from "lucide-react";
import { notFound } from "next/navigation";
import {
  getSchoolLesson,
  getSchoolQuizzes,
} from "@/lib/supabase/queries-school";
import LessonReader from "@/components/school/LessonReader";
import AskMore from "@/components/school/AskMore";

export const revalidate = 60;

interface PageProps {
  params: Promise<{ id: string }>;
}

export async function generateMetadata({ params }: PageProps) {
  const { id } = await params;
  const lesson = await getSchoolLesson(id);
  return {
    title: lesson?.title
      ? `${lesson.title} — Concept Reader`
      : "Concept Reader — School",
    description: lesson?.title
      ? `อ่านบทเรียน "${lesson.title}" แล้วทำ quiz ทันที`
      : "อ่าน concept แล้วทำ quiz",
  };
}

export default async function LessonPage({ params }: PageProps) {
  const { id } = await params;
  const lesson = await getSchoolLesson(id);
  if (!lesson) notFound();

  const allTopicQuizzes = await getSchoolQuizzes({
    topicId: lesson.topic_id,
    limit: 20,
    randomize: true,
  });
  const quizzes = allTopicQuizzes
    .filter((q) => q.layer === lesson.layer)
    .slice(0, 10);

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <Link href="/school">
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> กลับ
        </Button>
      </Link>
      <div className="mb-4 flex items-center gap-2">
        <Badge className="bg-teal-100 text-teal-700">Concept Reader</Badge>
        <Badge variant="outline">{lesson.estimated_min} นาที</Badge>
        <Badge variant="outline">{lesson.layer}</Badge>
      </div>
      <h1 className="text-3xl font-bold mb-6 flex items-center gap-2">
        <BookOpen className="h-7 w-7 text-teal-600" /> {lesson.title}
      </h1>

      <LessonReader lesson={lesson} miniQuizzes={quizzes} />

      <div className="mt-6">
        <AskMore topicId={lesson.topic_id} />
      </div>

      {lesson.source && (
        <p className="text-xs text-muted-foreground italic mt-6">
          ที่มา: {lesson.source}
        </p>
      )}
    </div>
  );
}
