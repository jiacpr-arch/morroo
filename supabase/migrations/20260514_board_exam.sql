-- ============================================
-- หมอรู้ (MorRoo) — Board Exam (Phase 1: MCQ + ER blueprint)
--
-- เพิ่มเซกเมนต์ "แพทย์เฉพาะทางสอบ board" โดย reuse table เดิม
-- (mcq_subjects, mcq_questions, mcq_attempts, mcq_sessions) + discriminator
-- column `audience` พร้อม CHECK constraint กันข้อมูลปน
-- ============================================

-- ─── 1. Lookup tables ──────────────────────────────────

create table if not exists public.board_specialties (
  slug text primary key,
  name_th text not null,
  name_en text not null,
  short_name_th text,
  icon text default '🩺',
  royal_college text,
  description_th text,
  exam_format text,
  total_mcq_count int,
  display_order int default 0,
  has_long_case boolean default false,
  has_osce boolean default false,
  has_oral boolean default false,
  is_active boolean default true,
  is_published boolean default false,
  created_at timestamptz default now()
);

create table if not exists public.board_subspecialties (
  slug text primary key,
  specialty_slug text not null references public.board_specialties(slug) on delete cascade,
  name_th text not null,
  name_en text not null,
  display_order int default 0
);

create table if not exists public.board_exam_blueprints (
  id uuid primary key default gen_random_uuid(),
  specialty_slug text not null references public.board_specialties(slug) on delete cascade,
  exam_year int not null,
  section_code text not null,
  section_label_th text not null,
  section_label_en text,
  question_count int not null,
  display_order int default 0,
  notes text,
  unique (specialty_slug, exam_year, section_code)
);

create table if not exists public.board_topic_categories (
  id uuid primary key default gen_random_uuid(),
  blueprint_id uuid not null references public.board_exam_blueprints(id) on delete cascade,
  slug text not null,
  name_th text not null,
  name_en text,
  peds_count int default 0,
  adult_count int default 0,
  other_count int default 0,
  total_count int generated always as (peds_count + adult_count + other_count) stored,
  display_order int default 0,
  unique (blueprint_id, slug)
);

-- ─── 2. Extend mcq_subjects ────────────────────────────

alter table public.mcq_subjects
  add column if not exists audience text not null default 'student',
  add column if not exists board_specialty text references public.board_specialties(slug),
  add column if not exists board_subspecialty text references public.board_subspecialties(slug);

alter table public.mcq_subjects
  alter column exam_type drop not null;

-- Replace original CHECK on exam_type with audience-aware constraint
alter table public.mcq_subjects drop constraint if exists mcq_subjects_exam_type_check;
alter table public.mcq_subjects drop constraint if exists mcq_subjects_audience_check;
alter table public.mcq_subjects drop constraint if exists mcq_subjects_audience_consistency;

alter table public.mcq_subjects
  add constraint mcq_subjects_audience_check
    check (audience in ('student','board'));

alter table public.mcq_subjects
  add constraint mcq_subjects_audience_consistency check (
    (audience = 'student' and exam_type in ('NL1','NL2','both') and board_specialty is null)
    or
    (audience = 'board' and board_specialty is not null)
  );

-- ─── 3. Extend mcq_questions ───────────────────────────

alter table public.mcq_questions
  add column if not exists audience text not null default 'student',
  add column if not exists board_specialty text references public.board_specialties(slug),
  add column if not exists board_subspecialty text references public.board_subspecialties(slug),
  add column if not exists board_section text,
  add column if not exists board_topic text,
  add column if not exists board_age_group text,
  add column if not exists board_level int,
  add column if not exists reference_source text;

alter table public.mcq_questions
  alter column exam_type drop not null;

alter table public.mcq_questions drop constraint if exists mcq_questions_exam_type_check;
alter table public.mcq_questions drop constraint if exists mcq_questions_audience_check;
alter table public.mcq_questions drop constraint if exists mcq_questions_audience_consistency;
alter table public.mcq_questions drop constraint if exists mcq_questions_board_age_group_check;
alter table public.mcq_questions drop constraint if exists mcq_questions_board_level_check;

alter table public.mcq_questions
  add constraint mcq_questions_audience_check
    check (audience in ('student','board'));

alter table public.mcq_questions
  add constraint mcq_questions_board_age_group_check
    check (board_age_group is null or board_age_group in ('peds','adult','mixed'));

alter table public.mcq_questions
  add constraint mcq_questions_board_level_check
    check (board_level is null or board_level between 1 and 3);

alter table public.mcq_questions
  add constraint mcq_questions_audience_consistency check (
    (audience = 'student' and exam_type in ('NL1','NL2') and board_specialty is null)
    or
    (audience = 'board' and board_specialty is not null)
  );

-- ─── 4. Extend mcq_sessions to support board sessions ──

alter table public.mcq_sessions
  add column if not exists audience text not null default 'student',
  add column if not exists board_specialty text references public.board_specialties(slug),
  add column if not exists board_section text;

alter table public.mcq_sessions
  alter column exam_type drop not null;

alter table public.mcq_sessions drop constraint if exists mcq_sessions_exam_type_check;
alter table public.mcq_sessions drop constraint if exists mcq_sessions_audience_check;
alter table public.mcq_sessions drop constraint if exists mcq_sessions_audience_consistency;

alter table public.mcq_sessions
  add constraint mcq_sessions_audience_check
    check (audience in ('student','board'));

alter table public.mcq_sessions
  add constraint mcq_sessions_audience_consistency check (
    (audience = 'student' and exam_type in ('NL1','NL2') and board_specialty is null)
    or
    (audience = 'board' and board_specialty is not null)
  );

-- ─── 5. Indexes ────────────────────────────────────────

create index if not exists idx_mcq_subjects_audience on public.mcq_subjects(audience);
create index if not exists idx_mcq_subjects_board_specialty on public.mcq_subjects(board_specialty);
create index if not exists idx_mcq_questions_audience on public.mcq_questions(audience);
create index if not exists idx_mcq_questions_board_specialty on public.mcq_questions(board_specialty);
create index if not exists idx_mcq_questions_board_section on public.mcq_questions(board_section);
create index if not exists idx_mcq_questions_board_topic on public.mcq_questions(board_topic);
create index if not exists idx_mcq_sessions_audience on public.mcq_sessions(audience);
create index if not exists idx_board_topic_blueprint on public.board_topic_categories(blueprint_id);

-- ─── 6. RLS ────────────────────────────────────────────

alter table public.board_specialties enable row level security;
alter table public.board_subspecialties enable row level security;
alter table public.board_exam_blueprints enable row level security;
alter table public.board_topic_categories enable row level security;

drop policy if exists "Board specialties viewable" on public.board_specialties;
create policy "Board specialties viewable"
  on public.board_specialties for select
  using (is_active = true);

drop policy if exists "Board subspecialties viewable" on public.board_subspecialties;
create policy "Board subspecialties viewable"
  on public.board_subspecialties for select
  using (true);

drop policy if exists "Board blueprints viewable" on public.board_exam_blueprints;
create policy "Board blueprints viewable"
  on public.board_exam_blueprints for select
  using (true);

drop policy if exists "Board topic categories viewable" on public.board_topic_categories;
create policy "Board topic categories viewable"
  on public.board_topic_categories for select
  using (true);

-- Admin write access (mirrors mcq admin pattern)
drop policy if exists "Admins manage board_specialties" on public.board_specialties;
create policy "Admins manage board_specialties"
  on public.board_specialties for all
  using (auth.uid() in (select id from public.profiles where role = 'admin'));

drop policy if exists "Admins manage board_subspecialties" on public.board_subspecialties;
create policy "Admins manage board_subspecialties"
  on public.board_subspecialties for all
  using (auth.uid() in (select id from public.profiles where role = 'admin'));

drop policy if exists "Admins manage board_blueprints" on public.board_exam_blueprints;
create policy "Admins manage board_blueprints"
  on public.board_exam_blueprints for all
  using (auth.uid() in (select id from public.profiles where role = 'admin'));

drop policy if exists "Admins manage board_topic_categories" on public.board_topic_categories;
create policy "Admins manage board_topic_categories"
  on public.board_topic_categories for all
  using (auth.uid() in (select id from public.profiles where role = 'admin'));

-- Existing RLS on mcq_subjects / mcq_questions covers the new columns
-- (policies use `using (true)` / `using (status = 'active')`).

-- ─── 7. Backfill existing rows (defensive — should already be default) ─

update public.mcq_subjects set audience = 'student' where audience is null;
update public.mcq_questions set audience = 'student' where audience is null;
update public.mcq_sessions set audience = 'student' where audience is null;
