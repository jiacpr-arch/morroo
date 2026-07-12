"use client";

import { Fragment } from "react";
import { useRouter } from "next/navigation";
import { Play, Award, ClipboardCheck, User, UserCheck, RefreshCw } from "lucide-react";
import type { CourseMode } from "@/lib/courses/config";
import { getCourseMeta } from "@/lib/courses/config";
import type { ActiveStudent } from "@/lib/courses/stores/pre-course-store";
import { cn } from "@/lib/utils";
import { text2xs, btnBase, btnXl, btnBlock } from "./course-ui";

export interface NextLessonRef {
  id: string;
  shortTitle: string;
}

interface ProgressCardProps {
  course: CourseMode;
  activeStudent: ActiveStudent | null;
  preTestPassed: boolean;
  preTestAttempted: boolean;
  lessonsPassed: number;
  totalLessons: number;
  nextLesson: NextLessonRef | null;
  postTestPassed: boolean;
  postTestUnlocked: boolean;
  onIdentify?: () => void;
  onStartPretest?: () => void;
  onChangeStudent?: () => void;
  /**
   * Set false for courses with no pre-test (BLS) — hides the "Pre-test"
   * step pill, adjusts the progress-ring math, and swaps the anonymous CTA
   * copy from "เริ่มทำ Pre-test" to a generic "เริ่มเรียนเลย". Defaults to
   * true so ACLS (which always passes preTestPassed/preTestAttempted from
   * real pre-test state) is unaffected.
   */
  hasPreTest?: boolean;
}

// At-a-glance progress + next-step CTA for the pre-course flow (ported from
// acls-emr's ACLSProgressCard, made parametric on `course`).
// Decides what the student should do next:
// identify → pre-test → first lesson → continue → post-test → certificate.
export default function ProgressCard({
  course,
  activeStudent,
  preTestPassed,
  preTestAttempted,
  lessonsPassed,
  totalLessons,
  nextLesson,
  postTestPassed,
  postTestUnlocked,
  onIdentify,
  onStartPretest,
  onChangeStudent,
  hasPreTest = true,
}: ProgressCardProps) {
  const router = useRouter();
  const meta = getCourseMeta(course);
  const base = meta.basePath;

  // Weighted percent: pre-test counts as 1 step (when the course has one),
  // every lesson counts as 1, post-test counts as 1.
  const totalUnits = totalLessons + (hasPreTest ? 2 : 1);
  const doneUnits =
    (hasPreTest ? (preTestPassed ? 1 : 0) : 0) + lessonsPassed + (postTestPassed ? 1 : 0);
  const percent = totalUnits === 0 ? 0 : Math.round((doneUnits / totalUnits) * 100);

  interface Cta {
    label: string;
    icon: typeof Play;
    tone: "primary" | "success" | "warning";
    onClick?: () => void;
  }

  let cta: Cta;
  if (!activeStudent) {
    // Action-first framing: the funnel's biggest drop was here, where the CTA
    // used to read "identify to start". Lead with the exam; identity is a quick
    // name field that opens on click and then drops straight into the Pre-test
    // (courses with no pre-test lead into the lesson list instead).
    cta = hasPreTest
      ? {
          label: "เริ่มทำ Pre-test",
          icon: ClipboardCheck,
          tone: "primary",
          onClick: onStartPretest || onIdentify,
        }
      : {
          label: "เริ่มเรียนเลย",
          icon: Play,
          tone: "primary",
          onClick: onIdentify,
        };
  } else if (postTestPassed) {
    cta = {
      label: "ดูใบประกาศนียบัตร",
      icon: Award,
      tone: "success",
      onClick: () => router.push(`${base}/certification`),
    };
  } else if (postTestUnlocked) {
    cta = {
      label: "เริ่มทำ Post-test",
      icon: Award,
      tone: "warning",
      onClick: () => router.push(`${base}/post-test`),
    };
  } else if (hasPreTest && !preTestAttempted) {
    cta = {
      label: "เริ่มทำ Pre-test",
      icon: ClipboardCheck,
      tone: "primary",
      onClick: () => router.push(`${base}/pre-test`),
    };
  } else if (nextLesson) {
    cta = {
      label: lessonsPassed === 0 ? "เริ่มบทเรียนแรก" : `เรียนต่อ — ${nextLesson.shortTitle}`,
      icon: Play,
      tone: "primary",
      onClick: () => router.push(`${base}/learn/${nextLesson.id}`),
    };
  } else {
    cta = {
      label: "เริ่มเรียน",
      icon: Play,
      tone: "primary",
      onClick: () => router.push(base),
    };
  }

  const CtaIcon = cta.icon;
  const ctaClass =
    cta.tone === "success"
      ? "bg-emerald-600 text-white hover:bg-emerald-700"
      : cta.tone === "warning"
        ? "bg-amber-500 text-white hover:bg-amber-600"
        : "bg-blue-600 text-white hover:bg-blue-700";

  const statusLine = (() => {
    if (postTestPassed) {
      return (
        <span className="font-bold text-emerald-600 dark:text-emerald-400">
          เรียนจบครบหลักสูตรแล้ว ✓
        </span>
      );
    }
    if (postTestUnlocked) {
      return (
        <span className="font-bold text-amber-600 dark:text-amber-400">พร้อมสอบ Post-test</span>
      );
    }
    if (hasPreTest && !preTestAttempted) {
      return <>เริ่มจาก Pre-test เพื่อเช็คพื้นฐาน</>;
    }
    const remaining = totalLessons - lessonsPassed;
    if (remaining > 0) {
      return <>เหลืออีก {remaining} บทก่อนปลดล็อก Post-test</>;
    }
    return <>เรียนครบทุกบทแล้ว เตรียม Post-test</>;
  })();

  return (
    <>
      {/* Active-student status — its own card so identity reads as a
          separate concern from progress */}
      <div className="flex items-center gap-3 rounded-2xl border border-border bg-card p-5 shadow-md">
        {activeStudent ? (
          <>
            <div className="inline-flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-sky-500/15 text-sky-600 dark:text-sky-400">
              <UserCheck size={15} strokeWidth={2.4} />
            </div>
            <div className="min-w-0 flex-1">
              <div className="truncate text-[15px] font-bold text-foreground">
                {activeStudent.name}
              </div>
              <div className={`${text2xs} font-mono text-muted-foreground`}>
                {activeStudent.studentId
                  ? `รหัส ${activeStudent.studentId}`
                  : activeStudent.phone}
              </div>
            </div>
            <button
              onClick={onChangeStudent}
              className="inline-flex items-center gap-1 rounded-full bg-muted px-2.5 py-1.5 text-[11px] font-bold text-foreground/80"
            >
              <RefreshCw size={11} strokeWidth={2.4} /> เปลี่ยน
            </button>
          </>
        ) : (
          <>
            <div className="inline-flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-muted text-muted-foreground">
              <User size={15} strokeWidth={2.4} />
            </div>
            <div className="min-w-0 flex-1">
              <div className="text-[15px] font-bold text-foreground">
                ยังไม่ได้ระบุตัวผู้เรียน
              </div>
              <div className={`${text2xs} text-muted-foreground`}>
                ใส่ชื่อก่อนเริ่ม เพื่อบันทึกผล
              </div>
            </div>
            <button
              onClick={onIdentify}
              className="rounded-full bg-sky-600 px-3 py-1.5 text-[11px] font-bold text-white hover:bg-sky-700"
            >
              ระบุตัวตน
            </button>
          </>
        )}
      </div>

      {/* Progress + primary CTA */}
      <div className="rounded-2xl border border-border bg-card p-5 shadow-md">
        <div className="flex items-center gap-4">
          <ProgressRing percent={percent} />
          <div className="min-w-0 flex-1">
            <div className={`${text2xs} font-bold uppercase tracking-wider text-muted-foreground`}>
              ความคืบหน้า {meta.shortName}
            </div>
            <div className="text-xl font-extrabold leading-tight text-foreground tabular-nums">
              {lessonsPassed}
              <span className="text-sm font-bold text-muted-foreground">/{totalLessons}</span>
              <span className="ml-1.5 text-[13px] font-semibold text-foreground/80">บทผ่าน</span>
            </div>
            <div className={`${text2xs} mt-0.5 text-muted-foreground`}>{statusLine}</div>
          </div>
        </div>

        {/* Step pill row — bird's-eye view of the course journey */}
        <StepRow
          hasPreTest={hasPreTest}
          preTestPassed={preTestPassed}
          preTestAttempted={preTestAttempted}
          lessonsPassed={lessonsPassed}
          totalLessons={totalLessons}
          postTestPassed={postTestPassed}
        />

        <button
          onClick={cta.onClick}
          className={cn(btnBase, btnXl, btnBlock, "mt-4", ctaClass)}
          style={{ boxShadow: "0 6px 16px rgba(37, 99, 235, 0.28)" }}
        >
          <CtaIcon size={20} strokeWidth={2.4} />
          {cta.label}
        </button>
      </div>
    </>
  );
}

function StepRow({
  hasPreTest,
  preTestPassed,
  preTestAttempted,
  lessonsPassed,
  totalLessons,
  postTestPassed,
}: {
  hasPreTest: boolean;
  preTestPassed: boolean;
  preTestAttempted: boolean;
  lessonsPassed: number;
  totalLessons: number;
  postTestPassed: boolean;
}) {
  const lessonsState =
    lessonsPassed === totalLessons && totalLessons > 0
      ? "done"
      : (hasPreTest ? preTestAttempted : true) || lessonsPassed > 0
        ? "active"
        : "todo";

  const steps = [
    ...(hasPreTest
      ? [
          {
            n: 1,
            label: "Pre-test",
            state: preTestPassed ? "done" : preTestAttempted ? "active" : "todo",
          },
        ]
      : []),
    {
      n: hasPreTest ? 2 : 1,
      label: `บทเรียน ${lessonsPassed}/${totalLessons}`,
      state: lessonsState,
    },
    {
      n: hasPreTest ? 3 : 2,
      label: "Post-test",
      state: postTestPassed
        ? "done"
        : lessonsPassed === totalLessons && totalLessons > 0
          ? "active"
          : "todo",
    },
  ];

  return (
    <div className="mt-4 flex items-center gap-1.5">
      {steps.map((s, i) => (
        <Fragment key={s.n}>
          <div
            className={cn(
              "flex flex-1 items-center gap-1.5 rounded-full px-2 py-1.5 text-[11px] font-bold",
              s.state === "done"
                ? "bg-emerald-500/15 text-emerald-600 dark:text-emerald-400"
                : s.state === "active"
                  ? "bg-sky-500/15 text-sky-600 dark:text-sky-400"
                  : "bg-muted text-muted-foreground",
            )}
          >
            <span
              className={cn(
                "inline-flex h-4 w-4 shrink-0 items-center justify-center rounded-full text-[11px] font-extrabold",
                s.state === "done"
                  ? "bg-emerald-500 text-white"
                  : s.state === "active"
                    ? "bg-sky-500 text-white"
                    : "bg-card text-muted-foreground",
              )}
            >
              {s.n}
            </span>
            <span className="truncate">{s.label}</span>
          </div>
          {i < steps.length - 1 && (
            <span className="shrink-0 text-[11px] text-muted-foreground">›</span>
          )}
        </Fragment>
      ))}
    </div>
  );
}

function ProgressRing({ percent }: { percent: number }) {
  const size = 64;
  const stroke = 6;
  const r = (size - stroke) / 2;
  const c = 2 * Math.PI * r;
  const offset = c - (Math.min(100, Math.max(0, percent)) / 100) * c;

  return (
    <div className="relative shrink-0" style={{ width: size, height: size }}>
      <svg width={size} height={size} className="-rotate-90">
        <circle
          cx={size / 2}
          cy={size / 2}
          r={r}
          fill="none"
          stroke="var(--color-muted)"
          strokeWidth={stroke}
        />
        <circle
          cx={size / 2}
          cy={size / 2}
          r={r}
          fill="none"
          stroke="url(#course-ring-grad)"
          strokeWidth={stroke}
          strokeDasharray={c}
          strokeDashoffset={offset}
          strokeLinecap="round"
          style={{ transition: "stroke-dashoffset 0.4s ease" }}
        />
        <defs>
          <linearGradient id="course-ring-grad" x1="0" y1="0" x2="1" y2="1">
            <stop offset="0%" stopColor="#0EA5E9" />
            <stop offset="100%" stopColor="#2563EB" />
          </linearGradient>
        </defs>
      </svg>
      <div className="absolute inset-0 flex items-center justify-center">
        <span className="text-sm font-extrabold text-sky-600 tabular-nums dark:text-sky-400">
          {percent}%
        </span>
      </div>
    </div>
  );
}
