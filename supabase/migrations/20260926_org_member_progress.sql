-- ============================================================
-- org_member_progress: per-member MCQ progress for the org owner dashboard
--
-- /org (lib/organizations-server.ts loadOrgDashboard) used to pull every
-- mcq_attempts row of every member through PostgREST with one
-- `.in("user_id", <all member ids>)` filter — an org with a few hundred
-- members produced a URL the gateway rejects (the error was read as "no
-- data" and the owner saw all zeros), and heavy orgs needed up to 100
-- sequential pages. This aggregates in SQL instead and returns ONE jsonb
-- array (a single row, so PostgREST's max-rows cap never applies):
--
--   [{ user_id, attempts, correct, last_active, streak }, ...]
--
-- Only members with ≥1 attempt appear; the app fills in zeros. `streak`
-- follows lib/organizations.ts streakFromDays: the latest run of consecutive
-- Asia/Bangkok days with an attempt, counted only if it ends today or
-- yesterday (Bangkok).
--
-- Service role only (the page checks ownership / site-admin first).
-- Idempotent: safe to re-run.
-- ============================================================

CREATE OR REPLACE FUNCTION public.org_member_progress(p_org_id uuid)
RETURNS jsonb
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  WITH daily AS (
    SELECT a.user_id,
           (a.created_at AT TIME ZONE 'Asia/Bangkok')::date AS day,
           count(*)                                   AS n,
           count(*) FILTER (WHERE a.is_correct)       AS c,
           max(a.created_at)                          AS last_at
    FROM organization_members m
    JOIN mcq_attempts a ON a.user_id = m.user_id
    WHERE m.org_id = p_org_id
    GROUP BY a.user_id, (a.created_at AT TIME ZONE 'Asia/Bangkok')::date
  ),
  runs AS (
    SELECT user_id, day,
           day - (row_number() OVER (PARTITION BY user_id ORDER BY day))::integer AS grp
    FROM daily
  ),
  latest_run AS (
    SELECT DISTINCT ON (user_id)
           user_id, max(day) AS end_day, count(*)::integer AS len
    FROM runs
    GROUP BY user_id, grp
    ORDER BY user_id, max(day) DESC
  ),
  totals AS (
    SELECT user_id, sum(n)::bigint AS attempts, sum(c)::bigint AS correct, max(last_at) AS last_active
    FROM daily
    GROUP BY user_id
  )
  SELECT COALESCE(
    jsonb_agg(jsonb_build_object(
      'user_id',     t.user_id,
      'attempts',    t.attempts,
      'correct',     t.correct,
      'last_active', t.last_active,
      'streak',      CASE
                       WHEN r.end_day >= (now() AT TIME ZONE 'Asia/Bangkok')::date - 1 THEN r.len
                       ELSE 0
                     END
    )),
    '[]'::jsonb
  )
  FROM totals t
  LEFT JOIN latest_run r USING (user_id);
$$;

REVOKE ALL ON FUNCTION public.org_member_progress(uuid) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.org_member_progress(uuid) FROM anon, authenticated;
GRANT EXECUTE ON FUNCTION public.org_member_progress(uuid) TO service_role;
