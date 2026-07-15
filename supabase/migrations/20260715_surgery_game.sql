-- ============================================
-- Operation MorRoo (เกมหัตถการ) — operations, runs, badges
-- โครงเดียวกับ 20260712_sim_game.sql ของ Code Blue Sim
-- ============================================

-- ด่านที่แอดมิน/AI สร้าง (built-in อยู่ในโค้ด ไม่ต้องมีแถวที่นี่)
create table if not exists public.surgery_operations (
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
create table if not exists public.surgery_runs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users on delete cascade,
  operation_slug text not null,
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

create index if not exists idx_surgery_runs_user on public.surgery_runs(user_id, created_at desc);
create index if not exists idx_surgery_runs_operation on public.surgery_runs(operation_slug);

-- RLS
alter table public.surgery_operations enable row level security;
alter table public.surgery_runs enable row level security;

create policy "Published surgery operations readable by everyone"
  on public.surgery_operations for select using (status = 'published');

create policy "Users read own surgery runs"
  on public.surgery_runs for select using (auth.uid() = user_id);
create policy "Users insert own surgery runs"
  on public.surgery_runs for insert with check (auth.uid() = user_id);

-- Badges ของเกม (ใช้ catalog + XP engine เดิมของ school)
insert into public.school_badges (slug, name_th, name_en, description, icon, xp_reward, sort_order) values
  ('surgery_first_op',     'หัตถการแรกสำเร็จ',        'First Operation', 'ทำหัตถการสำเร็จครั้งแรกใน Operation MorRoo', '🩹', 50, 180),
  ('surgery_grade_s',      'ศัลยแพทย์เกรด S',         'S-rank Surgeon',  'จบด่านหัตถการด้วยเกรด S',                    '🏆', 100, 190),
  ('surgery_steady_hands', 'มือนิ่ง',                  'Steady Hands',    'จบด่านโดยไม่พลาดสักจังหวะ (โหมดปกติขึ้นไป)',  '🧤', 150, 200)
on conflict (slug) do nothing;
