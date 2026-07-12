import { lessons } from "@/lib/firstaid/content/lessons";

const TOTAL = lessons.length;
const HALF = Math.ceil(TOTAL / 2);

export type BadgeDef = {
  id: string;
  label: string;
  desc: string;
  emoji: string;
  threshold?: number;
  postTestOnly?: boolean;
};

export const BADGE_DEFS: BadgeDef[] = [
  { id: "first_step", label: "ก้าวแรก", desc: "เรียนบทแรกสำเร็จ", emoji: "🌱", threshold: 1 },
  { id: "halfway", label: "ครึ่งทาง", desc: `เรียนครบ ${HALF} บท`, emoji: "⚡", threshold: HALF },
  { id: "all_lessons", label: "เรียนครบ", desc: "เรียนครบทุกบทเรียน", emoji: "🎯", threshold: TOTAL },
  { id: "passed_theory", label: "ผ่านทฤษฎี", desc: "ผ่าน Post-test ภาคทฤษฎี", emoji: "🏆", postTestOnly: true },
];

type BadgeInput = { readLessonIds: Set<string>; postTestDone: boolean };

function countDone(readLessonIds: Set<string>) {
  return lessons.filter((l: { id: string }) => readLessonIds.has(l.id)).length;
}

export function computeBadges({ readLessonIds, postTestDone }: BadgeInput) {
  const done = countDone(readLessonIds);
  return BADGE_DEFS.filter((b) => (b.postTestOnly ? postTestDone : done >= (b.threshold ?? 0)));
}

// Returns the first badge newly unlocked by adding lessonId, or null
export function getNewBadge({
  readLessonIds,
  postTestDone,
  lessonId,
}: BadgeInput & { lessonId: string }) {
  const before = computeBadges({ readLessonIds, postTestDone });
  const next = new Set(readLessonIds);
  next.add(lessonId);
  const after = computeBadges({ readLessonIds: next, postTestDone });
  return after.find((b) => !before.some((pb) => pb.id === b.id)) ?? null;
}
