/**
 * Notify admin via LINE when a customer submits a bank-transfer payment slip.
 *
 * The payment page calls this (fire-and-forget) right after inserting a
 * pending payment_orders row, so the admin gets a LINE push and can review
 * the slip at /admin/payments without waiting for the daily digest.
 *
 * POST /api/payment/notify-admin  { orderId }
 */

import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { sendLineMessage, type LineMessage } from "@/lib/line";

export const runtime = "nodejs";

const PLAN_LABELS: Record<string, string> = {
  monthly: "รายเดือน",
  yearly: "รายปี",
  bundle: "ชุดข้อสอบ",
  board_monthly: "Board รายเดือน",
  board_yearly: "Board รายปี",
};

function infoRow(label: string, value: string) {
  return {
    type: "box",
    layout: "horizontal",
    contents: [
      { type: "text", text: label, size: "sm", color: "#8c8c8c", flex: 2 },
      {
        type: "text",
        text: value,
        size: "sm",
        color: "#111111",
        weight: "bold",
        flex: 4,
        wrap: true,
        align: "end",
      },
    ],
  };
}

export async function POST(request: Request) {
  const adminLineId = process.env.ADMIN_LINE_USER_ID;
  if (!adminLineId) {
    // Not configured — nothing to do, but don't surface as an error to the client.
    return NextResponse.json({ ok: false, skipped: "ADMIN_LINE_USER_ID not configured" });
  }

  let orderId: string | undefined;
  try {
    const body = await request.json();
    orderId = body?.orderId;
  } catch {
    return NextResponse.json({ ok: false, error: "Invalid body" }, { status: 400 });
  }
  if (!orderId) {
    return NextResponse.json({ ok: false, error: "orderId required" }, { status: 400 });
  }

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json({ ok: false, error: "Unauthorized" }, { status: 401 });
  }

  // RLS limits this read to the caller's own orders, so a user can only ever
  // trigger a notification for an order that belongs to them.
  const { data: order } = await supabase
    .from("payment_orders")
    .select("id, user_id, plan_type, amount, status, created_at")
    .eq("id", orderId)
    .single();

  if (!order || order.user_id !== user.id) {
    return NextResponse.json({ ok: false, error: "Order not found" }, { status: 404 });
  }

  // Only pending (bank-transfer) orders need a manual review nudge. Stripe
  // orders are created server-side as "approved" and never hit this route.
  if (order.status !== "pending") {
    return NextResponse.json({ ok: false, skipped: "order not pending" });
  }

  const { data: profile } = await supabase
    .from("profiles")
    .select("name, email")
    .eq("id", user.id)
    .single();

  const siteUrl = process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com";
  const planLabel = PLAN_LABELS[order.plan_type] ?? order.plan_type;
  const customerName = profile?.name || profile?.email || user.email || "ลูกค้า";
  const amountThb = Number(order.amount).toLocaleString();
  const timeLabel = new Date(order.created_at).toLocaleString("th-TH", {
    timeZone: "Asia/Bangkok",
  });

  const flex: LineMessage = {
    type: "flex",
    altText: `💸 ${customerName} แจ้งโอนเงิน ฿${amountThb} (${planLabel})`,
    contents: {
      type: "bubble",
      body: {
        type: "box",
        layout: "vertical",
        spacing: "md",
        contents: [
          {
            type: "text",
            text: "💸 มีลูกค้าแจ้งโอนเงิน",
            weight: "bold",
            size: "lg",
            color: "#1DB446",
          },
          {
            type: "box",
            layout: "vertical",
            spacing: "sm",
            margin: "md",
            contents: [
              infoRow("ลูกค้า", customerName),
              infoRow("อีเมล", profile?.email || user.email || "-"),
              infoRow("แพ็กเกจ", planLabel),
              infoRow("ยอดโอน", `฿${amountThb}`),
              infoRow("เวลา", timeLabel),
            ],
          },
        ],
      },
      footer: {
        type: "box",
        layout: "vertical",
        contents: [
          {
            type: "button",
            style: "primary",
            color: "#1DB446",
            action: {
              type: "uri",
              label: "ตรวจสอบสลิป",
              uri: `${siteUrl}/admin/payments`,
            },
          },
        ],
      },
    },
  };

  const ok = await sendLineMessage(adminLineId, [flex]);
  return NextResponse.json({ ok });
}
