/**
 * Tier-1 "config autopilot" for the LINE add-friend CTA.
 *
 * The website's LINE CTA aggressiveness is driven by a single value in the
 * app_settings key-value table (no deploy needed to change it). A daily cron
 * (/api/cron/line-autofix) reads yesterday's LINE click-through from the
 * marketing snapshot and nudges the level up when it's underperforming, or
 * back down once it recovers — fully reversible, with the prior value kept.
 *
 *   level 1 — normal   : floating LINE button shown (default, ships in PR #194)
 *   level 2 — boosted  : floating button shown + attention pulse
 *
 * Reads happen in a server component (components/FloatingLineCta.tsx); writes
 * happen only in the cron.
 */

import type { SupabaseClient } from "@supabase/supabase-js";
import type { MarketingSnapshot } from "@/lib/marketing-digest";

export const LINE_CTA_LEVEL_KEY = "line_cta_level";
export const LINE_CTA_LEVEL_PREV_KEY = "line_cta_level_prev";

export type LineCtaLevel = 1 | 2;
export const DEFAULT_LINE_CTA_LEVEL: LineCtaLevel = 1;

/** Autopilot tuning. Kept here so the decision stays unit-testable. */
export const LINE_CTA_AUTOPILOT = {
  /** Need at least this many visitors before we trust the signal. */
  minVisitors: 30,
  /** Below this LINE click-through rate (clicks / visitors) → boost. */
  lowCtrPct: 1.0,
  /** At or above this rate → step back down to normal. */
  recoverCtrPct: 3.0,
} as const;

function clampLevel(raw: string | null | undefined): LineCtaLevel {
  return raw === "2" ? 2 : DEFAULT_LINE_CTA_LEVEL;
}

export async function getLineCtaLevel(
  supabase: SupabaseClient
): Promise<LineCtaLevel> {
  const { data } = await supabase
    .from("app_settings")
    .select("value")
    .eq("key", LINE_CTA_LEVEL_KEY)
    .maybeSingle();
  return clampLevel((data as { value?: string } | null)?.value ?? null);
}

export async function setLineCtaLevel(
  supabase: SupabaseClient,
  prior: LineCtaLevel,
  next: LineCtaLevel
): Promise<void> {
  const now = new Date().toISOString();
  await supabase
    .from("app_settings")
    .upsert({ key: LINE_CTA_LEVEL_PREV_KEY, value: String(prior), updated_at: now });
  await supabase
    .from("app_settings")
    .upsert({ key: LINE_CTA_LEVEL_KEY, value: String(next), updated_at: now });
}

export interface LineCtaDecision {
  level: LineCtaLevel;
  changed: boolean;
  reason: string;
}

/**
 * Pure decision: given yesterday's snapshot and the level in effect, return the
 * level that should be in effect now. Reversible by design — it only ever moves
 * between {1,2} and de-escalates once click-through recovers.
 */
export function decideLineCtaLevel(
  snapshot: Pick<MarketingSnapshot, "visitors" | "lineClicks">,
  currentLevel: LineCtaLevel
): LineCtaDecision {
  const { visitors, lineClicks } = snapshot;

  if (visitors < LINE_CTA_AUTOPILOT.minVisitors) {
    return {
      level: currentLevel,
      changed: false,
      reason: `visitors ${visitors} < ${LINE_CTA_AUTOPILOT.minVisitors} — ข้อมูลไม่พอ ไม่เปลี่ยน`,
    };
  }

  const ctr = (lineClicks / visitors) * 100;

  if (ctr < LINE_CTA_AUTOPILOT.lowCtrPct && currentLevel === 1) {
    return {
      level: 2,
      changed: true,
      reason: `LINE CTR ${ctr.toFixed(1)}% < ${LINE_CTA_AUTOPILOT.lowCtrPct}% — ดันปุ่ม LINE ขึ้น (level 2)`,
    };
  }

  if (ctr >= LINE_CTA_AUTOPILOT.recoverCtrPct && currentLevel === 2) {
    return {
      level: 1,
      changed: true,
      reason: `LINE CTR ${ctr.toFixed(1)}% ฟื้นแล้ว — ลดกลับเป็นปกติ (level 1)`,
    };
  }

  return {
    level: currentLevel,
    changed: false,
    reason: `LINE CTR ${ctr.toFixed(1)}% — คงระดับ ${currentLevel}`,
  };
}
