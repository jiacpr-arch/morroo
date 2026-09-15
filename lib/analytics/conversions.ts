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

// Queue events even when the Google library has not finished loading.
// The site's existing Google tag consumes this same dataLayer; do not load
// another tag or bypass its consent settings here.
function googleEvent(name: string, parameters?: Record<string, unknown>) {
  if (typeof window === "undefined") return;
  if (!window.gtag) {
    const target = window as Window & { dataLayer?: unknown[] };
    target.dataLayer ??= [];
    window.gtag = function () {
      // Google tag's command queue uses Arguments objects, not event arrays.
      // eslint-disable-next-line prefer-rest-params
      target.dataLayer!.push(arguments);
    };
  }
  window.gtag("event", name, parameters ?? {});
}

export function trackPurchase(opts: {
  transactionId: string;
  value: number;
  currency: string;
}): void {
  if (typeof window === "undefined") return;
  const { transactionId, value, currency } = opts;

  if (!transactionId || !Number.isFinite(value) || value < 0 || !/^[A-Z]{3}$/.test(currency)) return;

  googleEvent("purchase", {
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

  googleEvent("begin_checkout", {
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

export function trackLead(code: string): void {
  if (typeof window === "undefined") return;
  // eventID must equal the server CAPI copy in app/api/leads/create
  // (`lead:<code>`) so Meta dedupes the browser+server pair. The browser
  // copy carries _fbp/_fbc for ad attribution.
  const eventId = `lead:${code}`;
  googleEvent("generate_lead");
  window.fbq?.("track", "Lead", { content_name: "free_trial" }, { eventID: eventId });
  window.ttq?.track("SubmitForm", { content_name: "free_trial" }, { event_id: eventId });
}

export function trackSignup(): void {
  if (typeof window === "undefined") return;
  // GA4 only. Meta/TikTok CompleteRegistration is already sent server-side
  // (app/auth/callback) and we lack its eventId here to dedupe a browser copy.
  googleEvent("sign_up", { method: "oauth" });
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
  googleEvent("sign_up", { method: "email" });
  window.fbq?.("track", "CompleteRegistration", { content_name: "signup" }, { eventID: eventId });
  window.ttq?.track("CompleteRegistration", { content_name: "signup" }, { event_id: eventId });
}

/**
 * Browser ViewContent เมื่อผู้ใช้เห็นการ์ดราคา — เดิมมีแต่ pricing_view เข้า
 * PostHog เท่านั้น ไม่มีสัญญาณอะไรเข้า Meta เลยว่าคนไหน "เห็นราคาแล้ว" ทำให้
 * ตั้ง Custom Conversion / Lookalike จากขั้นนี้ไม่ได้ ยิงคู่กับ pricing_view
 * เสมอ (ครั้งเดียวต่อ session ตาม guard ใน PricingViewTracker)
 */
export function trackPricingViewContent(surface: string): void {
  if (typeof window === "undefined") return;
  try {
    window.fbq?.("track", "ViewContent", {
      content_name: "pricing",
      content_type: "pricing",
      content_ids: [surface],
    });
    window.ttq?.track("ViewContent", {
      content_name: "pricing",
      content_type: "pricing",
      content_id: surface,
    });
  } catch {
    // pixel อาจถูก ad blocker บล็อก — ห้ามทำให้หน้าเว็บพัง
  }
}

/**
 * Browser Lead เมื่อกดปุ่ม LINE (OA หรือ debrief ท้ายเกม) — ไม่มี eventID
 * เพราะไม่มี server CAPI คู่กันสำหรับการกดลิงก์ LINE (ต่างจาก trackLead ที่
 * dedupe กับ app/api/leads/create ด้วย `lead:<code>`) และห้ามใช้รูปแบบ id
 * เดียวกันโดยไม่ตั้งใจ ไม่งั้น Meta จะ dedupe event คนละความหมายทิ้งกันเอง
 *
 * ไม่ยิง gtag generate_lead ที่นี่โดยตั้งใจ — ไม่อยากให้การกด LINE (ซึ่งไม่ใช่
 * lead ที่มีคนตามต่อแบบ trackLead) ไปปนกับ Lead conversion ของ Google Ads
 */
export function trackLineLead(surface: string): void {
  if (typeof window === "undefined") return;
  try {
    window.fbq?.("track", "Lead", { content_name: "line_oa", content_category: surface });
    window.ttq?.track("ClickButton", { content_name: "line_oa", content_id: surface });
  } catch {
    // pixel อาจถูก ad blocker บล็อก — ห้ามทำให้หน้าเว็บพัง
  }
}
