-- ============================================
-- Resus Hero (เกมหัตถการกู้ชีพ ACLS) — cases, runs, badges
-- โครงเดียวกับ 20260712_sim_game.sql ของ Code Blue Sim
-- ============================================

-- Cleanup: ร่างแรกของเกมนี้เป็นเกมผ่าตัด (surgery_*) — ถ้าเคยรัน SQL เวอร์ชันนั้น
-- ไปแล้วให้ลบทิ้ง (ตารางยังไม่เคยถูกใช้จริง ไม่มีข้อมูลผู้เล่น)
drop table if exists public.surgery_runs;
drop table if exists public.surgery_operations;
delete from public.school_badges
  where slug in ('surgery_first_op', 'surgery_grade_s', 'surgery_steady_hands');

-- เคสที่แอดมิน/AI สร้าง (built-in อยู่ในโค้ด ไม่ต้องมีแถวที่นี่)
create table if not exists public.resus_cases (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  title text not null,
  subtitle text,
  difficulty_tag text default 'basic',
  status text not null default 'draft' check (status in ('draft', 'published', 'archived')),
  definition jsonb not null,
  source text not null default 'manual' check (source in ('manual', 'ai')),
  created_by uuid references auth.users on delete set null,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- ผลการเล่นต่อรอบ (ผูก user จริง — ครู/แอดมินดูสถิติได้)
create table if not exists public.resus_runs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users on delete cascade,
  case_slug text not null,
  difficulty text not null,
  won boolean not null,
  grade text not null,
  score int not null default 0,
  stars int not null default 0,
  wrong_count int not null default 0,
  duration_sec int not null default 0,
  hp_left int not null default 0,
  metrics jsonb,
  created_at timestamptz default now()
);

create index if not exists idx_resus_runs_user on public.resus_runs(user_id, created_at desc);
create index if not exists idx_resus_runs_case on public.resus_runs(case_slug);

-- RLS
alter table public.resus_cases enable row level security;
alter table public.resus_runs enable row level security;

create policy "Published resus cases readable by everyone"
  on public.resus_cases for select using (status = 'published');

create policy "Users read own resus runs"
  on public.resus_runs for select using (auth.uid() = user_id);
create policy "Users insert own resus runs"
  on public.resus_runs for insert with check (auth.uid() = user_id);

-- Badges ของเกม (ใช้ catalog + XP engine เดิมของ school)
insert into public.school_badges (slug, name_th, name_en, description, icon, xp_reward, sort_order) values
  ('resus_first_save',   'กู้ชีพสำเร็จด้วยมือตัวเอง', 'First Save',    'ช่วยผู้ป่วยรอดครั้งแรกใน Resus Hero',          '🫀', 50, 180),
  ('resus_grade_s',      'มือกู้ชีพเกรด S',           'S-rank Resus',  'จบเคส Resus Hero ด้วยเกรด S',                 '⚡', 100, 190),
  ('resus_perfect_code', 'Perfect Code',              'Perfect Code',  'จบเคสโดยไม่พลาดสักจังหวะ (โหมดปกติขึ้นไป)',    '🏅', 150, 200)
on conflict (slug) do nothing;
