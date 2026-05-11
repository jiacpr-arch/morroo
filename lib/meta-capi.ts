/**
 * Meta Conversions API (CAPI) — server-side event tracking.
 *
 * Required env vars:
 *   META_PIXEL_ID           – Pixel ID (same as NEXT_PUBLIC_META_PIXEL_ID)
 *   META_CAPI_ACCESS_TOKEN  – System user access token from Events Manager
 *   META_TEST_EVENT_CODE    – (optional) test event code for sandbox testing
 */

import crypto from "crypto";

const CAPI_VERSION = "v21.0";
const CAPI_BASE = "https://graph.facebook.com";

function sha256(value: string): string {
  return crypto.createHash("sha256").update(value.trim().toLowerCase()).digest("hex");
}

export interface MetaCapiUser {
  email?: string;
  phone?: string;
  externalId?: string;
  fbp?: string;
  fbc?: string;
  clientIp?: string;
  clientUserAgent?: string;
}

export interface MetaPurchaseEvent {
  value: number;
  currency: string;
  orderId?: string;
  user: MetaCapiUser;
  eventTime?: number;
}

export interface MetaLeadEvent {
  user: MetaCapiUser;
  eventTime?: number;
  sourceUrl?: string;
}

function buildUserData(user: MetaCapiUser): Record<string, string> {
  const ud: Record<string, string> = {};
  if (user.email) ud.em = sha256(user.email);
  if (user.phone) ud.ph = sha256(user.phone.replace(/\D/g, ""));
  if (user.externalId) ud.external_id = sha256(user.externalId);
  if (user.fbp) ud.fbp = user.fbp;
  if (user.fbc) ud.fbc = user.fbc;
  if (user.clientIp) ud.client_ip_address = user.clientIp;
  if (user.clientUserAgent) ud.client_user_agent = user.clientUserAgent;
  return ud;
}

async function sendCapiEvents(events: object[]): Promise<void> {
  const pixelId = process.env.META_PIXEL_ID;
  const token = process.env.META_CAPI_ACCESS_TOKEN;
  if (!pixelId || !token) {
    console.warn("[meta-capi] META_PIXEL_ID or META_CAPI_ACCESS_TOKEN not set — skipping");
    return;
  }

  const url = `${CAPI_BASE}/${CAPI_VERSION}/${pixelId}/events?access_token=${token}`;
  const payload: Record<string, unknown> = { data: events };
  const testCode = process.env.META_TEST_EVENT_CODE;
  if (testCode) payload.test_event_code = testCode;

  try {
    const res = await fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
    });
    if (!res.ok) {
      const text = await res.text().catch(() => "");
      console.error("[meta-capi] API error:", res.status, text.slice(0, 300));
    }
  } catch (err) {
    console.error("[meta-capi] fetch error:", err);
  }
}

export async function sendMetaPurchase(event: MetaPurchaseEvent): Promise<void> {
  await sendCapiEvents([
    {
      event_name: "Purchase",
      event_time: event.eventTime ?? Math.floor(Date.now() / 1000),
      event_source_url: "https://www.morroo.com/payment/success",
      action_source: "website",
      user_data: buildUserData(event.user),
      custom_data: {
        value: event.value,
        currency: event.currency,
        ...(event.orderId ? { order_id: event.orderId } : {}),
      },
    },
  ]);
}

export async function sendMetaLead(event: MetaLeadEvent): Promise<void> {
  await sendCapiEvents([
    {
      event_name: "Lead",
      event_time: event.eventTime ?? Math.floor(Date.now() / 1000),
      event_source_url: event.sourceUrl ?? "https://www.morroo.com",
      action_source: "website",
      user_data: buildUserData(event.user),
    },
  ]);
}
