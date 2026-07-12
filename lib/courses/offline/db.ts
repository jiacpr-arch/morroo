// Local-first storage for the ACLS/BLS pre-course (ported from acls-emr's
// src/db/database.js, teaching stores only — the EMR case recorder stayed
// behind). Students work on phones with flaky classroom connectivity, so
// reads/quiz attempts land in IndexedDB first and a one-way sync engine
// flushes them to Supabase (see ./sync-engine.ts).
//
// Client-only: import from "use client" components/hooks.

import Dexie, { type Table } from "dexie";
import { v4 as uuidv4 } from "uuid";
import type { CohortSummaryRow } from "@/lib/courses/cohort";

export interface LocalStudent {
  /** Local uuid; remapped to the server's student_pk after first sync. */
  id: string;
  studentId: string;
  name: string;
  phone?: string | null;
  createdAt: string;
  syncedAt?: string | null;
}

export interface LessonProgressRow {
  autoId?: number;
  studentId: string;
  lessonId: string;
  readAt: string;
  syncedAt?: string | null;
}

export interface QuizAttemptRow {
  autoId?: number;
  /** Stable uuid so cloud inserts are idempotent across re-flushes. */
  uuid: string;
  studentId: string;
  lessonId: string;
  score: number;
  totalQuestions: number;
  correctCount: number;
  answers: unknown[];
  startedAt: string | null;
  finishedAt: string;
  passed: boolean;
  attemptNumber: number;
  syncedAt?: string | null;
}

export interface SyncFailureRow {
  autoId?: number;
  table: string;
  refId: string | number;
  attempts: number;
  lastError: string;
  nextRetryAt: string;
}

class CoursesDb extends Dexie {
  students!: Table<LocalStudent, string>;
  lessonProgress!: Table<LessonProgressRow, number>;
  quizAttempts!: Table<QuizAttemptRow, number>;
  syncFailures!: Table<SyncFailureRow, number>;

  constructor() {
    super("MORROO_COURSES");
    this.version(1).stores({
      students: "id, studentId, name, createdAt, syncedAt",
      lessonProgress: "++autoId, [studentId+lessonId], readAt, syncedAt",
      quizAttempts:
        "++autoId, uuid, studentId, lessonId, finishedAt, score, passed, syncedAt",
      syncFailures: "++autoId, table, refId, attempts, lastError, nextRetryAt",
    });
  }
}

export const db = new CoursesDb();

// ===== students =====

export async function upsertStudent(student: LocalStudent): Promise<LocalStudent> {
  await db.students.put(student);
  return student;
}

export async function findStudentByStudentId(studentId: string) {
  return db.students.where("studentId").equals(studentId).first();
}

export async function getStudentById(id: string) {
  return db.students.get(id);
}

export async function getAllStudents() {
  return db.students.orderBy("createdAt").reverse().toArray();
}

export async function deleteStudent(id: string) {
  await Promise.all([
    db.students.delete(id),
    db.lessonProgress.where("studentId").equals(id).delete(),
    db.quizAttempts.where("studentId").equals(id).delete(),
  ]);
}

// ===== lesson read progress =====

export async function markLessonRead(studentId: string, lessonId: string) {
  const existing = await db.lessonProgress
    .where("[studentId+lessonId]")
    .equals([studentId, lessonId])
    .first();
  if (existing) return existing.autoId;
  return db.lessonProgress.add({
    studentId,
    lessonId,
    readAt: new Date().toISOString(),
  });
}

export async function getLessonProgress(studentId: string | null | undefined) {
  if (!studentId) return [];
  return db.lessonProgress.where("studentId").equals(studentId).toArray();
}

export async function hasReadLesson(studentId: string | null | undefined, lessonId: string) {
  if (!studentId) return false;
  const row = await db.lessonProgress
    .where("[studentId+lessonId]")
    .equals([studentId, lessonId])
    .first();
  return !!row;
}

// ===== quiz attempts =====

export async function saveQuizAttempt(
  attempt: Omit<QuizAttemptRow, "autoId" | "uuid"> & { uuid?: string },
) {
  const withUuid: QuizAttemptRow = { uuid: uuidv4(), ...attempt };
  return db.quizAttempts.add(withUuid);
}

export async function getAttemptsForStudent(studentId: string | null | undefined) {
  if (!studentId) return [];
  return db.quizAttempts.where("studentId").equals(studentId).toArray();
}

export async function getAttemptById(autoId: number | string) {
  return db.quizAttempts.get(Number(autoId));
}

export async function getBestAttempt(
  studentId: string | null | undefined,
  lessonId: string,
) {
  if (!studentId) return null;
  const rows = await db.quizAttempts.where("studentId").equals(studentId).toArray();
  const forLesson = rows.filter((r) => r.lessonId === lessonId);
  if (!forLesson.length) return null;
  return forLesson.reduce<QuizAttemptRow | null>(
    (best, r) => (r.score > (best?.score ?? -1) ? r : best),
    null,
  );
}

export async function getAttemptCount(
  studentId: string | null | undefined,
  lessonId: string,
) {
  if (!studentId) return 0;
  const rows = await db.quizAttempts.where("studentId").equals(studentId).toArray();
  return rows.filter((r) => r.lessonId === lessonId).length;
}

// ===== cloud restore =====
// Hydrates local IndexedDB from a get_student_progress RPC response — used
// when a student re-registers on a device with no local record for them
// (new browser, cleared storage, different phone). Rows are marked
// already-synced so the sync engine doesn't try to re-push them.

export interface CloudProgress {
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

export async function hydrateStudentProgress(
  studentId: string,
  { lessonProgress = [], quizAttempts = [] }: CloudProgress = {},
) {
  const now = new Date().toISOString();
  for (const row of lessonProgress) {
    const dup = await db.lessonProgress
      .where("[studentId+lessonId]")
      .equals([studentId, row.lessonId])
      .first();
    if (dup) continue;
    await db.lessonProgress.add({
      studentId,
      lessonId: row.lessonId,
      readAt: row.readAt,
      syncedAt: now,
    });
  }
  for (const row of quizAttempts) {
    if (!row.uuid) continue;
    const dup = await db.quizAttempts.where("uuid").equals(row.uuid).first();
    if (dup) continue;
    await db.quizAttempts.add({ ...row, studentId, syncedAt: now });
  }
}

// ===== instructor cohort summary =====
// Local-only fallback for the get_cohort_summary RPC (lib/courses/cohort.ts)
// — used on /acls/cohort and /bls/cohort when no class is connected, or the
// cloud call fails, so the instructor still sees every student recorded on
// this device. Ported from acls-emr's src/db/database.js getCohortSummary.

export async function getCohortSummary(lessonIds: string[]): Promise<CohortSummaryRow[]> {
  const [students, allProgress, allAttempts] = await Promise.all([
    db.students.orderBy("createdAt").toArray(),
    db.lessonProgress.toArray(),
    db.quizAttempts.toArray(),
  ]);
  return students.map((s) => {
    const lessons: CohortSummaryRow["lessons"] = {};
    for (const lid of lessonIds) {
      const read = allProgress.some((p) => p.studentId === s.id && p.lessonId === lid);
      const attempts = allAttempts.filter((a) => a.studentId === s.id && a.lessonId === lid);
      const best = attempts.reduce<QuizAttemptRow | null>(
        (b, a) => (a.score > (b?.score ?? -1) ? a : b),
        null,
      );
      lessons[lid] = {
        read,
        attemptCount: attempts.length,
        bestScore: best?.score ?? null,
        passed: best?.passed ?? false,
        lastAttemptAt: attempts.length
          ? attempts.reduce((m, a) => (a.finishedAt > m ? a.finishedAt : m), "")
          : null,
      };
    }
    return {
      student: {
        id: s.id,
        studentId: s.studentId,
        name: s.name,
        phone: s.phone ?? null,
        createdAt: s.createdAt,
      },
      lessons,
    };
  });
}
