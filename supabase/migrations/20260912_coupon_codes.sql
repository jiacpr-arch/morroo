-- ============================================================
-- Coupon / voucher system (morroo) — schema capture + redeem RPC
--
-- coupon_codes / coupon_redemptions already exist in production (created from
-- the Supabase dashboard before the repo restore; the app code that used them
-- was lost). This file records the schema so the repo is the source of truth
-- and adds the atomic redeem function used by lib/redeem.ts.
-- Idempotent: safe to re-run.
-- ============================================================

CREATE TABLE IF NOT EXISTS public.coupon_codes (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code              text NOT NULL UNIQUE,
  description       text,
  coupon_type       text NOT NULL
    CHECK (coupon_type IN ('free_trial','discount_percent','discount_fixed','free_month')),
  value             integer NOT NULL,           -- free_trial: days · free_month: months · discount_*: % / THB
  platform          text NOT NULL
    CHECK (platform IN ('medical','pharmacy','all')),
  max_uses          integer,                    -- NULL = unlimited
  max_uses_per_user integer DEFAULT 1,
  current_uses      integer DEFAULT 0,
  starts_at         timestamptz DEFAULT now(),
  expires_at        timestamptz,
  source            text,                       -- campaign / channel tag (free text)
  is_active         boolean DEFAULT true,
  created_at        timestamptz DEFAULT now(),
  created_by        uuid REFERENCES auth.users(id)
);

CREATE TABLE IF NOT EXISTS public.coupon_redemptions (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  coupon_id   uuid REFERENCES public.coupon_codes(id) ON DELETE CASCADE,
  user_id     uuid REFERENCES auth.users(id) ON DELETE CASCADE,
  redeemed_at timestamptz DEFAULT now(),
  platform    text NOT NULL CHECK (platform IN ('medical','pharmacy')),
  UNIQUE (coupon_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_coupon_redemptions_coupon ON public.coupon_redemptions(coupon_id);
CREATE INDEX IF NOT EXISTS idx_coupon_redemptions_user   ON public.coupon_redemptions(user_id);

ALTER TABLE public.coupon_codes       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.coupon_redemptions ENABLE ROW LEVEL SECURITY;

-- Atomic redeem: validates every rule under a row lock, records the redemption
-- and bumps current_uses in one transaction. Raises a short error code the app
-- maps to a user-facing message: not_found · inactive · wrong_platform ·
-- not_started · expired · exhausted · already_redeemed.
-- Service-role only (called from lib/redeem.ts with the admin client).
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
GRANT EXECUTE ON FUNCTION public.redeem_coupon_code(text, uuid, text) TO service_role;

-- Undo a redemption whose reward failed to apply (lib/redeem.ts rollback path).
CREATE OR REPLACE FUNCTION public.unredeem_coupon_code(p_coupon_id uuid, p_user_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  DELETE FROM coupon_redemptions WHERE coupon_id = p_coupon_id AND user_id = p_user_id;
  UPDATE coupon_codes SET current_uses = GREATEST(COALESCE(current_uses, 0) - 1, 0)
    WHERE id = p_coupon_id;
END $$;

REVOKE ALL ON FUNCTION public.unredeem_coupon_code(uuid, uuid) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.unredeem_coupon_code(uuid, uuid) TO service_role;
