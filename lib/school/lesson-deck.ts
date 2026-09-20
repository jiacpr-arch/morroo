/**
 * Pure state/decision logic for the "mini class" card-deck lesson reader
 * (`components/school/LessonReader.tsx`, `layout="deck"`). Kept out of the
 * component so it's unit-testable — the project's vitest config only picks up
 * `**\/*.test.ts`, not component tests.
 *
 * One deck section == one lesson Part (`lib/school/lesson-parts.ts`). The
 * reader shows exactly one `DeckSection` at a time; these helpers decide what
 * "next" means, when it's allowed, and what's left for the Final Retrieval
 * quiz once the deck is finished.
 */

import type { InlineQuiz } from "./lesson-parts";

export interface DeckSection {
  index: number;
  body: string;
  /** Inline gate quiz if authored, else a legacy topic-pool quiz, else null. */
  quiz: InlineQuiz | null;
  isLast: boolean;
}

/**
 * Build the deck from a lesson's parts + their inline gate quizzes. Sections
 * without an inline quiz fall back to `poolFallback[i]` (the legacy topic-pool
 * quiz for un-migrated lessons — same fallback `LessonReader` always used).
 */
export function buildDeck(
  parts: string[],
  gateQuizzes: (InlineQuiz | null)[],
  poolFallback: (InlineQuiz | null)[] = []
): DeckSection[] {
  return parts.map((body, i) => ({
    index: i,
    body,
    quiz: gateQuizzes[i] ?? poolFallback[i] ?? null,
    isLast: i === parts.length - 1,
  }));
}

/**
 * Whether the reader may advance past `section`. A section with no quiz never
 * blocks. In non-gating contexts (read mode: the question is optional) nothing
 * blocks. Otherwise — mixed mode with a quiz — any pick unlocks Next; the
 * answer doesn't need to be correct (unchanged from the pre-deck reader).
 */
export function canAdvance(
  quiz: InlineQuiz | null,
  picked: string | null,
  opts: { gating: boolean }
): boolean {
  if (!quiz || !opts.gating) return true;
  return picked !== null;
}

export function nextIndex(i: number, total: number): number {
  if (total <= 0) return 0;
  return Math.min(i + 1, total - 1);
}

export function prevIndex(i: number): number {
  return Math.max(i - 1, 0);
}

export function isLastIndex(i: number, total: number): boolean {
  return total > 0 && i >= total - 1;
}

/** 1-based "section i of total" progress as a percentage, for a progress bar/dots fill. */
export function progressPct(i: number, total: number): number {
  if (total <= 0) return 0;
  return Math.round(((i + 1) / total) * 100);
}

/**
 * Final Retrieval pool: whatever is left in the topic-wide quiz pool after
 * `gatesUsed` of its front were consumed as gate fallbacks (mirrors the
 * pre-deck reader's `miniQuizzes.slice(totalGates)`). Empty once gates cover
 * or exceed the pool — `Array.slice` already returns `[]` past the end, this
 * just names the operation so it's testable and self-documenting at the call
 * site.
 */
export function finalRetrievalPool<T>(pool: T[], gatesUsed: number): T[] {
  return pool.slice(Math.max(gatesUsed, 0));
}
