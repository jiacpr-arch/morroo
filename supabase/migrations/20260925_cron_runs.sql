-- Cron run log — one row per invocation of a Vercel cron route.
--
-- Written by lib/cron-runs.ts (withCronRun) around every route listed in
-- vercel.json. A row is inserted as 'running' when the handler starts and
-- updated to 'ok' / 'error' when it returns or throws. A row that stays
-- 'running' past the function budget means the invocation was killed
-- (Vercel function timeout) — the next run of the same job sweeps it to
-- 'error' and the admin page / digest treat it as a timeout.
--
-- Read by the daily admin-digest cron (failures + stale jobs) and by
-- /admin/crons through the service-role API route. Only the service role
-- touches this table: RLS is on with no policies, so anon/authenticated
-- clients can neither read nor write it.
--
-- Retention: admin-digest deletes rows older than 30 days (board-gen alone
-- logs ~1,440 rows/day).

CREATE TABLE IF NOT EXISTS cron_runs (
  id           bigint      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  job          text        NOT NULL,
  started_at   timestamptz NOT NULL DEFAULT now(),
  finished_at  timestamptz,
  duration_ms  integer,
  status       text        NOT NULL DEFAULT 'running'
                           CHECK (status IN ('running', 'ok', 'error')),
  http_status  integer,
  error        text,
  meta         jsonb
);

CREATE INDEX IF NOT EXISTS cron_runs_job_started_idx
  ON cron_runs (job, started_at DESC);

-- Failure scans in the digest / admin page ("errors in the last 24h").
CREATE INDEX IF NOT EXISTS cron_runs_status_started_idx
  ON cron_runs (status, started_at DESC)
  WHERE status <> 'ok';

ALTER TABLE cron_runs ENABLE ROW LEVEL SECURITY;
-- Intentionally no policies: service role only.
