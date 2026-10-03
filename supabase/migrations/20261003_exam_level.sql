-- ระดับการสอบ (NL1/NL2/NL3/ทุกขั้นตอน/board) สำหรับตามนักเรียนตามระดับ
--   1) profiles.target_exam รับ NL3 เพิ่ม
--   2) get_daily_mcq รับ p_pool เพื่อเลือกข้อสอบรายวันตามระดับ (NULL = ผสม NL1+NL2 เหมือนเดิม)
--   3) exam_reminder_log กันส่งเตือนนับถอยหลังซ้ำ (service role เท่านั้น)

-- ─── 1) target_exam ────────────────────────────────────────────────────────
ALTER TABLE public.profiles DROP CONSTRAINT IF EXISTS profiles_target_exam_check;
ALTER TABLE public.profiles
  ADD CONSTRAINT profiles_target_exam_check
  CHECK (target_exam IS NULL OR target_exam IN ('NL1', 'NL2', 'NL3', 'both', 'board'))
  NOT VALID;

-- ─── 2) get_daily_mcq(p_date, p_pool) ──────────────────────────────────────
-- p_pool: 'NL1' | 'NL2' → นักศึกษา exam_type นั้น, 'board' → audience board,
-- NULL/อื่นๆ → พฤติกรรมเดิม (student NL1+NL2). ยัง SECURITY DEFINER + grant anon
-- เหมือนเดิม เพราะ dashboard card ใช้ตอนยังไม่ login
DROP FUNCTION IF EXISTS get_daily_mcq(date);

CREATE OR REPLACE FUNCTION get_daily_mcq(
  p_date date DEFAULT quiz_date_bangkok(),
  p_pool text DEFAULT NULL
)
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
    AND (
      CASE
        WHEN p_pool = 'board' THEN q.audience = 'board'
        WHEN p_pool IN ('NL1', 'NL2') THEN q.audience = 'student' AND q.exam_type = p_pool
        ELSE q.audience = 'student' AND q.exam_type IN ('NL1', 'NL2')
      END
    )
  ORDER BY md5(q.id::text || p_date::text)
  LIMIT 1;
$$;

GRANT EXECUTE ON FUNCTION get_daily_mcq(date, text) TO authenticated, anon;

-- ─── 3) exam_reminder_log ──────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.exam_reminder_log (
  user_id     uuid        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  round_key   text        NOT NULL,   -- เช่น "2026-10-10:1" (วันสอบ:step)
  days_before integer     NOT NULL,
  sent_at     timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, round_key, days_before)
);

-- เปิด RLS โดยไม่มี policy = service role เท่านั้น
ALTER TABLE public.exam_reminder_log ENABLE ROW LEVEL SECURITY;
