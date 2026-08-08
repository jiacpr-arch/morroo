import Link from "next/link";
import { notFound } from "next/navigation";
import { Button } from "@/components/ui/button";
import { ArrowLeft } from "lucide-react";
import {
  getSchoolVisual,
  getFlashcardsByIds,
} from "@/lib/supabase/queries-school";
import VisualDetail from "@/components/school/VisualDetail";
import UpgradeGate from "@/components/school/UpgradeGate";
import { getSchoolAccess } from "@/lib/school/access-server";
import { canOpenTopic } from "@/lib/school/access";

export const dynamic = "force-dynamic";

interface PageProps {
  params: Promise<{ id: string }>;
}

export async function generateMetadata({ params }: PageProps) {
  const { id } = await params;
  const v = await getSchoolVisual(id);
  return {
    title: v ? `${v.title} — Visual Summary` : "Visual Summary",
    description: v?.caption ?? undefined,
  };
}

export default async function VisualPage({ params }: PageProps) {
  const { id } = await params;
  const visual = await getSchoolVisual(id);
  if (!visual) notFound();

  // รูปสรุปมีทั้งโน้ตและ flashcards ของวิชา — ล็อกตามวิชาต้นทางเหมือนบทเรียน
  const { access } = await getSchoolAccess();
  const unlocked = canOpenTopic(access, visual.school_topics);

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
      {unlocked ? (
        <VisualDetail visual={visual} flashcards={flashcards} />
      ) : (
        <UpgradeGate
          title={`รูปสรุปของวิชา “${visual.school_topics?.name_th ?? ""}” อยู่ในแพ็ก School`}
          description="สมัครแล้วเปิดดูรูปสรุป ช็อตโน้ต และ flashcards ของทุกวิชาในชั้นปี"
          fallbackHref="/school/visuals"
          fallbackLabel="กลับไปหน้า Visuals"
        />
      )}
    </div>
  );
}
