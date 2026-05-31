"use client";

import { useState } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Trophy, ArrowRight, Zap } from "lucide-react";
import Link from "next/link";
import type { SchoolQuiz } from "@/lib/types-school";
import { createClient } from "@/lib/supabase/client";
import { nextSrsState } from "@/lib/school/srs";
import { XP, awardXp, awardBadge } from "@/lib/school/xp";
import RewardBadge from "./RewardBadge";
import ShareResult from "./ShareResult";

interface Props {
  quizzes: SchoolQuiz[];
  topicName: string;
  topicId: string;
}

export default function ChallengeRunner({ quizzes, topicName, topicId }: Props) {
  const [idx, setIdx] = useState(0);
  const [picked, setPicked] = useState<string | null>(null);
  const [correct, setCorrect] = useState(0);
  const [xpEarned, setXpEarned] = useState(0);
  const [badgeWon, setBadgeWon] = useState(false);

  const quiz = quizzes[idx];
  const done = !quiz;

  async function pick(label: string) {
    if (picked || !quiz) return;
    setPicked(label);
    const isCorrect = label === quiz.correct_answer;
    if (isCorrect) setCorrect((c) => c + 1);

    const xp = isCorrect ? XP.quizHard : XP.quizWrong;
    setXpEarned((x) => x + xp);
    await awardXp(xp, `challenge:quiz`);

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
      }
    } catch {
      // Non-blocking
    }
  }

  async function next() {
    if (idx + 1 < quizzes.length) {
      setIdx((i) => i + 1);
      setPicked(null);
      return;
    }
    // Finishing — award badge if passed
    const pct = Math.round((correct / quizzes.length) * 100);
    if (pct >= 80) {
      const newly = await awardBadge("challenge_win");
      if (newly) setBadgeWon(true);
      await awardXp(XP.challengePassed, "challenge:passed");
      setXpEarned((x) => x + XP.challengePassed);
    }
    setIdx((i) => i + 1);
  }

  if (done) {
    const total = quizzes.length;
    const pct = total ? Math.round((correct / total) * 100) : 0;
    const passed = pct >= 80;
    return (
      <Card>
        <CardContent className="p-8 text-center space-y-4">
          <Trophy className={`h-12 w-12 mx-auto ${passed ? "text-amber-500" : "text-muted-foreground"}`} />
          <h2 className="text-2xl font-bold">
            {passed ? "ผ่าน Challenge!" : "ลองอีกครั้ง"}
          </h2>
          <p className="text-muted-foreground">
            ถูก {correct}/{total} ({pct}%)
          </p>
          <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-amber-100 text-amber-700 font-bold">
            <Zap className="h-4 w-4" /> +{xpEarned} XP
          </div>
          {badgeWon && (
            <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-rose-100 text-rose-700 font-bold">
              ⚡ ได้ badge ใหม่: พิชิต Challenge
            </div>
          )}
          <div>
            <RewardBadge />
          </div>
          {passed && (
            <div className="pt-3">
              <p className="text-sm font-semibold mb-2">แชร์ให้เพื่อน</p>
              <ShareResult
                topicName={`${topicName} (Challenge)`}
                score={correct}
                total={total}
                xpEarned={xpEarned}
              />
            </div>
          )}
          <div className="flex gap-3 justify-center pt-2">
            <Link href={`/school/topic/${topicId}`}>
              <Button variant="outline">กลับ Topic</Button>
            </Link>
            <Link href="/school/leaderboard">
              <Button>ดู Leaderboard</Button>
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
          ข้อ {idx + 1} / {quizzes.length}
        </span>
        <span>ถูก {correct}</span>
      </div>
      <Card>
        <CardContent className="p-6 space-y-3">
          <Badge variant="outline" className="text-xs">
            Hard · {quiz.layer}
          </Badge>
          <p className="font-medium whitespace-pre-wrap">{quiz.stem}</p>
          <div className="space-y-2">
            {quiz.choices.map((c) => {
              const chosen = picked === c.label;
              const correctAns = picked && c.label === quiz.correct_answer;
              const wrong = chosen && !correctAns;
              return (
                <button
                  key={c.label}
                  onClick={() => pick(c.label)}
                  disabled={picked !== null}
                  className={[
                    "w-full text-left rounded-lg border px-4 py-3 flex items-start gap-3",
                    correctAns && "border-emerald-400 bg-emerald-50",
                    wrong && "border-rose-400 bg-rose-50",
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
        <Button onClick={next} className="w-full gap-2">
          {idx + 1 < quizzes.length ? "ข้อถัดไป" : "ดูผล"}{" "}
          <ArrowRight className="h-4 w-4" />
        </Button>
      )}
    </div>
  );
}
