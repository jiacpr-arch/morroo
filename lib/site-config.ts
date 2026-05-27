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
