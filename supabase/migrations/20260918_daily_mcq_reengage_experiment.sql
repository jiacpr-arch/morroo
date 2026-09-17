-- 1-week A/B test: does ONE regular MCQ card a week bring dormant LINE-linked
-- users back, or just add block risk?
--
-- Cohort is frozen at creation (linked LINE, free plan, no MCQ activity in the
-- last 30 days) and split 50/50:
--   control    — nothing extra (only the 3 weekly broadcasts everyone gets)
--   weekly_mcq — also gets the regular daily MCQ card every Monday 07:00 BKK,
--                sent from /api/line/daily-reminder's Monday run
-- Already-paying and currently-active users are excluded: the question is
-- about winning back dormant free users, not people already converted or
-- already engaged.
--
-- sent_at is stamped on the first Monday send; day 1 of the test starts
-- there. The admin's daily LINE digest shows the running readout and flags
-- day 7. To extend past a week: do nothing (Monday sends keep going). To
-- stop: update experiment_daily_mcq_reengage set variant = 'control'.
--
-- Manual readout:
--   select e.variant,
--          count(*) as cohort,
--          count(*) filter (where p.membership_type <> 'free' and p.membership_expires_at > now()) as converted,
--          count(distinct u.line_user_id) as blocked,
--          count(distinct a.line_user_id) as answered
--   from experiment_daily_mcq_reengage e
--   join profiles p on p.id = e.user_id
--   left join line_unfollow_events u on u.line_user_id = e.line_user_id and u.unfollowed_at >= e.sent_at
--   left join daily_quiz_answers  a on a.line_user_id = e.line_user_id and a.created_at   >= e.sent_at
--   group by e.variant;

create table if not exists experiment_daily_mcq_reengage (
  id           uuid primary key default gen_random_uuid(),
  line_user_id text not null unique,
  user_id      uuid not null references profiles(id) on delete cascade,
  variant      text not null check (variant in ('control', 'weekly_mcq')),
  assigned_at  timestamptz not null default now(),
  sent_at      timestamptz
);

alter table experiment_daily_mcq_reengage enable row level security;
drop policy if exists "Service role only" on experiment_daily_mcq_reengage;
create policy "Service role only" on experiment_daily_mcq_reengage
  for all using (auth.role() = 'service_role');

-- LINE "unfollow" (block / remove friend) events, logged by the webhook so
-- block rate is measurable — per experiment arm here, and in general.
create table if not exists line_unfollow_events (
  id            uuid primary key default gen_random_uuid(),
  line_user_id  text not null,
  unfollowed_at timestamptz not null default now()
);

create index if not exists line_unfollow_events_user_idx
  on line_unfollow_events (line_user_id, unfollowed_at);

alter table line_unfollow_events enable row level security;
drop policy if exists "Service role only" on line_unfollow_events;
create policy "Service role only" on line_unfollow_events
  for all using (auth.role() = 'service_role');

-- One-time cohort freeze. on conflict do nothing keeps re-applies from
-- re-randomizing or growing the cohort once the test has started.
insert into experiment_daily_mcq_reengage (line_user_id, user_id, variant)
select
  p.line_user_id,
  p.id,
  case when random() < 0.5 then 'control' else 'weekly_mcq' end
from profiles p
where p.line_user_id is not null
  and (p.membership_type = 'free' or p.membership_expires_at is null or p.membership_expires_at <= now())
  and p.id not in (
    select user_id from mcq_attempts where created_at > now() - interval '30 days'
  )
  and p.line_user_id not in (
    select line_user_id from daily_quiz_answers where created_at > now() - interval '30 days'
  )
on conflict (line_user_id) do nothing;
