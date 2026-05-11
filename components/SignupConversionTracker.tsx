"use client";

import { useEffect } from "react";
import { trackConversion, trackEvent } from "@/lib/gtag";
import { trackFbEvent } from "@/lib/fb-browser";

/**
 * On the first page after OAuth signup, the auth callback redirects with
 * `?signup=1&fbe=<uuid>`. This tracker:
 *   - fires GA4 `sign_up` + Google Ads signup conversion
 *   - fires Meta Pixel `CompleteRegistration` reusing `fbe` as the eventID,
 *     so it dedups against the CAPI fire from `app/auth/callback/route.ts`
 *   - strips both params so refresh can't re-fire any of them
 */
export default function SignupConversionTracker() {
  useEffect(() => {
    if (typeof window === "undefined") return;
    const url = new URL(window.location.href);
    if (url.searchParams.get("signup") !== "1") return;

    const fbe = url.searchParams.get("fbe") ?? undefined;

    trackEvent("sign_up", { method: "oauth" });
    trackConversion("signup");
    trackFbEvent("CompleteRegistration", { content_name: "oauth_signup" }, fbe);

    url.searchParams.delete("signup");
    url.searchParams.delete("fbe");
    window.history.replaceState(
      {},
      "",
      url.pathname + (url.search ? `?${url.searchParams}` : "") + url.hash
    );
  }, []);
  return null;
}
