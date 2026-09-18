-- Cut LINE broadcast volume. Two broadcasts a day to every follower (daily MCQ
-- card + one per new article) was ~14,000 messages/month and hit the OA's
-- "You have reached your monthly limit" in Aug 2026, silently dropping every
-- LINE send for weeks.
--
-- Already applied to production on 2026-09-17 via cron.alter_job; kept here so
-- the repo describes the live pg_cron state. Every statement is idempotent.

-- 1. Daily MCQ card: weekdays only (07:00 Asia/Bangkok = 00:00 UTC).
select cron.alter_job(
  (select jobid from cron.job where jobname = 'send-daily-line-reminder'),
  schedule := '0 0 * * 1-5'
);

-- 2. Retire the legacy in-DB content generators. They duplicated the GitLab
--    CI generators (scripts/generate-*.mjs, see .gitlab-ci.yml) and had been
--    failing every run on "Failed to parse article JSON" — the routes ask
--    Claude for one JSON blob with the whole article inside and the reply
--    gets truncated. Had one ever parsed, it would also have double-posted
--    the article to Facebook and LINE. Disabled, not unscheduled, so they
--    can be inspected or revived.
select cron.alter_job((select jobid from cron.job where jobname = 'auto-generate-blog-post'), active := false);
select cron.alter_job((select jobid from cron.job where jobname = 'auto-generate-meq-exam'),  active := false);
select cron.alter_job((select jobid from cron.job where jobname = 'auto-generate-longcase'),  active := false);

-- 3. Blog announcements on LINE moved from one broadcast per article to a
--    single Monday carousel: vercel.json → /api/cron/line-weekly-blog-digest.
--    scripts/generate-blog.mjs now triggers Facebook only.
