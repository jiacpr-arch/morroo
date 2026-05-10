-- Trial-to-paid conversion email tracking
-- Dedupes the D-3 / D-1 reminder cron so a profile receives each email at most once.

CREATE TABLE IF NOT EXISTS trial_messages_sent (
  profile_id           uuid        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  days_before_expiry   int         NOT NULL,
  channel              text        NOT NULL,
  sent_at              timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (profile_id, days_before_expiry, channel)
);

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'trial_messages_sent_channel_check'
  ) THEN
    ALTER TABLE trial_messages_sent ADD CONSTRAINT trial_messages_sent_channel_check
      CHECK (channel IN ('email','line','messenger'));
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS trial_messages_sent_sent_at_idx
  ON trial_messages_sent(sent_at DESC);

ALTER TABLE trial_messages_sent ENABLE ROW LEVEL SECURITY;
-- service-role-only; no public policies (cron writes via createAdminClient).
