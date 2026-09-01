-- Auto-generate MCQ questions daily at 02:00 UTC (09:00 ICT)
-- Requires pg_cron + pg_net extensions enabled in Supabase dashboard
-- and app.site_url / app.blog_generate_secret already set

select cron.schedule(
  'auto-generate-daily-mcq',
  '0 2 * * *',
  $$
    select net.http_post(
      url := current_setting('app.site_url') || '/api/mcq/generate-daily?secret=' || current_setting('app.blog_generate_secret'),
      headers := '{"Content-Type": "application/json"}'::jsonb,
      body := '{}'::jsonb
    );
  $$
);
