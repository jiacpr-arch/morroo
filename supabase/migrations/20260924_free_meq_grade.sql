-- ============================================================
-- Free users: AI grading for one MEQ case
-- ============================================================
-- A free user may use AI grading on exactly one free (is_free) MEQ exam — all
-- of that exam's parts. The first graded exam is recorded here; the user_id
-- primary key makes the claim race-free (INSERT … ON CONFLICT DO NOTHING).
-- Written only by the service role from /api/grade.
-- ============================================================

CREATE TABLE IF NOT EXISTS public.free_meq_grades (
  user_id    uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  exam_id    uuid NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.free_meq_grades ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users view own free meq grade" ON public.free_meq_grades;
CREATE POLICY "Users view own free meq grade"
  ON public.free_meq_grades FOR SELECT
  USING (auth.uid() = user_id);
