import { NextResponse } from "next/server";
import { createLead } from "@/lib/leads";
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
  attribution?: unknown;
};

const ATTRIBUTION_KEYS = [
  "gclid",
  "gbraid",
  "wbraid",
  "utm_source",
  "utm_medium",
  "utm_campaign",
  "utm_term",
  "utm_content",
  "landing_page",
] as const;

function pickAttribution(input: unknown) {
  if (!input || typeof input !== "object") return undefined;
  const src = input as Record<string, unknown>;
  const out: Record<string, string> = {};
  for (const k of ATTRIBUTION_KEYS) {
    const v = src[k];
    if (typeof v === "string" && v.length > 0 && v.length < 1024) {
      out[k] = v;
    }
  }
  return Object.keys(out).length > 0 ? out : undefined;
}

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
    attribution: pickAttribution(body.attribution),
  });

  if (!result.ok) {
    const status = result.error === "db_error" ? 500 : 400;
    return NextResponse.json({ error: result.error }, { status });
  }

  return NextResponse.json({ ok: true, code: result.code });
}
