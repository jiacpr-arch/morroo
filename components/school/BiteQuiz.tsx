"use client";

import { useState } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { CheckCircle, XCircle, Trophy, ArrowRight, ArrowLeft } from "lucide-react";
import Link from "next/link";
import type { SchoolQuiz } from "@/lib/types-school";
import { createClient } from "@/lib/supabase/client";
import { nextSrsState } from "@/lib/school/srs";
import { applyStreak } from "@/lib/school/streak";
import { XP, awardXp, detectBadges } from "@/lib/school/xp";

interface Props {
  quizzes: SchoolQuiz[];
  isPremium?: boolean;
  freeLimit?: number;
}

const LAYER_BADGE: Record<string, string> = {
  anatomy: "bg-rose-100 text-rose-700",
  physio: "bg-sky-100 text-sky-700",
  biochem: "bg-amber-100 text-amber-700",
  path: "bg-purple-100 text-purple-700",
  pharm: "bg-emerald-100 text-emerald-700",
  clinical: "bg-orange-100 text-orange-700",
  foundation: "bg-slate-100 text-slate-700",
};

export default function BiteQuiz({
  quizzes,
  isPremium = false,
  freeLimit = 5,
}: Props) {
  const effective = isPremium ? quizzes : quizzes.slice(0, freeLimit);
  const [index, setIndex] = useState(0);
  const [picked, setPicked] = useState<string | null>(null);
  const [score, setScore] = useState({ correct: 0, total: 0 });

  const quiz = effective[index];
  const done = !quiz;
  const revealed = picked !== null;
  const isCorrect = revealed && picked === quiz?.correct_answer;

  async function pick(label: string) {
    if (revealed || !quiz) return;
    setPicked(label);
    const correct = label === quiz.correct_answer;
    setScore((s) => ({
      correct: s.correct + (correct ? 1 : 0),
      total: s.total + 1,
    }));

    try {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (user) {
        const { data: prev } = await supabase
          .from("school_progress")
          .select("ease_factor, interval_days")
          .eq("user_id", user.id)
          .eq("unit_type", "quiz")
          .eq("unit_id", quiz.id)
          .order("reviewed_at", { ascending: false })
          .limit(1)
          .maybeSingle();
        const next = nextSrsState(prev, correct ? "correct" : "wrong");
        await supabase.from("school_progress").insert({
          user_id: user.id,
          unit_type: "quiz",
          unit_id: quiz.id,
          outcome: correct ? "correct" : "wrong",
          ease_factor: next.ease_factor,
          interval_days: next.interval_days,
          due_at: next.due_at.toISOString(),
        });
        const { data: streak } = await supabase
          .from("school_streaks")
          .select("*")
          .eq("user_id", user.id)
          .maybeSingle();
        const nextStreak = applyStreak(
          streak ?? { current_streak: 0, longest_streak: 0, last_active_date: null }
        );
        await supabase.from("school_streaks").upsert({
          user_id: user.id,
          ...nextStreak,
        });
      }
    } catch {
      // Non-blocking
    }

    // XP based on difficulty
    const xp = correct
      ? quiz.difficulty === "hard"
        ? XP.quizHard
        : quiz.difficulty === "easy"
          ? XP.quizEasy
          : XP.quizMedium
      : XP.quizWrong;
    await awardXp(xp, `quiz:${quiz.difficulty}:${correct ? "right" : "wrong"}`);
    if ((score.total + 1) % 10 === 0) await detectBadges();
  }

  function next() {
    setPicked(null);
    setIndex((i) => i + 1);
  }

  if (done) {
    const pct = score.total ? Math.round((score.correct / score.total) * 100) : 0;
    return (
      <Card>
        <CardContent className="p-8 text-center space-y-4">
          <Trophy className="h-12 w-12 text-amber-500 mx-auto" />
          <h2 className="text-2xl font-bold">จบรอบนี้แล้ว!</h2>
          <p className="text-muted-foreground">
            ตอบถูก {score.correct} จาก {score.total} ข้อ ({pct}%)
          </p>
          {!isPremium && quizzes.length > freeLimit && (
            <div className="border rounded-lg p-4 bg-amber-50 text-amber-900 text-sm">
              ยังเหลืออีก {quizzes.length - freeLimit} ข้อ — สมัคร Premium เพื่อทำต่อไม่จำกัด
            </div>
          )}
          <div className="flex gap-3 justify-center">
            <Button
              onClick={() => {
                setIndex(0);
                setPicked(null);
                setScore({ correct: 0, total: 0 });
              }}
              variant="outline"
            >
              ทำใหม่
            </Button>
            <Link href="/school">
              <Button className="gap-2">
                <ArrowLeft className="h-4 w-4" /> กลับหน้าหลัก
              </Button>
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
          ข้อ {index + 1} / {effective.length}
        </span>
        <span>
          ถูก {score.correct} / {score.total}
        </span>
      </div>

      <Card>
        <CardContent className="p-6 space-y-4">
          <div className="flex items-center gap-2">
            <Badge className={LAYER_BADGE[quiz.layer] ?? "bg-slate-100 text-slate-700"}>
              {quiz.layer}
            </Badge>
            <Badge variant="outline" className="text-xs">
              {quiz.difficulty}
            </Badge>
          </div>

          <p className="text-base sm:text-lg font-medium whitespace-pre-wrap">
            {quiz.stem}
          </p>

          <div className="space-y-2">
            {quiz.choices.map((c) => {
              const chosen = picked === c.label;
              const correct = revealed && c.label === quiz.correct_answer;
              const wrong = revealed && chosen && !correct;
              return (
                <button
                  key={c.label}
                  onClick={() => pick(c.label)}
                  disabled={revealed}
                  className={[
                    "w-full text-left rounded-lg border px-4 py-3 transition-all",
                    "flex items-start gap-3",
                    revealed && correct && "border-emerald-400 bg-emerald-50",
                    wrong && "border-rose-400 bg-rose-50",
                    !revealed && "hover:border-brand/40 hover:bg-muted/50 cursor-pointer",
                    revealed && !correct && !wrong && "opacity-60",
                  ]
                    .filter(Boolean)
                    .join(" ")}
                >
                  <span className="font-semibold w-6 shrink-0">{c.label}.</span>
                  <span className="flex-1">{c.text}</span>
                  {revealed && correct && (
                    <CheckCircle className="h-5 w-5 text-emerald-600 shrink-0" />
                  )}
                  {wrong && <XCircle className="h-5 w-5 text-rose-600 shrink-0" />}
                </button>
              );
            })}
          </div>

          {revealed && (
            <div
              className={[
                "rounded-lg p-4 border text-sm",
                isCorrect
                  ? "bg-emerald-50 border-emerald-200 text-emerald-900"
                  : "bg-rose-50 border-rose-200 text-rose-900",
              ].join(" ")}
            >
              <p className="font-semibold mb-1">
                {isCorrect ? "ถูกต้อง!" : `เฉลย: ${quiz.correct_answer}`}
              </p>
              {quiz.explanation && (
                <p className="whitespace-pre-wrap">{quiz.explanation}</p>
              )}
              {quiz.source && (
                <p className="mt-2 text-xs italic opacity-80">ที่มา: {quiz.source}</p>
              )}
            </div>
          )}
        </CardContent>
      </Card>

      {revealed && (
        <Button onClick={next} className="w-full gap-2">
          ข้อถัดไป <ArrowRight className="h-4 w-4" />
        </Button>
      )}
    </div>
  );
}
