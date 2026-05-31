import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { ArrowRight, GraduationCap, Layers, Brain, Sparkles } from "lucide-react";
import {
  getSchoolSystems,
  getSchoolTopicsByYear,
  getSchoolTopicCounts,
} from "@/lib/supabase/queries-school";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "โหมด School — เรียนแพทย์ Y1–Y6 แบบ Micro-Learning",
  description:
    "เรียนเนื้อหาแพทย์ตั้งแต่ปี 1 ถึงปี 6 แบบ flashcard และ bite-sized quiz วันละ 5–10 นาที จำได้นาน เข้าใจลึก",
  alternates: { canonical: "https://www.morroo.com/school" },
};

export const revalidate = 60;

const YEARS = [1, 2, 3, 4, 5, 6] as const;

export default async function SchoolPage() {
  const [systems, topics, counts] = await Promise.all([
    getSchoolSystems(),
    Promise.all(YEARS.map((y) => getSchoolTopicsByYear(y))).then((arr) =>
      arr.flat()
    ),
    getSchoolTopicCounts(),
  ]);

  const totalFlashcards = Object.values(counts.flashcards).reduce(
    (a, b) => a + b,
    0
  );
  const totalQuizzes = Object.values(counts.quizzes).reduce((a, b) => a + b, 0);

  const topicsByYear: Record<number, typeof topics> = {};
  for (const t of topics) {
    if (!topicsByYear[t.year]) topicsByYear[t.year] = [];
    topicsByYear[t.year].push(t);
  }

  return (
    <div className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="mb-8">
        <div className="flex items-center gap-2 mb-2">
          <Badge className="bg-indigo-100 text-indigo-700">โหมดใหม่</Badge>
          <Badge variant="secondary">{totalFlashcards} flashcards</Badge>
          <Badge variant="secondary">{totalQuizzes} ข้อสอบสั้น</Badge>
        </div>
        <h1 className="text-3xl font-bold">School — เรียนแพทย์ Y1–Y6</h1>
        <p className="mt-2 text-muted-foreground max-w-2xl">
          เนื้อหาแพทย์แบบ micro-learning ตั้งแต่ปี 1 พื้นฐานวิทยาศาสตร์การแพทย์
          จนถึงปี 6 clinical rotations — เรียนวันละ 5–10 นาทีจำได้นาน
        </p>
      </div>

      {/* Mode selection */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-12">
        <Card className="group hover:shadow-lg hover:border-brand/30 transition-all">
          <CardHeader className="pb-3">
            <div className="w-12 h-12 rounded-full bg-sky-100 flex items-center justify-center mb-3">
              <Layers className="h-6 w-6 text-sky-600" />
            </div>
            <h2 className="text-xl font-bold">Flashcards</h2>
            <p className="text-muted-foreground text-sm">
              แตะการ์ดเพื่อพลิกดูเฉลย ประเมินตัวเองว่าจำได้ไหม — ทบทวนวันละนิด
            </p>
          </CardHeader>
          <CardContent>
            <Link href="/school/flashcards">
              <Button className="w-full bg-sky-600 hover:bg-sky-700 text-white gap-2">
                เริ่ม Flashcards <ArrowRight className="h-4 w-4" />
              </Button>
            </Link>
          </CardContent>
        </Card>

        <Card className="group hover:shadow-lg hover:border-brand/30 transition-all">
          <CardHeader className="pb-3">
            <div className="w-12 h-12 rounded-full bg-emerald-100 flex items-center justify-center mb-3">
              <Brain className="h-6 w-6 text-emerald-600" />
            </div>
            <h2 className="text-xl font-bold">Bite-sized Quiz</h2>
            <p className="text-muted-foreground text-sm">
              คำถามสั้น 1 ข้อต่อ 1 concept เฉลยทันที พร้อมคำอธิบาย
            </p>
          </CardHeader>
          <CardContent>
            <Link href="/school/quiz">
              <Button className="w-full bg-emerald-600 hover:bg-emerald-700 text-white gap-2">
                เริ่มทำข้อสอบสั้น <ArrowRight className="h-4 w-4" />
              </Button>
            </Link>
          </CardContent>
        </Card>
      </div>

      {/* Year overview */}
      <div className="mb-8">
        <div className="flex items-center gap-2 mb-6">
          <GraduationCap className="h-5 w-5 text-brand" />
          <h2 className="text-2xl font-bold">เลือกชั้นปี</h2>
        </div>
        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-3">
          {YEARS.map((y) => {
            const topicCount = topicsByYear[y]?.length ?? 0;
            const disabled = topicCount === 0;
            return (
              <Link
                key={y}
                href={disabled ? "#" : `/school/${y}`}
                aria-disabled={disabled}
                className={disabled ? "pointer-events-none" : ""}
              >
                <Card
                  className={[
                    "h-full transition-all",
                    disabled
                      ? "opacity-50"
                      : "hover:shadow-md hover:border-brand/30 cursor-pointer",
                  ].join(" ")}
                >
                  <CardContent className="p-4 text-center">
                    <p className="text-2xl font-bold text-brand">Y{y}</p>
                    <p className="text-xs text-muted-foreground mt-1">
                      {topicCount > 0 ? `${topicCount} หัวข้อ` : "เร็วๆ นี้"}
                    </p>
                  </CardContent>
                </Card>
              </Link>
            );
          })}
        </div>
      </div>

      {/* Systems overview */}
      <div className="mb-8">
        <div className="flex items-center gap-2 mb-6">
          <Sparkles className="h-5 w-5 text-brand" />
          <h2 className="text-2xl font-bold">ระบบที่ครอบคลุม</h2>
        </div>
        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-3">
          {systems.map((s) => (
            <Card key={s.id} className="h-full">
              <CardContent className="p-4 text-center">
                <span className="text-3xl block mb-2">{s.icon}</span>
                <h3 className="font-medium text-sm">{s.name_th}</h3>
                <p className="text-xs text-muted-foreground mt-1">{s.name_en}</p>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </div>
  );
}
