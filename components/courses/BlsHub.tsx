"use client";

// BLS hub — port of acls-emr's BLS PreCourse branch, following the exact
// architecture of components/courses/AclsHub.tsx (class-gate/identity flow,
// Dexie progress loading, lesson state derivation, voucher unlock, deep
// links via ?join=/?voucher=). BLS has no pre-test (unlike ACLS), so
// PreTestCard is dropped and the tool grid swaps chapters/qa-deep/ekg for
// skill-practice/scenario/algorithm/aed/choking.

import { useEffect, useRef, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { GraduationCap, Users, Cloud, CloudOff } from "lucide-react";

import { preCourseLessons } from "@/lib/courses/bls/lessons";
import { POST_TEST_LESSON_ID } from "@/lib/courses/bls/post-test";
import { getCourseMeta, type CourseMode } from "@/lib/courses/config";
import {
  getLessonProgress,
  getAttemptsForStudent,
  type LessonProgressRow,
  type QuizAttemptRow,
} from "@/lib/courses/offline/db";
import { usePreCourseStore } from "@/lib/courses/stores/pre-course-store";
import { useClassStore } from "@/lib/courses/stores/class-store";
import { useVoucherStore } from "@/lib/courses/stores/voucher-store";
import { validateVoucher } from "@/lib/courses/vouchers";
import { track } from "@/lib/analytics";

import LessonCard, { type LessonCardLesson } from "./LessonCard";
import PostTestCard from "./PostTestCard";
import ProgressCard, { type NextLessonRef } from "./ProgressCard";
import StudentIdentityModal from "./StudentIdentityModal";
import ClassGateModal from "./ClassGateModal";
import VoucherCard from "./VoucherCard";
import VoucherModal from "./VoucherModal";
import FeaturedVideo from "./FeaturedVideo";
import { dashCard, text2xs, textOverline, btnGhost, btnSm } from "./course-ui";

import { Card, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";

const COURSE: CourseMode = "bls";

type HubLesson = LessonCardLesson & { title: string };
const lessons = preCourseLessons as unknown as HubLesson[];

const tools = [
  {
    href: "/bls/skill-practice",
    icon: "💗",
    title: "ฝึก CPR",
    desc: "Metronome จังหวะ 100–120/นาที",
  },
  {
    href: "/bls/scenario",
    icon: "🧠",
    title: "เกมลำดับขั้น BLS",
    desc: "8 ด่านตัดสินใจ + ข้อสอบรวม",
  },
  {
    href: "/bls/algorithm",
    icon: "🗺️",
    title: "BLS Algorithm",
    desc: "ผังขั้นตอนการช่วยชีวิต",
  },
  {
    href: "/bls/aed",
    icon: "⚡",
    title: "คู่มือ AED",
    desc: "ตำแหน่ง pads และสถานการณ์พิเศษ",
  },
  {
    href: "/bls/choking",
    icon: "🫁",
    title: "ช่วยเหลือสำลัก",
    desc: "FBAO ผู้ใหญ่ เด็ก ทารก",
  },
];

export default function BlsHub() {
  const router = useRouter();
  const meta = getCourseMeta(COURSE);

  // Stores are persisted in localStorage — gate their values behind `mounted`
  // so the first client render matches the server-rendered HTML.
  const [mounted, setMounted] = useState(false);
  useEffect(() => setMounted(true), []);

  const activeStudentRaw = usePreCourseStore((s) => s.activeStudent);
  const clearActiveStudent = usePreCourseStore((s) => s.clearActiveStudent);
  const currentAttempt = usePreCourseStore((s) => s.currentAttempt);
  const classCodeRaw = useClassStore((s) => s.classCode);
  const classNameRaw = useClassStore((s) => s.className);
  const clearClass = useClassStore((s) => s.clearClass);
  const voucherActiveRaw = useVoucherStore(
    (s) => !!(s.voucher?.lineConfirmed && validateVoucher(s.voucher.code)),
  );
  const redeemVoucher = useVoucherStore((s) => s.redeemVoucher);

  const activeStudent = mounted ? activeStudentRaw : null;
  const classCode = mounted ? classCodeRaw : null;
  const className = mounted ? classNameRaw : null;
  const voucherActive = mounted ? voucherActiveRaw : false;

  const [progress, setProgress] = useState<LessonProgressRow[]>([]);
  const [attempts, setAttempts] = useState<QuizAttemptRow[]>([]);
  const [showIdentity, setShowIdentity] = useState(false);
  const [showClassGate, setShowClassGate] = useState(false);
  const [gateInitialMode, setGateInitialMode] = useState<"home" | "join">("home");
  const [joinParam, setJoinParam] = useState("");
  const [showVoucher, setShowVoucher] = useState(false);
  const [voucherInitialCode, setVoucherInitialCode] = useState("");
  const lessonsRef = useRef<HTMLDivElement | null>(null);

  // ?join=K7M2QX — students arriving from the instructor's QR / shared link
  // land straight on the join form with the code prefilled.
  // ?voucher=BLS2025 — a share-only link for people who already have the
  // code. Valid → redeem silently; invalid → open the modal prefilled so they
  // can see/retype it. Read from window.location on mount (instead of
  // useSearchParams) so the statically prerendered shell stays intact.
  useEffect(() => {
    const params = new URLSearchParams(window.location.search);

    const join = (params.get("join") || "").trim().toUpperCase();
    setJoinParam(join);
    const s = useClassStore.getState();
    if (join && s.classCode !== join) {
      setGateInitialMode("join");
      setShowClassGate(true);
    } else if (!s.classCode && !s.syncDisabled) {
      setGateInitialMode("home");
      setShowClassGate(true);
    }

    const voucherParam = (params.get("voucher") || "").trim().toUpperCase();
    if (voucherParam) {
      const v = validateVoucher(voucherParam);
      if (v) {
        redeemVoucher(v);
        track("voucher_redeemed", { code: v.code, via: "link" });
      } else {
        setVoucherInitialCode(voucherParam);
        setShowVoucher(true);
      }
    }
  }, [redeemVoucher]);

  // Load this student's Dexie progress + attempts.
  useEffect(() => {
    const id = activeStudent?.id;
    if (!id) {
      setProgress([]);
      setAttempts([]);
      return;
    }
    void Promise.all([getLessonProgress(id), getAttemptsForStudent(id)]).then(
      ([p, a]) => {
        setProgress(p);
        setAttempts(a);
      },
    );
  }, [activeStudent?.id, showIdentity]);

  const lessonState = (lessonId: string) => {
    const read = progress.some((p) => p.lessonId === lessonId);
    const lessonAttempts = attempts.filter((a) => a.lessonId === lessonId);
    const best = lessonAttempts.reduce<QuizAttemptRow | null>(
      (b, a) => (a.score > (b?.score ?? -1) ? a : b),
      null,
    );
    const inProgress =
      currentAttempt?.lessonId === lessonId &&
      (currentAttempt.stepIndex ?? 0) > 0 &&
      !best;
    return {
      read,
      bestScore: best?.score ?? null,
      passed: best?.passed ?? false,
      inProgress,
    };
  };

  const lessonsPassed = lessons.filter((l) => lessonState(l.id).passed).length;
  const totalLessons = lessons.length;
  const allLessonsPassed = lessonsPassed === totalLessons && totalLessons > 0;
  const postAttempts = attempts.filter((a) => a.lessonId === POST_TEST_LESSON_ID);
  const postBest = postAttempts.reduce<QuizAttemptRow | null>(
    (b, a) => (a.score > (b?.score ?? -1) ? a : b),
    null,
  );
  const postTestUnlocked = !!activeStudent && (allLessonsPassed || voucherActive);
  const postTestPassed = postBest?.passed ?? false;

  const nextLesson: NextLessonRef | null = (() => {
    const found = lessons.find((l) => !lessonState(l.id).passed);
    if (!found) return null;
    return { id: found.id, shortTitle: shortenLessonTitle(found.title) };
  })();

  const confirmIdentity = () => setShowIdentity(false);
  const closeIdentity = () => setShowIdentity(false);

  // After a class join, immediately ask who the student is (if unknown) so
  // their rows sync under the right roster entry.
  const closeClassGate = () => {
    setShowClassGate(false);
    if (
      useClassStore.getState().classCode &&
      !usePreCourseStore.getState().activeStudent
    ) {
      setShowIdentity(true);
    }
  };

  const classBanner = (
    <div className={`${dashCard} flex items-center gap-3`}>
      {classCode ? (
        <>
          <div className="inline-flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-sky-500/15 text-sky-600 dark:text-sky-400">
            <Cloud size={18} strokeWidth={2.2} />
          </div>
          <div className="min-w-0 flex-1">
            <div className="truncate text-sm font-semibold text-foreground">
              คลาส: {className || "—"}
            </div>
            <div className={`${text2xs} font-mono text-muted-foreground`}>
              รหัสคลาส: {classCode}
            </div>
          </div>
          <button
            onClick={() => {
              clearClass();
              setShowClassGate(true);
            }}
            className={`${btnGhost} ${btnSm}`}
          >
            เปลี่ยนคลาส
          </button>
        </>
      ) : (
        <>
          <div className="inline-flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-muted text-muted-foreground">
            <CloudOff size={18} strokeWidth={2.2} />
          </div>
          <div className="min-w-0 flex-1">
            <div className="text-sm font-semibold text-foreground">โหมด offline</div>
            <div className={`${text2xs} text-muted-foreground`}>
              ข้อมูลเก็บในเครื่องนี้เท่านั้น
            </div>
          </div>
          <button onClick={() => setShowClassGate(true)} className={`${btnGhost} ${btnSm}`}>
            เชื่อมต่อคลาส
          </button>
        </>
      )}
    </div>
  );

  return (
    <div className="mx-auto max-w-5xl px-4 py-12 sm:px-6 lg:px-8">
      <header className="mb-10 text-center">
        <h1 className="text-3xl font-bold sm:text-4xl">{meta.titleTh}</h1>
        <p className="mt-3 text-lg text-muted-foreground">
          บทเรียน · ฝึกทักษะ CPR/AED · เกมตัดสินใจ · Post-test · ใบประกาศนียบัตร
        </p>
      </header>

      {/* ===== Course flow (ported from acls-emr PreCourse, BLS branch) ===== */}
      <div className="mx-auto mb-12 max-w-2xl space-y-5">
        <div className="space-y-2 text-center">
          <div
            className="mx-auto inline-flex h-16 w-16 items-center justify-center rounded-2xl"
            style={{
              background: "linear-gradient(135deg, #0EA5E9 0%, #2563EB 100%)",
              boxShadow: "0 8px 20px rgba(37, 99, 235, 0.28)",
            }}
          >
            <GraduationCap size={28} strokeWidth={2.2} className="text-white" />
          </div>
          <h2 className="text-2xl font-bold text-foreground">บทเรียน BLS</h2>
          <p className="text-xs text-muted-foreground">2 ขั้นตอน: บทเรียน → Post-test</p>
        </div>

        {/* Hero: progress + smart next-step CTA. Identity is shown inside.
            BLS has no pre-test — hasPreTest=false hides the Pre-test step
            pill and swaps the anonymous CTA to a generic "start" label. */}
        <ProgressCard
          course={COURSE}
          activeStudent={activeStudent}
          hasPreTest={false}
          preTestPassed={false}
          preTestAttempted={false}
          lessonsPassed={lessonsPassed}
          totalLessons={totalLessons}
          nextLesson={nextLesson}
          postTestPassed={postTestPassed}
          postTestUnlocked={postTestUnlocked}
          onIdentify={() => setShowIdentity(true)}
          onChangeStudent={() => {
            clearActiveStudent();
            setShowIdentity(true);
          }}
        />

        {classBanner}

        <VoucherCard onOpen={() => setShowVoucher(true)} />

        {/* Step 1 — Lessons */}
        <div className="space-y-2" id="bls-lessons" ref={lessonsRef}>
          <div className="flex items-center justify-between px-1">
            <div className={`${textOverline} flex items-center gap-2`}>
              <StepNumber n={1} />
              บทเรียน · {lessonsPassed}/{totalLessons} ผ่าน
            </div>
            <Link href="/bls/cohort" className={`${btnGhost} ${btnSm}`}>
              <Users size={14} strokeWidth={2.4} /> สำหรับอาจารย์
            </Link>
          </div>
          <div className="space-y-3">
            {lessons.map((l) => {
              const st = lessonState(l.id);
              return <LessonCard key={l.id} lesson={l} course={COURSE} {...st} />;
            })}
          </div>
        </div>

        {/* Step 2 — Post-test */}
        <div className="space-y-2">
          <div className={`${textOverline} flex items-center gap-2 px-1`}>
            <StepNumber n={2} />
            ข้อสอบหลังเรียน
          </div>
          <PostTestCard
            course={COURSE}
            unlocked={postTestUnlocked}
            bestScore={postBest?.score ?? null}
            passed={postTestPassed}
            attemptCount={postAttempts.length}
            lessonCount={totalLessons}
          />
        </div>

        {meta.featuredVideo && <FeaturedVideo video={meta.featuredVideo} />}
      </div>

      {/* ===== BLS tools — skill practice, decision game, references ===== */}
      <h2 className="mb-4 text-sm font-semibold uppercase tracking-wide text-muted-foreground">
        ฝึกทักษะและคู่มืออ้างอิง
      </h2>
      <div className="mb-12 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {tools.map((t) => (
          <Link key={t.href} href={t.href} className="block">
            <Card className="h-full transition-shadow hover:shadow-md hover:ring-brand/30">
              <CardHeader>
                <span className="text-3xl">{t.icon}</span>
                <CardTitle className="text-base">{t.title}</CardTitle>
                <CardDescription>{t.desc}</CardDescription>
              </CardHeader>
            </Card>
          </Link>
        ))}
      </div>

      {/* ===== Modals ===== */}
      <ClassGateModal
        open={showClassGate}
        course={COURSE}
        initialMode={gateInitialMode}
        initialCode={joinParam}
        onClose={closeClassGate}
      />

      <StudentIdentityModal
        open={showIdentity}
        onClose={closeIdentity}
        onConfirm={confirmIdentity}
      />

      <VoucherModal
        open={showVoucher}
        initialCode={voucherInitialCode}
        onClose={() => {
          setShowVoucher(false);
          setVoucherInitialCode("");
        }}
      />
    </div>
  );
}

function StepNumber({ n }: { n: number }) {
  return (
    <span className="inline-flex h-5 w-5 shrink-0 items-center justify-center rounded-full bg-sky-600 text-[11px] font-extrabold text-white">
      {n}
    </span>
  );
}

function shortenLessonTitle(title: string): string {
  if (!title) return "";
  // "บทที่ 1: ภาพรวม BLS …" → "บทที่ 1"
  const m = title.match(/^(บทที่\s*\d+)/);
  if (m) return m[1];
  return title.length > 18 ? title.slice(0, 18) + "…" : title;
}
