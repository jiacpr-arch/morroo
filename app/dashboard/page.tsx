"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { createClient } from "@/lib/supabase/client";
import {
  Loader2,
  Target,
  Clock,
  TrendingUp,
  TrendingDown,
  AlertTriangle,
  BookOpen,
  BarChart3,
  ArrowRight,
  Flame,
  Users,
  Sparkles,
} from "lucide-react";
import { AccuracyTrendChart } from "@/components/AccuracyTrendChart";
import AllExamsCountdown from "@/components/AllExamsCountdown";
import LeaderboardCard from "@/components/LeaderboardCard";
import OnboardingChecklist from "@/components/OnboardingChecklist";

interface SubjectStat {
  subject_id: string;
  subject_name: string;
  subject_name_th: string;
  subject_icon: string;
  total_attempts: number;
  correct_count: number;
  accuracy: number;
  avg_time_spent: number | null;
}

interface RecentSession {
  session_id: string;
  mode: string;
  exam_type: string;
  subject_name_th: string | null;
  subject_icon: string | null;
  total_questions: number;
  correct_count: number;
  accuracy: number;
  created_at: string;
  completed_at: string;
}

interface WeakTopic {
  subject_id: string;
  subject_name: string;
  subject_name_th: string;
  subject_icon: string;
  total_attempts: number;
  correct_count: number;
  accuracy: number;
  wrong_count: number;
}

interface AccuracyTrend {
  week_start: string;
  total_attempts: number;
  correct_count: number;
  accuracy: number;
}

interface SubjectComparison {
  subject_id: string;
  subject_name_th: string;
  subject_icon: string;
  user_accuracy: number;
  global_accuracy: number;
  diff: number;
}

export default function DashboardPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [userId, setUserId] = useState<string | null>(null);
  const [subjectStats, setSubjectStats] = useState<SubjectStat[]>([]);
  const [recentSessions, setRecentSessions] = useState<RecentSession[]>([]);
  const [weakTopics, setWeakTopics] = useState<WeakTopic[]>([]);
  const [trend, setTrend] = useState<AccuracyTrend[]>([]);
  const [streak, setStreak] = useState(0);
  const [comparison, setComparison] = useState<SubjectComparison[]>([]);
  const [dailyGoal, setDailyGoal] = useState(20);
  const [todayCount, setTodayCount] = useState(0);
  const [lineLinked, setLineLinked] = useState(false);
  const [newQuestions, setNewQuestions] = useState<{
    count: number;
    difficulty: { easy: number; medium: number; hard: number };
    subjectId: string | null;
    subjectNameTh: string | null;
    subjectIcon: string | null;
  }>({ count: 0, difficulty: { easy: 0, medium: 0, hard: 0 }, subjectId: null, subjectNameTh: null, subjectIcon: null });
  const [dailyMcq, setDailyMcq] = useState<{
    id: string;
    scenario: string;
    difficulty: string;
    subject_id: string;
    subject_name_th: string;
    subject_icon: string;
    exam_type: string;
  } | null>(null);

  useEffect(() => {
    async function load() {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();

      if (!user) {
        router.push("/login");
        return;
      }

      setUserId(user.id);

      const todayStart = new Date();
      todayStart.setHours(0, 0, 0, 0);

      const [statsRes, sessionsRes, weakRes, trendRes, streakRes, compRes, profileRes, todayRes, dailyRes] =
        await Promise.all([
          supabase.rpc("get_user_subject_stats", { p_user_id: user.id }),
          supabase.rpc("get_user_recent_sessions", {
            p_user_id: user.id,
            p_limit: 10,
          }),
          supabase.rpc("get_user_weak_topics", {
            p_user_id: user.id,
            p_threshold: 60,
          }),
          supabase.rpc("get_user_accuracy_trend", { p_user_id: user.id }),
          supabase.rpc("get_user_streak", { p_user_id: user.id }),
          supabase.rpc("get_user_vs_global_avg", { p_user_id: user.id }),
          supabase.from("profiles").select("daily_goal, line_user_id").eq("id", user.id).single(),
          supabase.from("mcq_attempts")
            .select("id", { count: "exact", head: true })
            .eq("user_id", user.id)
            .gte("created_at", todayStart.toISOString()),
          supabase.rpc("get_daily_mcq"),
        ]);

      setSubjectStats((statsRes.data as SubjectStat[]) || []);
      setRecentSessions((sessionsRes.data as RecentSession[]) || []);
      setWeakTopics((weakRes.data as WeakTopic[]) || []);
      setTrend((trendRes.data as AccuracyTrend[]) || []);
      setStreak((streakRes.data as number) ?? 0);
      setComparison((compRes.data as SubjectComparison[]) || []);
      setDailyGoal(profileRes.data?.daily_goal ?? 20);
      setLineLinked(!!profileRes.data?.line_user_id);
      setTodayCount(todayRes.count ?? 0);
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      const dailyRow = (dailyRes.data as any[])?.[0];
      if (dailyRow) setDailyMcq(dailyRow);

      // Fetch today's new AI-generated questions with difficulty breakdown
      const { data: newQData } = await supabase
        .from("mcq_questions")
        .select("subject_id, difficulty, mcq_subjects(name_th, icon)")
        .eq("status", "active")
        .eq("exam_source", "AI-generated-daily")
        .gte("created_at", todayStart.toISOString());

      if (newQData && newQData.length > 0) {
        const diff = { easy: 0, medium: 0, hard: 0 };
        for (const row of newQData) {
          // eslint-disable-next-line @typescript-eslint/no-explicit-any
          const d = (row as any).difficulty;
          if (d === "easy") diff.easy++;
          else if (d === "hard") diff.hard++;
          else diff.medium++;
        }

        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const first = newQData[0] as any;
        setNewQuestions({
          count: newQData.length,
          difficulty: diff,
          subjectId: first.subject_id,
          subjectNameTh: first.mcq_subjects?.name_th ?? null,
          subjectIcon: first.mcq_subjects?.icon ?? null,
        });
      }

      setLoading(false);
    }
    load();
  }, [router]);

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <Loader2 className="h-8 w-8 animate-spin text-brand" />
      </div>
    );
  }

  const totalAttempts = subjectStats.reduce((s, x) => s + x.total_attempts, 0);
  const totalCorrect = subjectStats.reduce((s, x) => s + x.correct_count, 0);
  const overallAccuracy =
    totalAttempts > 0
      ? Math.round((totalCorrect * 1000) / totalAttempts) / 10
      : 0;
  const bestSubject = [...subjectStats].sort(
    (a, b) => (b.accuracy ?? 0) - (a.accuracy ?? 0)
  )[0];
  const avgTime =
    subjectStats.filter((x) => x.avg_time_spent != null).length > 0
      ? Math.round(
          subjectStats.reduce((s, x) => s + (x.avg_time_spent ?? 0), 0) /
            subjectStats.filter((x) => x.avg_time_spent != null).length
        )
      : 0;

  if (totalAttempts === 0) {
    return (
      <div className="mx-auto max-w-2xl px-4 py-12">
        <div className="mb-8">
          <AllExamsCountdown />
        </div>
        {dailyMcq && (
          <Card className="mb-8 border-brand/40 bg-gradient-to-r from-brand/5 to-amber-50/60">
            <CardContent className="py-5 px-5">
              <div className="flex items-start justify-between gap-4">
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2 mb-2">
                    <Sparkles className="h-4 w-4 text-brand shrink-0" />
                    <span className="text-xs font-semibold text-brand uppercase tracking-wide">
                      โจทย์ประจำวันนี้
                    </span>
                    <span className="text-sm">{dailyMcq.subject_icon}</span>
                    <span className="text-xs text-muted-foreground">{dailyMcq.subject_name_th}</span>
                  </div>
                  <p className="text-sm text-gray-700 line-clamp-2 leading-relaxed">
                    {dailyMcq.scenario.length > 150
                      ? dailyMcq.scenario.slice(0, 150) + "…"
                      : dailyMcq.scenario}
                  </p>
                </div>
                <Link href={`/nl/practice?subject=${dailyMcq.subject_id}`} className="shrink-0">
                  <Button size="sm" className="bg-brand hover:bg-brand-light text-white gap-1.5 whitespace-nowrap">
                    ทำเลย <ArrowRight className="h-3.5 w-3.5" />
                  </Button>
                </Link>
              </div>
            </CardContent>
          </Card>
        )}
        <div className="text-center">
          <BarChart3 className="h-16 w-16 text-muted-foreground mx-auto mb-4" />
          <h1 className="text-2xl font-bold mb-2">ยังไม่มีข้อมูลการเรียน</h1>
          <p className="text-muted-foreground mb-6">
            เริ่มทำข้อสอบเพื่อดูสถิติและจุดอ่อนของคุณ
          </p>
          <Link href="/nl">
            <Button className="bg-brand hover:bg-brand-light text-white">
              เริ่มทำข้อสอบ
            </Button>
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="mb-6">
        <h1 className="text-2xl font-bold">ผลการเรียน</h1>
        <p className="text-muted-foreground mt-1">
          ติดตามความก้าวหน้าและจุดที่ต้องปรับปรุง
        </p>
      </div>

      {/* Onboarding checklist */}
      {userId && <OnboardingChecklist userId={userId} />}

      {/* New Questions Countdown */}
      <div className="mb-4">
        <AllExamsCountdown />
      </div>

      {/* Daily Question Banner */}
      {dailyMcq && (
        <Card className="mb-4 border-brand/40 bg-gradient-to-r from-brand/5 to-amber-50/60 overflow-hidden">
          <CardContent className="py-4 px-5">
            <div className="flex items-start justify-between gap-4">
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2 mb-2">
                  <Sparkles className="h-4 w-4 text-brand shrink-0" />
                  <span className="text-xs font-semibold text-brand uppercase tracking-wide">
                    โจทย์ประจำวันนี้
                  </span>
                  <span className="text-sm">{dailyMcq.subject_icon}</span>
                  <span className="text-xs text-muted-foreground">{dailyMcq.subject_name_th}</span>
                  <span className={`text-xs font-medium px-1.5 py-0.5 rounded-full ${
                    dailyMcq.difficulty === "easy"
                      ? "bg-green-100 text-green-700"
                      : dailyMcq.difficulty === "hard"
                      ? "bg-red-100 text-red-700"
                      : "bg-yellow-100 text-yellow-700"
                  }`}>
                    {dailyMcq.difficulty === "easy" ? "ง่าย" : dailyMcq.difficulty === "hard" ? "ยาก" : "ปานกลาง"}
                  </span>
                </div>
                <p className="text-sm text-gray-700 line-clamp-2 leading-relaxed">
                  {dailyMcq.scenario.length > 150
                    ? dailyMcq.scenario.slice(0, 150) + "…"
                    : dailyMcq.scenario}
                </p>
              </div>
              <Link
                href={`/nl/practice?subject=${dailyMcq.subject_id}`}
                className="shrink-0"
              >
                <Button
                  size="sm"
                  className="bg-brand hover:bg-brand-light text-white gap-1.5 whitespace-nowrap"
                >
                  ทำเลย <ArrowRight className="h-3.5 w-3.5" />
                </Button>
              </Link>
            </div>
          </CardContent>
        </Card>
      )}

      {/* Daily Goal Progress */}
      {(() => {
        const pct = Math.min(100, Math.round((todayCount / dailyGoal) * 100));
        const done = todayCount >= dailyGoal;
        return (
          <Card className={`mb-6 ${done ? "border-green-400" : "border-brand/30"}`}>
            <CardContent className="py-4">
              <div className="flex items-center justify-between mb-2">
                <div className="flex items-center gap-2">
                  <span className="text-lg">{done ? "✅" : "🎯"}</span>
                  <span className="font-semibold text-sm">
                    {done ? "ครบเป้าวันนี้แล้ว!" : "เป้าหมายวันนี้"}
                  </span>
                </div>
                <span className="text-sm font-medium text-muted-foreground">
                  {todayCount} / {dailyGoal} ข้อ
                </span>
              </div>
              <div className="w-full bg-muted rounded-full h-3 overflow-hidden">
                <div
                  className={`h-3 rounded-full transition-all ${done ? "bg-green-500" : "bg-brand"}`}
                  style={{ width: `${pct}%` }}
                />
              </div>
              {!done && (
                <p className="text-xs text-muted-foreground mt-2">
                  อีก {dailyGoal - todayCount} ข้อจะครบเป้า —{" "}
                  <Link href="/nl" className="text-brand hover:underline font-medium">
                    ทำต่อเลย
                  </Link>
                </p>
              )}
            </CardContent>
          </Card>
        );
      })()}

      {/* LINE Add Friend Banner */}
      {!lineLinked && (
        <a
          href="https://line.me/R/ti/p/@508srmcr"
          target="_blank"
          rel="noopener noreferrer"
          className="flex items-center gap-3 mb-6 rounded-xl bg-[#06C755]/10 border border-[#06C755]/30 px-4 py-3 hover:bg-[#06C755]/15 transition-colors"
        >
          <span className="text-2xl shrink-0">💬</span>
          <div className="flex-1 min-w-0">
            <p className="text-sm font-semibold text-green-800">รับข้อสอบทุกเช้าผ่าน LINE</p>
            <p className="text-xs text-green-700">กด Add Friend LINE OA @508srmcr แล้วรับโจทย์ประจำวันทุก 7 โมงเช้า</p>
          </div>
          <span className="text-xs font-semibold text-[#06C755] shrink-0 whitespace-nowrap">เพิ่มเพื่อน →</span>
        </a>
      )}

      {/* Summary Cards */}
      <div className="grid grid-cols-2 lg:grid-cols-5 gap-4 mb-8">
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-lg bg-brand/10 flex items-center justify-center">
                <BookOpen className="h-5 w-5 text-brand" />
              </div>
              <div>
                <p className="text-2xl font-bold">{totalAttempts}</p>
                <p className="text-xs text-muted-foreground">ข้อที่ทำแล้ว</p>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-lg bg-green-100 flex items-center justify-center">
                <Target className="h-5 w-5 text-green-600" />
              </div>
              <div>
                <p className="text-2xl font-bold">{overallAccuracy}%</p>
                <p className="text-xs text-muted-foreground">ถูกต้องรวม</p>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card className={streak >= 3 ? "border-orange-300" : ""}>
          <CardContent className="pt-6">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-lg bg-orange-100 flex items-center justify-center">
                <Flame className={`h-5 w-5 ${streak >= 3 ? "text-orange-500" : "text-orange-300"}`} />
              </div>
              <div>
                <p className="text-2xl font-bold">{streak}</p>
                <p className="text-xs text-muted-foreground">วันติดต่อกัน</p>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-lg bg-blue-100 flex items-center justify-center">
                <TrendingUp className="h-5 w-5 text-blue-600" />
              </div>
              <div>
                <p className="text-lg font-bold truncate">
                  {bestSubject?.subject_icon} {bestSubject?.accuracy ?? 0}%
                </p>
                <p className="text-xs text-muted-foreground">เก่งที่สุด</p>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-lg bg-slate-100 flex items-center justify-center">
                <Clock className="h-5 w-5 text-slate-600" />
              </div>
              <div>
                <p className="text-2xl font-bold">{avgTime}s</p>
                <p className="text-xs text-muted-foreground">เวลาเฉลี่ย/ข้อ</p>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Smart Practice — personalised recommendation */}
      {totalAttempts >= 5 && (
        <Card className="border-brand/40 bg-gradient-to-br from-brand/5 to-amber-50/40 mb-4">
          <CardContent className="py-5 px-5">
            <div className="flex items-start justify-between gap-4">
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2 mb-1">
                  <Sparkles className="h-4 w-4 text-brand shrink-0" />
                  <span className="text-sm font-semibold text-brand">
                    ชุดแนะนำให้คุณ
                  </span>
                </div>
                <p className="text-sm text-gray-700 leading-relaxed">
                  จัดชุด 20 ข้อให้เอง — ทบทวนข้อที่เคยผิด + เสริมสาขาที่คะแนนยังต่ำ
                </p>
              </div>
              <Link href="/nl/practice?mode=recommended" className="shrink-0">
                <Button size="sm" className="bg-brand hover:bg-brand-light text-white gap-1.5 whitespace-nowrap">
                  เริ่มฝึก <ArrowRight className="h-3.5 w-3.5" />
                </Button>
              </Link>
            </div>
          </CardContent>
        </Card>
      )}

      {/* Study Plan CTA */}
      <Card className="border-brand/30 mb-8">
        <CardContent className="py-5 px-5">
          <div className="flex items-start justify-between gap-4">
            <div className="flex-1 min-w-0">
              <div className="flex items-center gap-2 mb-1">
                <Sparkles className="h-4 w-4 text-brand shrink-0" />
                <span className="text-sm font-semibold text-brand">
                  แผนอ่านหนังสือของคุณ
                </span>
              </div>
              <p className="text-sm text-gray-700 leading-relaxed">
                ตั้งวันสอบ → AI วางแผนรายสัปดาห์ให้ตามจุดอ่อนของคุณ
              </p>
            </div>
            <Link href="/study-plan" className="shrink-0">
              <Button size="sm" variant="outline" className="gap-1.5 whitespace-nowrap">
                เปิดแผน <ArrowRight className="h-3.5 w-3.5" />
              </Button>
            </Link>
          </div>
        </CardContent>
      </Card>

      {/* Weak Topics — ควรทบทวน */}
      {weakTopics.length > 0 && (
        <Card className="border-red-200 bg-red-50/50 mb-8">
          <CardHeader className="pb-3">
            <CardTitle className="text-base flex items-center gap-2 text-red-700">
              <AlertTriangle className="h-5 w-5" />
              ควรทบทวน — สาขาที่ถูกต้อง &lt; 60%
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
              {weakTopics.map((topic) => (
                <div
                  key={topic.subject_id}
                  className="flex items-center justify-between rounded-lg bg-white p-3 border border-red-100"
                >
                  <div className="flex items-center gap-2">
                    <span className="text-lg">{topic.subject_icon}</span>
                    <div>
                      <p className="text-sm font-medium">
                        {topic.subject_name_th}
                      </p>
                      <p className="text-xs text-red-600">
                        {topic.accuracy}% ({topic.wrong_count} ข้อผิด)
                      </p>
                    </div>
                  </div>
                  <Link href={`/nl/practice?subject=${topic.subject_id}`}>
                    <Button size="sm" variant="outline" className="text-xs gap-1">
                      ฝึกเพิ่ม <ArrowRight className="h-3 w-3" />
                    </Button>
                  </Link>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      )}

      {/* Leaderboard */}
      {userId && totalAttempts >= 5 && <LeaderboardCard currentUserId={userId} />}

      {/* Comparison vs Global Average */}
      {comparison.length > 0 && (
        <Card className="mb-8">
          <CardHeader>
            <CardTitle className="text-base flex items-center gap-2">
              <Users className="h-5 w-5 text-muted-foreground" />
              เปรียบเทียบกับ avg ผู้ใช้ทั้งหมด
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-2">
              {comparison.map((c) => (
                <div
                  key={c.subject_id}
                  className="flex items-center gap-3 rounded-lg border p-2.5"
                >
                  <span className="text-lg w-7 text-center shrink-0">
                    {c.subject_icon}
                  </span>
                  <p className="text-sm flex-1 truncate">{c.subject_name_th}</p>
                  <div className="flex items-center gap-2 shrink-0">
                    <span className="text-sm font-mono text-muted-foreground">
                      avg {c.global_accuracy}%
                    </span>
                    <span className="text-sm font-bold">→ {c.user_accuracy}%</span>
                    <Badge
                      className={`text-xs min-w-[52px] justify-center ${
                        c.diff > 0
                          ? "bg-green-100 text-green-700"
                          : c.diff < 0
                          ? "bg-red-100 text-red-700"
                          : "bg-gray-100 text-gray-600"
                      }`}
                    >
                      {c.diff > 0 ? "+" : ""}
                      {c.diff}%
                    </Badge>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      )}

      {/* Accuracy Trend Chart */}
      {trend.length >= 2 && (
        <Card className="mb-8">
          <CardHeader>
            <CardTitle className="text-base">
              แนวโน้มความถูกต้องรายสัปดาห์
            </CardTitle>
          </CardHeader>
          <CardContent>
            <AccuracyTrendChart data={trend} />
          </CardContent>
        </Card>
      )}

      {/* Subject Performance Table */}
      <Card className="mb-8">
        <CardHeader>
          <CardTitle className="text-base">สถิติแยกตามสาขา</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-3">
            {subjectStats.map((stat) => {
              const color =
                stat.accuracy >= 80
                  ? "text-green-600"
                  : stat.accuracy >= 60
                  ? "text-yellow-600"
                  : "text-red-600";
              const bgColor =
                stat.accuracy >= 80
                  ? "bg-green-500"
                  : stat.accuracy >= 60
                  ? "bg-yellow-500"
                  : "bg-red-500";
              return (
                <div
                  key={stat.subject_id}
                  className="flex items-center gap-3 rounded-lg border p-3"
                >
                  <span className="text-xl w-8 text-center">
                    {stat.subject_icon}
                  </span>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center justify-between mb-1">
                      <p className="text-sm font-medium truncate">
                        {stat.subject_name_th}
                      </p>
                      <div className="flex items-center gap-2 shrink-0">
                        <span className={`text-sm font-bold ${color}`}>
                          {stat.accuracy}%
                        </span>
                        <span className="text-xs text-muted-foreground">
                          ({stat.correct_count}/{stat.total_attempts})
                        </span>
                      </div>
                    </div>
                    <div className="w-full bg-gray-100 rounded-full h-2">
                      <div
                        className={`h-2 rounded-full ${bgColor}`}
                        style={{ width: `${Math.min(stat.accuracy, 100)}%` }}
                      />
                    </div>
                  </div>
                  <Link href={`/nl/practice?subject=${stat.subject_id}`}>
                    <Button size="icon" variant="ghost" className="h-8 w-8 shrink-0">
                      <ArrowRight className="h-4 w-4" />
                    </Button>
                  </Link>
                </div>
              );
            })}
          </div>
        </CardContent>
      </Card>

      {/* Recent Sessions */}
      {recentSessions.length > 0 && (
        <Card>
          <CardHeader>
            <CardTitle className="text-base">เซสชันล่าสุด</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-2">
              {recentSessions.map((session) => (
                <div
                  key={session.session_id}
                  className="flex items-center justify-between rounded-lg border p-3"
                >
                  <div className="flex items-center gap-3">
                    <span className="text-lg">
                      {session.subject_icon || "📝"}
                    </span>
                    <div>
                      <p className="text-sm font-medium">
                        {session.subject_name_th || "หลายสาขา"}
                      </p>
                      <p className="text-xs text-muted-foreground">
                        {new Date(session.created_at).toLocaleDateString(
                          "th-TH",
                          { day: "numeric", month: "short", year: "2-digit" }
                        )}
                      </p>
                    </div>
                  </div>
                  <div className="flex items-center gap-3">
                    <Badge
                      variant={session.mode === "mock" ? "default" : "secondary"}
                      className="text-xs"
                    >
                      {session.mode === "mock" ? "Mock" : "Practice"}
                    </Badge>
                    <span
                      className={`text-sm font-bold ${
                        session.accuracy >= 60 ? "text-green-600" : "text-red-600"
                      }`}
                    >
                      {session.correct_count}/{session.total_questions} ({session.accuracy}%)
                    </span>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      )}
    </div>
  );
}
