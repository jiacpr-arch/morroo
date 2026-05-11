-- Webhook event queue — persists incoming LINE/FB webhook events so they can
-- be retried if processing fails (AI timeout, LINE API down, etc.)

CREATE TABLE IF NOT EXISTS webhook_events (
  id            uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  channel       text        NOT NULL,
  payload       jsonb       NOT NULL,
  attempts      int         NOT NULL DEFAULT 0,
  max_attempts  int         NOT NULL DEFAULT 3,
  status        text        NOT NULL DEFAULT 'pending',
  error         text,
  created_at    timestamptz NOT NULL DEFAULT now(),
  next_retry_at timestamptz NOT NULL DEFAULT now(),
  completed_at  timestamptz
);

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'webhook_events_channel_check') THEN
    ALTER TABLE webhook_events ADD CONSTRAINT webhook_events_channel_check
      CHECK (channel IN ('line', 'facebook'));
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'webhook_events_status_check') THEN
    ALTER TABLE webhook_events ADD CONSTRAINT webhook_events_status_check
      CHECK (status IN ('pending', 'processing', 'done', 'failed'));
  END IF;
END $$;

-- Cron picks up events where status=pending AND next_retry_at <= now()
CREATE INDEX IF NOT EXISTS webhook_events_pending_idx ON webhook_events(next_retry_at)
  WHERE status = 'pending';

-- Allow cleanup queries to find old done/failed events
CREATE INDEX IF NOT EXISTS webhook_events_completed_idx ON webhook_events(completed_at)
  WHERE status IN ('done', 'failed');

ALTER TABLE webhook_events ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Service role full access webhook_events" ON webhook_events;
CREATE POLICY "Service role full access webhook_events" ON webhook_events
  FOR ALL TO service_role USING (true) WITH CHECK (true);
