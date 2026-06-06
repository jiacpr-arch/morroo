/**
 * Difficulty helpers (client-safe) for School mini-quizzes.
 *
 * Mini-quizzes should ramp gradually — a learner who just read a Part expects
 * the gate quiz to start easy and only get harder deeper into the lesson. These
 * helpers give a single source of truth for (1) ordering quizzes easy→hard and
 * (2) labelling each quiz with its level so the ramp is visible, not a surprise.
 */

import type { SchoolDifficulty } from "@/lib/types-school";

/** Lower rank = easier; used to sort/ramp quizzes from easy to hard. */
export const DIFFICULTY_RANK: Record<SchoolDifficulty, number> = {
  easy: 0,
  medium: 1,
  hard: 2,
};

/** Unlabelled quizzes sit in the middle so they neither lead nor trail. */
const UNKNOWN_RANK = DIFFICULTY_RANK.medium;

export function difficultyRank(d: SchoolDifficulty | null | undefined): number {
  return d && d in DIFFICULTY_RANK ? DIFFICULTY_RANK[d] : UNKNOWN_RANK;
}

const LABELS_TH: Record<SchoolDifficulty, string> = {
  easy: "ง่าย",
  medium: "ปานกลาง",
  hard: "ยาก",
};

export function difficultyLabelTh(d: SchoolDifficulty): string {
  return LABELS_TH[d] ?? d;
}

/** Tailwind badge classes per level (green → amber → rose). */
const BADGE_CLASS: Record<SchoolDifficulty, string> = {
  easy: "bg-green-100 text-green-700",
  medium: "bg-amber-100 text-amber-700",
  hard: "bg-rose-100 text-rose-700",
};

export function difficultyBadgeClass(d: SchoolDifficulty): string {
  return BADGE_CLASS[d] ?? "";
}

/**
 * Stable sort a list easy→hard by each item's difficulty. Stable so any
 * existing order (e.g. a prior shuffle for variety) is preserved within a tier.
 */
export function sortByDifficultyAsc<T>(
  items: T[],
  getDifficulty: (item: T) => SchoolDifficulty | null | undefined
): T[] {
  return items
    .map((item, i) => ({ item, i }))
    .sort((a, b) => {
      const d = difficultyRank(getDifficulty(a.item)) - difficultyRank(getDifficulty(b.item));
      return d !== 0 ? d : a.i - b.i;
    })
    .map(({ item }) => item);
}
