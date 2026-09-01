/**
 * Streak helpers — pure date math used by both server queries and client
 * components. Streak updates happen client-side after each session.
 */

/** Format a Date as YYYY-MM-DD in local timezone. */
export function toDateKey(d: Date): string {
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, "0");
  const day = String(d.getDate()).padStart(2, "0");
  return `${y}-${m}-${day}`;
}

/** Days between two YYYY-MM-DD strings (b − a). Negative if b < a. */
export function daysBetween(a: string, b: string): number {
  const da = new Date(a + "T00:00:00");
  const db = new Date(b + "T00:00:00");
  return Math.round((db.getTime() - da.getTime()) / (24 * 60 * 60 * 1000));
}

/**
 * Given the last active date and current streak counters, return the next
 * counters after activity today. If consecutive day, streak++. If gap > 1 day,
 * streak resets to 1.
 */
export function applyStreak(
  state: { current_streak: number; longest_streak: number; last_active_date: string | null },
  today: Date = new Date()
): { current_streak: number; longest_streak: number; last_active_date: string } {
  const todayKey = toDateKey(today);
  if (!state.last_active_date) {
    return { current_streak: 1, longest_streak: Math.max(1, state.longest_streak), last_active_date: todayKey };
  }
  const gap = daysBetween(state.last_active_date, todayKey);
  if (gap === 0) {
    return { ...state, last_active_date: todayKey };
  }
  const next = gap === 1 ? state.current_streak + 1 : 1;
  return {
    current_streak: next,
    longest_streak: Math.max(next, state.longest_streak),
    last_active_date: todayKey,
  };
}
