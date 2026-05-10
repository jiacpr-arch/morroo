"use client";

import { useEffect } from "react";
import { captureAdsAttribution } from "@/lib/gtag";

/**
 * Reads gclid/gbraid/wbraid + utm_* from the URL on first paint and stores
 * them in sessionStorage so server actions later in the funnel (lead form,
 * Stripe checkout) can attach them to the conversion.
 */
export default function AdsAttributionTracker() {
  useEffect(() => {
    captureAdsAttribution();
  }, []);
  return null;
}
