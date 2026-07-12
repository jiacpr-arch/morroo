"use client";

import { useState } from "react";
import { usePreCourseStore } from "@/lib/courses/stores/pre-course-store";
import StudentIdentityModal from "@/components/courses/StudentIdentityModal";
import Exam from "./Exam";
import type { AssessmentQuestion } from "@/lib/acls-reader/assessment";
import { User } from "lucide-react";

// Wraps Exam with an identity requirement for the pre-test / post-test
// (lessonId set) — these attempts count toward certification and the
// instructor cohort view, so they need a name attached. Free-practice
// reader tests (lessonId undefined) render Exam directly, no gate.
export default function TrackedExam({
  questions,
  setId,
  passPct,
  lessonId,
}: {
  questions: AssessmentQuestion[];
  setId: string;
  passPct: number;
  lessonId?: string;
}) {
  const activeStudent = usePreCourseStore((s) => s.activeStudent);
  const [showIdentity, setShowIdentity] = useState(false);

  if (lessonId && !activeStudent) {
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

  return (
    <Exam questions={questions} setId={setId} passPct={passPct} lessonId={lessonId} />
  );
}
