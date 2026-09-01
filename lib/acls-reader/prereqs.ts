// Client-side gating for the post-test: it unlocks only after the learner has
// taken the pre-test and passed every pre-course lesson. Progress lives in
// localStorage (no login), so these helpers must run in the browser.

export interface LessonRef {
  id: string;
  passingScore: number;
}

export interface PrereqStatus {
  preTestDone: boolean;
  lessonsPassed: number;
  totalLessons: number;
  unlocked: boolean;
}

export function isPostTestSet(setId: string): boolean {
  return setId.startsWith("posttest");
}

export function readPrereqStatus(
  pretestIds: string[],
  lessons: LessonRef[]
): PrereqStatus {
  const totalLessons = lessons.length;
  if (typeof window === "undefined") {
    return { preTestDone: false, lessonsPassed: 0, totalLessons, unlocked: false };
  }
  const preTestDone = pretestIds.some(
    (id) => window.localStorage.getItem(`acls-reader-exam-${id}`) !== null
  );
  const lessonsPassed = lessons.filter(
    (l) =>
      Number(window.localStorage.getItem(`acls-reader-precourse-${l.id}`) ?? "0") >=
      l.passingScore
  ).length;
  const unlocked = preTestDone && totalLessons > 0 && lessonsPassed >= totalLessons;
  return { preTestDone, lessonsPassed, totalLessons, unlocked };
}
