-- Auto-generate MEQ exams: Monday + Thursday at 03:00 UTC (10:00 ICT)
select cron.schedule(
  'auto-generate-meq-exam',
  '0 3 * * 1,4',
  $$
    select net.http_post(
      url := current_setting('app.site_url') || '/api/exams/generate-weekly?secret=' || current_setting('app.blog_generate_secret'),
      headers := '{"Content-Type": "application/json"}'::jsonb,
      body := '{}'::jsonb
    );
  $$
);

-- Auto-generate Long Case: Sunday at 04:00 UTC (11:00 ICT)
select cron.schedule(
  'auto-generate-longcase',
  '0 4 * * 0',
  $$
    select net.http_post(
      url := current_setting('app.site_url') || '/api/longcase/generate-weekly?secret=' || current_setting('app.blog_generate_secret'),
      headers := '{"Content-Type": "application/json"}'::jsonb,
      body := '{}'::jsonb
    );
  $$
);
