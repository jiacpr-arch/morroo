-- Formalize the mcq_questions.detailed_explanation column as a migration.
-- The column was originally added ad-hoc via supabase/add_detailed_explanation.sql
-- and is already used by the answer pages + AI generators; this makes it part of
-- the tracked migration history. Idempotent — safe to re-run.

ALTER TABLE public.mcq_questions
  ADD COLUMN IF NOT EXISTS detailed_explanation jsonb DEFAULT NULL;

-- Format: {
--   "summary": "คำตอบที่ถูกต้อง: D. Midgut volvulus ...",
--   "reason": "อาการอาเจียนสีเขียว (Bilious vomiting) ...",
--   "choices": [
--     {"label": "A", "text": "Intussusception", "is_correct": false, "explanation": "..."},
--     {"label": "D", "text": "Midgut volvulus", "is_correct": true, "explanation": "..."}
--   ],
--   "key_takeaway": "Bilious vomiting ในเด็ก = Red flag ..."
-- }
