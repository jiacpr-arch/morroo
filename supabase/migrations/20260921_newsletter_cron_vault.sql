-- send-weekly-newsletter still had its URL + BLOG_GENERATE_SECRET hardcoded in
-- the cron.job command (`https://www.morroo.com/api/newsletter/send?secret=morroo-blog-secret-2026`)
-- instead of reading from vault.decrypted_secrets like every other job rewritten in
-- 20260512_cron_vault_rewrite.sql. That leaked the secret in plaintext to anyone able
-- to SELECT cron.job. Bring it in line with the rest.
--
-- cron.schedule() with an existing jobname updates that job in place (same jobid),
-- it does not create a duplicate.
select cron.schedule(
  'send-weekly-newsletter',
  '0 2 * * 1',
  $$
    select net.http_post(
      url := (select decrypted_secret from vault.decrypted_secrets where name = 'SITE_URL')
             || '/api/newsletter/send?secret='
             || (select decrypted_secret from vault.decrypted_secrets where name = 'BLOG_GENERATE_SECRET'),
      headers := '{"Content-Type": "application/json"}'::jsonb,
      body := '{}'::jsonb
    );
  $$
);
