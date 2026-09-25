// Web Push sender (server-only) — ส่งแจ้งเตือนไปยังเบราว์เซอร์/แอปที่ติดตั้งบนหน้าจอหลัก
//
// Subscriptions live in public.push_subscriptions (one row per browser/device,
// endpoint unique — see supabase/migrations/20260925_push_subscriptions.sql).
// Callers pass a service-role client: the cron fans out across users, which
// RLS (own rows only) would otherwise block.
//
// Env:
//   NEXT_PUBLIC_VAPID_PUBLIC_KEY  — also read by the browser to subscribe
//   VAPID_PRIVATE_KEY
//   VAPID_SUBJECT                 — "mailto:..." or https URL (defaults to the site URL)
// When the keys are missing every send is a no-op ({ skipped: true }) so
// previews / forks without VAPID keys keep working.
//
// Push services answer 404/410 for a subscription the user revoked or the
// browser dropped — those rows are deleted so we stop retrying them forever.

import webpush from "web-push";
import type { SupabaseClient } from "@supabase/supabase-js";

export interface PushPayload {
  title: string;
  body: string;
  /** Same-origin path opened on click (the SW rejects other origins). */
  url?: string;
  /** Notifications with the same tag replace each other instead of stacking. */
  tag?: string;
  icon?: string;
}

export interface PushSubscriptionRow {
  id: string;
  user_id: string;
  endpoint: string;
  p256dh: string;
  auth: string;
}

export interface PushSendResult {
  /** True when VAPID env is not configured — nothing was attempted. */
  skipped: boolean;
  sent: number;
  failed: number;
  /** Subscriptions deleted because the push service reported them gone. */
  removed: number;
}

interface VapidConfig {
  publicKey: string;
  privateKey: string;
  subject: string;
}

export function getVapidConfig(): VapidConfig | null {
  const publicKey = process.env.NEXT_PUBLIC_VAPID_PUBLIC_KEY?.trim();
  const privateKey = process.env.VAPID_PRIVATE_KEY?.trim();
  if (!publicKey || !privateKey) return null;
  const subject =
    process.env.VAPID_SUBJECT?.trim() ||
    (process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com").trim();
  return { publicKey, privateKey, subject };
}

export function isPushConfigured(): boolean {
  return getVapidConfig() !== null;
}

/** 404 Not Found / 410 Gone from the push service = subscription is dead. */
export function isGoneError(err: unknown): boolean {
  const status = (err as { statusCode?: unknown } | null)?.statusCode;
  return status === 404 || status === 410;
}

let configuredKey: string | null = null;

function ensureVapid(cfg: VapidConfig) {
  const key = `${cfg.subject}|${cfg.publicKey}|${cfg.privateKey}`;
  if (configuredKey === key) return;
  webpush.setVapidDetails(cfg.subject, cfg.publicKey, cfg.privateKey);
  configuredKey = key;
}

/** Send one payload to each subscription; prunes dead ones. Never throws. */
export async function sendPushToSubscriptions(
  supabase: SupabaseClient,
  subscriptions: PushSubscriptionRow[],
  payload: PushPayload
): Promise<PushSendResult> {
  const result: PushSendResult = { skipped: false, sent: 0, failed: 0, removed: 0 };
  const cfg = getVapidConfig();
  if (!cfg) return { ...result, skipped: true };
  if (subscriptions.length === 0) return result;

  ensureVapid(cfg);
  const body = JSON.stringify(payload);
  const goneIds: string[] = [];

  await Promise.all(
    subscriptions.map(async (sub) => {
      try {
        await webpush.sendNotification(
          { endpoint: sub.endpoint, keys: { p256dh: sub.p256dh, auth: sub.auth } },
          body,
          // A daily nudge is worthless a day later — let the push service drop it.
          { TTL: 12 * 3600, urgency: "normal" }
        );
        result.sent++;
      } catch (err) {
        if (isGoneError(err)) {
          goneIds.push(sub.id);
        } else {
          result.failed++;
          console.error(`[push] send failed for subscription ${sub.id}:`, err);
        }
      }
    })
  );

  if (goneIds.length > 0) {
    const { error } = await supabase.from("push_subscriptions").delete().in("id", goneIds);
    if (error) {
      console.error("[push] failed to prune gone subscriptions:", error.message);
    } else {
      result.removed = goneIds.length;
    }
  }

  const sentIds = subscriptions.map((s) => s.id).filter((id) => !goneIds.includes(id));
  if (result.sent > 0 && sentIds.length > 0) {
    // Best-effort bookkeeping — an error here is ignored, the send already happened.
    await supabase
      .from("push_subscriptions")
      .update({ last_used_at: new Date().toISOString() })
      .in("id", sentIds);
  }

  return result;
}

/** Look up every subscription for a user and send to all of them. */
export async function sendPushToUser(
  supabase: SupabaseClient,
  userId: string,
  payload: PushPayload
): Promise<PushSendResult> {
  if (!isPushConfigured()) return { skipped: true, sent: 0, failed: 0, removed: 0 };
  const { data, error } = await supabase
    .from("push_subscriptions")
    .select("id, user_id, endpoint, p256dh, auth")
    .eq("user_id", userId);
  if (error) {
    console.error(`[push] failed to load subscriptions for ${userId}:`, error.message);
    return { skipped: false, sent: 0, failed: 1, removed: 0 };
  }
  return sendPushToSubscriptions(supabase, (data ?? []) as PushSubscriptionRow[], payload);
}

/** Shape the browser's PushSubscription.toJSON() into a table row. Null if malformed. */
export function parseSubscriptionJson(
  input: unknown
): { endpoint: string; p256dh: string; auth: string } | null {
  if (!input || typeof input !== "object") return null;
  const o = input as { endpoint?: unknown; keys?: { p256dh?: unknown; auth?: unknown } };
  const endpoint = typeof o.endpoint === "string" ? o.endpoint : "";
  const p256dh = typeof o.keys?.p256dh === "string" ? o.keys.p256dh : "";
  const auth = typeof o.keys?.auth === "string" ? o.keys.auth : "";
  if (!endpoint || !p256dh || !auth) return null;
  let url: URL;
  try {
    url = new URL(endpoint);
  } catch {
    return null;
  }
  // Push services are always https; refuse anything else so the server never
  // POSTs to an arbitrary internal URL on a user's behalf.
  if (url.protocol !== "https:" || endpoint.length > 1024) return null;
  if (p256dh.length > 256 || auth.length > 128) return null;
  return { endpoint, p256dh, auth };
}
