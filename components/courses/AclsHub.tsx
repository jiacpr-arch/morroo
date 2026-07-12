"use client";

// ACLS hub — port of acls-emr's src/pages/PreCourse.jsx (ACLS branch) merged
// with morroo's existing reader landing (chapter cards + tool links). All the
// store/Dexie logic lives here; the server page shell fetches chapters and
// assessment sets and passes them down.

import { useEffect, useRef, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { GraduationCap, Users, Cloud, CloudOff } from "lucide-react";

import { preCourseLessons } from "@/lib/acls-reader/precourse";
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
import {
  PRE_TEST_LESSON_ID,
  POST_TEST_LESSON_ID,
} from "@/lib/courses/assessment-ids";
import { track } from "@/lib/analytics";

import LessonCard, { type LessonCardLesson } from "./LessonCard";
import PreTestCard from "./PreTestCard";
import PostTestCard from "./PostTestCard";
import ProgressCard, { type NextLessonRef } from "./ProgressCard";
import StudentIdentityModal from "./StudentIdentityModal";
import ClassGateModal from "./ClassGateModal";
import VoucherCard from "./VoucherCard";
import VoucherModal from "./VoucherModal";
import FeaturedVideo from "./FeaturedVideo";
import { dashCard, text2xs, textOverline, btnGhost, btnSm } from "./course-ui";

import ReaderProgress from "@/components/acls-reader/ReaderProgress";
import LandingPageTracker from "@/components/LandingPageTracker";
import { Card, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";

const COURSE: CourseMode = "acls";

type HubLesson = LessonCardLesson & { title: string };
const lessons = preCourseLessons as HubLesson[];

export interface HubChapter {
  id: string;
  title: string;
  icon: string | null;
  sectionCount: number;
}

export interface HubTestSet {
  id: string;
  title: string;
}

interface AclsHubProps {
  chapters: HubChapter[];
  testSets: HubTestSet[];
  /** Server-rendered <SectionUpdatesBadge> (async server component). */
  updatesBadge?: React.ReactNode;
}

const tools = [
  {
    href: "/acls/learn",
    icon: "🎓",
    title: "บทเรียน Pre-course",
    desc: "13 บทแบบอ่าน-ควิซ พร้อมเฉลย",
  },
  {
    href: "/acls/test",
    icon: "📝",
    title: "แบบทดสอบ",
    desc: "Pre-test / Post-test พร้อมเฉลยทุกข้อ",
  },
  {
    href: "/acls/ekg",
    icon: "💓",
    title: "ฝึกอ่าน EKG",
    desc: "ดูคลื่นแล้วเลือกจังหวะที่ถูกต้อง",
  },
  {
    href: "/acls/qa-deep",
    icon: "💬",
    title: "Q&A เชิงลึก",
    desc: "คำถาม-คำตอบประกอบ infographic",
  },
];

export default function AclsHub({ chapters, testSets, updatesBadge }: AclsHubProps) {
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
  // When the identity modal is opened from the "start Pre-test" CTA, drop the
  // student straight into the exam once they've entered their name — removes
  // the extra tap that used to sit between registering and actually starting.
  const [identityNext, setIdentityNext] = useState<"pretest" | null>(null);
  const [showClassGate, setShowClassGate] = useState(false);
  const [gateInitialMode, setGateInitialMode] = useState<"home" | "join">("home");
  const [joinParam, setJoinParam] = useState("");
  const [showVoucher, setShowVoucher] = useState(false);
  const [voucherInitialCode, setVoucherInitialCode] = useState("");
  const lessonsRef = useRef<HTMLDivElement | null>(null);

  // ?join=K7M2QX — students arriving from the instructor's QR / shared link
  // land straight on the join form with the code prefilled.
  // ?voucher=ACLS2025 — a share-only link for people who already have the
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

  // ACLS pre-test best scores
  const preTestAttempts = attempts.filter((a) => a.lessonId === PRE_TEST_LESSON_ID);
  const preTestBest = preTestAttempts.reduce<QuizAttemptRow | null>(
    (b, a) => (a.score > (b?.score ?? -1) ? a : b),
    null,
  );
  const preTestPassed = preTestBest?.passed ?? false;
  const preTestAttempted = preTestAttempts.length > 0;

  const nextLesson: NextLessonRef | null = (() => {
    const found = lessons.find((l) => !lessonState(l.id).passed);
    if (!found) return null;
    return { id: found.id, shortTitle: shortenLessonTitle(found.title) };
  })();

  const startPretest = () => {
    setIdentityNext("pretest");
    setShowIdentity(true);
  };
  const confirmIdentity = () => {
    setShowIdentity(false);
    const next = identityNext;
    setIdentityNext(null);
    if (next === "pretest") router.push(`${meta.basePath}/pre-test`);
  };
  const closeIdentity = () => {
    setIdentityNext(null);
    setShowIdentity(false);
  };

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
      <LandingPageTracker event="acls_reader_view" />
      <header className="mb-10 text-center">
        <h1 className="text-3xl font-bold sm:text-4xl">คู่มือทบทวน ACLS</h1>
        <p className="mt-3 text-lg text-muted-foreground">
          อ่านเป็นบท · เรียน pre-course · ทำแบบทดสอบ · ฝึกอ่าน EKG
        </p>
        {updatesBadge && <div className="mt-3 flex justify-center">{updatesBadge}</div>}
      </header>

      {/* ===== Course flow (ported from acls-emr PreCourse, ACLS branch) ===== */}
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
          <h2 className="text-2xl font-bold text-foreground">บทเรียน ACLS</h2>
          <p className="text-xs text-muted-foreground">
            3 ขั้นตอน: Pre-test → บทเรียน → Post-test
          </p>
        </div>

        {/* Hero: progress + smart next-step CTA. Identity is shown inside. */}
        <ProgressCard
          course={COURSE}
          activeStudent={activeStudent}
          preTestPassed={preTestPassed}
          preTestAttempted={preTestAttempted}
          lessonsPassed={lessonsPassed}
          totalLessons={totalLessons}
          nextLesson={nextLesson}
          postTestPassed={postTestPassed}
          postTestUnlocked={postTestUnlocked}
          onIdentify={() => setShowIdentity(true)}
          onStartPretest={startPretest}
          onChangeStudent={() => {
            clearActiveStudent();
            setShowIdentity(true);
          }}
        />

        {classBanner}

        <VoucherCard onOpen={() => setShowVoucher(true)} />

        {/* Step 1 — Pre-test */}
        {activeStudent && (
          <div className="space-y-2">
            <div className={`${textOverline} flex items-center gap-2 px-1`}>
              <StepNumber n={1} />
              ข้อสอบก่อนเรียน
            </div>
            <PreTestCard
              course={COURSE}
              bestScore={preTestBest?.score ?? null}
              passed={preTestPassed}
              attemptCount={preTestAttempts.length}
            />
          </div>
        )}

        {/* Step 2 — Lessons */}
        <div className="space-y-2" id="acls-lessons" ref={lessonsRef}>
          <div className="flex items-center justify-between px-1">
            <div className={`${textOverline} flex items-center gap-2`}>
              <StepNumber n={2} />
              บทเรียน · {lessonsPassed}/{totalLessons} ผ่าน
            </div>
            <Link href="/acls/cohort" className={`${btnGhost} ${btnSm}`}>
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

        {/* Step 3 — Post-test */}
        <div className="space-y-2">
          <div className={`${textOverline} flex items-center gap-2 px-1`}>
            <StepNumber n={3} />
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

      {/* ===== Existing reader tools (kept from the previous /acls page) ===== */}
      <ReaderProgress
        lessons={lessons.map((l) => ({ id: l.id, passingScore: l.passingScore }))}
        testSets={testSets}
      />

      <div className="mb-12 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
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

      <h2 className="mb-4 text-sm font-semibold uppercase tracking-wide text-muted-foreground">
        อ่านเป็นบท
      </h2>
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {chapters.map((c) => (
          <Link key={c.id} href={`/acls/chapter/${c.id}`} className="block">
            <Card className="h-full transition-shadow hover:shadow-md hover:ring-brand/30">
              <CardHeader>
                <span className="text-3xl">{c.icon ?? "📘"}</span>
                <CardTitle className="text-base">{c.title}</CardTitle>
                <CardDescription>{c.sectionCount} หัวข้อ</CardDescription>
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
  // "บทที่ 1: ภาพรวม ACLS …" → "บทที่ 1"
  const m = title.match(/^(บทที่\s*\d+)/);
  if (m) return m[1];
  return title.length > 18 ? title.slice(0, 18) + "…" : title;
}
