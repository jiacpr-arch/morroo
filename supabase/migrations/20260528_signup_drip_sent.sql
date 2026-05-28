-- Free-user signup drip tracking
-- Dedupes the D1 / D3 / D7 LINE nudges that re-engage signups who haven't
-- upgraded yet, so a profile receives each touch at most once.

CREATE TABLE IF NOT EXISTS signup_drip_sent (
  profile_id         uuid        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  days_after_signup  int         NOT NULL,
  channel            text        NOT NULL,
  sent_at            timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (profile_id, days_after_signup, channel)
);

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'signup_drip_sent_channel_check'
  ) THEN
    ALTER TABLE signup_drip_sent ADD CONSTRAINT signup_drip_sent_channel_check
      CHECK (channel IN ('line','email','messenger'));
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS signup_drip_sent_sent_at_idx
  ON signup_drip_sent(sent_at DESC);

ALTER TABLE signup_drip_sent ENABLE ROW LEVEL SECURITY;
-- service-role-only; no public policies (cron writes via createAdminClient).
