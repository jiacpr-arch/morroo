// ตรรกะ "ผ่าน" ของคลิปวิดีโอ ใช้ร่วมกันระหว่างหน้าไลบรารี/รายละเอียด และเงื่อนไขใบประกาศนียบัตร
// นิยาม: ดูจบ (มีใน lessonProgress) AND (ไม่มีควิซ หรือ ผ่านควิซแล้ว)
// Ported from acls-emr's src/utils/videoProgress.js, typed against morroo's
// VideoLesson + offline Dexie row types.

import type { VideoLesson } from "@/lib/courses/video-lessons";
import type { LessonProgressRow, QuizAttemptRow } from "@/lib/courses/offline/db";
import { videoLessonKey } from "@/lib/courses/video-topics";

export function clipWatched(clip: VideoLesson, progressLessonIds: Set<string>): boolean {
  return progressLessonIds.has(videoLessonKey(clip.id));
}

export function clipQuizPassed(clip: VideoLesson, passedLessonIds: Set<string>): boolean {
  if (!clip.quiz || clip.quiz.length === 0) return true; // ไม่มีควิซ = ผ่านอัตโนมัติ
  return passedLessonIds.has(videoLessonKey(clip.id));
}

export function clipDone(
  clip: VideoLesson,
  progressLessonIds: Set<string>,
  passedLessonIds: Set<string>,
): boolean {
  return clipWatched(clip, progressLessonIds) && clipQuizPassed(clip, passedLessonIds);
}

// สร้าง Set จาก progress/attempts ของ Dexie (getLessonProgress / getAttemptsForStudent)
export function buildProgressSets(
  progress: Pick<LessonProgressRow, "lessonId">[] | null | undefined,
  attempts: Pick<QuizAttemptRow, "lessonId" | "passed">[] | null | undefined,
): { progressLessonIds: Set<string>; passedLessonIds: Set<string> } {
  const progressLessonIds = new Set((progress || []).map((p) => p.lessonId));
  const passedLessonIds = new Set(
    (attempts || []).filter((a) => a.passed).map((a) => a.lessonId),
  );
  return { progressLessonIds, passedLessonIds };
}

export interface VideoCompletion {
  total: number;
  done: number;
  allDone: boolean;
}

// สรุปความคืบหน้าวิดีโอสำหรับใบประกาศนียบัตร — นับเฉพาะคลิป required
export function computeVideoCompletion(
  lessons: VideoLesson[] | null | undefined,
  progress: Pick<LessonProgressRow, "lessonId">[] | null | undefined,
  attempts: Pick<QuizAttemptRow, "lessonId" | "passed">[] | null | undefined,
): VideoCompletion {
  const required = (lessons || []).filter((l) => l.required);
  const { progressLessonIds, passedLessonIds } = buildProgressSets(progress, attempts);
  const done = required.filter((c) => clipDone(c, progressLessonIds, passedLessonIds)).length;
  const total = required.length;
  return { total, done, allDone: total > 0 && done === total };
}
