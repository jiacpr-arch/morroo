"use client";

import { useState } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  BookOpen,
  Layers,
  Brain,
  Trophy,
  ArrowRight,
  CheckCircle2,
  Circle,
} from "lucide-react";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import type {
  SchoolLesson,
  SchoolFlashcard,
  SchoolQuiz,
} from "@/lib/types-school";
import { createClient } from "@/lib/supabase/client";
import { nextSrsState } from "@/lib/school/srs";
import { applyStreak } from "@/lib/school/streak";
import RewardBadge from "./RewardBadge";

interface Props {
  topicId: string;
  lessons: SchoolLesson[];
  cards: SchoolFlashcard[];
  quizzes: SchoolQuiz[];
  initialMastery: { seen: number; correct: number; pct: number };
  isPremium: boolean;
}

type Phase = "learn" | "practice" | "test" | "done";

export default function GuidedRunner({
  topicId,
  lessons,
  cards,
  quizzes,
  initialMastery,
}: Props) {
  const [phase, setPhase] = useState<Phase>(
    lessons.length > 0 ? "learn" : cards.length > 0 ? "practice" : "test"
  );
  const [lessonIdx, setLessonIdx] = useState(0);
  const [cardIdx, setCardIdx] = useState(0);
  const [quizIdx, setQuizIdx] = useState(0);
  const [flipped, setFlipped] = useState(false);
  const [picked, setPicked] = useState<string | null>(null);
  const [correct, setCorrect] = useState(0);

  async function markLessonRead(lessonId: string) {
    try {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return;
      await supabase.from("school_progress").insert({
        user_id: user.id,
        unit_type: "lesson",
        unit_id: lessonId,
        outcome: "good",
        ease_factor: 2.5,
        interval_days: 7,
      });
      const { data: s } = await supabase
        .from("school_streaks")
        .select("*")
        .eq("user_id", user.id)
        .maybeSingle();
      const ns = applyStreak(
        s ?? { current_streak: 0, longest_streak: 0, last_active_date: null }
      );
      await supabase.from("school_streaks").upsert({ user_id: user.id, ...ns });
    } catch {
      // Non-blocking
    }
  }

  async function rateCard(
    card: SchoolFlashcard,
    outcome: "again" | "hard" | "good" | "easy"
  ) {
    if (outcome !== "again") setCorrect((c) => c + 1);
    try {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return;
      const { data: prev } = await supabase
        .from("school_progress")
        .select("ease_factor, interval_days")
        .eq("user_id", user.id)
        .eq("unit_type", "flashcard")
        .eq("unit_id", card.id)
        .order("reviewed_at", { ascending: false })
        .limit(1)
        .maybeSingle();
      const next = nextSrsState(prev, outcome);
      await supabase.from("school_progress").insert({
        user_id: user.id,
        unit_type: "flashcard",
        unit_id: card.id,
        outcome,
        ease_factor: next.ease_factor,
        interval_days: next.interval_days,
        due_at: next.due_at.toISOString(),
      });
    } catch {
      // Non-blocking
    }
    setFlipped(false);
    setCardIdx((i) => i + 1);
  }

  async function pickQuiz(quiz: SchoolQuiz, label: string) {
    if (picked) return;
    setPicked(label);
    const isCorrect = label === quiz.correct_answer;
    if (isCorrect) setCorrect((c) => c + 1);
    try {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return;
      const { data: prev } = await supabase
        .from("school_progress")
        .select("ease_factor, interval_days")
        .eq("user_id", user.id)
        .eq("unit_type", "quiz")
        .eq("unit_id", quiz.id)
        .order("reviewed_at", { ascending: false })
        .limit(1)
        .maybeSingle();
      const next = nextSrsState(prev, isCorrect ? "correct" : "wrong");
      await supabase.from("school_progress").insert({
        user_id: user.id,
        unit_type: "quiz",
        unit_id: quiz.id,
        outcome: isCorrect ? "correct" : "wrong",
        ease_factor: next.ease_factor,
        interval_days: next.interval_days,
        due_at: next.due_at.toISOString(),
      });
    } catch {
      // Non-blocking
    }
  }

  // ─── Phase: Learn ──────────────────────────────────────────────────────────
  if (phase === "learn") {
    const lesson = lessons[lessonIdx];
    if (!lesson) {
      setPhase(cards.length > 0 ? "practice" : "test");
      return null;
    }
    return (
      <div className="space-y-4">
        <PhaseStepper phase={phase} lessonsTotal={lessons.length} lessonIdx={lessonIdx} />
        <Card>
          <CardContent className="p-6">
            <div className="flex items-center gap-2 mb-3">
              <BookOpen className="h-5 w-5 text-teal-600" />
              <h2 className="text-xl font-bold">{lesson.title}</h2>
            </div>
            <Badge variant="outline" className="text-xs mb-4">
              {lesson.layer} · {lesson.estimated_min} นาที
            </Badge>
            <article className="prose prose-slate dark:prose-invert max-w-none text-sm">
              <ReactMarkdown remarkPlugins={[remarkGfm]}>
                {lesson.body_md}
              </ReactMarkdown>
            </article>
          </CardContent>
        </Card>
        <Button
          onClick={async () => {
            await markLessonRead(lesson.id);
            if (lessonIdx + 1 < lessons.length) {
              setLessonIdx((i) => i + 1);
            } else {
              setPhase(cards.length > 0 ? "practice" : "test");
            }
          }}
          className="w-full gap-2"
        >
          {lessonIdx + 1 < lessons.length
            ? "อ่านบทถัดไป"
            : cards.length > 0
              ? "ไปฝึก Flashcards"
              : "ไปทดสอบ Quiz"}{" "}
          <ArrowRight className="h-4 w-4" />
        </Button>
      </div>
    );
  }

  // ─── Phase: Practice ──────────────────────────────────────────────────────
  if (phase === "practice") {
    const card = cards[cardIdx];
    if (!card) {
      setPhase(quizzes.length > 0 ? "test" : "done");
      return null;
    }
    return (
      <div className="space-y-4">
        <PhaseStepper
          phase={phase}
          cardsTotal={cards.length}
          cardIdx={cardIdx}
          lessonsTotal={lessons.length}
        />
        <Card
          className="min-h-[240px] cursor-pointer"
          onClick={() => setFlipped((f) => !f)}
        >
          <CardContent className="p-6 flex flex-col items-center justify-center text-center min-h-[200px] gap-3">
            <Badge variant="outline" className="text-xs">
              Flashcard {cardIdx + 1} / {cards.length}
            </Badge>
            {card.image_url && (
              <img src={card.image_url} alt="" className="max-h-32 rounded" />
            )}
            <p className="text-lg whitespace-pre-wrap">
              {!flipped ? card.front : card.back}
            </p>
            <p className="text-xs text-muted-foreground">
              {flipped ? "(เฉลย)" : "แตะเพื่อเปิดเฉลย"}
            </p>
          </CardContent>
        </Card>
        {!flipped ? (
          <Button onClick={() => setFlipped(true)} className="w-full gap-2">
            เปิดเฉลย <ArrowRight className="h-4 w-4" />
          </Button>
        ) : (
          <div className="grid grid-cols-4 gap-2">
            <Button onClick={() => rateCard(card, "again")} variant="outline" className="text-rose-700">
              ลืม
            </Button>
            <Button onClick={() => rateCard(card, "hard")} variant="outline" className="text-amber-700">
              ยาก
            </Button>
            <Button onClick={() => rateCard(card, "good")} variant="outline" className="text-sky-700">
              จำได้
            </Button>
            <Button onClick={() => rateCard(card, "easy")} variant="outline" className="text-emerald-700">
              ง่าย
            </Button>
          </div>
        )}
      </div>
    );
  }

  // ─── Phase: Test ──────────────────────────────────────────────────────────
  if (phase === "test") {
    const quiz = quizzes[quizIdx];
    if (!quiz) {
      setPhase("done");
      return null;
    }
    return (
      <div className="space-y-4">
        <PhaseStepper
          phase={phase}
          quizTotal={quizzes.length}
          quizIdx={quizIdx}
          lessonsTotal={lessons.length}
          cardsTotal={cards.length}
        />
        <Card>
          <CardContent className="p-6 space-y-3">
            <Badge variant="outline" className="text-xs">
              Quiz {quizIdx + 1} / {quizzes.length}
            </Badge>
            <p className="font-medium">{quiz.stem}</p>
            <div className="space-y-2">
              {quiz.choices.map((c) => {
                const chosen = picked === c.label;
                const isCorrectAns = picked && c.label === quiz.correct_answer;
                const isWrong = chosen && !isCorrectAns;
                return (
                  <button
                    key={c.label}
                    onClick={() => pickQuiz(quiz, c.label)}
                    disabled={picked !== null}
                    className={[
                      "w-full text-left rounded-lg border px-4 py-3 flex items-start gap-3",
                      isCorrectAns && "border-emerald-400 bg-emerald-50",
                      isWrong && "border-rose-400 bg-rose-50",
                      picked === null && "hover:border-brand/40 hover:bg-muted/50 cursor-pointer",
                    ].filter(Boolean).join(" ")}
                  >
                    <span className="font-semibold w-6 shrink-0">{c.label}.</span>
                    <span className="flex-1">{c.text}</span>
                  </button>
                );
              })}
            </div>
            {picked !== null && quiz.explanation && (
              <div className="rounded-lg p-3 border text-sm bg-muted/30">
                <p className="font-semibold mb-1">เฉลย: {quiz.correct_answer}</p>
                <p className="whitespace-pre-wrap">{quiz.explanation}</p>
              </div>
            )}
          </CardContent>
        </Card>
        {picked !== null && (
          <Button
            onClick={() => {
              setPicked(null);
              setQuizIdx((i) => i + 1);
            }}
            className="w-full gap-2"
          >
            ข้อถัดไป <ArrowRight className="h-4 w-4" />
          </Button>
        )}
      </div>
    );
  }

  // ─── Phase: Done ──────────────────────────────────────────────────────────
  const totalActions = lessons.length + cards.length + quizzes.length;
  const pct = totalActions ? Math.round((correct / (cards.length + quizzes.length)) * 100) : 0;
  return (
    <Card>
      <CardContent className="p-8 text-center space-y-4">
        <Trophy className="h-12 w-12 text-amber-500 mx-auto" />
        <h2 className="text-2xl font-bold">Guided Sequence เสร็จ!</h2>
        <p className="text-muted-foreground">
          คุณ: 📖 อ่าน {lessons.length} concept · 🎴 ฝึก {cards.length} ใบ · 🧠 ตอบ {quizzes.length} ข้อ
        </p>
        <p className="text-lg">
          ความแม่นยำ <span className="font-bold">{pct}%</span> ({correct}/{cards.length + quizzes.length})
        </p>
        <div>
          <RewardBadge />
        </div>
        <p className="text-sm text-muted-foreground">
          Mastery รวมเดิม {initialMastery.pct}% — ระบบจะอัปเดต Progress หน้า /school/progress
        </p>
        <div className="flex gap-3 justify-center pt-2">
          <a href={`/school/topic/${topicId}`}>
            <Button variant="outline">กลับ Topic</Button>
          </a>
          <a href="/school/progress">
            <Button>ดู Progress</Button>
          </a>
        </div>
      </CardContent>
    </Card>
  );
}

function PhaseStepper({
  phase,
  lessonsTotal = 0,
  lessonIdx = 0,
  cardsTotal = 0,
  cardIdx = 0,
  quizTotal = 0,
  quizIdx = 0,
}: {
  phase: Phase;
  lessonsTotal?: number;
  lessonIdx?: number;
  cardsTotal?: number;
  cardIdx?: number;
  quizTotal?: number;
  quizIdx?: number;
}) {
  const items = [
    {
      key: "learn",
      label: "Learn",
      icon: BookOpen,
      active: phase === "learn",
      done: phase !== "learn",
      progress: lessonsTotal ? Math.round((lessonIdx / lessonsTotal) * 100) : 0,
    },
    {
      key: "practice",
      label: "Practice",
      icon: Layers,
      active: phase === "practice",
      done: phase === "test" || phase === "done",
      progress: cardsTotal ? Math.round((cardIdx / cardsTotal) * 100) : 0,
    },
    {
      key: "test",
      label: "Test",
      icon: Brain,
      active: phase === "test",
      done: phase === "done",
      progress: quizTotal ? Math.round((quizIdx / quizTotal) * 100) : 0,
    },
  ];
  return (
    <div className="grid grid-cols-3 gap-2">
      {items.map((it) => (
        <div
          key={it.key}
          className={`rounded-lg border p-2 text-center text-xs ${
            it.active
              ? "border-violet-400 bg-violet-50 text-violet-700"
              : it.done
                ? "border-emerald-200 bg-emerald-50 text-emerald-700"
                : "border-muted text-muted-foreground"
          }`}
        >
          <div className="flex items-center justify-center gap-1">
            {it.done ? (
              <CheckCircle2 className="h-3 w-3" />
            ) : (
              <Circle className="h-3 w-3" />
            )}
            <it.icon className="h-3 w-3" />
            <span className="font-semibold">{it.label}</span>
          </div>
        </div>
      ))}
    </div>
  );
}
