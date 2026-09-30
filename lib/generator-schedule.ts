/**
 * When each content-generator GitHub workflow should run.
 *
 * GitHub's own `schedule:` triggers stopped firing for this repo in Aug 2026
 * (manual workflow_dispatch still works), so Vercel cron calls
 * /api/cron/dispatch-generators at each slot below and that route dispatches
 * the due workflows. Times are UTC and match the old workflow crons.
 *
 * Pure module — unit-tested in lib/generator-schedule.test.ts.
 */

export interface GeneratorSlot {
  /** Workflow file name under .github/workflows. */
  workflow: string;
  /** UTC "HH:MM"; always on :00 or :30. */
  time: string;
  /** Days of week (0 = Sun) — omit for daily. */
  days?: number[];
}

export const GENERATOR_SLOTS: readonly GeneratorSlot[] = [
  { workflow: "generate-blog.yml", time: "05:00" }, // 12:00 BKK
  { workflow: "generate-mcq.yml", time: "19:00" }, // 02:00 BKK
  { workflow: "generate-board.yml", time: "19:30" },
  { workflow: "generate-board-oral.yml", time: "20:00" },
  { workflow: "generate-meq.yml", time: "20:00", days: [0, 3] },
  { workflow: "generate-meq-games.yml", time: "20:30", days: [0, 3] },
  { workflow: "generate-longcase.yml", time: "21:00", days: [6] },
];

/** Vercel cron expression covering every slot above (kept in sync by test). */
export const DISPATCH_CRON = "0,30 5,19-21 * * *";

/**
 * Workflows due at the half-hour slot containing `now`. A cron that fires a
 * few minutes late still lands in its own slot (minute 0-29 → :00, 30-59 → :30).
 */
export function dueWorkflows(now: Date): string[] {
  const hh = String(now.getUTCHours()).padStart(2, "0");
  const mm = now.getUTCMinutes() < 30 ? "00" : "30";
  const time = `${hh}:${mm}`;
  const day = now.getUTCDay();
  return GENERATOR_SLOTS.filter(
    (s) => s.time === time && (!s.days || s.days.includes(day))
  ).map((s) => s.workflow);
}
