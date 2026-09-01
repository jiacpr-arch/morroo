/**
 * Facebook Lead Ads (Instant Form) helpers.
 *
 * Required env vars:
 *   FACEBOOK_APP_SECRET             – for X-Hub-Signature-256 verification
 *   FACEBOOK_LEADS_VERIFY_TOKEN     – matches the token configured in the
 *                                     Meta App's webhook subscription
 *   FACEBOOK_PAGE_ID                – page that owns the lead form
 *   FACEBOOK_USER_TOKEN             – existing long-lived user token
 *                                     (already used by lib/facebook.ts)
 *   FACEBOOK_LEAD_FORM_REWARDS?     – optional comma-separated map
 *                                     "form_id_a=monthly_1m,form_id_b=bundle_10q"
 *                                     used when the form has no
 *                                     custom "reward_choice" question
 */

import crypto from "crypto";
import {
  getLatestUserToken,
  getPageToken,
  refreshUserToken,
  saveUserToken,
} from "@/lib/facebook";
import type { RewardType } from "@/lib/redeem";

export type FbFieldDatum = { name: string; values: string[] };
export type FbLeadgenPayload = {
  id: string;
  created_time: string;
  ad_id?: string;
  adset_id?: string;
  campaign_id?: string;
  form_id?: string;
  field_data: FbFieldDatum[];
};

const VALID_REWARDS: RewardType[] = ["monthly_1m", "bundle_10q"];

/**
 * Constant-time check of FB's HMAC-SHA256 signature.
 * Header format: `sha256=<hex>`. Body must be the raw request bytes.
 */
export function verifyWebhookSignature(
  rawBody: string,
  signatureHeader: string | null,
  appSecret: string
): boolean {
  if (!signatureHeader || !signatureHeader.startsWith("sha256=")) return false;
  const provided = signatureHeader.slice("sha256=".length);
  const expected = crypto
    .createHmac("sha256", appSecret)
    .update(rawBody, "utf8")
    .digest("hex");
  if (provided.length !== expected.length) return false;
  try {
    return crypto.timingSafeEqual(
      Buffer.from(provided, "hex"),
      Buffer.from(expected, "hex")
    );
  } catch {
    return false;
  }
}

/** Resolve a fresh Page Access Token using the existing token plumbing. */
export async function resolvePageAccessToken(): Promise<string | null> {
  const pageId = process.env.FACEBOOK_PAGE_ID;
  if (!pageId) return null;
  const current = await getLatestUserToken();
  if (!current) return null;
  const fresh = (await refreshUserToken(current)) ?? current;
  if (fresh && fresh !== current) await saveUserToken(fresh);
  return getPageToken(pageId, fresh);
}

/**
 * Fetch full lead data from FB Graph for a given leadgen_id.
 * Returns null if the call fails — caller should log and bail.
 */
export async function fetchLeadgenData(
  leadgenId: string
): Promise<FbLeadgenPayload | null> {
  const pageToken = await resolvePageAccessToken();
  if (!pageToken) {
    console.error("[fb-leads] no page token available");
    return null;
  }
  const url = `https://graph.facebook.com/v24.0/${leadgenId}?fields=id,created_time,ad_id,adset_id,campaign_id,form_id,field_data&access_token=${encodeURIComponent(pageToken)}`;
  const res = await fetch(url);
  const data = (await res.json()) as
    | (FbLeadgenPayload & { error?: unknown })
    | { error: { message: string } };
  if ("error" in data && data.error) {
    console.error("[fb-leads] graph fetch failed:", JSON.stringify(data.error));
    return null;
  }
  return data as FbLeadgenPayload;
}

type MappedFields = {
  email?: string;
  name?: string;
  phone?: string;
  statusYear?: string;
  examTarget?: "NL1" | "NL2" | "both" | "unknown";
  rewardChoice?: RewardType;
};

const FIELD_ALIASES: Record<keyof MappedFields, string[]> = {
  email: ["email", "email_address", "อีเมล"],
  name: ["full_name", "name", "ชื่อ", "first_name"],
  phone: ["phone_number", "phone", "tel", "เบอร์โทร"],
  statusYear: ["status_year", "year", "ชั้นปี"],
  examTarget: ["exam_target", "target", "เป้าหมายสอบ"],
  rewardChoice: ["reward_choice", "reward", "ของขวัญ"],
};

/** Map Meta's field_data array into our lead schema, with Thai aliases. */
export function mapFieldData(fieldData: FbFieldDatum[]): MappedFields {
  const dict = new Map<string, string>();
  for (const f of fieldData) {
    const value = f.values?.[0]?.trim();
    if (value) dict.set(f.name.toLowerCase().trim(), value);
  }

  const lookup = (key: keyof MappedFields): string | undefined => {
    for (const alias of FIELD_ALIASES[key]) {
      const v = dict.get(alias.toLowerCase());
      if (v) return v;
    }
    return undefined;
  };

  const examRaw = lookup("examTarget")?.toUpperCase();
  const examTarget: MappedFields["examTarget"] =
    examRaw === "NL1" || examRaw === "NL2" || examRaw === "BOTH"
      ? (examRaw === "BOTH" ? "both" : (examRaw as "NL1" | "NL2"))
      : examRaw
        ? "unknown"
        : undefined;

  const rewardRaw = lookup("rewardChoice")?.toLowerCase().trim();
  const rewardChoice: MappedFields["rewardChoice"] =
    rewardRaw && (VALID_REWARDS as string[]).includes(rewardRaw)
      ? (rewardRaw as RewardType)
      : undefined;

  return {
    email: lookup("email"),
    name: lookup("name"),
    phone: lookup("phone"),
    statusYear: lookup("statusYear"),
    examTarget,
    rewardChoice,
  };
}

/**
 * Decide reward for a lead when the form didn't include a reward_choice
 * field. Reads FACEBOOK_LEAD_FORM_REWARDS env (form_id=reward,...).
 * Falls back to 'monthly_1m' as the default new-user offer.
 */
export function rewardForForm(formId: string | undefined): RewardType {
  const map = process.env.FACEBOOK_LEAD_FORM_REWARDS;
  if (formId && map) {
    for (const pair of map.split(",")) {
      const [id, reward] = pair.split("=").map((s) => s.trim());
      if (id === formId && (VALID_REWARDS as string[]).includes(reward)) {
        return reward as RewardType;
      }
    }
  }
  return "monthly_1m";
}
