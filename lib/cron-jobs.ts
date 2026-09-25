/**
 * Registry of every Vercel cron in vercel.json — the job name each route logs
 * under in `cron_runs` (see lib/cron-runs.ts) and how often it should run.
 *
 * Kept in sync with vercel.json by lib/cron-jobs.test.ts: adding a cron there
 * without adding it here (and wrapping its route in withCronRun) fails CI.
 *
 * Pure module (no server imports) so client pages can use it too.
 */

export interface CronJobDef {
  /** Name stored in cron_runs.job. */
  job: string;
  /** Route path as listed in vercel.json. */
  path: string;
  /** Cron expression as listed in vercel.json (UTC). */
  schedule: string;
}

export const CRON_JOBS: readonly CronJobDef[] = [
  { job: "billing-reconcile", path: "/api/billing/reconcile", schedule: "*/15 * * * *" },
  { job: "email-weekly-digest", path: "/api/email/weekly-digest", schedule: "0 1 * * 1" },
  { job: "lead-followup", path: "/api/cron/lead-followup", schedule: "0 2 * * *" },
  { job: "exam-watch", path: "/api/cron/exam-watch", schedule: "30 0 * * *" },
  { job: "signup-drip", path: "/api/cron/signup-drip", schedule: "45 2 * * *" },
  { job: "autopost-ig", path: "/api/cron/autopost-ig", schedule: "0 13 * * *" },
  { job: "autopost-ig-story", path: "/api/cron/autopost-ig-story", schedule: "0 12 * * *" },
  { job: "autopost-ig-carousel", path: "/api/cron/autopost-ig-carousel", schedule: "0 2 * * 1,3,5" },
  { job: "autopost-scheduled", path: "/api/cron/autopost-scheduled", schedule: "*/15 * * * *" },
  { job: "ig-insights", path: "/api/cron/ig-insights", schedule: "0 4 * * *" },
  { job: "admin-digest", path: "/api/cron/admin-digest", schedule: "0 1 * * *" },
  { job: "streak-nudge", path: "/api/cron/streak-nudge", schedule: "0 12 * * *" },
  { job: "mcq-review-reminder", path: "/api/cron/mcq-review-reminder", schedule: "30 1 * * *" },
  { job: "ads-autofix", path: "/api/cron/ads-autofix", schedule: "0 22 * * *" },
  { job: "ads-autofix-suggest", path: "/api/cron/ads-autofix-suggest", schedule: "0 23 * * *" },
  { job: "ads-postmerge-watch", path: "/api/cron/ads-postmerge-watch", schedule: "30 21 * * *" },
  { job: "school-streak-reminder", path: "/api/cron/school-streak-reminder", schedule: "0 13 * * *" },
  { job: "school-review-reminder", path: "/api/cron/school-review-reminder", schedule: "0 11 * * *" },
  { job: "school-enrich", path: "/api/cron/school-enrich", schedule: "0 18 * * *" },
  { job: "board-gen", path: "/api/cron/board-gen", schedule: "* * * * *" },
  { job: "line-weekly-blog-digest", path: "/api/cron/line-weekly-blog-digest", schedule: "0 5 * * 3" },
];

// ─── Schedule → expected interval ──────────────────────────────────────────

function parseField(field: string, min: number, max: number): Set<number> {
  const out = new Set<number>();
  for (const part of field.split(",")) {
    const [rangePart, stepPart] = part.split("/");
    const step = stepPart ? Number(stepPart) : 1;
    let lo = min;
    let hi = max;
    if (rangePart !== "*") {
      const [a, b] = rangePart.split("-");
      lo = Number(a);
      hi = b != null ? Number(b) : stepPart ? max : lo;
    }
    if (![lo, hi, step].every(Number.isFinite) || step < 1) {
      throw new Error(`Unsupported cron field "${field}"`);
    }
    for (let v = lo; v <= hi; v += step) out.add(v);
  }
  return out;
}

const WEEK_MINUTES = 7 * 24 * 60;

/**
 * Longest gap (minutes) between consecutive firings of a cron expression.
 * Supports minute/hour/day-of-week fields (`*`, `*\/n`, lists, ranges);
 * day-of-month and month must be `*` — true for every schedule we use.
 */
export function maxIntervalMinutes(schedule: string): number {
  const fields = schedule.trim().split(/\s+/);
  if (fields.length !== 5) throw new Error(`Bad cron expression "${schedule}"`);
  const [minF, hourF, domF, monF, dowF] = fields;
  if (domF !== "*" || monF !== "*") {
    throw new Error(`Unsupported cron expression "${schedule}" (day-of-month/month must be *)`);
  }
  const minutes = parseField(minF, 0, 59);
  const hours = parseField(hourF, 0, 23);
  const dows = new Set([...parseField(dowF, 0, 7)].map((d) => d % 7));

  // Walk one week minute by minute (week starts Sunday 00:00 = dow 0).
  const fires: number[] = [];
  for (let t = 0; t < WEEK_MINUTES; t++) {
    const dow = Math.floor(t / 1440);
    const hour = Math.floor((t % 1440) / 60);
    const minute = t % 60;
    if (dows.has(dow) && hours.has(hour) && minutes.has(minute)) fires.push(t);
  }
  if (fires.length === 0) throw new Error(`Cron expression never fires "${schedule}"`);
  let maxGap = fires[0] + WEEK_MINUTES - fires[fires.length - 1];
  for (let i = 1; i < fires.length; i++) {
    maxGap = Math.max(maxGap, fires[i] - fires[i - 1]);
  }
  return maxGap;
}

/**
 * How long after its last start a job counts as stale: the longest scheduled
 * gap plus slack for Vercel's scheduling jitter and a run that was slow —
 * 25% of the interval, at least 10 minutes.
 */
export function staleAfterMinutes(schedule: string): number {
  const interval = maxIntervalMinutes(schedule);
  return interval + Math.max(10, Math.round(interval * 0.25));
}

export function formatInterval(minutes: number): string {
  if (minutes < 60) return `${minutes} นาที`;
  if (minutes < 1440) return `${Math.round(minutes / 60)} ชม.`;
  return `${Math.round(minutes / 1440)} วัน`;
}
