"use client";

import { useMemo, useState } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Trophy, ArrowRight, Flame } from "lucide-react";
import Link from "next/link";
import type { SchoolFlashcard, SchoolQuiz } from "@/lib/types-school";
import { createClient } from "@/lib/supabase/client";
import { nextSrsState } from "@/lib/school/srs";
import { applyStreak } from "@/lib/school/streak";
import RewardBadge from "./RewardBadge";

interface Props {
  cards: SchoolFlashcard[];
  quizzes: SchoolQuiz[];
  isPremium?: boolean;
}

type Step =
  | { kind: "flashcard"; card: SchoolFlashcard }
  | { kind: "quiz"; quiz: SchoolQuiz };

export default function DailyLessonStepper({ cards, quizzes }: Props) {
  // Interleave: alternate flashcard, quiz, flashcard, ...
  const steps = useMemo<Step[]>(() => {
    const out: Step[] = [];
    const maxLen = Math.max(cards.length, quizzes.length);
    for (let i = 0; i < maxLen; i++) {
      if (i < cards.length) out.push({ kind: "flashcard", card: cards[i] });
      if (i < quizzes.length) out.push({ kind: "quiz", quiz: quizzes[i] });
    }
    return out;
  }, [cards, quizzes]);

  const [index, setIndex] = useState(0);
  const [flipped, setFlipped] = useState(false);
  const [picked, setPicked] = useState<string | null>(null);
  const [correctCount, setCorrectCount] = useState(0);
  const [streak, setStreak] = useState<number | null>(null);

  const step = steps[index];
  const done = !step;

  async function persist(
    unitType: "flashcard" | "quiz",
    unitId: string,
    outcome: "again" | "hard" | "good" | "easy" | "correct" | "wrong"
  ) {
    try {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return;
      const { data: prev } = await supabase
        .from("school_progress")
        .select("ease_factor, interval_days")
        .eq("user_id", user.id)
        .eq("unit_type", unitType)
        .eq("unit_id", unitId)
        .order("reviewed_at", { ascending: false })
        .limit(1)
        .maybeSingle();
      const next = nextSrsState(prev, outcome);
      await supabase.from("school_progress").insert({
        user_id: user.id,
        unit_type: unitType,
        unit_id: unitId,
        outcome,
        ease_factor: next.ease_factor,
        interval_days: next.interval_days,
        due_at: next.due_at.toISOString(),
      });
      const { data: s } = await supabase
        .from("school_streaks")
        .select("*")
        .eq("user_id", user.id)
        .maybeSingle();
      const ns = applyStreak(
        s ?? { current_streak: 0, longest_streak: 0, last_active_date: null }
      );
      await supabase.from("school_streaks").upsert({
        user_id: user.id,
        ...ns,
      });
      setStreak(ns.current_streak);
    } catch {
      // Non-blocking
    }
  }

  async function rateFlashcard(outcome: "again" | "hard" | "good" | "easy") {
    if (step?.kind !== "flashcard") return;
    await persist("flashcard", step.card.id, outcome);
    if (outcome !== "again") setCorrectCount((c) => c + 1);
    advance();
  }

  async function pickQuiz(label: string) {
    if (step?.kind !== "quiz" || picked) return;
    setPicked(label);
    const isCorrect = label === step.quiz.correct_answer;
    if (isCorrect) setCorrectCount((c) => c + 1);
    await persist("quiz", step.quiz.id, isCorrect ? "correct" : "wrong");
  }

  function advance() {
    setFlipped(false);
    setPicked(null);
    setIndex((i) => i + 1);
  }

  if (done) {
    const total = steps.length;
    const pct = total ? Math.round((correctCount / total) * 100) : 0;
    return (
      <Card>
        <CardContent className="p-8 text-center space-y-4">
          <Trophy className="h-12 w-12 text-amber-500 mx-auto" />
          <h2 className="text-2xl font-bold">Daily Lesson เสร็จแล้ว!</h2>
          <p className="text-muted-foreground">
            ตอบถูก {correctCount} จาก {total} ({pct}%)
          </p>
          {streak !== null && streak > 0 && (
            <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-orange-100 text-orange-700 font-semibold">
              <Flame className="h-5 w-5" /> Streak {streak} วันติด
            </div>
          )}
          <div>
            <RewardBadge />
          </div>
          <div className="flex gap-3 justify-center pt-2">
            <Link href="/school/review">
              <Button variant="outline">ทบทวน Due cards</Button>
            </Link>
            <Link href="/school">
              <Button>กลับหน้าหลัก</Button>
            </Link>
          </div>
        </CardContent>
      </Card>
    );
  }

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between text-sm text-muted-foreground">
        <span>
          Step {index + 1} / {steps.length}
        </span>
        <span>ถูกแล้ว {correctCount}</span>
      </div>

      {step.kind === "flashcard" ? (
        <>
          <Card
            className="min-h-[260px] cursor-pointer select-none transition-shadow hover:shadow-md"
            onClick={() => setFlipped((f) => !f)}
          >
            <CardContent className="p-6 space-y-3">
              <Badge variant="outline" className="text-xs">
                Flashcard · {step.card.layer}
              </Badge>
              <div className="min-h-[160px] flex items-center justify-center text-center">
                {!flipped ? (
                  <p className="text-lg font-medium whitespace-pre-wrap">
                    {step.card.front}
                  </p>
                ) : (
                  <p className="text-base whitespace-pre-wrap">{step.card.back}</p>
                )}
              </div>
            </CardContent>
          </Card>
          {!flipped ? (
            <Button onClick={() => setFlipped(true)} className="w-full gap-2">
              เปิดเฉลย <ArrowRight className="h-4 w-4" />
            </Button>
          ) : (
            <div className="grid grid-cols-4 gap-2">
              <Button onClick={() => rateFlashcard("again")} variant="outline" className="text-rose-700">
                ลืม
              </Button>
              <Button onClick={() => rateFlashcard("hard")} variant="outline" className="text-amber-700">
                ยาก
              </Button>
              <Button onClick={() => rateFlashcard("good")} variant="outline" className="text-sky-700">
                จำได้
              </Button>
              <Button onClick={() => rateFlashcard("easy")} variant="outline" className="text-emerald-700">
                ง่าย
              </Button>
            </div>
          )}
        </>
      ) : (
        <Card>
          <CardContent className="p-6 space-y-4">
            <Badge variant="outline" className="text-xs">
              Quiz · {step.quiz.layer}
            </Badge>
            <p className="text-base font-medium whitespace-pre-wrap">{step.quiz.stem}</p>
            <div className="space-y-2">
              {step.quiz.choices.map((c) => {
                const chosen = picked === c.label;
                const isCorrect = picked !== null && c.label === step.quiz.correct_answer;
                const isWrong = chosen && !isCorrect;
                return (
                  <button
                    key={c.label}
                    onClick={() => pickQuiz(c.label)}
                    disabled={picked !== null}
                    className={[
                      "w-full text-left rounded-lg border px-4 py-3 flex items-start gap-3",
                      isCorrect && "border-emerald-400 bg-emerald-50",
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
            {picked !== null && step.quiz.explanation && (
              <div className="rounded-lg p-4 border text-sm bg-muted/30">
                <p className="font-semibold mb-1">เฉลย: {step.quiz.correct_answer}</p>
                <p className="whitespace-pre-wrap">{step.quiz.explanation}</p>
              </div>
            )}
            {picked !== null && (
              <Button onClick={advance} className="w-full gap-2">
                Step ถัดไป <ArrowRight className="h-4 w-4" />
              </Button>
            )}
          </CardContent>
        </Card>
      )}
    </div>
  );
}
