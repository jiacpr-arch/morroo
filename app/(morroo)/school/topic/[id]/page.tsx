import Link from "next/link";
import { notFound } from "next/navigation";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { ArrowLeft, BookOpenText, CheckCircle2 } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import {
  getSchoolTopic,
  getSchoolLessons,
  getSchoolQuizzes,
  getSchoolMasteryByTopic,
  getSchoolBookByTopic,
} from "@/lib/supabase/queries-school";
import ChapterList from "@/components/school/ChapterList";
import UpgradeGate from "@/components/school/UpgradeGate";
import { splitLessonParts } from "@/lib/school/lesson-parts";
import { getSchoolAccess } from "@/lib/school/access-server";
import { canOpenTopic } from "@/lib/school/access";

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

  const { access } = await getSchoolAccess();
  const unlocked = canOpenTopic(access, topic);

  const [lessons, quizzes, bookResult] = unlocked
    ? await Promise.all([
        getSchoolLessons({ topicId: id }),
        getSchoolQuizzes({ topicId: id, limit: 100 }),
        getSchoolBookByTopic(id),
      ])
    : [[], [], null];
  const book = bookResult?.book ?? null;
  const bookChapterCount = bookResult?.chapters.length ?? 0;

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
  const mastered = mastery.seen >= 5 && mastery.pct >= MASTERY_THRESHOLD;

  // จำนวนข้อสอบต่อบท = mini quiz ที่ฝังในบท + คลังข้อสอบของ layer เดียวกัน
  // (ชุดเดียวกับที่หน้าบทเรียนหยิบไปใช้ ทั้งตอนคั่นและตอน final retrieval)
  const chapters = lessons.map((l) => {
    const gates = splitLessonParts(l.body_md).gateQuizzes.filter(Boolean).length;
    const pool = quizzes.filter((q) => q.layer === l.layer).length;
    return {
      id: l.id,
      title: l.title,
      estimated_min: l.estimated_min,
      quizCount: gates + pool,
      read: lessonsRead.has(l.id),
    };
  });

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
        {topic.code && (
          <Badge variant="outline" className="font-mono">{topic.code}</Badge>
        )}
        {topic.credits != null && (
          <Badge variant="outline">
            {topic.credits} หน่วยกิต
            {topic.credit_hours && ` (${topic.credit_hours})`}
          </Badge>
        )}
        {mastered && (
          <Badge className="bg-emerald-100 text-emerald-700">
            <CheckCircle2 className="h-3 w-3 mr-1" /> Mastered
          </Badge>
        )}
        {topic.is_preview && (
          <Badge className="bg-sky-100 text-sky-700">วิชาตัวอย่าง — ฟรี</Badge>
        )}
      </div>
      <h1 className="text-3xl font-bold mb-3">{topic.name_th}</h1>
      <p className="text-muted-foreground mb-1">{topic.name_en}</p>
      {topic.summary && (
        <p className="text-sm text-muted-foreground mb-6">{topic.summary}</p>
      )}

      {/* เนื้อหาแยกเป็นบท + เลือกโหมดการเรียน — ทางเข้าหลักของวิชา */}
      <div className="mb-8">
        {unlocked ? (
          <ChapterList chapters={chapters} />
        ) : (
          <UpgradeGate
            title="วิชานี้อยู่ในแพ็ก School"
            description="สมัครแล้วเปิดอ่านได้ทุกบทของทุกวิชาในชั้นปี พร้อมข้อสอบ เฉลย และระบบทบทวนตามตารางลืม"
          />
        )}
      </div>

      {/* Full-text book (reference) — มาพร้อมสิทธิ์ของวิชา (ล็อกพร้อมกัน) */}
      {book && bookChapterCount > 0 && (
        <Card className="mb-8 border-amber-200 bg-amber-50/50">
          <CardContent className="p-5 flex items-center justify-between gap-4">
            <div>
              <p className="font-semibold text-amber-700 flex items-center gap-2">
                <BookOpenText className="h-4 w-4" /> อ่านหนังสือฉบับเต็ม (Reference)
              </p>
              <p className="text-sm text-muted-foreground">
                เนื้อหาฉบับเต็ม {bookChapterCount} บท แบบอ่านต่อเนื่อง + สารบัญ — เปิดอ่านได้อิสระ
              </p>
            </div>
            <Link href={`/school/book/${book.id}`}>
              <Button
                variant="outline"
                className="border-amber-300 text-amber-700 hover:bg-amber-100"
              >
                เปิดอ่าน
              </Button>
            </Link>
          </CardContent>
        </Card>
      )}
    </div>
  );
}
