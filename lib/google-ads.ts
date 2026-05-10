/**
 * Google Ads conversion configuration.
 *
 * Set these in environment variables (Vercel → Project → Settings → Env Vars):
 *
 *   NEXT_PUBLIC_GOOGLE_ADS_ID                       AW-XXXXXXXXXX
 *   NEXT_PUBLIC_GOOGLE_ADS_CONV_LEAD                <conversion label>
 *   NEXT_PUBLIC_GOOGLE_ADS_CONV_SIGNUP              <conversion label>
 *   NEXT_PUBLIC_GOOGLE_ADS_CONV_BEGIN_CHECKOUT      <conversion label>
 *   NEXT_PUBLIC_GOOGLE_ADS_CONV_PURCHASE            <conversion label>
 *
 * Conversion labels are the part after the slash in
 *   "send_to: AW-XXXXXXXXXX/AbC-D_efGhIj" → "AbC-D_efGhIj"
 *
 * Server-side (offline) conversion uploads (optional, only if you want to
 * upload conversions through Google Ads API instead of/alongside gtag):
 *
 *   GOOGLE_ADS_DEVELOPER_TOKEN
 *   GOOGLE_ADS_CUSTOMER_ID                          1234567890 (no dashes)
 *   GOOGLE_ADS_LOGIN_CUSTOMER_ID                    optional MCC id
 *   GOOGLE_ADS_OAUTH_CLIENT_ID
 *   GOOGLE_ADS_OAUTH_CLIENT_SECRET
 *   GOOGLE_ADS_OAUTH_REFRESH_TOKEN
 *   GOOGLE_ADS_CONV_ACTION_LEAD_ID
 *   GOOGLE_ADS_CONV_ACTION_PURCHASE_ID
 */

export const GOOGLE_ADS_ID = process.env.NEXT_PUBLIC_GOOGLE_ADS_ID ?? "";

export const GOOGLE_ADS_CONVERSIONS = {
  lead: process.env.NEXT_PUBLIC_GOOGLE_ADS_CONV_LEAD ?? "",
  signup: process.env.NEXT_PUBLIC_GOOGLE_ADS_CONV_SIGNUP ?? "",
  beginCheckout: process.env.NEXT_PUBLIC_GOOGLE_ADS_CONV_BEGIN_CHECKOUT ?? "",
  purchase: process.env.NEXT_PUBLIC_GOOGLE_ADS_CONV_PURCHASE ?? "",
} as const;

export type ConversionEvent = keyof typeof GOOGLE_ADS_CONVERSIONS;

export function getSendTo(event: ConversionEvent): string | null {
  if (!GOOGLE_ADS_ID) return null;
  const label = GOOGLE_ADS_CONVERSIONS[event];
  if (!label) return null;
  return `${GOOGLE_ADS_ID}/${label}`;
}
