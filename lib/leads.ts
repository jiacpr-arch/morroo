import { createAdminClient } from "@/lib/supabase/admin";
import { issueRedeemCode, type RewardType, type RedeemSource } from "@/lib/redeem";
import { sendRedeemCodeEmail } from "@/lib/email/send";
import { sendMetaLead } from "@/lib/meta-capi";
import { sendTikTokLead } from "@/lib/tiktok-events";

const REWARD_LABEL: Record<RewardType, string> = {
  monthly_1m: "สมาชิกรายเดือน 1 เดือน",
  bundle_10q: "Bundle 10 ข้อ",
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

  // Fire server-side Lead events (non-blocking)
  const capiUser = { email, phone: args.phone };
  Promise.all([
    sendMetaLead({ user: capiUser }),
    sendTikTokLead({ user: capiUser }),
  ]).catch((e) => console.error("[CAPI] lead event error:", e));

  return { ok: true, leadId: lead.id, code, isDuplicate: false };
}
