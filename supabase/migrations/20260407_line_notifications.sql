-- =====================================================
-- LINE Notification Features — RPC + Cron Jobs
-- Run in Supabase SQL Editor
-- =====================================================

-- =====================================================
-- 1. get_user_weekly_summary: สรุปผลสอบรายสัปดาห์
-- =====================================================
CREATE OR REPLACE FUNCTION get_user_weekly_summary(p_user_id uuid)
RETURNS TABLE (
  total_questions int,
  correct_count int,
  accuracy numeric,
  best_subject text,
  best_subject_icon text,
  streak int
)
LANGUAGE sql STABLE
AS $$
  WITH weekly AS (
    SELECT
      a.is_correct,
      q.subject_id
    FROM mcq_attempts a
    JOIN mcq_questions q ON q.id = a.question_id
    WHERE a.user_id = p_user_id
      AND a.created_at >= NOW() - INTERVAL '7 days'
  ),
  totals AS (
    SELECT
      COUNT(*)::int AS total_q,
      COUNT(*) FILTER (WHERE is_correct)::int AS correct_q,
      ROUND(
        COUNT(*) FILTER (WHERE is_correct) * 100.0 / NULLIF(COUNT(*), 0),
        1
      ) AS acc
    FROM weekly
  ),
  best AS (
    SELECT
      s.name_th,
      s.icon,
      ROUND(
        COUNT(*) FILTER (WHERE w.is_correct) * 100.0 / NULLIF(COUNT(*), 0),
        1
      ) AS sub_acc
    FROM weekly w
    JOIN mcq_subjects s ON s.id = w.subject_id
    GROUP BY s.name_th, s.icon
    ORDER BY sub_acc DESC
    LIMIT 1
  )
  SELECT
    t.total_q AS total_questions,
    t.correct_q AS correct_count,
    t.acc AS accuracy,
    COALESCE(b.name_th, '-') AS best_subject,
    COALESCE(b.icon, '') AS best_subject_icon,
    get_user_streak(p_user_id) AS streak
  FROM totals t
  LEFT JOIN best b ON true;
$$;

-- =====================================================
-- 2. Cron: Expiry warning — daily 09:00 ICT (02:00 UTC)
-- =====================================================
SELECT cron.schedule(
  'send-expiry-warning',
  '0 2 * * *',
  $$
    SELECT net.http_post(
      url := current_setting('app.site_url') || '/api/line/expiry-warning?secret=' || current_setting('app.blog_generate_secret'),
      headers := '{"Content-Type": "application/json"}'::jsonb,
      body := '{}'::jsonb
    );
  $$
);

-- =====================================================
-- 3. Cron: Weekly summary — Sunday 10:00 ICT (03:00 UTC)
-- =====================================================
SELECT cron.schedule(
  'send-weekly-summary',
  '0 3 * * 0',
  $$
    SELECT net.http_post(
      url := current_setting('app.site_url') || '/api/line/weekly-summary?secret=' || current_setting('app.blog_generate_secret'),
      headers := '{"Content-Type": "application/json"}'::jsonb,
      body := '{}'::jsonb
    );
  $$
);
