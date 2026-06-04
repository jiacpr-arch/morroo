import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import {
  ArrowRight,
  GraduationCap,
  Layers,
  Sparkles,
  Clock,
  Flame,
  Target,
  Trophy,
  Zap,
  Database,
} from "lucide-react";
import { xpToLevel } from "@/lib/school/xp";
import {
  getSchoolSystems,
  getSchoolTopicsByYear,
  getSchoolTopicCounts,
  getSchoolStreak,
  getDueCount,
  getSchoolMasteryByTopic,
  getWeeklyQuestMetrics,
} from "@/lib/supabase/queries-school";
import { getUnlockState } from "@/lib/school/journey";
import {
  buildWeeklyQuests,
  topSystemSlugFor,
  type Quest,
} from "@/lib/school/quests";
import JourneyBanner from "@/components/school/JourneyBanner";
import ToolGrid from "@/components/school/ToolGrid";
import WeeklyQuests from "@/components/school/WeeklyQuests";
import { createClient } from "@/lib/supabase/server";
import SectionUpdatesBadge from "@/components/SectionUpdatesBadge";
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
  let xp = 0;
  let badgeCount = 0;
  let isAdmin = false;
  let masteredCount = 0;
  let targetSpecialty: string | null = null;
  let quests: Quest[] = [];
  if (user) {
    const [s, due, profileRes, badgesRes, mastery] = await Promise.all([
      getSchoolStreak(user.id),
      getDueCount(user.id),
      supabase
        .from("profiles")
        .select("current_year, school_daily_goal, school_xp, role, target_specialty")
        .eq("id", user.id)
        .maybeSingle(),
      supabase
        .from("school_user_badges")
        .select("badge_id", { count: "exact", head: true })
        .eq("user_id", user.id),
      getSchoolMasteryByTopic(user.id),
    ]);
    streak = s;
    dueCount = due;
    dailyGoal = profileRes.data?.school_daily_goal ?? 20;
    currentYear = profileRes.data?.current_year ?? null;
    xp = profileRes.data?.school_xp ?? 0;
    badgeCount = badgesRes.count ?? 0;
    isAdmin = profileRes.data?.role === "admin";
    targetSpecialty = profileRes.data?.target_specialty ?? null;
    // A topic counts as "mastered" once seen >= 5 quizzes and >= 80% correct
    masteredCount = Object.values(mastery).filter(
      (m) => m.seen >= 5 && m.pct >= 80
    ).length;

    // Weekly quests — one tied to the student's target specialty.
    const focusSlug = topSystemSlugFor(targetSpecialty);
    const focusSystem = focusSlug
      ? systems.find((sy) => sy.slug === focusSlug) ?? null
      : null;
    const [metrics, todayCount] = await Promise.all([
      getWeeklyQuestMetrics(user.id, focusSlug),
      supabase
        .from("school_progress")
        .select("id", { count: "exact", head: true })
        .eq("user_id", user.id)
        .gte(
          "reviewed_at",
          (() => {
            const d = new Date();
            d.setHours(0, 0, 0, 0);
            return d.toISOString();
          })()
        ),
    ]);
    dailyDone = todayCount.count ?? 0;
    quests = buildWeeklyQuests(metrics, {
      targetSpecialtyId: targetSpecialty,
      focusSystem: focusSystem
        ? { slug: focusSystem.slug, name_th: focusSystem.name_th }
        : null,
    });
  }

  // Progressive-disclosure unlock state for the tool grid + journey banner.
  const unlockState = getUnlockState({
    hasYear: currentYear != null,
    xp,
    streak: streak.current_streak,
    masteredCount,
    dueCount,
  });

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
      <div className="mb-6">
        <div className="flex items-center gap-2 mb-2">
          <Badge className="bg-indigo-100 text-indigo-700">โหมดใหม่</Badge>
          <Badge variant="secondary">{totalFlashcards} flashcards</Badge>
          <Badge variant="secondary">{totalQuizzes} ข้อสอบสั้น</Badge>
        </div>
        <h1 className="text-3xl font-bold">School — เรียนแพทย์ Y1–Y6</h1>
        <p className="mt-2 text-muted-foreground max-w-2xl">
          ติวแพทย์ตั้งแต่ปี 1 ถึงปี 6 แบบวันละนิด — flashcard + quiz + AI ช่วยติว
          พร้อมระบบทบทวนอัตโนมัติและ streak ให้เรียนต่อเนื่องเหมือน Duolingo
        </p>
        <SectionUpdatesBadge section="school" className="mt-3" />
      </div>

      {/* Journey: ก้าวต่อไป + ด่านปลดล็อก (แทน "เริ่มยังไง 3 ขั้น") */}
      <JourneyBanner
        hasYear={currentYear != null}
        xp={xp}
        streak={streak.current_streak}
        masteredCount={masteredCount}
        dueCount={dueCount}
      />

      {/* เลือกชั้นปี — จุดเริ่มต้น ยกขึ้นมาบนสุด */}
      <div className="mb-8">
        <div className="flex items-center gap-2 mb-1">
          <GraduationCap className="h-5 w-5 text-brand" />
          <h2 className="text-2xl font-bold">1. เลือกชั้นปีของคุณ</h2>
        </div>
        <p className="text-sm text-muted-foreground mb-4">
          แตะปีที่คุณกำลังเรียน เพื่อดูหัวข้อทั้งหมดของปีนั้น
        </p>
        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-3">
          {YEARS.map((y) => {
            const topicCount = topicsByYear[y]?.length ?? 0;
            const disabled = topicCount === 0;
            const isCurrent = y === currentYear;
            return (
              <Link
                key={y}
                href={disabled ? "#" : `/school/${y}`}
                aria-disabled={disabled}
                className={disabled ? "pointer-events-none" : ""}
              >
                <Card
                  className={[
                    "h-full transition-all relative",
                    disabled
                      ? "opacity-50"
                      : "hover:shadow-md hover:border-brand/30 cursor-pointer",
                    isCurrent ? "border-brand border-2 bg-brand/5" : "",
                  ].join(" ")}
                >
                  <CardContent className="p-4 text-center">
                    {isCurrent && (
                      <Badge className="absolute -top-2 left-1/2 -translate-x-1/2 bg-brand text-white text-[10px] px-2">
                        ชั้นปีของคุณ
                      </Badge>
                    )}
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

      {user && (
        <>
          {/* XP / Level banner */}
          {(() => {
            const lvl = xpToLevel(xp);
            return (
              <Card className="mb-4 border-amber-200 bg-gradient-to-r from-amber-50 to-yellow-50">
                <CardContent className="p-4">
                  <div className="flex items-center gap-3 mb-2">
                    <Zap className="h-8 w-8 text-amber-600" />
                    <div className="flex-1">
                      <p className="text-xs text-muted-foreground">
                        Level {lvl.level} · {xp} XP · {badgeCount} badges
                      </p>
                      <p className="font-bold text-amber-700">
                        ถัดไป Level {lvl.level + 1} ({lvl.nextAt - xp} XP)
                      </p>
                    </div>
                    <Link href="/school/leaderboard">
                      <Button variant="outline" size="sm" className="gap-1">
                        <Trophy className="h-4 w-4" /> Leaderboard
                      </Button>
                    </Link>
                  </div>
                  <div className="h-2 bg-amber-100 rounded-full overflow-hidden">
                    <div
                      className="h-full bg-amber-500 transition-all"
                      style={{ width: `${lvl.progress}%` }}
                    />
                  </div>
                </CardContent>
              </Card>
            );
          })()}

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

          {isAdmin && (
            <div className="mb-4">
              <Link href="/admin/school">
                <Button variant="outline" size="sm" className="gap-2">
                  <Database className="h-4 w-4" /> Admin · Manage content
                </Button>
              </Link>
            </div>
          )}

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

          {/* Weekly quests — รวมเป้าหมายของสัปดาห์ไว้ที่เดียว */}
          {quests.length > 0 && <WeeklyQuests quests={quests} />}
        </>
      )}

      {/* โหมดทั้งหมด จัดเป็นหมวดหมู่ — ค่อยๆ ปลดล็อกตามความก้าวหน้า */}
      <div className="mb-12">
        <div className="flex items-center gap-2 mb-1">
          <Layers className="h-5 w-5 text-brand" />
          <h2 className="text-2xl font-bold">2. เครื่องมือทั้งหมด</h2>
        </div>
        <p className="text-sm text-muted-foreground mb-6">
          เครื่องมือที่ล็อกอยู่จะค่อยๆ ปลดล็อกเมื่อคุณเรียนคืบหน้า — ไม่ต้องรีบ ทำทีละนิด
        </p>
        <ToolGrid state={unlockState} />
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
            <p className="text-muted-foreground">AI ตั้งคำถาม &quot;ทำไม / อย่างไร?&quot; บังคับคิดถึงกลไก — Dunlosky 2013</p>
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
