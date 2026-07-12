"use client";

// Dedicated BLS post-test exam UI — structurally mirrors
// components/acls-reader/Exam.tsx, but BLS post-test content is static (not
// Supabase-backed like acls_assessment_sets/questions), so this component
// does NOT POST to /api/acls/attempts (that route looks up bank_id from a
// Supabase set that doesn't exist for BLS ids). It only writes to the local
// Dexie store (markLessonRead + saveQuizAttempt) + schedules a sync flush,
// and only when a student has been identified (enforced by the caller,
// BlsPostTestGate, before this component ever renders).

import { useRef, useState } from "react";
import { cn } from "@/lib/utils";
import type { AssessmentQuestion } from "@/lib/acls-reader/assessment";
import { usePreCourseStore } from "@/lib/courses/stores/pre-course-store";
import { saveQuizAttempt, markLessonRead, getAttemptCount } from "@/lib/courses/offline/db";
import { scheduleFlush } from "@/lib/courses/offline/sync-engine";
import { POST_TEST_LESSON_ID, POST_TEST_PASS_PERCENT } from "@/lib/courses/bls/post-test";

const TOPIC_LABELS: Record<string, string> = {
  chain: "Chain of Survival",
  "high-quality-cpr": "High-Quality CPR",
  aed: "AED",
  team: "Team / 2-rescuer",
  "in-hospital-defib": "In-hospital Defib",
  infant: "ทารก",
  choking: "Choking (FBAO)",
};

export default function BlsPostTestExam({
  questions,
  setId,
}: {
  questions: AssessmentQuestion[];
  setId: string;
}) {
  const [answers, setAnswers] = useState<Record<string, string>>({});
  const [submitted, setSubmitted] = useState(false);
  const startedAtRef = useRef<string>(new Date().toISOString());
  const activeStudent = usePreCourseStore((s) => s.activeStudent);

  if (questions.length === 0) {
    return (
      <p className="rounded-lg border border-border bg-muted/40 p-4 text-muted-foreground">
        ยังไม่มีข้อสอบในชุดนี้
      </p>
    );
  }

  const total = questions.length;
  const answeredCount = Object.keys(answers).length;
  const correctCount = questions.filter((q) => answers[q.id] === q.correctId).length;
  const pct = Math.round((correctCount / total) * 100);
  const passed = pct >= POST_TEST_PASS_PERCENT;

  function select(qId: string, choiceId: string) {
    if (submitted) return;
    setAnswers((a) => ({ ...a, [qId]: choiceId }));
  }

  async function submit() {
    setSubmitted(true);
    if (activeStudent) {
      const startedAt = startedAtRef.current;
      const finishedAt = new Date().toISOString();
      const attemptAnswers = questions.map((q) => ({
        questionId: q.id,
        choiceId: answers[q.id] ?? null,
        correct: answers[q.id] === q.correctId,
      }));
      try {
        await markLessonRead(activeStudent.id, POST_TEST_LESSON_ID);
        const attemptNumber = (await getAttemptCount(activeStudent.id, POST_TEST_LESSON_ID)) + 1;
        await saveQuizAttempt({
          studentId: activeStudent.id,
          lessonId: POST_TEST_LESSON_ID,
          score: pct,
          totalQuestions: total,
          correctCount,
          answers: attemptAnswers,
          startedAt,
          finishedAt,
          passed,
          attemptNumber,
        });
        scheduleFlush();
      } catch {
        /* Dexie unavailable (e.g. private browsing) — summary still shows the score */
      }
    }
    window.scrollTo({ top: 0, behavior: "smooth" });
  }

  // Per-topic breakdown (after submit)
  const byTopic = new Map<string, { correct: number; total: number }>();
  if (submitted) {
    for (const q of questions) {
      const t = byTopic.get(q.topic) ?? { correct: 0, total: 0 };
      t.total += 1;
      if (answers[q.id] === q.correctId) t.correct += 1;
      byTopic.set(q.topic, t);
    }
  }

  return (
    <div>
      <p className="mb-4 text-xs text-muted-foreground">ชุดข้อสอบ: {setId}</p>

      {submitted && (
        <div
          className={cn(
            "mb-8 rounded-xl border p-5 text-center",
            passed ? "border-brand/30 bg-brand/10" : "border-destructive/30 bg-destructive/10",
          )}
        >
          <p className="text-sm text-muted-foreground">คะแนนของคุณ</p>
          <p className="mt-1 text-4xl font-bold">
            {pct}%{" "}
            <span className="text-lg font-medium text-muted-foreground">
              ({correctCount}/{total})
            </span>
          </p>
          <p className={cn("mt-2 font-semibold", passed ? "text-brand" : "text-destructive")}>
            {passed ? `ผ่าน (เกณฑ์ ${POST_TEST_PASS_PERCENT}%)` : `ยังไม่ผ่าน (เกณฑ์ ${POST_TEST_PASS_PERCENT}%)`}
          </p>

          {byTopic.size > 0 && (
            <div className="mx-auto mt-4 max-w-sm space-y-1 text-left text-sm">
              {[...byTopic.entries()].map(([topic, s]) => (
                <div key={topic} className="flex justify-between">
                  <span className="text-muted-foreground">{TOPIC_LABELS[topic] ?? topic}</span>
                  <span className={s.correct === s.total ? "text-brand" : "text-foreground"}>
                    {s.correct}/{s.total}
                  </span>
                </div>
              ))}
            </div>
          )}

          <button
            onClick={() => window.location.reload()}
            className="mt-5 rounded-lg bg-brand px-5 py-2 text-sm font-medium text-white transition-colors hover:bg-brand/90"
          >
            ทำใหม่อีกครั้ง
          </button>
        </div>
      )}

      <div className="space-y-6">
        {questions.map((q, i) => {
          const chosen = answers[q.id];
          return (
            <div key={q.id} className="rounded-xl border border-border p-4 sm:p-5">
              <p className="font-medium">
                <span className="text-muted-foreground">{i + 1}. </span>
                {q.question}
              </p>
              <div className="mt-3 space-y-2">
                {q.choices.map((c) => {
                  const isChosen = chosen === c.id;
                  const isCorrect = c.id === q.correctId;
                  let tone = "border-border hover:border-brand/40 hover:bg-muted/40";
                  if (submitted) {
                    if (isCorrect) tone = "border-brand bg-brand/10";
                    else if (isChosen) tone = "border-destructive bg-destructive/10";
                    else tone = "border-border opacity-70";
                  } else if (isChosen) {
                    tone = "border-brand bg-brand/10";
                  }
                  return (
                    <button
                      key={c.id}
                      onClick={() => select(q.id, c.id)}
                      disabled={submitted}
                      className={cn(
                        "flex w-full items-start gap-3 rounded-lg border p-3 text-left text-sm transition-colors",
                        tone,
                        submitted && "cursor-default",
                      )}
                    >
                      <span className="font-semibold uppercase">{c.id}.</span>
                      <span className="flex-1">{c.text}</span>
                      {submitted && isCorrect && <span className="text-brand">✓</span>}
                      {submitted && isChosen && !isCorrect && (
                        <span className="text-destructive">✗</span>
                      )}
                    </button>
                  );
                })}
              </div>
              {submitted && q.explanation && (
                <div className="mt-3 rounded-lg bg-muted/50 p-3 text-sm text-foreground/85">
                  <span className="font-semibold">เฉลย: </span>
                  {q.explanation}
                </div>
              )}
            </div>
          );
        })}
      </div>

      {!submitted && (
        <div className="sticky bottom-4 mt-8">
          <button
            onClick={submit}
            disabled={answeredCount === 0}
            className="w-full rounded-xl bg-brand px-5 py-3 font-medium text-white shadow-lg transition-colors hover:bg-brand/90 disabled:opacity-50"
          >
            ส่งคำตอบ ({answeredCount}/{total})
          </button>
        </div>
      )}
    </div>
  );
}
