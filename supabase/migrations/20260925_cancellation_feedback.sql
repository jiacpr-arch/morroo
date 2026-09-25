-- ============================================================
-- cancellation_feedback — "why not renewing" survey + win-back offer
--
-- morroo plans are one-time purchases (Stripe Checkout mode=payment) with a
-- fixed length; nothing auto-renews. When a plan or the 7-day trial runs out
-- the member can tell us why they aren't renewing at /renewal (linked from
-- the profile page and the D+1 expiry LINE/email). Each answer stores the
-- reason, the offer we showed (lib/winback.ts selectWinbackOffer) and whether
-- they took it. A discount offer is a single-use row in coupon_codes
-- (source = 'winback'); a redemption of that coupon at checkout is the
-- "won back" signal (coupon_redemptions.coupon_id = offer_coupon_id).
--
-- Written by app/api/winback (service role, after auth); users can read their
-- own rows and insert their own. Admin view: /admin/winback.
-- Idempotent: safe to re-run.
-- ============================================================

CREATE TABLE IF NOT EXISTS public.cancellation_feedback (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id           uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  source            text NOT NULL DEFAULT 'direct'
    CHECK (source IN ('profile','expiry_line','expiry_email','direct')),
  -- membership_type / expiry at the time of the answer
  last_plan         text,
  access_expires_at timestamptz,
  was_trial         boolean NOT NULL DEFAULT false,
  reason            text NOT NULL
    CHECK (reason IN ('exam_done','too_expensive','not_using','content_mismatch','other')),
  reason_detail     text CHECK (reason_detail IS NULL OR char_length(reason_detail) <= 1000),
  -- offer shown
  offer_kind        text NOT NULL DEFAULT 'none' CHECK (offer_kind IN ('discount','none')),
  offer_percent     integer CHECK (offer_percent IS NULL OR offer_percent BETWEEN 1 AND 100),
  offer_plan        text,
  offer_coupon_id   uuid REFERENCES public.coupon_codes(id) ON DELETE SET NULL,
  offer_coupon_code text,
  offer_expires_at  timestamptz,
  -- member's response to the offer (accepted = went to checkout with the code)
  offer_response    text CHECK (offer_response IS NULL OR offer_response IN ('accepted','declined')),
  responded_at      timestamptz,
  created_at        timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_cancellation_feedback_user
  ON public.cancellation_feedback (user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_cancellation_feedback_created
  ON public.cancellation_feedback (created_at DESC);
CREATE INDEX IF NOT EXISTS idx_cancellation_feedback_coupon
  ON public.cancellation_feedback (offer_coupon_id)
  WHERE offer_coupon_id IS NOT NULL;

ALTER TABLE public.cancellation_feedback ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "cancellation_feedback_select_own" ON public.cancellation_feedback;
CREATE POLICY "cancellation_feedback_select_own"
  ON public.cancellation_feedback FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "cancellation_feedback_insert_own" ON public.cancellation_feedback;
CREATE POLICY "cancellation_feedback_insert_own"
  ON public.cancellation_feedback FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "cancellation_feedback_service_all" ON public.cancellation_feedback;
CREATE POLICY "cancellation_feedback_service_all"
  ON public.cancellation_feedback FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- D+1 win-back reminders are deduped in trial_messages_sent with
-- days_before_expiry = -1 (no schema change needed).
