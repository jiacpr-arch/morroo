"use client";

// Client-side gate for the BLS post-test: BLS has no pre-test (unlike ACLS's
// PrereqGuard, which also checks a pre-test), so this only needs to check
// (1) a student is identified and (2) every pre-course lesson has been
// passed — modeled on how app/acls/certification/page.tsx computes
// `preCourseDone` from Dexie attempts, plus the identity-gate pattern from
// components/acls-reader/TrackedExam.tsx.

import { useEffect, useState } from "react";
import Link from "next/link";
import { User, BookOpen } from "lucide-react";
import { usePreCourseStore } from "@/lib/courses/stores/pre-course-store";
import { getAttemptsForStudent, type QuizAttemptRow } from "@/lib/courses/offline/db";
import { preCourseLessons } from "@/lib/courses/bls/lessons";
import StudentIdentityModal from "@/components/courses/StudentIdentityModal";

export default function BlsPostTestGate({ children }: { children: React.ReactNode }) {
  const activeStudent = usePreCourseStore((s) => s.activeStudent);
  const [showIdentity, setShowIdentity] = useState(false);
  const [loading, setLoading] = useState(true);
  const [lessonsPassed, setLessonsPassed] = useState(0);

  useEffect(() => {
    let cancelled = false;
    if (!activeStudent) {
      setLoading(false);
      setLessonsPassed(0);
      return;
    }
    setLoading(true);
    void getAttemptsForStudent(activeStudent.id).then((attempts) => {
      if (cancelled) return;
      const passedCount = preCourseLessons.filter((l) => {
        const best = attempts
          .filter((a) => a.lessonId === l.id)
          .reduce<QuizAttemptRow | null>((b, a) => (a.score > (b?.score ?? -1) ? a : b), null);
        return best?.passed ?? false;
      }).length;
      setLessonsPassed(passedCount);
      setLoading(false);
    });
    return () => {
      cancelled = true;
    };
  }, [activeStudent?.id]);

  if (!activeStudent) {
    return (
      <div className="rounded-xl border border-border bg-muted/40 p-6 text-center">
        <User className="mx-auto mb-2 h-8 w-8 text-muted-foreground" />
        <p className="font-semibold">ระบุตัวผู้เรียนก่อนเริ่มทำข้อสอบชุดนี้</p>
        <p className="mt-1 text-sm text-muted-foreground">
          เพื่อบันทึกคะแนนสำหรับใบประกาศนียบัตรและครูผู้สอน
        </p>
        <button
          onClick={() => setShowIdentity(true)}
          className="mt-4 rounded-lg bg-brand px-5 py-2 text-sm font-medium text-white hover:bg-brand/90"
        >
          ระบุตัวตน
        </button>
        <StudentIdentityModal
          open={showIdentity}
          onClose={() => setShowIdentity(false)}
          onConfirm={() => setShowIdentity(false)}
        />
      </div>
    );
  }

  if (loading) {
    return (
      <p className="rounded-lg border border-border bg-muted/40 p-4 text-center text-muted-foreground">
        กำลังตรวจสอบความคืบหน้า...
      </p>
    );
  }

  const totalLessons = preCourseLessons.length;
  if (lessonsPassed < totalLessons) {
    return (
      <div className="rounded-xl border border-border bg-muted/40 p-6 text-center">
        <BookOpen className="mx-auto mb-2 h-8 w-8 text-muted-foreground" />
        <p className="font-semibold">ยังเรียนไม่ครบทุกบท</p>
        <p className="mt-1 text-sm text-muted-foreground">
          ผ่านแล้ว {lessonsPassed}/{totalLessons} บท — ต้องผ่านครบทุกบทก่อนทำ Post-test
        </p>
        <Link
          href="/bls/learn"
          className="mt-4 inline-block rounded-lg bg-brand px-5 py-2 text-sm font-medium text-white hover:bg-brand/90"
        >
          ไปที่บทเรียน
        </Link>
      </div>
    );
  }

  return <>{children}</>;
}
