import { createClient } from "@/lib/supabase/server";
import { notFound } from "next/navigation";
import Link from "next/link";

const PLAN_NAMES: Record<string, string> = {
  monthly: "MorRoo รายเดือน",
  yearly: "MorRoo รายปี",
  bundle: "MorRoo ชุดข้อสอบ 10 ข้อ",
};

interface Invoice {
  id: string;
  invoice_number: string;
  issued_at: string;
  plan_type: string;
  amount: number;
  vat_amount: number;
  total_amount: number;
  buyer_name: string | null;
  buyer_tax_id: string | null;
  buyer_address: string | null;
  buyer_email: string | null;
  payment_method: string;
  status: string;
}

export default async function InvoicePage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const supabase = await createClient();

  const { data: invoice, error } = await supabase
    .from("invoices")
    .select("*")
    .eq("id", id)
    .single();

  if (error || !invoice) {
    notFound();
  }

  const inv = invoice as Invoice;
  const sellerName = process.env.SELLER_NAME ?? "บริษัท โรจน์รุ่งธุรกิจ จำกัด";
  const sellerTaxId = process.env.SELLER_TAX_ID ?? "XXXXXXXXXXXXXXXXX";
  const sellerAddress = process.env.SELLER_ADDRESS ?? "กรุณาระบุที่อยู่ผู้ขาย";

  const issuedDate = new Date(inv.issued_at);
  const formattedDate = issuedDate.toLocaleDateString("th-TH", {
    year: "numeric",
    month: "long",
    day: "numeric",
  });

  const planName = PLAN_NAMES[inv.plan_type] ?? inv.plan_type;
  const hasTaxId = Boolean(inv.buyer_tax_id);

  return (
    <>
      <style>{`
        @media print {
          .no-print { display: none !important; }
          body { background: white !important; }
          .print-container { box-shadow: none !important; border: none !important; }
        }
      `}</style>

      {/* Navigation / Actions (hidden on print) */}
      <div className="no-print mx-auto max-w-3xl px-4 py-4 flex items-center justify-between">
        <Link href="/profile" className="text-sm text-muted-foreground hover:text-brand">
          ← กลับไปหน้าโปรไฟล์
        </Link>
        <button
          onClick={() => window.print()}
          className="inline-flex items-center gap-2 rounded-md bg-brand px-4 py-2 text-sm font-medium text-white hover:bg-brand-light transition-colors"
        >
          🖨️ พิมพ์ / บันทึก PDF
        </button>
      </div>

      {/* Invoice Document */}
      <div className="print-container mx-auto max-w-3xl px-4 pb-16">
        <div className="rounded-lg border bg-white shadow-sm p-8 space-y-6">

          {/* Header */}
          <div className="flex items-start justify-between border-b pb-6">
            <div>
              <h1 className="text-2xl font-bold text-gray-900">
                ใบเสร็จรับเงิน
                {hasTaxId && (
                  <span className="ml-2 text-base font-normal text-gray-500">
                    / ใบกำกับภาษีอย่างย่อ
                  </span>
                )}
              </h1>
              <p className="text-sm text-gray-500 mt-1">Receipt{hasTaxId ? " / Abbreviated Tax Invoice" : ""}</p>
            </div>
            <div className="text-right">
              <p className="text-lg font-bold text-brand">{inv.invoice_number}</p>
              <p className="text-sm text-gray-500">{formattedDate}</p>
            </div>
          </div>

          {/* Seller & Buyer */}
          <div className="grid grid-cols-2 gap-8">
            {/* Seller */}
            <div>
              <p className="text-xs font-semibold uppercase tracking-wider text-gray-400 mb-2">
                ผู้ขาย / Seller
              </p>
              <p className="font-semibold text-gray-900">{sellerName}</p>
              <p className="text-sm text-gray-600 mt-1">
                เลขประจำตัวผู้เสียภาษี: {sellerTaxId}
              </p>
              <p className="text-sm text-gray-600 mt-1 whitespace-pre-line">
                {sellerAddress}
              </p>
            </div>

            {/* Buyer */}
            <div>
              <p className="text-xs font-semibold uppercase tracking-wider text-gray-400 mb-2">
                ผู้ซื้อ / Buyer
              </p>
              {inv.buyer_name ? (
                <>
                  <p className="font-semibold text-gray-900">{inv.buyer_name}</p>
                  {inv.buyer_tax_id && (
                    <p className="text-sm text-gray-600 mt-1">
                      เลขประจำตัวผู้เสียภาษี: {inv.buyer_tax_id}
                    </p>
                  )}
                  {inv.buyer_address && (
                    <p className="text-sm text-gray-600 mt-1 whitespace-pre-line">
                      {inv.buyer_address}
                    </p>
                  )}
                  {inv.buyer_email && (
                    <p className="text-sm text-gray-600 mt-1">{inv.buyer_email}</p>
                  )}
                </>
              ) : (
                <>
                  <p className="text-sm text-gray-600">{inv.buyer_email ?? "-"}</p>
                </>
              )}
            </div>
          </div>

          {/* Line Items */}
          <div>
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-gray-200">
                  <th className="text-left py-2 font-semibold text-gray-700">รายการ</th>
                  <th className="text-right py-2 font-semibold text-gray-700 w-32">จำนวนเงิน</th>
                </tr>
              </thead>
              <tbody>
                <tr className="border-b border-gray-100">
                  <td className="py-3 text-gray-800">{planName}</td>
                  <td className="py-3 text-right text-gray-800">
                    ฿{inv.amount.toLocaleString("th-TH", { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                  </td>
                </tr>
              </tbody>
            </table>

            {/* Totals */}
            <div className="mt-4 space-y-2">
              <div className="flex justify-between text-sm text-gray-600">
                <span>ราคาก่อนภาษี</span>
                <span>฿{inv.amount.toLocaleString("th-TH", { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</span>
              </div>
              <div className="flex justify-between text-sm text-gray-600">
                <span>ภาษีมูลค่าเพิ่ม 7%</span>
                <span>฿{inv.vat_amount.toLocaleString("th-TH", { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</span>
              </div>
              <div className="flex justify-between font-bold text-base border-t border-gray-200 pt-2">
                <span>รวมทั้งสิ้น</span>
                <span className="text-brand">
                  ฿{inv.total_amount.toLocaleString("th-TH", { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                </span>
              </div>
            </div>
          </div>

          {/* Payment info */}
          <div className="rounded-lg bg-gray-50 p-4 text-sm text-gray-600 space-y-1">
            <p>
              <span className="font-medium">วิธีชำระเงิน:</span>{" "}
              {inv.payment_method === "stripe" ? "บัตรเครดิต/เดบิต (Stripe)" : "โอนเงินธนาคาร"}
            </p>
            <p>
              <span className="font-medium">สถานะ:</span>{" "}
              <span className="text-green-600 font-medium">ชำระแล้ว</span>
            </p>
          </div>

          {/* Footer note */}
          <div className="border-t pt-4 text-center text-xs text-gray-400">
            <p>ใบเสร็จนี้ออกโดย {sellerName}</p>
            {hasTaxId && (
              <p className="mt-1">
                เอกสารนี้ใช้เป็นใบกำกับภาษีอย่างย่อตาม พ.ร.บ. ภาษีมูลค่าเพิ่ม
              </p>
            )}
          </div>
        </div>
      </div>
    </>
  );
}
