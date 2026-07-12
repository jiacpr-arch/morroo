"use client";

import { useEffect, useMemo, useState } from "react";
import {
  ekgQuestions,
  rhythmLabels,
  shuffleOptions,
  quizCategories,
  EKG_TEST_PASS_PERCENT,
  EKG_TEST_PASSED_KEY,
} from "@/lib/acls-reader/ekg-quiz";
import EKGWaveform from "@/components/acls-reader/EKGWaveform";
import { cn } from "@/lib/utils";

interface EkgQuestion {
  id: string;
  category: string;
  rhythmId: string;
  answer: string;
  options: string[];
  hint?: string;
  pulse?: string;
}

const labels = rhythmLabels as Record<string, string>;

export default function EkgQuiz() {
  const [cat, setCat] = useState("all");
  const [order, setOrder] = useState<number[] | null>(null);
  const [pos, setPos] = useState(0);
  const [chosen, setChosen] = useState<string | null>(null);
  const [score, setScore] = useState(0);

  const pool = useMemo<EkgQuestion[]>(
    () =>
      cat === "all"
        ? (ekgQuestions as EkgQuestion[])
        : (ekgQuestions as EkgQuestion[]).filter((q) => q.category === cat),
    [cat]
  );

  // Shuffle client-side (after mount) to avoid hydration mismatch.
  useEffect(() => {
    const idx = pool.map((_, i) => i);
    for (let i = idx.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [idx[i], idx[j]] = [idx[j], idx[i]];
    }
    setOrder(idx);
    setPos(0);
    setChosen(null);
    setScore(0);
  }, [pool]);

  const catChips = (
    <div className="mb-6 flex flex-wrap gap-2">
      {quizCategories.map((c) => (
        <button
          key={c.id}
          onClick={() => setCat(c.id)}
          className={cn(
            "rounded-full border px-3 py-1 text-sm transition-colors",
            cat === c.id
              ? "border-brand bg-brand text-white"
              : "border-border text-muted-foreground hover:border-brand/40 hover:text-foreground"
          )}
        >
          {c.label}
        </button>
      ))}
    </div>
  );

  if (!order) return <div className="h-72" />;

  const finished = pos >= order.length;

  if (finished) {
    const pct = order.length ? Math.round((score / order.length) * 100) : 0;
    // The "all" category run is the formal EKG test the certification page
    // gates on; a passing score here unlocks that requirement.
    if (cat === "all" && pct >= EKG_TEST_PASS_PERCENT && typeof window !== "undefined") {
      try {
        window.localStorage.setItem(EKG_TEST_PASSED_KEY, "true");
      } catch {
        /* ignore */
      }
    }
    return (
      <div>
        {catChips}
        <div className="rounded-xl border border-brand/30 bg-brand/10 p-6 text-center">
          <p className="text-sm text-muted-foreground">จบหมวดนี้แล้ว</p>
          <p className="mt-1 text-4xl font-bold">
            {score}/{order.length}{" "}
            <span className="text-lg font-medium text-muted-foreground">({pct}%)</span>
          </p>
          <button
            onClick={() => setCat((c) => c)}
            className="mt-5 rounded-lg bg-brand px-5 py-2 text-sm font-medium text-white hover:bg-brand/90"
          >
            เริ่มใหม่
          </button>
        </div>
      </div>
    );
  }

  const q = pool[order[pos]];
  const options = shuffleOptions(q.options, pos + 1) as string[];
  const isCorrect = chosen === q.answer;

  function choose(opt: string) {
    if (chosen) return;
    setChosen(opt);
    if (opt === q.answer) setScore((s) => s + 1);
  }

  return (
    <div>
      {catChips}

      <div className="mb-3 flex items-center justify-between text-sm text-muted-foreground">
        <span>
          ข้อ {pos + 1} / {order.length}
        </span>
        <span>คะแนน {score}</span>
      </div>

      <div className="overflow-hidden rounded-xl border border-border">
        <EKGWaveform rhythmId={q.rhythmId} variant="paper" />
      </div>
      {q.pulse === "none" && (
        <p className="mt-2 text-sm font-medium text-destructive">⚠ คลำชีพจรไม่ได้ (pulseless)</p>
      )}

      <p className="mt-5 mb-2 text-sm font-medium text-muted-foreground">
        จังหวะนี้คืออะไร?
      </p>
      <div className="grid grid-cols-1 gap-2 sm:grid-cols-2">
        {options.map((opt) => {
          const isAns = opt === q.answer;
          let tone = "border-border hover:border-brand/40 hover:bg-muted/40";
          if (chosen) {
            if (isAns) tone = "border-brand bg-brand/10";
            else if (opt === chosen) tone = "border-destructive bg-destructive/10";
            else tone = "border-border opacity-70";
          }
          return (
            <button
              key={opt}
              onClick={() => choose(opt)}
              disabled={!!chosen}
              className={cn(
                "flex items-center justify-between rounded-lg border p-3 text-left text-sm transition-colors",
                tone,
                chosen && "cursor-default"
              )}
            >
              <span>{labels[opt] ?? opt}</span>
              {chosen && isAns && <span className="text-brand">✓</span>}
              {chosen && opt === chosen && !isAns && (
                <span className="text-destructive">✗</span>
              )}
            </button>
          );
        })}
      </div>

      {chosen && (
        <div
          className={cn(
            "mt-4 rounded-lg p-4 text-sm",
            isCorrect ? "bg-brand/10" : "bg-destructive/10"
          )}
        >
          <p className={cn("font-semibold", isCorrect ? "text-brand" : "text-destructive")}>
            {isCorrect ? "ถูกต้อง!" : `เฉลย: ${labels[q.answer] ?? q.answer}`}
          </p>
          {q.hint && <p className="mt-1 text-foreground/85">{q.hint}</p>}
          <button
            onClick={() => {
              setChosen(null);
              setPos((p) => p + 1);
            }}
            className="mt-3 rounded-lg bg-brand px-4 py-2 text-sm font-medium text-white hover:bg-brand/90"
          >
            {pos + 1 >= order.length ? "ดูสรุป" : "ข้อถัดไป →"}
          </button>
        </div>
      )}
    </div>
  );
}
