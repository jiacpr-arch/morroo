-- AI-generated landing-page suggestion PRs (Option 1 of the
-- "auto-fix from analytics signals" pipeline, paired with the
-- ads_diagnostics tables introduced in 20260523_ads_diagnostics.sql).
--
-- One row per draft PR the ads-autofix-suggest cron opens against a finding.
-- Keeps the baseline metrics that triggered the PR so the post-merge watcher
-- can A/B compare current performance against "what it was when AI suggested
-- the change" and either auto-revert (degradation) or mark resolved.

CREATE TABLE IF NOT EXISTS ad_suggest_prs (
  id                       bigint      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  finding_id               bigint      REFERENCES ad_diagnostics_findings(id) ON DELETE SET NULL,
  page_path                text        NOT NULL,                -- e.g. "/lp/free-trial"
  page_file                text        NOT NULL,                -- e.g. "app/lp/free-trial/page.tsx"
  pr_number                integer     NOT NULL UNIQUE,
  pr_url                   text        NOT NULL,
  branch                   text        NOT NULL,
  baseline_metrics         jsonb       NOT NULL,                -- sessions, signup_rate, etc.
  risk_checks              jsonb       NOT NULL DEFAULT '[]'::jsonb,
  status                   text        NOT NULL DEFAULT 'open' CHECK (status IN ('open','merged','closed','reverted','snoozed')),
  merged_at                timestamptz,
  revert_pr_number         integer,
  post_merge_metrics       jsonb,
  outcome                  text        CHECK (outcome IN ('improved','degraded','flat')),
  outcome_resolved_at      timestamptz,
  created_at               timestamptz NOT NULL DEFAULT now(),
  updated_at               timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS ad_suggest_prs_status_idx
  ON ad_suggest_prs (status, created_at DESC);
CREATE INDEX IF NOT EXISTS ad_suggest_prs_merged_idx
  ON ad_suggest_prs (merged_at) WHERE merged_at IS NOT NULL;
CREATE INDEX IF NOT EXISTS ad_suggest_prs_page_idx
  ON ad_suggest_prs (page_path);

-- Snooze list. When the admin dismisses a suggest PR, skip the same
-- (entity_id, category) pair until snoozed_until passes.
CREATE TABLE IF NOT EXISTS ad_finding_snooze (
  id              bigint      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  entity_id       text        NOT NULL,
  category        text        NOT NULL,
  snoozed_until   timestamptz NOT NULL,
  reason          text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  UNIQUE (entity_id, category)
);

CREATE INDEX IF NOT EXISTS ad_finding_snooze_until_idx
  ON ad_finding_snooze (snoozed_until DESC);

ALTER TABLE ad_suggest_prs     ENABLE ROW LEVEL SECURITY;
ALTER TABLE ad_finding_snooze  ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Admins read ad_suggest_prs" ON ad_suggest_prs;
CREATE POLICY "Admins read ad_suggest_prs" ON ad_suggest_prs FOR SELECT
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));

DROP POLICY IF EXISTS "Admins read ad_finding_snooze" ON ad_finding_snooze;
CREATE POLICY "Admins read ad_finding_snooze" ON ad_finding_snooze FOR SELECT
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));
