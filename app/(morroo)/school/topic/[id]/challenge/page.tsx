import Link from "next/link";
import { notFound, redirect } from "next/navigation";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ArrowLeft, Zap } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import { getSchoolTopic, getSchoolQuizzes } from "@/lib/supabase/queries-school";
import ChallengeRunner from "@/components/school/ChallengeRunner";

export const dynamic = "force-dynamic";

interface PageProps {
  params: Promise<{ id: string }>;
}

export const metadata = {
  title: "Challenge Mode — School",
  description: "ข้อสอบยาก — Bloom level analysis/synthesis",
};

export default async function ChallengePage({ params }: PageProps) {
  const { id } = await params;
  const topic = await getSchoolTopic(id);
  if (!topic) notFound();

  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect(`/login?next=/school/topic/${id}/challenge`);

  // Pull hard-difficulty quizzes; fall back to all if scarce
  const allHard = await getSchoolQuizzes({
    topicId: id,
    limit: 30,
    randomize: true,
  });
  const hard = allHard.filter((q) => q.difficulty === "hard").slice(0, 5);
  const pool = hard.length >= 3 ? hard : allHard.slice(0, 5);

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6">
      <Link href={`/school/topic/${id}`}>
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> กลับ
        </Button>
      </Link>
      <div className="mb-4 flex items-center gap-2">
        <Badge className="bg-rose-100 text-rose-700">Challenge</Badge>
        <Badge variant="outline">{topic.name_th}</Badge>
        <Badge variant="outline">{pool.length} ข้อยาก</Badge>
      </div>
      <h1 className="text-2xl font-bold mb-1 flex items-center gap-2">
        <Zap className="h-6 w-6 text-rose-600" /> Challenge Mode
      </h1>
      <p className="text-sm text-muted-foreground mb-6">
        ข้อยากระดับ analysis + integration — ผ่าน ≥80% รับ XP โบนัส 150 + badge ⚡
      </p>

      {pool.length === 0 ? (
        <div className="border rounded-lg p-8 text-center text-muted-foreground">
          ยังไม่มีข้อ Challenge สำหรับหัวข้อนี้
        </div>
      ) : (
        <ChallengeRunner quizzes={pool} topicName={topic.name_th} topicId={id} />
      )}
    </div>
  );
}
