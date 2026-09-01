-- Track whether each attempt came from the recommendation engine.
-- Nullable/default-false so historical rows remain unaffected.

ALTER TABLE public.mcq_attempts
  ADD COLUMN IF NOT EXISTS via_recommendation boolean NOT NULL DEFAULT false;

CREATE INDEX IF NOT EXISTS idx_mcq_attempts_via_recommendation
  ON public.mcq_attempts (via_recommendation)
  WHERE via_recommendation = true;

-- get_recommendation_effectiveness:
--   Compares accuracy of recommended-mode attempts vs normal attempts
--   over the given window. Admin-only (enforced at API layer).
CREATE OR REPLACE FUNCTION get_recommendation_effectiveness(p_days int DEFAULT 30)
RETURNS TABLE (
  bucket text,
  total_attempts bigint,
  correct_count bigint,
  accuracy numeric,
  unique_users bigint
)
LANGUAGE sql STABLE
AS $$
  WITH windowed AS (
    SELECT user_id, is_correct, via_recommendation
    FROM mcq_attempts
    WHERE created_at >= now() - (p_days || ' days')::interval
  )
  SELECT
    CASE WHEN via_recommendation THEN 'recommended' ELSE 'regular' END AS bucket,
    COUNT(*)::bigint AS total_attempts,
    COUNT(*) FILTER (WHERE is_correct)::bigint AS correct_count,
    ROUND(
      (COUNT(*) FILTER (WHERE is_correct)::numeric / NULLIF(COUNT(*), 0)) * 100,
      1
    ) AS accuracy,
    COUNT(DISTINCT user_id)::bigint AS unique_users
  FROM windowed
  GROUP BY via_recommendation
  ORDER BY via_recommendation DESC;
$$;

GRANT EXECUTE ON FUNCTION get_recommendation_effectiveness(int) TO authenticated;
