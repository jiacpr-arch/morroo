import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ArrowLeft } from "lucide-react";
import BiteQuiz from "@/components/school/BiteQuiz";
import UpgradeGate from "@/components/school/UpgradeGate";
import {
  getSchoolLockedCounts,
  getSchoolQuizzes,
  getSchoolTopic,
  getSchoolTopicsByYear,
} from "@/lib/supabase/queries-school";
import { getSchoolAccess } from "@/lib/school/access-server";
import { canOpenTopic } from "@/lib/school/access";
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

  const { access } = await getSchoolAccess();

  const requestedTopic = topicId ? await getSchoolTopic(topicId) : null;
  const topicLocked = Boolean(requestedTopic) && !canOpenTopic(access, requestedTopic);

  const [quizzes, topics, lockedCounts] = await Promise.all([
    topicLocked
      ? Promise.resolve([])
      : getSchoolQuizzes({
          topicId,
          year,
          limit: 30,
          randomize: true,
          previewOnly: access.previewOnly,
        }),
    year ? getSchoolTopicsByYear(year) : Promise.resolve([]),
    access.previewOnly
      ? getSchoolLockedCounts(year)
      : Promise.resolve({ topics: 0, flashcards: 0, quizzes: 0, lessons: 0 }),
  ]);

  const activeTopic = requestedTopic ?? topics.find((t) => t.id === topicId);

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

      {topicLocked ? (
        <UpgradeGate
          title={`วิชา “${activeTopic?.name_th ?? "นี้"}” อยู่ในแพ็ก School`}
          description={`สมัครแล้วทำข้อสอบได้ทุกวิชาในชั้นปี — ยังมีอีก ${lockedCounts.quizzes} ข้อในวิชาที่ล็อกอยู่`}
        />
      ) : quizzes.length === 0 ? (
        <div className="border rounded-lg p-8 text-center text-muted-foreground">
          ยังไม่มีข้อสอบสำหรับหัวข้อนี้ — กลับไปเลือกหัวข้ออื่นได้เลย
        </div>
      ) : (
        <BiteQuiz quizzes={quizzes} lockedCount={lockedCounts.quizzes} />
      )}
    </div>
  );
}
