/**
 * Google Ads API client for offline / Enhanced Conversions uploads.
 *
 * We don't pull the official google-ads-api SDK because it's huge (~5MB) and
 * we only need a single endpoint — the OAuth + REST surface is small enough
 * to drive directly with `fetch`.
 *
 * Required env vars:
 *
 *   GOOGLE_ADS_DEVELOPER_TOKEN
 *   GOOGLE_ADS_CUSTOMER_ID                10-digit, no dashes
 *   GOOGLE_ADS_LOGIN_CUSTOMER_ID          (optional MCC)
 *   GOOGLE_ADS_OAUTH_CLIENT_ID
 *   GOOGLE_ADS_OAUTH_CLIENT_SECRET
 *   GOOGLE_ADS_OAUTH_REFRESH_TOKEN
 *   GOOGLE_ADS_CONV_ACTION_LEAD_ID        numeric conversionAction id
 *   GOOGLE_ADS_CONV_ACTION_PURCHASE_ID    numeric conversionAction id
 *
 * Until all of the above are set, `uploadOfflineConversion` is a no-op that
 * returns `{ ok: false, reason: "not_configured" }`.
 */

import { createHash } from "crypto";

const TOKEN_URL = "https://oauth2.googleapis.com/token";
const API_VERSION = "v18";

let cachedToken: { token: string; expiresAt: number } | null = null;

async function getAccessToken(): Promise<string | null> {
  const clientId = process.env.GOOGLE_ADS_OAUTH_CLIENT_ID;
  const clientSecret = process.env.GOOGLE_ADS_OAUTH_CLIENT_SECRET;
  const refreshToken = process.env.GOOGLE_ADS_OAUTH_REFRESH_TOKEN;
  if (!clientId || !clientSecret || !refreshToken) return null;

  const now = Date.now();
  if (cachedToken && cachedToken.expiresAt - 60_000 > now) return cachedToken.token;

  const body = new URLSearchParams({
    client_id: clientId,
    client_secret: clientSecret,
    refresh_token: refreshToken,
    grant_type: "refresh_token",
  });
  const res = await fetch(TOKEN_URL, {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body,
  });
  if (!res.ok) {
    console.error("[google-ads] token refresh failed:", await res.text());
    return null;
  }
  const json = (await res.json()) as { access_token: string; expires_in: number };
  cachedToken = {
    token: json.access_token,
    expiresAt: now + json.expires_in * 1000,
  };
  return json.access_token;
}

function sha256(value: string): string {
  return createHash("sha256").update(value.trim().toLowerCase()).digest("hex");
}

export type OfflineConversionInput = {
  /** "lead" or "purchase" — selects which conversionAction to charge. */
  type: "lead" | "purchase";
  /** Click identifiers from the original ad click. At least one of these,
   *  or hashed user-data, is required by Google. */
  gclid?: string | null;
  gbraid?: string | null;
  wbraid?: string | null;
  /** ISO datetime of the conversion. Defaults to now. */
  conversionDateTime?: Date;
  /** Conversion value in account currency. Defaults to 0. */
  conversionValue?: number;
  /** ISO 4217 currency code. Defaults to THB. */
  currencyCode?: string;
  /** Free-form id used by Google to dedupe replays. */
  orderId?: string;
  /** Used for Enhanced Conversions when the gclid is missing. */
  email?: string | null;
  phone?: string | null;
};

export type OfflineConversionResult =
  | { ok: true; resourceName: string }
  | { ok: false; reason: "not_configured" | "missing_match_keys" | "api_error"; detail?: string };

function formatTimestamp(d: Date): string {
  // Google Ads expects "yyyy-MM-dd HH:mm:ss+ZZ:ZZ"
  const pad = (n: number) => n.toString().padStart(2, "0");
  const tzOff = -d.getTimezoneOffset();
  const sign = tzOff >= 0 ? "+" : "-";
  const tzH = pad(Math.floor(Math.abs(tzOff) / 60));
  const tzM = pad(Math.abs(tzOff) % 60);
  return (
    `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ` +
    `${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}` +
    `${sign}${tzH}:${tzM}`
  );
}

export async function uploadOfflineConversion(
  input: OfflineConversionInput
): Promise<OfflineConversionResult> {
  const developerToken = process.env.GOOGLE_ADS_DEVELOPER_TOKEN;
  const customerId = process.env.GOOGLE_ADS_CUSTOMER_ID;
  const loginCustomerId = process.env.GOOGLE_ADS_LOGIN_CUSTOMER_ID;
  const leadActionId = process.env.GOOGLE_ADS_CONV_ACTION_LEAD_ID;
  const purchaseActionId = process.env.GOOGLE_ADS_CONV_ACTION_PURCHASE_ID;

  const conversionActionId =
    input.type === "lead" ? leadActionId : purchaseActionId;

  if (!developerToken || !customerId || !conversionActionId) {
    return { ok: false, reason: "not_configured" };
  }

  // Need either a click id OR Enhanced Conversions user data.
  const hasClickId = !!(input.gclid || input.gbraid || input.wbraid);
  const hasUserData = !!(input.email || input.phone);
  if (!hasClickId && !hasUserData) {
    return { ok: false, reason: "missing_match_keys" };
  }

  const token = await getAccessToken();
  if (!token) return { ok: false, reason: "not_configured" };

  const conversionDateTime = formatTimestamp(
    input.conversionDateTime ?? new Date()
  );

  const conversion: Record<string, unknown> = {
    conversionAction: `customers/${customerId}/conversionActions/${conversionActionId}`,
    conversionDateTime,
    conversionValue: input.conversionValue ?? 0,
    currencyCode: input.currencyCode ?? "THB",
  };
  if (input.gclid) conversion.gclid = input.gclid;
  if (input.gbraid) conversion.gbraid = input.gbraid;
  if (input.wbraid) conversion.wbraid = input.wbraid;
  if (input.orderId) conversion.orderId = input.orderId;

  if (hasUserData) {
    const userIdentifiers: Record<string, string>[] = [];
    if (input.email) userIdentifiers.push({ hashedEmail: sha256(input.email) });
    if (input.phone) userIdentifiers.push({ hashedPhoneNumber: sha256(input.phone) });
    conversion.userIdentifiers = userIdentifiers;
  }

  const url =
    `https://googleads.googleapis.com/${API_VERSION}` +
    `/customers/${customerId}:uploadClickConversions`;

  const headers: Record<string, string> = {
    Authorization: `Bearer ${token}`,
    "developer-token": developerToken,
    "Content-Type": "application/json",
  };
  if (loginCustomerId) headers["login-customer-id"] = loginCustomerId;

  const res = await fetch(url, {
    method: "POST",
    headers,
    body: JSON.stringify({
      conversions: [conversion],
      partialFailure: true,
      validateOnly: false,
    }),
  });
  const json = (await res.json()) as {
    results?: { resourceName?: string }[];
    partialFailureError?: { message?: string };
    error?: { message?: string };
  };
  if (!res.ok || json.error) {
    const msg = json.error?.message ?? json.partialFailureError?.message ?? `http_${res.status}`;
    console.error("[google-ads] upload failed:", msg);
    return { ok: false, reason: "api_error", detail: msg };
  }
  const resourceName = json.results?.[0]?.resourceName ?? "";
  return { ok: true, resourceName };
}
