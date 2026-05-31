import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ArrowLeft, BookOpen } from "lucide-react";
import { notFound } from "next/navigation";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import { getSchoolLesson, getSchoolQuizzes } from "@/lib/supabase/queries-school";
import BiteQuiz from "@/components/school/BiteQuiz";

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
    limit: 5,
    randomize: true,
  });
  const quizzes = allTopicQuizzes.filter((q) => q.layer === lesson.layer).slice(0, 5);

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

      <article className="prose prose-slate dark:prose-invert max-w-none mb-10">
        <ReactMarkdown remarkPlugins={[remarkGfm]}>{lesson.body_md}</ReactMarkdown>
      </article>

      {lesson.source && (
        <p className="text-xs text-muted-foreground italic mb-8">
          ที่มา: {lesson.source}
        </p>
      )}

      {quizzes.length > 0 && (
        <div className="border-t pt-8">
          <h2 className="text-xl font-bold mb-4">เช็คความเข้าใจ</h2>
          <p className="text-sm text-muted-foreground mb-4">
            Retrieval practice — ดึงสิ่งที่เพิ่งอ่านออกมาทดสอบความเข้าใจ
          </p>
          <BiteQuiz quizzes={quizzes} isPremium freeLimit={5} />
        </div>
      )}
    </div>
  );
}
