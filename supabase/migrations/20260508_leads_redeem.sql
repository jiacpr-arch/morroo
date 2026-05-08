-- Lead Ads + Redeem Code system
--
-- Most of the schema below was applied directly to the database before this
-- migration existed (leads, redeem_codes, lead_messages_sent, lead_chat_state
-- were created and RLS policies attached). This file is the canonical source
-- of truth: every statement is idempotent so it's safe on environments where
-- the schema is already partially in place.

-- ─── leads ───────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS leads (
  id              uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  source          text        NOT NULL,
  campaign        text,
  ad_set          text,
  fb_lead_id      text        UNIQUE,
  fb_psid         text,
  line_user_id    text,
  email           text,
  phone           text,
  name            text,
  status_year     text,
  exam_target     text,
  reward_choice   text,
  stage           text        NOT NULL DEFAULT 'new',
  user_id         uuid        REFERENCES auth.users(id) ON DELETE SET NULL,
  consent_pdpa    boolean     NOT NULL DEFAULT false,
  consent_at      timestamptz,
  raw_payload     jsonb,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'leads_source_check') THEN
    ALTER TABLE leads ADD CONSTRAINT leads_source_check
      CHECK (source IN ('fb_leadgen_form','fb_messenger','landing','organic','admin'));
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'leads_stage_check') THEN
    ALTER TABLE leads ADD CONSTRAINT leads_stage_check
      CHECK (stage IN ('new','contacted','code_issued','registered','redeemed','paid','dropped'));
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'leads_reward_choice_check') THEN
    ALTER TABLE leads ADD CONSTRAINT leads_reward_choice_check
      CHECK (reward_choice IS NULL OR reward_choice IN ('monthly_1m','bundle_10q'));
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'leads_exam_target_check') THEN
    ALTER TABLE leads ADD CONSTRAINT leads_exam_target_check
      CHECK (exam_target IS NULL OR exam_target IN ('NL1','NL2','both','unknown'));
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS leads_stage_idx ON leads(stage);
CREATE INDEX IF NOT EXISTS leads_source_idx ON leads(source);
CREATE INDEX IF NOT EXISTS leads_email_idx ON leads(email);
CREATE INDEX IF NOT EXISTS leads_created_at_idx ON leads(created_at DESC);

ALTER TABLE leads ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Admins read all leads" ON leads;
CREATE POLICY "Admins read all leads" ON leads FOR SELECT
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));

DROP POLICY IF EXISTS "Admins update leads" ON leads;
CREATE POLICY "Admins update leads" ON leads FOR UPDATE
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));

-- ─── redeem_codes ────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS redeem_codes (
  code              text        PRIMARY KEY,
  reward_type       text        NOT NULL,
  source            text        NOT NULL,
  campaign          text,
  lead_id           uuid        REFERENCES leads(id) ON DELETE SET NULL,
  issued_to_email   text,
  redeemed_by       uuid        REFERENCES auth.users(id) ON DELETE SET NULL,
  redeemed_at       timestamptz,
  expires_at        timestamptz NOT NULL,
  stripe_coupon_id  text,
  created_at        timestamptz NOT NULL DEFAULT now()
);

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'redeem_codes_reward_type_check') THEN
    ALTER TABLE redeem_codes ADD CONSTRAINT redeem_codes_reward_type_check
      CHECK (reward_type IN ('monthly_1m','bundle_10q'));
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS redeem_codes_lead_id_idx ON redeem_codes(lead_id);
CREATE INDEX IF NOT EXISTS redeem_codes_redeemed_by_idx ON redeem_codes(redeemed_by);
CREATE INDEX IF NOT EXISTS redeem_codes_email_idx ON redeem_codes(issued_to_email);

ALTER TABLE redeem_codes ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Admins read all redeem codes" ON redeem_codes;
CREATE POLICY "Admins read all redeem codes" ON redeem_codes FOR SELECT
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));

DROP POLICY IF EXISTS "Users view own redeemed code" ON redeem_codes;
CREATE POLICY "Users view own redeemed code" ON redeem_codes FOR SELECT
  USING (redeemed_by = auth.uid());

-- ─── lead_messages_sent ──────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS lead_messages_sent (
  lead_id   uuid        NOT NULL REFERENCES leads(id) ON DELETE CASCADE,
  day       int         NOT NULL,
  channel   text        NOT NULL,
  sent_at   timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (lead_id, day, channel)
);

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'lead_messages_sent_channel_check') THEN
    ALTER TABLE lead_messages_sent ADD CONSTRAINT lead_messages_sent_channel_check
      CHECK (channel IN ('email','messenger','line'));
  END IF;
END $$;

ALTER TABLE lead_messages_sent ENABLE ROW LEVEL SECURITY;
-- service-role-only; no public policies

-- ─── lead_chat_state ─────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS lead_chat_state (
  psid          text        PRIMARY KEY,
  step          text        NOT NULL,
  partial_data  jsonb       NOT NULL DEFAULT '{}'::jsonb,
  campaign      text,
  ad_set        text,
  updated_at    timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE lead_chat_state ENABLE ROW LEVEL SECURITY;
-- service-role-only; no public policies

-- ─── bundle_credits (ledger) ─────────────────────────────────────────────
-- Each row is a delta. Balance = SUM(delta) WHERE user_id = $1.
-- Positive deltas come from redeem codes / purchases; negative from usage.
CREATE TABLE IF NOT EXISTS bundle_credits (
  id           uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      uuid        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  delta        int         NOT NULL,
  source       text        NOT NULL,
  reference    text,
  created_at   timestamptz NOT NULL DEFAULT now()
);

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'bundle_credits_source_check') THEN
    ALTER TABLE bundle_credits ADD CONSTRAINT bundle_credits_source_check
      CHECK (source IN ('redeem','purchase','use','adjustment'));
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS bundle_credits_user_id_idx ON bundle_credits(user_id);
CREATE INDEX IF NOT EXISTS bundle_credits_reference_idx ON bundle_credits(reference);

ALTER TABLE bundle_credits ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users read own bundle credits" ON bundle_credits;
CREATE POLICY "Users read own bundle credits" ON bundle_credits FOR SELECT
  USING (user_id = auth.uid());

DROP POLICY IF EXISTS "Admins read all bundle credits" ON bundle_credits;
CREATE POLICY "Admins read all bundle credits" ON bundle_credits FOR SELECT
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));
