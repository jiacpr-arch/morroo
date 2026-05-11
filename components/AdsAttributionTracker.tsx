"use client";

import { useEffect } from "react";
import { captureAdsAttribution } from "@/lib/gtag";
import { captureFbAttribution } from "@/lib/fb-browser";

/**
 * Captures ad-network attribution on first paint and persists it to
 * sessionStorage so server actions later in the funnel (lead form, Stripe
 * checkout) can attach the click identifiers to the conversion.
 *
 * - Google Ads: gclid / gbraid / wbraid + utm_*
 * - Meta:       fbclid + _fbp / _fbc cookies
 *
 * Runs in a small delay loop because `_fbp` is set asynchronously by the
 * Pixel script — we want the cookie value if it's available by the time the
 * user submits anything, but never block render.
 */
export default function AdsAttributionTracker() {
  useEffect(() => {
    captureAdsAttribution();
    captureFbAttribution();

    // Re-run once after Pixel has had a moment to drop _fbp.
    const t = window.setTimeout(() => {
      captureFbAttribution();
    }, 1500);
    return () => window.clearTimeout(t);
  }, []);
  return null;
}
