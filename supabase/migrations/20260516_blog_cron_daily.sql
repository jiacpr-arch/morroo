-- Switch blog auto-generation from weekly Monday → daily 12:00 UTC (19:00 ICT).
--
-- 19:00 ICT is peak IG engagement for the Thai med-student / junior-doctor
-- audience (post-rounds wind-down + pre-bed scrolling); the autopost flow
-- inside /api/blog/generate now publishes feed + Story unconditionally
-- (INSTAGRAM_*_AUTOPOST_ENABLED flags removed in PR #159).
--
-- Cron command reads SITE_URL + BLOG_GENERATE_SECRET from vault.decrypted_secrets
-- to match the pattern used by send-daily-line-reminder / auto-generate-meq-exam
-- (managed-Postgres GUCs need superuser, vault works for non-superuser).

select cron.unschedule('auto-generate-blog-post')
where exists (select 1 from cron.job where jobname = 'auto-generate-blog-post');

select cron.schedule(
  'auto-generate-blog-post',
  '0 12 * * *',
  $$
    select net.http_post(
      url := (select decrypted_secret from vault.decrypted_secrets where name = 'SITE_URL')
             || '/api/blog/generate?secret='
             || (select decrypted_secret from vault.decrypted_secrets where name = 'BLOG_GENERATE_SECRET'),
      headers := '{"Content-Type": "application/json"}'::jsonb,
      body := '{}'::jsonb,
      timeout_milliseconds := 300000
    );
  $$
);
