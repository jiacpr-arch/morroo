/**
 * Admin review of a bank-transfer payment order.
 *
 * POST /api/admin/payments/review  { orderId, action: "approve"|"reject", note? }
 *
 * Replaces the old client-side approval in /admin/payments, which wrote to
 * the DB directly from the browser and never told the customer anything —
 * the root cause of the "paid ฿199, sent the slip 3 times, nobody answered"
 * incident. Approve runs the same fulfillment as an auto-verified slip
 * (membership + invoice + referral + buyer LINE/email). Reject records the
 * reason and notifies the customer with a resubmit link.
 */

import { NextRequest, NextResponse, after } from "next/server";
import { requireAdmin } from "@/lib/admin-auth";
import { createAdminClient } from "@/lib/supabase/admin";
import { fulfillSlipOrder } from "@/lib/billing/fulfill-slip-order";
import { sendFulfillmentNotifications } from "@/lib/billing/send-fulfillment-notifications";
import { PLAN_LABELS_TH } from "@/lib/billing/fulfillment-core";
import { sendLineMessage } from "@/lib/line";
import { sendPaymentRejectedEmail } from "@/lib/email/send";

export const runtime = "nodejs";

const SITE = process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com";

export async function POST(request: NextRequest) {
  const auth = await requireAdmin();
  if (!auth.ok) return auth.response;

  let orderId: string | undefined;
  let action: string | undefined;
  let note: string | undefined;
  try {
    const body = await request.json();
    orderId = body?.orderId;
    action = body?.action;
    note = typeof body?.note === "string" ? body.note.trim() : undefined;
  } catch {
    return NextResponse.json({ error: "invalid body" }, { status: 400 });
  }

  if (!orderId || (action !== "approve" && action !== "reject")) {
    return NextResponse.json({ error: "orderId and action required" }, { status: 400 });
  }

  const admin = createAdminClient();
  const { data: order } = await admin
    .from("payment_orders")
    .select("id, user_id, plan_type, amount, status")
    .eq("id", orderId)
    .maybeSingle();

  if (!order) {
    return NextResponse.json({ error: "order not found" }, { status: 404 });
  }
  if (order.status !== "pending") {
    return NextResponse.json({ error: "order already reviewed" }, { status: 409 });
  }

  if (action === "approve") {
    if (note) {
      await admin.from("payment_orders").update({ note }).eq("id", orderId);
    }
    const fulfillment = await fulfillSlipOrder({ orderId, reviewedBy: auth.userId });
    if (fulfillment.alreadyProcessed) {
      return NextResponse.json({ error: "order already reviewed" }, { status: 409 });
    }
    if (fulfillment.notify) {
      const notify = fulfillment.notify;
      after(() => sendFulfillmentNotifications(notify));
    }
    return NextResponse.json({
      ok: true,
      status: "approved",
      expiresAt: fulfillment.notify?.expiresAt ?? null,
    });
  }

  // ── Reject ──────────────────────────────────────────────────────────────
  const { data: rejected, error: rejectError } = await admin
    .from("payment_orders")
    .update({
      status: "rejected",
      note: note || null,
      reviewed_by: auth.userId,
      reviewed_at: new Date().toISOString(),
    })
    .eq("id", orderId)
    .eq("status", "pending")
    .select("id");

  if (rejectError) {
    console.error("[payments/review] reject failed:", rejectError);
    return NextResponse.json({ error: "reject failed" }, { status: 500 });
  }
  if (!rejected || rejected.length === 0) {
    return NextResponse.json({ error: "order already reviewed" }, { status: 409 });
  }

  const { data: buyer } = await admin
    .from("profiles")
    .select("name, email, line_user_id")
    .eq("id", order.user_id)
    .maybeSingle();

  const planLabel = PLAN_LABELS_TH[order.plan_type] ?? order.plan_type;
  const amount = Number(order.amount);
  const retryUrl = `${SITE}/payment/${order.plan_type}`;
  const reasonText = note || "ไม่สามารถยืนยันการชำระเงินได้";

  after(async () => {
    if (buyer?.line_user_id) {
      try {
        await sendLineMessage(buyer.line_user_id, [
          {
            type: "text",
            text:
              `❌ การแจ้งโอนเงินยังไม่ผ่านการตรวจสอบ\n\n` +
              `แพ็กเกจ: หมอรู้ ${planLabel} (฿${amount.toLocaleString("th-TH")})\n` +
              `เหตุผล: ${reasonText}\n\n` +
              `หากโอนเงินแล้วจริง ส่งสลิปอีกครั้งได้ที่\n${retryUrl}\n` +
              `หรือทักแชทนี้ได้เลยครับ 🙏`,
          },
        ]);
      } catch (err) {
        console.error("[payments/review] LINE reject notify error:", err);
      }
    }
    if (buyer?.email) {
      try {
        await sendPaymentRejectedEmail({
          email: buyer.email,
          name: buyer.name || "ลูกค้า",
          planLabel,
          amount,
          reason: note || undefined,
          retryUrl,
        });
      } catch (err) {
        console.error("[payments/review] reject email error:", err);
      }
    }
  });

  return NextResponse.json({ ok: true, status: "rejected" });
}
