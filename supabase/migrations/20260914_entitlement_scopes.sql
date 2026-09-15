-- ============================================================
-- Scoped entitlements — sell one subject / specialty / exam / case / topic
--
-- membership_entitlements so far held one row per (user, product) meaning
-- "the whole product". Add a `scope` so a row can also mean "only this
-- item inside the product":
--
--   scope = '*'                         whole product (all existing rows)
--   mcq      subject:<mcq_subjects.id> · category:internal_med · examtype:NL1
--   board    specialty:<board slug>
--   meq      exam:<exams.id> · category:<exams.category>
--   longcase case:<long_cases.id> · specialty:<long_cases.specialty>
--   school   topic:<school_topics.id> · year:<1-6>
--
-- Access = product row active OR any matching scope row active
-- (lib/membership.ts hasScopedAccess). Idempotent: safe to re-run.
-- ============================================================

ALTER TABLE public.membership_entitlements
  ADD COLUMN IF NOT EXISTS scope text NOT NULL DEFAULT '*';

-- PK (user_id, product) → (user_id, product, scope)
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'membership_entitlements_pkey'
      AND conrelid = 'public.membership_entitlements'::regclass
      AND array_length(conkey, 1) = 2
  ) THEN
    ALTER TABLE public.membership_entitlements DROP CONSTRAINT membership_entitlements_pkey;
    ALTER TABLE public.membership_entitlements ADD PRIMARY KEY (user_id, product, scope);
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_membership_entitlements_scope
  ON public.membership_entitlements(product, scope);

-- Replace the RPCs with scope-aware versions (drop the old 6-arg signatures).
DROP FUNCTION IF EXISTS public.grant_entitlement(uuid, text, integer, text, text, uuid);
DROP FUNCTION IF EXISTS public.set_entitlement(uuid, text, timestamptz, text, text, uuid);

CREATE OR REPLACE FUNCTION public.grant_entitlement(
  p_user_id    uuid,
  p_product    text,
  p_days       integer,
  p_source     text DEFAULT NULL,
  p_reference  text DEFAULT NULL,
  p_granted_by uuid DEFAULT NULL,
  p_scope      text DEFAULT '*'
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
    (user_id, product, scope, expires_at, source, reference, granted_by)
  VALUES (
    p_user_id,
    p_product,
    COALESCE(p_scope, '*'),
    CASE WHEN p_days IS NULL THEN NULL
         ELSE now() + make_interval(days => p_days) END,
    p_source, p_reference, p_granted_by
  )
  ON CONFLICT (user_id, product, scope) DO UPDATE SET
    expires_at = CASE
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

REVOKE ALL ON FUNCTION public.grant_entitlement(uuid, text, integer, text, text, uuid, text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.grant_entitlement(uuid, text, integer, text, text, uuid, text) TO service_role;

CREATE OR REPLACE FUNCTION public.set_entitlement(
  p_user_id    uuid,
  p_product    text,
  p_expires_at timestamptz,
  p_source     text DEFAULT 'admin',
  p_reference  text DEFAULT NULL,
  p_granted_by uuid DEFAULT NULL,
  p_scope      text DEFAULT '*'
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO membership_entitlements
    (user_id, product, scope, expires_at, source, reference, granted_by)
  VALUES (p_user_id, p_product, COALESCE(p_scope, '*'), p_expires_at, p_source, p_reference, p_granted_by)
  ON CONFLICT (user_id, product, scope) DO UPDATE SET
    expires_at = EXCLUDED.expires_at,
    source     = EXCLUDED.source,
    reference  = EXCLUDED.reference,
    granted_by = EXCLUDED.granted_by,
    updated_at = now();
END $$;

REVOKE ALL ON FUNCTION public.set_entitlement(uuid, text, timestamptz, text, text, uuid, text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.set_entitlement(uuid, text, timestamptz, text, text, uuid, text) TO service_role;
