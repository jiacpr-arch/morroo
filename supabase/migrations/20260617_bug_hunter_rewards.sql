-- ============================================================
-- Bug Hunter rewards — redeem reporter points for free membership
-- ============================================================
-- The Bug Hunter program (see 20260415_mcq_question_reports.sql) awards
-- profiles.reporter_points: +1 per report, +10 when an admin confirms a
-- report is a genuine bug. This migration lets students *spend* those points
-- on free membership days, and tracks the spend so the available balance is
--     available = reporter_points - reporter_points_spent.
-- ============================================================

-- 1) Running total of points already spent on rewards.
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS reporter_points_spent int NOT NULL DEFAULT 0;

-- 2) Ledger of redemptions (audit trail; one row per redeem).
CREATE TABLE IF NOT EXISTS public.reporter_point_redemptions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  points_spent int NOT NULL CHECK (points_spent > 0),
  reward_days int NOT NULL CHECK (reward_days > 0),
  membership_expires_at timestamptz, -- new expiry after applying the reward
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_reporter_redemptions_user
  ON public.reporter_point_redemptions(user_id);

ALTER TABLE public.reporter_point_redemptions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users view own redemptions" ON public.reporter_point_redemptions;
CREATE POLICY "Users view own redemptions"
  ON public.reporter_point_redemptions FOR SELECT
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Admins manage redemptions" ON public.reporter_point_redemptions;
CREATE POLICY "Admins manage redemptions"
  ON public.reporter_point_redemptions FOR ALL
  USING (auth.uid() IN (SELECT id FROM public.profiles WHERE role = 'admin'));

-- 3) Atomic redeem: validate the balance, spend points, extend membership.
--    Returns jsonb { ok, error?, new_balance?, membership_expires_at? }.
--    SECURITY DEFINER + a row lock make concurrent redeems double-spend safe.
CREATE OR REPLACE FUNCTION public.redeem_reporter_points(
  p_user_id uuid,
  p_cost    int,
  p_days    int
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_earned  int;
  v_spent   int;
  v_avail   int;
  v_type    text;
  v_base    timestamptz;
  v_new_exp timestamptz;
BEGIN
  IF p_cost <= 0 OR p_days <= 0 THEN
    RETURN jsonb_build_object('ok', false, 'error', 'invalid_tier');
  END IF;

  -- Lock the profile row so two concurrent redeems can't both pass the check.
  SELECT COALESCE(reporter_points, 0),
         COALESCE(reporter_points_spent, 0),
         membership_type,
         membership_expires_at
    INTO v_earned, v_spent, v_type, v_base
    FROM public.profiles
   WHERE id = p_user_id
   FOR UPDATE;

  IF NOT FOUND THEN
    RETURN jsonb_build_object('ok', false, 'error', 'profile_not_found');
  END IF;

  v_avail := v_earned - v_spent;
  IF v_avail < p_cost THEN
    RETURN jsonb_build_object(
      'ok', false, 'error', 'insufficient_points', 'new_balance', v_avail
    );
  END IF;

  -- Stack the free days on top of any unexpired entitlement.
  IF v_base IS NULL OR v_base < now() THEN
    v_base := now();
  END IF;
  v_new_exp := v_base + make_interval(days => p_days);

  UPDATE public.profiles
     SET reporter_points_spent = v_spent + p_cost,
         -- Only upgrade a free account; never downgrade a paid tier.
         membership_type = CASE WHEN v_type = 'free' THEN 'monthly' ELSE v_type END,
         membership_expires_at = v_new_exp
   WHERE id = p_user_id;

  INSERT INTO public.reporter_point_redemptions
        (user_id, points_spent, reward_days, membership_expires_at)
  VALUES (p_user_id, p_cost, p_days, v_new_exp);

  RETURN jsonb_build_object(
    'ok', true,
    'new_balance', v_avail - p_cost,
    'membership_expires_at', v_new_exp
  );
END;
$$;

-- Lock the function down: only the service role (our admin client) may call it,
-- so points can only be spent through the rate-limited API with fixed tiers.
REVOKE ALL ON FUNCTION public.redeem_reporter_points(uuid, int, int) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.redeem_reporter_points(uuid, int, int) TO service_role;
