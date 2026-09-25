-- ============================================================
-- Group / institution plans (B2B): med-school cohorts, tutors, friend groups
--
-- MVP, manual billing: a site admin creates the organization at
-- /admin/organizations after an offline payment / invoice and sets the seat
-- count + expiry. Members join with the org's join code (/org/join/<code>).
--
-- Access: every member of an unexpired organization gets the products of
-- `organizations.plan` (a PLAN_CATALOG key, default the student pack) through
-- the central entitlement resolver — lib/entitlements.ts fetchEntitlements()
-- appends one synthetic `source = 'org'` row per product, expiring at
-- organizations.expires_at. Nothing is written to membership_entitlements or
-- profiles.membership_type, so access ends by itself when the org expires or
-- the member row is deleted.
--
-- Seats: every organization_members row (owner included) uses one seat.
-- join_organization() takes a row lock on the org so two concurrent joins can
-- never overshoot `seats`.
--
-- Writes go through the service role (API routes); RLS only covers reads.
-- Idempotent: safe to re-run.
-- ============================================================

CREATE TABLE IF NOT EXISTS public.organizations (
  id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  name        text        NOT NULL CHECK (length(trim(name)) > 0),
  seats       integer     NOT NULL DEFAULT 10 CHECK (seats >= 1),
  -- PLAN_CATALOG key (lib/membership.ts) whose products members receive.
  plan        text        NOT NULL DEFAULT 'yearly',
  expires_at  timestamptz NOT NULL,
  join_code   text        NOT NULL UNIQUE CHECK (join_code ~ '^[A-Z0-9]{6,16}$'),
  note        text,                      -- invoice no. / contact, admin only
  created_by  uuid        REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.organization_members (
  org_id     uuid        NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
  user_id    uuid        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role       text        NOT NULL DEFAULT 'member' CHECK (role IN ('owner', 'member')),
  joined_at  timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (org_id, user_id)
);

-- fetchEntitlements looks members up by user on every gated page.
CREATE INDEX IF NOT EXISTS idx_organization_members_user
  ON public.organization_members(user_id);

-- ------------------------------------------------------------
-- RLS helpers. SECURITY DEFINER so a policy on organization_members can ask
-- "is the caller an owner of this org?" without recursing into itself.
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.is_org_member(p_org_id uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM organization_members
    WHERE org_id = p_org_id AND user_id = auth.uid()
  );
$$;

CREATE OR REPLACE FUNCTION public.is_org_owner(p_org_id uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM organization_members
    WHERE org_id = p_org_id AND user_id = auth.uid() AND role = 'owner'
  );
$$;

REVOKE ALL ON FUNCTION public.is_org_member(uuid) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.is_org_owner(uuid) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.is_org_member(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_org_owner(uuid) TO authenticated;

ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.organization_members ENABLE ROW LEVEL SECURITY;

-- Members (owners included) can read their own organization.
DROP POLICY IF EXISTS "Members can view their organization" ON public.organizations;
CREATE POLICY "Members can view their organization"
  ON public.organizations FOR SELECT
  USING (public.is_org_member(id));

DROP POLICY IF EXISTS "Admins can view all organizations" ON public.organizations;
CREATE POLICY "Admins can view all organizations"
  ON public.organizations FOR SELECT
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin'));

-- A user can always read their own membership rows (the entitlement check
-- runs with the cookie client); owners can read every member of their org.
DROP POLICY IF EXISTS "Users can view own org memberships" ON public.organization_members;
CREATE POLICY "Users can view own org memberships"
  ON public.organization_members FOR SELECT
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Owners can view org members" ON public.organization_members;
CREATE POLICY "Owners can view org members"
  ON public.organization_members FOR SELECT
  USING (public.is_org_owner(org_id));

DROP POLICY IF EXISTS "Admins can view all org members" ON public.organization_members;
CREATE POLICY "Admins can view all org members"
  ON public.organization_members FOR SELECT
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin'));

-- No INSERT / UPDATE / DELETE policies: writes go through the service role
-- (app/api/admin/organizations, app/api/org/*).

-- ------------------------------------------------------------
-- join_organization: atomic seat-checked join. Returns one of
--   'joined' · 'already_member' · 'not_found' · 'expired' · 'full'
-- Service role only (called from POST /api/org/join).
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.join_organization(
  p_join_code text,
  p_user_id   uuid
)
RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_org   organizations%ROWTYPE;
  v_count integer;
BEGIN
  SELECT * INTO v_org
  FROM organizations
  WHERE join_code = upper(trim(p_join_code))
  FOR UPDATE;

  IF NOT FOUND THEN
    RETURN 'not_found';
  END IF;

  IF EXISTS (
    SELECT 1 FROM organization_members
    WHERE org_id = v_org.id AND user_id = p_user_id
  ) THEN
    RETURN 'already_member';
  END IF;

  IF v_org.expires_at <= now() THEN
    RETURN 'expired';
  END IF;

  SELECT count(*) INTO v_count FROM organization_members WHERE org_id = v_org.id;
  IF v_count >= v_org.seats THEN
    RETURN 'full';
  END IF;

  INSERT INTO organization_members (org_id, user_id, role)
  VALUES (v_org.id, p_user_id, 'member');
  RETURN 'joined';
END;
$$;

REVOKE ALL ON FUNCTION public.join_organization(text, uuid) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.join_organization(text, uuid) FROM anon, authenticated;
GRANT EXECUTE ON FUNCTION public.join_organization(text, uuid) TO service_role;
