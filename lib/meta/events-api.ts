const PIXEL_ID = "966371002896288";
// Keep in step with lib/ads-diagnostics.ts — both talk to the same Graph API
// and a version that silently ages out takes every Purchase with it. v18.0
// shipped in late 2023 and was already past Meta's ~2-year support window.
const API_VERSION = "v24.0";

type MetaEventName =
  | "PageView"
  | "ViewContent"
  | "Lead"
  | "CompleteRegistration"
  | "Subscribe"
  | "Purchase"
  | "InitiateCheckout"
  | "AddToCart";

/**
 * Where the conversion actually happened.
 *
 * Meta uses this to judge match quality, so it must describe reality: a sale
 * closed over chat and typed into an admin screen is `system_generated`, not
 * a `website` visit that never occurred.
 */
export type MetaActionSource =
  | "website"
  | "app"
  | "chat"
  | "email"
  | "phone_call"
  | "physical_store"
  | "system_generated"
  | "business_messaging"
  | "other";

export interface MetaEventInput {
  event: MetaEventName;
  eventId?: string;
  /** Defaults to "website" — the only source every existing caller has. */
  actionSource?: MetaActionSource;
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

/**
 * Put a phone number in the shape Meta hashes against: digits only, country
 * code included, no `+` and no leading international access code.
 *
 * Thai numbers are stored domestically (`081-234-5678`) but Meta's index keys
 * on the international form, so a raw digit-strip matches nothing. The leading
 * zero is what disambiguates the two: a domestic Thai number always has one,
 * an already-international number never does — so `0661234567` (an 06x mobile)
 * becomes `66661234567`, not a double-counted country code.
 *
 * Non-Thai numbers pass through untouched; we only know how to complete a
 * number we can recognise, and guessing a country code is worse than leaving
 * one alone.
 */
export function normalizePhone(raw: string): string | null {
  let digits = raw.replace(/\D/g, "");
  if (!digits) return null;

  // 00 = international access code dialled from abroad; the country code follows.
  if (digits.startsWith("00")) digits = digits.slice(2);

  // Domestic Thai form: 0 + 8 or 9 national digits.
  if (digits.startsWith("0") && (digits.length === 9 || digits.length === 10)) {
    return `66${digits.slice(1)}`;
  }

  return digits || null;
}

// Web Crypto API — works in both Node.js 18+ and Edge runtimes (unlike node:crypto)
async function sha256Lower(value: string): Promise<string> {
  const data = new TextEncoder().encode(value.trim().toLowerCase());
  const buf = await crypto.subtle.digest("SHA-256", data);
  return Array.from(new Uint8Array(buf))
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

/**
 * test_event_code ต้องไม่หลุดขึ้น production เด็ดขาด
 *
 * Meta ถือว่า event ที่แนบ test_event_code เป็น "อีเวนต์ทดสอบ" — โผล่ในแท็บ
 * Test Events ให้ดูได้ แต่ **ไม่นับเป็น conversion จริง** จึงใช้ทำ Custom
 * Conversion / optimization / attribution ไม่ได้เลย
 *
 * เคยเกิดขึ้นจริง: `META_TEST_EVENT_CODE` ถูกตั้งเป็น All Environments ใน Vercel
 * ตั้งแต่ 2026-05-14 ทำให้ CAPI ของ production ทั้งระบบ (PageView, ViewContent
 * ของเกมเคส, CompleteRegistration, Purchase) กลายเป็น test ทั้งหมดโดยไม่มีใคร
 * รู้ — ตรวจพบ 2026-07-27 ตอนไล่หาสาเหตุที่ Meta ได้รับ ViewContent วันละ ~5
 * ครั้ง ทั้งที่ระบบยิงไป ~900 ครั้ง
 *
 * ตัด env ทิ้งอย่างเดียวไม่พอ เพราะใครตั้งใหม่ผิดช่องก็พังเงียบอีก — gate ที่
 * โค้ดจึงเป็นด่านที่เชื่อถือได้กว่า
 */
function resolveTestEventCode(): string | undefined {
  if (process.env.VERCEL_ENV === "production") return undefined;
  return process.env.META_TEST_EVENT_CODE?.trim() || undefined;
}

/**
 * Say it once per instance when the token is missing.
 *
 * Returning silently is how an unset env var turns into months of lost
 * Purchases with nothing in the logs — the same failure shape as the ads
 * scan that reported "all clear" without reading the account (PR #430).
 * Once per instance rather than per event: ViewContent alone fires ~900
 * times a day, and a warning that floods is a warning nobody reads.
 */
let warnedMissingToken = false;

function warnMissingToken(event: MetaEventName): void {
  if (warnedMissingToken) return;
  warnedMissingToken = true;
  console.error(
    `[meta-capi] META_CAPI_ACCESS_TOKEN ไม่ได้ตั้งค่า — ทิ้ง event ทั้งหมดเงียบ ๆ ` +
      `(ตัวแรกที่ถูกทิ้ง: ${event}${
        process.env.VERCEL_ENV ? `, env=${process.env.VERCEL_ENV}` : ""
      }). Purchase/Lead จะไม่ถึง Meta จนกว่าจะตั้งค่า`
  );
}

/** Test-only: the warning latch is module state that survives between tests. */
export function __resetMissingTokenWarning(): void {
  warnedMissingToken = false;
}

export async function sendMetaEvent(input: MetaEventInput): Promise<void> {
  const token = process.env.META_CAPI_ACCESS_TOKEN;
  if (!token) {
    warnMissingToken(input.event);
    return;
  }

  const userData: Record<string, unknown> = {};
  if (input.email) userData.em = [await sha256Lower(input.email)];
  if (input.phone) {
    const phone = normalizePhone(input.phone);
    if (phone) userData.ph = [await sha256Lower(phone)];
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
    action_source: input.actionSource ?? "website",
    user_data: userData,
  };
  if (input.url) eventData.event_source_url = input.url;
  if (Object.keys(customData).length) eventData.custom_data = customData;

  const payload: Record<string, unknown> = { data: [eventData] };
  const testCode = resolveTestEventCode();
  if (testCode) payload.test_event_code = testCode;

  const endpoint = `https://graph.facebook.com/${API_VERSION}/${PIXEL_ID}/events?access_token=${encodeURIComponent(token)}`;

  try {
    // callers ที่ต้องการความชัวร์ (เช่น app/api/track/casegame) รอผลลัพธ์นี้
    // ก่อนตอบ response แล้ว — ต้องมี timeout กันไม่ให้ Meta ช้าแล้วดึงเวลาตอบ
    // ผู้ใช้ยืดไม่มีที่สิ้นสุด
    const res = await fetch(endpoint, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
      signal: AbortSignal.timeout(5_000),
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
