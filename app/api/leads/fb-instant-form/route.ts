import { NextResponse } from "next/server";
import {
  verifyWebhookSignature,
  fetchLeadgenData,
  mapFieldData,
  rewardForForm,
} from "@/lib/facebook-leads";
import { createLead } from "@/lib/leads";

/**
 * Facebook Lead Ads (Instant Form) webhook.
 *
 * GET — Meta's webhook subscription verification handshake.
 *   Query: hub.mode=subscribe & hub.verify_token=<...> & hub.challenge=<...>
 *   Echoes hub.challenge if the token matches.
 *
 * POST — Lead notification. Verifies HMAC signature, fetches the full lead
 *   from Graph, maps standard + Thai-aliased fields, and inserts via
 *   createLead (idempotent on fb_lead_id). The form's lack of a reward
 *   field falls back to FACEBOOK_LEAD_FORM_REWARDS or 'monthly_1m'.
 *
 * Meta retries on non-2xx responses, so we always 200 after best-effort
 * processing — except on signature failure, where 401 prevents replay
 * abuse from spoofed senders.
 */

export async function GET(request: Request) {
  const url = new URL(request.url);
  const mode = url.searchParams.get("hub.mode");
  const token = url.searchParams.get("hub.verify_token");
  const challenge = url.searchParams.get("hub.challenge");

  const expected = process.env.FACEBOOK_LEADS_VERIFY_TOKEN;
  if (mode === "subscribe" && expected && token === expected && challenge) {
    return new Response(challenge, {
      status: 200,
      headers: { "content-type": "text/plain" },
    });
  }
  return new Response("forbidden", { status: 403 });
}

type Change = {
  field?: string;
  value?: {
    leadgen_id?: string;
    page_id?: string;
    form_id?: string;
    ad_id?: string;
    adgroup_id?: string;
    created_time?: number;
  };
};
type Entry = { id?: string; time?: number; changes?: Change[] };
type WebhookBody = { object?: string; entry?: Entry[] };

export async function POST(request: Request) {
  const appSecret = process.env.FACEBOOK_APP_SECRET;
  if (!appSecret) {
    console.error("[fb-leads] FACEBOOK_APP_SECRET missing");
    return NextResponse.json({ error: "config" }, { status: 500 });
  }

  const rawBody = await request.text();
  const sig = request.headers.get("x-hub-signature-256");
  if (!verifyWebhookSignature(rawBody, sig, appSecret)) {
    console.warn("[fb-leads] signature verification failed");
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  }

  let body: WebhookBody;
  try {
    body = JSON.parse(rawBody) as WebhookBody;
  } catch {
    return NextResponse.json({ error: "invalid_json" }, { status: 400 });
  }

  if (body.object !== "page") {
    // Other webhook objects can share the same endpoint in Meta config; ignore.
    return NextResponse.json({ ok: true, ignored: "non_page" });
  }

  const results: Array<{ leadgen_id: string; status: string }> = [];
  for (const entry of body.entry ?? []) {
    for (const change of entry.changes ?? []) {
      if (change.field !== "leadgen") continue;
      const leadgenId = change.value?.leadgen_id;
      if (!leadgenId) continue;

      try {
        const result = await processLead(leadgenId, change.value);
        results.push({ leadgen_id: leadgenId, status: result });
      } catch (e) {
        console.error("[fb-leads] processing failed for", leadgenId, e);
        results.push({ leadgen_id: leadgenId, status: "error" });
      }
    }
  }

  // Always 200 to prevent Meta retry storms after partial success.
  return NextResponse.json({ ok: true, results });
}

async function processLead(
  leadgenId: string,
  webhookValue: Change["value"]
): Promise<string> {
  const lead = await fetchLeadgenData(leadgenId);
  if (!lead) return "fetch_failed";

  const mapped = mapFieldData(lead.field_data);
  if (!mapped.email) {
    console.warn("[fb-leads] lead missing email:", leadgenId);
    return "no_email";
  }

  const reward = mapped.rewardChoice ?? rewardForForm(lead.form_id);

  const result = await createLead({
    source: "fb_leadgen_form",
    campaign: lead.campaign_id ?? webhookValue?.ad_id,
    adSet: lead.adset_id ?? webhookValue?.adgroup_id,
    fbLeadId: leadgenId,
    email: mapped.email,
    phone: mapped.phone,
    name: mapped.name,
    statusYear: mapped.statusYear,
    examTarget: mapped.examTarget,
    rewardChoice: reward,
    consentPdpa: true, // FB Lead Ads enforce consent at form level
    rawPayload: { webhook: webhookValue, graph: lead },
  });

  if (!result.ok) return `error:${result.error}`;
  return result.isDuplicate ? "duplicate" : "created";
}
