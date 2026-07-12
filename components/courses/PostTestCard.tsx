"use client";

import { useRouter } from "next/navigation";
import { Award, ChevronRight, Lock, Check, RotateCcw } from "lucide-react";
import type { CourseMode } from "@/lib/courses/config";
import { getCourseMeta } from "@/lib/courses/config";
import { POST_TEST_QUESTION_COUNT } from "@/lib/courses/assessment-ids";
import { cn } from "@/lib/utils";
import { text2xs } from "./course-ui";

interface PostTestCardProps {
  course: CourseMode;
  unlocked: boolean;
  bestScore: number | null;
  passed: boolean;
  attemptCount: number;
  lessonCount?: number;
}

export default function PostTestCard({
  course,
  unlocked,
  bestScore,
  passed,
  attemptCount,
  lessonCount,
}: PostTestCardProps) {
  const router = useRouter();
  const meta = getCourseMeta(course);
  const hasAttempt = bestScore != null;
  const goPostTest = () => router.push(`${meta.basePath}/post-test`);

  return (
    <div
      className={cn(
        "overflow-hidden rounded-xl border border-border bg-card shadow-sm",
        !unlocked && "opacity-70",
      )}
    >
      <button
        onClick={() => unlocked && goPostTest()}
        disabled={!unlocked}
        className="flex w-full items-center gap-3 px-4 py-3.5 text-left transition-colors hover:bg-muted/50 disabled:cursor-not-allowed"
      >
        <div
          className={cn(
            "inline-flex h-10 w-10 shrink-0 items-center justify-center rounded-lg",
            unlocked
              ? "bg-amber-500/15 text-amber-600 dark:text-amber-400"
              : "bg-muted text-muted-foreground",
          )}
        >
          {unlocked ? (
            <Award size={18} strokeWidth={2.2} />
          ) : (
            <Lock size={16} strokeWidth={2.4} />
          )}
        </div>
        <div className="min-w-0 flex-1">
          <div className="truncate text-sm font-semibold text-foreground">Post-test Exam</div>
          <div className={`${text2xs} mt-0.5 text-muted-foreground`}>
            {POST_TEST_QUESTION_COUNT} ข้อ · เกณฑ์ {meta.passingScore.postTest}% · สุ่มจาก 3 ชุด
          </div>
        </div>
        {unlocked && (
          <ChevronRight size={16} strokeWidth={2.2} className="shrink-0 text-muted-foreground" />
        )}
      </button>

      <div className="flex flex-wrap items-center gap-2 px-4 pb-3">
        {!unlocked ? (
          <span className="inline-flex items-center gap-1 rounded-full bg-muted px-2 py-1 text-[11px] font-bold text-muted-foreground">
            <Lock size={11} strokeWidth={2.4} /> ปลดล็อกเมื่อผ่านบทเรียนทั้ง {lessonCount ?? 6} บท
            หรือใช้รหัส voucher
          </span>
        ) : (
          <span
            className={cn(
              "inline-flex items-center gap-1 rounded-full px-2 py-1 text-[11px] font-bold",
              passed
                ? "bg-emerald-500/15 text-emerald-600 dark:text-emerald-400"
                : "bg-amber-500/15 text-amber-600 dark:text-amber-400",
            )}
          >
            {passed ? (
              <>
                <Check size={11} strokeWidth={2.4} /> ผ่าน {bestScore}%
              </>
            ) : hasAttempt ? (
              <>
                <RotateCcw size={11} strokeWidth={2.4} /> ยังไม่ผ่าน · {bestScore}%
              </>
            ) : (
              <>พร้อมสอบ</>
            )}
            {hasAttempt && attemptCount > 1 && (
              <span className="font-normal text-muted-foreground">
                · พยายาม {attemptCount} ครั้ง
              </span>
            )}
          </span>
        )}
        <div className="flex-1" />
        {unlocked && (
          <button
            onClick={(e) => {
              e.stopPropagation();
              goPostTest();
            }}
            className="inline-flex items-center gap-1 rounded-full bg-amber-500 px-3 py-1.5 text-[11px] font-bold text-white hover:opacity-90"
          >
            {hasAttempt ? "ทำใหม่" : "เริ่มสอบ"}
          </button>
        )}
      </div>
    </div>
  );
}
