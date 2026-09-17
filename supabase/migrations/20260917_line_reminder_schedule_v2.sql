-- LINE reminder schedule v2 (spacing/relevance research: broadcast only what's
-- worth everyone's attention, push the rest to people who actually engage).
--
--   Mon-Thu 07:00 BKK  push  daily MCQ            -> active players only
--   Fri     07:00 BKK  push  weekly hard question -> active players only
--   Wed     12:00 BKK  broadcast  weekly blog digest (moved off Monday,
--                                 which collided with the daily MCQ slot)
--   Sat     09:00 BKK  broadcast  MEQ/long-case casegame teaser
--   Sun     19:00 BKK  broadcast  new long case + weekly recap
--
-- All hit /api/line/daily-reminder, which branches on day-of-week; see that
-- route for the actual content per day. Already applied to production on
-- 2026-09-17 via cron.schedule / cron.alter_job; kept here so the repo
-- describes the live pg_cron state. Every statement is idempotent.

-- Weekly "hard question" pick, same deterministic-per-date approach as
-- get_daily_mcq so Friday's card is stable if the route is retried.
create or replace function get_weekly_hard_mcq(p_date date default quiz_date_bangkok())
returns table(id uuid, scenario text, difficulty text, subject_id uuid, subject_name_th text, subject_icon text, exam_type text, quiz_date date)
language sql
stable security definer
as $$
  select
    q.id,
    q.scenario,
    q.difficulty::text,
    q.subject_id,
    s.name_th as subject_name_th,
    s.icon    as subject_icon,
    q.exam_type::text,
    p_date    as quiz_date
  from mcq_questions q
  join mcq_subjects  s on s.id = q.subject_id
  where q.status = 'active'
    and q.audience = 'student'
    and q.exam_type in ('NL1', 'NL2')
    and q.difficulty = 'hard'
  order by md5(q.id::text || p_date::text)
  limit 1;
$$;

-- send-daily-line-reminder already covers Mon-Fri 07:00 (set in the previous
-- migration); this just documents it stays as-is under the new v2 content.
select cron.alter_job(
  (select jobid from cron.job where jobname = 'send-daily-line-reminder'),
  schedule := '0 0 * * 1-5'
);

select cron.schedule(
  'send-saturday-casegame',
  '0 2 * * 6',
  $$
    select net.http_post(
      url := (select decrypted_secret from vault.decrypted_secrets where name = 'SITE_URL')
             || '/api/line/daily-reminder?secret='
             || (select decrypted_secret from vault.decrypted_secrets where name = 'BLOG_GENERATE_SECRET'),
      headers := '{"Content-Type": "application/json"}'::jsonb,
      body := '{}'::jsonb
    );
  $$
);

select cron.schedule(
  'send-sunday-longcase',
  '0 12 * * 0',
  $$
    select net.http_post(
      url := (select decrypted_secret from vault.decrypted_secrets where name = 'SITE_URL')
             || '/api/line/daily-reminder?secret='
             || (select decrypted_secret from vault.decrypted_secrets where name = 'BLOG_GENERATE_SECRET'),
      headers := '{"Content-Type": "application/json"}'::jsonb,
      body := '{}'::jsonb
    );
  $$
);
