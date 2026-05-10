"use client";

import { useEffect } from "react";
import { trackConversion, trackEvent } from "@/lib/gtag";

/**
 * Fires a Google Ads "sign_up" conversion + GA4 event when the URL contains
 * `?signup=1` (set by the OAuth callback on first login). After firing, the
 * query param is stripped so the conversion can't double-fire on refresh.
 */
export default function SignupConversionTracker() {
  useEffect(() => {
    if (typeof window === "undefined") return;
    const url = new URL(window.location.href);
    if (url.searchParams.get("signup") !== "1") return;
    trackEvent("sign_up", { method: "oauth" });
    trackConversion("signup");
    url.searchParams.delete("signup");
    window.history.replaceState(
      {},
      "",
      url.pathname + (url.search ? `?${url.searchParams}` : "") + url.hash
    );
  }, []);
  return null;
}
