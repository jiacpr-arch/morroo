"use client";

import { useRouter } from "next/navigation";
import { BookOpen, Check, ChevronRight, Clock, Play } from "lucide-react";
import type { CourseMode } from "@/lib/courses/config";
import { getCourseMeta } from "@/lib/courses/config";
import { cn } from "@/lib/utils";
import { text2xs } from "./course-ui";

export interface LessonCardLesson {
  id: string;
  title: string;
  estMinutes: number;
  passingScore: number;
  steps?: unknown[];
  quiz: unknown[];
}

const LESSON_TONE: Record<string, keyof typeof TONE_CLASSES> = {
  // ACLS pre-course
  pc01: "sky", // ภาพรวม ACLS
  pc02: "cyan", // ประเมินผู้ป่วย
  pc03: "emerald", // ป้องกัน Arrest
  pc04: "red", // ACS
  pc05: "violet", // Stroke
  pc06: "indigo", // Bradycardia
  pc07: "orange", // Tachycardia
  pc08: "teal", // ทีมช่วยชีวิต + CPR Coach
  pc09: "blue", // Airway
  pc10: "rose", // VF/pVT
  pc11: "amber", // PEA/Asystole
  pc12: "green", // Post-ROSC
  pc13: "fuchsia", // Pharmacology
  // BLS-HCP
  "bls-1": "sky",
  "bls-2": "emerald",
  "bls-3": "red",
  "bls-1r": "cyan",
  "bls-4": "orange",
  "bls-5": "violet",
  "bls-6": "teal",
  "bls-7": "fuchsia",
};

const TONE_CLASSES = {
  sky: { iconBg: "bg-sky-500/15", iconText: "text-sky-500", stripe: "bg-sky-500", btn: "bg-sky-500" },
  cyan: { iconBg: "bg-cyan-500/15", iconText: "text-cyan-500", stripe: "bg-cyan-500", btn: "bg-cyan-500" },
  emerald: { iconBg: "bg-emerald-500/15", iconText: "text-emerald-500", stripe: "bg-emerald-500", btn: "bg-emerald-500" },
  red: { iconBg: "bg-red-500/15", iconText: "text-red-500", stripe: "bg-red-500", btn: "bg-red-500" },
  violet: { iconBg: "bg-violet-500/15", iconText: "text-violet-500", stripe: "bg-violet-500", btn: "bg-violet-500" },
  indigo: { iconBg: "bg-indigo-500/15", iconText: "text-indigo-500", stripe: "bg-indigo-500", btn: "bg-indigo-500" },
  orange: { iconBg: "bg-orange-500/15", iconText: "text-orange-500", stripe: "bg-orange-500", btn: "bg-orange-500" },
  teal: { iconBg: "bg-teal-500/15", iconText: "text-teal-500", stripe: "bg-teal-500", btn: "bg-teal-500" },
  blue: { iconBg: "bg-blue-500/15", iconText: "text-blue-500", stripe: "bg-blue-500", btn: "bg-blue-500" },
  rose: { iconBg: "bg-rose-500/15", iconText: "text-rose-500", stripe: "bg-rose-500", btn: "bg-rose-500" },
  amber: { iconBg: "bg-amber-500/15", iconText: "text-amber-500", stripe: "bg-amber-500", btn: "bg-amber-500" },
  green: { iconBg: "bg-green-500/15", iconText: "text-green-500", stripe: "bg-green-500", btn: "bg-green-500" },
  fuchsia: { iconBg: "bg-fuchsia-500/15", iconText: "text-fuchsia-500", stripe: "bg-fuchsia-500", btn: "bg-fuchsia-500" },
};

const DEFAULT_TONE = TONE_CLASSES.blue;

interface LessonCardProps {
  lesson: LessonCardLesson;
  course: CourseMode;
  read?: boolean;
  bestScore?: number | null;
  passed?: boolean;
  inProgress?: boolean;
}

export default function LessonCard({
  lesson,
  course,
  read,
  bestScore,
  passed,
  inProgress,
}: LessonCardProps) {
  const router = useRouter();
  const meta = getCourseMeta(course);
  const hasAttempt = bestScore != null;
  const stepCount = lesson.steps?.length ?? 0;
  const tone = TONE_CLASSES[LESSON_TONE[lesson.id]] ?? DEFAULT_TONE;
  // morroo's lesson reader lives at {basePath}/learn/[lessonId]
  // (old app: /pre-course/:lessonId).
  const go = () => router.push(`${meta.basePath}/learn/${lesson.id}`);

  return (
    <div className="relative overflow-hidden rounded-xl border border-border bg-card shadow-sm">
      <div className={cn("absolute bottom-0 left-0 top-0 w-1", tone.stripe)} aria-hidden />
      <button
        onClick={go}
        className="flex w-full items-center gap-3 py-3.5 pl-5 pr-4 text-left transition-colors hover:bg-muted/50"
      >
        <div
          className={cn(
            "inline-flex h-10 w-10 shrink-0 items-center justify-center rounded-lg",
            tone.iconBg,
            tone.iconText,
          )}
        >
          <BookOpen size={18} strokeWidth={2.2} />
        </div>
        <div className="min-w-0 flex-1">
          <div className="truncate text-sm font-semibold text-foreground">{lesson.title}</div>
          <div className={`${text2xs} mt-0.5 inline-flex items-center gap-2 text-muted-foreground`}>
            <Clock size={11} strokeWidth={2.2} /> ~{lesson.estMinutes} นาที
            <span className="text-muted-foreground">·</span>
            <span>
              {stepCount} ขั้น · {lesson.quiz.length} ข้อ
            </span>
            <span className="text-muted-foreground">·</span>
            <span>เกณฑ์ {lesson.passingScore}%</span>
          </div>
        </div>
        <ChevronRight size={16} strokeWidth={2.2} className="shrink-0 text-muted-foreground" />
      </button>

      <div className="flex flex-wrap items-center gap-2 pb-3 pl-5 pr-4">
        <span
          className={cn(
            "inline-flex items-center gap-1 rounded-full px-2 py-1 text-[11px] font-bold",
            passed
              ? "bg-emerald-500/15 text-emerald-600 dark:text-emerald-400"
              : hasAttempt
                ? "bg-amber-500/15 text-amber-600 dark:text-amber-400"
                : inProgress
                  ? "bg-sky-500/15 text-sky-600 dark:text-sky-400"
                  : read
                    ? "bg-emerald-500/15 text-emerald-600 dark:text-emerald-400"
                    : "bg-muted text-muted-foreground",
          )}
        >
          {passed ? (
            <>
              <Check size={11} strokeWidth={2.4} /> ผ่าน {bestScore}%
            </>
          ) : hasAttempt ? (
            <>ยังไม่ผ่าน · {bestScore}%</>
          ) : inProgress ? (
            <>
              <Play size={11} strokeWidth={2.4} /> เรียนค้างไว้
            </>
          ) : read ? (
            <>
              <Check size={11} strokeWidth={2.4} /> อ่านครบ
            </>
          ) : (
            <>ยังไม่เริ่ม</>
          )}
        </span>
        <div className="flex-1" />
        <button
          onClick={(e) => {
            e.stopPropagation();
            go();
          }}
          className={cn(
            "inline-flex items-center gap-1 rounded-full px-3 py-1.5 text-[11px] font-bold text-white hover:opacity-90",
            tone.btn,
          )}
        >
          {inProgress ? "เรียนต่อ" : hasAttempt ? "ทำใหม่" : "เริ่มเรียน"}
        </button>
      </div>
    </div>
  );
}
