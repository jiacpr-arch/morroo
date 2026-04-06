-- Daily LINE reminder: every day at 00:00 UTC (07:00 ICT / Bangkok time)
-- Requires pg_cron + pg_net extensions enabled in Supabase dashboard
-- and app.site_url / app.blog_generate_secret already set (from blog cron setup)

select cron.schedule(
  'send-daily-line-reminder',
  '0 0 * * *',
  $$
    select net.http_post(
      url := current_setting('app.site_url') || '/api/line/daily-reminder?secret=' || current_setting('app.blog_generate_secret'),
      headers := '{"Content-Type": "application/json"}'::jsonb,
      body := '{}'::jsonb
    );
  $$
);
