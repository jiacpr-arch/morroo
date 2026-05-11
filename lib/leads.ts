import { createAdminClient } from "@/lib/supabase/admin";
import { issueRedeemCode, type RewardType, type RedeemSource } from "@/lib/redeem";
import { sendRedeemCodeEmail } from "@/lib/email/send";
import { uploadOfflineConversion } from "@/lib/google-ads-server";
import { sendCapiEvent } from "@/lib/facebook-capi";
import { sha256Norm, normalizePhoneTH, newEventId } from "@/lib/facebook-pixel";

const REWARD_LABEL: Record<RewardType, string> = {
  monthly_1m: "สมาชิกรายเดือน 1 เดือน",
  bundle_10q: "Bundle 10 ข้อ",
};

export type AdsAttribution = {
  gclid?: string;
  gbraid?: string;
  wbraid?: string;
  fbclid?: string;
  fbc?: string;
  fbp?: string;
  utm_source?: string;
  utm_medium?: string;
  utm_campaign?: string;
  utm_term?: string;
  utm_content?: string;
  landing_page?: string;
};

export type CreateLeadArgs = {
  source: RedeemSource;
  campaign?: string;
  adSet?: string;
  fbLeadId?: string;
  email: string;
  phone?: string;
  name?: string;
  statusYear?: string;
  examTarget?: "NL1" | "NL2" | "both" | "unknown";
  rewardChoice: RewardType;
  consentPdpa: boolean;
  rawPayload?: Record<string, unknown>;
  attribution?: AdsAttribution;
  /** UUID minted client-side for Pixel/CAPI dedup. When omitted (e.g. webhook
   *  paths) the helper falls back to a fresh UUID for CAPI-only Lead events. */
  fbEventId?: string;
  /** First-hop client IP — required for high Event Match Quality. */
  clientIp?: string;
  /** Browser user-agent — required for high Event Match Quality. */
  clientUserAgent?: string;
};

export type CreateLeadResult =
  | { ok: true; leadId: string; code: string; isDuplicate: boolean }
  | { ok: false; error: "missing_consent" | "invalid_email" | "db_error" };

const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

/**
 * Capture a lead and issue a redeem code.
 *
 * Idempotency: when args.fbLeadId is provided (FB Instant Form path), the
 * UNIQUE constraint on leads.fb_lead_id makes this a no-op replay. The
 * existing lead is returned along with its outstanding code.
 *
 * Email is fired-and-forgotten — failures are logged but don't block the
 * caller, since the lead is the durable record and the code can be re-sent.
 */
export async function createLead(
  args: CreateLeadArgs
): Promise<CreateLeadResult> {
  if (!args.consentPdpa) return { ok: false, error: "missing_consent" };
  if (!EMAIL_REGEX.test(args.email)) return { ok: false, error: "invalid_email" };

  const supabase = createAdminClient();
  const email = args.email.trim().toLowerCase();

  if (args.fbLeadId) {
    const { data: existing } = await supabase
      .from("leads")
      .select("id")
      .eq("fb_lead_id", args.fbLeadId)
      .maybeSingle();
    if (existing) {
      const { data: code } = await supabase
        .from("redeem_codes")
        .select("code")
        .eq("lead_id", existing.id)
        .order("created_at", { ascending: false })
        .limit(1)
        .maybeSingle();
      return {
        ok: true,
        leadId: existing.id,
        code: code?.code ?? "",
        isDuplicate: true,
      };
    }
  }

  const { data: lead, error: leadError } = await supabase
    .from("leads")
    .insert({
      source: args.source,
      campaign: args.campaign ?? null,
      ad_set: args.adSet ?? null,
      fb_lead_id: args.fbLeadId ?? null,
      email,
      phone: args.phone ?? null,
      name: args.name ?? null,
      status_year: args.statusYear ?? null,
      exam_target: args.examTarget ?? null,
      reward_choice: args.rewardChoice,
      stage: "code_issued",
      consent_pdpa: args.consentPdpa,
      consent_at: new Date().toISOString(),
      raw_payload: args.rawPayload ?? null,
      gclid: args.attribution?.gclid ?? null,
      gbraid: args.attribution?.gbraid ?? null,
      wbraid: args.attribution?.wbraid ?? null,
      fbclid: args.attribution?.fbclid ?? null,
      fbc: args.attribution?.fbc ?? null,
      fbp: args.attribution?.fbp ?? null,
      fb_event_id: args.fbEventId ?? null,
      utm_source: args.attribution?.utm_source ?? null,
      utm_medium: args.attribution?.utm_medium ?? null,
      utm_campaign: args.attribution?.utm_campaign ?? null,
      utm_term: args.attribution?.utm_term ?? null,
      utm_content: args.attribution?.utm_content ?? null,
      landing_page: args.attribution?.landing_page ?? null,
    })
    .select("id")
    .single();

  if (leadError || !lead) {
    console.error("createLead insert failed:", leadError);
    return { ok: false, error: "db_error" };
  }

  let code: string;
  try {
    const issued = await issueRedeemCode({
      rewardType: args.rewardChoice,
      source: args.source,
      campaign: args.campaign,
      leadId: lead.id,
      issuedToEmail: email,
    });
    code = issued.code;

    const siteUrl = process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com";
    sendRedeemCodeEmail({
      email,
      name: args.name ?? "คุณหมอ",
      code: issued.code,
      rewardLabel: REWARD_LABEL[args.rewardChoice],
      expiresAt: issued.expiresAt.toISOString(),
      redeemUrl: `${siteUrl}/redeem/${issued.code}`,
    }).catch((e) => {
      console.error("createLead email failed:", e);
    });
  } catch (e) {
    console.error("createLead issueRedeemCode failed:", e);
    return { ok: false, error: "db_error" };
  }

  // Fire-and-forget offline conversion upload to Google Ads. No-op when the
  // server-side credentials aren't configured. We don't await — the lead is
  // already saved, and conversion latency shouldn't block the API response.
  if (args.attribution?.gclid || args.attribution?.gbraid || args.attribution?.wbraid) {
    uploadOfflineConversion({
      type: "lead",
      gclid: args.attribution.gclid ?? null,
      gbraid: args.attribution.gbraid ?? null,
      wbraid: args.attribution.wbraid ?? null,
      conversionValue: args.rewardChoice === "monthly_1m" ? 199 : 50,
      currencyCode: "THB",
      orderId: lead.id,
      email,
      phone: args.phone,
    })
      .then(async (result) => {
        if (result.ok) {
          await supabase
            .from("leads")
            .update({ conv_uploaded_at: new Date().toISOString() })
            .eq("id", lead.id);
        }
      })
      .catch((e) => console.error("[leads] offline conversion upload failed:", e));
  }

  // Fire-and-forget Meta CAPI Lead. The same event_id was already fired
  // browser-side by the form (or, for FB Instant Form leads, fb_lead_id
  // doubles as event_id since there's no browser context).
  const capiEventId =
    args.fbEventId ?? (args.fbLeadId ? `fb_lead_${args.fbLeadId}` : newEventId());
  const actionSource = args.fbLeadId ? "system_generated" : "website";
  const eventSourceUrl = args.fbLeadId
    ? "https://www.facebook.com"
    : args.attribution?.landing_page
      ? `${process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com"}${args.attribution.landing_page}`
      : process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com";

  sendCapiEvent({
    eventName: "Lead",
    eventId: capiEventId,
    actionSource,
    eventSourceUrl,
    userData: {
      em: sha256Norm(email),
      ph: args.phone ? sha256Norm(normalizePhoneTH(args.phone).replace(/^\+/, "")) : undefined,
      fbc: args.attribution?.fbc,
      fbp: args.attribution?.fbp,
      client_ip_address: args.clientIp,
      client_user_agent: args.clientUserAgent,
      external_id: lead.id,
    },
    customData: {
      value: args.rewardChoice === "monthly_1m" ? 199 : 50,
      currency: "THB",
      content_name: "free_trial",
    },
  })
    .then(async (result) => {
      if (result.ok) {
        await supabase
          .from("leads")
          .update({ fb_capi_uploaded_at: new Date().toISOString() })
          .eq("id", lead.id);
      }
    })
    .catch((e) => console.error("[leads] CAPI Lead upload failed:", e));

  return { ok: true, leadId: lead.id, code, isDuplicate: false };
}
