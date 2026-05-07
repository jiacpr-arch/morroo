import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import crypto from "crypto";

export const runtime = "nodejs";

/** GET — Meta pings this URL to verify it's reachable before accepting it in the dashboard. */
export function GET() {
  return NextResponse.json({ status: "ok" });
}

/**
 * Parses and verifies a Facebook signed_request.
 * Format: base64url(HMAC-SHA256(payload, appSecret)).base64url(payload)
 * Handles both top-level `user_id` and nested `user.id` payload shapes.
 */
function parseSignedRequest(
  signedRequest: string,
  appSecret: string
): { userId: string } | null {
  const parts = signedRequest.split(".");
  if (parts.length !== 2) return null;

  const [encodedSig, encodedPayload] = parts;

  const toBase64 = (s: string) => s.replace(/-/g, "+").replace(/_/g, "/");

  const sig = Buffer.from(toBase64(encodedSig), "base64");
  const expected = crypto
    .createHmac("sha256", appSecret)
    .update(encodedPayload)
    .digest();

  if (sig.length !== expected.length || !crypto.timingSafeEqual(sig, expected)) {
    return null;
  }

  let payload: Record<string, unknown>;
  try {
    const json = Buffer.from(toBase64(encodedPayload), "base64").toString("utf8");
    payload = JSON.parse(json);
  } catch {
    return null;
  }

  // Facebook sends either user_id (top-level) or user.id (nested, Login product)
  const userId =
    (payload.user_id as string | undefined) ??
    ((payload.user as { id?: string } | undefined)?.id);

  if (!userId) return null;
  return { userId };
}

/**
 * POST /api/facebook/data-deletion
 *
 * Facebook Data Deletion Request Callback — called when a user removes the app
 * via Facebook's Privacy Center. Meta sends a signed_request (form-encoded)
 * containing the user_id (PSID). We delete all chat history for that user and
 * return a confirmation code + status URL as required by Meta's spec.
 *
 * Docs: https://developers.facebook.com/docs/development/create-an-app/app-dashboard/data-deletion-callback
 */
export async function POST(request: NextRequest) {
  const appSecret = process.env.FACEBOOK_APP_SECRET;
  if (!appSecret) {
    console.error("[fb-deletion] FACEBOOK_APP_SECRET not set");
    return NextResponse.json({ error: "Not configured" }, { status: 500 });
  }

  // Meta sends as application/x-www-form-urlencoded
  let signedRequest: string | null = null;
  try {
    const text = await request.text();
    const params = new URLSearchParams(text);
    signedRequest = params.get("signed_request");
  } catch {
    return NextResponse.json({ error: "Invalid request body" }, { status: 400 });
  }

  if (!signedRequest) {
    return NextResponse.json({ error: "Missing signed_request" }, { status: 400 });
  }

  const parsed = parseSignedRequest(signedRequest, appSecret);
  if (!parsed) {
    return NextResponse.json({ error: "Invalid signed_request" }, { status: 401 });
  }

  const { userId } = parsed;
  const confirmationCode = crypto.randomUUID();

  const supabase = createAdminClient();

  const { error } = await supabase
    .from("chat_messages")
    .delete()
    .eq("channel", "facebook")
    .eq("channel_user_id", userId);

  if (error) {
    console.error("[fb-deletion] delete failed:", error.message);
    return NextResponse.json({ error: "Deletion failed" }, { status: 500 });
  }

  console.log(`[fb-deletion] deleted data for psid=${userId} code=${confirmationCode}`);

  const siteUrl = "https://www.morroo.com";
  return NextResponse.json({
    url: `${siteUrl}/deletion-status?code=${confirmationCode}`,
    confirmation_code: confirmationCode,
  });
}
