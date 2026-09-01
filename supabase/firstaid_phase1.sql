-- FirstAid Phase 1: learner-core tables migrated into morroo's Supabase.
-- Mirrors jiacpr-arch/firstaid supabase/schema.sql with an fa_ prefix.
-- All tables are service-role-only (RLS on, no anon/authenticated policies):
-- route handlers under app/api/firstaid/* go through the admin client, and
-- anonymous learners have no auth.uid() to write policies against.
--
-- Phase 2/3 (not here): fa_cohorts, fa_enrollments, fa_practical_sessions,
-- fa_attendance, fa_line_nurture_log, lesson-media tables.

create extension if not exists "pgcrypto";

-- ===== LINE Login identity mapping (replaces old line_identities) =====
-- Bridges a LINE userId to a morroo Supabase auth user and the learner's
-- permanent id. Learner data stays keyed by learner_id (anonymous-first);
-- this table is the auth bridge.
create table if not exists fa_learner_links (
  line_user_id  text primary key,
  auth_user_id  uuid not null references auth.users(id) on delete cascade,
  learner_id    uuid not null,
  email         text,
  display_name  text,
  picture_url   text,
  nurture_opted_out    boolean not null default false,
  nurture_opted_out_at timestamptz,
  created_at    timestamptz not null default now()
);
create index if not exists idx_fa_learner_links_learner on fa_learner_links(learner_id);
create index if not exists idx_fa_learner_links_auth on fa_learner_links(auth_user_id);

-- Staging map for identities copied from the old firstaid deployment
-- (line_identities there). No FK to auth.users — the old system's auth users
-- are NOT migrated; instead the LINE callback consults this table on first
-- login, adopts the learner_id, and mints the real fa_learner_links row.
-- Re-copyable any time for the pre-cutover delta.
create table if not exists fa_migrated_learners (
  line_user_id  text primary key,
  learner_id    uuid not null,
  email         text,
  display_name  text,
  picture_url   text,
  nurture_opted_out    boolean not null default false,
  nurture_opted_out_at timestamptz,
  created_at    timestamptz not null default now()
);

create table if not exists fa_lesson_progress (
  id          bigserial primary key,
  learner_id  uuid not null,
  lesson_id   text not null,
  read_at     timestamptz not null,
  unique (learner_id, lesson_id)
);
create index if not exists idx_fa_lesson_progress_learner on fa_lesson_progress(learner_id);

create table if not exists fa_quiz_attempts (
  id           bigserial primary key,
  uuid         uuid not null unique,
  learner_id   uuid not null,
  lesson_id    text not null,
  score        int  not null,
  correct      int,
  total        int,
  passed       boolean,
  finished_at  timestamptz not null
);
create index if not exists idx_fa_quiz_attempts_learner on fa_quiz_attempts(learner_id);

create table if not exists fa_exam_attempts (
  id           bigserial primary key,
  uuid         uuid not null unique,
  learner_id   uuid not null,
  kind         text not null check (kind in ('pre', 'post')),
  score        int  not null,
  correct      int,
  total        int,
  passed       boolean,
  finished_at  timestamptz not null
);
create index if not exists idx_fa_exam_attempts_learner on fa_exam_attempts(learner_id);

create table if not exists fa_simulation_runs (
  id          bigserial primary key,
  uuid        uuid not null unique,
  learner_id  uuid not null,
  scenario_id text not null,
  score       int,
  total       int,
  passed      boolean,
  finished_at timestamptz not null
);
create index if not exists idx_fa_simulation_runs_learner on fa_simulation_runs(learner_id);

create table if not exists fa_certificates (
  id              uuid primary key default gen_random_uuid(),
  learner_id      uuid not null,
  cohort_id       uuid,
  kind            text not null check (kind in ('theory','practical')),
  code            text not null unique,
  issued_at       timestamptz not null default now(),
  learner_name    text,
  learner_phone   text,
  learner_email   text,
  pdpa_consent_at timestamptz,
  location        text,
  source_ref      uuid,
  pdf_url         text,
  revoked_at      timestamptz,
  unique (learner_id, kind)
);

-- Course paywall: per-chapter unlock via voucher code.
-- chapter 0 = whole-course bundle. learner_id is the canonical id from
-- fa_learner_links — a learner must be logged in via LINE before an
-- entitlement can be granted, so purchases survive a device change.
create table if not exists fa_lesson_entitlements (
  learner_id  uuid not null,
  chapter     int  not null default 0 check (chapter between 0 and 4),
  source      text not null check (source in ('voucher', 'admin_grant')),
  order_ref   text,
  granted_at  timestamptz not null default now(),
  primary key (learner_id, chapter)
);
create index if not exists idx_fa_entitlements_learner on fa_lesson_entitlements(learner_id);

create table if not exists fa_vouchers (
  code        text primary key,
  chapter     int  not null default 0 check (chapter between 0 and 4),
  status      text not null default 'active' check (status in ('active', 'redeemed', 'void')),
  price_thb   int,
  redeemed_by uuid,
  redeemed_at timestamptz,
  created_by  uuid references auth.users(id),
  created_at  timestamptz not null default now()
);

-- Practical-course interest leads (learner-facing form, Phase 1).
create table if not exists fa_course_interest (
  id         uuid primary key default gen_random_uuid(),
  learner_id text,
  name       text not null,
  phone      text not null,
  source     text,
  created_at timestamptz not null default now()
);

-- RLS on, no policies: service-role only.
alter table fa_migrated_learners enable row level security;
alter table fa_learner_links enable row level security;
alter table fa_lesson_progress enable row level security;
alter table fa_quiz_attempts enable row level security;
alter table fa_exam_attempts enable row level security;
alter table fa_simulation_runs enable row level security;
alter table fa_certificates enable row level security;
alter table fa_lesson_entitlements enable row level security;
alter table fa_vouchers enable row level security;
alter table fa_course_interest enable row level security;
