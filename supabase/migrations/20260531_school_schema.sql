-- ============================================
-- หมอรู้ (MorRoo) — School Mode (Y1–Y6 Micro-Learning)
-- ============================================
-- Phase 1 MVP: Cell Biology block (Y1)

-- ----------------------------------------------
-- 1. Curriculum structure
-- ----------------------------------------------
create table if not exists public.school_systems (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  name_th text not null,
  name_en text not null,
  icon text default '📚',
  sort_order int default 0,
  created_at timestamptz default now()
);

create table if not exists public.school_topics (
  id uuid primary key default gen_random_uuid(),
  system_id uuid not null references public.school_systems on delete cascade,
  year smallint not null check (year between 1 and 6),
  slug text not null,
  name_th text not null,
  name_en text not null,
  summary text,
  sort_order int default 0,
  created_at timestamptz default now(),
  unique (system_id, year, slug)
);

-- ----------------------------------------------
-- 2. Atomic content units
-- ----------------------------------------------
-- Layer values: anatomy | physio | biochem | path | pharm | clinical | foundation
create table if not exists public.school_flashcards (
  id uuid primary key default gen_random_uuid(),
  topic_id uuid not null references public.school_topics on delete cascade,
  layer text not null,
  front text not null,
  back text not null,
  image_url text,
  difficulty text default 'medium' check (difficulty in ('easy', 'medium', 'hard')),
  source text,                               -- e.g. "PCCMS Y1 Cell Biology lecture 1"
  status text default 'active' check (status in ('active', 'review', 'disabled')),
  created_at timestamptz default now()
);

create table if not exists public.school_lessons (
  id uuid primary key default gen_random_uuid(),
  topic_id uuid not null references public.school_topics on delete cascade,
  layer text not null,
  title text not null,
  body_md text not null,
  estimated_min int default 5,
  sort_order int default 0,
  source text,
  status text default 'active' check (status in ('active', 'review', 'disabled')),
  created_at timestamptz default now()
);

create table if not exists public.school_quizzes (
  id uuid primary key default gen_random_uuid(),
  topic_id uuid not null references public.school_topics on delete cascade,
  layer text not null,
  stem text not null,
  choices jsonb not null,                    -- [{"label":"A","text":"..."}, ...]
  correct_answer text not null,              -- "A" | "B" | ...
  explanation text,
  difficulty text default 'medium' check (difficulty in ('easy', 'medium', 'hard')),
  source text,
  status text default 'active' check (status in ('active', 'review', 'disabled')),
  created_at timestamptz default now()
);

-- ----------------------------------------------
-- 3. Progress + sessions
-- ----------------------------------------------
-- Simple per-unit progress for MVP. SRS scheduling fields are present but
-- only updated by background jobs in a later phase.
create table if not exists public.school_progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users on delete cascade,
  unit_type text not null check (unit_type in ('flashcard', 'lesson', 'quiz')),
  unit_id uuid not null,
  outcome text not null check (outcome in ('again', 'hard', 'good', 'easy', 'correct', 'wrong')),
  ease_factor numeric default 2.5,
  interval_days int default 1,
  due_at timestamptz,
  reviewed_at timestamptz default now(),
  created_at timestamptz default now()
);

create table if not exists public.school_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users on delete cascade,
  mode text not null check (mode in ('flashcards', 'quiz', 'daily', 'review')),
  topic_id uuid references public.school_topics,
  units_seen int default 0,
  units_correct int default 0,
  started_at timestamptz default now(),
  completed_at timestamptz
);

-- ----------------------------------------------
-- 4. Profile additions
-- ----------------------------------------------
alter table public.profiles
  add column if not exists current_year smallint check (current_year between 1 and 6),
  add column if not exists school_daily_goal int default 20;

-- New membership SKUs (membership_type is a text column, no enum to alter)
-- The application layer (lib/membership.ts) is responsible for validating
-- new values: 'school_monthly', 'school_yearly'.

-- ----------------------------------------------
-- 5. Indexes
-- ----------------------------------------------
create index if not exists idx_school_topics_year on public.school_topics(year);
create index if not exists idx_school_topics_system on public.school_topics(system_id);
create index if not exists idx_school_flashcards_topic on public.school_flashcards(topic_id);
create index if not exists idx_school_quizzes_topic on public.school_quizzes(topic_id);
create index if not exists idx_school_lessons_topic on public.school_lessons(topic_id);
create index if not exists idx_school_progress_user_unit on public.school_progress(user_id, unit_type, unit_id);
create index if not exists idx_school_progress_due on public.school_progress(user_id, due_at);
create index if not exists idx_school_sessions_user on public.school_sessions(user_id);

-- ----------------------------------------------
-- 6. Row-level security
-- ----------------------------------------------
alter table public.school_systems enable row level security;
alter table public.school_topics enable row level security;
alter table public.school_flashcards enable row level security;
alter table public.school_lessons enable row level security;
alter table public.school_quizzes enable row level security;
alter table public.school_progress enable row level security;
alter table public.school_sessions enable row level security;

-- Catalog tables: readable by everyone
create policy "School systems readable by everyone"
  on public.school_systems for select using (true);
create policy "School topics readable by everyone"
  on public.school_topics for select using (true);
create policy "Active school flashcards readable by everyone"
  on public.school_flashcards for select using (status = 'active');
create policy "Active school lessons readable by everyone"
  on public.school_lessons for select using (status = 'active');
create policy "Active school quizzes readable by everyone"
  on public.school_quizzes for select using (status = 'active');

-- Progress + sessions: per-user
create policy "Users read own school progress"
  on public.school_progress for select using (auth.uid() = user_id);
create policy "Users insert own school progress"
  on public.school_progress for insert with check (auth.uid() = user_id);
create policy "Users update own school progress"
  on public.school_progress for update using (auth.uid() = user_id);

create policy "Users read own school sessions"
  on public.school_sessions for select using (auth.uid() = user_id);
create policy "Users insert own school sessions"
  on public.school_sessions for insert with check (auth.uid() = user_id);
create policy "Users update own school sessions"
  on public.school_sessions for update using (auth.uid() = user_id);

-- Admin override on catalog tables
create policy "Admins manage school_systems"
  on public.school_systems for all
  using (auth.uid() in (select id from public.profiles where role = 'admin'));
create policy "Admins manage school_topics"
  on public.school_topics for all
  using (auth.uid() in (select id from public.profiles where role = 'admin'));
create policy "Admins manage school_flashcards"
  on public.school_flashcards for all
  using (auth.uid() in (select id from public.profiles where role = 'admin'));
create policy "Admins manage school_lessons"
  on public.school_lessons for all
  using (auth.uid() in (select id from public.profiles where role = 'admin'));
create policy "Admins manage school_quizzes"
  on public.school_quizzes for all
  using (auth.uid() in (select id from public.profiles where role = 'admin'));

-- ----------------------------------------------
-- 7. Seed: foundation system + cell biology topic (Y1)
-- ----------------------------------------------
insert into public.school_systems (slug, name_th, name_en, icon, sort_order) values
  ('foundation',   'พื้นฐานวิทยาศาสตร์การแพทย์', 'Foundation',     '🧬', 0),
  ('cardiovascular','ระบบหัวใจและหลอดเลือด',   'Cardiovascular','❤️', 10),
  ('respiratory',  'ระบบทางเดินหายใจ',          'Respiratory',    '🫁', 20),
  ('gi',           'ระบบทางเดินอาหาร',          'Gastrointestinal','🫄', 30),
  ('renal',        'ระบบไตและทางเดินปัสสาวะ',  'Renal',           '🫘', 40),
  ('neuro',        'ระบบประสาท',                'Neuroscience',    '🧠', 50),
  ('endocrine',    'ระบบต่อมไร้ท่อ',            'Endocrine',       '🦋', 60),
  ('msk',          'ระบบกล้ามเนื้อและกระดูก',  'Musculoskeletal', '🦴', 70),
  ('repro',        'ระบบสืบพันธุ์',             'Reproductive',    '👶', 80),
  ('heme',         'ระบบโลหิตวิทยา',           'Hematology',      '🩸', 90),
  ('id',           'โรคติดเชื้อและภูมิคุ้มกัน','Infectious & Immunology','🦠',100),
  ('psych',        'จิตเวชและพฤติกรรมศาสตร์',  'Psychiatry',      '🧘',110)
on conflict (slug) do nothing;

insert into public.school_topics (system_id, year, slug, name_th, name_en, summary, sort_order)
select
  s.id, 1, 'cell-biology',
  'ชีววิทยาของเซลล์',
  'Cell Biology',
  'พื้นฐานโครงสร้างและหน้าที่ของเซลล์ — organelles, membrane, signaling, cell cycle',
  0
from public.school_systems s where s.slug = 'foundation'
on conflict (system_id, year, slug) do nothing;
