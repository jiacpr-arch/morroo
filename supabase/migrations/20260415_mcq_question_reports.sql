-- ============================================================
-- Student-driven exam-answer verification
-- ============================================================
-- Students can flag MCQ questions whose answer key is wrong
-- (or explanation/typo/duplicate etc.), earn "reporter points",
-- and once a question receives ≥3 independent "wrong_answer"
-- reports, it is auto-moved to status='review' so admins see it.
-- ============================================================

-- 1) Per-profile running total of "bug bounty" points
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS reporter_points int NOT NULL DEFAULT 0;

-- 2) Report table
CREATE TABLE IF NOT EXISTS public.mcq_question_reports (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id uuid NOT NULL REFERENCES public.mcq_questions(id) ON DELETE CASCADE,
  user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  reason text NOT NULL CHECK (reason IN (
    'wrong_answer',      -- เฉลยไม่ตรงกับคำตอบที่ถูก
    'unclear_question',  -- โจทย์ไม่ชัดเจน/กำกวม
    'typo',              -- พิมพ์ผิด
    'outdated',          -- ข้อมูลล้าสมัย
    'duplicate',         -- ซ้ำกับข้ออื่น
    'other'
  )),
  note text,
  suggested_answer text, -- เสนอคำตอบที่ควรจะเป็น (A/B/C/D/E) ถ้ามี
  status text NOT NULL DEFAULT 'pending' CHECK (status IN (
    'pending', 'confirmed', 'rejected', 'duplicate'
  )),
  points_awarded int NOT NULL DEFAULT 0,
  reviewed_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  reviewed_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  -- 1 user may only file one report per (question, reason) pair to avoid farming
  UNIQUE (question_id, user_id, reason)
);

CREATE INDEX IF NOT EXISTS idx_mcq_reports_question ON public.mcq_question_reports(question_id);
CREATE INDEX IF NOT EXISTS idx_mcq_reports_user     ON public.mcq_question_reports(user_id);
CREATE INDEX IF NOT EXISTS idx_mcq_reports_status   ON public.mcq_question_reports(status);

-- 3) Award points: +1 on submit, +10 extra when admin confirms
CREATE OR REPLACE FUNCTION public.award_reporter_points()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    IF NEW.user_id IS NOT NULL THEN
      UPDATE public.profiles
         SET reporter_points = COALESCE(reporter_points, 0) + 1
       WHERE id = NEW.user_id;
      NEW.points_awarded := 1;
    END IF;
    RETURN NEW;
  END IF;

  IF TG_OP = 'UPDATE'
     AND NEW.status = 'confirmed'
     AND (OLD.status IS DISTINCT FROM 'confirmed')
     AND NEW.user_id IS NOT NULL THEN
    UPDATE public.profiles
       SET reporter_points = COALESCE(reporter_points, 0) + 10
     WHERE id = NEW.user_id;
    NEW.points_awarded := COALESCE(OLD.points_awarded, 0) + 10;
    IF NEW.reviewed_at IS NULL THEN
      NEW.reviewed_at := now();
    END IF;
    RETURN NEW;
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_mcq_reports_award_insert ON public.mcq_question_reports;
CREATE TRIGGER trg_mcq_reports_award_insert
  BEFORE INSERT ON public.mcq_question_reports
  FOR EACH ROW EXECUTE FUNCTION public.award_reporter_points();

DROP TRIGGER IF EXISTS trg_mcq_reports_award_update ON public.mcq_question_reports;
CREATE TRIGGER trg_mcq_reports_award_update
  BEFORE UPDATE ON public.mcq_question_reports
  FOR EACH ROW EXECUTE FUNCTION public.award_reporter_points();

-- 4) Auto-flag a question for admin review once it has 3+ independent
--    "wrong_answer" reports
CREATE OR REPLACE FUNCTION public.autoflag_mcq_on_reports()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  report_count int;
BEGIN
  IF NEW.reason <> 'wrong_answer' THEN
    RETURN NEW;
  END IF;

  SELECT COUNT(*) INTO report_count
    FROM public.mcq_question_reports
   WHERE question_id = NEW.question_id
     AND reason      = 'wrong_answer'
     AND status IN ('pending', 'confirmed');

  IF report_count >= 3 THEN
    UPDATE public.mcq_questions
       SET status = 'review'
     WHERE id = NEW.question_id
       AND status = 'active';
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_mcq_reports_autoflag ON public.mcq_question_reports;
CREATE TRIGGER trg_mcq_reports_autoflag
  AFTER INSERT ON public.mcq_question_reports
  FOR EACH ROW EXECUTE FUNCTION public.autoflag_mcq_on_reports();

-- 5) RLS
ALTER TABLE public.mcq_question_reports ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users insert own reports" ON public.mcq_question_reports;
CREATE POLICY "Users insert own reports"
  ON public.mcq_question_reports FOR INSERT
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users view own reports" ON public.mcq_question_reports;
CREATE POLICY "Users view own reports"
  ON public.mcq_question_reports FOR SELECT
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Admins manage reports" ON public.mcq_question_reports;
CREATE POLICY "Admins manage reports"
  ON public.mcq_question_reports FOR ALL
  USING (
    auth.uid() IN (SELECT id FROM public.profiles WHERE role = 'admin')
  );
