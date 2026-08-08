import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ArrowLeft, BookOpen, Brain, Zap } from "lucide-react";
import { notFound } from "next/navigation";
import {
  getSchoolLesson,
  getSchoolQuizzes,
  getSchoolTopic,
} from "@/lib/supabase/queries-school";
import UpgradeGate from "@/components/school/UpgradeGate";
import { getSchoolAccess } from "@/lib/school/access-server";
import { canOpenTopic } from "@/lib/school/access";
import LessonReader from "@/components/school/LessonReader";
import LessonQuizRunner, {
  type RunnerQuiz,
} from "@/components/school/LessonQuizRunner";
import AskMore from "@/components/school/AskMore";
import { sortByDifficultyAsc } from "@/lib/school/difficulty";
import { splitLessonParts } from "@/lib/school/lesson-parts";

// สิทธิ์เข้าถึงขึ้นกับ membership ของผู้ใช้ จึง render ต่อ request
// (เดิม revalidate = 60 แคชร่วมกันทุกคน ซึ่งใช้กับ paywall ไม่ได้)
export const dynamic = "force-dynamic";

type Mode = "mixed" | "read" | "quiz";

interface PageProps {
  params: Promise<{ id: string }>;
  searchParams: Promise<{ mode?: string }>;
}

function parseMode(raw: string | undefined): Mode {
  return raw === "read" || raw === "quiz" ? raw : "mixed";
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

const MODE_TABS: { key: Mode; label: string; icon: typeof BookOpen }[] = [
  { key: "mixed", label: "อ่าน + ควิซ", icon: Zap },
  { key: "read", label: "อ่านอย่างเดียว", icon: BookOpen },
  { key: "quiz", label: "ควิซอย่างเดียว", icon: Brain },
];

export default async function LessonPage({ params, searchParams }: PageProps) {
  const { id } = await params;
  const mode = parseMode((await searchParams).mode);
  const lesson = await getSchoolLesson(id);
  if (!lesson) notFound();

  // บทเรียนเข้าตรงด้วย URL ได้ จึงต้องเช็คสิทธิ์ของวิชาต้นทางที่นี่ด้วย
  const [{ access }, topic] = await Promise.all([
    getSchoolAccess(),
    getSchoolTopic(lesson.topic_id),
  ]);
  if (!canOpenTopic(access, topic)) {
    return (
      <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
        <Link href={`/school/topic/${lesson.topic_id}`}>
          <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
            <ArrowLeft className="h-4 w-4" /> กลับไปหน้าวิชา
          </Button>
        </Link>
        <UpgradeGate
          title={`บทนี้อยู่ในวิชา “${topic?.name_th ?? ""}” ของแพ็ก School`}
          description="สมัครแล้วอ่านได้ทุกบทของทุกวิชาในชั้นปี พร้อมควิซคั่นบทและเฉลยเต็ม"
          fallbackHref={`/school/topic/${lesson.topic_id}`}
          fallbackLabel="กลับหน้าวิชา"
        />
      </div>
    );
  }

  // โหมดควิซใช้ข้อสอบทั้งคลังของ layer นี้ ส่วนโหมดอ่านคั่นใช้แค่พอเป็น gate
  // + final retrieval จึงจำกัดไว้ 10 ข้อเหมือนเดิม
  const poolLimit = mode === "quiz" ? 60 : 20;
  const allTopicQuizzes = await getSchoolQuizzes({
    topicId: lesson.topic_id,
    limit: poolLimit,
    randomize: mode !== "quiz",
  });
  // Shuffle (above) keeps variety across visits; then ramp easy→hard so the
  // gate quizzes a reader meets get gradually harder instead of spiking. When a
  // lesson authors its gate quizzes inline, those win and keep their order — this
  // ramp only governs the legacy topic-pool fallback and the final retrieval.
  const pool = sortByDifficultyAsc(
    allTopicQuizzes
      .filter((q) => q.layer === lesson.layer)
      .slice(0, mode === "quiz" ? 60 : 10),
    (q) => q.difficulty
  );

  // โหมดควิซ: รวม mini quiz ที่ฝังในบท (ตรงกับเนื้อหาแต่ละ Part) เข้ากับคลังข้อสอบ
  const gateQuizzes = splitLessonParts(lesson.body_md).gateQuizzes;
  const runnerQuizzes: RunnerQuiz[] = [
    ...gateQuizzes
      .filter((q) => q !== null)
      .map((q) => ({
        dbId: null,
        stem: q!.stem,
        choices: q!.choices,
        correct_answer: q!.correct_answer,
        explanation: q!.explanation,
        difficulty: q!.difficulty,
      })),
    ...pool.map((q) => ({
      dbId: q.id,
      stem: q.stem,
      choices: q.choices,
      correct_answer: q.correct_answer,
      explanation: q.explanation,
      difficulty: q.difficulty,
    })),
  ];

  const modeLabel =
    mode === "read" ? "อ่านอย่างเดียว" : mode === "quiz" ? "ควิซอย่างเดียว" : "อ่าน + ควิซ";

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <Link href={`/school/topic/${lesson.topic_id}`}>
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> กลับไปหน้าวิชา
        </Button>
      </Link>
      <div className="mb-4 flex items-center gap-2 flex-wrap">
        <Badge className="bg-teal-100 text-teal-700">{modeLabel}</Badge>
        {mode !== "quiz" && (
          <Badge variant="outline">{lesson.estimated_min} นาที</Badge>
        )}
        {mode !== "read" && (
          <Badge variant="outline">{runnerQuizzes.length} ข้อ</Badge>
        )}
      </div>
      <h1 className="text-3xl font-bold mb-4 flex items-center gap-2">
        <BookOpen className="h-7 w-7 text-teal-600" /> {lesson.title}
      </h1>

      {/* สลับโหมดได้จากในบท ไม่ต้องย้อนกลับไปหน้าวิชา */}
      <div className="grid grid-cols-3 gap-2 mb-6">
        {MODE_TABS.map((t) => {
          const Icon = t.icon;
          const on = t.key === mode;
          return (
            <Link key={t.key} href={`/school/lesson/${id}?mode=${t.key}`}>
              <div
                className={[
                  "rounded-lg border-2 p-2 text-center transition-colors",
                  on
                    ? "border-brand bg-brand/5 text-brand font-semibold"
                    : "border-muted text-muted-foreground hover:bg-muted/50",
                ].join(" ")}
              >
                <Icon className="h-4 w-4 mx-auto mb-1" />
                <span className="text-[11px] block leading-tight">{t.label}</span>
              </div>
            </Link>
          );
        })}
      </div>

      {mode === "quiz" ? (
        runnerQuizzes.length === 0 ? (
          <div className="border rounded-lg p-8 text-center text-sm text-muted-foreground">
            บทนี้ยังไม่มีข้อสอบ — ลองอ่านเนื้อหาก่อนได้เลย
          </div>
        ) : (
          <LessonQuizRunner
            quizzes={runnerQuizzes}
            lessonId={lesson.id}
            readHref={`/school/lesson/${id}?mode=read`}
          />
        )
      ) : (
        <LessonReader
          lesson={lesson}
          miniQuizzes={pool}
          mode={mode}
          quizHref={`/school/lesson/${id}?mode=quiz`}
        />
      )}

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
