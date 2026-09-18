import crypto from "crypto";
import { createAdminClient } from "@/lib/supabase/admin";

type LineTextMessage = { type: "text"; text: string };
type LineFlexMessage = { type: "flex"; altText: string; contents: Record<string, unknown> };
export type LineMessage = LineTextMessage | LineFlexMessage;

// ─── Quota awareness ───────────────────────────────────────────────────────
//
// The Aug 2026 incident: the LINE OA hit "you have reached your monthly
// limit" and every push/broadcast failed silently for weeks — every cron
// still logged `ok: true` because a failed send just returned `false` and
// the loop moved on. Two defenses now:
//
//  1. Proactive: bulk-sending routes (loops over many recipients, or
//     broadcastLineMessages) call `checkLineQuota()` once before they start
//     and bail out early if headroom is low, preserving what's left for
//     low-volume/high-value sends (payment confirmation, chatbot replies,
//     admin alerts) that call sendLineMessage() directly without this gate.
//  2. Reactive safety net: if a send still comes back 429 with a
//     quota-exceeded body (cache was stale, or the proactive check was
//     skipped), sendLineMessage/broadcastLineMessages flag it and notify
//     the admin — over email, since LINE itself is what's broken.

const LINE_QUOTA_CACHE_KEY = "line_quota_cache";
const LINE_QUOTA_ALERT_KEY = "line_quota_alert_sent_at";
const QUOTA_CACHE_TTL_MS = 15 * 60_000; // 15 min — cheap enough not to hammer LINE's quota endpoint every cron tick
const ALERT_DEDUPE_MS = 24 * 60 * 60_000; // at most one admin alert per day

/** Reserve kept off-limits to bulk sends, so critical single-recipient sends still get through. */
export const LINE_QUOTA_RESERVE_MIN = 300;
export const LINE_QUOTA_RESERVE_FRACTION = 0.05;

export interface LineQuotaStatus {
  /** null when the plan is unlimited ("none") or unknown — never throttles. */
  limit: number | null;
  used: number | null;
  remaining: number | null;
  /** true when bulk sends should back off and leave headroom for critical sends. */
  throttled: boolean;
}

/** Pure so the threshold math is unit-testable without hitting the LINE API. */
export function computeLineQuotaStatus(
  limit: number | null,
  used: number | null
): LineQuotaStatus {
  if (limit == null || used == null) {
    return { limit, used, remaining: null, throttled: false };
  }
  const remaining = limit - used;
  const reserve = Math.max(LINE_QUOTA_RESERVE_MIN, Math.ceil(limit * LINE_QUOTA_RESERVE_FRACTION));
  return { limit, used, remaining, throttled: remaining <= reserve };
}

let inFlightQuotaCheck: Promise<LineQuotaStatus> | null = null;
/** Per-invocation guard so a throttled bulk loop doesn't re-hit the DB on every recipient. */
let quotaAlertedThisInvocation = false;

async function fetchLineQuotaFromLine(token: string): Promise<{ limit: number | null; used: number | null }> {
  const headers = { Authorization: `Bearer ${token}` };
  const [quotaRes, consumptionRes] = await Promise.all([
    fetch("https://api.line.me/v2/bot/message/quota", { headers }),
    fetch("https://api.line.me/v2/bot/message/quota/consumption", { headers }),
  ]);

  if (!quotaRes.ok) {
    console.error(`[line] quota check failed status=${quotaRes.status}`);
    return { limit: null, used: null };
  }

  const quota = (await quotaRes.json().catch(() => null)) as { type?: string; value?: number } | null;
  if (!quota || quota.type !== "limited" || typeof quota.value !== "number") {
    // type === "none" (unlimited plan) or unparseable — never throttle.
    return { limit: null, used: null };
  }

  const consumption = consumptionRes.ok
    ? ((await consumptionRes.json().catch(() => null)) as { totalUsage?: number } | null)
    : null;

  return { limit: quota.value, used: consumption?.totalUsage ?? null };
}

/**
 * Cached quota check for bulk-sending routes to call before they start a
 * send loop. Cheap to call repeatedly — only hits the LINE API once per
 * QUOTA_CACHE_TTL_MS across the whole app (cache lives in app_settings).
 */
export async function checkLineQuota(): Promise<LineQuotaStatus> {
  if (inFlightQuotaCheck) return inFlightQuotaCheck;

  inFlightQuotaCheck = (async () => {
    const token = process.env.LINE_CHANNEL_ACCESS_TOKEN;
    if (!token) return computeLineQuotaStatus(null, null);

    const supabase = createAdminClient();
    try {
      const { data } = await supabase
        .from("app_settings")
        .select("value, updated_at")
        .eq("key", LINE_QUOTA_CACHE_KEY)
        .maybeSingle();

      const cached = (data as { value?: string; updated_at?: string } | null) ?? null;
      const cachedAt = cached?.updated_at ? new Date(cached.updated_at).getTime() : 0;
      const isFresh = Date.now() - cachedAt < QUOTA_CACHE_TTL_MS;

      let limit: number | null = null;
      let used: number | null = null;

      if (isFresh && cached?.value) {
        try {
          const parsed = JSON.parse(cached.value) as { limit: number | null; used: number | null };
          limit = parsed.limit;
          used = parsed.used;
        } catch {
          // fall through to a fresh fetch below
        }
      }

      if (!isFresh) {
        const fresh = await fetchLineQuotaFromLine(token);
        limit = fresh.limit;
        used = fresh.used;
        await supabase.from("app_settings").upsert({
          key: LINE_QUOTA_CACHE_KEY,
          value: JSON.stringify({ limit, used }),
          updated_at: new Date().toISOString(),
        });
      }

      const status = computeLineQuotaStatus(limit, used);
      if (status.throttled) {
        await notifyAdminLineQuotaLow(status);
      }
      return status;
    } catch (err) {
      console.error("[line] checkLineQuota failed:", err);
      return computeLineQuotaStatus(null, null);
    }
  })();

  try {
    return await inFlightQuotaCheck;
  } finally {
    inFlightQuotaCheck = null;
  }
}

function looksLikeQuotaExceeded(status: number, body: string): boolean {
  return status === 429 && /monthly limit|quota/i.test(body);
}

/** Reactive safety net: called when a send actually 429s with a quota-shaped body. */
async function flagQuotaExceededFromSend(context: string, body: string): Promise<void> {
  if (quotaAlertedThisInvocation) return;
  quotaAlertedThisInvocation = true;
  await notifyAdminLineQuotaLow(null, `${context}: ${body.slice(0, 300)}`);
}

async function notifyAdminLineQuotaLow(status: LineQuotaStatus | null, detail?: string): Promise<void> {
  try {
    const supabase = createAdminClient();
    const { data } = await supabase
      .from("app_settings")
      .select("value")
      .eq("key", LINE_QUOTA_ALERT_KEY)
      .maybeSingle();
    const lastAlert = (data as { value?: string } | null)?.value;
    if (lastAlert && Date.now() - new Date(lastAlert).getTime() < ALERT_DEDUPE_MS) {
      return; // already alerted recently — don't spam
    }
    await supabase.from("app_settings").upsert({
      key: LINE_QUOTA_ALERT_KEY,
      value: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    });
  } catch (err) {
    console.error("[line] quota-alert dedupe check failed:", err);
    // Keep going — better to risk one extra alert than to drop it entirely.
  }

  const remainingLine = status?.remaining != null ? `เหลือ ${status.remaining}/${status.limit} ข้อความ` : "";
  const subject = "🚨 LINE OA โควตาข้อความใกล้หมด/เต็มแล้ว";
  const text = [
    "ระบบตรวจพบว่า LINE Official Account ใกล้หมดโควตาข้อความรายเดือน หรือส่งไม่ได้แล้ว",
    remainingLine,
    detail ? `รายละเอียด: ${detail}` : "",
    "",
    "ผลกระทบ: cron ที่ส่งจำนวนมาก (ข้อสอบประจำวัน, เตือนหมดอายุ, สรุปรายสัปดาห์ ฯลฯ) จะถูกข้ามอัตโนมัติเพื่อกันโควตาไว้ให้ข้อความสำคัญ เช่น ยืนยันชำระเงิน",
    "แนะนำ: ตรวจสอบที่ LINE Official Account Manager > การตั้งค่า > สถิติการส่งข้อความ หรืออัปเกรดแพ็กเกจ",
  ]
    .filter(Boolean)
    .join("\n");

  // Email first — it's the reliable channel here, since LINE itself is what's degraded.
  try {
    const { sendAdminAlertEmail } = await import("@/lib/email/send");
    await sendAdminAlertEmail({ subject, text });
  } catch (err) {
    console.error("[line] quota admin alert email failed:", err);
  }

  // Best-effort LINE push too (costs nothing extra to try, and light overages
  // sometimes still allow a handful of pushes through).
  const adminLineId = process.env.ADMIN_LINE_USER_ID;
  const token = process.env.LINE_CHANNEL_ACCESS_TOKEN;
  if (adminLineId && token) {
    try {
      await fetch("https://api.line.me/v2/bot/message/push", {
        method: "POST",
        headers: { Authorization: `Bearer ${token}`, "Content-Type": "application/json" },
        body: JSON.stringify({ to: adminLineId, messages: [{ type: "text", text }] }),
      });
    } catch {
      // ignore — email above is the real notification path
    }
  }
}

// ─── Sending ────────────────────────────────────────────────────────────────

export async function sendLineMessage(
  lineUserId: string,
  messages: LineMessage[]
): Promise<boolean> {
  const token = process.env.LINE_CHANNEL_ACCESS_TOKEN;
  if (!token) {
    console.error("[line] LINE_CHANNEL_ACCESS_TOKEN not set");
    return false;
  }

  const res = await fetch("https://api.line.me/v2/bot/message/push", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${token}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ to: lineUserId, messages }),
  });

  if (!res.ok) {
    const errText = await res.text().catch(() => "<no body>");
    console.error(`[line] push failed status=${res.status} body=${errText}`);
    if (looksLikeQuotaExceeded(res.status, errText)) {
      await flagQuotaExceededFromSend("sendLineMessage push", errText);
    }
  }

  return res.ok;
}

export async function broadcastLineMessages(
  messages: LineMessage[]
): Promise<{ ok: boolean; error?: string }> {
  const token = process.env.LINE_CHANNEL_ACCESS_TOKEN;
  if (!token) return { ok: false, error: "LINE_CHANNEL_ACCESS_TOKEN not set" };

  const res = await fetch("https://api.line.me/v2/bot/message/broadcast", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${token}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ messages }),
  });

  if (!res.ok) {
    const err = await res.text();
    if (looksLikeQuotaExceeded(res.status, err)) {
      await flagQuotaExceededFromSend("broadcastLineMessages", err);
    }
    return { ok: false, error: err };
  }
  return { ok: true };
}

export function verifyLineSignature(body: string, signature: string): boolean {
  const secret = process.env.LINE_CHANNEL_SECRET;
  if (!secret) {
    // Fail closed if the webhook secret isn't configured.
    console.error("LINE_CHANNEL_SECRET is not set; rejecting webhook");
    return false;
  }
  const expected = crypto
    .createHmac("sha256", secret)
    .update(body)
    .digest();

  let received: Buffer;
  try {
    received = Buffer.from(signature, "base64");
  } catch {
    return false;
  }

  if (received.length !== expected.length) return false;
  return crypto.timingSafeEqual(received, expected);
}
