"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import Link from "next/link";
import { cn } from "@/lib/utils";
import { usePreCourseStore } from "@/lib/courses/stores/pre-course-store";
import {
  markLessonRead,
  saveQuizAttempt,
  getAttemptCount,
} from "@/lib/courses/offline/db";
import { scheduleFlush } from "@/lib/courses/offline/sync-engine";

interface ReadStep {
  type: "read";
  heading: string;
  body: string;
}
interface QuizStep {
  type: "quiz";
  id: string;
  topic: string;
  question: string;
  choices: { id: string; text: string }[];
  correctId: string;
  explanation: string;
}
type Step = ReadStep | QuizStep;

export interface Lesson {
  id: string;
  title: string;
  description: string;
  estMinutes: number;
  passingScore: number;
  steps: Step[];
}

function ReadBody({ body }: { body: string }) {
  const lines = (body ?? "")
    .split("\n")
    .map((l) => l.trim())
    .filter(Boolean);

  return (
    <div className="text-[15px] leading-7 text-foreground/85">
      {lines.map((line, i) => {
        const bullet = line.match(/^([•\-*])\s+(.*)$/);
        const numbered = line.match(/^(\d+)[).]\s+(.*)$/);
        if (bullet) {
          return (
            <div key={i} className={cn("flex gap-2.5", i > 0 && "mt-2")}>
              <span className="shrink-0 text-brand">•</span>
              <span>{bullet[2]}</span>
            </div>
          );
        }
        if (numbered) {
          return (
            <div key={i} className={cn("flex gap-2.5", i > 0 && "mt-2")}>
              <span className="min-w-[22px] shrink-0 font-semibold text-brand">
                {numbered[1]}.
              </span>
              <span>{numbered[2]}</span>
            </div>
          );
        }
        return (
          <p key={i} className={i > 0 ? "mt-3" : ""}>
            {line}
          </p>
        );
      })}
    </div>
  );
}

export default function LessonReader({
  lesson,
  nextHref = "/acls/learn",
}: {
  lesson: Lesson;
  /** Where "บทเรียนถัดไป" points — pass "/bls/learn" from the BLS reader. */
  nextHref?: string;
}) {
  const totalSteps = lesson.steps.length;
  const quizSteps = useMemo(
    () => lesson.steps.filter((s): s is QuizStep => s.type === "quiz"),
    [lesson]
  );
  const totalQuiz = quizSteps.length;

  const [stepIndex, setStepIndex] = useState(0);
  const [answers, setAnswers] = useState<Record<string, string>>({});

  const isOnSummary = stepIndex >= totalSteps;
  const step = !isOnSummary ? lesson.steps[stepIndex] : null;

  const { correctSoFar, answeredCount } = useMemo(() => {
    let correct = 0;
    let answered = 0;
    for (const s of quizSteps) {
      const chosen = answers[s.id];
      if (chosen) {
        answered += 1;
        if (chosen === s.correctId) correct += 1;
      }
    }
    return { correctSoFar: correct, answeredCount: answered };
  }, [quizSteps, answers]);

  const score = totalQuiz ? Math.round((correctSoFar / totalQuiz) * 100) : 0;
  const passed = score >= lesson.passingScore;

  // Persist best score on completion (no login).
  useEffect(() => {
    if (!isOnSummary || typeof window === "undefined") return;
    const key = `acls-reader-precourse-${lesson.id}`;
    const prev = Number(window.localStorage.getItem(key) ?? "0");
    if (score > prev) window.localStorage.setItem(key, String(score));
  }, [isOnSummary, score, lesson.id]);

  // When a student identity exists (class/offline course mode), also record
  // the read + quiz attempt in Dexie so it syncs to the cohort dashboard.
  // localStorage above stays untouched — it still drives the prereq gates.
  const startedAtRef = useRef<string>(new Date().toISOString());
  const attemptSavedRef = useRef(false);
  useEffect(() => {
    if (!isOnSummary || attemptSavedRef.current) return;
    const activeStudent = usePreCourseStore.getState().activeStudent;
    if (!activeStudent) return;
    attemptSavedRef.current = true;

    const detailed = quizSteps.map((q) => {
      const chosen = answers[q.id] || null;
      return { questionId: q.id, chosenId: chosen, correct: chosen === q.correctId };
    });
    const finishedAt = new Date().toISOString();

    void (async () => {
      try {
        await markLessonRead(activeStudent.id, lesson.id);
        const prevCount = await getAttemptCount(activeStudent.id, lesson.id);
        await saveQuizAttempt({
          studentId: activeStudent.id,
          lessonId: lesson.id,
          score,
          totalQuestions: totalQuiz,
          correctCount: correctSoFar,
          answers: detailed,
          startedAt: startedAtRef.current,
          finishedAt,
          passed,
          attemptNumber: prevCount + 1,
        });
        scheduleFlush();
      } catch {
        // Best-effort offline persistence — never block the summary screen.
      }
    })();
  }, [isOnSummary, quizSteps, answers, score, totalQuiz, correctSoFar, passed, lesson.id]);

  const progressPct = Math.round((Math.min(stepIndex, totalSteps) / totalSteps) * 100);
  const quizUnanswered = step?.type === "quiz" && !answers[step.id];

  return (
    <div className="space-y-4">
      <div className="rounded-lg border border-border p-3">
        <div className="mb-2 flex items-center justify-between text-xs">
          <span className="font-semibold text-muted-foreground">
            {isOnSummary ? "พร้อมสรุป" : `ขั้นที่ ${stepIndex + 1} / ${totalSteps}`}
          </span>
          <span className="text-muted-foreground">
            ตอบถูก <span className="font-bold text-brand">{correctSoFar}</span>
            {answeredCount > 0 && <span> / {answeredCount} ที่ตอบ</span>} (จาก {totalQuiz} ข้อ)
          </span>
        </div>
        <div className="h-2 overflow-hidden rounded-full bg-muted">
          <div
            className="h-full bg-brand transition-all"
            style={{ width: `${progressPct}%` }}
          />
        </div>
      </div>

      {!isOnSummary && step?.type === "read" && (
        <section className="rounded-xl border border-border p-5">
          <h2 className="mb-3 text-lg font-semibold text-brand">{step.heading}</h2>
          <ReadBody body={step.body} />
        </section>
      )}

      {!isOnSummary && step?.type === "quiz" && (
        <QuizStepView
          step={step}
          chosenId={answers[step.id]}
          onChoose={(cid) =>
            setAnswers((a) => (a[step.id] ? a : { ...a, [step.id]: cid }))
          }
        />
      )}

      {isOnSummary && (
        <section
          className={cn(
            "rounded-xl border p-6 text-center",
            passed ? "border-brand/30 bg-brand/10" : "border-destructive/30 bg-destructive/10"
          )}
        >
          <p className="text-sm text-muted-foreground">เรียนจบบทแล้ว</p>
          <p className="mt-1 text-4xl font-bold">
            {score}%{" "}
            <span
              className={cn(
                "text-lg font-semibold",
                passed ? "text-brand" : "text-destructive"
              )}
            >
              {passed ? "ผ่าน" : "ไม่ผ่าน"}
            </span>
          </p>
          <p className="mt-1 text-sm text-muted-foreground">
            ตอบถูก {correctSoFar} / {totalQuiz} ข้อ · เกณฑ์ผ่าน {lesson.passingScore}%
          </p>
          {answeredCount < totalQuiz && (
            <p className="mt-2 text-sm text-destructive">
              ยังมี {totalQuiz - answeredCount} ข้อที่ไม่ได้ตอบ (นับเป็นข้อผิด)
            </p>
          )}
          <div className="mt-5 flex justify-center gap-2">
            <button
              onClick={() => {
                setAnswers({});
                setStepIndex(0);
                startedAtRef.current = new Date().toISOString();
                attemptSavedRef.current = false;
              }}
              className="rounded-lg border border-border px-4 py-2 text-sm font-medium hover:bg-muted/40"
            >
              เริ่มบทนี้ใหม่
            </button>
            <Link
              href={nextHref}
              className="rounded-lg bg-brand px-4 py-2 text-sm font-medium text-white hover:bg-brand/90"
            >
              บทเรียนถัดไป →
            </Link>
          </div>
        </section>
      )}

      <div className="flex items-center gap-2 pt-1">
        <button
          onClick={() => setStepIndex((i) => Math.max(0, i - 1))}
          disabled={stepIndex === 0}
          className="rounded-lg border border-border px-4 py-2 text-sm font-medium disabled:opacity-40 hover:bg-muted/40"
        >
          ← ก่อนหน้า
        </button>
        <div className="flex-1" />
        {!isOnSummary && (
          <button
            onClick={() => setStepIndex((i) => Math.min(totalSteps, i + 1))}
            disabled={quizUnanswered}
            className="rounded-lg bg-brand px-4 py-2 text-sm font-medium text-white disabled:opacity-40 hover:bg-brand/90"
          >
            {quizUnanswered ? "เลือกคำตอบก่อน" : "ถัดไป →"}
          </button>
        )}
      </div>
    </div>
  );
}

function QuizStepView({
  step,
  chosenId,
  onChoose,
}: {
  step: QuizStep;
  chosenId?: string;
  onChoose: (id: string) => void;
}) {
  const answered = !!chosenId;
  const correct = answered && chosenId === step.correctId;

  return (
    <section className="space-y-3">
      <p className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">
        คำถาม
      </p>
      <div className="rounded-xl border border-border p-5">
        <p className="mb-4 font-medium">{step.question}</p>
        <div className="space-y-2">
          {step.choices.map((c) => {
            const isAns = c.id === step.correctId;
            let tone = "border-border hover:border-brand/40 hover:bg-muted/40";
            if (answered) {
              if (isAns) tone = "border-brand bg-brand/10";
              else if (c.id === chosenId) tone = "border-destructive bg-destructive/10";
              else tone = "border-border opacity-70";
            }
            return (
              <button
                key={c.id}
                onClick={() => onChoose(c.id)}
                disabled={answered}
                className={cn(
                  "flex w-full items-center justify-between rounded-lg border p-3 text-left text-sm transition-colors",
                  tone,
                  answered && "cursor-default"
                )}
              >
                <span>{c.text}</span>
                {answered && isAns && <span className="text-brand">✓</span>}
                {answered && c.id === chosenId && !isAns && (
                  <span className="text-destructive">✗</span>
                )}
              </button>
            );
          })}
        </div>
      </div>
      {answered && (
        <div
          className={cn(
            "rounded-lg p-4 text-sm",
            correct ? "bg-brand/10" : "bg-destructive/10"
          )}
        >
          <p
            className={cn(
              "mb-1 font-semibold",
              correct ? "text-brand" : "text-destructive"
            )}
          >
            {correct ? "ถูกต้อง" : "ผิด — มาดูเฉลย"}
          </p>
          <p className="text-foreground/85">{step.explanation}</p>
        </div>
      )}
    </section>
  );
}
