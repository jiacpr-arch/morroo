-- =====================================================
-- Learning Analytics RPC Functions for Morroo
-- Run this in Supabase SQL Editor
-- =====================================================

-- 1. get_user_subject_stats: สถิติแยกตามสาขาของนักเรียน
CREATE OR REPLACE FUNCTION get_user_subject_stats(p_user_id uuid)
RETURNS TABLE (
  subject_id uuid,
  subject_name text,
  subject_name_th text,
  subject_icon text,
  total_attempts bigint,
  correct_count bigint,
  accuracy numeric,
  avg_time_spent numeric
)
LANGUAGE sql STABLE
AS $$
  SELECT
    s.id AS subject_id,
    s.name AS subject_name,
    s.name_th AS subject_name_th,
    s.icon AS subject_icon,
    COUNT(a.id) AS total_attempts,
    COUNT(a.id) FILTER (WHERE a.is_correct) AS correct_count,
    ROUND(
      COUNT(a.id) FILTER (WHERE a.is_correct) * 100.0 / NULLIF(COUNT(a.id), 0),
      1
    ) AS accuracy,
    ROUND(AVG(a.time_spent_seconds)::numeric, 1) AS avg_time_spent
  FROM mcq_attempts a
  JOIN mcq_questions q ON q.id = a.question_id
  JOIN mcq_subjects s ON s.id = q.subject_id
  WHERE a.user_id = p_user_id
  GROUP BY s.id, s.name, s.name_th, s.icon
  ORDER BY accuracy ASC NULLS FIRST;
$$;

-- 2. get_user_recent_sessions: sessions ล่าสุดของนักเรียน
CREATE OR REPLACE FUNCTION get_user_recent_sessions(p_user_id uuid, p_limit int DEFAULT 10)
RETURNS TABLE (
  session_id uuid,
  mode text,
  exam_type text,
  subject_name_th text,
  subject_icon text,
  total_questions int,
  correct_count int,
  accuracy numeric,
  created_at timestamptz,
  completed_at timestamptz
)
LANGUAGE sql STABLE
AS $$
  SELECT
    ms.id AS session_id,
    ms.mode,
    ms.exam_type,
    s.name_th AS subject_name_th,
    s.icon AS subject_icon,
    ms.total_questions,
    ms.correct_count,
    ROUND(
      ms.correct_count * 100.0 / NULLIF(ms.total_questions, 0),
      1
    ) AS accuracy,
    ms.created_at,
    ms.completed_at
  FROM mcq_sessions ms
  LEFT JOIN mcq_subjects s ON s.id = ms.subject_id
  WHERE ms.user_id = p_user_id
    AND ms.completed_at IS NOT NULL
  ORDER BY ms.created_at DESC
  LIMIT p_limit;
$$;

-- 3. get_user_weak_topics: สาขาที่อ่อน (accuracy < threshold)
CREATE OR REPLACE FUNCTION get_user_weak_topics(p_user_id uuid, p_threshold numeric DEFAULT 60)
RETURNS TABLE (
  subject_id uuid,
  subject_name text,
  subject_name_th text,
  subject_icon text,
  total_attempts bigint,
  correct_count bigint,
  accuracy numeric,
  wrong_count bigint
)
LANGUAGE sql STABLE
AS $$
  SELECT
    s.id AS subject_id,
    s.name AS subject_name,
    s.name_th AS subject_name_th,
    s.icon AS subject_icon,
    COUNT(a.id) AS total_attempts,
    COUNT(a.id) FILTER (WHERE a.is_correct) AS correct_count,
    ROUND(
      COUNT(a.id) FILTER (WHERE a.is_correct) * 100.0 / NULLIF(COUNT(a.id), 0),
      1
    ) AS accuracy,
    COUNT(a.id) FILTER (WHERE NOT a.is_correct) AS wrong_count
  FROM mcq_attempts a
  JOIN mcq_questions q ON q.id = a.question_id
  JOIN mcq_subjects s ON s.id = q.subject_id
  WHERE a.user_id = p_user_id
  GROUP BY s.id, s.name, s.name_th, s.icon
  HAVING ROUND(
    COUNT(a.id) FILTER (WHERE a.is_correct) * 100.0 / NULLIF(COUNT(a.id), 0),
    1
  ) < p_threshold
  ORDER BY accuracy ASC NULLS FIRST;
$$;

-- 4. get_user_accuracy_trend: accuracy ตามสัปดาห์ (สำหรับ chart)
CREATE OR REPLACE FUNCTION get_user_accuracy_trend(p_user_id uuid)
RETURNS TABLE (
  week_start date,
  total_attempts bigint,
  correct_count bigint,
  accuracy numeric
)
LANGUAGE sql STABLE
AS $$
  SELECT
    DATE_TRUNC('week', a.created_at)::date AS week_start,
    COUNT(a.id) AS total_attempts,
    COUNT(a.id) FILTER (WHERE a.is_correct) AS correct_count,
    ROUND(
      COUNT(a.id) FILTER (WHERE a.is_correct) * 100.0 / NULLIF(COUNT(a.id), 0),
      1
    ) AS accuracy
  FROM mcq_attempts a
  WHERE a.user_id = p_user_id
  GROUP BY DATE_TRUNC('week', a.created_at)
  ORDER BY week_start ASC;
$$;

-- 5. get_admin_overall_stats: สถิติภาพรวมสำหรับ admin
CREATE OR REPLACE FUNCTION get_admin_overall_stats()
RETURNS TABLE (
  total_students bigint,
  active_students_7d bigint,
  avg_accuracy numeric,
  total_attempts bigint,
  weakest_subject_name_th text,
  weakest_subject_icon text,
  weakest_subject_accuracy numeric
)
LANGUAGE sql STABLE
AS $$
  WITH student_stats AS (
    SELECT DISTINCT user_id FROM mcq_attempts
  ),
  active_stats AS (
    SELECT DISTINCT user_id
    FROM mcq_attempts
    WHERE created_at > NOW() - INTERVAL '7 days'
  ),
  overall AS (
    SELECT
      ROUND(
        COUNT(*) FILTER (WHERE is_correct) * 100.0 / NULLIF(COUNT(*), 0),
        1
      ) AS avg_acc,
      COUNT(*) AS total_att
    FROM mcq_attempts
  ),
  weakest AS (
    SELECT
      s.name_th,
      s.icon,
      ROUND(
        COUNT(a.id) FILTER (WHERE a.is_correct) * 100.0 / NULLIF(COUNT(a.id), 0),
        1
      ) AS acc
    FROM mcq_attempts a
    JOIN mcq_questions q ON q.id = a.question_id
    JOIN mcq_subjects s ON s.id = q.subject_id
    GROUP BY s.id, s.name_th, s.icon
    HAVING COUNT(a.id) >= 10
    ORDER BY acc ASC
    LIMIT 1
  )
  SELECT
    (SELECT COUNT(*) FROM student_stats)::bigint AS total_students,
    (SELECT COUNT(*) FROM active_stats)::bigint AS active_students_7d,
    o.avg_acc AS avg_accuracy,
    o.total_att AS total_attempts,
    w.name_th AS weakest_subject_name_th,
    w.icon AS weakest_subject_icon,
    w.acc AS weakest_subject_accuracy
  FROM overall o
  LEFT JOIN weakest w ON true;
$$;

-- 6. get_admin_students_overview: รายชื่อนักเรียนทุกคนพร้อมสถิติ
CREATE OR REPLACE FUNCTION get_admin_students_overview()
RETURNS TABLE (
  user_id uuid,
  user_name text,
  user_email text,
  membership_type text,
  total_attempts bigint,
  correct_count bigint,
  accuracy numeric,
  last_active timestamptz
)
LANGUAGE sql STABLE
AS $$
  SELECT
    p.id AS user_id,
    p.name AS user_name,
    p.email AS user_email,
    p.membership_type,
    COUNT(a.id) AS total_attempts,
    COUNT(a.id) FILTER (WHERE a.is_correct) AS correct_count,
    ROUND(
      COUNT(a.id) FILTER (WHERE a.is_correct) * 100.0 / NULLIF(COUNT(a.id), 0),
      1
    ) AS accuracy,
    MAX(a.created_at) AS last_active
  FROM profiles p
  INNER JOIN mcq_attempts a ON a.user_id = p.id
  GROUP BY p.id, p.name, p.email, p.membership_type
  ORDER BY last_active DESC;
$$;
