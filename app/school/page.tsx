import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import {
  ArrowRight,
  GraduationCap,
  Layers,
  Brain,
  Sparkles,
  Shuffle,
  Clock,
  Flame,
  Calendar,
  Target,
} from "lucide-react";
import {
  getSchoolSystems,
  getSchoolTopicsByYear,
  getSchoolTopicCounts,
  getSchoolStreak,
  getDueCount,
} from "@/lib/supabase/queries-school";
import { createClient } from "@/lib/supabase/server";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "โหมด School — เรียนแพทย์ Y1–Y6 แบบ Micro-Learning",
  description:
    "เรียนเนื้อหาแพทย์ Y1–Y6 แบบ flashcard + quiz + concept reader + AI self-explanation พร้อม spaced repetition และ streak tracking",
  alternates: { canonical: "https://www.morroo.com/school" },
};

export const dynamic = "force-dynamic";

const YEARS = [1, 2, 3, 4, 5, 6] as const;

export default async function SchoolPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  const [systems, topicsByYearArr, counts] = await Promise.all([
    getSchoolSystems(),
    Promise.all(YEARS.map((y) => getSchoolTopicsByYear(y))),
    getSchoolTopicCounts(),
  ]);
  const topics = topicsByYearArr.flat();

  // Personalised state — only if logged in
  let streak = { current_streak: 0, longest_streak: 0, last_active_date: null as string | null };
  let dueCount = 0;
  let dailyGoal = 20;
  let dailyDone = 0;
  let currentYear: number | null = null;
  if (user) {
    const [s, due, profileRes] = await Promise.all([
      getSchoolStreak(user.id),
      getDueCount(user.id),
      supabase
        .from("profiles")
        .select("current_year, school_daily_goal")
        .eq("id", user.id)
        .maybeSingle(),
    ]);
    streak = s;
    dueCount = due;
    dailyGoal = profileRes.data?.school_daily_goal ?? 20;
    currentYear = profileRes.data?.current_year ?? null;
    // Count units done today
    const startOfDay = new Date();
    startOfDay.setHours(0, 0, 0, 0);
    const { count } = await supabase
      .from("school_progress")
      .select("id", { count: "exact", head: true })
      .eq("user_id", user.id)
      .gte("reviewed_at", startOfDay.toISOString());
    dailyDone = count ?? 0;
  }

  const totalFlashcards = Object.values(counts.flashcards).reduce((a, b) => a + b, 0);
  const totalQuizzes = Object.values(counts.quizzes).reduce((a, b) => a + b, 0);

  const topicsByYear: Record<number, typeof topics> = {};
  for (const t of topics) {
    if (!topicsByYear[t.year]) topicsByYear[t.year] = [];
    topicsByYear[t.year].push(t);
  }

  const goalPct = Math.min(100, Math.round((dailyDone / dailyGoal) * 100));

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
          Evidence-based micro-learning: Spaced Repetition, Interleaving, Active Recall,
          Self-explanation, Daily Lesson + Streak — เหมือน Anki + Duolingo สำหรับนักศึกษาแพทย์
        </p>
      </div>

      {user && (
        <>
          {/* Streak + Daily goal */}
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-6">
            <Card className="border-orange-200 bg-orange-50/50">
              <CardContent className="p-4 flex items-center gap-3">
                <Flame className="h-8 w-8 text-orange-600" />
                <div>
                  <p className="text-xs text-muted-foreground">Streak</p>
                  <p className="text-2xl font-bold text-orange-700">
                    {streak.current_streak} วัน
                  </p>
                  <p className="text-xs text-muted-foreground">
                    ดีที่สุด {streak.longest_streak} วัน
                  </p>
                </div>
              </CardContent>
            </Card>
            <Card className="border-emerald-200 bg-emerald-50/50">
              <CardContent className="p-4">
                <div className="flex items-center gap-3 mb-2">
                  <Target className="h-8 w-8 text-emerald-600" />
                  <div>
                    <p className="text-xs text-muted-foreground">เป้าหมายวันนี้</p>
                    <p className="text-2xl font-bold text-emerald-700">
                      {dailyDone} / {dailyGoal}
                    </p>
                  </div>
                </div>
                <div className="h-2 bg-emerald-100 rounded-full overflow-hidden">
                  <div
                    className="h-full bg-emerald-500 transition-all"
                    style={{ width: `${goalPct}%` }}
                  />
                </div>
              </CardContent>
            </Card>
            <Card className="border-rose-200 bg-rose-50/50">
              <CardContent className="p-4 flex items-center gap-3">
                <Clock className="h-8 w-8 text-rose-600" />
                <div>
                  <p className="text-xs text-muted-foreground">ต้องทบทวน</p>
                  <p className="text-2xl font-bold text-rose-700">{dueCount}</p>
                  <Link href="/school/review" className="text-xs text-rose-700 underline">
                    เริ่มทบทวน →
                  </Link>
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Onboarding prompt */}
          {!currentYear && (
            <Card className="mb-6 border-violet-200 bg-violet-50/50">
              <CardContent className="p-4 flex items-center justify-between gap-3">
                <div>
                  <p className="font-semibold text-violet-700">เริ่มต้นใช้งาน</p>
                  <p className="text-sm text-muted-foreground">
                    บอกเราว่าคุณอยู่ชั้นปีไหน เพื่อ Daily Lesson ที่ตรงกับคุณ
                  </p>
                </div>
                <Link href="/school/onboarding">
                  <Button className="gap-2">ตั้งค่า <ArrowRight className="h-4 w-4" /></Button>
                </Link>
              </CardContent>
            </Card>
          )}
        </>
      )}

      {/* Mode selection — 6 modes */}
      <div className="grid grid-cols-2 lg:grid-cols-6 gap-3 mb-12">
        {[
          {
            href: "/school/daily",
            icon: Calendar,
            color: "violet",
            title: "Daily Lesson",
            desc: "บทเรียน 5 นาที/วัน",
          },
          {
            href: "/school/flashcards",
            icon: Layers,
            color: "sky",
            title: "Flashcards",
            desc: "ทบทวนทีละการ์ด",
          },
          {
            href: "/school/quiz",
            icon: Brain,
            color: "emerald",
            title: "Quiz",
            desc: "ข้อสอบสั้น + เฉลย",
          },
          {
            href: "/school/mixed",
            icon: Shuffle,
            color: "fuchsia",
            title: "Mixed",
            desc: "Interleaved practice",
          },
          {
            href: "/school/review",
            icon: Clock,
            color: "rose",
            title: "Review",
            desc: "ใกล้ลืม — SRS",
          },
          {
            href: "/school/progress",
            icon: GraduationCap,
            color: "indigo",
            title: "Progress",
            desc: "Mastery + ปลดล็อก",
          },
        ].map((m) => (
          <Link key={m.href} href={m.href}>
            <Card className="group h-full hover:shadow-md hover:border-brand/30 transition-all cursor-pointer">
              <CardContent className="p-4 text-center">
                <div
                  className={`w-10 h-10 rounded-full bg-${m.color}-100 flex items-center justify-center mb-2 mx-auto`}
                >
                  <m.icon className={`h-5 w-5 text-${m.color}-600`} />
                </div>
                <h3 className="font-bold text-sm">{m.title}</h3>
                <p className="text-xs text-muted-foreground mt-1">{m.desc}</p>
              </CardContent>
            </Card>
          </Link>
        ))}
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

      {/* Evidence-based explainer */}
      <div className="border-t pt-8 mt-12">
        <h2 className="text-xl font-bold mb-4">วิธีเรียนรู้ที่ระบบรองรับ (Evidence-based)</h2>
        <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-4 text-sm">
          <div>
            <p className="font-semibold mb-1">✓ Spaced Repetition (SM-2)</p>
            <p className="text-muted-foreground">การ์ดกลับมาทบทวนตามจังหวะที่ใกล้ลืม — Ebbinghaus</p>
          </div>
          <div>
            <p className="font-semibold mb-1">✓ Active Recall / Retrieval</p>
            <p className="text-muted-foreground">ดึงข้อมูลออกจากความจำ &gt; อ่านซ้ำ — Karpicke 2011</p>
          </div>
          <div>
            <p className="font-semibold mb-1">✓ Interleaving (Mixed mode)</p>
            <p className="text-muted-foreground">สลับ topic ในรอบเดียว — Rohrer & Taylor</p>
          </div>
          <div>
            <p className="font-semibold mb-1">✓ Self-explanation (Feynman)</p>
            <p className="text-muted-foreground">อธิบายให้คนอื่นฟัง → AI ตรวจให้คะแนน + บอกที่ขาด</p>
          </div>
          <div>
            <p className="font-semibold mb-1">✓ Elaborative Interrogation</p>
            <p className="text-muted-foreground">AI ตั้งคำถาม "ทำไม / อย่างไร?" บังคับคิดถึงกลไก — Dunlosky 2013</p>
          </div>
          <div>
            <p className="font-semibold mb-1">✓ Generation Effect (Cloze)</p>
            <p className="text-muted-foreground">ปิดคำตอบบางส่วน — บังคับเดา/สร้างคำตอบ — Slamecka & Graf 1978</p>
          </div>
          <div>
            <p className="font-semibold mb-1">✓ Mastery Learning (Bloom)</p>
            <p className="text-muted-foreground">ปลดล็อก topic ถัดไปเมื่อได้ 80%+ — bloom 1968</p>
          </div>
          <div>
            <p className="font-semibold mb-1">✓ Adaptive / Weak-subject bias</p>
            <p className="text-muted-foreground">ระบบหยิบ topic ที่คุณไม่ถนัดมาฝึกบ่อยขึ้น — Vygotsky ZPD</p>
          </div>
          <div>
            <p className="font-semibold mb-1">✓ Variable Reward</p>
            <p className="text-muted-foreground">รางวัลสุ่มหลังจบ session — Skinner box, dopamine loop</p>
          </div>
          <div>
            <p className="font-semibold mb-1">✓ Dual Coding</p>
            <p className="text-muted-foreground">คำ + ภาพ — แสดง diagram บน flashcard (ถ้ามี) — Paivio</p>
          </div>
          <div>
            <p className="font-semibold mb-1">✓ Microlearning + Streak</p>
            <p className="text-muted-foreground">5–10 นาที/วัน + habit loop เหมือน Duolingo</p>
          </div>
          <div>
            <p className="font-semibold mb-1">✓ Concept Reader + Quiz</p>
            <p className="text-muted-foreground">อ่าน 1 concept แล้ว retrieval ทันที</p>
          </div>
        </div>
      </div>
    </div>
  );
}
