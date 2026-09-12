/**
 * Server-side helpers for per-product membership entitlements
 * (`membership_entitlements`, see supabase/migrations/20260913_membership_entitlements.sql).
 *
 * Reading (`fetchAccess`) works with any Supabase client — the cookie client
 * in server components (RLS lets users read their own rows) or the admin
 * client. Writing (`grantPlan`, `grantProduct`, `setProduct`) always uses the
 * service-role client because the RPCs are service_role only.
 */

import type { SupabaseClient } from "@supabase/supabase-js";
import { createAdminClient } from "@/lib/supabase/admin";
import {
  PLAN_CATALOG,
  PRODUCTS,
  deriveLegacyMembership,
  planDurationDays,
  planExpiry,
  resolveAccess,
  type Access,
  type EntitlementLike,
  type MembershipLike,
  type PlanType,
  type Product,
  WHOLE_PRODUCT_SCOPE,
  entitledScopes,
} from "@/lib/membership";
import type { ItemSpec } from "@/lib/items";

export type EntitlementSource =
  | "stripe"
  | "slip"
  | "admin"
  | "redeem"
  | "coupon"
  | "referral"
  | "reward"
  | "backfill";

export interface EntitlementRow extends EntitlementLike {
  user_id: string;
  product: Product;
  scope: string;
  expires_at: string | null;
  source: string | null;
  reference: string | null;
  updated_at: string;
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type AnyClient = SupabaseClient<any, any, any>;

/** All entitlement rows for one user (active and expired). */
export async function fetchEntitlements(
  supabase: AnyClient,
  userId: string
): Promise<EntitlementRow[]> {
  const { data, error } = await supabase
    .from("membership_entitlements")
    .select("user_id, product, scope, expires_at, source, reference, updated_at")
    .eq("user_id", userId);
  if (error) {
    // Table missing (migration not applied yet) → fall back to legacy columns.
    console.error("fetchEntitlements failed:", error.message);
    return [];
  }
  return (data ?? []) as EntitlementRow[];
}

/**
 * Resolve what a user can access right now. Fetches the legacy profile
 * columns and the entitlement rows in parallel; `profile` may be passed when
 * the caller already loaded it to skip one query.
 */
export async function fetchAccess(
  supabase: AnyClient,
  userId: string,
  profile?: MembershipLike | null
): Promise<Access & { entitlements: EntitlementRow[] }> {
  const [p, entitlements] = await Promise.all([
    profile !== undefined
      ? Promise.resolve(profile)
      : supabase
          .from("profiles")
          .select("membership_type, membership_expires_at")
          .eq("id", userId)
          .maybeSingle()
          .then((r: { data: MembershipLike | null }) => r.data),
    fetchEntitlements(supabase, userId),
  ]);
  return { ...resolveAccess(p, entitlements), entitlements };
}

export interface GrantOptions {
  source: EntitlementSource;
  reference?: string | null;
  grantedBy?: string | null;
  /** Item scope (lib/items.ts); omit for the whole product. */
  scope?: string | null;
}

/**
 * Stack `days` of one product on top of whatever is still active
 * (`null` days = lifetime). Returns false on failure.
 */
export async function grantProduct(
  userId: string,
  product: Product,
  days: number | null,
  opts: GrantOptions
): Promise<boolean> {
  const admin = createAdminClient();
  const { error } = await admin.rpc("grant_entitlement", {
    p_user_id: userId,
    p_product: product,
    p_days: days,
    p_source: opts.source,
    p_reference: opts.reference ?? null,
    p_granted_by: opts.grantedBy ?? null,
    p_scope: opts.scope ?? WHOLE_PRODUCT_SCOPE,
  });
  if (error) {
    console.error(`grantProduct ${product} failed:`, error.message);
    return false;
  }
  return true;
}

/** Admin absolute set. `expiresAt` null = lifetime; a past date = revoked. */
export async function setProduct(
  userId: string,
  product: Product,
  expiresAt: Date | null,
  opts: GrantOptions
): Promise<boolean> {
  const admin = createAdminClient();
  const { error } = await admin.rpc("set_entitlement", {
    p_user_id: userId,
    p_product: product,
    p_expires_at: expiresAt ? expiresAt.toISOString() : null,
    p_source: opts.source,
    p_reference: opts.reference ?? null,
    p_granted_by: opts.grantedBy ?? null,
    p_scope: opts.scope ?? WHOLE_PRODUCT_SCOPE,
  });
  if (error) {
    console.error(`setProduct ${product} failed:`, error.message);
    return false;
  }
  return true;
}

export async function revokeProduct(
  userId: string,
  product: Product,
  opts: GrantOptions
): Promise<boolean> {
  // Keep the row (expired) so the legacy fallback never re-opens access.
  return setProduct(userId, product, new Date(), opts);
}

/**
 * Grant every product of a plan for the plan's duration and write the legacy
 * summary columns (`membership_type` = this plan, expiry = plan expiry, as
 * fulfillment always did). Used by Stripe, slip approval and admin grants.
 */
export async function grantPlan(
  userId: string,
  plan: PlanType,
  opts: GrantOptions
): Promise<{ ok: boolean; expiresAt: Date }> {
  const days = planDurationDays(plan);
  const results = await Promise.all(
    PLAN_CATALOG[plan].products.map((product) =>
      grantProduct(userId, product, days, opts)
    )
  );
  const expiresAt = planExpiry(plan);
  const admin = createAdminClient();
  const { error } = await admin
    .from("profiles")
    .update({
      membership_type: plan,
      membership_expires_at: expiresAt.toISOString(),
    })
    .eq("id", userId);
  if (error) console.error("grantPlan legacy update failed:", error.message);
  return { ok: results.every(Boolean) && !error, expiresAt };
}

/**
 * Grant a fixed number of days of a plan's products (redeem codes, coupons,
 * rewards) — stacks on existing entitlements, then re-derives the legacy
 * summary so the profile expiry reflects the stacked total.
 */
export async function grantPlanDays(
  userId: string,
  plan: PlanType,
  days: number,
  opts: GrantOptions
): Promise<boolean> {
  const results = await Promise.all(
    PLAN_CATALOG[plan].products.map((product) =>
      grantProduct(userId, product, days, opts)
    )
  );
  if (!results.every(Boolean)) return false;
  return syncLegacyMembership(userId, plan);
}

/**
 * Extend every currently-active product by `days` (referral / reward
 * bonuses that historically pushed `membership_expires_at` forward). Users
 * with nothing active get the student pack for `days`.
 */
export async function extendActiveProducts(
  userId: string,
  days: number,
  opts: GrantOptions
): Promise<boolean> {
  const admin = createAdminClient();
  const access = await fetchAccess(admin, userId);
  const products: readonly Product[] =
    access.products.length > 0 ? access.products : PLAN_CATALOG.monthly.products;
  const results = await Promise.all(
    products.map((product) => grantProduct(userId, product, days, opts))
  );
  if (!results.every(Boolean)) return false;
  return syncLegacyMembership(userId);
}

/**
 * Recompute `profiles.membership_type` / `membership_expires_at` from the
 * entitlement rows. `preferPlan` keeps that label when it still fits.
 */
export async function syncLegacyMembership(
  userId: string,
  preferPlan?: PlanType | null
): Promise<boolean> {
  const admin = createAdminClient();
  const [{ data: profile }, entitlements] = await Promise.all([
    admin
      .from("profiles")
      .select("membership_type")
      .eq("id", userId)
      .maybeSingle(),
    fetchEntitlements(admin, userId),
  ]);
  const derived = deriveLegacyMembership(
    entitlements,
    preferPlan ?? (profile as { membership_type?: string } | null)?.membership_type
  );
  const { error } = await admin
    .from("profiles")
    .update(derived)
    .eq("id", userId);
  if (error) {
    console.error("syncLegacyMembership failed:", error.message);
    return false;
  }
  return true;
}

/**
 * Grant one purchased item (subject / specialty / exam / case / topic).
 * Stacks like a plan for subscription items (board specialty), lifetime
 * otherwise. Legacy profile columns are untouched — items are not plans.
 */
export async function grantItem(
  userId: string,
  item: ItemSpec,
  opts: Omit<GrantOptions, "scope">
): Promise<boolean> {
  return grantProduct(userId, item.product, item.days, { ...opts, scope: item.scope });
}

/** Item scopes the user currently holds for a product (from a fetchAccess result). */
export function ownedScopes(
  access: { entitlements: EntitlementRow[] },
  product: Product
): Set<string> {
  return entitledScopes(access.entitlements, product);
}

/** Admin listing: every row, grouped by user. */
export async function fetchAllEntitlements(): Promise<
  Record<string, EntitlementRow[]>
> {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("membership_entitlements")
    .select("user_id, product, scope, expires_at, source, reference, updated_at")
    .order("updated_at", { ascending: false })
    .limit(20000);
  if (error) {
    console.error("fetchAllEntitlements failed:", error.message);
    return {};
  }
  const out: Record<string, EntitlementRow[]> = {};
  for (const row of (data ?? []) as EntitlementRow[]) {
    (out[row.user_id] ??= []).push(row);
  }
  return out;
}

export { PRODUCTS };
