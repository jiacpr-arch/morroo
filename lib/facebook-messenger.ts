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
    const err = await res.text().catch(() => "<no body>");
    console.error(`[fb] send failed status=${res.status} body=${err}`);
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
