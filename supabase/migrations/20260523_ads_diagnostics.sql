-- Ads + landing-page auto-diagnostics.
--
-- The /api/cron/ads-autofix endpoint joins:
--   1. analytics_events (page funnel signals)
--   2. Meta Marketing API insights (ad spend / CTR / CPL)
-- and writes:
--   - ad_diagnostics_runs       (one row per cron run)
--   - ad_diagnostics_findings   (each issue found, with recommendation)
--   - ad_auto_actions           (audit trail of every Meta API write,
--                                so we can revert / explain to the admin)
--
-- All three are admin-only and append-mostly. Findings have a `resolved`
-- flag so the admin dashboard can clear them out manually.

CREATE TABLE IF NOT EXISTS ad_diagnostics_runs (
  id              bigint      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  started_at      timestamptz NOT NULL DEFAULT now(),
  finished_at     timestamptz,
  ok              boolean     NOT NULL DEFAULT false,
  pages_scanned   integer     NOT NULL DEFAULT 0,
  ads_scanned     integer     NOT NULL DEFAULT 0,
  findings_count  integer     NOT NULL DEFAULT 0,
  actions_count   integer     NOT NULL DEFAULT 0,
  error           text,
  summary         jsonb
);

CREATE INDEX IF NOT EXISTS ad_diagnostics_runs_started_idx
  ON ad_diagnostics_runs (started_at DESC);

-- One row per detected issue. severity: info | warn | critical.
-- category drives which auto-action (if any) was attempted.
CREATE TABLE IF NOT EXISTS ad_diagnostics_findings (
  id                 bigint      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  run_id             bigint      REFERENCES ad_diagnostics_runs(id) ON DELETE CASCADE,
  severity           text        NOT NULL CHECK (severity IN ('info', 'warn', 'critical')),
  category           text        NOT NULL,
  entity_type        text        NOT NULL CHECK (entity_type IN ('page', 'ad', 'adset', 'campaign')),
  entity_id          text        NOT NULL,
  entity_label       text,
  metric_snapshot    jsonb       NOT NULL DEFAULT '{}'::jsonb,
  recommendation     text        NOT NULL,
  auto_action_taken  text,
  resolved           boolean     NOT NULL DEFAULT false,
  resolved_at        timestamptz,
  resolved_by        uuid        REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at         timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS ad_diagnostics_findings_created_idx
  ON ad_diagnostics_findings (created_at DESC);
CREATE INDEX IF NOT EXISTS ad_diagnostics_findings_run_idx
  ON ad_diagnostics_findings (run_id);
CREATE INDEX IF NOT EXISTS ad_diagnostics_findings_open_idx
  ON ad_diagnostics_findings (resolved, severity, created_at DESC)
  WHERE resolved = false;

-- Audit trail of every automated Meta API write. Keeps prior_state so the
-- admin can revert an auto-pause if it was wrong.
CREATE TABLE IF NOT EXISTS ad_auto_actions (
  id            bigint      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  finding_id    bigint      REFERENCES ad_diagnostics_findings(id) ON DELETE SET NULL,
  run_id        bigint      REFERENCES ad_diagnostics_runs(id) ON DELETE CASCADE,
  action        text        NOT NULL, -- e.g. 'pause_ad', 'pause_adset'
  entity_type   text        NOT NULL,
  entity_id     text        NOT NULL,
  prior_state   jsonb,
  result        jsonb,
  ok            boolean     NOT NULL DEFAULT false,
  reverted_at   timestamptz,
  created_at    timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS ad_auto_actions_created_idx
  ON ad_auto_actions (created_at DESC);
CREATE INDEX IF NOT EXISTS ad_auto_actions_entity_idx
  ON ad_auto_actions (entity_type, entity_id, created_at DESC);

ALTER TABLE ad_diagnostics_runs     ENABLE ROW LEVEL SECURITY;
ALTER TABLE ad_diagnostics_findings ENABLE ROW LEVEL SECURITY;
ALTER TABLE ad_auto_actions         ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Admins read ad_diagnostics_runs" ON ad_diagnostics_runs;
CREATE POLICY "Admins read ad_diagnostics_runs" ON ad_diagnostics_runs FOR SELECT
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));

DROP POLICY IF EXISTS "Admins read ad_diagnostics_findings" ON ad_diagnostics_findings;
CREATE POLICY "Admins read ad_diagnostics_findings" ON ad_diagnostics_findings FOR SELECT
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));

DROP POLICY IF EXISTS "Admins update ad_diagnostics_findings" ON ad_diagnostics_findings;
CREATE POLICY "Admins update ad_diagnostics_findings" ON ad_diagnostics_findings FOR UPDATE
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'))
  WITH CHECK (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));

DROP POLICY IF EXISTS "Admins read ad_auto_actions" ON ad_auto_actions;
CREATE POLICY "Admins read ad_auto_actions" ON ad_auto_actions FOR SELECT
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));
