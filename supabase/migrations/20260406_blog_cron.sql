-- Enable pg_cron and pg_net extensions (must be enabled in Supabase dashboard first)
-- Dashboard → Database → Extensions → enable "pg_cron" and "pg_net"

-- Set app config (run once, replace with your values):
-- alter database postgres set "app.site_url" = 'https://www.morroo.com';
-- alter database postgres set "app.blog_generate_secret" = 'your-secret-here';

-- 1) Auto-generate blog post: every Monday 01:00 UTC (08:00 ICT)
select cron.schedule(
  'auto-generate-blog-post',
  '0 1 * * 1',
  $$
    select net.http_post(
      url := current_setting('app.site_url') || '/api/blog/generate?secret=' || current_setting('app.blog_generate_secret'),
      headers := '{"Content-Type": "application/json"}'::jsonb,
      body := '{}'::jsonb
    );
  $$
);

-- 2) Send weekly newsletter: every Monday 02:00 UTC (09:00 ICT)
select cron.schedule(
  'send-weekly-newsletter',
  '0 2 * * 1',
  $$
    select net.http_post(
      url := current_setting('app.site_url') || '/api/newsletter/send?secret=' || current_setting('app.blog_generate_secret'),
      headers := '{"Content-Type": "application/json"}'::jsonb,
      body := '{}'::jsonb
    );
  $$
);
