-- ============================================
-- Code Blue Sim — scenarios, runs, badges
-- ============================================

-- เคสที่แอดมิน/AI สร้าง (built-in อยู่ในโค้ด ไม่ต้องมีแถวที่นี่)
create table if not exists public.sim_scenarios (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  title text not null,
  subtitle text,
  difficulty_tag text default 'basic',
  status text not null default 'draft' check (status in ('draft', 'published', 'archived')),
  story jsonb not null,
  source text not null default 'manual' check (source in ('manual', 'ai')),
  created_by uuid references auth.users on delete set null,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- ผลการเล่นต่อรอบ (ผูก user จริง — ครู/แอดมินดูสถิติได้)
create table if not exists public.sim_runs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users on delete cascade,
  scenario_slug text not null,
  difficulty text not null,
  won boolean not null,
  grade text not null,
  score int not null default 0,
  wrong_count int not null default 0,
  time_to_cpr_sec int,
  time_to_shock_sec int,
  duration_sec int not null default 0,
  metrics jsonb,
  created_at timestamptz default now()
);

create index if not exists idx_sim_runs_user on public.sim_runs(user_id, created_at desc);
create index if not exists idx_sim_runs_scenario on public.sim_runs(scenario_slug);

-- RLS
alter table public.sim_scenarios enable row level security;
alter table public.sim_runs enable row level security;

create policy "Published sim scenarios readable by everyone"
  on public.sim_scenarios for select using (status = 'published');

create policy "Users read own sim runs"
  on public.sim_runs for select using (auth.uid() = user_id);
create policy "Users insert own sim runs"
  on public.sim_runs for insert with check (auth.uid() = user_id);

-- Badges ของเกม (ใช้ catalog + XP engine เดิมของ school)
insert into public.school_badges (slug, name_th, name_en, description, icon, xp_reward, sort_order) values
  ('sim_first_rosc',  'กู้ชีพสำเร็จครั้งแรก', 'First ROSC',      'พาผู้ป่วยกลับมามีชีพจรใน Code Blue Sim ครั้งแรก', '🚨', 50, 150),
  ('sim_grade_s',     'Team Leader เกรด S',  'S-rank Leader',   'จบเคส Code Blue Sim ด้วยเกรด S',                  '🌟', 100, 160),
  ('sim_no_mistake',  'ไร้ที่ติ',             'Flawless Code',   'จบเคสโดยไม่พลาดสักคำสั่ง (โหมดปกติขึ้นไป)',        '🎖️', 150, 170)
on conflict (slug) do nothing;
