-- Daily MCQ function
-- Returns one deterministic question per day (same for all users on the same day)
-- Uses md5(question_id + quiz_date) as a stable sort key that rotates daily
--
-- Canonical source of truth is supabase/migrations/20260916_daily_mcq_line.sql
-- (this file exists for reference/local bootstrap only — re-running it is
-- safe since CREATE OR REPLACE is idempotent). That migration also added:
--   - quiz_date_bangkok(): the canonical "today" (Asia/Bangkok, not UTC),
--     used as this function's default p_date and by the LINE daily-reminder
--     broadcast / postback handler so they always agree on which question
--     is "today's".
--   - Scoping to audience='student' + exam_type NL1/NL2 (previously: every
--     active question, including Board — the NL practice page it links to
--     can't serve those).
--   - A `quiz_date` output column so callers never recompute "today"
--     themselves.

CREATE OR REPLACE FUNCTION get_daily_mcq(p_date date DEFAULT quiz_date_bangkok())
RETURNS TABLE(
  id          uuid,
  scenario    text,
  difficulty  text,
  subject_id  uuid,
  subject_name_th text,
  subject_icon    text,
  exam_type   text,
  quiz_date   date
)
LANGUAGE sql STABLE SECURITY DEFINER AS $$
  SELECT
    q.id,
    q.scenario,
    q.difficulty::text,
    q.subject_id,
    s.name_th   AS subject_name_th,
    s.icon      AS subject_icon,
    q.exam_type::text,
    p_date      AS quiz_date
  FROM mcq_questions q
  JOIN mcq_subjects  s ON s.id = q.subject_id
  WHERE q.status = 'active'
    AND q.audience = 'student'
    AND q.exam_type IN ('NL1', 'NL2')
  ORDER BY md5(q.id::text || p_date::text)
  LIMIT 1;
$$;

GRANT EXECUTE ON FUNCTION get_daily_mcq(date) TO authenticated, anon;
