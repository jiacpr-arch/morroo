"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  RadarChart, PolarGrid, PolarAngleAxis, PolarRadiusAxis, Radar,
  AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer,
} from "recharts";
import {
  Activity, BookOpen, Brain, Clock, Flame, GraduationCap,
  Target, Trophy, Medal, TrendingUp, ChevronRight, Stethoscope,
  Award, Share2, CalendarDays, Zap, Loader2,
} from "lucide-react";
import { createClient } from "@/lib/supabase/client";

// ===== Mock Data (โครงสร้างตรงกับ DB schema จริง) =====
// TODO: Replace with real Supabase queries

const student = {
  name: "นพ.สมชาย",
  rank: "Resident",
  rankIcon: "🩺",
  xp: 1250,
  xpNext: 2000,
  streak: 12,
  totalQuestions: 847,
  avgScore: 72,
  membershipType: "monthly" as const,
};

const subjectScores = [
  { name: "cardio_med", name_th: "อายุรฯ หัวใจ", icon: "❤️", score: 78, total: 50, trend: "+5", color: "var(--chart-1)" },
  { name: "surgery", name_th: "ศัลยศาสตร์", icon: "🔪", score: 65, total: 40, trend: "+3", color: "var(--chart-2)" },
  { name: "ped", name_th: "กุมารฯ", icon: "👶", score: 82, total: 35, trend: "+8", color: "var(--chart-3)" },
  { name: "ob_gyn", name_th: "สูติ-นรีเวช", icon: "🤰", score: 74, total: 30, trend: "+4", color: "var(--chart-4)" },
  { name: "psychi", name_th: "จิตเวช", icon: "🧘", score: 88, total: 25, trend: "+2", color: "var(--chart-5)" },
  { name: "ortho", name_th: "ออร์โธปิดิกส์", icon: "🦴", score: 55, total: 20, trend: "-2", color: "var(--chart-1)" },
  { name: "neuro_med", name_th: "ประสาทวิทยา", icon: "🧠", score: 60, total: 28, trend: "+6", color: "var(--chart-2)" },
  { name: "infectious_med", name_th: "โรคติดเชื้อ", icon: "🦠", score: 70, total: 32, trend: "+1", color: "var(--chart-3)" },
];

const radarData = subjectScores.map((s) => ({
  subject: s.name_th,
  score: s.score,
  fullMark: 100,
}));

const weeklyData = [
  { day: "จ.", score: 68, questions: 25 },
  { day: "อ.", score: 72, questions: 30 },
  { day: "พ.", score: 65, questions: 20 },
  { day: "พฤ.", score: 78, questions: 35 },
  { day: "ศ.", score: 74, questions: 28 },
  { day: "ส.", score: 82, questions: 40 },
  { day: "อา.", score: 76, questions: 32 },
];

const weakTopics = [
  { topic: "Acid-Base Balance", subject: "อายุรฯ ไต", subjectName: "nephro_med", score: 35, priority: "high" as const, suggestion: "ทำ MCQ อีก 10 ข้อ" },
  { topic: "EKG Interpretation", subject: "อายุรฯ หัวใจ", subjectName: "cardio_med", score: 42, priority: "high" as const, suggestion: "ทำ MEQ Case ใหม่" },
  { topic: "Fracture Classification", subject: "ออร์โธปิดิกส์", subjectName: "ortho", score: 48, priority: "medium" as const, suggestion: "ทบทวน MCQ 5 ข้อ" },
  { topic: "Neonatal Jaundice", subject: "กุมารฯ", subjectName: "ped", score: 52, priority: "medium" as const, suggestion: "ทำ Long Case ใหม่" },
  { topic: "Drug Interaction", subject: "เภสัชวิทยา", subjectName: "pharmacology", score: 55, priority: "medium" as const, suggestion: "ทบทวนสูตร + MCQ 5 ข้อ" },
];

const studyPlan = [
  {
    time: "วันนี้",
    tasks: [
      { icon: "🫘", task: "MCQ อายุรฯ ไต: Acid-Base Balance 10 ข้อ (Easy→Medium)", type: "weakness" as const },
      { icon: "❤️", task: "MEQ Case: EKG Interpretation 1 เคส", type: "weakness" as const },
      { icon: "🔥", task: "Daily Challenge: Mixed 5 ข้อ", type: "challenge" as const },
    ],
  },
  {
    time: "พรุ่งนี้",
    tasks: [
      { icon: "🦴", task: "MCQ ออร์โธฯ: Fracture Classification 10 ข้อ", type: "weakness" as const },
      { icon: "👶", task: "Long Case: Neonatal Jaundice", type: "weakness" as const },
      { icon: "📊", task: "Mock Exam: NL2 เต็มชุด (ถ้ามีเวลา)", type: "mock" as const },
    ],
  },
  {
    time: "สัปดาห์นี้",
    tasks: [
      { icon: "🎯", task: "ทำครบทุกสาขาที่อ่อน อย่างน้อยสาขาละ 20 ข้อ", type: "goal" as const },
      { icon: "🏆", task: "เข้าร่วม Weekly Challenge", type: "challenge" as const },
      { icon: "📋", task: "Long Case อย่างน้อย 2 เคส", type: "goal" as const },
    ],
  },
];

const badges = [
  { name: "Streak 7 วัน", icon: "🔥", earned: true, date: "15 มี.ค." },
  { name: "ทำครบ 100 ข้อ", icon: "💯", earned: true, date: "22 มี.ค." },
  { name: "Top 3 Weekly", icon: "🏆", earned: true, date: "28 มี.ค." },
  { name: "Speed Demon", icon: "⚡", earned: true, date: "1 เม.ย." },
  { name: "Streak 30 วัน", icon: "👑", earned: false, progress: "12/30" },
  { name: "ทำครบ 1,000 ข้อ", icon: "🎯", earned: false, progress: "847/1000" },
  { name: "Advanced Solver", icon: "🔬", earned: false, progress: "35/50" },
  { name: "Perfect Score", icon: "💎", earned: false, progress: "0/1" },
];

const challengeHistory = [
  { title: "Weekly Challenge #12", type: "weekly" as const, score: 85, total: 10, correct: 8, rank: 3, time: "2 ชม.ที่แล้ว" },
  { title: "Monthly Challenge มี.ค.", type: "monthly" as const, score: 72, total: 20, correct: 14, rank: 15, time: "3 วันที่แล้ว" },
  { title: "Weekly Challenge #11", type: "weekly" as const, score: 90, total: 10, correct: 9, rank: 1, time: "1 สัปดาห์ที่แล้ว" },
];

const tabs = [
  { value: "overview", label: "ภาพรวม", icon: Activity },
  { value: "weakness", label: "จุดอ่อน & แผนติว", icon: Target },
  { value: "challenge", label: "Challenge", icon: Trophy },
  { value: "badges", label: "Badge & Rank", icon: Award },
];

// ===== Helper Components =====

function ProgressRing({ pct, size = 44, stroke = 4, color }: { pct: number; size?: number; stroke?: number; color: string }) {
  const r = (size - stroke) / 2;
  const c = 2 * Math.PI * r;
  const offset = c - (pct / 100) * c;
  return (
    <svg width={size} height={size} style={{ transform: "rotate(-90deg)" }}>
      <circle cx={size / 2} cy={size / 2} r={r} fill="none" stroke="currentColor" strokeWidth={stroke} className="text-muted" />
      <circle cx={size / 2} cy={size / 2} r={r} fill="none" stroke={color} strokeWidth={stroke} strokeDasharray={c} strokeDashoffset={offset} strokeLinecap="round" style={{ transition: "stroke-dashoffset 0.8s ease" }} />
    </svg>
  );
}

function StatBox({ icon: Icon, label, value, color }: { icon: React.ElementType; label: string; value: string | number; color?: string }) {
  return (
    <div className="flex flex-col items-center gap-1">
      <div className={`text-lg font-extrabold ${color || "text-foreground"}`}>
        <Icon className="inline size-4 mr-0.5" />
        {value}
      </div>
      <div className="text-xs text-muted-foreground">{label}</div>
    </div>
  );
}

// ===== Main Component =====

export default function DashboardPage() {
  const [tab, setTab] = useState("overview");
  const [microQuiz, setMicroQuiz] = useState(false);
  const [authLoading, setAuthLoading] = useState(true);
  const router = useRouter();

  useEffect(() => {
    const supabase = createClient();
    supabase.auth.getUser().then(({ data }) => {
      if (!data.user) {
        router.replace("/login");
      } else {
        setAuthLoading(false);
      }
    });
  }, [router]);

  const xpPct = Math.round((student.xp / student.xpNext) * 100);

  if (authLoading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <Loader2 className="h-8 w-8 animate-spin text-brand" />
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-4xl px-4 py-6 sm:px-6 lg:px-8">
      {/* Top Bar */}
      <div className="flex flex-wrap items-center justify-between gap-4 mb-5">
        <div className="flex items-center gap-3">
          <div className="flex size-11 items-center justify-center rounded-xl bg-primary text-lg text-primary-foreground">
            {student.rankIcon}
          </div>
          <div>
            <div className="font-bold text-base">{student.name}</div>
            <div className="text-xs text-muted-foreground">
              {student.rankIcon} {student.rank} &middot; {student.xp.toLocaleString()} XP
            </div>
          </div>
        </div>
        <div className="flex gap-5">
          <StatBox icon={Flame} label="Streak" value={student.streak} color="text-destructive" />
          <StatBox icon={BookOpen} label="ข้อ" value={student.totalQuestions} color="text-primary" />
          <StatBox icon={TrendingUp} label="เฉลี่ย" value={`${student.avgScore}%`} color="text-accent" />
        </div>
      </div>

      {/* XP Bar */}
      <Card size="sm" className="mb-4">
        <CardContent className="flex items-center gap-3">
          <span className="text-xs text-muted-foreground whitespace-nowrap">
            {student.rankIcon} {student.rank}
          </span>
          <div className="flex-1 h-2 bg-muted rounded-full overflow-hidden">
            <div
              className="h-full bg-primary rounded-full transition-all duration-500"
              style={{ width: `${xpPct}%` }}
            />
          </div>
          <span className="text-xs font-semibold text-primary whitespace-nowrap">
            {student.xp.toLocaleString()}/{student.xpNext.toLocaleString()} XP
          </span>
          <span className="text-xs text-muted-foreground">
            &rarr; <GraduationCap className="inline size-3.5" />
          </span>
        </CardContent>
      </Card>

      {/* Quick Quiz Banner */}
      {!microQuiz && (
        <Card
          size="sm"
          className="mb-4 cursor-pointer border-primary/20 bg-primary/5 hover:bg-primary/10 transition-colors"
          onClick={() => setMicroQuiz(true)}
        >
          <CardContent className="flex items-center justify-between">
            <div>
              <div className="font-bold text-sm flex items-center gap-1.5">
                <Stethoscope className="size-4 text-primary" />
                Quick Quiz 5 นาที
              </div>
              <div className="text-xs text-muted-foreground">5 ข้อ MCQ จากสาขาที่อ่อน &middot; ได้ XP + Streak</div>
            </div>
            <Button size="sm">
              เริ่มเลย <ChevronRight className="size-3.5" />
            </Button>
          </CardContent>
        </Card>
      )}
      {microQuiz && (
        <Card size="sm" className="mb-4 border-primary/20">
          <CardContent>
            <div className="flex justify-between mb-3">
              <span className="font-bold text-sm">
                <Stethoscope className="inline size-4 mr-1" />
                Quick Quiz &mdash; อายุรฯ ไต: Acid-Base
              </span>
              <span className="text-primary font-bold text-sm flex items-center gap-1">
                <Clock className="size-3.5" /> 4:32
              </span>
            </div>
            <div className="bg-muted rounded-lg p-3 mb-3 text-sm">
              <div className="text-xs text-muted-foreground mb-1">ข้อ 1/5 (Easy)</div>
              ผู้ป่วยมี pH 7.28, HCO3- 14, pCO2 30 สภาวะนี้คือ?
            </div>
            {[
              "Metabolic acidosis with respiratory compensation",
              "Respiratory acidosis",
              "Metabolic alkalosis",
              "Mixed acid-base disorder",
            ].map((c, i) => (
              <div
                key={i}
                className={`p-2.5 rounded-lg mb-1.5 text-sm cursor-pointer border transition-colors ${
                  i === 0
                    ? "bg-primary/5 border-primary/30"
                    : "bg-muted border-transparent hover:border-border"
                }`}
              >
                {["A", "B", "C", "D"][i]}. {c}
              </div>
            ))}
            <div className="text-right mt-2">
              <Button size="sm" onClick={() => setMicroQuiz(false)}>
                ข้อถัดไป <ChevronRight className="size-3.5" />
              </Button>
            </div>
          </CardContent>
        </Card>
      )}

      {/* Tabs */}
      <div className="flex gap-2 mb-5 overflow-x-auto pb-1">
        {tabs.map((t) => (
          <button
            key={t.value}
            onClick={() => setTab(t.value)}
            className={`flex items-center gap-1.5 px-3.5 py-2 rounded-lg border text-xs font-semibold whitespace-nowrap transition-colors cursor-pointer ${
              tab === t.value
                ? "border-primary bg-primary/10 text-primary"
                : "border-border text-muted-foreground hover:bg-muted"
            }`}
          >
            <t.icon className="size-3.5" />
            {t.label}
          </button>
        ))}
      </div>

      {/* TAB: Overview */}
      {tab === "overview" && (
        <div className="space-y-4">
          {/* Radar Chart */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Brain className="size-4 text-primary" />
                คะแนนเฉลี่ยแยกสาขา
              </CardTitle>
            </CardHeader>
            <CardContent>
              <ResponsiveContainer width="100%" height={260}>
                <RadarChart data={radarData} cx="50%" cy="50%" outerRadius="70%">
                  <PolarGrid stroke="var(--border)" />
                  <PolarAngleAxis dataKey="subject" tick={{ fill: "var(--muted-foreground)", fontSize: 11 }} />
                  <PolarRadiusAxis angle={90} domain={[0, 100]} tick={{ fill: "var(--muted-foreground)", fontSize: 10 }} />
                  <Radar dataKey="score" stroke="var(--primary)" fill="var(--primary)" fillOpacity={0.15} strokeWidth={2} />
                </RadarChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>

          {/* Subject Cards */}
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-3">
            {subjectScores.map((s) => (
              <Card key={s.name} size="sm" className={s.score < 60 ? "border-destructive/30" : ""}>
                <CardContent className="relative">
                  {s.score < 60 && (
                    <Badge variant="destructive" className="absolute top-0 right-0 text-[10px]">
                      ต้องเพิ่ม!
                    </Badge>
                  )}
                  <div className="flex items-center gap-2 mb-2">
                    <span className="text-lg">{s.icon}</span>
                    <span className="font-semibold text-xs">{s.name_th}</span>
                  </div>
                  <div className="flex items-baseline gap-1.5">
                    <span className={`text-2xl font-extrabold ${
                      s.score >= 75 ? "text-green-600" : s.score >= 60 ? "text-yellow-600" : "text-destructive"
                    }`}>
                      {s.score}%
                    </span>
                    <span className={`text-[10px] font-medium ${
                      s.trend.startsWith("+") ? "text-green-600" : "text-destructive"
                    }`}>
                      {s.trend}%
                    </span>
                  </div>
                  <div className="h-1.5 bg-muted rounded-full mt-2 overflow-hidden">
                    <div
                      className="h-full rounded-full transition-all"
                      style={{ width: `${s.score}%`, background: s.color }}
                    />
                  </div>
                  <div className="text-[10px] text-muted-foreground mt-1.5">ทำแล้ว {s.total} ข้อ</div>
                </CardContent>
              </Card>
            ))}
          </div>

          {/* Weekly Trend */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <TrendingUp className="size-4 text-primary" />
                คะแนนเฉลี่ย 7 วันล่าสุด
              </CardTitle>
            </CardHeader>
            <CardContent>
              <ResponsiveContainer width="100%" height={180}>
                <AreaChart data={weeklyData}>
                  <CartesianGrid strokeDasharray="3 3" stroke="var(--border)" />
                  <XAxis dataKey="day" tick={{ fill: "var(--muted-foreground)", fontSize: 11 }} />
                  <YAxis domain={[50, 100]} tick={{ fill: "var(--muted-foreground)", fontSize: 10 }} />
                  <Tooltip
                    contentStyle={{
                      background: "var(--card)",
                      border: "1px solid var(--border)",
                      borderRadius: 8,
                      fontSize: 12,
                    }}
                  />
                  <Area type="monotone" dataKey="score" stroke="var(--primary)" fill="var(--primary)" fillOpacity={0.1} strokeWidth={2} />
                </AreaChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>
        </div>
      )}

      {/* TAB: Weakness & Study Plan */}
      {tab === "weakness" && (
        <div className="space-y-4">
          {/* AI Weakness Detector */}
          <Card className="border-destructive/20">
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Target className="size-4 text-destructive" />
                AI ตรวจจุดอ่อน
              </CardTitle>
              <CardDescription>
                วิเคราะห์จาก {student.totalQuestions} ข้อที่ทำมา &mdash; เรียงจากอ่อนที่สุด
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-2">
              {weakTopics.map((w, i) => (
                <div key={i} className="flex items-center gap-3 p-3 bg-muted rounded-lg">
                  <div className="relative">
                    <ProgressRing
                      pct={w.score}
                      size={44}
                      stroke={4}
                      color={w.priority === "high" ? "var(--destructive)" : "#eab308"}
                    />
                    <div className={`absolute inset-0 flex items-center justify-center text-[10px] font-bold ${
                      w.priority === "high" ? "text-destructive" : "text-yellow-600"
                    }`}>
                      {w.score}%
                    </div>
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="font-semibold text-sm">{w.topic}</div>
                    <div className="text-xs text-muted-foreground truncate">{w.subject} &middot; {w.suggestion}</div>
                  </div>
                  <Button size="xs" variant="ghost" className="text-primary shrink-0">
                    ฝึกเลย <ChevronRight className="size-3" />
                  </Button>
                </div>
              ))}
            </CardContent>
          </Card>

          {/* AI Study Plan */}
          <Card className="border-primary/20">
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Brain className="size-4 text-primary" />
                แผนติว AI (สร้างจากจุดอ่อนของคุณ)
              </CardTitle>
              <CardDescription>AI วางแผนให้อัตโนมัติ &mdash; กดทำได้เลย</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              {studyPlan.map((sp, si) => (
                <div key={si}>
                  <div className={`text-xs font-bold mb-2 flex items-center gap-1.5 ${
                    si === 0 ? "text-green-600" : si === 1 ? "text-primary" : "text-yellow-600"
                  }`}>
                    <CalendarDays className="size-3.5" />
                    {sp.time}
                  </div>
                  <div className="space-y-1.5">
                    {sp.tasks.map((t, ti) => (
                      <div key={ti} className="flex items-center gap-2 p-2 bg-muted rounded-lg text-sm">
                        <span>{t.icon}</span>
                        <span className="flex-1 text-muted-foreground">{t.task}</span>
                        <Badge
                          variant="secondary"
                          className={`text-[10px] ${
                            t.type === "weakness"
                              ? "bg-red-100 text-red-700"
                              : t.type === "challenge"
                              ? "bg-purple-100 text-purple-700"
                              : t.type === "mock"
                              ? "bg-yellow-100 text-yellow-700"
                              : "bg-green-100 text-green-700"
                          }`}
                        >
                          {t.type === "weakness" ? "จุดอ่อน" : t.type === "challenge" ? "ท้าทาย" : t.type === "mock" ? "Mock" : "เป้าหมาย"}
                        </Badge>
                      </div>
                    ))}
                  </div>
                </div>
              ))}
            </CardContent>
          </Card>

          {/* AI Study Buddy */}
          <Card size="sm" className="border-purple-200 bg-purple-50/50">
            <CardContent className="flex gap-3 items-start">
              <span className="text-2xl">🤖</span>
              <div>
                <div className="font-bold text-sm text-purple-700">AI Study Buddy แจ้งเตือน</div>
                <div className="text-xs text-muted-foreground leading-relaxed mt-1">
                  &ldquo;เห็นว่าสาขาอายุรฯ ไต เรื่อง Acid-Base ยังอ่อนอยู่ ถ้าทำวันนี้อีก 10 ข้อ น่าจะขึ้น 50% ได้ ลองดูไหม?&rdquo;
                </div>
              </div>
            </CardContent>
          </Card>
        </div>
      )}

      {/* TAB: Challenge */}
      {tab === "challenge" && (
        <div className="space-y-4">
          {/* Active Challenge */}
          <Card className="border-primary/20 bg-primary/5 text-center">
            <CardContent className="py-6">
              <Trophy className="mx-auto size-10 text-primary mb-3" />
              <div className="font-extrabold text-lg mb-1">Challenge</div>
              <div className="text-sm text-muted-foreground mb-5">
                แข่งกับเพื่อนร่วมรุ่น ใครคะแนนสูงและเร็วกว่าชนะ!
              </div>
              <div className="flex gap-3 justify-center flex-wrap">
                <Button>
                  <Zap className="size-4" />
                  Weekly Challenge
                </Button>
                <Button variant="outline">
                  <CalendarDays className="size-4" />
                  Monthly Challenge
                </Button>
              </div>
            </CardContent>
          </Card>

          {/* Challenge History */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <BookOpen className="size-4 text-primary" />
                ประวัติ Challenge
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-2">
              {challengeHistory.map((ch, i) => (
                <div key={i} className="flex items-center gap-3 p-3 bg-muted rounded-lg">
                  <div className={`flex size-9 items-center justify-center rounded-lg text-sm font-extrabold ${
                    ch.rank <= 3
                      ? "bg-yellow-100 text-yellow-700"
                      : "bg-muted-foreground/10 text-muted-foreground"
                  }`}>
                    {ch.rank <= 3 ? <Medal className="size-4" /> : `#${ch.rank}`}
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="font-semibold text-sm">
                      {ch.title}
                      <Badge variant="secondary" className="ml-2 text-[10px]">
                        {ch.type === "weekly" ? "Weekly" : "Monthly"}
                      </Badge>
                    </div>
                    <div className="text-xs text-muted-foreground">{ch.time}</div>
                  </div>
                  <div className="text-right">
                    <div className="font-extrabold text-base text-primary">{ch.score}%</div>
                    <div className="text-[10px] text-muted-foreground">{ch.correct}/{ch.total} ข้อ</div>
                  </div>
                </div>
              ))}
            </CardContent>
          </Card>

          {/* Challenge Stats */}
          <div className="grid grid-cols-3 gap-3">
            {[
              { label: "เข้าร่วม", value: "8", color: "text-primary" },
              { label: "คะแนนเฉลี่ย", value: "79%", color: "text-green-600" },
              { label: "อันดับดีสุด", value: "#1", color: "text-yellow-600" },
            ].map((s, i) => (
              <Card key={i} size="sm" className="text-center">
                <CardContent>
                  <div className={`text-xl font-extrabold ${s.color}`}>{s.value}</div>
                  <div className="text-xs text-muted-foreground">{s.label}</div>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      )}

      {/* TAB: Badges & Rank */}
      {tab === "badges" && (
        <div className="space-y-4">
          {/* Badges */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Award className="size-4 text-primary" />
                Digital Badges
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
                {badges.map((b, i) => (
                  <div
                    key={i}
                    className={`rounded-xl border p-3 text-center transition-colors ${
                      b.earned
                        ? "bg-green-50 border-green-200"
                        : "bg-muted/50 border-border opacity-60"
                    }`}
                  >
                    <div className="text-2xl mb-1">{b.icon}</div>
                    <div className="font-semibold text-xs">{b.name}</div>
                    {b.earned ? (
                      <div className="text-[10px] text-green-600 mt-1">&#10003; ได้รับ {b.date}</div>
                    ) : (
                      <div className="text-[10px] text-yellow-600 mt-1">&#128274; {b.progress}</div>
                    )}
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>

          {/* Shareable Badge Card */}
          <Card className="border-primary/20 bg-gradient-to-br from-card to-muted text-center">
            <CardContent className="py-6">
              <div className="text-[10px] font-semibold text-primary tracking-widest mb-2">DIGITAL BADGE CARD</div>
              <div className="text-2xl mb-1">
                {badges.filter((b) => b.earned).map((b) => b.icon).join(" ")}
              </div>
              <div className="font-extrabold text-base">{student.name}</div>
              <div className="text-sm text-muted-foreground">
                {student.rankIcon} {student.rank} &middot; {student.xp.toLocaleString()} XP &middot; {student.totalQuestions} ข้อ
              </div>
              <div className="text-xs text-muted-foreground mt-2">ใส่ใน Portfolio ได้!</div>
              <Button size="sm" className="mt-4">
                <Share2 className="size-3.5" />
                แชร์ / ดาวน์โหลด
              </Button>
            </CardContent>
          </Card>
        </div>
      )}

      {/* Footer */}
      <div className="text-center text-xs text-muted-foreground py-6">
        หมอรู้ MorRoo &mdash; Student Dashboard
      </div>
    </div>
  );
}
