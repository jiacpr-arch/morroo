/**
 * Spaced Repetition Scheduler — SM-2 lite.
 *
 * Given the user's last interval/ease and the outcome of the current review,
 * compute the next review state. We support outcomes from both flashcards
 * (again / hard / good / easy) and quizzes (correct / wrong).
 *
 * Ease factor is clamped to [1.3, 3.0]. Intervals are in whole days.
 */

import type { SchoolProgressOutcome } from "../types-school";

export interface SrsState {
  ease_factor: number;
  interval_days: number;
}

export interface NextSrsState extends SrsState {
  due_at: Date;
}

const MIN_EF = 1.3;
const MAX_EF = 3.0;

export function nextSrsState(
  current: Partial<SrsState> | null | undefined,
  outcome: SchoolProgressOutcome,
  now: Date = new Date()
): NextSrsState {
  let ef = clamp(current?.ease_factor ?? 2.5, MIN_EF, MAX_EF);
  const prev = Math.max(1, current?.interval_days ?? 1);
  let interval: number;

  switch (outcome) {
    case "again":
    case "wrong":
      interval = 1;
      ef = clamp(ef - 0.2, MIN_EF, MAX_EF);
      break;
    case "hard":
      interval = Math.max(1, Math.ceil(prev * 1.2));
      ef = clamp(ef - 0.15, MIN_EF, MAX_EF);
      break;
    case "good":
    case "correct":
      interval = Math.max(1, Math.ceil(prev * ef));
      break;
    case "easy":
      interval = Math.max(1, Math.ceil(prev * ef * 1.3));
      ef = clamp(ef + 0.15, MIN_EF, MAX_EF);
      break;
  }

  const due_at = new Date(now);
  due_at.setDate(due_at.getDate() + interval);
  return { ease_factor: ef, interval_days: interval, due_at };
}

function clamp(n: number, lo: number, hi: number) {
  return Math.max(lo, Math.min(hi, n));
}
