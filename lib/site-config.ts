/**
 * General app_settings-backed config levers the autopilot can tune (no deploy),
 * plus the pure decisions behind them. Today this drives the hero A/B winner;
 * future levers (promo banner, urgency, plan emphasis) belong here too.
 *
 * Everything is conservative on purpose: with low daily traffic the autopilot
 * must NOT act on noise, so each decision requires a minimum sample before it
 * will change anything, and de-escalation/flip-flopping is avoided.
 */

import type { SupabaseClient } from "@supabase/supabase-js";
import type { Variant } from "@/lib/ab";
import type { MarketingSnapshot } from "@/lib/marketing-digest";

export const HERO_FORCED_VARIANT_KEY = "hero_forced_variant";

export interface HeroABStats {
  a: { views: number; converts: number; rate: number | null };
  b: { views: number; converts: number; rate: number | null };
}

/** Guardrails so we never "pick a winner" off a handful of visitors. */
export const HERO_AUTOPILOT = {
  minViewsPerVariant: 100,
  minTotalConverts: 10,
  minRelMargin: 0.2, // winner's rate must beat the loser's by ≥20% (relative)
} as const;

export interface HeroDecision {
  forced: Variant | null; // null = keep testing (50/50)
  changed: boolean;
  reason: string;
}

/**
 * Decide whether to lock the hero to a winning variant. Returns the current
 * state unchanged unless there's enough data AND a clear margin. Once a winner
 * is locked it stays locked (the experiment has concluded) — re-testing is a
 * manual reset.
 */
export function decideHeroWinner(
  hero: HeroABStats,
  current: Variant | null
): HeroDecision {
  const { a, b } = hero;

  if (
    a.views < HERO_AUTOPILOT.minViewsPerVariant ||
    b.views < HERO_AUTOPILOT.minViewsPerVariant
  ) {
    return {
      forced: current,
      changed: false,
      reason: `ข้อมูลยังน้อย (A ${a.views} / B ${b.views} views) — ยังไม่ตัดสิน`,
    };
  }

  if (a.converts + b.converts < HERO_AUTOPILOT.minTotalConverts) {
    return {
      forced: current,
      changed: false,
      reason: `conversion รวมยังน้อย (${a.converts + b.converts}) — ยังไม่ตัดสิน`,
    };
  }

  const aRate = a.rate ?? 0;
  const bRate = b.rate ?? 0;
  const winner: Variant = aRate >= bRate ? "A" : "B";
  const winRate = Math.max(aRate, bRate);
  const loseRate = Math.min(aRate, bRate);

  if (loseRate > 0 && winRate < loseRate * (1 + HERO_AUTOPILOT.minRelMargin)) {
    return {
      forced: current,
      changed: false,
      reason: `ผลต่างน้อยเกินไป (A ${aRate.toFixed(1)}% vs B ${bRate.toFixed(1)}%) — ยังไม่ตัดสิน`,
    };
  }

  if (current === winner) {
    return {
      forced: winner,
      changed: false,
      reason: `${winner} ยังเป็นผู้ชนะ — คงไว้`,
    };
  }

  return {
    forced: winner,
    changed: true,
    reason: `ล็อก hero เป็น ${winner} (A ${aRate.toFixed(1)}% vs B ${bRate.toFixed(1)}%)`,
  };
}

export async function getHeroForcedVariant(
  supabase: SupabaseClient
): Promise<Variant | null> {
  const { data } = await supabase
    .from("app_settings")
    .select("value")
    .eq("key", HERO_FORCED_VARIANT_KEY)
    .maybeSingle();
  const v = (data as { value?: string } | null)?.value;
  return v === "A" || v === "B" ? v : null;
}

export async function setHeroForcedVariant(
  supabase: SupabaseClient,
  variant: Variant
): Promise<void> {
  await supabase
    .from("app_settings")
    .upsert({
      key: HERO_FORCED_VARIANT_KEY,
      value: variant,
      updated_at: new Date().toISOString(),
    });
}

export async function runHeroAutopilot(
  supabase: SupabaseClient,
  hero: HeroABStats
): Promise<{ previous: Variant | null; decision: HeroDecision }> {
  const previous = await getHeroForcedVariant(supabase);
  const decision = decideHeroWinner(hero, previous);
  if (decision.changed && decision.forced) {
    await setHeroForcedVariant(supabase, decision.forced);
  }
  return { previous, decision };
}

// ─── Pricing promo bar lever ───────────────────────────────────────────────
//
// An honest reassurance bar on the pricing page (free start / cancel anytime),
// NOT a fake countdown. The autopilot switches it on when people look at
// pricing but don't convert, and off once conversions recover.

export const PRICING_PROMO_KEY = "pricing_promo_level";

export type PricingPromoLevel = 0 | 1; // 0 off, 1 on

export const PRICING_PROMO_AUTOPILOT = {
  minVisitors: 50,
  minPricingViewers: 15,
  /** At/above this signup rate (%) the promo is unnecessary → turn off. */
  recoverConversionPct: 2.0,
} as const;

export interface PricingPromoDecision {
  level: PricingPromoLevel;
  changed: boolean;
  reason: string;
}

export function decidePricingPromo(
  snapshot: Pick<
    MarketingSnapshot,
    "visitors" | "pricingViewers" | "formSubmits" | "conversionRate"
  >,
  current: PricingPromoLevel
): PricingPromoDecision {
  const { visitors, pricingViewers, formSubmits, conversionRate } = snapshot;

  if (
    visitors < PRICING_PROMO_AUTOPILOT.minVisitors ||
    pricingViewers < PRICING_PROMO_AUTOPILOT.minPricingViewers
  ) {
    return {
      level: current,
      changed: false,
      reason: `ข้อมูลยังน้อย (visitors ${visitors}, ดูราคา ${pricingViewers}) — คงไว้`,
    };
  }

  if (formSubmits === 0 && current === 0) {
    return {
      level: 1,
      changed: true,
      reason: `ดูราคา ${pricingViewers} คน แต่สมัคร 0 — เปิด promo bar ลดความกังวลก่อนซื้อ`,
    };
  }

  if ((conversionRate ?? 0) >= PRICING_PROMO_AUTOPILOT.recoverConversionPct && current === 1) {
    return {
      level: 0,
      changed: true,
      reason: `conversion ${(conversionRate ?? 0).toFixed(1)}% ฟื้นแล้ว — ปิด promo bar`,
    };
  }

  return {
    level: current,
    changed: false,
    reason: `คง promo bar ระดับ ${current}`,
  };
}

export async function getPricingPromoLevel(
  supabase: SupabaseClient
): Promise<PricingPromoLevel> {
  const { data } = await supabase
    .from("app_settings")
    .select("value")
    .eq("key", PRICING_PROMO_KEY)
    .maybeSingle();
  return (data as { value?: string } | null)?.value === "1" ? 1 : 0;
}

export async function setPricingPromoLevel(
  supabase: SupabaseClient,
  level: PricingPromoLevel
): Promise<void> {
  await supabase
    .from("app_settings")
    .upsert({
      key: PRICING_PROMO_KEY,
      value: String(level),
      updated_at: new Date().toISOString(),
    });
}

export async function runPricingPromoAutopilot(
  supabase: SupabaseClient,
  snapshot: Pick<
    MarketingSnapshot,
    "visitors" | "pricingViewers" | "formSubmits" | "conversionRate"
  >
): Promise<{ previous: PricingPromoLevel; decision: PricingPromoDecision }> {
  const previous = await getPricingPromoLevel(supabase);
  const decision = decidePricingPromo(snapshot, previous);
  if (decision.changed) {
    await setPricingPromoLevel(supabase, decision.level);
  }
  return { previous, decision };
}
