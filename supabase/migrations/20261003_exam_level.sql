-- ระดับการสอบ (ส่วนที่ 1 / ส่วนที่ 2 / NL2 เดิม / board) สำหรับตามนักเรียนตามระดับ
--   1) profiles.target_exam เปลี่ยนเป็นค่าตามระบบ ศรว. ใหม่ (+ map ค่าเดิม)
--   2) profiles.board_specialty + get_daily_mcq รับ p_pool / p_board_specialty เพื่อเลือกข้อสอบรายวันตามระดับ (NULL = ผสม NL1+NL2 เหมือนเดิม)
--   3) exam_reminder_log กันส่งเตือนนับถอยหลังซ้ำ (service role เท่านั้น)

-- ─── 1) target_exam → ระบบ ศรว. ใหม่ ───────────────────────────────────────
-- ข้อบังคับแพทยสภา พ.ศ. 2568: ตั้งแต่ 2570 สอบ ส่วนที่ 1 (พื้นฐาน+คลินิก รวม) +
-- ส่วนที่ 2 (OSCE); NL1 เดิมสอบครั้งสุดท้าย ม.ค. 2569, NL2 เดิมเปิดถึง ต.ค. 2570
--   part1 = ส่วนที่ 1, part2 = ส่วนที่ 2 (OSCE), NL2 = NL2 เดิม, meq = MEQ + Long case, board = Board
-- map ค่าเดิม: NL1 / both → part1, NL3 → part2 (NL2, board คงเดิม)
ALTER TABLE public.profiles DROP CONSTRAINT IF EXISTS profiles_target_exam_check;

UPDATE public.profiles SET target_exam = 'part1' WHERE target_exam IN ('NL1', 'both');
UPDATE public.profiles SET target_exam = 'part2' WHERE target_exam = 'NL3';
-- ค่าแปลกปลอมอื่น (ถ้ามี) → ยังไม่ตั้งระดับ ให้ dashboard ถามใหม่
UPDATE public.profiles SET target_exam = NULL
  WHERE target_exam IS NOT NULL AND target_exam NOT IN ('part1', 'part2', 'NL2', 'meq', 'board');

-- CHECK ยังรับค่าเก่า (NL1 / NL3 / both) ไว้ด้วย: onboarding ของโค้ดก่อน merge ยังเขียนค่าเหล่านี้
-- และโค้ดใหม่อ่านผ่าน normalizeTarget() ได้ — ไม่งั้นการสมัครใหม่บน prod จะพังระหว่างรอ deploy
ALTER TABLE public.profiles
  ADD CONSTRAINT profiles_target_exam_check
  CHECK (target_exam IS NULL OR target_exam IN ('part1', 'part2', 'NL2', 'meq', 'board', 'NL1', 'NL3', 'both'));

-- ─── 2) board_specialty + get_daily_mcq(p_date, p_pool, p_board_specialty) ──
-- ผู้ใช้ระดับ board เลือกสาขา (อายุรศาสตร์, ศัลยศาสตร์ …) เพื่อรับข้อสอบรายวันของสาขานั้น
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS board_specialty text REFERENCES public.board_specialties(slug) ON DELETE SET NULL;

-- p_pool: 'NL1' | 'NL2' → นักศึกษา exam_type นั้น
--         'board'      → audience board (กรองสาขาด้วย p_board_specialty ถ้าส่งมา)
--         NULL/อื่นๆ   → พฤติกรรมเดิม (student NL1+NL2)
-- ยัง SECURITY DEFINER + grant anon เหมือนเดิม เพราะ dashboard card ใช้ตอนยังไม่ login
DROP FUNCTION IF EXISTS get_daily_mcq(date);
DROP FUNCTION IF EXISTS get_daily_mcq(date, text);

CREATE OR REPLACE FUNCTION get_daily_mcq(
  p_date date DEFAULT quiz_date_bangkok(),
  p_pool text DEFAULT NULL,
  p_board_specialty text DEFAULT NULL
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
        WHEN p_pool = 'board' THEN
          q.audience = 'board'
          AND (p_board_specialty IS NULL OR q.board_specialty = p_board_specialty)
        WHEN p_pool IN ('NL1', 'NL2') THEN q.audience = 'student' AND q.exam_type = p_pool
        ELSE q.audience = 'student' AND q.exam_type IN ('NL1', 'NL2')
      END
    )
  ORDER BY md5(q.id::text || p_date::text)
  LIMIT 1;
$$;

GRANT EXECUTE ON FUNCTION get_daily_mcq(date, text, text) TO authenticated, anon;

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
