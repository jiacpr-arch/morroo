// การเชื่อมต่อ Supabase (โปรเจกต์ CPR — คนละตัวกับ morroo หลัก), LIFF และ edge functions
// Phase 1: ยังเรียก Supabase REST จาก browser ด้วย anon key ตาม flow เดิม
// (Phase 3 จะย้าย write ทั้งหมดผ่าน /api/cpr/* ฝั่ง server)
import type { SupabaseClient } from "@supabase/supabase-js";
import { FN_HEADERS, FN_URL, LIFF_ID, PROMO_CODE_PREFIX, SUPABASE_KEY, SUPABASE_URL, VOUCHER_CODE_PREFIX } from "./config";
import { getGateVariant, getUTM, load, mergeProgressLocal, save, type CprProgress, type CprUser } from "./storage";
import { phCapture, safeTrack } from "./analytics";

/* eslint-disable @typescript-eslint/no-explicit-any */

export const supaRest = async (
  table: string,
  method: "GET" | "POST" | "PATCH" | "DELETE" = "GET",
  body: Record<string, unknown> | null = null,
  filters = ""
): Promise<any[]> => {
  const url = `${SUPABASE_URL}/rest/v1/${table}${filters}`;
  const h: Record<string, string> = {
    apikey: SUPABASE_KEY,
    Authorization: `Bearer ${SUPABASE_KEY}`,
    "Content-Type": "application/json",
  };
  if (method === "POST" || method === "PATCH") h.Prefer = "return=representation";
  const opts: RequestInit = { method, headers: h };
  if (body && method !== "GET" && method !== "DELETE") opts.body = JSON.stringify(body);
  try {
    const res = await fetch(url, opts);
    return res.ok ? await res.text().then((t) => (t ? JSON.parse(t) : [])) : [];
  } catch (e) {
    console.error("Supabase:", e);
    return [];
  }
};

// อัปโหลดไฟล์เข้า Supabase Storage bucket `slips` แล้วคืน public URL (null = ล้มเหลว)
export const uploadSlip = async (fileName: string, blob: Blob): Promise<string | null> => {
  try {
    const res = await fetch(`${SUPABASE_URL}/storage/v1/object/slips/${fileName}`, {
      method: "POST",
      headers: {
        apikey: SUPABASE_KEY,
        Authorization: `Bearer ${SUPABASE_KEY}`,
        "Content-Type": "image/jpeg",
        "x-upsert": "true",
      },
      body: blob,
    });
    if (!res.ok) return null;
    return `${SUPABASE_URL}/storage/v1/object/public/slips/${fileName}`;
  } catch (_e) {
    return null;
  }
};

// ========== CODE GENERATORS ==========
const CODE_CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
const randCode = (len: number) => {
  let r = "";
  for (let i = 0; i < len; i++) r += CODE_CHARS[Math.floor(Math.random() * CODE_CHARS.length)];
  return r;
};
export const genLinkCode = () => randCode(6);
export const genCoupon = () => "JIA-" + randCode(6);
export const genLeadCode = () => PROMO_CODE_PREFIX + randCode(6);
export const genVoucherCode = () => VOUCHER_CODE_PREFIX + randCode(6);
export const normalizePhone = (s: string | null | undefined) => (s || "").replace(/\D/g, "");
export const normalizeEmail = (s: string | null | undefined) => (s || "").trim().toLowerCase();
export const daysUntil = (iso: string | null | undefined) => {
  if (!iso) return 0;
  const ms = new Date(iso).getTime() - Date.now();
  return Math.max(0, Math.ceil(ms / 86400000));
};
export const genIdempotencyKey = (email: string, phone: string) =>
  `${normalizeEmail(email)}|${normalizePhone(phone)}|${Math.floor(Date.now() / 60000)}`.slice(0, 80);

export const getLinkCode = () => {
  let code = load<string | null>("line_link_code", null);
  if (!code) {
    code = genLinkCode();
    save("line_link_code", code);
  }
  return code;
};

// ข้อความ prefill ที่ลูกค้ากดส่งเข้า @jiacpr — โค้ด JIA-LINK ต้องอยู่หน้าสุดเสมอ
// (webhook ภายนอกจับคู่กับ customers.line_link_code → เขียน line_user_id กลับ)
export const lineLinkDeepLink = (code: string) =>
  `https://line.me/R/oaMessage/%40jiacpr/?${encodeURIComponent(
    "JIA-LINK-" + code + "\nสนใจคอร์ส CPR & AED 🙏 เรียนออนไลน์อยู่และได้รับส่วนลดแล้ว อยากนัดวันมาเรียนภาคปฏิบัติ ไม่ทราบว่าสะดวกวันไหนบ้างครับ/ค่ะ"
  )}`;

export const markLineAdded = (user?: CprUser | null) => {
  save("line_added", true);
  save("line_added_at", new Date().toISOString());
  safeTrack("line_oa_added");
  phCapture("line_oa_added", {});
  const u = user || load<CprUser | null>("user", null);
  if (u?.phone) {
    const tail = u.phone.replace(/\D/g, "").slice(-9);
    // ผูก line_link_code ไว้กับเรคคอร์ดลูกค้าก่อน เพื่อให้ line-webhook จับคู่ข้อความ "JIA-LINK-<code>" → เขียน line_user_id กลับได้
    supaRest(
      "customers",
      "PATCH",
      { line_added: true, line_added_at: new Date().toISOString(), line_link_code: getLinkCode() },
      `?tel=ilike.*${tail}`
    );
  }
};

// ========== LIFF / Supabase Auth (โหลดแบบ on-demand) ==========
type LiffLike = any;
let _liff: LiffLike = null;
export const loadLiff = async (): Promise<LiffLike> => {
  if (_liff) return _liff;
  if (!LIFF_ID) return null;
  try {
    const mod = await import("@line/liff");
    const liff = (mod as any).default || mod;
    await liff.init({ liffId: LIFF_ID });
    _liff = liff;
    return liff;
  } catch (e) {
    console.error("liff init", e);
    return null;
  }
};

let _supa: SupabaseClient | null = null;
export const getSupabase = async (): Promise<SupabaseClient> => {
  if (_supa) return _supa;
  const { createClient } = await import("@supabase/supabase-js");
  _supa = createClient(SUPABASE_URL, SUPABASE_KEY);
  return _supa;
};

// บันทึก progress ขึ้น account (เรียนต่อข้ามเครื่อง) — เรียกหลัง save("progress") ทุกครั้งถ้า signedUp
export const syncProgressRemote = async (np: CprProgress) => {
  try {
    const u = load<CprUser | null>("user", null);
    if (!u) return;
    if (u.line_user_id) {
      const idt = load<string | null>("line_id_token", null);
      if (idt)
        await fetch(FN_URL("account-progress"), {
          method: "POST",
          headers: FN_HEADERS,
          body: JSON.stringify({ action: "save", id_token: idt, progress: np }),
        });
    } else if (u.auth_user_id) {
      const at = load<string | null>("sb_access_token", null);
      if (at)
        await fetch(FN_URL("account-progress"), {
          method: "POST",
          headers: FN_HEADERS,
          body: JSON.stringify({ action: "save", access_token: at, progress: np }),
        });
    }
  } catch (_e) {}
};

// ทำ LINE signup ให้เสร็จ (เรียกหลัง LIFF login redirect กลับมา / หรือกรณี login อยู่แล้ว)
export const finishLineSignup = async () => {
  const liff = await loadLiff();
  if (!liff || !liff.isLoggedIn()) return null;
  const pending = load<Record<string, any>>("signup_pending", {}) || {};
  let idToken: string | null = null;
  try {
    idToken = liff.getIDToken();
  } catch (_e) {}
  if (!idToken) return null;
  let profile: any = {};
  try {
    profile = await liff.getProfile();
  } catch (_e) {}
  let isFriend = true;
  try {
    const fs = await liff.getFriendship();
    isFriend = !!fs?.friendFlag;
  } catch (_e) {}
  save("line_id_token", idToken);
  const res = await fetch(FN_URL("auth-line-link"), {
    method: "POST",
    headers: FN_HEADERS,
    body: JSON.stringify({
      id_token: idToken,
      phone: pending.phone || "",
      pdpa: true,
      display_name: profile.displayName || "",
      utm: getUTM(),
      landing_url: load("landing_url", null),
      local_progress: load("progress", { done: [], scores: {} }),
      gate_variant: pending.gate_variant || getGateVariant(),
    }),
  });
  let data: any = {};
  try {
    data = await res.json();
  } catch (_e) {}
  if (!data?.ok) return null;
  const u: CprUser = {
    name: data.name || profile.displayName || pending.name || "",
    phone: pending.phone || "",
    line_user_id: data.line_user_id,
    customer_id: data.customer_id,
  };
  save("user", u);
  save("signed_up", true);
  save("line_added", false); // ยืนยันแอดจริงตอนกด "เพิ่มเพื่อนแล้ว" (ตรวจ cross-provider ไม่ได้)
  if (data.progress) save("progress", data.progress);
  if (data.coupon) save("coupon", data.coupon);
  save("signup_pending", null);
  save("line_login_pending", false);
  save("enrolled", true);
  safeTrack("signup_complete", { provider: "line", is_friend: isFriend });
  phCapture("signup_complete", { provider: "line", variant: getGateVariant() });
  return { user: u, progress: data.progress as CprProgress | undefined, isFriend };
};

// ทำ signup ให้เสร็จสำหรับ Google/Email (มี Supabase session แล้ว)
export const finalizeOAuthSignup = async (provider: string) => {
  const supa = await getSupabase();
  const {
    data: { session },
  } = await supa.auth.getSession();
  if (!session) return null;
  const pending = load<Record<string, any>>("signup_pending", {}) || {};
  const authUserId = session.user.id;
  const email = session.user.email || "";
  const name = session.user.user_metadata?.full_name || session.user.user_metadata?.name || "";
  save("sb_access_token", session.access_token);
  const fields: Record<string, unknown> = {
    auth_provider: provider,
    auth_user_id: authUserId,
    oauth_sub: authUserId,
    email,
    name: name || undefined,
    display_name: name || undefined,
    tel: pending.phone || undefined,
    pdpa_consent_at: new Date().toISOString(),
    signup_at: new Date().toISOString(),
    source: "online-course",
    gate_variant: pending.gate_variant || getGateVariant(),
    landing_url: load("landing_url", null),
    ...getUTM(),
  };
  const existing = await supaRest("customers", "GET", null, `?auth_user_id=eq.${authUserId}&select=id&limit=1`);
  let customerId: string;
  if (Array.isArray(existing) && existing[0]) {
    customerId = existing[0].id;
    await supaRest("customers", "PATCH", fields, `?id=eq.${customerId}`);
  } else {
    customerId = "cust_" + Date.now() + "_" + Math.random().toString(36).slice(2, 6);
    await supaRest("customers", "POST", { id: customerId, ...fields });
    await supaRest("online_students", "POST", {
      customer_id: customerId,
      name: name || "",
      phone: pending.phone || "",
      email,
      status: "กำลังเรียน",
    });
  }
  let progress = load<CprProgress>("progress", { done: [], scores: {} });
  try {
    const r = await fetch(FN_URL("account-progress"), {
      method: "POST",
      headers: FN_HEADERS,
      body: JSON.stringify({ action: "save", access_token: session.access_token, progress }),
    });
    const d = await r.json();
    if (d?.progress) progress = mergeProgressLocal(progress, d.progress);
  } catch (_e) {}
  const u: CprUser = { name: name || "", phone: pending.phone || "", email, auth_user_id: authUserId, customer_id: customerId };
  save("user", u);
  save("signed_up", true);
  save("progress", progress);
  save("signup_pending", null);
  save("oauth_pending", false);
  save("enrolled", true);
  safeTrack("signup_complete", { provider });
  phCapture("signup_complete", { provider, variant: getGateVariant() });
  return { user: u, progress };
};
