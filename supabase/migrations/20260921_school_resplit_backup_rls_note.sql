-- Supabase security advisor `rls_enabled_no_policy` (level INFO) flagged
-- `public.school_lessons_resplit_backup_20260920`: RLS is enabled but no
-- policy exists.
--
-- This is intentional, not a gap — see supabase/school_resplit_backup_20260920.sql
-- (the original one-off script this table was created from). The table backs
-- up school_lessons.body_md before scripts/resplit-lesson-parts.ts rewrites it;
-- it lives in `public` only because scripts/resplit-lesson-parts.ts talks to
-- Supabase over the service-role key, which is restricted to schemas exposed
-- under Settings → API → Exposed schemas. RLS-enabled-with-no-policy denies
-- anon and authenticated entirely; service_role still bypasses RLS as usual,
-- so the script keeps working.
--
-- This migration doesn't change any state (the table + RLS already exist in
-- production, applied 2026-09-20 by the resplit script itself) — it exists so
-- the table's schema and RLS posture are tracked in supabase/migrations/ like
-- every other table, instead of only living in a standalone script.

create table if not exists public.school_lessons_resplit_backup_20260920 (
  id uuid primary key default gen_random_uuid(),
  lesson_id uuid not null references public.school_lessons(id) on delete cascade,
  topic_id uuid,
  layer text,
  title text,
  body_md text not null,
  estimated_min int,
  sort_order int,
  source text,
  status text,
  lesson_created_at timestamptz,
  backed_up_at timestamptz not null default now()
);

create index if not exists school_lessons_resplit_backup_20260920_lesson_id_idx
  on public.school_lessons_resplit_backup_20260920 (lesson_id);

alter table public.school_lessons_resplit_backup_20260920 enable row level security;
-- No policy by design — anon/authenticated get zero access; service_role
-- (this table's only reader/writer, scripts/resplit-lesson-parts.ts) bypasses
-- RLS as usual.
