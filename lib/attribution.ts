// Attribution — จับ utm_* ตอนเข้าเว็บครั้งแรก แล้วแนบเข้าทุก event ที่ยิงผ่าน
// track() (lib/analytics.ts) ไปตลอด session/จนกว่าจะมี utm ชุดใหม่
//
// ทำไมต้องมี: แคมเปญโฆษณา (11 ก.ย. 2026) วัดได้แค่ pageview → ไม่รู้เลยว่า
// utm_campaign/utm_content ไหนพาไปถึง pricing_view/signup_submit เพราะ utm
// หายทันทีที่ navigate ออกจากหน้าแรก (เคยเช็คแล้ว: ไม่มี localStorage/
// sessionStorage เก็บไว้เลย มีแต่ path ของ event pageview ที่เก็บ query
// เฉพาะหน้า landing หน้าเดียว)
//
// เก็บสองชุด:
//  - first-touch (localStorage, เขียนครั้งเดียว) — ต้นทางที่พาเข้าเว็บครั้งแรก
//  - last-touch (sessionStorage, เขียนทับทุกครั้งที่ url มี utm ใหม่ที่ไม่ใช่
//    ลิงก์ภายในเว็บเอง) — ต้นทางที่ใกล้กับ conversion รอบนี้ที่สุด
// attributionEventProps() คืน last-touch ก่อน ถ้าไม่มีค่อย fallback first-touch
// เพื่อให้ conversion ของคนที่เปิดแท็บใหม่ (utm หายจาก sessionStorage) ยัง
// สืบต้นทางได้จาก localStorage
//
// pure ทั้งไฟล์ยกเว้น getBrowserStores() — เทสต์ได้ด้วย vitest (node env) โดย
// inject StorageLike ปลอมเข้าไปแทน localStorage/sessionStorage จริง

export const UTM_KEYS = [
  "utm_source",
  "utm_medium",
  "utm_campaign",
  "utm_content",
  "utm_term",
] as const;

export type UtmKey = (typeof UTM_KEYS)[number];

export interface Attribution {
  utm_source: string | null;
  utm_medium: string | null;
  utm_campaign: string | null;
  utm_content: string | null;
  utm_term: string | null;
  /** เก็บไว้เผื่อใช้ต่อ CAPI ในอนาคต — ไม่แนบเข้า event เพื่อไม่ให้ analytics_events บวม */
  fbclid: string | null;
  /** pathname อย่างเดียว ไม่มี query — กัน PII/utm ซ้ำซ้อนกับ properties */
  landing_path: string;
  captured_at: string;
}

export interface StorageLike {
  getItem(key: string): string | null;
  setItem(key: string, value: string): void;
}

export interface AttributionStores {
  local: StorageLike | null;
  session: StorageLike | null;
}

export const FIRST_TOUCH_KEY = "morroo_attr_first";
export const LAST_TOUCH_KEY = "morroo_attr_last";

/** utm_source ที่เป็นลิงก์ภายในเว็บเอง (เช่น games hub) — ห้ามทับ last-touch ของจริง */
export const INTERNAL_UTM_SOURCES = ["morroo"];

const MAX_VALUE_LEN = 120;

function clamp(value: string | null): string | null {
  if (!value) return null;
  const trimmed = value.trim();
  return trimmed ? trimmed.slice(0, MAX_VALUE_LEN) : null;
}

/**
 * แกะ utm_* และ fbclid จาก query string — คืน null เมื่อไม่มีอะไรน่าเก็บเลย
 * (ไม่มี utm สักตัว ไม่มี fbclid) เพื่อไม่ให้ persist ทับของเดิมด้วยค่าว่างเปล่า
 */
export function parseAttribution(
  search: string,
  pathname: string,
  now: Date = new Date(),
): Attribution | null {
  const params = new URLSearchParams(search);
  const source = clamp(params.get("utm_source"));

  if (source && INTERNAL_UTM_SOURCES.includes(source.toLowerCase())) return null;

  const attr: Attribution = {
    utm_source: source,
    utm_medium: clamp(params.get("utm_medium")),
    utm_campaign: clamp(params.get("utm_campaign")),
    utm_content: clamp(params.get("utm_content")),
    utm_term: clamp(params.get("utm_term")),
    fbclid: clamp(params.get("fbclid")),
    landing_path: pathname || "/",
    captured_at: now.toISOString(),
  };

  const hasUtm = UTM_KEYS.some((k) => attr[k] !== null);
  if (!hasUtm && !attr.fbclid) return null;
  return attr;
}

function safeGet(store: StorageLike | null, key: string): string | null {
  if (!store) return null;
  try {
    return store.getItem(key);
  } catch {
    return null;
  }
}

function safeSet(store: StorageLike | null, key: string, value: string): void {
  if (!store) return;
  try {
    store.setItem(key, value);
  } catch {
    // เต็มหรือถูกปิด (private mode / in-app browser) — ปล่อยผ่าน ไม่ทำให้เว็บพัง
  }
}

/** first-touch เขียนครั้งเดียว (ไม่มีอยู่ก่อนเท่านั้น) · last-touch เขียนทับทุกครั้ง */
export function persistAttribution(attr: Attribution, stores: AttributionStores): void {
  const json = JSON.stringify(attr);
  if (!safeGet(stores.local, FIRST_TOUCH_KEY)) {
    safeSet(stores.local, FIRST_TOUCH_KEY, json);
  }
  safeSet(stores.session, LAST_TOUCH_KEY, json);
}

function safeParse(raw: string | null): Attribution | null {
  if (!raw) return null;
  try {
    const parsed = JSON.parse(raw);
    if (!parsed || typeof parsed !== "object") return null;
    return parsed as Attribution;
  } catch {
    return null;
  }
}

export function readAttribution(stores: AttributionStores): {
  first: Attribution | null;
  last: Attribution | null;
} {
  return {
    first: safeParse(safeGet(stores.local, FIRST_TOUCH_KEY)),
    last: safeParse(safeGet(stores.session, LAST_TOUCH_KEY)),
  };
}

/** parse + persist ในคำเรียกเดียว — คืนสิ่งที่เพิ่งเก็บ (null เมื่อ url ไม่มี utm) */
export function captureAttribution(
  location: { search: string; pathname: string },
  stores: AttributionStores,
): Attribution | null {
  const attr = parseAttribution(location.search, location.pathname);
  if (attr) persistAttribution(attr, stores);
  return attr;
}

export type AttributionProps = Record<UtmKey, string | null> & {
  utm_touch: "last" | "first";
  landing_path: string;
};

/**
 * ค่าที่จะ merge เข้า track() — last-touch ก่อน ไม่งั้น fallback first-touch,
 * คืน null เมื่อไม่มีทั้งคู่ (organic/ไม่เคยมี utm) เพื่อไม่เพิ่ม key ให้แถวส่วนใหญ่
 */
export function attributionEventProps(stores: AttributionStores): AttributionProps | null {
  const { first, last } = readAttribution(stores);
  const chosen = last ?? first;
  if (!chosen) return null;
  const touch: "last" | "first" = last ? "last" : "first";
  const props = { utm_touch: touch, landing_path: chosen.landing_path } as AttributionProps;
  for (const key of UTM_KEYS) props[key] = chosen[key];
  return props;
}

/** ชุดย่อสำหรับ Vercel Analytics (จำกัด property ต่อ event) */
export function vercelAttributionProps(
  props: AttributionProps | null,
): Record<string, string | null> | null {
  if (!props) return null;
  return {
    utm_source: props.utm_source,
    utm_medium: props.utm_medium,
    utm_campaign: props.utm_campaign,
    utm_content: props.utm_content,
  };
}

export function getBrowserStores(): AttributionStores {
  if (typeof window === "undefined") return { local: null, session: null };
  let local: StorageLike | null = null;
  let session: StorageLike | null = null;
  try {
    local = window.localStorage;
  } catch {
    local = null;
  }
  try {
    session = window.sessionStorage;
  } catch {
    session = null;
  }
  return { local, session };
}
