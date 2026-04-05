-- =====================================================
-- Morroo Analytics Functions v2
-- Run in Supabase SQL Editor
-- =====================================================

-- Add topic column to mcq_questions (run first)
ALTER TABLE mcq_questions ADD COLUMN IF NOT EXISTS topic text;

-- =====================================================
-- 1. get_user_streak: นับวันที่ทำข้อสอบติดต่อกัน
-- =====================================================
CREATE OR REPLACE FUNCTION get_user_streak(p_user_id uuid)
RETURNS integer
LANGUAGE sql STABLE
AS $$
  WITH daily AS (
    SELECT DISTINCT DATE(created_at AT TIME ZONE 'Asia/Bangkok') AS day
    FROM mcq_attempts
    WHERE user_id = p_user_id
  ),
  ordered AS (
    SELECT
      day,
      day - (ROW_NUMBER() OVER (ORDER BY day))::integer AS grp
    FROM daily
  ),
  groups AS (
    SELECT grp, MIN(day) AS start_day, MAX(day) AS end_day, COUNT(*) AS streak_len
    FROM ordered
    GROUP BY grp
  ),
  latest_group AS (
    SELECT streak_len
    FROM groups
    WHERE end_day >= CURRENT_DATE - INTERVAL '1 day'
    ORDER BY end_day DESC
    LIMIT 1
  )
  SELECT COALESCE((SELECT streak_len::integer FROM latest_group), 0);
$$;

-- =====================================================
-- 2. get_user_vs_global_avg: เปรียบเทียบ user กับ avg
-- =====================================================
CREATE OR REPLACE FUNCTION get_user_vs_global_avg(p_user_id uuid)
RETURNS TABLE (
  subject_id uuid,
  subject_name_th text,
  subject_icon text,
  user_accuracy numeric,
  global_accuracy numeric,
  diff numeric
)
LANGUAGE sql STABLE
AS $$
  WITH user_stats AS (
    SELECT
      q.subject_id,
      ROUND(
        COUNT(*) FILTER (WHERE a.is_correct) * 100.0 / NULLIF(COUNT(*), 0),
        1
      ) AS user_acc
    FROM mcq_attempts a
    JOIN mcq_questions q ON q.id = a.question_id
    WHERE a.user_id = p_user_id
    GROUP BY q.subject_id
  ),
  global_stats AS (
    SELECT
      q.subject_id,
      ROUND(
        COUNT(*) FILTER (WHERE a.is_correct) * 100.0 / NULLIF(COUNT(*), 0),
        1
      ) AS global_acc
    FROM mcq_attempts a
    JOIN mcq_questions q ON q.id = a.question_id
    GROUP BY q.subject_id
  )
  SELECT
    s.id AS subject_id,
    s.name_th AS subject_name_th,
    s.icon AS subject_icon,
    u.user_acc AS user_accuracy,
    g.global_acc AS global_accuracy,
    ROUND(u.user_acc - g.global_acc, 1) AS diff
  FROM user_stats u
  JOIN global_stats g ON g.subject_id = u.subject_id
  JOIN mcq_subjects s ON s.id = u.subject_id
  ORDER BY diff ASC;
$$;

-- =====================================================
-- 3. get_admin_activity_heatmap: heatmap วัน × ชั่วโมง
-- =====================================================
CREATE OR REPLACE FUNCTION get_admin_activity_heatmap()
RETURNS TABLE (
  day_of_week integer,
  hour_of_day integer,
  attempt_count bigint
)
LANGUAGE sql STABLE
AS $$
  SELECT
    EXTRACT(DOW FROM created_at AT TIME ZONE 'Asia/Bangkok')::integer AS day_of_week,
    EXTRACT(HOUR FROM created_at AT TIME ZONE 'Asia/Bangkok')::integer AS hour_of_day,
    COUNT(*) AS attempt_count
  FROM mcq_attempts
  WHERE created_at > NOW() - INTERVAL '90 days'
  GROUP BY day_of_week, hour_of_day
  ORDER BY day_of_week, hour_of_day;
$$;
