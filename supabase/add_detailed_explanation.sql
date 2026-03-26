-- Add detailed_explanation column to mcq_questions
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
