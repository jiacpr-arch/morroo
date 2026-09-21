-- Supabase security advisor `rls_disabled_in_public` (level ERROR) flagged eight
-- one-off MCQ backup tables taken on 2026-08-30/31. They sit in the `public`
-- schema, so PostgREST exposes them at /rest/v1/<table> — with RLS off, anyone
-- holding the anon key could read ~26k rows of answer keys, explanations and
-- shuffle maps straight out of them.
--
-- Nothing in the app reads these tables (no reference anywhere in the repo);
-- they are snapshots kept for reference only. Enabling RLS with no policy
-- denies anon and authenticated entirely while service_role (cron/admin paths)
-- still bypasses RLS as usual.
--
-- Applied to production on 2026-09-20 by the daily doctor after owner approval;
-- this file exists so the repo matches the database.
--
-- NOT included here: `public.mcq_shuffle_map`, which the same advisor flags.
-- That one is live data, not a backup, and needs a check for anon readers
-- before RLS goes on — enabling it blind could break option shuffling.

ALTER TABLE public.mcq_scenario_backup_20260830     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mcq_explanation_backup_20260830  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mcq_explanation_backup2_20260830 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mcq_answer_backup_20260830       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mcq_fulltext_backup_20260830     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mcq_shuffle_backup_20260830      ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mcq_review_backup_20260830       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mcq_qcfix_backup_20260831        ENABLE ROW LEVEL SECURITY;
