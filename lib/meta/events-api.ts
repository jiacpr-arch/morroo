const PIXEL_ID = "966371002896288";
const API_VERSION = "v18.0";

type MetaEventName =
  | "PageView"
  | "ViewContent"
  | "Lead"
  | "CompleteRegistration"
  | "Subscribe"
  | "Purchase"
  | "InitiateCheckout"
  | "AddToCart";

export interface MetaEventInput {
  event: MetaEventName;
  eventId?: string;
  email?: string | null;
  phone?: string | null;
  externalId?: string | null;
  firstName?: string | null;
  lastName?: string | null;
  ip?: string | null;
  userAgent?: string | null;
  fbc?: string | null;
  fbp?: string | null;
  url?: string | null;
  value?: number;
  currency?: string;
  contentIds?: string[];
  contentName?: string;
  contentType?: string;
}

// Web Crypto API — works in both Node.js 18+ and Edge runtimes (unlike node:crypto)
async function sha256Lower(value: string): Promise<string> {
  const data = new TextEncoder().encode(value.trim().toLowerCase());
  const buf = await crypto.subtle.digest("SHA-256", data);
  return Array.from(new Uint8Array(buf))
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

export async function sendMetaEvent(input: MetaEventInput): Promise<void> {
  const token = process.env.META_CAPI_ACCESS_TOKEN;
  if (!token) return;

  const userData: Record<string, unknown> = {};
  if (input.email) userData.em = [await sha256Lower(input.email)];
  if (input.phone) {
    const digits = input.phone.replace(/\D/g, "");
    if (digits) userData.ph = [await sha256Lower(digits)];
  }
  if (input.firstName) userData.fn = [await sha256Lower(input.firstName)];
  if (input.lastName) userData.ln = [await sha256Lower(input.lastName)];
  if (input.externalId) userData.external_id = [await sha256Lower(input.externalId)];
  if (input.ip) userData.client_ip_address = input.ip;
  if (input.userAgent) userData.client_user_agent = input.userAgent;
  if (input.fbc) userData.fbc = input.fbc;
  if (input.fbp) userData.fbp = input.fbp;

  const customData: Record<string, unknown> = {};
  if (input.value !== undefined) customData.value = input.value;
  if (input.currency) customData.currency = input.currency;
  if (input.contentIds?.length) customData.content_ids = input.contentIds;
  if (input.contentName) customData.content_name = input.contentName;
  if (input.contentType) customData.content_type = input.contentType;

  const eventData: Record<string, unknown> = {
    event_name: input.event,
    event_time: Math.floor(Date.now() / 1000),
    event_id: input.eventId ?? crypto.randomUUID(),
    action_source: "website",
    user_data: userData,
  };
  if (input.url) eventData.event_source_url = input.url;
  if (Object.keys(customData).length) eventData.custom_data = customData;

  const payload: Record<string, unknown> = { data: [eventData] };
  const testCode = resolveTestEventCode(input.event);
  if (testCode) payload.test_event_code = testCode;

  const endpoint = `https://graph.facebook.com/${API_VERSION}/${PIXEL_ID}/events?access_token=${encodeURIComponent(token)}`;

  try {
    const res = await fetch(endpoint, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
    });
    if (!res.ok) {
      const text = await res.text().catch(() => "");
      console.error(
        `[meta-capi] ${input.event} failed: ${res.status} ${text.slice(0, 200)}`
      );
    }
  } catch (err) {
    console.error(`[meta-capi] ${input.event} fetch error:`, err);
  }
}

/**
 * `test_event_code` ห้ามหลุดขึ้น production เด็ดขาด
 *
 * event ที่แนบโค้ดนี้ไป Meta จะรับไว้ (ตอบ 200 ไม่มี error ให้เห็น) แต่โยนเข้า
 * Test Events อย่างเดียว — ไม่นับเข้า dataset, ใช้ optimize ไม่ได้, ใช้ทำ
 * attribution ไม่ได้ ผลคือแคมเปญยิงเงินไปโดยไม่มี conversion กลับมาสักตัว
 * และไม่มีอะไรบอกเลยว่าพัง
 *
 * เกิดขึ้นจริงแล้ว: `META_TEST_EVENT_CODE` ถูกตั้งบน Vercel แบบ All Environments
 * (รวม Production) ค้างไว้ตั้งแต่ 14 พ.ค. 2026 — conversion ทุกตัวหายเงียบ
 * สองเดือนกว่า กว่าจะจับได้ตอนไล่ดูว่าทำไม dataset แทบไม่มีข้อมูล
 *
 * จึงไม่ไว้ใจ env อีกต่อไป: production เพิกเฉยต่อค่านี้เสมอ ไม่ว่าใครจะตั้งมา
 * ยังไง แล้ว log เตือนไว้ให้เห็นว่ามีค่าค้างอยู่ที่ต้องไปลบ
 */
export function resolveTestEventCode(event: string): string | undefined {
  const testCode = process.env.META_TEST_EVENT_CODE?.trim();
  if (!testCode) return undefined;

  // VERCEL_ENV = production เฉพาะ deployment ที่ผูกกับ production domain
  // (preview/development ได้ค่าของตัวเอง) — เชื่อถือได้กว่า NODE_ENV ซึ่ง
  // build ของ preview ก็เป็น "production" เหมือนกัน
  if (process.env.VERCEL_ENV === "production") {
    console.warn(
      `[meta-capi] ignoring META_TEST_EVENT_CODE on production (${event}) — ` +
        "ลบตัวแปรนี้ออกจาก Production ใน Vercel ได้เลย"
    );
    return undefined;
  }
  return testCode;
}
