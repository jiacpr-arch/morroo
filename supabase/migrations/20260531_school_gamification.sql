-- ============================================
-- School gamification — XP, badges, leaderboard
-- ============================================

-- XP column on profiles
alter table public.profiles
  add column if not exists school_xp int default 0;

-- Badge definitions (catalog)
create table if not exists public.school_badges (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  name_th text not null,
  name_en text not null,
  description text,
  icon text default '🏅',
  xp_reward int default 0,
  sort_order int default 0,
  created_at timestamptz default now()
);

-- Badges earned by users
create table if not exists public.school_user_badges (
  user_id uuid not null references auth.users on delete cascade,
  badge_id uuid not null references public.school_badges on delete cascade,
  earned_at timestamptz default now(),
  primary key (user_id, badge_id)
);

-- XP transactions (audit trail)
create table if not exists public.school_xp_events (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users on delete cascade,
  amount int not null,
  reason text not null,
  created_at timestamptz default now()
);

create index if not exists idx_school_xp_events_user on public.school_xp_events(user_id);
create index if not exists idx_profiles_school_xp on public.profiles(school_xp desc);

-- RLS
alter table public.school_badges enable row level security;
alter table public.school_user_badges enable row level security;
alter table public.school_xp_events enable row level security;

create policy "School badges readable by everyone"
  on public.school_badges for select using (true);

create policy "User badges readable by everyone"
  on public.school_user_badges for select using (true);
create policy "Users insert own badges"
  on public.school_user_badges for insert with check (auth.uid() = user_id);

create policy "Users read own XP events"
  on public.school_xp_events for select using (auth.uid() = user_id);
create policy "Users insert own XP events"
  on public.school_xp_events for insert with check (auth.uid() = user_id);

-- Seed badges
insert into public.school_badges (slug, name_th, name_en, description, icon, xp_reward, sort_order) values
  ('first_card',     'การ์ดแรก',           'First Card',         'ทบทวน flashcard 1 ใบแรก',                       '🎴', 5,  10),
  ('streak_3',       'ติด 3 วัน',          '3-day Streak',       'เข้าใช้งานต่อเนื่อง 3 วัน',                       '🔥', 30, 20),
  ('streak_7',       'ติด 1 สัปดาห์',      '7-day Streak',       'เข้าใช้งานต่อเนื่อง 7 วัน',                       '🔥', 70, 30),
  ('streak_30',      'ติด 1 เดือน',        '30-day Streak',      'เข้าใช้งานต่อเนื่อง 30 วัน',                      '🔥', 300, 40),
  ('cards_100',      '100 ใบแรก',         '100 Cards',          'ทบทวน flashcard ครบ 100 ใบ',                      '💯', 50, 50),
  ('cards_500',      '500 ใบ',            '500 Cards',          'ทบทวน flashcard ครบ 500 ใบ',                      '💯', 200, 60),
  ('quiz_50',        'นักทำข้อสอบ',        'Quiz Master',         'ทำ quiz ครบ 50 ข้อ',                              '🧠', 50, 70),
  ('perfect_quiz',   'เต็ม Daily',          'Perfect Daily',       'ทำ Daily Lesson ได้ทุกข้อ',                       '🎯', 30, 80),
  ('first_mastered', 'Mastery แรก',       'First Mastery',       'ได้ ≥80% ใน 1 topic แรก',                          '🏆', 100, 90),
  ('feynman_5',      'Feynman 5 ครั้ง',    '5x Feynman',          'อธิบายให้ AI ตรวจ 5 ครั้ง',                          '🎓', 75, 100),
  ('all_systems',    'ครบทุกระบบ',         'All Systems Touched','ลองทำ flashcard จากทุก 12 ระบบ',                     '🌐', 250, 110),
  ('night_owl',      'นกฮูก',              'Night Owl',           'ใช้งานหลัง 22:00',                                  '🦉', 10, 120),
  ('early_bird',     'นกตื่นเช้า',          'Early Bird',          'ใช้งานก่อน 7:00',                                    '🐦', 10, 130),
  ('challenge_win',  'พิชิต Challenge',    'Challenge Conqueror', 'ทำ Challenge Mode ได้ ≥80%',                       '⚡', 150, 140)
on conflict (slug) do nothing;
