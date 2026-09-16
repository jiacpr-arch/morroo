-- Daily MCQ in LINE: answer-in-chat postback support.
--
-- Adds a single canonical "quiz date" (Asia/Bangkok, not UTC) used by
-- get_daily_mcq(), the daily-reminder broadcast, and the postback handler
-- so the picked question and the recorded answer always agree on "today".
--
-- New table daily_quiz_answers records one answer per LINE user per quiz
-- date (service-role only — no anon/authenticated policy). Two RPCs expose
-- aggregate stats (percent-correct, streak) without leaking other users'
-- rows through PostgREST.

-- ─── quiz_date_bangkok() ───────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION quiz_date_bangkok()
RETURNS date
LANGUAGE sql STABLE AS $$
  SELECT (now() AT TIME ZONE 'Asia/Bangkok')::date;
$$;

-- ─── get_daily_mcq(): NL-only, Bangkok-dated, parameterized ───────────────
-- Replaces supabase/daily_mcq_function.sql. Still SECURITY DEFINER and
-- granted to anon so the dashboard card works for logged-out visitors, but
-- now scoped to audience='student' + exam_type NL1/NL2 (was: every active
-- question, including Board) and returns quiz_date so callers never have to
-- recompute "today" themselves.
DROP FUNCTION IF EXISTS get_daily_mcq();

CREATE OR REPLACE FUNCTION get_daily_mcq(p_date date DEFAULT quiz_date_bangkok())
RETURNS TABLE(
  id              uuid,
  scenario        text,
  difficulty      text,
  subject_id      uuid,
  subject_name_th text,
  subject_icon    text,
  exam_type       text,
  quiz_date       date
)
LANGUAGE sql STABLE SECURITY DEFINER AS $$
  SELECT
    q.id,
    q.scenario,
    q.difficulty::text,
    q.subject_id,
    s.name_th AS subject_name_th,
    s.icon    AS subject_icon,
    q.exam_type::text,
    p_date    AS quiz_date
  FROM mcq_questions q
  JOIN mcq_subjects  s ON s.id = q.subject_id
  WHERE q.status = 'active'
    AND q.audience = 'student'
    AND q.exam_type IN ('NL1', 'NL2')
  ORDER BY md5(q.id::text || p_date::text)
  LIMIT 1;
$$;

GRANT EXECUTE ON FUNCTION get_daily_mcq(date) TO authenticated, anon;

-- ─── daily_quiz_answers ────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS daily_quiz_answers (
  id              uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  line_user_id    text        NOT NULL,
  question_id     uuid        NOT NULL REFERENCES mcq_questions(id) ON DELETE CASCADE,
  quiz_date       date        NOT NULL,
  selected_answer text        NOT NULL,
  is_correct      boolean     NOT NULL,
  user_id         uuid        REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at      timestamptz NOT NULL DEFAULT now()
);

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'daily_quiz_answers_selected_answer_check') THEN
    ALTER TABLE daily_quiz_answers ADD CONSTRAINT daily_quiz_answers_selected_answer_check
      CHECK (selected_answer IN ('A', 'B', 'C', 'D', 'E'));
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'daily_quiz_answers_line_date_unique') THEN
    ALTER TABLE daily_quiz_answers ADD CONSTRAINT daily_quiz_answers_line_date_unique
      UNIQUE (line_user_id, quiz_date);
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS daily_quiz_answers_quiz_date_idx ON daily_quiz_answers(quiz_date);

-- Service-role only: RLS enabled, no policies granted to anon/authenticated.
ALTER TABLE daily_quiz_answers ENABLE ROW LEVEL SECURITY;

-- ─── daily_quiz_stats(): percent-correct for one quiz date ────────────────
CREATE OR REPLACE FUNCTION daily_quiz_stats(p_date date)
RETURNS TABLE(total int, correct int)
LANGUAGE sql STABLE SECURITY DEFINER AS $$
  SELECT
    count(*)::int AS total,
    count(*) FILTER (WHERE is_correct)::int AS correct
  FROM daily_quiz_answers
  WHERE quiz_date = p_date;
$$;

-- Aggregate-only (no per-row identifying data), but keep it service-role to
-- match daily_quiz_answers' access model rather than opening a new surface.
REVOKE ALL ON FUNCTION daily_quiz_stats(date) FROM PUBLIC;

-- ─── daily_quiz_streak(): consecutive quiz_dates ending at p_date ─────────
-- Classic "gaps and islands" trick: for the most recent 60 answered dates
-- (descending), row_number() - 1 subtracted from p_date must equal the row's
-- quiz_date for every row that's part of the current unbroken streak ending
-- exactly at p_date. Returns 0 if the user didn't answer on p_date itself.
CREATE OR REPLACE FUNCTION daily_quiz_streak(p_line_user_id text, p_date date)
RETURNS int
LANGUAGE sql STABLE SECURITY DEFINER AS $$
  WITH recent AS (
    SELECT quiz_date
    FROM daily_quiz_answers
    WHERE line_user_id = p_line_user_id
      AND quiz_date <= p_date
    ORDER BY quiz_date DESC
    LIMIT 60
  ),
  numbered AS (
    SELECT quiz_date, (row_number() OVER (ORDER BY quiz_date DESC) - 1)::int AS rn
    FROM recent
  )
  SELECT count(*)::int
  FROM numbered
  WHERE quiz_date = p_date - rn;
$$;

REVOKE ALL ON FUNCTION daily_quiz_streak(text, date) FROM PUBLIC;

-- ─── daily_quiz_week_recap(): Sunday recap bubble data ────────────────────
-- p_end = the last day of the 7-day window (Saturday, quiz_date_bangkok()-1
-- when called Sunday morning by the broadcast route).
CREATE OR REPLACE FUNCTION daily_quiz_week_recap(p_end date)
RETURNS TABLE(
  answers        int,
  participants   int,
  hardest_date   date,
  hardest_pct    numeric,
  streak5_count  int
)
LANGUAGE sql STABLE SECURITY DEFINER AS $$
  WITH week AS (
    SELECT *
    FROM daily_quiz_answers
    WHERE quiz_date BETWEEN p_end - 6 AND p_end
  ),
  by_day AS (
    SELECT
      quiz_date,
      count(*) AS total,
      count(*) FILTER (WHERE is_correct) AS correct,
      round(100.0 * count(*) FILTER (WHERE is_correct) / NULLIF(count(*), 0), 1) AS pct
    FROM week
    GROUP BY quiz_date
  ),
  hardest AS (
    SELECT quiz_date, pct
    FROM by_day
    WHERE total >= 5
    ORDER BY pct ASC NULLS LAST
    LIMIT 1
  ),
  streaks AS (
    SELECT line_user_id
    FROM week
    GROUP BY line_user_id
    HAVING count(DISTINCT quiz_date) FILTER (
      WHERE quiz_date >= p_end - 4
    ) = 5
  )
  SELECT
    (SELECT count(*)::int FROM week)                       AS answers,
    (SELECT count(DISTINCT line_user_id)::int FROM week)    AS participants,
    (SELECT quiz_date FROM hardest)                         AS hardest_date,
    (SELECT pct FROM hardest)                                AS hardest_pct,
    (SELECT count(*)::int FROM streaks)                     AS streak5_count;
$$;

REVOKE ALL ON FUNCTION daily_quiz_week_recap(date) FROM PUBLIC;
