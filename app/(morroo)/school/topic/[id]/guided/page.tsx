import Link from "next/link";
import { notFound, redirect } from "next/navigation";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ArrowLeft, Sparkles } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import {
  getSchoolTopic,
  getSchoolLessons,
  getSchoolFlashcards,
  getSchoolQuizzes,
  getSchoolMasteryByTopic,
} from "@/lib/supabase/queries-school";
import GuidedRunner from "@/components/school/GuidedRunner";
import UpgradeGate from "@/components/school/UpgradeGate";
import { canOpenTopic, schoolAccessFor } from "@/lib/school/access";

export const dynamic = "force-dynamic";

interface PageProps {
  params: Promise<{ id: string }>;
}

export const metadata = {
  title: "Guided Sequence — School",
  description: "Bloom hierarchy walk-through: Read → Practice → Test → Mastery",
};

export default async function GuidedPage({ params }: PageProps) {
  const { id } = await params;
  const topic = await getSchoolTopic(id);
  if (!topic) notFound();

  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect(`/login?next=/school/topic/${id}/guided`);

  const { data: profile } = await supabase
    .from("profiles")
    .select("membership_type, membership_expires_at")
    .eq("id", user.id)
    .maybeSingle();
  const access = schoolAccessFor(profile);
  const unlocked = canOpenTopic(access, topic);

  const empty = {
    lessons: [] as Awaited<ReturnType<typeof getSchoolLessons>>,
    cards: [] as Awaited<ReturnType<typeof getSchoolFlashcards>>,
    quizzes: [] as Awaited<ReturnType<typeof getSchoolQuizzes>>,
    masteryMap: {} as Awaited<ReturnType<typeof getSchoolMasteryByTopic>>,
  };
  const { lessons, cards, quizzes, masteryMap } = unlocked
    ? await Promise.all([
        getSchoolLessons({ topicId: id }),
        getSchoolFlashcards({ topicId: id, limit: 30 }),
        getSchoolQuizzes({ topicId: id, limit: 20 }),
        getSchoolMasteryByTopic(user.id),
      ]).then(([lessons, cards, quizzes, masteryMap]) => ({
        lessons,
        cards,
        quizzes,
        masteryMap,
      }))
    : empty;

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6">
      <Link href={`/school/topic/${id}`}>
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> กลับ
        </Button>
      </Link>
      <div className="mb-4 flex items-center gap-2">
        <Badge className="bg-violet-100 text-violet-700">Guided Sequence</Badge>
        <Badge variant="outline">{topic.name_th}</Badge>
      </div>
      <h1 className="text-2xl font-bold mb-1 flex items-center gap-2">
        <Sparkles className="h-6 w-6 text-violet-600" /> Bloom hierarchy walk-through
      </h1>
      <p className="text-sm text-muted-foreground mb-6">
        อ่าน → ฝึก → ทดสอบ → mastery check
      </p>

      {unlocked ? (
        <GuidedRunner
          topicId={id}
          lessons={lessons}
          cards={cards}
          quizzes={quizzes}
          initialMastery={masteryMap[id] ?? { seen: 0, correct: 0, pct: 0 }}
          isPremium={access.isPremium}
        />
      ) : (
        <UpgradeGate
          title="วิชานี้อยู่ในแพ็ก School"
          description="Guided Sequence พาเดินจากอ่าน → ฝึก → ทดสอบ ทีละบท — สมัครแพ็ก School เพื่อเปิดใช้กับทุกวิชาในชั้นปี"
          fallbackHref={`/school/topic/${id}`}
          fallbackLabel="กลับหน้าวิชา"
        />
      )}
    </div>
  );
}
