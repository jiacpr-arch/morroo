-- MCQ "ทบทวนข้อที่ผิด" — spaced-repetition queue for NL questions a user got
-- wrong. One row per (user, question) that is still being reviewed.
--
-- Scheduling lives in the app (lib/mcq-review.ts, reusing the School SM-2
-- scheduler in lib/school/srs.ts):
--   * wrong answer anywhere   → row created / reset to a 1-day interval
--   * correct answer when due → interval grows by ease_factor
--   * interval would pass 60d → row deleted ("graduated")
-- Writers: components/McqPractice.tsx (browser, user's own rows via RLS) and
-- lib/daily-mcq-line.ts (service role, LINE daily quiz answers).

create table if not exists public.mcq_review_queue (
  user_id uuid not null references auth.users on delete cascade,
  question_id uuid not null references public.mcq_questions on delete cascade,
  ease_factor numeric not null default 2.5,
  interval_days int not null default 1,
  due_at timestamptz not null,
  lapses int not null default 0,          -- wrong answers after entering the queue
  review_count int not null default 0,    -- scheduled reviews answered (right or wrong)
  last_reviewed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (user_id, question_id)
);

-- "What's due for this user" (page + toggle badge) and "who has anything due"
-- (LINE reminder cron).
create index if not exists idx_mcq_review_queue_user_due
  on public.mcq_review_queue (user_id, due_at);
create index if not exists idx_mcq_review_queue_due
  on public.mcq_review_queue (due_at);

alter table public.mcq_review_queue enable row level security;

drop policy if exists "Users read own mcq review queue" on public.mcq_review_queue;
create policy "Users read own mcq review queue"
  on public.mcq_review_queue for select using (auth.uid() = user_id);
drop policy if exists "Users insert own mcq review queue" on public.mcq_review_queue;
create policy "Users insert own mcq review queue"
  on public.mcq_review_queue for insert with check (auth.uid() = user_id);
drop policy if exists "Users update own mcq review queue" on public.mcq_review_queue;
create policy "Users update own mcq review queue"
  on public.mcq_review_queue for update
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "Users delete own mcq review queue" on public.mcq_review_queue;
create policy "Users delete own mcq review queue"
  on public.mcq_review_queue for delete using (auth.uid() = user_id);

-- Backfill: every student question whose LATEST attempt was wrong enters the
-- queue, due one day after that attempt (so most are due immediately). Without
-- this the mode would sit empty for existing users until they miss something
-- new. Idempotent — existing rows are left alone.
insert into public.mcq_review_queue (user_id, question_id, due_at, created_at)
select l.user_id, l.question_id, l.created_at + interval '1 day', l.created_at
from (
  select distinct on (a.user_id, a.question_id)
    a.user_id, a.question_id, a.is_correct, a.created_at
  from public.mcq_attempts a
  join public.mcq_questions q on q.id = a.question_id
  where a.user_id is not null
    and q.audience = 'student'
  order by a.user_id, a.question_id, a.created_at desc
) l
where l.is_correct = false
on conflict (user_id, question_id) do nothing;

-- Per-user due counts for the LINE reminder cron
-- (app/api/cron/mcq-review-reminder). One bulk query instead of a per-user
-- loop: only LINE-linked users with at least one attempt since p_active_since
-- (long-lapsed users belong to the re-engage campaign, not this one), and
-- only active questions so the count matches what /nl/practice?mode=review
-- actually serves.
create or replace function public.mcq_review_due_counts(
  p_cutoff timestamptz,
  p_active_since timestamptz
)
returns table (user_id uuid, line_user_id text, name text, due_count bigint)
language sql
stable
set search_path = public
as $$
  select p.id, p.line_user_id, p.name, count(*) as due_count
  from public.mcq_review_queue r
  join public.mcq_questions q on q.id = r.question_id and q.status = 'active'
  join public.profiles p on p.id = r.user_id and p.line_user_id is not null
  where r.due_at < p_cutoff
    and exists (
      select 1 from public.mcq_attempts a
      where a.user_id = r.user_id and a.created_at >= p_active_since
    )
  group by p.id, p.line_user_id, p.name;
$$;

-- Cron-only (service role). Never callable from the browser.
revoke all on function public.mcq_review_due_counts(timestamptz, timestamptz) from public, anon, authenticated;
grant execute on function public.mcq_review_due_counts(timestamptz, timestamptz) to service_role;
