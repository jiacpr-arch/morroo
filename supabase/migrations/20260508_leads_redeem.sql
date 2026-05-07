-- ============================================================
-- Lead capture + redeem code system (FB Lead Ads campaign)
-- ============================================================
-- Adds:
--   * leads                — captured leads from FB Instant Form / Messenger / landing
--   * redeem_codes         — single-use codes that grant Monthly trial or Bundle
--   * lead_messages_sent   — idempotency for the multi-channel follow-up sequence
--   * lead_chat_state      — Messenger scripted-flow state machine
-- Idempotent: safe to re-run.
-- ============================================================

-- ----- leads -----
CREATE TABLE IF NOT EXISTS public.leads (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  source text NOT NULL CHECK (source IN (
    'fb_leadgen_form','fb_messenger','landing','organic','admin'
  )),
  campaign text,
  ad_set text,
  fb_lead_id text UNIQUE,
  fb_psid text,
  line_user_id text,
  email text,
  phone text,
  name text,
  status_year text,
  exam_target text CHECK (exam_target IN ('NL1','NL2','both','unknown') OR exam_target IS NULL),
  reward_choice text CHECK (reward_choice IN ('monthly_1m','bundle_10q')),
  stage text NOT NULL DEFAULT 'new' CHECK (stage IN (
    'new','contacted','code_issued','registered','redeemed','paid','dropped'
  )),
  user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  consent_pdpa boolean NOT NULL DEFAULT false,
  consent_at timestamptz,
  raw_payload jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_leads_stage ON public.leads(stage);
CREATE INDEX IF NOT EXISTS idx_leads_email ON public.leads(email);
CREATE INDEX IF NOT EXISTS idx_leads_psid ON public.leads(fb_psid);
CREATE INDEX IF NOT EXISTS idx_leads_line ON public.leads(line_user_id);
CREATE INDEX IF NOT EXISTS idx_leads_campaign ON public.leads(campaign, ad_set);
CREATE INDEX IF NOT EXISTS idx_leads_created ON public.leads(created_at DESC);

ALTER TABLE public.leads ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Admins read all leads" ON public.leads;
CREATE POLICY "Admins read all leads"
  ON public.leads FOR SELECT
  USING (auth.uid() IN (SELECT id FROM public.profiles WHERE role = 'admin'));

DROP POLICY IF EXISTS "Admins update leads" ON public.leads;
CREATE POLICY "Admins update leads"
  ON public.leads FOR UPDATE
  USING (auth.uid() IN (SELECT id FROM public.profiles WHERE role = 'admin'));

-- ----- redeem_codes -----
CREATE TABLE IF NOT EXISTS public.redeem_codes (
  code text PRIMARY KEY,
  reward_type text NOT NULL CHECK (reward_type IN ('monthly_1m','bundle_10q')),
  source text NOT NULL,
  campaign text,
  lead_id uuid REFERENCES public.leads(id) ON DELETE SET NULL,
  issued_to_email text,
  redeemed_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  redeemed_at timestamptz,
  expires_at timestamptz NOT NULL,
  stripe_coupon_id text,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_redeem_codes_lead ON public.redeem_codes(lead_id);
CREATE INDEX IF NOT EXISTS idx_redeem_codes_email ON public.redeem_codes(issued_to_email);
CREATE INDEX IF NOT EXISTS idx_redeem_codes_expires ON public.redeem_codes(expires_at);

-- Prevent duplicate codes per (lead, reward_type)
CREATE UNIQUE INDEX IF NOT EXISTS uq_redeem_codes_lead_reward
  ON public.redeem_codes(lead_id, reward_type)
  WHERE lead_id IS NOT NULL;

-- A user can only redeem one code total (1 reward per account)
CREATE UNIQUE INDEX IF NOT EXISTS uq_redeem_codes_redeemed_by
  ON public.redeem_codes(redeemed_by)
  WHERE redeemed_by IS NOT NULL;

ALTER TABLE public.redeem_codes ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users view own redeemed code" ON public.redeem_codes;
CREATE POLICY "Users view own redeemed code"
  ON public.redeem_codes FOR SELECT
  USING (auth.uid() = redeemed_by);

DROP POLICY IF EXISTS "Admins read all redeem codes" ON public.redeem_codes;
CREATE POLICY "Admins read all redeem codes"
  ON public.redeem_codes FOR SELECT
  USING (auth.uid() IN (SELECT id FROM public.profiles WHERE role = 'admin'));

-- ----- lead_messages_sent -----
CREATE TABLE IF NOT EXISTS public.lead_messages_sent (
  lead_id uuid NOT NULL REFERENCES public.leads(id) ON DELETE CASCADE,
  day int NOT NULL,
  channel text NOT NULL CHECK (channel IN ('email','messenger','line')),
  sent_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (lead_id, day, channel)
);

CREATE INDEX IF NOT EXISTS idx_lead_messages_sent_at ON public.lead_messages_sent(sent_at DESC);

ALTER TABLE public.lead_messages_sent ENABLE ROW LEVEL SECURITY;

-- ----- lead_chat_state (Messenger scripted-flow state machine) -----
CREATE TABLE IF NOT EXISTS public.lead_chat_state (
  psid text PRIMARY KEY,
  step text NOT NULL,
  partial_data jsonb NOT NULL DEFAULT '{}'::jsonb,
  campaign text,
  ad_set text,
  updated_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.lead_chat_state ENABLE ROW LEVEL SECURITY;

-- ----- updated_at trigger for leads -----
CREATE OR REPLACE FUNCTION public.touch_leads_updated_at()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_leads_touch_updated_at ON public.leads;
CREATE TRIGGER trg_leads_touch_updated_at
  BEFORE UPDATE ON public.leads
  FOR EACH ROW EXECUTE FUNCTION public.touch_leads_updated_at();
