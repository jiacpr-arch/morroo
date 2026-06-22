declare global {
  interface Window {
    gtag?: (...args: unknown[]) => void;
    fbq?: (...args: unknown[]) => void;
    ttq?: {
      track: (
        event: string,
        params?: Record<string, unknown>,
        options?: Record<string, unknown>
      ) => void;
    };
  }
}

export function trackPurchase(opts: {
  transactionId: string;
  value: number;
  currency: string;
}): void {
  if (typeof window === "undefined") return;
  const { transactionId, value, currency } = opts;

  window.gtag?.("event", "purchase", {
    transaction_id: transactionId,
    value,
    currency,
  });

  // eventID/event_id must equal the Stripe session id used by the server-side
  // CAPI events in app/api/billing/webhook so Meta/TikTok dedupe the
  // browser+server pair. TikTok's event name must also match the API's
  // ("Subscribe", not "CompletePayment") or dedup won't trigger.
  window.fbq?.("track", "Purchase", { value, currency }, { eventID: transactionId });
  window.ttq?.track("Subscribe", { value, currency }, { event_id: transactionId });
}

export function trackInitiateCheckout(opts: {
  plan: string;
  value: number;
  currency: string;
}): void {
  if (typeof window === "undefined") return;
  const { plan, value, currency } = opts;

  window.gtag?.("event", "begin_checkout", {
    value,
    currency,
    items: [{ item_id: plan }],
  });
  window.fbq?.("track", "InitiateCheckout", {
    value,
    currency,
    content_ids: [plan],
    content_type: "subscription",
  });
  window.ttq?.track("InitiateCheckout", {
    value,
    currency,
    content_id: plan,
    content_type: "subscription",
  });
}

export function trackSignup(): void {
  if (typeof window === "undefined") return;
  // GA4 only. Meta/TikTok CompleteRegistration is already sent server-side
  // (app/auth/callback) and we lack its eventId here to dedupe a browser copy.
  window.gtag?.("event", "sign_up", { method: "oauth" });
}

export function trackEmailSignup(userId: string): void {
  if (typeof window === "undefined") return;
  // Email/password signups never pass through app/auth/callback (that route's
  // server-side CompleteRegistration only fires for Google/LINE OAuth, and its
  // 60s isNewSignup window also misses the email-confirmation round-trip), so
  // without firing here every email registration is invisible to Meta/TikTok —
  // under-reporting results and starving the conversion campaigns of signal.
  // The browser pixel carries the _fbp/_fbc cookies for attribution; eventID
  // keys dedup against the `signup:<userId>` server copy fired by
  // POST /api/track/registration (the register page calls both).
  const eventId = `signup:${userId}`;
  window.gtag?.("event", "sign_up", { method: "email" });
  window.fbq?.("track", "CompleteRegistration", { content_name: "signup" }, { eventID: eventId });
  window.ttq?.track("CompleteRegistration", { content_name: "signup" }, { event_id: eventId });
}
