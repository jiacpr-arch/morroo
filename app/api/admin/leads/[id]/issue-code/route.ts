import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";
import { issueRedeemCode, type RewardType } from "@/lib/redeem";
import { sendRedeemCodeEmail } from "@/lib/email/send";

/**
 * POST /api/admin/leads/[id]/issue-code
 *
 * Admin action: generates a fresh redeem code for a lead and emails it.
 * Useful when:
 *   - the original code expired before the lead redeemed
 *   - the email delivery failed and the lead asks for a re-send
 *   - the lead's reward_choice was wrong and we want to reissue
 *
 * Body (all optional):
 *   { rewardType?: "monthly_1m" | "bundle_10q" }  // overrides lead's default
 *
 * Returns: { ok, code, expiresAt }
 */

const REWARD_LABEL: Record<RewardType, string> = {
  monthly_1m: "สมาชิกรายเดือน 1 เดือน",
  bundle_10q: "Bundle 10 ข้อ",
};
const VALID_REWARDS: RewardType[] = ["monthly_1m", "bundle_10q"];

export async function POST(
  request: Request,
  { params }: { params: Promise<{ id: string }> }
) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const { id } = await params;

  const supabase = createAdminClient();
  const { data: lead } = await supabase
    .from("leads")
    .select("id, email, name, reward_choice")
    .eq("id", id)
    .maybeSingle();

  if (!lead) {
    return NextResponse.json({ error: "lead_not_found" }, { status: 404 });
  }
  if (!lead.email) {
    return NextResponse.json({ error: "lead_has_no_email" }, { status: 400 });
  }

  let body: { rewardType?: unknown } = {};
  try {
    body = (await request.json()) as { rewardType?: unknown };
  } catch {
    // Empty body is fine — fall through to default.
  }

  const overrideReward =
    typeof body.rewardType === "string" &&
    (VALID_REWARDS as string[]).includes(body.rewardType)
      ? (body.rewardType as RewardType)
      : null;
  const rewardType: RewardType =
    overrideReward ??
    (lead.reward_choice as RewardType | null) ??
    "monthly_1m";

  const issued = await issueRedeemCode({
    rewardType,
    source: "admin",
    leadId: lead.id,
    issuedToEmail: lead.email,
  });

  // Bump stage back to code_issued so admin pipeline reflects the fresh code.
  await supabase
    .from("leads")
    .update({ stage: "code_issued", updated_at: new Date().toISOString() })
    .eq("id", lead.id);

  const siteUrl = process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com";
  try {
    await sendRedeemCodeEmail({
      email: lead.email,
      name: lead.name ?? "คุณหมอ",
      code: issued.code,
      rewardLabel: REWARD_LABEL[rewardType],
      expiresAt: issued.expiresAt.toISOString(),
      redeemUrl: `${siteUrl}/redeem/${issued.code}`,
    });
  } catch (e) {
    console.error("[admin/issue-code] email send failed:", e);
    // The code is already in DB — admin can copy/paste it manually.
  }

  return NextResponse.json({
    ok: true,
    code: issued.code,
    expiresAt: issued.expiresAt.toISOString(),
  });
}
