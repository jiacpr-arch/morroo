"use client";

import { useState } from "react";
import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { CheckCircle, RotateCcw, Trophy, XCircle } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { nextSrsState } from "@/lib/school/srs";
import { XP, awardXp } from "@/lib/school/xp";
import {
  difficultyBadgeClass,
  difficultyLabelTh,
} from "@/lib/school/difficulty";
import type { SchoolDifficulty } from "@/lib/types-school";

export interface RunnerQuiz {
  /** id ในตาราง school_quizzes — ไม่มีเมื่อเป็น mini quiz ที่ฝังในบท */
  dbId: string | null;
  stem: string;
  choices: { label: string; text: string }[];
  correct_answer: string;
  explanation: string | null;
  difficulty: SchoolDifficulty | null;
}

interface Props {
  quizzes: RunnerQuiz[];
  lessonId: string;
  /** ลิงก์กลับไปอ่านเนื้อหาบทนี้ */
  readHref: string;
}

const XP_BY_DIFFICULTY: Record<SchoolDifficulty, number> = {
  easy: XP.quizEasy,
  medium: XP.quizMedium,
  hard: XP.quizHard,
};

/**
 * โหมด "ควิซอย่างเดียว" ของหนึ่งบท — ไล่ทีละข้อ เฉลยทันทีหลังตอบ
 * ข้อที่มาจากคลัง (มี dbId) จะบันทึก SRS ให้ด้วย ส่วน mini quiz ที่ฝังใน
 * เนื้อหาไม่มีแถวในฐาน จึงให้แค่ XP และนับคะแนนในรอบนี้
 */
export default function LessonQuizRunner({ quizzes, lessonId, readHref }: Props) {
  const [index, setIndex] = useState(0);
  const [picked, setPicked] = useState<string | null>(null);
  const [score, setScore] = useState({ correct: 0, total: 0 });

  const quiz = quizzes[index];
  const done = !quiz;
  const revealed = picked !== null;

  async function pick(label: string) {
    if (revealed || !quiz) return;
    setPicked(label);
    const correct = label === quiz.correct_answer;
    setScore((s) => ({
      correct: s.correct + (correct ? 1 : 0),
      total: s.total + 1,
    }));

    const difficulty = quiz.difficulty ?? "medium";
    await awardXp(
      correct ? XP_BY_DIFFICULTY[difficulty] : XP.quizWrong,
      `lesson-quiz:${lessonId}:${index}`,
    );

    if (!quiz.dbId) return;
    try {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return;
      const { data: prev } = await supabase
        .from("school_progress")
        .select("ease_factor, interval_days")
        .eq("user_id", user.id)
        .eq("unit_type", "quiz")
        .eq("unit_id", quiz.dbId)
        .order("reviewed_at", { ascending: false })
        .limit(1)
        .maybeSingle();
      const next = nextSrsState(prev, correct ? "correct" : "wrong");
      await supabase.from("school_progress").insert({
        user_id: user.id,
        unit_type: "quiz",
        unit_id: quiz.dbId,
        outcome: correct ? "correct" : "wrong",
        ease_factor: next.ease_factor,
        interval_days: next.interval_days,
        due_at: next.due_at.toISOString(),
      });
    } catch {
      // ไม่ให้การบันทึกล้มเหลวขวางการทำข้อถัดไป
    }
  }

  function next() {
    setPicked(null);
    setIndex((i) => i + 1);
  }

  function restart() {
    setPicked(null);
    setIndex(0);
    setScore({ correct: 0, total: 0 });
  }

  if (done) {
    const pct = score.total ? Math.round((score.correct / score.total) * 100) : 0;
    return (
      <Card className="border-emerald-300 bg-emerald-50/40">
        <CardContent className="p-6 text-center space-y-3">
          <Trophy className="h-10 w-10 mx-auto text-emerald-600" />
          <p className="text-2xl font-bold">
            {score.correct} / {score.total} ข้อ ({pct}%)
          </p>
          <p className="text-sm text-muted-foreground">
            {pct >= 80
              ? "แม่นมาก — บทนี้ผ่านเกณฑ์ mastery แล้ว"
              : "ยังไม่ถึง 80% — ลองกลับไปอ่านเนื้อหาแล้วทำใหม่อีกรอบ"}
          </p>
          <div className="flex flex-col sm:flex-row gap-2 justify-center pt-2">
            <Button onClick={restart} variant="outline" className="gap-2">
              <RotateCcw className="h-4 w-4" /> ทำใหม่อีกรอบ
            </Button>
            <Link href={readHref}>
              <Button className="w-full sm:w-auto">อ่านเนื้อหาบทนี้</Button>
            </Link>
          </div>
        </CardContent>
      </Card>
    );
  }

  const isCorrect = revealed && picked === quiz.correct_answer;

  return (
    <div className="space-y-4">
      <div className="flex items-center gap-2">
        <Badge variant="outline">
          ข้อ {index + 1} / {quizzes.length}
        </Badge>
        {quiz.difficulty && (
          <Badge className={`text-[10px] ${difficultyBadgeClass(quiz.difficulty)}`}>
            {difficultyLabelTh(quiz.difficulty)}
          </Badge>
        )}
        <span className="ml-auto text-xs text-muted-foreground">
          ถูก {score.correct}/{score.total}
        </span>
      </div>
      <div className="h-1.5 bg-muted rounded-full overflow-hidden">
        <div
          className="h-full bg-emerald-500 transition-all"
          style={{ width: `${(index / quizzes.length) * 100}%` }}
        />
      </div>

      <Card>
        <CardContent className="p-5 space-y-3">
          <p className="font-medium">{quiz.stem}</p>
          <div className="space-y-2">
            {quiz.choices.map((c) => {
              const chosen = picked === c.label;
              const right = revealed && c.label === quiz.correct_answer;
              const wrong = chosen && !right;
              return (
                <button
                  key={c.label}
                  onClick={() => pick(c.label)}
                  disabled={revealed}
                  className={[
                    "w-full text-left rounded border px-3 py-2 text-sm flex items-start gap-2",
                    right ? "border-emerald-400 bg-emerald-50" : "",
                    wrong ? "border-rose-400 bg-rose-50" : "",
                    !revealed ? "hover:bg-muted/50 cursor-pointer" : "",
                  ]
                    .filter(Boolean)
                    .join(" ")}
                >
                  <span className="font-semibold w-5 shrink-0">{c.label}.</span>
                  <span className="flex-1">{c.text}</span>
                  {right && <CheckCircle className="h-4 w-4 text-emerald-600" />}
                  {wrong && <XCircle className="h-4 w-4 text-rose-600" />}
                </button>
              );
            })}
          </div>
          {revealed && (
            <div className="space-y-2 pt-1">
              <p
                className={`text-sm font-semibold ${
                  isCorrect ? "text-emerald-700" : "text-rose-700"
                }`}
              >
                {isCorrect ? "ถูกต้อง" : `ตอบผิด — เฉลยคือข้อ ${quiz.correct_answer}`}
              </p>
              {quiz.explanation && (
                <p className="text-sm text-muted-foreground">{quiz.explanation}</p>
              )}
              <Button onClick={next} className="w-full">
                {index + 1 === quizzes.length ? "ดูสรุปคะแนน" : "ข้อถัดไป"}
              </Button>
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
