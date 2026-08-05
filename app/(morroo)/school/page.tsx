import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import {
  ArrowRight,
  GraduationCap,
  Clock,
  Flame,
  Target,
  Trophy,
  Zap,
  Database,
} from "lucide-react";
import RankBadge from "@/components/school/RankBadge";
import { xpToRank } from "@/lib/school/rank";
import {
  getSchoolSystems,
  getSchoolTopicsByYear,
  getSchoolTopicCounts,
  getSchoolBookMap,
  getSchoolStreak,
  getDueCount,
  getSchoolMasteryByTopic,
  getWeeklyQuestMetrics,
} from "@/lib/supabase/queries-school";
import {
  buildWeeklyQuests,
  topSystemSlugFor,
  type Quest,
} from "@/lib/school/quests";
import JourneyBanner from "@/components/school/JourneyBanner";
import WeeklyQuests from "@/components/school/WeeklyQuests";
import SubjectRail from "@/components/school/SubjectRail";
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

  const [systems, topicsByYearArr, counts, bookMap] = await Promise.all([
    getSchoolSystems(),
    Promise.all(YEARS.map((y) => getSchoolTopicsByYear(y))),
    getSchoolTopicCounts(),
    getSchoolBookMap(),
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

      {/* ชั้นปี + วิชา — เห็นชื่อวิชาตรงนี้เลย ไม่ต้องกดเข้าไปดูทีละปี */}
      <div className="mb-8 space-y-6">
        <div>
          <div className="flex items-center gap-2 mb-1">
            <GraduationCap className="h-5 w-5 text-brand" />
            <h2 className="text-2xl font-bold">ชั้นปี & วิชา</h2>
          </div>
          <p className="text-sm text-muted-foreground">
            ปัดเลือกวิชาที่อยากเรียนได้เลย
          </p>
        </div>

        {YEARS.map((y) => {
          const yearTopics = topicsByYear[y] ?? [];
          const isCurrent = y === currentYear;

          if (yearTopics.length === 0) {
            return (
              <div
                key={y}
                className="flex items-center gap-2 text-sm text-muted-foreground border rounded-lg px-4 py-3"
              >
                <Badge variant="outline">ปี {y}</Badge>
                {isCurrent && (
                  <Badge className="bg-brand text-white text-[10px]">
                    ชั้นปีของคุณ
                  </Badge>
                )}
                <span>เนื้อหากำลังจัดทำ</span>
              </div>
            );
          }

          // จัดกลุ่มวิชาของปีนี้ตามระบบ (system) เหมือนที่ /school/[year] ทำ
          const bySystem: Record<string, typeof yearTopics> = {};
          for (const t of yearTopics) {
            const key = t.school_systems?.slug ?? "other";
            if (!bySystem[key]) bySystem[key] = [];
            bySystem[key].push(t);
          }

          return (
            <div key={y}>
              <div className="flex items-center gap-2 mb-3">
                <Badge
                  className={
                    isCurrent
                      ? "bg-brand text-white"
                      : "bg-indigo-100 text-indigo-700"
                  }
                >
                  ปี {y}
                </Badge>
                {isCurrent && (
                  <span className="text-xs text-brand font-semibold">
                    ชั้นปีของคุณ
                  </span>
                )}
                <span className="text-xs text-muted-foreground">
                  {yearTopics.length} วิชา
                </span>
              </div>
              <div className="space-y-5 pl-1">
                {Object.entries(bySystem).map(([slug, list]) => {
                  const sys = list[0].school_systems;
                  return (
                    <div key={slug}>
                      {Object.keys(bySystem).length > 1 && (
                        <div className="flex items-center gap-2 mb-2 text-sm">
                          <span>{sys?.icon}</span>
                          <span className="font-medium">{sys?.name_th}</span>
                        </div>
                      )}
                      <SubjectRail
                        subjects={list.map((t) => ({
                          id: t.id,
                          name_th: t.name_th,
                          name_en: t.name_en,
                          code: t.code,
                          credits: t.credits,
                          credit_hours: t.credit_hours,
                          lessons: counts.lessons[t.id] ?? 0,
                          quizzes: counts.quizzes[t.id] ?? 0,
                          bookId: bookMap[t.id],
                        }))}
                      />
                    </div>
                  );
                })}
              </div>
            </div>
          );
        })}
      </div>

      {/* Journey: ก้าวต่อไป + ด่านปลดล็อก (แทน "เริ่มยังไง 3 ขั้น") */}
      <JourneyBanner
        hasYear={currentYear != null}
        xp={xp}
        streak={streak.current_streak}
        masteredCount={masteredCount}
        dueCount={dueCount}
      />

      {user && (
        <>
          {/* XP / Level banner */}
          {(() => {
            const rankNow = xpToRank(xp);
            return (
              <Card className="mb-4 border-amber-200 bg-gradient-to-r from-amber-50 to-yellow-50">
                <CardContent className="p-4">
                  <div className="flex items-center gap-3 mb-2">
                    <Zap className="h-8 w-8 text-amber-600" />
                    <div className="flex-1">
                      <div className="flex flex-wrap items-center gap-2">
                        <RankBadge xp={xp} showLevel size="sm" />
                        <span className="text-xs text-muted-foreground">
                          {xp} XP · {badgeCount} badges
                        </span>
                      </div>
                      <p className="font-bold text-amber-700">
                        {rankNow.next
                          ? `อีก ${(rankNow.xpForNext - rankNow.xpIntoRank).toLocaleString("th-TH")} XP ถึง${rankNow.next.title}`
                          : "ขั้นสูงสุดของสายวิชาการแล้ว"}
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
                      style={{ width: `${rankNow.progress}%` }}
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
    </div>
  );
}
