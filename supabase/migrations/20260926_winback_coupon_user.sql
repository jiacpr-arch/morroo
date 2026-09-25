-- ============================================================
-- Win-back coupons: tie to the user + one offer per lapse
--
-- 1. coupon_codes.restricted_user_id — when set, only that account can use
--    the coupon. Win-back coupons (lib/winback-server.ts issueWinbackCoupon)
--    set it to the member who answered the lapse survey, so a code can't be
--    passed around. Checked at checkout (lib/billing/coupon-checkout.ts
--    validateDiscountCoupon) and again inside redeem_coupon_code (raises
--    'not_found' for anyone else, same as an unknown code). NULL = anyone
--    (every existing coupon keeps working unchanged).
--
-- 2. One survey answer (and so at most one coupon) per user per lapse:
--    UNIQUE (user_id, access_expires_at). Two concurrent POST /api/winback
--    calls used to both pass the "no recent answer" check and both issue a
--    coupon; now the second insert fails with 23505 and the route disables
--    its coupon and returns the first answer. access_expires_at is the
--    expiry that ran out, so a later purchase + lapse gets a fresh offer.
--
-- Apply BEFORE deploying the matching app code (issueWinbackCoupon writes
-- restricted_user_id). Idempotent: safe to re-run.
-- ============================================================

ALTER TABLE public.coupon_codes
  ADD COLUMN IF NOT EXISTS restricted_user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE;

CREATE INDEX IF NOT EXISTS idx_coupon_codes_restricted_user
  ON public.coupon_codes (restricted_user_id)
  WHERE restricted_user_id IS NOT NULL;

-- Same function as 20260912_coupon_codes.sql plus the restricted_user_id check.
CREATE OR REPLACE FUNCTION public.redeem_coupon_code(
  p_code     text,
  p_user_id  uuid,
  p_platform text DEFAULT 'medical'
)
RETURNS TABLE (coupon_id uuid, coupon_type text, value integer)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v coupon_codes%ROWTYPE;
  v_user_uses integer;
BEGIN
  SELECT * INTO v FROM coupon_codes
    WHERE code = upper(trim(p_code))
    FOR UPDATE;
  IF NOT FOUND THEN RAISE EXCEPTION 'not_found'; END IF;
  -- Someone else's personal coupon looks like an unknown code.
  IF v.restricted_user_id IS NOT NULL AND v.restricted_user_id IS DISTINCT FROM p_user_id THEN
    RAISE EXCEPTION 'not_found';
  END IF;
  IF NOT COALESCE(v.is_active, false) THEN RAISE EXCEPTION 'inactive'; END IF;
  IF v.platform <> 'all' AND v.platform <> p_platform THEN RAISE EXCEPTION 'wrong_platform'; END IF;
  IF v.starts_at IS NOT NULL AND v.starts_at > now() THEN RAISE EXCEPTION 'not_started'; END IF;
  IF v.expires_at IS NOT NULL AND v.expires_at <= now() THEN RAISE EXCEPTION 'expired'; END IF;
  IF v.max_uses IS NOT NULL AND COALESCE(v.current_uses, 0) >= v.max_uses THEN
    RAISE EXCEPTION 'exhausted';
  END IF;

  SELECT count(*) INTO v_user_uses FROM coupon_redemptions r
    WHERE r.coupon_id = v.id AND r.user_id = p_user_id;
  IF v_user_uses >= COALESCE(v.max_uses_per_user, 1) THEN
    RAISE EXCEPTION 'already_redeemed';
  END IF;

  INSERT INTO coupon_redemptions (coupon_id, user_id, platform)
    VALUES (v.id, p_user_id, p_platform);
  UPDATE coupon_codes SET current_uses = COALESCE(current_uses, 0) + 1 WHERE id = v.id;

  RETURN QUERY SELECT v.id, v.coupon_type, v.value;
END $$;

REVOKE ALL ON FUNCTION public.redeem_coupon_code(text, uuid, text) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.redeem_coupon_code(text, uuid, text) FROM anon, authenticated;
GRANT EXECUTE ON FUNCTION public.redeem_coupon_code(text, uuid, text) TO service_role;

-- One answer per user per lapse. If duplicate rows already exist (a race
-- before this fix) the index is skipped with a warning instead of failing the
-- migration — the app still works, just without the DB-level guard; remove
-- the duplicates and re-run to add it.
DO $$
BEGIN
  CREATE UNIQUE INDEX IF NOT EXISTS uq_cancellation_feedback_user_lapse
    ON public.cancellation_feedback (user_id, access_expires_at)
    WHERE access_expires_at IS NOT NULL;
EXCEPTION WHEN unique_violation THEN
  RAISE WARNING 'uq_cancellation_feedback_user_lapse not created: duplicate (user_id, access_expires_at) rows exist';
END $$;
