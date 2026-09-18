-- Daily state for the morroo-daily-doctor scheduled task (see
-- docs/ops/daily-doctor.md). One row per calendar day (Bangkok time),
-- written by the doctor's own Supabase MCP session at the end of each run.
-- admin-digest reads the latest row to surface a "🩺 หมอประจำวัน" section
-- in the 08:00 LINE push.

CREATE TABLE IF NOT EXISTS doctor_reports (
  id          bigint      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  run_date    date        NOT NULL UNIQUE,
  headline    text        NOT NULL,
  merged      jsonb       NOT NULL DEFAULT '[]'::jsonb,   -- [{iid, title, url}]
  awaiting    jsonb       NOT NULL DEFAULT '[]'::jsonb,   -- [{iid, title, url, risk}]
  manual      jsonb       NOT NULL DEFAULT '[]'::jsonb,   -- [{title, howto}]
  health      jsonb       NOT NULL DEFAULT '{}'::jsonb,   -- 24h health snapshot
  report_md   text,                                        -- full report, for reference
  created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS doctor_reports_run_date_idx
  ON doctor_reports (run_date DESC);

ALTER TABLE doctor_reports ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Admins read doctor_reports" ON doctor_reports;
CREATE POLICY "Admins read doctor_reports" ON doctor_reports FOR SELECT
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));
