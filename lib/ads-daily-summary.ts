/**
 * Daily ads performance summary — collapses per-ad Meta insights for a
 * single day into one snapshot for the admin LINE digest.
 *
 * Pure: takes AdInsight rows (from lib/ads-diagnostics fetchAdInsights)
 * and returns totals. Returns null when nothing delivered so the digest
 * can skip the section entirely.
 */

import type { AdInsight } from "./ads-diagnostics";

export interface AdsDailySummary {
  spendThb: number;
  impressions: number;
  clicks: number;
  /** Weighted CTR across all delivered ads (clicks / impressions). */
  ctrPct: number | null;
  signups: number;
  costPerSignupThb: number | null;
  /** Ad with the most signups (cheapest per signup on ties); null when no signups yet. */
  topAdName: string | null;
  adsDelivered: number;
}

export function summarizeAdsDay(ads: AdInsight[]): AdsDailySummary | null {
  const delivered = ads.filter((a) => a.impressions > 0 || a.spend > 0);
  if (delivered.length === 0) return null;

  const spendThb = delivered.reduce((sum, a) => sum + a.spend, 0);
  const impressions = delivered.reduce((sum, a) => sum + a.impressions, 0);
  const clicks = delivered.reduce((sum, a) => sum + a.clicks, 0);
  const signups = delivered.reduce((sum, a) => sum + a.leads, 0);

  let topAdName: string | null = null;
  if (signups > 0) {
    const top = [...delivered].sort(
      (a, b) =>
        b.leads - a.leads ||
        (a.cpl ?? Infinity) - (b.cpl ?? Infinity) ||
        b.ctr - a.ctr
    )[0];
    topAdName = top.ad_name || top.ad_id;
  }

  return {
    spendThb,
    impressions,
    clicks,
    ctrPct: impressions > 0 ? (clicks / impressions) * 100 : null,
    signups,
    costPerSignupThb: signups > 0 ? spendThb / signups : null,
    topAdName,
    adsDelivered: delivered.length,
  };
}
