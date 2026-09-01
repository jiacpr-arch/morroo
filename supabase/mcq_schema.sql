-- ============================================
-- หมอรู้ (MorRoo) — MCQ Schema สำหรับ NL 1 & 2
-- ============================================

-- ตาราง mcq_subjects (สาขาวิชา)
create table if not exists public.mcq_subjects (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  name_th text not null,
  icon text default '📚',
  exam_type text not null check (exam_type in ('NL1', 'NL2', 'both')),
  question_count int default 0,
  created_at timestamptz default now()
);

-- ตาราง mcq_questions (ข้อสอบ MCQ)
create table if not exists public.mcq_questions (
  id uuid primary key default gen_random_uuid(),
  subject_id uuid references public.mcq_subjects on delete cascade,
  exam_type text not null check (exam_type in ('NL1', 'NL2')),
  exam_source text,                          -- เช่น 'ศรว 2010', 'NL2-CU 2558'
  question_number int,                       -- ลำดับข้อในชุดเดิม
  scenario text not null,                    -- โจทย์ scenario
  choices jsonb not null,                    -- [{"label":"A","text":"..."},{"label":"B","text":"..."}]
  correct_answer text not null,              -- "A", "B", "C", "D", "E"
  explanation text,                          -- คำอธิบายเฉลย
  difficulty text default 'medium' check (difficulty in ('easy', 'medium', 'hard')),
  is_ai_enhanced boolean default false,      -- ข้อนี้ AI ช่วยเติม/แก้ไขหรือไม่
  ai_notes text,                             -- AI แก้ไขอะไรบ้าง
  status text default 'active' check (status in ('active', 'review', 'disabled')),
  created_at timestamptz default now()
);

-- ตาราง mcq_attempts (ประวัติการทำข้อสอบ)
create table if not exists public.mcq_attempts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users on delete cascade,
  question_id uuid references public.mcq_questions on delete cascade,
  selected_answer text not null,
  is_correct boolean not null,
  time_spent_seconds int,                    -- เวลาที่ใช้ (วินาที)
  mode text default 'practice' check (mode in ('practice', 'mock')),
  session_id uuid,                           -- จัดกลุ่มข้อสอบที่ทำพร้อมกัน
  created_at timestamptz default now()
);

-- ตาราง mcq_sessions (รอบการทำข้อสอบ)
create table if not exists public.mcq_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users on delete cascade,
  mode text not null check (mode in ('practice', 'mock')),
  exam_type text not null check (exam_type in ('NL1', 'NL2')),
  subject_id uuid references public.mcq_subjects,  -- null = mixed (mock)
  total_questions int not null,
  correct_count int default 0,
  time_limit_minutes int,                    -- null = ไม่จับเวลา
  completed_at timestamptz,
  created_at timestamptz default now()
);

-- Indexes
create index if not exists idx_mcq_questions_subject on public.mcq_questions(subject_id);
create index if not exists idx_mcq_questions_exam_type on public.mcq_questions(exam_type);
create index if not exists idx_mcq_attempts_user on public.mcq_attempts(user_id);
create index if not exists idx_mcq_attempts_question on public.mcq_attempts(question_id);
create index if not exists idx_mcq_attempts_session on public.mcq_attempts(session_id);
create index if not exists idx_mcq_sessions_user on public.mcq_sessions(user_id);

-- RLS
alter table public.mcq_subjects enable row level security;
alter table public.mcq_questions enable row level security;
alter table public.mcq_attempts enable row level security;
alter table public.mcq_sessions enable row level security;

-- mcq_subjects: ทุกคนดูได้
create policy "MCQ subjects viewable by everyone"
  on public.mcq_subjects for select
  using (true);

-- mcq_questions: active questions ดูได้ทุกคน
create policy "Active MCQ questions viewable by everyone"
  on public.mcq_questions for select
  using (status = 'active');

-- mcq_attempts: ดูได้เฉพาะของตัวเอง
create policy "Users can view own attempts"
  on public.mcq_attempts for select
  using (auth.uid() = user_id);

create policy "Users can insert own attempts"
  on public.mcq_attempts for insert
  with check (auth.uid() = user_id);

-- mcq_sessions: ดูได้เฉพาะของตัวเอง
create policy "Users can view own sessions"
  on public.mcq_sessions for select
  using (auth.uid() = user_id);

create policy "Users can insert own sessions"
  on public.mcq_sessions for insert
  with check (auth.uid() = user_id);

create policy "Users can update own sessions"
  on public.mcq_sessions for update
  using (auth.uid() = user_id);

-- Admin policies
create policy "Admins can manage mcq_subjects"
  on public.mcq_subjects for all
  using (auth.uid() in (select id from public.profiles where role = 'admin'));

create policy "Admins can manage mcq_questions"
  on public.mcq_questions for all
  using (auth.uid() in (select id from public.profiles where role = 'admin'));

-- ============================================
-- Seed: สาขาวิชา
-- ============================================
insert into public.mcq_subjects (name, name_th, icon, exam_type) values
  ('cardio_med', 'อายุรศาสตร์หัวใจ', '❤️', 'NL2'),
  ('chest_med', 'อายุรศาสตร์ทรวงอก', '🫁', 'NL2'),
  ('ent', 'โสต ศอ นาสิก', '👂', 'NL2'),
  ('endocrine', 'ต่อมไร้ท่อ', '🦋', 'NL2'),
  ('eye', 'จักษุวิทยา', '👁️', 'NL2'),
  ('forensic', 'นิติเวชศาสตร์', '🔍', 'NL2'),
  ('gi_med', 'อายุรศาสตร์ทางเดินอาหาร', '🫄', 'NL2'),
  ('gi_ped', 'กุมารเวช ทางเดินอาหาร', '👶', 'NL2'),
  ('gd_ped', 'กุมารเวช พัฒนาการ', '🧒', 'NL2'),
  ('hemato_med', 'โลหิตวิทยา', '🩸', 'NL2'),
  ('hemato_ped', 'กุมารเวช โลหิตวิทยา', '🧬', 'NL2'),
  ('infectious_med', 'โรคติดเชื้อ', '🦠', 'NL2'),
  ('infectious_ped', 'กุมารเวช โรคติดเชื้อ', '🧫', 'NL2'),
  ('nephro_med', 'อายุรศาสตร์ไต', '🫘', 'NL2'),
  ('neuro_med', 'ประสาทวิทยา', '🧠', 'NL2'),
  ('ob_gyn', 'สูติศาสตร์-นรีเวชวิทยา', '🤰', 'NL2'),
  ('ortho', 'ออร์โธปิดิกส์', '🦴', 'NL2'),
  ('ped', 'กุมารเวชศาสตร์', '👶', 'NL2'),
  ('psychi', 'จิตเวชศาสตร์', '🧘', 'NL2'),
  ('surgery', 'ศัลยศาสตร์', '🔪', 'NL2'),
  ('uro_surgery', 'ศัลยศาสตร์ระบบทางเดินปัสสาวะ', '💧', 'NL2'),
  ('epidemio', 'ระบาดวิทยา', '📊', 'NL2'),
  ('chest_ped', 'กุมารเวช ทรวงอก', '🌬️', 'NL2'),
  ('endocrine_ped', 'กุมารเวช ต่อมไร้ท่อ', '⚗️', 'NL2')
on conflict (name) do nothing;
