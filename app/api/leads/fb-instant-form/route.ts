import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { verifyFbSignature } from "@/lib/facebook-messenger";
import { issueRedeemCode, type RewardType } from "@/lib/redeem";
import { sendRedeemCodeEmail } from "@/lib/email/send";

export const runtime = "nodejs";
export const maxDuration = 30;

const GRAPH_API = "https://graph.facebook.com/v24.0";

/**
 * GET = subscription verification handshake (same scheme as the Messenger webhook).
 * Configure this URL in the FB App webhook subscription for the `leadgen` field.
 */
export async function GET(request: NextRequest) {
  const url = new URL(request.url);
  const mode = url.searchParams.get("hub.mode");
  const token = url.searchParams.get("hub.verify_token");
  const challenge = url.searchParams.get("hub.challenge");

  const expected = process.env.FACEBOOK_VERIFY_TOKEN;
  if (!expected) {
    return NextResponse.json({ error: "Server not configured" }, { status: 500 });
  }
  if (mode === "subscribe" && token === expected && challenge) {
    return new NextResponse(challenge, { status: 200 });
  }
  return NextResponse.json({ error: "Forbidden" }, { status: 403 });
}

type LeadgenChange = {
  field?: string;
  value?: {
    leadgen_id?: string;
    form_id?: string;
    ad_id?: string;
    adgroup_id?: string;
    page_id?: string;
    created_time?: number;
  };
};

type LeadgenEntry = {
  id?: string;
  time?: number;
  changes?: LeadgenChange[];
};

type LeadgenWebhookBody = {
  object?: string;
  entry?: LeadgenEntry[];
};

interface FbLeadField {
  name: string;
  values: string[];
}

interface FbLeadDetails {
  id: string;
  created_time?: string;
  field_data?: FbLeadField[];
  ad_id?: string;
  adset_id?: string;
  campaign_id?: string;
  form_id?: string;
}

async function fetchLeadDetails(leadgenId: string): Promise<FbLeadDetails | null> {
  const token = process.env.FACEBOOK_PAGE_TOKEN;
  if (!token) {
    console.error("[fb-leadgen] FACEBOOK_PAGE_TOKEN not set");
    return null;
  }
  const res = await fetch(
    `${GRAPH_API}/${encodeURIComponent(leadgenId)}?access_token=${encodeURIComponent(token)}`,
    { method: "GET" }
  );
  if (!res.ok) {
    const err = await res.text().catch(() => "<no body>");
    console.error(`[fb-leadgen] fetch lead failed status=${res.status} body=${err}`);
    return null;
  }
  return res.json();
}

const FIELD_MAP: Record<string, string> = {
  full_name: "name",
  name: "name",
  first_name: "first_name",
  last_name: "last_name",
  email: "email",
  phone_number: "phone",
  phone: "phone",
};

function pickField(data: FbLeadField[], target: string): string | undefined {
  const row = data.find(
    (f) => FIELD_MAP[f.name?.toLowerCase()] === target || f.name?.toLowerCase() === target
  );
  return row?.values?.[0]?.trim() || undefined;
}

function pickByContains(data: FbLeadField[], substrings: string[]): string | undefined {
  const lower = data.map((f) => ({ ...f, _n: f.name?.toLowerCase() ?? "" }));
  for (const s of substrings) {
    const hit = lower.find((f) => f._n.includes(s));
    if (hit?.values?.[0]) return hit.values[0].trim();
  }
  return undefined;
}

function inferRewardChoice(value: string | undefined): RewardType {
  if (!value) return "monthly_1m";
  const v = value.toLowerCase();
  if (v.includes("bundle") || v.includes("ชุด") || v.includes("10 ข้อ")) return "bundle_10q";
  return "monthly_1m";
}

function inferExamTarget(value: string | undefined): "NL1" | "NL2" | "both" | "unknown" {
  if (!value) return "unknown";
  const v = value.toUpperCase();
  if (v.includes("NL1") && v.includes("NL2")) return "both";
  if (v.includes("BOTH") || v.includes("ทั้งสอง")) return "both";
  if (v.includes("NL1")) return "NL1";
  if (v.includes("NL2")) return "NL2";
  return "unknown";
}

async function processLeadgen(leadgenId: string, change: LeadgenChange): Promise<void> {
  const details = await fetchLeadDetails(leadgenId);
  if (!details) return;

  const fields = details.field_data ?? [];
  const fullName =
    pickField(fields, "name") ||
    [pickField(fields, "first_name"), pickField(fields, "last_name")].filter(Boolean).join(" ").trim() ||
    "ผู้สนใจ";
  const email = pickField(fields, "email");
  const phone = pickField(fields, "phone");
  const statusYear = pickByContains(fields, ["status", "สถานะ", "ปี", "ระดับ"]);
  const examTargetRaw = pickByContains(fields, ["exam", "สอบ", "nl"]);
  const rewardRaw = pickByContains(fields, ["reward", "รางวัล", "เลือก", "premium", "bundle"]);

  if (!email) {
    console.warn("[fb-leadgen] missing email on lead", leadgenId);
    return;
  }

  const supabase = createAdminClient();

  const { data: lead, error: insertErr } = await supabase
    .from("leads")
    .upsert(
      {
        source: "fb_leadgen_form",
        campaign: change.value?.ad_id ?? null,
        ad_set: change.value?.adgroup_id ?? null,
        fb_lead_id: leadgenId,
        email: email.toLowerCase(),
        phone: phone ?? null,
        name: fullName,
        status_year: statusYear ?? null,
        exam_target: inferExamTarget(examTargetRaw),
        reward_choice: inferRewardChoice(rewardRaw),
        stage: "code_issued",
        consent_pdpa: true,
        consent_at: new Date().toISOString(),
        raw_payload: { change, details } as object,
      },
      { onConflict: "fb_lead_id" }
    )
    .select("id, reward_choice, email, name")
    .single();

  if (insertErr || !lead) {
    console.error("[fb-leadgen] insert error:", insertErr);
    return;
  }

  const code = await issueRedeemCode({
    supabase,
    rewardType: lead.reward_choice as RewardType,
    source: "fb_leadgen_form",
    campaign: change.value?.ad_id ?? null,
    leadId: lead.id,
    email: lead.email,
  });

  try {
    await sendRedeemCodeEmail({
      name: lead.name,
      email: lead.email,
      code: code.code,
      rewardType: lead.reward_choice as RewardType,
      expiresAt: code.expires_at,
    });
    await supabase
      .from("lead_messages_sent")
      .insert({ lead_id: lead.id, day: 0, channel: "email" })
      .then(() => null, () => null);
  } catch (e) {
    console.error("[fb-leadgen] email send failed:", e);
  }
}

export async function POST(request: NextRequest) {
  const rawBody = await request.text();
  const signature = request.headers.get("x-hub-signature-256");

  if (!verifyFbSignature(rawBody, signature)) {
    return NextResponse.json({ error: "Invalid signature" }, { status: 401 });
  }

  const body = JSON.parse(rawBody) as LeadgenWebhookBody;
  if (body.object !== "page") {
    return NextResponse.json({ ok: true });
  }

  for (const entry of body.entry ?? []) {
    for (const change of entry.changes ?? []) {
      if (change.field !== "leadgen" || !change.value?.leadgen_id) continue;
      try {
        await processLeadgen(change.value.leadgen_id, change);
      } catch (e) {
        console.error("[fb-leadgen] process error:", e);
      }
    }
  }

  return NextResponse.json({ ok: true });
}
