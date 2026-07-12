"use client";

import { useRouter } from "next/navigation";
import { Sparkles, Check, RotateCcw, ArrowRight } from "lucide-react";
import type { CourseMode } from "@/lib/courses/config";
import { getCourseMeta } from "@/lib/courses/config";
import {
  PRE_TEST_PASS_PERCENT,
  PRE_TEST_QUESTION_COUNT,
} from "@/lib/courses/assessment-ids";
import { cn } from "@/lib/utils";
import { text2xs } from "./course-ui";

interface PreTestCardProps {
  course: CourseMode;
  bestScore: number | null;
  passed: boolean;
  attemptCount: number;
}

export default function PreTestCard({
  course,
  bestScore,
  passed,
  attemptCount,
}: PreTestCardProps) {
  const router = useRouter();
  const meta = getCourseMeta(course);
  const hasAttempt = bestScore != null;
  const go = () => router.push(`${meta.basePath}/pre-test`);

  return (
    <div className="overflow-hidden rounded-xl border border-border bg-card shadow-sm">
      <div className="flex items-center gap-3 px-4 pb-3 pt-3.5">
        <div className="inline-flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-sky-500/15 text-sky-600 dark:text-sky-400">
          <Sparkles size={18} strokeWidth={2.2} />
        </div>
        <div className="min-w-0 flex-1">
          <div className="flex items-center gap-2">
            <div className="truncate text-sm font-semibold text-foreground">
              Pre-test {meta.shortName}
            </div>
            {hasAttempt && (
              <span
                className={cn(
                  "inline-flex shrink-0 items-center gap-0.5 rounded-full px-1.5 py-0.5 text-[11px] font-bold",
                  passed
                    ? "bg-emerald-500/15 text-emerald-600 dark:text-emerald-400"
                    : "bg-amber-500/15 text-amber-600 dark:text-amber-400",
                )}
              >
                {passed ? (
                  <Check size={10} strokeWidth={2.6} />
                ) : (
                  <RotateCcw size={10} strokeWidth={2.6} />
                )}
                {bestScore}%
              </span>
            )}
          </div>
          <div className={`${text2xs} mt-0.5 text-muted-foreground`}>
            {PRE_TEST_QUESTION_COUNT} ข้อ · เกณฑ์ {PRE_TEST_PASS_PERCENT}%
            {hasAttempt && attemptCount > 1 ? (
              <> · พยายาม {attemptCount} ครั้ง</>
            ) : (
              <> · ทำก่อนเริ่มเรียน</>
            )}
          </div>
        </div>
      </div>

      <button
        onClick={go}
        className="flex h-12 w-full items-center justify-center gap-1.5 bg-sky-600 text-sm font-bold text-white transition-opacity hover:opacity-90 active:opacity-80"
      >
        {hasAttempt ? "ทำใหม่อีกครั้ง" : "เริ่มทำ Pre-test"}
        <ArrowRight size={16} strokeWidth={2.4} />
      </button>
    </div>
  );
}
