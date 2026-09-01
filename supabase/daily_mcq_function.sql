-- Daily MCQ function
-- Returns one deterministic question per day (same for all users on the same day)
-- Uses md5(question_id + current_date) as a stable sort key that rotates daily

CREATE OR REPLACE FUNCTION get_daily_mcq()
RETURNS TABLE(
  id          uuid,
  scenario    text,
  difficulty  text,
  subject_id  uuid,
  subject_name_th text,
  subject_icon    text,
  exam_type   text
)
LANGUAGE sql STABLE SECURITY DEFINER AS $$
  SELECT
    q.id,
    q.scenario,
    q.difficulty::text,
    q.subject_id,
    s.name_th   AS subject_name_th,
    s.icon      AS subject_icon,
    q.exam_type::text
  FROM mcq_questions q
  JOIN mcq_subjects  s ON s.id = q.subject_id
  WHERE q.status = 'active'
  ORDER BY md5(q.id::text || current_date::text)
  LIMIT 1;
$$;

GRANT EXECUTE ON FUNCTION get_daily_mcq() TO authenticated, anon;
