"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { cn } from "@/lib/utils";

interface LessonRef {
  id: string;
  passingScore: number;
}
interface SetRef {
  id: string;
  title: string;
}

export default function ReaderProgress({
  lessons,
  testSets,
}: {
  lessons: LessonRef[];
  testSets: SetRef[];
}) {
  const [mounted, setMounted] = useState(false);
  const [lessonScores, setLessonScores] = useState<Record<string, number>>({});
  const [testScores, setTestScores] = useState<Record<string, number>>({});

  useEffect(() => {
    const ls: Record<string, number> = {};
    for (const l of lessons) {
      const v = Number(window.localStorage.getItem(`acls-reader-precourse-${l.id}`) ?? "");
      if (Number.isFinite(v) && v > 0) ls[l.id] = v;
    }
    const ts: Record<string, number> = {};
    for (const s of testSets) {
      const v = Number(window.localStorage.getItem(`acls-reader-exam-${s.id}`) ?? "");
      if (Number.isFinite(v) && v > 0) ts[s.id] = v;
    }
    setLessonScores(ls);
    setTestScores(ts);
    setMounted(true);
  }, [lessons, testSets]);

  if (!mounted) return null;

  const passedCount = lessons.filter(
    (l) => (lessonScores[l.id] ?? 0) >= l.passingScore
  ).length;
  const startedLessons = Object.keys(lessonScores).length;
  const testsTaken = testSets.filter((s) => testScores[s.id] != null);

  // Nothing saved yet → don't show an empty dashboard.
  if (startedLessons === 0 && testsTaken.length === 0) return null;

  const pct = lessons.length ? Math.round((passedCount / lessons.length) * 100) : 0;

  return (
    <section className="mb-10 rounded-xl border border-border bg-muted/30 p-5">
      <h2 className="mb-4 text-sm font-semibold uppercase tracking-wide text-muted-foreground">
        ความคืบหน้าของคุณ
      </h2>

      <div className="mb-2 flex items-center justify-between text-sm">
        <span className="font-medium">บทเรียน pre-course</span>
        <span className="text-muted-foreground">
          ผ่านแล้ว <span className="font-bold text-brand">{passedCount}</span> / {lessons.length} บท
        </span>
      </div>
      <div className="h-2 overflow-hidden rounded-full bg-muted">
        <div className="h-full bg-brand transition-all" style={{ width: `${pct}%` }} />
      </div>

      {testsTaken.length > 0 && (
        <div className="mt-5">
          <p className="mb-2 text-sm font-medium">คะแนนแบบทดสอบ (ดีที่สุด)</p>
          <ul className="space-y-1.5">
            {testsTaken.map((s) => {
              const score = testScores[s.id];
              const passed = score >= 75;
              return (
                <li key={s.id} className="flex items-center justify-between text-sm">
                  <Link
                    href={`/acls-reader/test/${s.id}`}
                    className="text-muted-foreground hover:text-foreground"
                  >
                    {s.title}
                  </Link>
                  <span
                    className={cn(
                      "font-semibold",
                      passed ? "text-brand" : "text-destructive"
                    )}
                  >
                    {score}%
                  </span>
                </li>
              );
            })}
          </ul>
        </div>
      )}
    </section>
  );
}
