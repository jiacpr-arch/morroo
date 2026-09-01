-- Personalised weekly digest: per-user stats from the last 7 days.

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS weekly_digest_opt_in boolean NOT NULL DEFAULT true;

-- get_user_weekly_digest:
--   Returns the data needed to render one digest email: attempts, accuracy,
--   best subject, weakest subject, and streak for the last 7 days.
CREATE OR REPLACE FUNCTION get_user_weekly_digest(p_user_id uuid)
RETURNS TABLE (
  total_attempts bigint,
  correct_count bigint,
  accuracy numeric,
  streak int,
  best_subject_name text,
  best_subject_icon text,
  best_subject_accuracy numeric,
  weak_subject_name text,
  weak_subject_icon text,
  weak_subject_accuracy numeric
)
LANGUAGE sql STABLE
AS $$
  WITH week_attempts AS (
    SELECT a.*, q.subject_id
    FROM mcq_attempts a
    JOIN mcq_questions q ON q.id = a.question_id
    WHERE a.user_id = p_user_id
      AND a.created_at >= now() - interval '7 days'
  ),
  totals AS (
    SELECT
      COUNT(*) AS total_attempts,
      COUNT(*) FILTER (WHERE is_correct) AS correct_count
    FROM week_attempts
  ),
  per_subject AS (
    SELECT
      wa.subject_id,
      s.name_th,
      s.icon,
      COUNT(*) AS total,
      COUNT(*) FILTER (WHERE wa.is_correct) AS correct,
      (COUNT(*) FILTER (WHERE wa.is_correct)::numeric / NULLIF(COUNT(*), 0)) * 100 AS acc
    FROM week_attempts wa
    JOIN mcq_subjects s ON s.id = wa.subject_id
    GROUP BY wa.subject_id, s.name_th, s.icon
    HAVING COUNT(*) >= 3
  ),
  best AS (
    SELECT name_th, icon, acc FROM per_subject ORDER BY acc DESC NULLS LAST LIMIT 1
  ),
  weak AS (
    SELECT name_th, icon, acc FROM per_subject ORDER BY acc ASC NULLS LAST LIMIT 1
  )
  SELECT
    totals.total_attempts,
    totals.correct_count,
    ROUND((totals.correct_count::numeric / NULLIF(totals.total_attempts, 0)) * 100, 1) AS accuracy,
    get_user_streak(p_user_id) AS streak,
    (SELECT name_th FROM best) AS best_subject_name,
    (SELECT icon FROM best) AS best_subject_icon,
    ROUND((SELECT acc FROM best), 1) AS best_subject_accuracy,
    (SELECT name_th FROM weak) AS weak_subject_name,
    (SELECT icon FROM weak) AS weak_subject_icon,
    ROUND((SELECT acc FROM weak), 1) AS weak_subject_accuracy
  FROM totals;
$$;

GRANT EXECUTE ON FUNCTION get_user_weekly_digest(uuid) TO authenticated, service_role;
