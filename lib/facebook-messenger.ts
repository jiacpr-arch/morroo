/**
 * Facebook Messenger send helpers + webhook signature verification.
 *
 * Required env vars:
 *   FACEBOOK_PAGE_TOKEN   – Page Access Token with `pages_messaging` permission
 *   FACEBOOK_APP_SECRET   – used to verify X-Hub-Signature-256 on incoming webhooks
 *   FACEBOOK_VERIFY_TOKEN – random string we set in the FB App webhook config; must match the
 *                            `hub.verify_token` query param during subscription handshake
 */

import crypto from "crypto";

const GRAPH_API = "https://graph.facebook.com/v24.0";

/** Page Inbox app ID — primary receiver for Click-to-Messenger conversations
 *  when no other handover routing is configured. Used to pass thread control
 *  back to the Page Inbox if we ever need to release control. */
const PAGE_INBOX_APP_ID = "263902037430900";

type FbGraphError = {
  message?: string;
  type?: string;
  code?: number;
  error_subcode?: number;
  fbtrace_id?: string;
};

/** Parse a Graph API error response into separate log fields so Vercel's
 *  truncated single-line preview still shows the diagnostic code/subcode. */
async function logGraphFailure(
  context: string,
  res: Response,
  recipientPsid: string
): Promise<void> {
  const rawBody = await res.text().catch(() => "");
  let parsed: { error?: FbGraphError } | null = null;
  try {
    parsed = rawBody ? (JSON.parse(rawBody) as { error?: FbGraphError }) : null;
  } catch {
    parsed = null;
  }
  const err = parsed?.error;
  console.error(
    `[fb] ${context} failed status=${res.status} psid=${recipientPsid}` +
      ` code=${err?.code ?? "?"} subcode=${err?.error_subcode ?? "?"}` +
      ` fbtrace=${err?.fbtrace_id ?? "?"} message=${err?.message ?? rawBody.slice(0, 200)}`
  );
}

/** Send a plain text message back to a user via the Messenger Send API. */
export async function sendFbMessage(
  recipientPsid: string,
  text: string
): Promise<boolean> {
  const token = process.env.FACEBOOK_PAGE_TOKEN;
  if (!token) {
    console.error("[fb] FACEBOOK_PAGE_TOKEN not set");
    return false;
  }

  const res = await fetch(
    `${GRAPH_API}/me/messages?access_token=${encodeURIComponent(token)}`,
    {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        recipient: { id: recipientPsid },
        message: { text },
        // RESPONSE: standard 24-hour reply window after a user-initiated message
        messaging_type: "RESPONSE",
      }),
    }
  );

  if (!res.ok) {
    await logGraphFailure("send", res, recipientPsid);
  }

  return res.ok;
}

/** Mark the user's last message as read so they see the read receipt while AI thinks. */
export async function sendFbReadReceipt(recipientPsid: string): Promise<void> {
  const token = process.env.FACEBOOK_PAGE_TOKEN;
  if (!token) return;

  await fetch(
    `${GRAPH_API}/me/messages?access_token=${encodeURIComponent(token)}`,
    {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        recipient: { id: recipientPsid },
        sender_action: "mark_seen",
      }),
    }
  ).catch(() => {});
}

/** Show the typing indicator while the AI is generating. */
export async function sendFbTyping(recipientPsid: string, on: boolean): Promise<void> {
  const token = process.env.FACEBOOK_PAGE_TOKEN;
  if (!token) return;

  await fetch(
    `${GRAPH_API}/me/messages?access_token=${encodeURIComponent(token)}`,
    {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        recipient: { id: recipientPsid },
        sender_action: on ? "typing_on" : "typing_off",
      }),
    }
  ).catch(() => {});
}

/**
 * Take control of a conversation thread via Messenger Handover Protocol.
 *
 * Click-to-Messenger ads default to routing the conversation to the Page Inbox
 * (Meta's built-in app, ID 263902037430900) as the primary receiver. Our app
 * then only sees `standby` events instead of `messaging` events, and Send API
 * calls return (#10) "Application does not have permission for this action".
 *
 * Call this when we receive a standby event for an ad-initiated conversation
 * to claim thread control — afterwards we receive normal messaging events and
 * can Send normally. No-op (returns false) if the Page hasn't configured the
 * Handover Protocol in App Dashboard → Messenger → Settings.
 *
 * Docs: https://developers.facebook.com/docs/messenger-platform/handover-protocol
 */
export async function takeThreadControl(recipientPsid: string): Promise<boolean> {
  const token = process.env.FACEBOOK_PAGE_TOKEN;
  if (!token) return false;

  const res = await fetch(
    `${GRAPH_API}/me/take_thread_control?access_token=${encodeURIComponent(token)}`,
    {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        recipient: { id: recipientPsid },
        metadata: "ctm-ad-takeover",
      }),
    }
  );

  if (!res.ok) {
    await logGraphFailure("take_thread_control", res, recipientPsid);
  }
  return res.ok;
}

/** App ID of Meta's Page Inbox primary receiver — exported so callers can
 *  recognize standby events that originated from the Page Inbox. */
export { PAGE_INBOX_APP_ID };

/**
 * Verify X-Hub-Signature-256 header matches HMAC-SHA256(body, APP_SECRET).
 * Webhook payloads from Meta include this header; reject if it doesn't match.
 */
export function verifyFbSignature(rawBody: string, signatureHeader: string | null): boolean {
  if (!signatureHeader) return false;
  const secret = process.env.FACEBOOK_APP_SECRET;
  if (!secret) {
    console.error("[fb] FACEBOOK_APP_SECRET not set; rejecting webhook");
    return false;
  }

  // Header format: "sha256=<hex>"
  const prefix = "sha256=";
  if (!signatureHeader.startsWith(prefix)) return false;
  const receivedHex = signatureHeader.slice(prefix.length);

  const expected = crypto.createHmac("sha256", secret).update(rawBody).digest();

  let received: Buffer;
  try {
    received = Buffer.from(receivedHex, "hex");
  } catch {
    return false;
  }

  if (received.length !== expected.length) return false;
  return crypto.timingSafeEqual(received, expected);
}
