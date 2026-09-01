import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ArrowLeft } from "lucide-react";
import BiteQuiz from "@/components/school/BiteQuiz";
import { getSchoolQuizzes, getSchoolTopicsByYear } from "@/lib/supabase/queries-school";
import { createClient } from "@/lib/supabase/server";
import { hasSchoolAccess } from "@/lib/membership";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Bite-sized Quiz — โหมด School",
  description: "ทำข้อสอบสั้นๆ ทบทวนความเข้าใจ",
};

export const dynamic = "force-dynamic";

interface PageProps {
  searchParams: Promise<{ topic?: string; year?: string }>;
}

export default async function QuizPage({ searchParams }: PageProps) {
  const params = await searchParams;
  const year = params.year ? Number(params.year) : undefined;
  const topicId = params.topic;

  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  let isPremium = false;
  if (user) {
    const { data: profile } = await supabase
      .from("profiles")
      .select("membership_type, membership_expires_at")
      .eq("id", user.id)
      .maybeSingle();
    isPremium = hasSchoolAccess(profile);
  }

  const [quizzes, topics] = await Promise.all([
    getSchoolQuizzes({ topicId, year, limit: 30, randomize: true }),
    year ? getSchoolTopicsByYear(year) : Promise.resolve([]),
  ]);

  const activeTopic = topics.find((t) => t.id === topicId);

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6">
      <div className="mb-6">
        <Link href="/school">
          <Button variant="ghost" size="sm" className="gap-2 -ml-2">
            <ArrowLeft className="h-4 w-4" /> กลับ
          </Button>
        </Link>
        <div className="mt-2 flex items-center gap-2">
          <Badge className="bg-emerald-100 text-emerald-700">Bite-sized Quiz</Badge>
          {activeTopic && <Badge variant="outline">{activeTopic.name_th}</Badge>}
          {year && !activeTopic && <Badge variant="outline">ปี {year}</Badge>}
        </div>
        <h1 className="text-2xl font-bold mt-2">
          {activeTopic?.name_th ?? "ทำข้อสอบสั้น"}
        </h1>
      </div>

      {quizzes.length === 0 ? (
        <div className="border rounded-lg p-8 text-center text-muted-foreground">
          ยังไม่มีข้อสอบสำหรับหัวข้อนี้ — กลับไปเลือกหัวข้ออื่นได้เลย
        </div>
      ) : (
        <BiteQuiz quizzes={quizzes} isPremium={isPremium} freeLimit={5} />
      )}
    </div>
  );
}
