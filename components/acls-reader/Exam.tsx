"use client";

import { useState } from "react";
import { cn } from "@/lib/utils";
import type { AssessmentQuestion } from "@/lib/acls-reader/assessment";

const TOPIC_LABELS: Record<string, string> = {
  overview: "ภาพรวม",
  team: "การทำงานเป็นทีม",
  assessment: "การประเมินผู้ป่วย",
  rrt: "Rapid Response",
  airway: "ทางเดินหายใจ",
  vf_pvt: "VF/pVT",
  pea_asystole: "PEA/Asystole",
  bradycardia: "Bradycardia",
  tachycardia: "Tachycardia",
  pharmacology: "ยา",
  post_arrest: "หลังกู้ชีพ",
  acs: "ACS",
  stroke: "Stroke",
};

export default function Exam({
  questions,
  setId,
  passPct = 75,
}: {
  questions: AssessmentQuestion[];
  setId: string;
  passPct?: number;
}) {
  const [answers, setAnswers] = useState<Record<string, string>>({});
  const [submitted, setSubmitted] = useState(false);

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
  const passed = pct >= passPct;

  function select(qId: string, choiceId: string) {
    if (submitted) return;
    setAnswers((a) => ({ ...a, [qId]: choiceId }));
  }

  function submit() {
    setSubmitted(true);
    if (typeof window !== "undefined") {
      try {
        const key = `acls-reader-exam-${setId}`;
        const prev = Number(localStorage.getItem(key) ?? "0");
        localStorage.setItem(key, String(Math.max(prev, pct)));
      } catch {
        /* ignore */
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
      {submitted && (
        <div
          className={cn(
            "mb-8 rounded-xl border p-5 text-center",
            passed
              ? "border-brand/30 bg-brand/10"
              : "border-destructive/30 bg-destructive/10"
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
            {passed ? `ผ่าน (เกณฑ์ ${passPct}%)` : `ยังไม่ผ่าน (เกณฑ์ ${passPct}%)`}
          </p>

          {byTopic.size > 0 && (
            <div className="mx-auto mt-4 max-w-sm space-y-1 text-left text-sm">
              {[...byTopic.entries()].map(([topic, s]) => (
                <div key={topic} className="flex justify-between">
                  <span className="text-muted-foreground">
                    {TOPIC_LABELS[topic] ?? topic}
                  </span>
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
                        submitted && "cursor-default"
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
                  {q.reference && (
                    <span className="mt-1 block text-xs text-muted-foreground">
                      อ้างอิง: {q.reference}
                    </span>
                  )}
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
