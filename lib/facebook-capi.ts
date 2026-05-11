/**
 * Facebook Conversions API (CAPI) client.
 *
 * Server-side mirror of browser Pixel events. Sending the same `event_id`
 * to both Pixel and CAPI lets Meta dedupe within a 48h window — essential
 * for accurate ad attribution under iOS 14.5 ATT and ad-blocker losses.
 *
 * No-ops gracefully when env vars are missing so the codebase stays
 * deployable in dev / preview environments without Meta credentials.
 */

import {
  FB_PIXEL_ID,
  FB_CAPI_ACCESS_TOKEN,
  FB_CAPI_TEST_EVENT_CODE,
  FB_CAPI_API_VERSION,
  type FbEventName,
  trimEventSourceUrl,
} from "@/lib/facebook-pixel";

export type CapiUserData = {
  /** SHA-256 hashed lowercase email */
  em?: string;
  /** SHA-256 hashed E.164 phone (no leading +) */
  ph?: string;
  /** Raw _fbp cookie value (Meta requires raw, not hashed) */
  fbp?: string;
  /** Raw _fbc cookie value (Meta requires raw, not hashed) */
  fbc?: string;
  /** Client IP — read from x-forwarded-for at the route handler */
  client_ip_address?: string;
  /** User-Agent — read from request headers */
  client_user_agent?: string;
  /** External id (e.g. Supabase user id) */
  external_id?: string;
};

export type SendCapiArgs = {
  eventName: FbEventName;
  /** UUID — must match the Pixel `eventID` for browser/server dedup. */
  eventId: string;
  /** Defaults to now. */
  eventTime?: Date;
  /** URL the conversion happened on (or facebook.com for off-site). */
  eventSourceUrl?: string;
  /** "website" for browser-initiated, "system_generated" for webhooks. */
  actionSource?: "website" | "system_generated" | "email" | "chat" | "physical_store" | "other";
  userData?: CapiUserData;
  customData?: {
    value?: number;
    currency?: string;
    content_name?: string;
    content_category?: string;
    content_ids?: string[];
    [key: string]: unknown;
  };
};

export type CapiResult =
  | { ok: true; eventsReceived: number; fbtrace_id?: string }
  | { ok: false; reason: "not_configured" | "api_error"; detail?: string };

export async function sendCapiEvent(args: SendCapiArgs): Promise<CapiResult> {
  if (!FB_PIXEL_ID || !FB_CAPI_ACCESS_TOKEN) {
    return { ok: false, reason: "not_configured" };
  }

  const eventTime = Math.floor(
    (args.eventTime?.getTime() ?? Date.now()) / 1000
  );

  const event: Record<string, unknown> = {
    event_name: args.eventName,
    event_time: eventTime,
    event_id: args.eventId,
    action_source: args.actionSource ?? "website",
  };
  if (args.eventSourceUrl) {
    event.event_source_url = trimEventSourceUrl(args.eventSourceUrl);
  }
  if (args.userData) {
    const ud: Record<string, unknown> = {};
    for (const [k, v] of Object.entries(args.userData)) {
      if (v !== undefined && v !== null && v !== "") ud[k] = v;
    }
    if (Object.keys(ud).length > 0) event.user_data = ud;
  }
  if (args.customData) {
    const cd: Record<string, unknown> = {};
    for (const [k, v] of Object.entries(args.customData)) {
      if (v !== undefined && v !== null && v !== "") cd[k] = v;
    }
    if (Object.keys(cd).length > 0) event.custom_data = cd;
  }

  const body: Record<string, unknown> = {
    data: [event],
    access_token: FB_CAPI_ACCESS_TOKEN,
  };
  if (FB_CAPI_TEST_EVENT_CODE) body.test_event_code = FB_CAPI_TEST_EVENT_CODE;

  const url = `https://graph.facebook.com/${FB_CAPI_API_VERSION}/${FB_PIXEL_ID}/events`;

  try {
    const res = await fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(body),
    });
    const json = (await res.json()) as {
      events_received?: number;
      fbtrace_id?: string;
      error?: { message?: string; type?: string; code?: number };
    };
    if (!res.ok || json.error) {
      const detail = json.error?.message ?? `http_${res.status}`;
      console.error("[fb-capi] send failed:", detail);
      return { ok: false, reason: "api_error", detail };
    }
    return {
      ok: true,
      eventsReceived: json.events_received ?? 0,
      fbtrace_id: json.fbtrace_id,
    };
  } catch (err) {
    const detail = err instanceof Error ? err.message : String(err);
    console.error("[fb-capi] network error:", detail);
    return { ok: false, reason: "api_error", detail };
  }
}

/**
 * Read the client IP from common forwarding headers. Vercel sets
 * x-forwarded-for; some proxies use x-real-ip. Returns the first hop only.
 */
export function getClientIp(headers: Headers): string | undefined {
  const xff = headers.get("x-forwarded-for");
  if (xff) return xff.split(",")[0].trim();
  const xri = headers.get("x-real-ip");
  if (xri) return xri.trim();
  return undefined;
}

export function getClientUserAgent(headers: Headers): string | undefined {
  return headers.get("user-agent") ?? undefined;
}
