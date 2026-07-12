// localStorage helpers ของระบบ CPR — คีย์ prefix `jia_` ต้องคงเดิมทุกตัว
// เพื่อให้ข้อมูลผู้เรียนเดิม (progress/purchased/promo) ใช้ต่อได้หลังย้าย origin
import { FREE_LAUNCH, GATE_VARIANT_DEFAULT, PRICING } from "./config";

export type CprUser = {
  name: string;
  phone: string;
  email?: string;
  line_user_id?: string;
  auth_user_id?: string;
  customer_id?: string;
};
export type CprProgress = { done: number[]; scores: Record<string, number> };

export const save = (k: string, v: unknown) => {
  try {
    localStorage.setItem(`jia_${k}`, JSON.stringify(v));
  } catch (_e) {}
};
export const load = <T,>(k: string, d: T): T => {
  try {
    if (typeof window === "undefined") return d;
    const v = localStorage.getItem(`jia_${k}`);
    return v ? (JSON.parse(v) as T) : d;
  } catch (_e) {
    return d;
  }
};

export const getGateVariant = () => load("gate_variant", GATE_VARIANT_DEFAULT);
export const isSignedUp = () => {
  const u = load<CprUser | null>("user", null);
  return !!(load("signed_up", false) || u?.line_user_id || u?.auth_user_id);
};

// UTM: เก็บครั้งแรกที่เข้า ก่อน replaceState จะลบ query ทิ้ง
const UTM_KEYS = ["utm_source", "utm_medium", "utm_campaign", "utm_content", "utm_term"];
export const captureUTM = () => {
  try {
    const p = new URLSearchParams(window.location.search);
    const got: Record<string, string> = {};
    UTM_KEYS.forEach((k) => {
      const v = p.get(k);
      if (v) got[k] = v;
    });
    if (Object.keys(got).length && !load("utm", null)) {
      save("utm", got);
      save("landing_url", window.location.href.slice(0, 500));
    }
  } catch (_e) {}
};
export const getUTM = () => load<Record<string, string>>("utm", {});

export const mergeProgressLocal = (a: CprProgress | null, b: CprProgress | null): CprProgress => {
  const done = [...new Set([...(a?.done || []), ...(b?.done || [])])].sort((x, y) => x - y);
  const scores: Record<string, number> = { ...(a?.scores || {}) };
  for (const [k, v] of Object.entries(b?.scores || {}))
    scores[k] = Math.max(Number(scores[k] || 0), Number(v || 0));
  return { done, scores };
};

// ========== PURCHASE HELPERS ==========
export const getPurchased = (): number[] => {
  const stored = load<number[] | null>("purchased", null);
  const promoUnlocked = load<number[]>("promo_unlocked", []);
  if (stored && stored.length)
    return promoUnlocked.length ? [...new Set([...stored, ...promoUnlocked])] : stored;
  if (load("grandfathered", false)) return [1, 2, 3, 4, 5, 6, 7];
  // grandfather: เฉพาะ user ที่เข้าใช้งานจริงในช่วง FREE_LAUNCH เท่านั้น จึงคงสิทธิ์เรียนฟรีทุกบท
  // (ห้ามผูกกับ "enrolled" ซึ่งถูกตั้ง true ทุกครั้งที่สมัคร — จะทำให้ผู้สมัครใหม่หลัง cutover ได้ครบคอร์สฟรี)
  if (FREE_LAUNCH) {
    save("grandfathered", true);
    return [1, 2, 3, 4, 5, 6, 7];
  }
  const base = [PRICING.freeModule];
  return promoUnlocked.length ? [...new Set([...base, ...promoUnlocked])] : base;
};
export const savePurchased = (ids: number[]) => {
  save("purchased", ids);
};
export const isModuleAccessible = (id: number, purchased: number[]) =>
  purchased.includes(id) || (id === 7 && purchased.filter((x) => x <= 6).length === 6);
export const calcPrice = (count: number) => {
  if (count >= 6) return PRICING.full;
  if (count >= 3)
    return Math.floor(count / 3) * PRICING.bundle3 + (count % 3) * PRICING.single;
  return count * PRICING.single;
};
