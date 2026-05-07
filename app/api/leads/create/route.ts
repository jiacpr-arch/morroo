import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { issueRedeemCode, type RewardType } from "@/lib/redeem";
import { sendRedeemCodeEmail } from "@/lib/email/send";

export const runtime = "nodejs";

interface LeadPayload {
  name: string;
  email: string;
  phone?: string;
  status_year?: string;
  exam_target?: "NL1" | "NL2" | "both" | "unknown";
  reward_choice: RewardType;
  consent_pdpa: boolean;
  campaign?: string;
  ad_set?: string;
  source?: "landing" | "organic";
}

function validate(p: Partial<LeadPayload>): { ok: true; v: LeadPayload } | { ok: false; error: string } {
  if (!p.name?.trim()) return { ok: false, error: "กรุณาระบุชื่อ" };
  if (!p.email?.trim() || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(p.email))
    return { ok: false, error: "อีเมลไม่ถูกต้อง" };
  if (p.reward_choice !== "monthly_1m" && p.reward_choice !== "bundle_10q")
    return { ok: false, error: "กรุณาเลือกรางวัล" };
  if (!p.consent_pdpa) return { ok: false, error: "กรุณายอมรับเงื่อนไขการติดต่อกลับ (PDPA)" };
  return {
    ok: true,
    v: {
      name: p.name.trim(),
      email: p.email.trim().toLowerCase(),
      phone: p.phone?.trim() || undefined,
      status_year: p.status_year?.trim() || undefined,
      exam_target: p.exam_target ?? "unknown",
      reward_choice: p.reward_choice,
      consent_pdpa: true,
      campaign: p.campaign?.trim() || undefined,
      ad_set: p.ad_set?.trim() || undefined,
      source: p.source === "organic" ? "organic" : "landing",
    },
  };
}

export async function POST(request: NextRequest) {
  let body: Partial<LeadPayload>;
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ ok: false, error: "ข้อมูลคำขอไม่ถูกต้อง" }, { status: 400 });
  }

  const check = validate(body);
  if (!check.ok) {
    return NextResponse.json({ ok: false, error: check.error }, { status: 400 });
  }
  const v = check.v;

  const supabase = createAdminClient();

  const { data: existing } = await supabase
    .from("leads")
    .select("id")
    .eq("email", v.email)
    .eq("source", v.source!)
    .limit(1);
  if (existing && existing.length > 0) {
    return NextResponse.json(
      { ok: false, error: "อีเมลนี้เคยลงทะเบียนแล้ว — เช็คกล่องอีเมลของคุณ" },
      { status: 409 }
    );
  }

  const { data: lead, error: insertErr } = await supabase
    .from("leads")
    .insert({
      source: v.source,
      campaign: v.campaign ?? null,
      ad_set: v.ad_set ?? null,
      email: v.email,
      phone: v.phone ?? null,
      name: v.name,
      status_year: v.status_year ?? null,
      exam_target: v.exam_target,
      reward_choice: v.reward_choice,
      stage: "code_issued",
      consent_pdpa: true,
      consent_at: new Date().toISOString(),
      raw_payload: body,
    })
    .select("id")
    .single();

  if (insertErr || !lead) {
    console.error("[leads/create] insert error:", insertErr);
    return NextResponse.json({ ok: false, error: "ไม่สามารถบันทึกข้อมูลได้" }, { status: 500 });
  }

  const code = await issueRedeemCode({
    supabase,
    rewardType: v.reward_choice,
    source: v.source!,
    campaign: v.campaign ?? null,
    leadId: lead.id,
    email: v.email,
  });

  try {
    await sendRedeemCodeEmail({
      name: v.name,
      email: v.email,
      code: code.code,
      rewardType: v.reward_choice,
      expiresAt: code.expires_at,
    });
    await supabase
      .from("lead_messages_sent")
      .insert({ lead_id: lead.id, day: 0, channel: "email" })
      .then(() => null, () => null);
  } catch (e) {
    console.error("[leads/create] email send failed:", e);
  }

  return NextResponse.json({
    ok: true,
    leadId: lead.id,
    code: code.code,
    redeemUrl: `/redeem/${code.code}`,
  });
}
