-- ACLS/BLS pre/post-test assessment tables, migrated from emr-ai-clinic.
--
-- RLS change vs the old project: attempts had anon INSERT **and anon SELECT**
-- there (leaking student names/phones to anyone with the anon key). Here the
-- attempts table has NO anon policies — inserts go through
-- app/api/acls/attempts (service role), and reads are admin/service only.

create table if not exists public.acls_assessment_banks (
  id                 text primary key,
  title              text not null,
  description        text,
  pass_percent       integer not null default 70,
  question_count     integer not null,
  shuffle_questions  boolean not null default true,
  shuffle_choices    boolean not null default false,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now()
);

create table if not exists public.acls_assessment_sets (
  id               text primary key,
  bank_id          text not null references public.acls_assessment_banks(id) on delete cascade,
  title            text not null,
  sort_order       integer not null default 0,
  active           boolean not null default true,
  created_at       timestamptz not null default now(),
  selection_mode   text not null default 'set' check (selection_mode in ('set','pool')),
  selection_config jsonb
);
create index if not exists acls_assessment_sets_bank_idx
  on public.acls_assessment_sets (bank_id, active, sort_order);

create table if not exists public.acls_assessment_questions (
  id          text primary key,
  set_id      text not null references public.acls_assessment_sets(id) on delete cascade,
  q_number    integer not null,
  topic       text not null,
  difficulty  text not null default 'medium',
  question    text not null,
  choices     jsonb not null,
  correct_id  text not null,
  explanation text,
  reference   text,
  active      boolean not null default true,
  created_at  timestamptz not null default now()
);
create index if not exists acls_assessment_questions_set_idx
  on public.acls_assessment_questions (set_id, active, q_number);

create table if not exists public.acls_assessment_attempts (
  id               uuid primary key default gen_random_uuid(),
  student_local_id text,
  student_code     text,
  student_name     text,
  bank_id          text not null,
  set_id           text,
  score            integer not null,
  total_questions  integer not null,
  correct_count    integer not null,
  passed           boolean not null,
  duration_seconds integer,
  answers          jsonb not null,
  started_at       timestamptz,
  finished_at      timestamptz not null default now(),
  created_at       timestamptz not null default now(),
  student_phone    text,
  student_email    text
);
create index if not exists acls_assessment_attempts_bank_idx
  on public.acls_assessment_attempts (bank_id, finished_at desc);
create index if not exists acls_assessment_attempts_student_idx
  on public.acls_assessment_attempts (student_local_id, finished_at desc);

alter table public.acls_assessment_banks     enable row level security;
alter table public.acls_assessment_sets      enable row level security;
alter table public.acls_assessment_questions enable row level security;
alter table public.acls_assessment_attempts  enable row level security;

drop policy if exists acls_assessment_banks_public_read on public.acls_assessment_banks;
create policy acls_assessment_banks_public_read on public.acls_assessment_banks
  for select to anon, authenticated using (true);

drop policy if exists acls_assessment_sets_public_read on public.acls_assessment_sets;
create policy acls_assessment_sets_public_read on public.acls_assessment_sets
  for select to anon, authenticated using (active);

drop policy if exists acls_assessment_questions_public_read on public.acls_assessment_questions;
create policy acls_assessment_questions_public_read on public.acls_assessment_questions
  for select to anon, authenticated using (active);

-- attempts: intentionally no anon/authenticated policies (service role only).
