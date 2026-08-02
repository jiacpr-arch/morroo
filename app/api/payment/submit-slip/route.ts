/**
 * Bank-transfer slip submission with automatic verification.
 *
 * POST /api/payment/submit-slip  { plan, storagePath }
 *
 * The client uploads the slip image to the private `slips` bucket first
 * (own-folder RLS policy), then calls this route with the storage path.
 * The route downloads the image server-side, runs it through the slip
 * verification provider (lib/slip-verify.ts), and:
 *
 * - verified + rules pass  → order approved + membership activated
 *   immediately; buyer/admin notified like a Stripe purchase.
 * - verified + rules fail  → order stays pending with the failure reason;
 *   admin gets a LINE flex to review manually. NEVER auto-rejects.
 * - provider not configured / down / unreadable image → same manual flow.
 *
 * Duplicate protection:
 * - one pending bank-transfer order per (user, plan)  → friendly response
 * - unique trans_ref across non-rejected orders       → 409 duplicate_slip
 */

import { NextRequest, NextResponse, after } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { getPlan } from "@/lib/plans";
import { getSlipConfig, validateSlip, verifySlip } from "@/lib/slip-verify";
import { fulfillSlipOrder } from "@/lib/billing/fulfill-slip-order";
import { sendFulfillmentNotifications } from "@/lib/billing/send-fulfillment-notifications";
import { PLAN_LABELS_TH } from "@/lib/billing/fulfillment-core";
import { notifyAdminPendingSlip } from "@/lib/notifications";
import { RATE_LIMITS, checkRateLimit, rateLimitResponse } from "@/lib/rate-limit";

export const runtime = "nodejs";

/** Thai one-liners for the admin flex "เหตุผล" row. */
const REASON_LABELS: Record<string, string> = {
  amount_mismatch: "ยอดโอนไม่ตรงกับราคาแพ็กเกจ",
  wrong_receiver: "บัญชีผู้รับไม่ตรง",
  stale_slip: "สลิปเก่าเกินกำหนด",
  invalid_slip: "อ่านสลิปไม่ได้",
  provider_error: "ระบบตรวจสลิปขัดข้อง",
  not_configured: "ยังไม่ได้เปิดใช้ระบบตรวจสลิปอัตโนมัติ",
};

export async function POST(request: NextRequest) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json({ error: "unauthenticated" }, { status: 401 });
  }

  let plan: string | undefined;
  let storagePath: string | undefined;
  try {
    const body = await request.json();
    plan = body?.plan;
    storagePath = body?.storagePath;
  } catch {
    return NextResponse.json({ error: "invalid body" }, { status: 400 });
  }

  const planInfo = plan ? getPlan(plan) : null;
  if (!plan || !planInfo) {
    return NextResponse.json({ error: "unknown plan" }, { status: 400 });
  }

  // The slip must live in the caller's own storage folder — otherwise a user
  // could submit someone else's uploaded slip.
  if (!storagePath || !storagePath.startsWith(`${user.id}/`)) {
    return NextResponse.json({ error: "invalid storage path" }, { status: 403 });
  }

  const rate = await checkRateLimit(supabase, user.id, "submit-slip", RATE_LIMITS.submitSlip);
  const limited = rateLimitResponse(rate, RATE_LIMITS.submitSlip);
  if (limited) return limited;

  const admin = createAdminClient();

  // One pending order per (user, plan): if a review is already in flight,
  // don't create another — tell the customer it's being processed.
  const { data: existingPending } = await admin
    .from("payment_orders")
    .select("id")
    .eq("user_id", user.id)
    .eq("plan_type", plan)
    .eq("payment_method", "bank_transfer")
    .eq("status", "pending")
    .maybeSingle();

  if (existingPending) {
    return NextResponse.json({ status: "pending_review", duplicate: true });
  }

  const { data: slipBlob, error: downloadError } = await admin.storage
    .from("slips")
    .download(storagePath);

  if (downloadError || !slipBlob) {
    return NextResponse.json({ error: "slip not found in storage" }, { status: 400 });
  }

  const buffer = Buffer.from(await slipBlob.arrayBuffer());
  const result = await verifySlip({
    buffer,
    contentType: slipBlob.type || "image/jpeg",
    filename: storagePath.split("/").pop() ?? "slip.jpg",
  });

  const config = getSlipConfig();

  // Fields shared by every insert below.
  const baseOrder = {
    user_id: user.id,
    plan_type: plan,
    amount: planInfo.amount,
    slip_url: storagePath,
    status: "pending",
    payment_method: "bank_transfer",
  };

  const { data: profile } = await admin
    .from("profiles")
    .select("name, email")
    .eq("id", user.id)
    .maybeSingle();

  const adminFlexPayload = (reason: string) => ({
    customerName: profile?.name || profile?.email || user.email || "ลูกค้า",
    customerEmail: profile?.email || user.email || "-",
    planLabel: PLAN_LABELS_TH[plan] ?? plan,
    amount: planInfo.amount,
    createdAt: new Date().toISOString(),
    reason: REASON_LABELS[reason] ?? reason,
  });

  // ── Verified slip ──────────────────────────────────────────────────────
  if (result.ok) {
    const validation = validateSlip({
      slip: result.slip,
      expectedAmount: planInfo.amount,
      receiverBankCode: config.receiverBankCode,
      receiverAccount: config.receiverAccount,
      maxAgeHours: config.maxAgeHours,
    });

    const verificationRecord = {
      provider: result.provider,
      slip: { ...result.slip, raw: undefined },
      validation,
      raw: result.slip.raw,
    };

    const { data: order, error: insertError } = await admin
      .from("payment_orders")
      .insert({
        ...baseOrder,
        trans_ref: result.slip.transRef,
        verified_by_provider: validation.valid ? result.provider : null,
        verification: verificationRecord,
        note: validation.valid ? null : REASON_LABELS[validation.code],
      })
      .select("id")
      .single();

    if (insertError) {
      // 23505 = unique violation on trans_ref: this exact bank transaction
      // already paid for an order.
      if (insertError.code === "23505") {
        return NextResponse.json(
          { error: "duplicate_slip", message: "สลิปนี้ถูกใช้ยืนยันการชำระเงินไปแล้ว" },
          { status: 409 }
        );
      }
      console.error("[submit-slip] order insert failed:", insertError);
      return NextResponse.json({ error: "order insert failed" }, { status: 500 });
    }

    if (validation.valid) {
      const fulfillment = await fulfillSlipOrder({ orderId: order.id, reviewedBy: null });
      if (fulfillment.notify) {
        const notify = fulfillment.notify;
        after(() => sendFulfillmentNotifications(notify));
      }
      return NextResponse.json({
        status: "approved",
        expiresAt: fulfillment.notify?.expiresAt ?? null,
      });
    }

    // Slip is real but doesn't pass business rules → manual review.
    after(() => notifyAdminPendingSlip(adminFlexPayload(validation.code)));
    return NextResponse.json({ status: "pending_review", reason: validation.code });
  }

  // ── Unverifiable (provider missing/down or unreadable image) ──────────
  const { error: insertError } = await admin.from("payment_orders").insert({
    ...baseOrder,
    verification: { failure: result.reason, detail: "detail" in result ? result.detail : null },
    note: REASON_LABELS[result.reason],
  });

  if (insertError) {
    console.error("[submit-slip] pending order insert failed:", insertError);
    return NextResponse.json({ error: "order insert failed" }, { status: 500 });
  }

  after(() => notifyAdminPendingSlip(adminFlexPayload(result.reason)));
  return NextResponse.json({ status: "pending_review", reason: result.reason });
}
