-- Enable pg_cron and pg_net extensions (must be enabled in Supabase dashboard first)
-- Dashboard → Database → Extensions → enable "pg_cron" and "pg_net"

-- Schedule: every Monday at 01:00 UTC (08:00 ICT)
-- Calls POST /api/blog/generate?secret=<BLOG_GENERATE_SECRET>
-- Replace <YOUR_SITE_URL> and <YOUR_SECRET> with actual values, or use Supabase Vault

select cron.schedule(
  'auto-generate-blog-post',
  '0 1 * * 1',  -- every Monday 01:00 UTC
  $$
    select net.http_post(
      url := current_setting('app.site_url') || '/api/blog/generate?secret=' || current_setting('app.blog_generate_secret'),
      headers := '{"Content-Type": "application/json"}'::jsonb,
      body := '{}'::jsonb
    );
  $$
);

-- Set app config (run once, replace with your values):
-- alter database postgres set "app.site_url" = 'https://www.morroo.com';
-- alter database postgres set "app.blog_generate_secret" = 'your-secret-here';
