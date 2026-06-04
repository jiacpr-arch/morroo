-- ============================================
-- School Mode — Multiple exam schedule ("ตารางสอบ")
-- ============================================
-- Lets a student record several upcoming exams instead of a single date,
-- each with a topic ("สอบหัวข้ออะไร") and a date ("วันไหน"). Stored as a
-- JSONB array of { "topic": string, "date": "YYYY-MM-DD" } on the profile.
-- The legacy `exam_date` column is kept in sync with the nearest upcoming
-- exam so study-plan generation keeps working unchanged. Covered by the
-- existing profiles RLS policies.

alter table public.profiles
  -- e.g. [{"topic": "ระบบหัวใจและหลอดเลือด", "date": "2026-07-15"}, ...]
  add column if not exists exam_schedule jsonb;
