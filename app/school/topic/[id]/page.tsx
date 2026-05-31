import Link from "next/link";
import { notFound } from "next/navigation";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import {
  ArrowLeft,
  BookOpen,
  Layers,
  Brain,
  TrendingUp,
  Sparkles,
  CheckCircle2,
  Circle,
} from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import {
  getSchoolTopic,
  getSchoolLessons,
  getSchoolFlashcards,
  getSchoolQuizzes,
  getSchoolMasteryByTopic,
} from "@/lib/supabase/queries-school";

export const dynamic = "force-dynamic";

interface PageProps {
  params: Promise<{ id: string }>;
}

const MASTERY_THRESHOLD = 80;

export async function generateMetadata({ params }: PageProps) {
  const { id } = await params;
  const topic = await getSchoolTopic(id);
  return {
    title: topic
      ? `${topic.name_th} — Topic Hub`
      : "Topic — School",
    description: topic?.summary ?? "หน้าเรียนแบบ guided sequence",
  };
}

export default async function TopicPage({ params }: PageProps) {
  const { id } = await params;
  const topic = await getSchoolTopic(id);
  if (!topic) notFound();

  const [lessons, cards, quizzes] = await Promise.all([
    getSchoolLessons({ topicId: id }),
    getSchoolFlashcards({ topicId: id, limit: 100 }),
    getSchoolQuizzes({ topicId: id, limit: 100 }),
  ]);

  // Personalised mastery + read status
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  let lessonsRead = new Set<string>();
  let mastery = { seen: 0, correct: 0, pct: 0 };
  if (user) {
    const masteryMap = await getSchoolMasteryByTopic(user.id);
    mastery = masteryMap[id] ?? mastery;
    const { data: lessonProgress } = await supabase
      .from("school_progress")
      .select("unit_id")
      .eq("user_id", user.id)
      .eq("unit_type", "lesson");
    lessonsRead = new Set(
      (lessonProgress ?? []).map((r: { unit_id: string }) => r.unit_id)
    );
  }
  const allLessonsRead = lessons.length > 0 && lessons.every((l) => lessonsRead.has(l.id));
  const mastered = mastery.seen >= 5 && mastery.pct >= MASTERY_THRESHOLD;

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <Link href={`/school/${topic.year}`}>
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> กลับชั้นปี {topic.year}
        </Button>
      </Link>
      <div className="mb-4 flex items-center gap-2 flex-wrap">
        {topic.school_systems && (
          <Badge variant="outline">
            <span className="mr-1">{topic.school_systems.icon}</span>
            {topic.school_systems.name_th}
          </Badge>
        )}
        <Badge variant="outline">ปี {topic.year}</Badge>
        {mastered && (
          <Badge className="bg-emerald-100 text-emerald-700">
            <CheckCircle2 className="h-3 w-3 mr-1" /> Mastered
          </Badge>
        )}
      </div>
      <h1 className="text-3xl font-bold mb-3">{topic.name_th}</h1>
      <p className="text-muted-foreground mb-1">{topic.name_en}</p>
      {topic.summary && (
        <p className="text-sm text-muted-foreground mb-6">{topic.summary}</p>
      )}

      {/* Guided sequence CTA */}
      <Card className="mb-8 border-violet-200 bg-violet-50/50">
        <CardContent className="p-5 flex items-center justify-between gap-4">
          <div>
            <p className="font-semibold text-violet-700 flex items-center gap-2">
              <Sparkles className="h-4 w-4" /> Guided Sequence (แนะนำ)
            </p>
            <p className="text-sm text-muted-foreground">
              อ่าน concept → ฝึก flashcards → ทดสอบ → mastery check (ตาม Bloom hierarchy)
            </p>
          </div>
          <Link href={`/school/topic/${id}/guided`}>
            <Button className="bg-violet-600 hover:bg-violet-700 text-white">
              เริ่ม
            </Button>
          </Link>
        </CardContent>
      </Card>

      {/* Sections */}
      <div className="space-y-4">
        {/* 1. Learn */}
        <SectionCard
          step={1}
          icon={BookOpen}
          color="teal"
          title="Learn (อ่าน Concept)"
          count={lessons.length}
          completed={allLessonsRead}
        >
          {lessons.length === 0 ? (
            <p className="text-sm text-muted-foreground">
              ยังไม่มี concept reader สำหรับหัวข้อนี้
            </p>
          ) : (
            <ul className="space-y-1">
              {lessons.map((l, i) => {
                const read = lessonsRead.has(l.id);
                return (
                  <li key={l.id}>
                    <Link
                      href={`/school/lesson/${l.id}`}
                      className="flex items-center gap-3 p-2 rounded hover:bg-muted/50 transition-colors"
                    >
                      {read ? (
                        <CheckCircle2 className="h-4 w-4 text-emerald-600 shrink-0" />
                      ) : (
                        <Circle className="h-4 w-4 text-muted-foreground shrink-0" />
                      )}
                      <span className="flex-1 text-sm">
                        {i + 1}. {l.title}
                      </span>
                      <span className="text-xs text-muted-foreground">
                        {l.estimated_min} นาที
                      </span>
                    </Link>
                  </li>
                );
              })}
            </ul>
          )}
        </SectionCard>

        {/* 2. Practice */}
        <SectionCard
          step={2}
          icon={Layers}
          color="sky"
          title="Practice (Flashcards)"
          count={cards.length}
          locked={lessons.length > 0 && !allLessonsRead && !mastered}
          completed={false}
        >
          {cards.length === 0 ? (
            <p className="text-sm text-muted-foreground">ยังไม่มี flashcards</p>
          ) : (
            <PracticeButtons topicId={id} cardsCount={cards.length} mustLearnFirst={lessons.length > 0 && !allLessonsRead && !mastered} />
          )}
        </SectionCard>

        {/* 3. Test */}
        <SectionCard
          step={3}
          icon={Brain}
          color="emerald"
          title="Test (Quiz)"
          count={quizzes.length}
          locked={lessons.length > 0 && !allLessonsRead && !mastered}
          completed={mastered}
        >
          {quizzes.length === 0 ? (
            <p className="text-sm text-muted-foreground">ยังไม่มี quiz</p>
          ) : (
            <TestButtons topicId={id} quizCount={quizzes.length} mustLearnFirst={lessons.length > 0 && !allLessonsRead && !mastered} />
          )}
        </SectionCard>

        {/* Challenge */}
        {quizzes.filter((q) => q.difficulty === "hard").length >= 3 && (
          <Card className="border-rose-200 bg-rose-50/30">
            <CardContent className="p-5 flex items-center justify-between gap-4">
              <div>
                <p className="font-bold text-rose-700 flex items-center gap-2">
                  ⚡ Challenge Mode
                </p>
                <p className="text-sm text-muted-foreground">
                  ข้อยาก analysis level — ผ่าน ≥80% รับ XP โบนัส + badge ⚡
                </p>
              </div>
              <Link href={`/school/topic/${id}/challenge`}>
                <Button className="bg-rose-600 hover:bg-rose-700 text-white">เริ่ม</Button>
              </Link>
            </CardContent>
          </Card>
        )}

        {/* 4. Mastery */}
        <SectionCard
          step={4}
          icon={TrendingUp}
          color="indigo"
          title="Mastery"
          count={null}
          completed={mastered}
        >
          {user ? (
            <div className="space-y-2">
              <div className="flex justify-between text-sm">
                <span>ความเข้าใจ</span>
                <span className="font-bold">{mastery.pct}%</span>
              </div>
              <div className="h-2 bg-muted rounded-full overflow-hidden">
                <div
                  className={`h-full transition-all ${
                    mastered
                      ? "bg-emerald-500"
                      : mastery.pct >= 50
                        ? "bg-amber-500"
                        : "bg-rose-400"
                  }`}
                  style={{ width: `${mastery.pct}%` }}
                />
              </div>
              <p className="text-xs text-muted-foreground">
                ทำ quiz {mastery.correct}/{mastery.seen} ข้อ — ต้องได้ {MASTERY_THRESHOLD}%+ จาก ≥5 ข้อ จึง mastered
              </p>
            </div>
          ) : (
            <p className="text-sm text-muted-foreground">
              <Link href="/login" className="underline">เข้าสู่ระบบ</Link> เพื่อติดตาม mastery
            </p>
          )}
        </SectionCard>
      </div>
    </div>
  );
}

function SectionCard({
  step,
  icon: Icon,
  color,
  title,
  count,
  locked = false,
  completed,
  children,
}: {
  step: number;
  icon: React.ComponentType<{ className?: string }>;
  color: string;
  title: string;
  count: number | null;
  locked?: boolean;
  completed: boolean;
  children: React.ReactNode;
}) {
  return (
    <Card className={locked ? "opacity-60" : ""}>
      <CardContent className="p-5">
        <div className="flex items-center gap-3 mb-3">
          <div
            className={`w-10 h-10 rounded-full bg-${color}-100 flex items-center justify-center shrink-0`}
          >
            <Icon className={`h-5 w-5 text-${color}-600`} />
          </div>
          <div className="flex-1 min-w-0">
            <p className="text-xs text-muted-foreground">Step {step}</p>
            <p className="font-bold">
              {title}{" "}
              {count !== null && (
                <span className="text-sm font-normal text-muted-foreground">
                  ({count})
                </span>
              )}
            </p>
          </div>
          {completed && (
            <CheckCircle2 className="h-5 w-5 text-emerald-600 shrink-0" />
          )}
        </div>
        {children}
      </CardContent>
    </Card>
  );
}

function PracticeButtons({
  topicId,
  cardsCount,
  mustLearnFirst,
}: {
  topicId: string;
  cardsCount: number;
  mustLearnFirst: boolean;
}) {
  return (
    <div className="flex flex-col gap-2">
      <p className="text-sm text-muted-foreground">
        {cardsCount} ใบ — Active Recall + SRS
      </p>
      {mustLearnFirst && (
        <p className="text-xs italic text-amber-700 bg-amber-50 p-2 rounded">
          💡 แนะนำให้อ่าน Concept ก่อน — แต่ข้ามได้ถ้าคุณเรียนมาแล้ว
        </p>
      )}
      <Link href={`/school/flashcards?topic=${topicId}`}>
        <Button variant="outline" className="w-full">
          เริ่ม Flashcards
        </Button>
      </Link>
    </div>
  );
}

function TestButtons({
  topicId,
  quizCount,
  mustLearnFirst,
}: {
  topicId: string;
  quizCount: number;
  mustLearnFirst: boolean;
}) {
  return (
    <div className="flex flex-col gap-2">
      <p className="text-sm text-muted-foreground">{quizCount} ข้อ MCQ</p>
      {mustLearnFirst && (
        <p className="text-xs italic text-amber-700 bg-amber-50 p-2 rounded">
          💡 แนะนำให้อ่าน Concept ก่อน เพื่อไม่ frustrate ตอนทดสอบ
        </p>
      )}
      <Link href={`/school/quiz?topic=${topicId}`}>
        <Button variant="outline" className="w-full">
          เริ่มทำ Quiz
        </Button>
      </Link>
    </div>
  );
}
