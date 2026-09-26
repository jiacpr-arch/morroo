/**
 * Immediate admin LINE alerts for the few events that shouldn't wait for the
 * 08:00 digest — throttled per kind so a burst (e.g. a brigade reporting many
 * comments) pings the admin at most once per window. Everything else, and
 * anything suppressed by the throttle, still shows up in the digest's
 * "📋 งานรอแอดมิน" section (lib/admin-action-items.ts).
 *
 * Same throttle pattern as alertCronFailure in lib/cron-runs.ts: last-sent
 * timestamp in app_settings under `admin_alert_sent_at:<kind>`.
 */

import type { createAdminClient } from "@/lib/supabase/admin";
import { sendLineMessage } from "@/lib/line";
import { adminUrl } from "@/lib/admin-action-items";

type AdminClient = ReturnType<typeof createAdminClient>;

export const ADMIN_ALERT_THROTTLE_MS = 6 * 60 * 60_000;

export type AdminAlertKind = "comment_autohidden" | "mcq_autoflagged";

export function adminAlertKey(kind: AdminAlertKind): string {
  return `admin_alert_sent_at:${kind}`;
}

/** Pure: may we send again, given the last-sent ISO timestamp? */
export function isAlertThrottled(
  lastSentAt: string | null | undefined,
  now: Date,
  throttleMs = ADMIN_ALERT_THROTTLE_MS
): boolean {
  if (!lastSentAt) return false;
  const t = Date.parse(lastSentAt);
  if (Number.isNaN(t)) return false;
  return now.getTime() - t < throttleMs;
}

export function buildAdminAlertText(opts: {
  title: string;
  detail?: string | null;
  path: string;
  throttleMs?: number;
}): string {
  const hours = (opts.throttleMs ?? ADMIN_ALERT_THROTTLE_MS) / 3_600_000;
  return [
    opts.title,
    ...(opts.detail ? [opts.detail.replace(/\s+/g, " ").trim().slice(0, 200)] : []),
    "",
    `จัดการ: ${adminUrl(opts.path)}`,
    `(แจ้งเรื่องนี้ไม่เกิน 1 ครั้งทุก ${hours} ชม. — ที่เหลือดูในสรุปเช้า)`,
  ].join("\n");
}

/**
 * Push `text` to ADMIN_LINE_USER_ID unless an alert of the same kind went out
 * within the throttle window. Never throws; returns whether it sent.
 */
export async function sendThrottledAdminAlert(
  admin: AdminClient,
  kind: AdminAlertKind,
  text: string,
  now: Date = new Date()
): Promise<boolean> {
  try {
    const adminLineId = process.env.ADMIN_LINE_USER_ID;
    if (!adminLineId) return false;

    const key = adminAlertKey(kind);
    const { data } = await admin.from("app_settings").select("value").eq("key", key).maybeSingle();
    const last = (data as { value?: string } | null)?.value;
    if (isAlertThrottled(last, now)) return false;

    // Claim the window before sending so concurrent requests don't double-send.
    const nowIso = now.toISOString();
    await admin.from("app_settings").upsert({ key, value: nowIso, updated_at: nowIso });

    return await sendLineMessage(adminLineId, [{ type: "text", text }]);
  } catch (err) {
    console.error(`[admin-alerts] ${kind} alert failed:`, err);
    return false;
  }
}
