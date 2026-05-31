-- school_streaks table — was defined in Phase 1 schema file but not applied
-- in the original migration. Adding it now so streak tracking works.

create table if not exists public.school_streaks (
  user_id uuid primary key references auth.users on delete cascade,
  current_streak int default 0,
  longest_streak int default 0,
  last_active_date date,
  updated_at timestamptz default now()
);

alter table public.school_streaks enable row level security;

create policy "Users read own school streak"
  on public.school_streaks for select using (auth.uid() = user_id);
create policy "Users upsert own school streak"
  on public.school_streaks for insert with check (auth.uid() = user_id);
create policy "Users update own school streak"
  on public.school_streaks for update using (auth.uid() = user_id);
