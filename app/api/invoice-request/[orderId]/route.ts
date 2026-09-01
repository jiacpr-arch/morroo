import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { createCashInvoice } from "@/lib/flowaccount";
import { emailReceipt } from "@/lib/notifications";

// GET — ดึงข้อมูล invoice สำหรับแสดงในฟอร์ม
export async function GET(
  _request: NextRequest,
  { params }: { params: Promise<{ orderId: string }> },
) {
  const { orderId } = await params;
  const supabase = createAdminClient();

  const { data: invoice, error } = await supabase
    .from("invoices")
    .select("invoice_number, plan_type, total_amount, buyer_name, buyer_tax_id, buyer_address, buyer_email, status")
    .eq("order_id", orderId)
    .single();

  if (error || !invoice) {
    return NextResponse.json({ error: "ไม่พบข้อมูลคำสั่งซื้อ" }, { status: 404 });
  }

  return NextResponse.json(invoice);
}

// POST — รับข้อมูลจากลูกค้า → อัพเดท invoice → สร้าง FlowAccount (ถ้ามี credentials)
export async function POST(
  request: NextRequest,
  { params }: { params: Promise<{ orderId: string }> },
) {
  const { orderId } = await params;

  const body = await request.json() as {
    buyerName?: string;
    buyerTaxId?: string;
    buyerAddress?: string;
    buyerEmail?: string;
  };

  if (!body.buyerName?.trim()) {
    return NextResponse.json({ error: "กรุณาระบุชื่อ" }, { status: 400 });
  }

  const supabase = createAdminClient();

  // ดึง invoice เดิม
  const { data: invoice, error: fetchError } = await supabase
    .from("invoices")
    .select("id, invoice_number, plan_type, amount, vat_amount, total_amount, stripe_session_id, issued_at")
    .eq("order_id", orderId)
    .single();

  if (fetchError || !invoice) {
    return NextResponse.json({ error: "ไม่พบข้อมูลคำสั่งซื้อ" }, { status: 404 });
  }

  // อัพเดทข้อมูลผู้ซื้อใน Supabase
  const { error: updateError } = await supabase
    .from("invoices")
    .update({
      buyer_name: body.buyerName.trim(),
      buyer_tax_id: body.buyerTaxId?.trim() || null,
      buyer_address: body.buyerAddress?.trim() || null,
      buyer_email: body.buyerEmail?.trim() || null,
    })
    .eq("id", invoice.id);

  if (updateError) {
    console.error("[invoice-request] update error:", updateError);
    return NextResponse.json({ error: "บันทึกไม่สำเร็จ" }, { status: 500 });
  }

  const publishedOn = new Date(invoice.issued_at).toISOString().slice(0, 10);

  // สร้างใบกำกับภาษีใน FlowAccount (non-blocking)
  createCashInvoice({
    planType: invoice.plan_type,
    totalAmount: invoice.total_amount,
    invoiceNumber: invoice.invoice_number,
    stripeSessionId: invoice.stripe_session_id ?? "",
    buyerName: body.buyerName.trim(),
    buyerTaxId: body.buyerTaxId?.trim() || undefined,
    buyerAddress: body.buyerAddress?.trim() || undefined,
    buyerEmail: body.buyerEmail?.trim() || undefined,
    publishedOn,
  }).then((result) => {
    if (result.ok) {
      console.log(`[FlowAccount] สร้างเอกสาร ${result.documentNumber} สำเร็จ (${invoice.invoice_number})`);
    } else {
      console.error(`[FlowAccount] สร้างเอกสารไม่สำเร็จ (${invoice.invoice_number}): ${result.error}`);
    }
  }).catch((err) => console.error("[FlowAccount] error:", err));

  // ส่ง email ใบเสร็จ (non-blocking)
  if (body.buyerEmail?.trim()) {
    const { STRIPE_PLANS } = await import("@/lib/stripe");
    const planName = STRIPE_PLANS[invoice.plan_type]?.name ?? invoice.plan_type;

    emailReceipt({
      toEmail: body.buyerEmail.trim(),
      planName,
      invoiceNumber: invoice.invoice_number,
      totalAmount: invoice.total_amount,
      vatAmount: invoice.vat_amount,
      amountBeforeVat: invoice.amount,
      buyerName: body.buyerName.trim(),
      buyerTaxId: body.buyerTaxId?.trim() || undefined,
      publishedOn,
    }).catch((err) => console.error("[Email] error:", err));
  }

  return NextResponse.json({ ok: true });
}
