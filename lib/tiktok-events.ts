/**
 * TikTok Events API — server-side event tracking (deduplicates with pixel).
 *
 * Required env vars:
 *   TIKTOK_PIXEL_ID           – Pixel code from TikTok Events Manager
 *   TIKTOK_EVENTS_API_TOKEN   – Access token from TikTok Business Center
 *   TIKTOK_TEST_EVENT_CODE    – (optional) for sandbox testing
 */

import crypto from "crypto";

const TIKTOK_API = "https://business-api.tiktok.com/open_api/v1.3/event/track/";

function sha256(value: string): string {
  return crypto.createHash("sha256").update(value.trim().toLowerCase()).digest("hex");
}

export interface TikTokUser {
  email?: string;
  phone?: string;
  externalId?: string;
  ip?: string;
  userAgent?: string;
  ttclid?: string;
}

export interface TikTokPurchaseEvent {
  value: number;
  currency: string;
  orderId?: string;
  user: TikTokUser;
  eventTime?: number;
}

export interface TikTokLeadEvent {
  user: TikTokUser;
  eventTime?: number;
  pageUrl?: string;
}

function buildContact(user: TikTokUser): Record<string, string> {
  const c: Record<string, string> = {};
  if (user.email) c.email = sha256(user.email);
  if (user.phone) c.phone_number = sha256(user.phone.replace(/\D/g, ""));
  if (user.externalId) c.external_id = sha256(user.externalId);
  return c;
}

async function sendTikTokEvents(events: object[]): Promise<void> {
  const pixelCode = process.env.TIKTOK_PIXEL_ID;
  const token = process.env.TIKTOK_EVENTS_API_TOKEN;
  if (!pixelCode || !token) {
    console.warn("[tiktok-events] TIKTOK_PIXEL_ID or TIKTOK_EVENTS_API_TOKEN not set — skipping");
    return;
  }

  const payload: Record<string, unknown> = {
    pixel_code: pixelCode,
    event_source: "web",
    partner_name: "MorRoo",
    data: events,
  };
  const testCode = process.env.TIKTOK_TEST_EVENT_CODE;
  if (testCode) payload.test_event_code = testCode;

  try {
    const res = await fetch(TIKTOK_API, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Access-Token": token,
      },
      body: JSON.stringify(payload),
    });
    if (!res.ok) {
      const text = await res.text().catch(() => "");
      console.error("[tiktok-events] API error:", res.status, text.slice(0, 300));
    }
  } catch (err) {
    console.error("[tiktok-events] fetch error:", err);
  }
}

export async function sendTikTokPurchase(event: TikTokPurchaseEvent): Promise<void> {
  const contact = buildContact(event.user);
  await sendTikTokEvents([
    {
      event: "CompletePayment",
      event_time: event.eventTime ?? Math.floor(Date.now() / 1000),
      event_id: event.orderId ?? `purchase-${Date.now()}`,
      user: {
        ...contact,
        ...(event.user.ip ? { ip: event.user.ip } : {}),
        ...(event.user.userAgent ? { user_agent: event.user.userAgent } : {}),
        ...(event.user.ttclid ? { ttclid: event.user.ttclid } : {}),
      },
      properties: {
        currency: event.currency,
        value: event.value,
        contents: [{ content_type: "product", content_name: "MorRoo Subscription" }],
      },
      page: { url: "https://www.morroo.com/payment/success" },
    },
  ]);
}

export async function sendTikTokLead(event: TikTokLeadEvent): Promise<void> {
  const contact = buildContact(event.user);
  await sendTikTokEvents([
    {
      event: "SubmitForm",
      event_time: event.eventTime ?? Math.floor(Date.now() / 1000),
      event_id: `lead-${event.user.email ?? Date.now()}`,
      user: {
        ...contact,
        ...(event.user.ip ? { ip: event.user.ip } : {}),
        ...(event.user.userAgent ? { user_agent: event.user.userAgent } : {}),
        ...(event.user.ttclid ? { ttclid: event.user.ttclid } : {}),
      },
      page: { url: event.pageUrl ?? "https://www.morroo.com" },
    },
  ]);
}
