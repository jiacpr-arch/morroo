/**
 * FlowAccount API — สำหรับ morroo.com
 * สร้างใบกำกับภาษี/ใบเสร็จอัตโนมัติเมื่อลูกค้าชำระเงินผ่าน Stripe
 *
 * Endpoint: POST /cash-invoices/inline/with-payment
 * = ใบกำกับภาษี/ใบเสร็จรับเงิน (ขายสด) + บันทึกรับชำระในครั้งเดียว
 */

const TOKEN_URL    = process.env.FLOWACCOUNT_TOKEN_URL    ?? "";
const BASE_URL     = process.env.FLOWACCOUNT_BASE_URL     ?? "";
const CLIENT_ID    = process.env.FLOWACCOUNT_CLIENT_ID    ?? "";
const CLIENT_SECRET = process.env.FLOWACCOUNT_CLIENT_SECRET ?? "";

// Token cache (in-process, resets on cold start)
let _token = "";
let _tokenExpiresAt = 0;

async function getToken(): Promise<string> {
  if (_token && Date.now() < _tokenExpiresAt - 60_000) return _token;
  if (!TOKEN_URL || !CLIENT_ID || !CLIENT_SECRET) {
    throw new Error("FlowAccount env vars not configured");
  }
  const res = await fetch(TOKEN_URL, {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "client_credentials",
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET,
      scope: "flowaccount-api",
    }),
  });
  if (!res.ok) throw new Error(`FlowAccount token error: ${res.status}`);
  const data = await res.json() as { access_token: string; expires_in: number };
  _token = data.access_token;
  _tokenExpiresAt = Date.now() + data.expires_in * 1_000;
  return _token;
}

// Map plan type → ข้อมูลสินค้า FlowAccount
const PLAN_PRODUCT: Record<string, { code: string; name: string }> = {
  monthly:          { code: "MORROO-FULL-MO", name: "MorRoo Full รายเดือน" },
  yearly:           { code: "MORROO-FULL-YR", name: "MorRoo Full รายปี" },
  bundle:           { code: "MORROO-BUNDLE",  name: "MorRoo Bundle (MCQ 20q + MEQ 5 เคส + Long Case 2 เคส)" },
  mcq_monthly:      { code: "MORROO-MCQ-MO",  name: "MorRoo MCQ รายเดือน" },
  mcq_yearly:       { code: "MORROO-MCQ-YR",  name: "MorRoo MCQ รายปี" },
  meq_monthly:      { code: "MORROO-MEQ-MO",  name: "MorRoo MEQ รายเดือน" },
  meq_yearly:       { code: "MORROO-MEQ-YR",  name: "MorRoo MEQ รายปี" },
  longcase_monthly: { code: "MORROO-LC-MO",   name: "MorRoo Long Case รายเดือน" },
  longcase_yearly:  { code: "MORROO-LC-YR",   name: "MorRoo Long Case รายปี" },
};

export interface FlowAccountInvoiceInput {
  planType: string;
  totalAmount: number;          // ราคารวม VAT แล้ว (บาท)
  invoiceNumber: string;        // เลขที่ใบกำกับภาษีจาก Supabase (INV-YYYY-NNNN)
  stripeSessionId: string;
  buyerName?: string;
  buyerTaxId?: string;
  buyerAddress?: string;
  buyerEmail?: string;
  publishedOn: string;          // "YYYY-MM-DD"
}

export interface FlowAccountResult {
  ok: boolean;
  documentId?: string;
  documentNumber?: string;
  error?: string;
}

export async function createCashInvoice(input: FlowAccountInvoiceInput): Promise<FlowAccountResult> {
  const token = await getToken();

  const product = PLAN_PRODUCT[input.planType] ?? {
    code: "MORROO-OTHER",
    name: input.planType,
  };

  // ราคา Stripe รวม VAT 7% แล้ว — ถอยหลัง
  const grandTotal = Math.round(input.totalAmount * 100) / 100;
  const vatAmount = Math.round((grandTotal * 7 / 107) * 100) / 100;
  const subTotal = Math.round((grandTotal - vatAmount) * 100) / 100;

  const body = {
    contactName: input.buyerName || "บุคคลทั่วไป",
    contactTaxId: input.buyerTaxId || "",
    contactAddress: input.buyerAddress || "",
    contactEmail: input.buyerEmail || "",
    contactGroup: 1,                  // ลูกค้า
    publishedOn: input.publishedOn,
    creditType: 3,                    // 3 = ขายสด (ไม่มีเครดิต)
    creditDays: 0,
    dueDate: input.publishedOn,
    reference: input.invoiceNumber,   // อ้างอิงเลขที่ใบกำกับของเรา
    isVatInclusive: false,            // ส่ง subTotal ก่อน VAT
    isVat: true,
    subTotal,
    discountPercentage: 0,
    discountAmount: 0,
    totalAfterDiscount: subTotal,
    vatAmount,
    grandTotal,
    documentShowWithholdingTax: false,
    documentWithholdingTaxPercentage: 0,
    documentWithholdingTaxAmount: 0,
    remarks: `Stripe: ${input.stripeSessionId}`,
    items: [
      {
        type: 1,                        // 1 = Service (บริการ)
        name: product.name,
        description: `แพ็กเกจ ${product.name}`,
        quantity: 1,
        unitName: "ใบอนุญาต",
        pricePerUnit: subTotal,
        total: subTotal,
        discountAmount: 0,
        vatRate: 7,
        sellChartOfAccountCode: "41210", // รายได้จากการให้บริการ
        buyChartOfAccountCode: "",
      },
    ],
    // บันทึกรับชำระพร้อมกัน
    documentPaymentStructureType: "InlineDocumentWithPaymentReceivingCash",
    paymentMethod: 3,                 // 3 = บัตรเครดิต/เดบิต (Stripe)
    paymentDate: input.publishedOn,
    collected: grandTotal,
    paymentDeductionType: 1,
    paymentDeductionAmount: 0,
    withheldPercentage: 0,
    withheldAmount: 0,
    paymentRemarks: `Stripe payment: ${input.stripeSessionId}`,
    remainingCollectedType: 51,
    remainingCollected: 0,
  };

  const res = await fetch(`${BASE_URL}/cash-invoices/inline/with-payment`, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${token}`,
      "Content-Type": "application/json",
      Accept: "application/json",
    },
    body: JSON.stringify(body),
  });

  const json = await res.json() as {
    id?: string;
    documentSerial?: string;
    documentNumber?: string;
    message?: string;
  };

  if (!res.ok) {
    return { ok: false, error: `${res.status}: ${json.message ?? JSON.stringify(json)}` };
  }

  return {
    ok: true,
    documentId: json.id ?? json.documentSerial,
    documentNumber: json.documentNumber,
  };
}
