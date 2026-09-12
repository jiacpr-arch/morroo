-- ============================================================
-- Per-product membership entitlements
--
-- profiles.membership_type can only hold ONE plan, so a user who buys Board
-- and then MCQ loses Board. This table lets a user hold an independent,
-- separately-expiring entitlement per product so each system can be gated
-- and billed on its own:
--
--   school   → Y1–Y6 micro-learning (flashcards / quizzes / SRS)
--   mcq      → NL Step 2 MCQ practice
--   meq      → MEQ exams + AI grading
--   longcase → Long Case (student audience)
--   board    → Board MCQ + Oral Exam
--
-- profiles.membership_type / membership_expires_at are KEPT as a legacy
-- summary (crons, analytics and older code still read them). The app keeps
-- them in sync (lib/entitlements.ts syncLegacyMembership) and treats this
-- table as the source of truth whenever a user has any row in it.
-- Idempotent: safe to re-run.
-- ============================================================

CREATE TABLE IF NOT EXISTS public.membership_entitlements (
  user_id     uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  product     text NOT NULL
    CHECK (product IN ('school','mcq','meq','longcase','board')),
  expires_at  timestamptz,               -- NULL = lifetime (bundle)
  source      text,                      -- stripe · slip · admin · redeem · coupon · referral · backfill
  reference   text,                      -- stripe session / order id / code
  granted_by  uuid REFERENCES auth.users(id),
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, product)
);

CREATE INDEX IF NOT EXISTS idx_membership_entitlements_expires
  ON public.membership_entitlements(product, expires_at);

ALTER TABLE public.membership_entitlements ENABLE ROW LEVEL SECURITY;

-- Users may read their own rows (server components gate with the cookie client).
DROP POLICY IF EXISTS "Users can view own entitlements" ON public.membership_entitlements;
CREATE POLICY "Users can view own entitlements"
  ON public.membership_entitlements FOR SELECT
  USING (auth.uid() = user_id);

-- Admins may read everything (admin dashboard lists). Writes go through the
-- service role only (/api/admin/membership, billing, redeem).
DROP POLICY IF EXISTS "Admins can view all entitlements" ON public.membership_entitlements;
CREATE POLICY "Admins can view all entitlements"
  ON public.membership_entitlements FOR SELECT
  USING (auth.uid() IN (SELECT id FROM public.profiles WHERE role = 'admin'));

-- ------------------------------------------------------------
-- grant_entitlement: stack p_days on top of any unexpired entitlement for
-- (user, product); an expired/missing one starts from now(). p_days NULL
-- = lifetime. Atomic via ON CONFLICT so concurrent grants both count.
-- Returns the new expiry (NULL = lifetime).
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.grant_entitlement(
  p_user_id   uuid,
  p_product   text,
  p_days      integer,
  p_source    text DEFAULT NULL,
  p_reference text DEFAULT NULL,
  p_granted_by uuid DEFAULT NULL
)
RETURNS timestamptz
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_expires timestamptz;
BEGIN
  INSERT INTO membership_entitlements AS e
    (user_id, product, expires_at, source, reference, granted_by)
  VALUES (
    p_user_id,
    p_product,
    CASE WHEN p_days IS NULL THEN NULL
         ELSE now() + make_interval(days => p_days) END,
    p_source, p_reference, p_granted_by
  )
  ON CONFLICT (user_id, product) DO UPDATE SET
    expires_at = CASE
      -- either side lifetime → lifetime
      WHEN e.expires_at IS NULL OR p_days IS NULL THEN NULL
      ELSE GREATEST(e.expires_at, now()) + make_interval(days => p_days)
    END,
    source     = COALESCE(EXCLUDED.source, e.source),
    reference  = COALESCE(EXCLUDED.reference, e.reference),
    granted_by = COALESCE(EXCLUDED.granted_by, e.granted_by),
    updated_at = now()
  RETURNING e.expires_at INTO v_expires;

  RETURN v_expires;
END $$;

REVOKE ALL ON FUNCTION public.grant_entitlement(uuid, text, integer, text, text, uuid) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.grant_entitlement(uuid, text, integer, text, text, uuid) TO service_role;

-- ------------------------------------------------------------
-- set_entitlement: admin absolute set (overwrite expiry). p_expires_at NULL
-- = lifetime. To revoke, pass now() (row is kept so the legacy fallback in
-- lib/membership.ts never re-opens access).
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.set_entitlement(
  p_user_id    uuid,
  p_product    text,
  p_expires_at timestamptz,
  p_source     text DEFAULT 'admin',
  p_reference  text DEFAULT NULL,
  p_granted_by uuid DEFAULT NULL
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO membership_entitlements
    (user_id, product, expires_at, source, reference, granted_by)
  VALUES (p_user_id, p_product, p_expires_at, p_source, p_reference, p_granted_by)
  ON CONFLICT (user_id, product) DO UPDATE SET
    expires_at = EXCLUDED.expires_at,
    source     = EXCLUDED.source,
    reference  = EXCLUDED.reference,
    granted_by = EXCLUDED.granted_by,
    updated_at = now();
END $$;

REVOKE ALL ON FUNCTION public.set_entitlement(uuid, text, timestamptz, text, text, uuid) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.set_entitlement(uuid, text, timestamptz, text, text, uuid) TO service_role;

-- ------------------------------------------------------------
-- profiles.membership_type: the 20260521 constraint never included the
-- school SKUs that lib/membership.ts already accepts. Add them.
-- ------------------------------------------------------------
ALTER TABLE public.profiles DROP CONSTRAINT IF EXISTS profiles_membership_type_check;
ALTER TABLE public.profiles ADD CONSTRAINT profiles_membership_type_check
  CHECK (membership_type = ANY (ARRAY[
    'free', 'bundle', 'monthly', 'yearly',
    'mcq_monthly', 'mcq_yearly',
    'meq_monthly', 'meq_yearly',
    'longcase_monthly', 'longcase_yearly',
    'board_monthly', 'board_yearly',
    'school_monthly', 'school_yearly'
  ]));

-- ------------------------------------------------------------
-- Backfill: every currently-active legacy membership becomes the matching
-- product rows. Mapping mirrors PLAN_PRODUCTS in lib/membership.ts:
--   monthly / yearly      → mcq, meq, longcase, school
--   bundle                → mcq (lifetime)
--   <product>_monthly/_yearly → that product
-- Existing rows are left untouched (ON CONFLICT DO NOTHING) so re-running
-- after real purchases never shortens anything.
-- ------------------------------------------------------------
INSERT INTO public.membership_entitlements (user_id, product, expires_at, source, reference)
SELECT p.id, m.product, p.membership_expires_at, 'backfill', p.membership_type
FROM public.profiles p
JOIN LATERAL (
  SELECT unnest(CASE p.membership_type
    WHEN 'monthly'           THEN ARRAY['mcq','meq','longcase','school']
    WHEN 'yearly'            THEN ARRAY['mcq','meq','longcase','school']
    WHEN 'bundle'            THEN ARRAY['mcq']
    WHEN 'mcq_monthly'       THEN ARRAY['mcq']
    WHEN 'mcq_yearly'        THEN ARRAY['mcq']
    WHEN 'meq_monthly'       THEN ARRAY['meq']
    WHEN 'meq_yearly'        THEN ARRAY['meq']
    WHEN 'longcase_monthly'  THEN ARRAY['longcase']
    WHEN 'longcase_yearly'   THEN ARRAY['longcase']
    WHEN 'board_monthly'     THEN ARRAY['board']
    WHEN 'board_yearly'      THEN ARRAY['board']
    WHEN 'school_monthly'    THEN ARRAY['school']
    WHEN 'school_yearly'     THEN ARRAY['school']
    ELSE ARRAY[]::text[]
  END) AS product
) m ON true
WHERE p.membership_type IS NOT NULL
  AND p.membership_type <> 'free'
  AND (p.membership_expires_at IS NULL OR p.membership_expires_at > now())
ON CONFLICT (user_id, product) DO NOTHING;
