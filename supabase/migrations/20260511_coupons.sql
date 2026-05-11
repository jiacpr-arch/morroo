-- Coupon / promotion engine
--
-- Supports:
--   discount_type = 'percent'  → value = percentage off (0–100)
--   discount_type = 'fixed'    → value = THB amount off
-- applicable_plans: NULL = all plans, or JSON array ["monthly","yearly","bundle"]

CREATE TABLE IF NOT EXISTS coupons (
  id                uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  code              text        NOT NULL UNIQUE,
  description       text,
  discount_type     text        NOT NULL,
  discount_value    numeric     NOT NULL CHECK (discount_value > 0),
  max_uses          int,
  uses_count        int         NOT NULL DEFAULT 0,
  applicable_plans  jsonb,
  valid_from        timestamptz NOT NULL DEFAULT now(),
  valid_until       timestamptz,
  is_active         boolean     NOT NULL DEFAULT true,
  created_by        uuid        REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at        timestamptz NOT NULL DEFAULT now(),
  updated_at        timestamptz NOT NULL DEFAULT now()
);

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'coupons_discount_type_check') THEN
    ALTER TABLE coupons ADD CONSTRAINT coupons_discount_type_check
      CHECK (discount_type IN ('percent', 'fixed'));
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'coupons_percent_range_check') THEN
    ALTER TABLE coupons ADD CONSTRAINT coupons_percent_range_check
      CHECK (discount_type != 'percent' OR (discount_value > 0 AND discount_value <= 100));
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS coupons_code_idx ON coupons(code);
CREATE INDEX IF NOT EXISTS coupons_active_idx ON coupons(is_active, valid_from, valid_until);

-- Tracks who used which coupon on which order
CREATE TABLE IF NOT EXISTS coupon_redemptions (
  id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  coupon_id   uuid        NOT NULL REFERENCES coupons(id) ON DELETE RESTRICT,
  user_id     uuid        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  order_id    uuid        REFERENCES payment_orders(id) ON DELETE SET NULL,
  plan_type   text        NOT NULL,
  discount    numeric     NOT NULL,
  redeemed_at timestamptz NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS coupon_redemptions_user_coupon_idx
  ON coupon_redemptions(coupon_id, user_id);

CREATE INDEX IF NOT EXISTS coupon_redemptions_coupon_idx ON coupon_redemptions(coupon_id);

ALTER TABLE coupons ENABLE ROW LEVEL SECURITY;
ALTER TABLE coupon_redemptions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Service role full access coupons" ON coupons;
CREATE POLICY "Service role full access coupons" ON coupons
  FOR ALL TO service_role USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Admins read coupons" ON coupons;
CREATE POLICY "Admins read coupons" ON coupons FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
  ));

DROP POLICY IF EXISTS "Service role full access coupon_redemptions" ON coupon_redemptions;
CREATE POLICY "Service role full access coupon_redemptions" ON coupon_redemptions
  FOR ALL TO service_role USING (true) WITH CHECK (true);

-- Atomic increment for uses_count (avoids read-modify-write race)
CREATE OR REPLACE FUNCTION increment_coupon_uses(p_coupon_id uuid)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  UPDATE coupons SET uses_count = uses_count + 1, updated_at = now()
  WHERE id = p_coupon_id;
END;
$$;
