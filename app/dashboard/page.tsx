"use client";

import { useState, useEffect, useRef, useCallback } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
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
import { toPng } from "html-to-image";

// ===== Types =====

interface StudentData {
  name: string;
  rank: string;
  rankIcon: string;
  xp: number;
  xpNext: number;
  streak: number;
  totalQuestions: number;
  avgScore: number;
  membershipType: string;
}

interface SubjectScore {
  name: string;
  name_th: string;
  icon: string;
  score: number;
  total: number;
  trend: string;
  color: string;
}

interface WeeklyPoint {
  day: string;
  score: number;
  questions: number;
}

interface BadgeData {
  name: string;
  icon: string;
  earned: boolean;
  date?: string;
  progress?: string;
}

interface LongCaseStats {
  total: number;
  completed: number;
  avgScore: number;
  bestScore: number;
  sessions: Array<{
    title: string;
    specialty: string;
    difficulty: string;
    scorePct: number;
    completedAt: string;
  }>;
  sectionAvg: { history: number; pe: number; lab: number; ddx: number; management: number; examiner: number };
}

interface ChallengeData {
  title: string;
  type: "weekly" | "monthly";
  score: number;
  total: number;
  correct: number;
  rank: number;
  time: string;
}

const CHART_COLORS = ["var(--chart-1)", "var(--chart-2)", "var(--chart-3)", "var(--chart-4)", "var(--chart-5)"];

const SUBJECT_ICON_MAP: Record<string, string> = {
  cardio_med: "❤️", chest_med: "🫁", ent: "👂", endocrine: "🦋",
  eye: "👁️", forensic: "🔍", gi_med: "🫄", hemato_med: "🩸",
  infectious_med: "🦠", nephro_med: "🫘", neuro_med: "🧠",
  ob_gyn: "🤰", ortho: "🦴", ped: "👶", psychi: "🧘",
  surgery: "🔪", epidemio: "📊", chest_ped: "🌬️", gi_ped: "👶",
  gd_ped: "🧒", hemato_ped: "🧬", infectious_ped: "🧫",
  uro_surgery: "💧", endocrine_ped: "⚗️",
};

function getRank(totalQuestions: number): { rank: string; icon: string; xp: number; xpNext: number } {
  if (totalQuestions >= 1000) return { rank: "Specialist", icon: "👨‍⚕️", xp: totalQuestions, xpNext: 2000 };
  if (totalQuestions >= 500) return { rank: "Resident", icon: "🩺", xp: totalQuestions, xpNext: 1000 };
  if (totalQuestions >= 100) return { rank: "Intern", icon: "📋", xp: totalQuestions, xpNext: 500 };
  return { rank: "Student", icon: "📖", xp: totalQuestions, xpNext: 100 };
}

// ===== Data Fetching =====

async function fetchDashboardData(supabase: ReturnType<typeof createClient>, userId: string) {
  // Fetch profile
  const { data: profile } = await supabase
    .from("profiles")
    .select("name, display_name, membership_type")
    .eq("id", userId)
    .single();

  // Fetch all MCQ attempts for this user with subject info
  const { data: attempts } = await supabase
    .from("mcq_attempts")
    .select("is_correct, created_at, question_id, mcq_questions!inner(subject_id)")
    .eq("user_id", userId);

  // Fetch subjects
  const { data: subjects } = await supabase
    .from("mcq_subjects")
    .select("id, name, name_th, icon");

  // Fetch user badges
  const { data: userBadges } = await supabase
    .from("user_badges")
    .select("earned_at, badges(name, name_th, icon_url, condition_type)")
    .eq("user_id", userId);

  // Fetch challenge submissions
  const { data: challengeSubs } = await supabase
    .from("challenge_submissions")
    .select("score, total_questions, correct_answers, time_taken_seconds, submitted_at, challenges(title, challenge_type)")
    .eq("user_id", userId)
    .order("submitted_at", { ascending: false })
    .limit(10);

  // Fetch long case sessions
  const { data: longCaseSessions } = await supabase
    .from("long_case_sessions")
    .select("id, phase, score_history, score_pe, score_lab, score_ddx, score_management, score_examiner, score_total_pct, started_at, completed_at, long_cases(title, specialty, difficulty)")
    .eq("user_id", userId)
    .order("started_at", { ascending: false })
    .limit(20);

  return { profile, attempts: attempts || [], subjects: subjects || [], userBadges: userBadges || [], challengeSubs: challengeSubs || [], longCaseSessions: longCaseSessions || [] };
}

function processData(
  profile: { name: string; display_name: string | null; membership_type: string } | null,
  attempts: Array<{ is_correct: boolean; created_at: string; question_id: string; mcq_questions: { subject_id: string } }>,
  subjects: Array<{ id: string; name: string; name_th: string; icon: string }>,
  userBadges: Array<{ earned_at: string; badges: { name: string; name_th: string; icon_url: string | null; condition_type: string } | null }>,
  challengeSubs: Array<{ score: number; total_questions: number; correct_answers: number; time_taken_seconds: number | null; submitted_at: string; challenges: { title: string; challenge_type: string } | null }>,
  longCaseSessions: Array<{ id: string; phase: string; score_history: number | null; score_pe: number | null; score_lab: number | null; score_ddx: number | null; score_management: number | null; score_examiner: number | null; score_total_pct: number | null; started_at: string; completed_at: string | null; long_cases: { title: string; specialty: string; difficulty: string } | null }>,
) {
  const totalQuestions = attempts.length;
  const totalCorrect = attempts.filter(a => a.is_correct).length;
  const avgScore = totalQuestions > 0 ? Math.round((totalCorrect / totalQuestions) * 100) : 0;
  const rankInfo = getRank(totalQuestions);

  // Calculate streak (consecutive days with attempts)
  const daySet = new Set(attempts.map(a => a.created_at.slice(0, 10)));
  let streak = 0;
  const today = new Date();
  for (let i = 0; i < 365; i++) {
    const d = new Date(today);
    d.setDate(d.getDate() - i);
    const ds = d.toISOString().slice(0, 10);
    if (daySet.has(ds)) { streak++; } else if (i > 0) { break; }
  }

  const student: StudentData = {
    name: profile?.display_name || profile?.name || "นักศึกษาแพทย์",
    rank: rankInfo.rank,
    rankIcon: rankInfo.icon,
    xp: rankInfo.xp,
    xpNext: rankInfo.xpNext,
    streak,
    totalQuestions,
    avgScore,
    membershipType: profile?.membership_type || "free",
  };

  // Subject scores
  const subjectMap = new Map(subjects.map(s => [s.id, s]));
  const bySubject: Record<string, { correct: number; total: number }> = {};
  for (const a of attempts) {
    const sid = a.mcq_questions.subject_id;
    if (!bySubject[sid]) bySubject[sid] = { correct: 0, total: 0 };
    bySubject[sid].total++;
    if (a.is_correct) bySubject[sid].correct++;
  }

  const subjectScores: SubjectScore[] = Object.entries(bySubject)
    .map(([sid, stats], i) => {
      const sub = subjectMap.get(sid);
      return {
        name: sub?.name || sid,
        name_th: sub?.name_th || sid,
        icon: sub?.icon || SUBJECT_ICON_MAP[sub?.name || ""] || "📝",
        score: Math.round((stats.correct / stats.total) * 100),
        total: stats.total,
        trend: "", // TODO: calculate from recent vs older attempts
        color: CHART_COLORS[i % CHART_COLORS.length],
      };
    })
    .sort((a, b) => b.total - a.total);

  // Weekly data (last 7 days)
  const dayNames = ["อา.", "จ.", "อ.", "พ.", "พฤ.", "ศ.", "ส."];
  const weeklyData: WeeklyPoint[] = [];
  for (let i = 6; i >= 0; i--) {
    const d = new Date(today);
    d.setDate(d.getDate() - i);
    const ds = d.toISOString().slice(0, 10);
    const dayAttempts = attempts.filter(a => a.created_at.slice(0, 10) === ds);
    const dayCorrect = dayAttempts.filter(a => a.is_correct).length;
    weeklyData.push({
      day: dayNames[d.getDay()],
      score: dayAttempts.length > 0 ? Math.round((dayCorrect / dayAttempts.length) * 100) : 0,
      questions: dayAttempts.length,
    });
  }

  // Badges
  const allBadgeDefs = [
    { condition: "streak", name: "Streak 7 วัน", icon: "🔥" },
    { condition: "total_correct", name: "ทำครบ 100 ข้อ", icon: "💯" },
    { condition: "top_rank", name: "Top 3 Weekly", icon: "🏆" },
    { condition: "speed", name: "Speed Demon", icon: "⚡" },
    { condition: "challenge_complete", name: "Challenge Complete", icon: "🎯" },
    { condition: "total_correct_advanced", name: "Advanced Solver", icon: "🔬" },
  ];
  const earnedSet = new Set(userBadges.map(ub => ub.badges?.condition_type));
  const badges: BadgeData[] = allBadgeDefs.map(bd => {
    const ub = userBadges.find(u => u.badges?.condition_type === bd.condition);
    return {
      name: ub?.badges?.name_th || bd.name,
      icon: bd.icon,
      earned: earnedSet.has(bd.condition),
      date: ub ? new Date(ub.earned_at).toLocaleDateString("th-TH", { day: "numeric", month: "short" }) : undefined,
    };
  });

  // Challenge history
  const challengeHistory: ChallengeData[] = challengeSubs
    .filter(cs => cs.challenges)
    .map(cs => {
      const pct = cs.total_questions > 0 ? Math.round((cs.correct_answers / cs.total_questions) * 100) : 0;
      const submitted = new Date(cs.submitted_at);
      const diffMs = Date.now() - submitted.getTime();
      const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24));
      let time = "";
      if (diffDays === 0) time = "วันนี้";
      else if (diffDays === 1) time = "เมื่อวาน";
      else if (diffDays < 7) time = `${diffDays} วันที่แล้ว`;
      else time = `${Math.floor(diffDays / 7)} สัปดาห์ที่แล้ว`;

      return {
        title: cs.challenges!.title,
        type: cs.challenges!.challenge_type as "weekly" | "monthly",
        score: pct,
        total: cs.total_questions,
        correct: cs.correct_answers,
        rank: 0,
        time,
      };
    });

  // Long Case stats
  const completedLC = longCaseSessions.filter(s => s.completed_at && s.score_total_pct != null);
  const avgLCScore = completedLC.length > 0 ? Math.round(completedLC.reduce((a, s) => a + (s.score_total_pct || 0), 0) / completedLC.length) : 0;
  const bestLCScore = completedLC.length > 0 ? Math.max(...completedLC.map(s => s.score_total_pct || 0)) : 0;

  const sectionKeys = ["score_history", "score_pe", "score_lab", "score_ddx", "score_management", "score_examiner"] as const;
  const sectionAvg = { history: 0, pe: 0, lab: 0, ddx: 0, management: 0, examiner: 0 };
  if (completedLC.length > 0) {
    const nameMap: Record<string, keyof typeof sectionAvg> = {
      score_history: "history", score_pe: "pe", score_lab: "lab",
      score_ddx: "ddx", score_management: "management", score_examiner: "examiner",
    };
    for (const key of sectionKeys) {
      const vals = completedLC.filter(s => s[key] != null).map(s => s[key] as number);
      sectionAvg[nameMap[key]] = vals.length > 0 ? Math.round(vals.reduce((a, v) => a + v, 0) / vals.length) : 0;
    }
  }

  const longCaseStats: LongCaseStats = {
    total: longCaseSessions.length,
    completed: completedLC.length,
    avgScore: avgLCScore,
    bestScore: bestLCScore,
    sessions: completedLC.slice(0, 5).map(s => ({
      title: s.long_cases?.title || "Long Case",
      specialty: s.long_cases?.specialty || "",
      difficulty: s.long_cases?.difficulty || "",
      scorePct: s.score_total_pct || 0,
      completedAt: s.completed_at || s.started_at,
    })),
    sectionAvg,
  };

  return { student, subjectScores, weeklyData, badges, challengeHistory, longCaseStats };
}

// Study plan is generated from weak subjects (computed dynamically)
function generateStudyPlan(weakSubjects: SubjectScore[]) {
  const top3 = weakSubjects.slice(0, 3);
  return [
    {
      time: "วันนี้",
      tasks: [
        ...(top3[0] ? [{ id: "today-1", icon: top3[0].icon, task: `MCQ ${top3[0].name_th} 10 ข้อ (Easy→Medium)`, type: "weakness" as const, href: "/nl/practice" }] : []),
        ...(top3[1] ? [{ id: "today-2", icon: top3[1].icon, task: `MCQ ${top3[1].name_th} 5 ข้อ`, type: "weakness" as const, href: "/nl/practice" }] : []),
        { id: "today-3", icon: "🔥", task: "Daily Challenge: Mixed 5 ข้อ", type: "challenge" as const, href: "/challenges" },
      ],
    },
    {
      time: "พรุ่งนี้",
      tasks: [
        ...(top3[2] ? [{ id: "tmr-1", icon: top3[2].icon, task: `MCQ ${top3[2].name_th} 10 ข้อ`, type: "weakness" as const, href: "/nl/practice" }] : []),
        { id: "tmr-2", icon: "📊", task: "Mock Exam: NL2 เต็มชุด", type: "mock" as const, href: "/nl/mock" },
      ],
    },
    {
      time: "สัปดาห์นี้",
      tasks: [
        { id: "week-1", icon: "🎯", task: "ทำครบทุกสาขาที่อ่อน สาขาละ 20 ข้อ", type: "goal" as const, href: "/nl/practice" },
        { id: "week-2", icon: "🏆", task: "เข้าร่วม Weekly Challenge", type: "challenge" as const, href: "/challenges" },
        { id: "week-3", icon: "📋", task: "Long Case อย่างน้อย 2 เคส", type: "goal" as const, href: "/longcase" },
      ],
    },
  ];
}

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
  const [quizQuestions, setQuizQuestions] = useState<Array<{
    id: string; scenario: string; choices: Array<{ label: string; text: string }>;
    correct_answer: string; subject_name_th: string; subject_icon: string;
  }>>([]);
  const [quizIndex, setQuizIndex] = useState(0);
  const [quizSelected, setQuizSelected] = useState<string | null>(null);
  const [quizScore, setQuizScore] = useState(0);
  const [completedTasks, setCompletedTasks] = useState<Set<string>>(new Set());
  const [loading, setLoading] = useState(true);
  const router = useRouter();

  const [student, setStudent] = useState<StudentData>({
    name: "", rank: "Student", rankIcon: "📖", xp: 0, xpNext: 100, streak: 0, totalQuestions: 0, avgScore: 0, membershipType: "free",
  });
  const [subjectScores, setSubjectScores] = useState<SubjectScore[]>([]);
  const [weeklyData, setWeeklyData] = useState<WeeklyPoint[]>([]);
  const [badges, setBadges] = useState<BadgeData[]>([]);
  const [challengeHistory, setChallengeHistory] = useState<ChallengeData[]>([]);
  const [longCaseStats, setLongCaseStats] = useState<LongCaseStats>({ total: 0, completed: 0, avgScore: 0, bestScore: 0, sessions: [], sectionAvg: { history: 0, pe: 0, lab: 0, ddx: 0, management: 0, examiner: 0 } });
  const badgeCardRef = useRef<HTMLDivElement>(null);

  const handleDownload = useCallback(async () => {
    if (!badgeCardRef.current) return;
    try {
      const dataUrl = await toPng(badgeCardRef.current, { pixelRatio: 3, backgroundColor: "#ffffff" });
      const link = document.createElement("a");
      link.download = `morroo-badge-${student.name || "card"}.png`;
      link.href = dataUrl;
      link.click();
    } catch (err) {
      console.error("Failed to export badge card:", err);
    }
  }, [student.name]);

  const handleShare = useCallback(async () => {
    if (!badgeCardRef.current) return;
    try {
      const dataUrl = await toPng(badgeCardRef.current, { pixelRatio: 3, backgroundColor: "#ffffff" });
      const res = await fetch(dataUrl);
      const blob = await res.blob();
      const file = new File([blob], "morroo-badge.png", { type: "image/png" });

      if (navigator.share && navigator.canShare({ files: [file] })) {
        await navigator.share({
          title: `${student.name} — หมอรู้ Badge Card`,
          text: `${student.rankIcon} ${student.rank} • ${student.totalQuestions} ข้อ • หมอรู้ MorRoo`,
          files: [file],
        });
      } else {
        // Fallback: download
        handleDownload();
      }
    } catch (err) {
      if ((err as Error).name !== "AbortError") {
        console.error("Failed to share:", err);
        handleDownload();
      }
    }
  }, [student, handleDownload]);

  const startQuiz = useCallback(async () => {
    const supabase = createClient();
    const { data } = await supabase
      .from("mcq_questions")
      .select("id, scenario, choices, correct_answer, mcq_subjects!inner(name_th, icon)")
      .eq("status", "active")
      .limit(50);

    if (!data || data.length === 0) return;

    // Shuffle and pick 5
    const shuffled = [...data].sort(() => Math.random() - 0.5).slice(0, 5);
    setQuizQuestions(shuffled.map((q: Record<string, unknown>) => ({
      id: q.id as string,
      scenario: q.scenario as string,
      choices: q.choices as Array<{ label: string; text: string }>,
      correct_answer: q.correct_answer as string,
      subject_name_th: (q.mcq_subjects as { name_th: string }).name_th,
      subject_icon: (q.mcq_subjects as { icon: string }).icon,
    })));
    setQuizIndex(0);
    setQuizSelected(null);
    setQuizScore(0);
    setMicroQuiz(true);
  }, []);

  const handleQuizAnswer = useCallback(async (label: string) => {
    if (quizSelected) return; // already answered
    setQuizSelected(label);
    const q = quizQuestions[quizIndex];
    const correct = label === q.correct_answer;
    if (correct) setQuizScore(prev => prev + 1);

    // Save attempt to Supabase
    const supabase = createClient();
    const { data: authData } = await supabase.auth.getUser();
    if (authData.user) {
      await supabase.from("mcq_attempts").insert({
        user_id: authData.user.id,
        question_id: q.id,
        selected_answer: label,
        is_correct: correct,
        mode: "practice",
      });
    }
  }, [quizSelected, quizQuestions, quizIndex]);

  const handleQuizNext = useCallback(() => {
    if (quizIndex < quizQuestions.length - 1) {
      setQuizIndex(prev => prev + 1);
      setQuizSelected(null);
    } else {
      setMicroQuiz(false);
    }
  }, [quizIndex, quizQuestions.length]);

  const toggleTask = useCallback((taskId: string) => {
    setCompletedTasks(prev => {
      const next = new Set(prev);
      if (next.has(taskId)) next.delete(taskId);
      else next.add(taskId);
      const today = new Date().toISOString().slice(0, 10);
      try { localStorage.setItem(`morroo-plan-${today}`, JSON.stringify([...next])); } catch {}
      return next;
    });
  }, []);

  // Load completed tasks from localStorage
  useEffect(() => {
    const today = new Date().toISOString().slice(0, 10);
    try {
      const saved = localStorage.getItem(`morroo-plan-${today}`);
      if (saved) setCompletedTasks(new Set(JSON.parse(saved)));
    } catch {}
  }, []);

  useEffect(() => {
    const supabase = createClient();
    supabase.auth.getUser().then(async ({ data: authData }: { data: { user: { id: string } | null } }) => {
      if (!authData.user) {
        router.replace("/login");
        return;
      }
      try {
        const raw = await fetchDashboardData(supabase, authData.user.id);
        const processed = processData(
          raw.profile as Parameters<typeof processData>[0],
          raw.attempts as Parameters<typeof processData>[1],
          raw.subjects as Parameters<typeof processData>[2],
          raw.userBadges as Parameters<typeof processData>[3],
          raw.challengeSubs as Parameters<typeof processData>[4],
          raw.longCaseSessions as Parameters<typeof processData>[5],
        );
        setStudent(processed.student);
        setSubjectScores(processed.subjectScores);
        setWeeklyData(processed.weeklyData);
        setBadges(processed.badges);
        setChallengeHistory(processed.challengeHistory);
        setLongCaseStats(processed.longCaseStats);
      } catch (err) {
        console.error("Dashboard data fetch error:", err);
      }
      setLoading(false);
    });
  }, [router]);

  const xpPct = student.xpNext > 0 ? Math.round((student.xp / student.xpNext) * 100) : 0;

  const radarData = subjectScores.slice(0, 8).map((s) => ({ subject: s.name_th, score: s.score, fullMark: 100 }));
  const weakSubjects = subjectScores.filter(s => s.score < 70).sort((a, b) => a.score - b.score);
  const studyPlan = generateStudyPlan(weakSubjects);

  if (loading) {
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
          onClick={startQuiz}
        >
          <CardContent className="flex items-center justify-between">
            <div>
              <div className="font-bold text-sm flex items-center gap-1.5">
                <Stethoscope className="size-4 text-primary" />
                Quick Quiz 5 นาที
              </div>
              <div className="text-xs text-muted-foreground">5 ข้อ MCQ สุ่มจากข้อสอบจริง &middot; บันทึกผลอัตโนมัติ</div>
            </div>
            <Button size="sm">
              เริ่มเลย <ChevronRight className="size-3.5" />
            </Button>
          </CardContent>
        </Card>
      )}
      {microQuiz && quizQuestions.length > 0 && (() => {
        const q = quizQuestions[quizIndex];
        return (
        <Card size="sm" className="mb-4 border-primary/20">
          <CardContent>
            <div className="flex justify-between mb-3">
              <span className="font-bold text-sm">
                <Stethoscope className="inline size-4 mr-1" />
                Quick Quiz &mdash; {q.subject_icon} {q.subject_name_th}
              </span>
              <span className="text-xs text-muted-foreground font-semibold">
                {quizIndex + 1}/{quizQuestions.length} &middot; ถูก {quizScore}
              </span>
            </div>
            <div className="bg-muted rounded-lg p-3 mb-3 text-sm">
              <div className="text-xs text-muted-foreground mb-1">ข้อ {quizIndex + 1}/{quizQuestions.length}</div>
              {q.scenario}
            </div>
            {q.choices.map((c) => {
              const isSelected = quizSelected === c.label;
              const isCorrect = c.label === q.correct_answer;
              let cls = "bg-muted border-transparent hover:border-border";
              if (quizSelected) {
                if (isCorrect) cls = "bg-green-50 border-green-400 text-green-800";
                else if (isSelected && !isCorrect) cls = "bg-red-50 border-red-400 text-red-800";
                else cls = "bg-muted border-transparent opacity-60";
              }
              return (
                <div
                  key={c.label}
                  onClick={() => handleQuizAnswer(c.label)}
                  className={`p-2.5 rounded-lg mb-1.5 text-sm cursor-pointer border transition-colors ${cls}`}
                >
                  {c.label}. {c.text}
                </div>
              );
            })}
            <div className="text-right mt-2">
              {quizSelected && (
                <Button size="sm" onClick={handleQuizNext}>
                  {quizIndex < quizQuestions.length - 1 ? "ข้อถัดไป" : `เสร็จ (${quizScore}/${quizQuestions.length})`} <ChevronRight className="size-3.5" />
                </Button>
              )}
            </div>
          </CardContent>
        </Card>
        );
      })()}

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

          {/* Long Case Stats */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Clock className="size-4 text-primary" />
                Long Case
              </CardTitle>
              <CardDescription>
                สถิติการฝึก Long Case ของคุณ
              </CardDescription>
            </CardHeader>
            <CardContent>
              {longCaseStats.completed === 0 ? (
                <div className="text-center py-4">
                  <div className="text-sm text-muted-foreground mb-3">ยังไม่เคยทำ Long Case — ลองฝึกดู!</div>
                  <Link href="/longcase">
                    <Button size="sm">
                      <Stethoscope className="size-3.5" /> เริ่มทำ Long Case
                    </Button>
                  </Link>
                </div>
              ) : (
                <>
                  {/* Summary stats */}
                  <div className="grid grid-cols-3 gap-3 mb-4">
                    <div className="text-center p-3 bg-muted rounded-lg">
                      <div className="text-xl font-extrabold text-primary">{longCaseStats.completed}</div>
                      <div className="text-xs text-muted-foreground">เคสที่ทำ</div>
                    </div>
                    <div className="text-center p-3 bg-muted rounded-lg">
                      <div className="text-xl font-extrabold text-green-600">{longCaseStats.avgScore}%</div>
                      <div className="text-xs text-muted-foreground">คะแนนเฉลี่ย</div>
                    </div>
                    <div className="text-center p-3 bg-muted rounded-lg">
                      <div className="text-xl font-extrabold text-yellow-600">{longCaseStats.bestScore}%</div>
                      <div className="text-xs text-muted-foreground">คะแนนสูงสุด</div>
                    </div>
                  </div>

                  {/* Section breakdown */}
                  <div className="text-xs font-semibold text-muted-foreground mb-2">คะแนนเฉลี่ยแยกหมวด</div>
                  <div className="space-y-1.5 mb-4">
                    {[
                      { label: "ซักประวัติ", key: "history" as const, icon: "📋" },
                      { label: "ตรวจร่างกาย", key: "pe" as const, icon: "🩺" },
                      { label: "Lab/Investigation", key: "lab" as const, icon: "🔬" },
                      { label: "Differential Dx", key: "ddx" as const, icon: "🧠" },
                      { label: "การรักษา", key: "management" as const, icon: "💊" },
                      { label: "Examiner", key: "examiner" as const, icon: "👨‍⚕️" },
                    ].map((sec) => (
                      <div key={sec.key} className="flex items-center gap-2">
                        <span className="text-sm w-5 text-center">{sec.icon}</span>
                        <span className="text-xs w-24 text-muted-foreground">{sec.label}</span>
                        <div className="flex-1 h-2 bg-muted rounded-full overflow-hidden">
                          <div
                            className="h-full rounded-full transition-all"
                            style={{
                              width: `${longCaseStats.sectionAvg[sec.key]}%`,
                              background: longCaseStats.sectionAvg[sec.key] >= 70 ? "var(--chart-2)" : longCaseStats.sectionAvg[sec.key] >= 50 ? "var(--chart-4)" : "var(--destructive)",
                            }}
                          />
                        </div>
                        <span className={`text-xs font-bold w-10 text-right ${
                          longCaseStats.sectionAvg[sec.key] >= 70 ? "text-green-600" : longCaseStats.sectionAvg[sec.key] >= 50 ? "text-yellow-600" : "text-destructive"
                        }`}>
                          {longCaseStats.sectionAvg[sec.key]}%
                        </span>
                      </div>
                    ))}
                  </div>

                  {/* Recent sessions */}
                  {longCaseStats.sessions.length > 0 && (
                    <>
                      <div className="text-xs font-semibold text-muted-foreground mb-2">เคสล่าสุด</div>
                      <div className="space-y-1.5">
                        {longCaseStats.sessions.map((s, i) => (
                          <div key={i} className="flex items-center gap-2 p-2 bg-muted rounded-lg text-sm">
                            <span className="text-base">📄</span>
                            <div className="flex-1 min-w-0">
                              <div className="font-semibold text-xs truncate">{s.title}</div>
                              <div className="text-[10px] text-muted-foreground">
                                {s.specialty} &middot; {s.difficulty} &middot; {new Date(s.completedAt).toLocaleDateString("th-TH", { day: "numeric", month: "short" })}
                              </div>
                            </div>
                            <span className={`text-sm font-extrabold ${
                              s.scorePct >= 70 ? "text-green-600" : s.scorePct >= 50 ? "text-yellow-600" : "text-destructive"
                            }`}>
                              {s.scorePct}%
                            </span>
                          </div>
                        ))}
                      </div>
                    </>
                  )}

                  <div className="mt-3 text-center">
                    <Link href="/longcase">
                      <Button size="sm" variant="outline">
                        ทำ Long Case เพิ่ม <ChevronRight className="size-3.5" />
                      </Button>
                    </Link>
                  </div>
                </>
              )}
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
              {weakSubjects.length === 0 && (
                <div className="text-sm text-muted-foreground text-center py-4">ยังไม่มีข้อมูล — ลองทำข้อสอบก่อนนะ!</div>
              )}
              {weakSubjects.slice(0, 5).map((w, i) => (
                <div key={i} className="flex items-center gap-3 p-3 bg-muted rounded-lg">
                  <div className="relative">
                    <ProgressRing
                      pct={w.score}
                      size={44}
                      stroke={4}
                      color={w.score < 50 ? "var(--destructive)" : "#eab308"}
                    />
                    <div className={`absolute inset-0 flex items-center justify-center text-[10px] font-bold ${
                      w.score < 50 ? "text-destructive" : "text-yellow-600"
                    }`}>
                      {w.score}%
                    </div>
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="font-semibold text-sm">{w.icon} {w.name_th}</div>
                    <div className="text-xs text-muted-foreground truncate">ทำแล้ว {w.total} ข้อ &middot; แนะนำทำเพิ่มอีก 10 ข้อ</div>
                  </div>
                  <Link href="/nl/practice">
                    <Button size="xs" variant="ghost" className="text-primary shrink-0">
                      ฝึกเลย <ChevronRight className="size-3" />
                    </Button>
                  </Link>
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
              <CardDescription>
                {(() => {
                  const allTasks = studyPlan.flatMap(sp => sp.tasks);
                  const done = allTasks.filter(t => completedTasks.has(t.id)).length;
                  return `ทำแล้ว ${done}/${allTasks.length} รายการ`;
                })()}
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              {/* Progress bar */}
              {(() => {
                const allTasks = studyPlan.flatMap(sp => sp.tasks);
                const done = allTasks.filter(t => completedTasks.has(t.id)).length;
                const pct = allTasks.length > 0 ? Math.round((done / allTasks.length) * 100) : 0;
                return (
                  <div className="h-2 bg-muted rounded-full overflow-hidden">
                    <div className="h-full bg-green-500 rounded-full transition-all duration-500" style={{ width: `${pct}%` }} />
                  </div>
                );
              })()}
              {studyPlan.map((sp, si) => (
                <div key={si}>
                  <div className={`text-xs font-bold mb-2 flex items-center gap-1.5 ${
                    si === 0 ? "text-green-600" : si === 1 ? "text-primary" : "text-yellow-600"
                  }`}>
                    <CalendarDays className="size-3.5" />
                    {sp.time}
                  </div>
                  <div className="space-y-1.5">
                    {sp.tasks.map((t) => {
                      const isDone = completedTasks.has(t.id);
                      return (
                        <div key={t.id} className={`flex items-center gap-2 p-2 rounded-lg text-sm transition-colors ${isDone ? "bg-green-50 opacity-70" : "bg-muted"}`}>
                          <button
                            onClick={() => toggleTask(t.id)}
                            className={`flex-shrink-0 size-5 rounded border-2 flex items-center justify-center transition-colors cursor-pointer ${
                              isDone ? "bg-green-500 border-green-500 text-white" : "border-muted-foreground/30 hover:border-primary"
                            }`}
                          >
                            {isDone && <span className="text-xs">&#10003;</span>}
                          </button>
                          <span>{t.icon}</span>
                          <Link href={t.href} className={`flex-1 hover:text-primary transition-colors ${isDone ? "line-through text-muted-foreground" : "text-muted-foreground"}`}>
                            {t.task}
                          </Link>
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
                      );
                    })}
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
                  {weakSubjects.length > 0
                    ? `"เห็นว่าสาขา${weakSubjects[0].name_th}ยังอ่อนอยู่ (${weakSubjects[0].score}%) ถ้าทำวันนี้อีก 10 ข้อ น่าจะดีขึ้นได้ ลองดูไหม?"`
                    : `"เก่งมาก! ทำต่อไปเรื่อยๆ แล้วจะพร้อมสอบแน่นอน!"`
                  }
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
                <Link href="/challenges">
                  <Button>
                    <Zap className="size-4" />
                    Weekly Challenge
                  </Button>
                </Link>
                <Link href="/challenges">
                  <Button variant="outline">
                    <CalendarDays className="size-4" />
                    Monthly Challenge
                  </Button>
                </Link>
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
              {challengeHistory.length === 0 && (
                <div className="text-sm text-muted-foreground text-center py-4">ยังไม่เคยเข้าร่วม Challenge — ลองเข้าร่วมดู!</div>
              )}
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
              { label: "เข้าร่วม", value: `${challengeHistory.length}`, color: "text-primary" },
              { label: "คะแนนเฉลี่ย", value: challengeHistory.length > 0 ? `${Math.round(challengeHistory.reduce((a, c) => a + c.score, 0) / challengeHistory.length)}%` : "-", color: "text-green-600" },
              { label: "คะแนนสูงสุด", value: challengeHistory.length > 0 ? `${Math.max(...challengeHistory.map(c => c.score))}%` : "-", color: "text-yellow-600" },
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
          <div>
            <Card ref={badgeCardRef} className="border-primary/20 bg-gradient-to-br from-card to-muted text-center">
              <CardContent className="py-6">
                <div className="text-[10px] font-semibold text-primary tracking-widest mb-2">DIGITAL BADGE CARD</div>
                <div className="text-2xl mb-1">
                  {badges.filter((b) => b.earned).map((b) => b.icon).join(" ") || "🩺"}
                </div>
                <div className="font-extrabold text-base">{student.name}</div>
                <div className="text-sm text-muted-foreground">
                  {student.rankIcon} {student.rank} &middot; {student.xp.toLocaleString()} XP &middot; {student.totalQuestions} ข้อ
                </div>
                <div className="text-[10px] text-muted-foreground mt-2">morroo.com &middot; หมอรู้ MorRoo</div>
              </CardContent>
            </Card>
            <div className="flex gap-2 justify-center mt-3">
              <Button size="sm" variant="outline" onClick={handleDownload}>
                ดาวน์โหลด PNG
              </Button>
              <Button size="sm" onClick={handleShare}>
                <Share2 className="size-3.5" />
                แชร์
              </Button>
            </div>
          </div>
        </div>
      )}

      {/* Footer */}
      <div className="text-center text-xs text-muted-foreground py-6">
        หมอรู้ MorRoo &mdash; Student Dashboard
      </div>
    </div>
  );
}
