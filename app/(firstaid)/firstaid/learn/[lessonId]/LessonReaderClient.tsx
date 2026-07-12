"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useState, useEffect, useMemo } from "react";
import { ArrowLeft, ChevronRight, CheckCircle2, Lock } from "lucide-react";
import { lessonsById, lessons } from "@/lib/firstaid/content/lessons";
import LessonStep from "@/components/firstaid/LessonStep";
import { useEnsureLearner } from "@/lib/firstaid/hooks/useLearner";
import { useLearnerStore } from "@/lib/firstaid/stores/learnerStore";
import {
  useProgressStore,
  pushProgress,
} from "@/lib/firstaid/stores/progressStore";
import { useEnsureProgress } from "@/lib/firstaid/hooks/useProgress";
import { useEntitlementStore } from "@/lib/firstaid/stores/entitlementStore";
import { useEnsureEntitlements } from "@/lib/firstaid/hooks/useEntitlements";
import { isChapterUnlocked } from "@/lib/firstaid/config/pricing";
import ChapterUnlockCard from "@/components/firstaid/ChapterUnlockCard";
import {
  fetchLessonMedia,
  mediaRowToStep,
} from "@/lib/firstaid/lessonMediaSteps";
import ProgressBar from "@/components/firstaid/ProgressBar";
import LinePopup from "@/components/firstaid/LinePopup";
import { getNewBadge } from "@/lib/firstaid/badges";
import { encourage } from "@/lib/firstaid/encouragement";
import CertUpsellCard from "@/components/firstaid/CertUpsellCard";
import { track } from "@/lib/firstaid/analytics";

export default function LessonReaderClient({ lessonId }: { lessonId: string }) {
  useEnsureLearner();
  const router = useRouter();
  const learner = useLearnerStore((s) => s.learner);
  const updateLearner = useLearnerStore((s) => s.updateLearner);
  const markReadStore = useProgressStore((s) => s.markRead);
  const readLessonIds = useProgressStore((s) => s.readLessonIds);
  const preTestDone = useProgressStore((s) => s.preTestDone);
  const postTestDone = useProgressStore((s) => s.postTestDone);
  const progressLoaded = useProgressStore((s) => s.loaded);
  useEnsureProgress(learner?.id);
  const unlockedChapters = useEntitlementStore((s) => s.chapters);
  const entitlementsLoaded = useEntitlementStore((s) => s.loaded);
  useEnsureEntitlements();

  const lesson = (lessonsById as Record<string, any>)[lessonId];
  const [prevLessonId, setPrevLessonId] = useState(lessonId);
  const [stepIdx, setStepIdx] = useState(0);
  const [correctCount, setCorrectCount] = useState(0);
  const [quizCount, setQuizCount] = useState(0);
  const [completed, setCompleted] = useState(false);
  const [earnedBadge, setEarnedBadge] = useState<any>(null);
  const [extraMedia, setExtraMedia] = useState<any[]>([]);

  // Reset state when lessonId changes — set-during-render pattern
  if (prevLessonId !== lessonId) {
    setPrevLessonId(lessonId);
    setStepIdx(0);
    setCorrectCount(0);
    setQuizCount(0);
    setCompleted(false);
    setEarnedBadge(null);
  }

  useEffect(() => {
    if (lesson)
      track("lesson_start", {
        lessonId: lesson.id,
        lessonOrder: lesson.order,
        lessonTitle: lesson.title,
      });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [lessonId]);

  // โหลดสื่อที่แอดมินผูกไว้กับบทนี้ (passthrough ใน Phase 1 — คืน [] จนกว่าจะย้ายระบบสื่อ)
  useEffect(() => {
    let cancelled = false;
    fetchLessonMedia(lessonId).then((rows: any[]) => {
      if (!cancelled) setExtraMedia(rows);
    });
    return () => {
      cancelled = true;
    };
  }, [lessonId]);

  const steps = useMemo(() => lesson?.steps || [], [lesson]);

  // จัดกลุ่มสื่อตามขั้น: after_step 1..len = ในขั้นนั้น; 0/ก่อนเริ่ม = หน้าปก; ว่าง/เกิน = ขั้นสุดท้าย
  const mediaByStep = useMemo(() => {
    const len = steps.length;
    const map = new Map<number, any[]>();
    for (const row of extraMedia) {
      let n = row.after_step;
      if (n == null || n > len) n = len;
      else if (n < 0) n = 0;
      if (!map.has(n)) map.set(n, []);
      map.get(n)!.push(row);
    }
    return map;
  }, [steps.length, extraMedia]);

  // ลำดับสไลด์: หน้าปก (ถ้ามีรูป after_step=0) ก่อน แล้วตามด้วยแต่ละขั้นเนื้อหา
  const slides = useMemo(() => {
    const out: any[] = [];
    const cover = mediaByStep.get(0);
    if (cover?.length) out.push({ kind: "cover", media: cover });
    steps.forEach((s: any, i: number) =>
      out.push({ kind: "step", step: s, media: mediaByStep.get(i + 1) }),
    );
    return out;
  }, [steps, mediaByStep]);

  if (!lesson) {
    return (
      <div className="page-container">
        <div className="card">ไม่พบบทเรียน</div>
        <Link href="/learn" className="btn btn-primary btn-block" style={{ marginTop: 12 }}>
          กลับไปหน้าบทเรียน
        </Link>
      </div>
    );
  }

  // กันเข้าบทเรียนตรง ๆ ผ่าน URL ก่อนทำ Pre-test — รอโหลดสถานะก่อนค่อยตัดสิน
  // ยกเว้นบทแรก (order 1) ที่บังคับให้เรียนก่อนเสมอเป็นตัวดึงดูด — ข้าม Pre-test ได้
  if (progressLoaded && !preTestDone && lesson.order !== 1) {
    return (
      <div className="page-container">
        <div className="card" style={{ textAlign: "center", padding: 28 }}>
          <Lock size={44} color="var(--color-text-secondary)" style={{ margin: "0 auto" }} />
          <div className="text-title" style={{ marginTop: 12 }}>ยังเข้าบทเรียนไม่ได้</div>
          <div className="text-body" style={{ marginTop: 8 }}>
            กรุณาทำแบบทดสอบก่อนเรียน (Pre-test) ก่อน จึงจะเริ่มเรียนได้
          </div>
        </div>
        <div style={{ display: "flex", gap: 8, marginTop: 16 }}>
          <Link href="/learn" className="btn btn-secondary" style={{ flex: 1 }}>
            <ArrowLeft size={16} /> รายการบท
          </Link>
          <Link href="/pre-test" className="btn btn-primary" style={{ flex: 1 }}>
            ไปทำ Pre-test <ChevronRight size={16} />
          </Link>
        </div>
      </div>
    );
  }

  // ปลดล็อกด้วยการซื้อ — หมวด 1 ฟรีเสมอ (isChapterUnlocked คืน true ทันที) หมวด 2-4 ต้องมี
  // entitlement ผูกกับ learner_id ถาวร ครอบคลุมทั้ง URL ตรง, list ในหน้า Learn และปุ่ม "บทถัดไป"
  // เพราะทุกทางเข้าวิ่งผ่าน route นี้เหมือนกัน
  if (
    entitlementsLoaded &&
    !isChapterUnlocked(lesson.chapter, unlockedChapters)
  ) {
    return <ChapterUnlockCard chapter={lesson.chapter} />;
  }

  const slide = slides[stepIdx];
  const isLast = stepIdx === slides.length - 1;
  const idx = lesson.order - 1;
  const nextLesson = (lessons as any[])[idx + 1];

  // ความก้าวหน้าทั้งคอร์ส — กี่บทแล้ว จากทั้งหมด (อัปเดตเองหลังเรียนจบบท)
  const totalLessons = (lessons as any[]).length;
  const doneLessons = (lessons as any[]).filter((l) =>
    readLessonIds.has(l.id),
  ).length;

  const finishLesson = () => {
    if (!learner?.id) return;
    const newBadge = getNewBadge({
      readLessonIds,
      postTestDone,
      lessonId: lesson.id,
    });
    // Optimistic store update + fire-and-forget server write
    // (แทน Dexie markLessonRead/saveQuizAttempt + flushSync เดิม)
    markReadStore(lesson.id);
    const finishedAt = new Date().toISOString();
    const quizScore =
      quizCount > 0 ? Math.round((correctCount / quizCount) * 100) : null;
    pushProgress({
      learnerId: learner.id,
      lessonRead: { lessonId: lesson.id, readAt: finishedAt },
      ...(quizCount > 0
        ? {
            quizAttempt: {
              uuid: crypto.randomUUID(),
              lessonId: lesson.id,
              correct: correctCount,
              total: quizCount,
              finishedAt,
            },
          }
        : {}),
    });
    localStorage.setItem("lastStudyDate", new Date().toISOString().slice(0, 10));
    if (newBadge) track("badge_earned", { badgeId: newBadge.id, lessonId: lesson.id });
    setEarnedBadge(newBadge);
    track("lesson_complete", {
      lessonId: lesson.id,
      lessonOrder: lesson.order,
      lessonTitle: lesson.title,
      ...(quizScore !== null
        ? { quizScore, quizCorrect: correctCount, quizTotal: quizCount }
        : {}),
    });
    setCompleted(true);
  };

  const onAnswered = (_id: unknown, correct: boolean) => {
    setQuizCount((c) => c + 1);
    if (correct) setCorrectCount((c) => c + 1);
  };

  const needLoginGate =
    completed &&
    lesson.order === 1 &&
    !learner?.lineAdded &&
    !learner?.lineSkippedAt;
  const confirmLine = () => {
    updateLearner({ lineAdded: true });
    track("line_add", { source: "lesson1_popup" });
    // แจ้ง admin LINE ว่ามีคนสนใจ (fire-and-forget — ไม่บล็อก UX ถ้า notify ล้มเหลว)
    fetch("/api/firstaid/notify/line-add", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ learnerId: learner?.id }),
    }).catch(() => {});
  };
  // Soft gate: กด "ดูภายหลัง" — บันทึกว่าข้าม แล้วปลดล็อกให้เรียนบทอื่นต่อได้
  const skipLine = () => {
    updateLearner({ lineSkippedAt: new Date().toISOString() });
    track("line_skip", { source: "lesson1_popup" });
  };

  const advance = () => {
    if (!isLast) setStepIdx((i) => i + 1);
    else finishLesson();
  };

  if (completed) {
    return (
      <div className="page-container">
        <div className="card" style={{ textAlign: "center", padding: 28 }}>
          <CheckCircle2 size={48} color="#10B981" style={{ margin: "0 auto" }} />
          <div className="text-title" style={{ marginTop: 12 }}>เรียนจบบทแล้ว!</div>
          <div className="text-caption" style={{ marginTop: 4 }}>{lesson.title}</div>
          {quizCount > 0 && (
            <div className="text-body" style={{ marginTop: 12 }}>
              ตอบคำถามถูก {correctCount} / {quizCount}
            </div>
          )}
          <div style={{ marginTop: 16 }}>
            <ProgressBar value={doneLessons} max={totalLessons} />
            <div className="text-caption" style={{ marginTop: 6 }}>
              เรียนจบแล้ว {doneLessons} / {totalLessons} บท
            </div>
            <div className="text-body-strong" style={{ marginTop: 6, color: "var(--color-brand-dark)" }}>
              {encourage(doneLessons, totalLessons)}
            </div>
          </div>
        </div>
        {earnedBadge && (
          <div className="card" style={{ marginTop: 12, textAlign: "center", padding: 20, background: "#FFFBEB", border: "1.5px solid #FDE68A" }}>
            <div style={{ fontSize: 40 }}>{earnedBadge.emoji}</div>
            <div className="text-body-strong" style={{ marginTop: 8 }}>ปลดล็อกแล้ว: {earnedBadge.label}</div>
            <div className="text-caption" style={{ marginTop: 4 }}>{earnedBadge.desc}</div>
          </div>
        )}
        <div style={{ display: "flex", gap: 8, marginTop: 16 }}>
          <Link href="/learn" className="btn btn-secondary" style={{ flex: 1 }}>
            <ArrowLeft size={16} /> รายการบท
          </Link>
          {nextLesson ? (
            <Link href={`/learn/${nextLesson.id}`} className="btn btn-primary" style={{ flex: 1 }}>
              บทถัดไป <ChevronRight size={16} />
            </Link>
          ) : (
            <Link href="/post-test" className="btn btn-primary" style={{ flex: 1 }}>
              ทำ Post-test <ChevronRight size={16} />
            </Link>
          )}
        </div>
        {/* เรียนครบทุกบทแล้ว — ชวนมาอบรมปฏิบัติจริง */}
        {!nextLesson && <CertUpsellCard source="lesson_complete_all" />}
        {needLoginGate && <LinePopup onConfirm={confirmLine} onSkip={skipLine} />}
      </div>
    );
  }

  return (
    <div className="page-container">
      <button
        type="button"
        onClick={() => router.push("/learn")}
        className="btn btn-ghost"
        style={{ paddingLeft: 0 }}
      >
        <ArrowLeft size={16} /> รายการบท
      </button>
      <div style={{ marginTop: 4 }}>
        <div className="text-caption">บทที่ {lesson.order} จาก {totalLessons}</div>
        <div className="text-title">{lesson.title}</div>
      </div>

      {/* ความก้าวหน้าทั้งคอร์ส + คำให้กำลังใจ ให้มีแรงเรียนต่อจนจบ */}
      <div className="card" style={{ marginTop: 12, padding: 12 }}>
        <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 8 }}>
          <span className="text-caption">ความก้าวหน้าทั้งคอร์ส</span>
          <span className="text-caption">เรียนจบแล้ว {doneLessons} / {totalLessons} บท</span>
        </div>
        <ProgressBar value={doneLessons} max={totalLessons} />
        <div className="text-caption" style={{ marginTop: 8, color: "var(--color-brand-dark)", fontWeight: 600 }}>
          {encourage(doneLessons, totalLessons)}
        </div>
      </div>

      <div style={{ marginTop: 12, marginBottom: 12 }}>
        <ProgressBar value={stepIdx + 1} max={slides.length} />
        <div className="text-caption" style={{ marginTop: 4 }}>
          {slide?.kind === "cover" ? "หน้าปก" : `ขั้นที่ ${stepIdx + 1} / ${slides.length}`}
        </div>
      </div>

      {slide?.kind === "cover" ? (
        // สไลด์หน้าปก — แสดงเฉพาะรูป/วิดีโอ ก่อนเข้าเนื้อหา
        slide.media.map((row: any) => (
          <div key={row.id} style={{ marginBottom: 12 }}>
            <LessonStep step={mediaRowToStep(row)} />
          </div>
        ))
      ) : (
        <>
          <LessonStep step={slide?.step} onQuizAnswered={onAnswered} />
          {/* รูป/วิดีโอที่ผูกกับขั้นนี้ — แสดงใต้เนื้อหาในสไลด์เดียวกัน */}
          {slide?.media?.map((row: any) => (
            <div key={row.id} style={{ marginTop: 12 }}>
              <LessonStep step={mediaRowToStep(row)} />
            </div>
          ))}
        </>
      )}

      <button
        type="button"
        className="btn btn-primary btn-block"
        style={{ marginTop: 14 }}
        onClick={advance}
      >
        {isLast ? "จบบทเรียน" : "ต่อไป"} <ChevronRight size={16} />
      </button>
    </div>
  );
}
