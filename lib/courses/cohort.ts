import { supabase } from "@/lib/acls-reader/supabase";
import { getClassContext } from "@/lib/courses/stores/class-store";
import type { CourseMode } from "@/lib/courses/config";

// Thin wrappers around the cohort Postgres RPCs (SECURITY DEFINER, bearer
// class/instructor code). All return { data, error } — callers handle errors
// so the sync engine can retry / record failures.

type RpcResult<T> = { data: T; error?: undefined } | { data?: undefined; error: Error };

export interface ClassInfo {
  classId: string;
  className: string;
  courseMode: CourseMode;
}

export async function rpcVerifyClassCode(code: string): Promise<RpcResult<ClassInfo>> {
  const { data, error } = await supabase.rpc("verify_class_code", { p_code: code });
  if (error) return { error };
  const row = Array.isArray(data) ? data[0] : data;
  return {
    data: {
      classId: row.class_id,
      className: row.class_name,
      courseMode: row.course_mode,
    },
  };
}

export async function rpcCreateClass({
  name,
  courseMode,
}: {
  name: string;
  courseMode: CourseMode;
}): Promise<RpcResult<{ classId: string; code: string; instructorCode: string }>> {
  const { data, error } = await supabase.rpc("create_class_v2", {
    p_name: name,
    p_course_mode: courseMode,
  });
  if (error) return { error };
  const row = Array.isArray(data) ? data[0] : data;
  return {
    data: {
      classId: row.class_id,
      code: row.code,
      instructorCode: row.instructor_code,
    },
  };
}

// Verify an instructor code (or a legacy class code). Returns the student
// join code too, so an instructor can reconnect — and recover a lost join
// code — from just the instructor code.
export async function rpcVerifyInstructorCode(
  code: string,
): Promise<RpcResult<ClassInfo & { classCode: string; instructorCode: string | null }>> {
  const { data, error } = await supabase.rpc("verify_instructor_code", { p_code: code });
  if (error) return { error };
  const row = Array.isArray(data) ? data[0] : data;
  return {
    data: {
      classId: row.class_id,
      className: row.class_name,
      courseMode: row.course_mode,
      classCode: row.class_code,
      instructorCode: row.instructor_code,
    },
  };
}

export async function rpcJoinClass({
  code,
  studentUuid,
  studentId,
  name,
  phone,
}: {
  code: string;
  studentUuid: string;
  studentId: string;
  name: string;
  phone?: string | null;
}): Promise<RpcResult<ClassInfo & { studentPk: string }>> {
  const { data, error } = await supabase.rpc("join_class", {
    p_code: code,
    p_student_uuid: studentUuid,
    p_student_id: studentId,
    p_name: name,
    p_phone: phone ?? null,
  });
  if (error) return { error };
  const row = Array.isArray(data) ? data[0] : data;
  return {
    data: {
      classId: row.class_id,
      studentPk: row.student_pk,
      className: row.class_name,
      courseMode: row.course_mode,
    },
  };
}

// Read-only restore: pulls a student's lesson progress + quiz attempts back
// from the cloud so a device with no local record (new browser, cleared
// storage, different phone) can catch up instead of starting over. Same
// bearer model as join_class — the class join code + the student's own id.
export interface CloudStudentProgress {
  student: {
    id: string;
    studentId: string;
    name: string;
    phone: string | null;
    createdAt: string;
  } | null;
  lessonProgress?: { lessonId: string; readAt: string }[];
  quizAttempts?: {
    uuid: string;
    lessonId: string;
    score: number;
    totalQuestions: number;
    correctCount: number;
    answers: unknown[];
    startedAt: string | null;
    finishedAt: string;
    passed: boolean;
    attemptNumber: number;
  }[];
}

export async function rpcGetStudentProgress({
  code,
  studentId,
}: {
  code: string;
  studentId: string;
}): Promise<RpcResult<CloudStudentProgress>> {
  const { data, error } = await supabase.rpc("get_student_progress", {
    p_code: code,
    p_student_id: studentId,
  });
  if (error) return { error };
  return { data: data || { student: null } };
}

export async function rpcUpsertLessonProgress({
  studentPk,
  lessonId,
  readAt,
}: {
  studentPk: string;
  lessonId: string;
  readAt: string;
}): Promise<RpcResult<true>> {
  const { classCode } = getClassContext();
  if (!classCode) return { error: new Error("no_class") };
  const { error } = await supabase.rpc("upsert_lesson_progress", {
    p_code: classCode,
    p_student_pk: studentPk,
    p_lesson_id: lessonId,
    p_read_at: readAt,
  });
  return error ? { error } : { data: true };
}

export async function rpcSubmitQuizAttempt({
  attemptUuid,
  studentPk,
  lessonId,
  payload,
}: {
  attemptUuid: string;
  studentPk: string;
  lessonId: string;
  payload: Record<string, unknown>;
}): Promise<RpcResult<true>> {
  const { classCode } = getClassContext();
  if (!classCode) return { error: new Error("no_class") };
  const { error } = await supabase.rpc("submit_quiz_attempt", {
    p_code: classCode,
    p_attempt_uuid: attemptUuid,
    p_student_pk: studentPk,
    p_lesson_id: lessonId,
    p_payload: payload,
  });
  return error ? { error } : { data: true };
}

// Instructor-level RPCs use the instructor code when the class has one;
// legacy classes fall back to the shared class code (old bearer behaviour).
function instructorAccessCode(): string | null {
  const { classCode, instructorCode } = getClassContext();
  return instructorCode || classCode;
}

export interface CohortSummaryLesson {
  read: boolean;
  attemptCount: number;
  bestScore: number | null;
  passed: boolean;
  lastAttemptAt: string | null;
}

export interface CohortSummaryRow {
  student: {
    id: string;
    studentId: string;
    name: string;
    phone: string | null;
    createdAt: string;
  };
  lessons: Record<string, CohortSummaryLesson>;
}

export async function rpcGetCohortSummary(
  lessonIds: string[],
): Promise<RpcResult<CohortSummaryRow[]>> {
  const code = instructorAccessCode();
  if (!code) return { error: new Error("no_class") };
  const { data, error } = await supabase.rpc("get_cohort_summary", {
    p_code: code,
    p_lesson_ids: lessonIds,
  });
  return error ? { error } : { data: data || [] };
}

export async function rpcDeleteCohortStudent(studentPk: string): Promise<RpcResult<true>> {
  const code = instructorAccessCode();
  if (!code) return { error: new Error("no_class") };
  const { error } = await supabase.rpc("delete_cohort_student", {
    p_code: code,
    p_student_pk: studentPk,
  });
  return error ? { error } : { data: true };
}
