-- Web Push subscriptions (PWA notifications) for www.morroo.com.
--
-- One row per browser/device a user opted in on (profile page toggle
-- "แจ้งเตือนบนเครื่องนี้"). endpoint is the push-service URL the browser handed
-- us; it is globally unique, so re-subscribing the same browser upserts the
-- row (and moves it to whoever is logged in now).
--
-- Written by app/api/push/subscribe (user session, RLS applies); read and
-- pruned by lib/push.ts via the service-role client (cron fan-out, deletes
-- rows the push service answers 404/410 for).

CREATE TABLE IF NOT EXISTS push_subscriptions (
  id            uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       uuid        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  endpoint      text        NOT NULL UNIQUE,
  p256dh        text        NOT NULL,
  auth          text        NOT NULL,
  user_agent    text,
  created_at    timestamptz NOT NULL DEFAULT now(),
  last_used_at  timestamptz
);

CREATE INDEX IF NOT EXISTS push_subscriptions_user_idx
  ON push_subscriptions (user_id);

ALTER TABLE push_subscriptions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users read own push_subscriptions" ON push_subscriptions;
CREATE POLICY "Users read own push_subscriptions" ON push_subscriptions FOR SELECT
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users insert own push_subscriptions" ON push_subscriptions;
CREATE POLICY "Users insert own push_subscriptions" ON push_subscriptions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users update own push_subscriptions" ON push_subscriptions;
CREATE POLICY "Users update own push_subscriptions" ON push_subscriptions FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users delete own push_subscriptions" ON push_subscriptions;
CREATE POLICY "Users delete own push_subscriptions" ON push_subscriptions FOR DELETE
  USING (auth.uid() = user_id);
