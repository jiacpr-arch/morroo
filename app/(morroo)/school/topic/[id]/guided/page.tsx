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
import { hasSchoolAccess } from "@/lib/membership";

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
  const isPremium = hasSchoolAccess(profile);

  const [lessons, cards, quizzes, masteryMap] = await Promise.all([
    getSchoolLessons({ topicId: id }),
    getSchoolFlashcards({ topicId: id, limit: 30 }),
    getSchoolQuizzes({ topicId: id, limit: 20 }),
    getSchoolMasteryByTopic(user.id),
  ]);

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

      <GuidedRunner
        topicId={id}
        lessons={lessons}
        cards={cards}
        quizzes={quizzes}
        initialMastery={masteryMap[id] ?? { seen: 0, correct: 0, pct: 0 }}
        isPremium={isPremium}
      />
    </div>
  );
}
