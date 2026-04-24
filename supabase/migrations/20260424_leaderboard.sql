-- Weekly leaderboard — top practisers by accuracy-weighted score.
-- Opt-in: users choose to appear on the board via profiles.leaderboard_opt_in.

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS leaderboard_opt_in boolean NOT NULL DEFAULT false;

-- get_leaderboard:
--   p_period: 'weekly' (last 7d) or 'alltime'
--   Returns the top opt-in users ordered by correct_count desc, then accuracy.
--   Users with fewer than 5 attempts in the period are excluded to keep the
--   board meaningful.
CREATE OR REPLACE FUNCTION get_leaderboard(
  p_period text DEFAULT 'weekly',
  p_limit int DEFAULT 10
)
RETURNS TABLE (
  rank int,
  user_id uuid,
  display_name text,
  correct_count bigint,
  total_count bigint,
  accuracy numeric,
  streak int
)
LANGUAGE sql STABLE
AS $$
  WITH since AS (
    SELECT CASE
      WHEN p_period = 'weekly' THEN now() - INTERVAL '7 days'
      ELSE '1970-01-01'::timestamptz
    END AS cutoff
  ),
  agg AS (
    SELECT
      a.user_id,
      COUNT(*) FILTER (WHERE a.is_correct) AS correct_count,
      COUNT(*) AS total_count
    FROM mcq_attempts a, since
    WHERE a.created_at >= since.cutoff
    GROUP BY a.user_id
    HAVING COUNT(*) >= 5
  ),
  joined AS (
    SELECT
      agg.user_id,
      COALESCE(NULLIF(p.name, ''), split_part(p.email, '@', 1)) AS full_name,
      agg.correct_count,
      agg.total_count,
      ROUND((agg.correct_count::numeric / NULLIF(agg.total_count, 0)) * 100, 1) AS accuracy
    FROM agg
    JOIN profiles p ON p.id = agg.user_id
    WHERE p.leaderboard_opt_in = true
  ),
  ranked AS (
    SELECT
      ROW_NUMBER() OVER (ORDER BY correct_count DESC, accuracy DESC NULLS LAST)::int AS rank,
      user_id,
      -- First word + initial of second (e.g. "Alice S.") for minimal privacy.
      CASE
        WHEN position(' ' IN full_name) > 0 THEN
          split_part(full_name, ' ', 1) || ' ' || left(split_part(full_name, ' ', 2), 1) || '.'
        ELSE full_name
      END AS display_name,
      correct_count,
      total_count,
      accuracy
    FROM joined
  )
  SELECT
    r.rank,
    r.user_id,
    r.display_name,
    r.correct_count,
    r.total_count,
    r.accuracy,
    get_user_streak(r.user_id) AS streak
  FROM ranked r
  ORDER BY r.rank
  LIMIT p_limit;
$$;

GRANT EXECUTE ON FUNCTION get_leaderboard(text, int) TO anon, authenticated;

-- get_user_leaderboard_rank: returns the caller's rank in the given period,
-- or NULL if they aren't opted in or have fewer than 5 attempts.
CREATE OR REPLACE FUNCTION get_user_leaderboard_rank(
  p_user_id uuid,
  p_period text DEFAULT 'weekly'
)
RETURNS TABLE (
  rank int,
  correct_count bigint,
  total_count bigint,
  accuracy numeric,
  total_participants int
)
LANGUAGE sql STABLE
AS $$
  WITH since AS (
    SELECT CASE
      WHEN p_period = 'weekly' THEN now() - INTERVAL '7 days'
      ELSE '1970-01-01'::timestamptz
    END AS cutoff
  ),
  agg AS (
    SELECT
      a.user_id,
      COUNT(*) FILTER (WHERE a.is_correct) AS correct_count,
      COUNT(*) AS total_count
    FROM mcq_attempts a, since
    WHERE a.created_at >= since.cutoff
    GROUP BY a.user_id
    HAVING COUNT(*) >= 5
  ),
  ranked AS (
    SELECT
      ROW_NUMBER() OVER (ORDER BY agg.correct_count DESC,
        (agg.correct_count::numeric / NULLIF(agg.total_count, 0)) DESC NULLS LAST
      )::int AS rank,
      agg.user_id,
      agg.correct_count,
      agg.total_count,
      ROUND((agg.correct_count::numeric / NULLIF(agg.total_count, 0)) * 100, 1) AS accuracy
    FROM agg
    JOIN profiles p ON p.id = agg.user_id
    WHERE p.leaderboard_opt_in = true
  )
  SELECT r.rank, r.correct_count, r.total_count, r.accuracy,
    (SELECT COUNT(*)::int FROM ranked) AS total_participants
  FROM ranked r
  WHERE r.user_id = p_user_id;
$$;

GRANT EXECUTE ON FUNCTION get_user_leaderboard_rank(uuid, text) TO authenticated;
