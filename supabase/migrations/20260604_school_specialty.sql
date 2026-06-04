-- ============================================
-- School Mode — Specialty / Career path ("เลือกสายเฉพาะทางแบบเกม")
-- ============================================
-- Adds two per-user fields on profiles so a student can pick a target
-- specialty ("อาชีพในฝัน") and record interest scores per body system. The
-- radar chart's "power" values are computed at read time from school_progress
-- (real performance) blended with these interest scores — so no extra tables
-- are needed. Both columns are covered by the existing profiles RLS policies.

alter table public.profiles
  add column if not exists target_specialty text,
  -- e.g. {"cardiovascular": 4, "neuro": 5, ...} on a 1–5 interest scale
  add column if not exists specialty_interests jsonb;
