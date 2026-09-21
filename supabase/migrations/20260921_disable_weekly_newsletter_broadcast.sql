-- Disable the legacy "send-weekly-newsletter" pg_cron job. It was still firing
-- every Monday 12:00 UTC (19:00 Asia/Bangkok) and broadcasting a plain-text
-- LINE message (app/api/newsletter/send) — the raw "📚 หมอรู้ Weekly" text with
-- bare bullet links — every week since 2026-04.
--
-- Blog announcements on LINE were moved to a single rich carousel in
-- 20260917_line_volume_cuts.sql (vercel.json → /api/cron/line-weekly-blog-digest,
-- Wednesdays), but this older job was never turned off, so followers kept
-- getting the old plain-text broadcast on top of the new carousel every week.
-- It also skips the LINE_AUTOPOST_ENABLED kill switch and the quota check
-- that every other LINE broadcast route now has.
--
-- Already applied to production on 2026-09-21 via cron.alter_job; kept here so
-- the repo describes the live pg_cron state. Idempotent.
select cron.alter_job(
  (select jobid from cron.job where jobname = 'send-weekly-newsletter'),
  active := false
) where exists (
  select 1 from cron.job where jobname = 'send-weekly-newsletter'
);
