import { NextResponse, after } from "next/server";
import { cookies, headers } from "next/headers";
import { createLead } from "@/lib/leads";
import { sendMetaEvent } from "@/lib/meta/events-api";
import type { RewardType } from "@/lib/redeem";

/**
 * POST /api/leads/create
 *
 * Public landing-form endpoint. Creates a lead with source='landing',
 * issues a redeem code, and emails it to the visitor.
 *
 * Body:
 *   {
 *     name, email, phone?, status_year?, exam_target?,
 *     reward_choice: "monthly_1m" | "bundle_10q",
 *     consent_pdpa: true,
 *     campaign?, ad_set?
 *   }
 */
type Body = {
  name?: unknown;
  email?: unknown;
  phone?: unknown;
  status_year?: unknown;
  exam_target?: unknown;
  reward_choice?: unknown;
  consent_pdpa?: unknown;
  campaign?: unknown;
  ad_set?: unknown;
};

const VALID_REWARDS: RewardType[] = ["monthly_1m", "bundle_10q"];
const VALID_EXAM_TARGETS = ["NL1", "NL2", "both", "unknown"] as const;

export async function POST(request: Request) {
  let body: Body;
  try {
    body = (await request.json()) as Body;
  } catch {
    return NextResponse.json({ error: "invalid_body" }, { status: 400 });
  }

  const email = typeof body.email === "string" ? body.email.trim() : "";
  const reward =
    typeof body.reward_choice === "string" &&
    VALID_REWARDS.includes(body.reward_choice as RewardType)
      ? (body.reward_choice as RewardType)
      : null;
  const consent = body.consent_pdpa === true;

  if (!email) return NextResponse.json({ error: "missing_email" }, { status: 400 });
  if (!reward) return NextResponse.json({ error: "missing_reward" }, { status: 400 });
  if (!consent) return NextResponse.json({ error: "missing_consent" }, { status: 400 });

  const examTarget =
    typeof body.exam_target === "string" &&
    (VALID_EXAM_TARGETS as readonly string[]).includes(body.exam_target)
      ? (body.exam_target as (typeof VALID_EXAM_TARGETS)[number])
      : undefined;

  const result = await createLead({
    source: "landing",
    campaign: typeof body.campaign === "string" ? body.campaign : undefined,
    adSet: typeof body.ad_set === "string" ? body.ad_set : undefined,
    email,
    phone: typeof body.phone === "string" ? body.phone : undefined,
    name: typeof body.name === "string" ? body.name : undefined,
    statusYear: typeof body.status_year === "string" ? body.status_year : undefined,
    examTarget,
    rewardChoice: reward,
    consentPdpa: consent,
    rawPayload: body as Record<string, unknown>,
  });

  if (!result.ok) {
    const status = result.error === "db_error" ? 500 : 400;
    return NextResponse.json({ error: result.error }, { status });
  }

  // Server-side Meta Lead — the free-trial form is the primary ad conversion,
  // and without this event Meta never sees it (can't optimize or attribute).
  // eventId `lead:<code>` keys dedup against the browser fbq copy in LeadForm.
  const [cookieStore, headerStore] = await Promise.all([cookies(), headers()]);
  const ip =
    headerStore.get("x-forwarded-for")?.split(",")[0]?.trim() || null;
  const fullName = typeof body.name === "string" ? body.name.trim() : "";
  const [firstName, ...restName] = fullName.split(/\s+/);
  after(() =>
    sendMetaEvent({
      event: "Lead",
      eventId: `lead:${result.code}`,
      email,
      firstName: firstName || null,
      lastName: restName.join(" ") || null,
      ip,
      userAgent: headerStore.get("user-agent"),
      fbc: cookieStore.get("_fbc")?.value ?? null,
      fbp: cookieStore.get("_fbp")?.value ?? null,
      url: "https://www.morroo.com/lp/free-trial",
      contentName: "free_trial",
    })
  );

  return NextResponse.json({ ok: true, code: result.code });
}
