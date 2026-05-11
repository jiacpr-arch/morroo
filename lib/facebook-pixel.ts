/**
 * Facebook Pixel + Conversions API shared config + utilities.
 *
 * Env vars (set on Vercel → Project → Settings → Environment Variables):
 *
 *   NEXT_PUBLIC_FACEBOOK_PIXEL_ID     numeric pixel id (public — embedded in browser)
 *   FACEBOOK_CAPI_ACCESS_TOKEN        long-lived System User token with Pixel access (server-only)
 *   FACEBOOK_CAPI_TEST_EVENT_CODE     optional, e.g. "TEST12345" — surfaces events in Meta
 *                                     Events Manager → Test Events tab
 *   FACEBOOK_CAPI_API_VERSION         optional, defaults to v21.0
 *
 * When the public pixel id is missing, no browser script loads.
 * When the access token is missing, the CAPI client no-ops.
 */

import { createHash, randomUUID } from "crypto";

export const FB_PIXEL_ID = process.env.NEXT_PUBLIC_FACEBOOK_PIXEL_ID ?? "";
export const FB_CAPI_ACCESS_TOKEN = process.env.FACEBOOK_CAPI_ACCESS_TOKEN ?? "";
export const FB_CAPI_TEST_EVENT_CODE =
  process.env.FACEBOOK_CAPI_TEST_EVENT_CODE ?? "";
export const FB_CAPI_API_VERSION =
  process.env.FACEBOOK_CAPI_API_VERSION ?? "v21.0";

export type FbEventName =
  | "PageView"
  | "Lead"
  | "CompleteRegistration"
  | "InitiateCheckout"
  | "Purchase";

/** SHA-256 of a normalized string (lowercase + trimmed). Used for em/ph hashing. */
export function sha256Norm(value: string): string {
  return createHash("sha256")
    .update(value.trim().toLowerCase())
    .digest("hex");
}

/**
 * Normalize a Thai phone number to E.164 (+66…) before hashing. Meta CAPI
 * requires E.164 with no leading zero or punctuation for the SHA-256 of `ph`
 * to match user records.
 *
 *   "0812345678"      → "+66812345678"
 *   "+66 81 234 5678" → "+66812345678"
 *   "02-123-4567"     → "+6621234567"
 */
export function normalizePhoneTH(raw: string): string {
  const digits = raw.replace(/[^\d]/g, "");
  if (digits.length === 0) return "";
  if (digits.startsWith("66")) return `+${digits}`;
  if (digits.startsWith("0")) return `+66${digits.slice(1)}`;
  // Unknown country code — return as-is with +
  return `+${digits}`;
}

/** UUID v4 for use as Pixel `eventID` + CAPI `event_id` (Meta dedups within 48h). */
export function newEventId(): string {
  return randomUUID();
}

/**
 * Synthesize the `_fbc` cookie value from a raw `fbclid` URL parameter.
 *
 * Meta's documented format: `fb.{subdomainIndex}.{creationUnixMs}.{fbclid}`
 * For root domain, subdomainIndex = 1.
 */
export function buildFbcFromFbclid(fbclid: string, timestampMs = Date.now()): string {
  return `fb.1.${timestampMs}.${fbclid}`;
}

/** Trim event_source_url to Meta's 1024-char cap (defensively to 900). */
export function trimEventSourceUrl(url: string): string {
  if (url.length <= 900) return url;
  return url.slice(0, 900);
}
