/**
 * Server helpers for the lapse survey / win-back flow (see lib/winback.ts
 * for the model and the offer rules). Service-role only.
 */

import { createAdminClient } from "@/lib/supabase/admin";
import { COUPON_PLATFORM, generateCouponCode } from "@/lib/coupons";
import { isPlanType, PLAN_CATALOG } from "@/lib/membership";
import type { WinbackOffer } from "@/lib/winback";
import { fetchOrgMemberships, isOrgActive } from "@/lib/organizations";

export interface LapseState {
  lastPlan: string | null;
  expiresAt: string | null;
  wasTrial: boolean;
}

/**
 * Still covered by an active group / institution plan — their personal plan
 * lapsing doesn't cost them access, so there's nothing to win back.
 */
export async function hasActiveOrgAccess(userId: string): Promise<boolean> {
  const memberships = await fetchOrgMemberships(createAdminClient(), userId);
  return memberships.some((m) => isOrgActive(m.organizations));
}

/**
 * What ran out (or is about to): the legacy summary plan + expiry on the
 * profile, falling back to the latest whole-product entitlement when the
 * profile was already reset to free. `wasTrial` = had the free trial and
 * never paid (no approved payment order).
 */
export async function getLapseState(userId: string): Promise<LapseState> {
  const admin = createAdminClient();
  const [{ data: profile }, { data: ents }, { count: trialCount }, { count: paidCount }] =
    await Promise.all([
      admin
        .from("profiles")
        .select("membership_type, membership_expires_at")
        .eq("id", userId)
        .maybeSingle(),
      admin
        .from("membership_entitlements")
        .select("expires_at, scope")
        .eq("user_id", userId),
      admin
        .from("redeem_codes")
        .select("code", { count: "exact", head: true })
        .eq("redeemed_by", userId)
        .eq("reward_type", "monthly_1m")
        .not("redeemed_at", "is", null),
      admin
        .from("payment_orders")
        .select("id", { count: "exact", head: true })
        .eq("user_id", userId)
        .eq("status", "approved"),
    ]);

  const p = profile as { membership_type?: string | null; membership_expires_at?: string | null } | null;
  let lastPlan = p?.membership_type && p.membership_type !== "free" ? p.membership_type : null;
  let expiresAt = lastPlan ? p?.membership_expires_at ?? null : null;

  if (!lastPlan) {
    const whole = ((ents ?? []) as { expires_at: string | null; scope: string | null }[])
      .filter((e) => (!e.scope || e.scope === "*") && e.expires_at)
      .map((e) => e.expires_at as string)
      .sort();
    if (whole.length) {
      lastPlan = "monthly";
      expiresAt = whole[whole.length - 1];
    }
  }

  return {
    lastPlan,
    expiresAt,
    wasTrial: (trialCount ?? 0) > 0 && (paidCount ?? 0) === 0,
  };
}

/** Most recent survey answer of this user (any age). */
export async function getLatestFeedback(userId: string) {
  const admin = createAdminClient();
  const { data } = await admin
    .from("cancellation_feedback")
    .select(
      "id, reason, offer_kind, offer_percent, offer_plan, offer_coupon_code, offer_expires_at, offer_response, created_at"
    )
    .eq("user_id", userId)
    .order("created_at", { ascending: false })
    .limit(1)
    .maybeSingle();
  return data as FeedbackRecord | null;
}

export interface FeedbackRecord {
  id: string;
  reason: string;
  offer_kind: "discount" | "none";
  offer_percent: number | null;
  offer_plan: string | null;
  offer_coupon_code: string | null;
  offer_expires_at: string | null;
  offer_response: "accepted" | "declined" | null;
  created_at: string;
}

/**
 * Single-use discount coupon for this user's win-back offer, restricted to
 * the plan they'd renew. Checked and consumed by the normal checkout coupon
 * path (lib/billing/coupon-checkout.ts).
 */
export async function issueWinbackCoupon(
  offer: Extract<WinbackOffer, { kind: "discount" }>
): Promise<{ id: string; code: string; expiresAt: string } | null> {
  const admin = createAdminClient();
  const expiresAt = new Date(Date.now() + offer.validDays * 86_400_000).toISOString();
  const planName = isPlanType(offer.plan) ? PLAN_CATALOG[offer.plan].label : offer.plan;

  // Retry on the (unlikely) unique-code collision.
  for (let attempt = 0; attempt < 3; attempt++) {
    const code = generateCouponCode("BACK");
    const { data, error } = await admin
      .from("coupon_codes")
      .insert({
        code,
        description: `Win-back ${offer.percent}% (${planName})`,
        coupon_type: "discount_percent",
        value: offer.percent,
        platform: COUPON_PLATFORM,
        max_uses: 1,
        max_uses_per_user: 1,
        expires_at: expiresAt,
        source: "winback",
        is_active: true,
        plan_type: offer.plan,
      })
      .select("id, code")
      .single();
    if (!error && data) return { id: data.id as string, code: data.code as string, expiresAt };
    if (error?.code !== "23505") {
      console.error("[winback] coupon insert failed:", error?.message);
      return null;
    }
  }
  return null;
}
