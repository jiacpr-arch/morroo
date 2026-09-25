/**
 * Cron observability — records every cron invocation in `cron_runs`
 * (supabase/migrations/20260925_cron_runs.sql) and alerts the admin on LINE
 * when one fails.
 *
 * Usage in a route (keeps the existing handler untouched):
 *
 *   async function handleGet(request: Request) { ...existing body... }
 *   export const GET = withCronRun("streak-nudge", handleGet, { authorize: isAuthorized });
 *
 * Design:
 *  - Unauthorized calls are NOT runs. When `authorize` is given and fails the
 *    wrapper answers 401 itself and logs nothing, so bots probing
 *    /api/cron/* don't pollute the log or trigger failure alerts.
 *  - Logging never breaks the cron: every DB/LINE call is wrapped, errors are
 *    console.error'd and swallowed, and each is capped by a short timeout so
 *    a slow Supabase can't eat the function budget.
 *  - Status: 2xx → 'ok'; any other status or a thrown error → 'error'. The
 *    original response is returned / the original error rethrown.
 *  - Timeouts: a function killed by Vercel never reaches the finish update,
 *    so its row stays 'running'. The next start of the same job sweeps such
 *    rows (older than RUN_ABANDONED_AFTER_MS) to 'error' and alerts; readers
 *    (digest, admin page) also treat them as timeouts.
 *  - Alerts are throttled per job (ALERT_THROTTLE_MS) via app_settings, so a
 *    job failing every minute (board-gen) pings the admin at most once per
 *    window.
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendLineMessage } from "@/lib/line";
import { CRON_JOBS, staleAfterMinutes, type CronJobDef } from "@/lib/cron-jobs";

export type CronRunStatus = "running" | "ok" | "error";

export interface CronRunRow {
  id: number;
  job: string;
  started_at: string;
  finished_at: string | null;
  duration_ms: number | null;
  status: CronRunStatus;
  http_status: number | null;
  error: string | null;
}

/** Longest maxDuration of any cron is 300s; anything 'running' past this was killed. */
export const RUN_ABANDONED_AFTER_MS = 15 * 60_000;
export const ALERT_THROTTLE_MS = 6 * 60 * 60_000;
const LOG_TIMEOUT_MS = 3_000;
const MAX_META_BODY_CHARS = 2_000;
const MAX_ERROR_CHARS = 1_000;

const TIMEOUT_ERROR = "timeout: ไม่มีการบันทึกจบงาน (น่าจะเกิน maxDuration)";

type AnyClient = ReturnType<typeof createAdminClient>;

function withTimeout<T>(p: PromiseLike<T>, label: string): Promise<T> {
  return new Promise<T>((resolve, reject) => {
    const timer = setTimeout(
      () => reject(new Error(`${label} timed out after ${LOG_TIMEOUT_MS}ms`)),
      LOG_TIMEOUT_MS
    );
    Promise.resolve(p).then(
      (v) => {
        clearTimeout(timer);
        resolve(v);
      },
      (e) => {
        clearTimeout(timer);
        reject(e);
      }
    );
  });
}

function errorMessage(err: unknown): string {
  const msg = err instanceof Error ? err.message : String(err);
  return msg.slice(0, MAX_ERROR_CHARS);
}

// ─── Recording ───────────────────────────────────────────────────────────────

async function recordStart(supabase: AnyClient, job: string, startedAt: Date): Promise<number | null> {
  try {
    const { data, error } = await withTimeout(
      supabase
        .from("cron_runs")
        .insert({ job, started_at: startedAt.toISOString(), status: "running" })
        .select("id")
        .single(),
      "cron_runs insert"
    );
    if (error) throw error;
    return (data as { id: number } | null)?.id ?? null;
  } catch (err) {
    console.error(`[cron-runs] ${job}: failed to record start:`, err);
    return null;
  }
}

/** Mark earlier runs of this job that never finished (killed by a timeout) as errors. */
async function sweepAbandoned(supabase: AnyClient, job: string, now: Date): Promise<void> {
  try {
    const cutoff = new Date(now.getTime() - RUN_ABANDONED_AFTER_MS).toISOString();
    const { data, error } = await withTimeout(
      supabase
        .from("cron_runs")
        .update({ status: "error", error: TIMEOUT_ERROR })
        .eq("job", job)
        .eq("status", "running")
        .lt("started_at", cutoff)
        .select("id, started_at"),
      "cron_runs sweep"
    );
    if (error) throw error;
    const rows = (data as { id: number; started_at: string }[] | null) ?? [];
    if (rows.length > 0) {
      await alertCronFailure(supabase, job, `${TIMEOUT_ERROR} (รอบที่เริ่ม ${rows[0].started_at})`);
    }
  } catch (err) {
    console.error(`[cron-runs] ${job}: abandoned-run sweep failed:`, err);
  }
}

async function recordFinish(
  supabase: AnyClient,
  job: string,
  runId: number | null,
  startedAt: Date,
  result: { status: "ok" | "error"; httpStatus: number | null; error: string | null; meta: unknown }
): Promise<void> {
  const finishedAt = new Date();
  const row = {
    finished_at: finishedAt.toISOString(),
    duration_ms: finishedAt.getTime() - startedAt.getTime(),
    status: result.status,
    http_status: result.httpStatus,
    error: result.error,
    meta: result.meta ?? null,
  };
  try {
    const query =
      runId != null
        ? supabase.from("cron_runs").update(row).eq("id", runId)
        : // Start insert failed — still try to leave one complete row behind.
          supabase.from("cron_runs").insert({ job, started_at: startedAt.toISOString(), ...row });
    const { error } = await withTimeout(query, "cron_runs finish");
    if (error) throw error;
  } catch (err) {
    console.error(`[cron-runs] ${job}: failed to record finish:`, err);
  }
}

/** Small JSON bodies are kept as run meta (cron summaries); big/non-JSON ones are skipped. */
async function readResponseMeta(response: Response): Promise<{ meta: unknown; bodyError: string | null }> {
  try {
    const type = response.headers.get("content-type") ?? "";
    if (!type.includes("json")) return { meta: null, bodyError: null };
    const text = await response.clone().text();
    if (text.length > MAX_META_BODY_CHARS) return { meta: { truncated: true, bytes: text.length }, bodyError: null };
    const parsed = JSON.parse(text) as unknown;
    const bodyError =
      parsed && typeof parsed === "object" && typeof (parsed as { error?: unknown }).error === "string"
        ? ((parsed as { error: string }).error).slice(0, MAX_ERROR_CHARS)
        : null;
    return { meta: parsed, bodyError };
  } catch {
    return { meta: null, bodyError: null };
  }
}

// ─── Alerts ──────────────────────────────────────────────────────────────────

function alertKey(job: string): string {
  return `cron_alert_sent_at:${job}`;
}

/**
 * Push a LINE text to the admin that `job` failed — at most once per
 * ALERT_THROTTLE_MS per job. Never throws.
 */
export async function alertCronFailure(supabase: AnyClient, job: string, detail: string): Promise<void> {
  try {
    const adminLineId = process.env.ADMIN_LINE_USER_ID;
    if (!adminLineId) return;

    const { data } = await withTimeout(
      supabase.from("app_settings").select("value").eq("key", alertKey(job)).maybeSingle(),
      "cron alert throttle read"
    );
    const last = (data as { value?: string } | null)?.value;
    if (last && Date.now() - new Date(last).getTime() < ALERT_THROTTLE_MS) return;

    const nowIso = new Date().toISOString();
    await withTimeout(
      supabase.from("app_settings").upsert({ key: alertKey(job), value: nowIso, updated_at: nowIso }),
      "cron alert throttle write"
    );

    const siteUrl = (process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com").trim();
    const text = [
      `🚨 Cron ล้มเหลว: ${job}`,
      detail.slice(0, 500),
      "",
      `ดูสถานะทุกงาน: ${siteUrl}/admin/crons`,
      `(แจ้งเตือนงานนี้ไม่เกิน 1 ครั้งทุก ${ALERT_THROTTLE_MS / 3_600_000} ชม.)`,
    ].join("\n");
    await withTimeout(sendLineMessage(adminLineId, [{ type: "text", text }]), "cron alert LINE push");
  } catch (err) {
    console.error(`[cron-runs] ${job}: failure alert failed:`, err);
  }
}

// ─── Wrapper ─────────────────────────────────────────────────────────────────

export interface WithCronRunOptions<A extends unknown[]> {
  /**
   * The route's own auth check. When it fails the wrapper returns 401 without
   * logging a run. The wrapped handler may keep its own check (harmless).
   */
  authorize?: (...args: A) => boolean;
}

export function withCronRun<A extends unknown[]>(
  job: string,
  handler: (...args: A) => Promise<Response> | Response,
  options: WithCronRunOptions<A> = {}
): (...args: A) => Promise<Response> {
  return async (...args: A): Promise<Response> => {
    if (options.authorize && !options.authorize(...args)) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const startedAt = new Date();
    let supabase: AnyClient | null = null;
    let runId: number | null = null;
    try {
      supabase = createAdminClient();
      runId = await recordStart(supabase, job, startedAt);
      await sweepAbandoned(supabase, job, startedAt);
    } catch (err) {
      console.error(`[cron-runs] ${job}: logging setup failed:`, err);
    }

    let response: Response;
    try {
      response = await handler(...args);
    } catch (err) {
      const msg = errorMessage(err);
      if (supabase) {
        await recordFinish(supabase, job, runId, startedAt, {
          status: "error",
          httpStatus: null,
          error: msg,
          meta: null,
        });
        await alertCronFailure(supabase, job, `exception: ${msg}`);
      }
      throw err;
    }

    if (supabase) {
      const ok = response.status >= 200 && response.status < 300;
      const { meta, bodyError } = await readResponseMeta(response);
      const error = ok ? null : bodyError ?? `HTTP ${response.status}`;
      await recordFinish(supabase, job, runId, startedAt, {
        status: ok ? "ok" : "error",
        httpStatus: response.status,
        error,
        meta,
      });
      if (!ok) await alertCronFailure(supabase, job, `HTTP ${response.status}: ${error}`);
    }
    return response;
  };
}

// ─── Health summary (admin page + digest) ───────────────────────────────────

export type CronEffectiveStatus = CronRunStatus | "timeout";

export interface CronJobHealth extends CronJobDef {
  staleAfterMinutes: number;
  lastRun: CronRunRow | null;
  lastStatus: CronEffectiveStatus | null;
  failures24h: number;
  lastError: string | null;
  /** Has run before, but not within its expected interval (+ slack). */
  stale: boolean;
}

/** A 'running' row older than the abandon window is a killed (timed-out) run. */
export function effectiveStatus(row: Pick<CronRunRow, "status" | "started_at">, now: Date): CronEffectiveStatus {
  if (row.status === "running" && now.getTime() - new Date(row.started_at).getTime() > RUN_ABANDONED_AFTER_MS) {
    return "timeout";
  }
  return row.status;
}

/**
 * Pure summary: `latest` is the newest row per job, `recent` every row from
 * the last 24h that isn't 'ok' (errors + still-running).
 */
export function summarizeCronHealth(
  latest: Map<string, CronRunRow>,
  recent: CronRunRow[],
  now: Date,
  jobs: readonly CronJobDef[] = CRON_JOBS
): CronJobHealth[] {
  return jobs.map((def) => {
    const staleAfter = staleAfterMinutes(def.schedule);
    const lastRun = latest.get(def.job) ?? null;
    const failures = recent
      .filter((r) => r.job === def.job)
      .filter((r) => {
        const s = effectiveStatus(r, now);
        return s === "error" || s === "timeout";
      })
      .sort((a, b) => b.started_at.localeCompare(a.started_at));
    const stale =
      lastRun != null && now.getTime() - new Date(lastRun.started_at).getTime() > staleAfter * 60_000;
    return {
      ...def,
      staleAfterMinutes: staleAfter,
      lastRun,
      lastStatus: lastRun ? effectiveStatus(lastRun, now) : null,
      failures24h: failures.length,
      lastError: failures[0] ? failures[0].error ?? TIMEOUT_ERROR : null,
      stale,
    };
  });
}

const RUN_COLUMNS = "id, job, started_at, finished_at, duration_ms, status, http_status, error";

/** Query cron_runs (service role) and summarize every registered job. */
export async function fetchCronHealth(supabase: AnyClient, now = new Date()): Promise<CronJobHealth[]> {
  const since = new Date(now.getTime() - 24 * 60 * 60_000).toISOString();
  const [latestResults, recentRes] = await Promise.all([
    Promise.all(
      CRON_JOBS.map((def) =>
        supabase
          .from("cron_runs")
          .select(RUN_COLUMNS)
          .eq("job", def.job)
          .order("started_at", { ascending: false })
          .limit(1)
      )
    ),
    supabase
      .from("cron_runs")
      .select(RUN_COLUMNS)
      .gte("started_at", since)
      .neq("status", "ok")
      .order("started_at", { ascending: false })
      .limit(1000),
  ]);

  const latest = new Map<string, CronRunRow>();
  for (const res of latestResults) {
    if (res.error) throw res.error;
    const row = (res.data as CronRunRow[] | null)?.[0];
    if (row) latest.set(row.job, row);
  }
  if (recentRes.error) throw recentRes.error;
  return summarizeCronHealth(latest, (recentRes.data as CronRunRow[] | null) ?? [], now);
}
