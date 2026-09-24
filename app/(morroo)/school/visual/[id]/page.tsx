import Link from "next/link";
import { notFound } from "next/navigation";
import { Button } from "@/components/ui/button";
import { ArrowLeft } from "lucide-react";
import {
  getSchoolVisual,
  getSchoolLessons,
  getFlashcardsByIds,
} from "@/lib/supabase/queries-school";
import VisualDetail from "@/components/school/VisualDetail";
import TopicUpsell from "@/components/school/TopicUpsell";
import { isFreeSampleLesson } from "@/lib/school/topic-access";
import { canOpenSchoolTopic } from "@/lib/school/topic-access-server";
import { isUuid } from "@/lib/school/ids";

export const dynamic = "force-dynamic";

interface PageProps {
  params: Promise<{ id: string }>;
}

export async function generateMetadata({ params }: PageProps) {
  const { id } = await params;
  if (!isUuid(id)) notFound();
  const v = await getSchoolVisual(id);
  return {
    title: v ? `${v.title} — Visual Summary` : "Visual Summary",
    description: v?.caption ?? undefined,
  };
}

export default async function VisualPage({ params }: PageProps) {
  const { id } = await params;
  // Reject non-uuid params (e.g. a literal "null") before touching the DB.
  if (!isUuid(id)) notFound();
  const visual = await getSchoolVisual(id);
  if (!visual) notFound();

  // รูปสรุปมีทั้งโน้ตและ flashcards ของวิชา — ล็อกตามวิชาต้นทาง ยกเว้นรูปที่
  // ผูกกับบทตัวอย่างฟรี (หน้าบทนั้นก็แสดงรูปนี้อยู่แล้ว)
  const topic = visual.school_topics ?? null;
  let unlocked = true;
  if (topic) {
    unlocked = await canOpenSchoolTopic(topic);
    if (!unlocked && visual.lesson_id) {
      const lessons = await getSchoolLessons({ topicId: topic.id });
      unlocked = isFreeSampleLesson(
        visual.lesson_id,
        lessons.map((l) => l.id)
      );
    }
  }

  const flashcards = unlocked
    ? await getFlashcardsByIds(visual.linked_flashcard_ids ?? [])
    : [];

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6">
      <Link href="/school/visuals">
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> Visuals
        </Button>
      </Link>
      {unlocked || !topic ? (
        <VisualDetail visual={visual} flashcards={flashcards} />
      ) : (
        <>
          <h1 className="text-2xl font-bold mb-2">{visual.title}</h1>
          <p className="text-sm text-muted-foreground mb-6">
            รูปสรุปนี้อยู่ในวิชา “{topic.name_th}” — ปลดล็อกวิชาเพื่อดูรูป ช็อตโน้ต และ
            flashcards ที่ผูกไว้
          </p>
          <TopicUpsell topic={topic} title="ปลดล็อกรูปสรุปและทุกบทของวิชา" />
        </>
      )}
    </div>
  );
}
