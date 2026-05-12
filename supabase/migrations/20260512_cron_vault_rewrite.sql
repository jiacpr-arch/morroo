-- Rewrite pg_cron jobs to read SITE_URL + BLOG_GENERATE_SECRET from vault.decrypted_secrets
-- instead of current_setting('app.site_url') / current_setting('app.blog_generate_secret').
--
-- Why: Setting custom GUCs via ALTER DATABASE requires superuser, which we do not have
-- on managed Supabase. Every job below was failing with
--   ERROR: unrecognized configuration parameter "app.site_url"
-- since they were created — including the LINE daily reminder, weekly summary,
-- weekly newsletter, expiry warning, MEQ generator, and longcase generator.
--
-- Prereq: vault must contain two secrets:
--   SITE_URL              (e.g. https://www.morroo.com)
--   BLOG_GENERATE_SECRET  (the shared secret used by /api/*/secret query params)
-- These are managed via the Supabase dashboard → Settings → Vault.

select cron.schedule(
  'send-daily-line-reminder',
  '0 0 * * *',
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
  'auto-generate-meq-exam',
  '0 3 * * 1,4',
  $$
    select net.http_post(
      url := (select decrypted_secret from vault.decrypted_secrets where name = 'SITE_URL')
             || '/api/exams/generate-weekly?secret='
             || (select decrypted_secret from vault.decrypted_secrets where name = 'BLOG_GENERATE_SECRET'),
      headers := '{"Content-Type": "application/json"}'::jsonb,
      body := '{}'::jsonb
    );
  $$
);

select cron.schedule(
  'auto-generate-longcase',
  '0 4 * * 0',
  $$
    select net.http_post(
      url := (select decrypted_secret from vault.decrypted_secrets where name = 'SITE_URL')
             || '/api/longcase/generate-weekly?secret='
             || (select decrypted_secret from vault.decrypted_secrets where name = 'BLOG_GENERATE_SECRET'),
      headers := '{"Content-Type": "application/json"}'::jsonb,
      body := '{}'::jsonb
    );
  $$
);

select cron.schedule(
  'send-expiry-warning',
  '0 2 * * *',
  $$
    select net.http_post(
      url := (select decrypted_secret from vault.decrypted_secrets where name = 'SITE_URL')
             || '/api/line/expiry-warning?secret='
             || (select decrypted_secret from vault.decrypted_secrets where name = 'BLOG_GENERATE_SECRET'),
      headers := '{"Content-Type": "application/json"}'::jsonb,
      body := '{}'::jsonb
    );
  $$
);

select cron.schedule(
  'send-weekly-summary',
  '0 3 * * 0',
  $$
    select net.http_post(
      url := (select decrypted_secret from vault.decrypted_secrets where name = 'SITE_URL')
             || '/api/line/weekly-summary?secret='
             || (select decrypted_secret from vault.decrypted_secrets where name = 'BLOG_GENERATE_SECRET'),
      headers := '{"Content-Type": "application/json"}'::jsonb,
      body := '{}'::jsonb
    );
  $$
);
