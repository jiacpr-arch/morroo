import { NextResponse } from "next/server";
import { createClient as createServerSupabaseClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";

/**
 * POST /api/line/liff-link
 *
 * Body: { idToken: string }
 *
 * Verifies a LIFF-issued ID token with LINE, then links the resulting LINE
 * userId to the currently signed-in Supabase user (when present).
 *
 * Returns { linked: true } when the linking succeeded, or { linked: false }
 * when the LIFF visitor was verified as a LINE user but there is no Supabase
 * session yet (cold ad lead). The OA already captures follow events via
 * webhook, so the lineUserId is recoverable later from the messaging side.
 */
export async function POST(request: Request) {
  const channelId = process.env.LINE_LOGIN_CHANNEL_ID;
  if (!channelId) {
    return NextResponse.json(
      { error: "LINE_LOGIN_CHANNEL_ID is not configured" },
      { status: 500 }
    );
  }

  let body: { idToken?: unknown };
  try {
    body = (await request.json()) as { idToken?: unknown };
  } catch {
    return NextResponse.json({ error: "invalid_body" }, { status: 400 });
  }

  const idToken = typeof body.idToken === "string" ? body.idToken : "";
  if (!idToken) {
    return NextResponse.json({ error: "missing_id_token" }, { status: 400 });
  }

  // Verify the ID token directly with LINE — never trust a client-supplied
  // userId. The audience must equal our LINE Login channel ID.
  const verifyRes = await fetch("https://api.line.me/oauth2/v2.1/verify", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      id_token: idToken,
      client_id: channelId,
    }),
  });

  if (!verifyRes.ok) {
    const detail = await verifyRes.text();
    console.error("LIFF id_token verify failed:", detail);
    return NextResponse.json(
      { error: "id_token_verify_failed" },
      { status: 401 }
    );
  }

  const payload = (await verifyRes.json()) as { sub?: string; aud?: string };
  if (!payload.sub || payload.aud !== channelId) {
    return NextResponse.json({ error: "id_token_invalid" }, { status: 401 });
  }

  const lineUserId = payload.sub;

  const supabase = await createServerSupabaseClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    // Cold lead — verified LINE follower but no morroo session. The OA's
    // own follow-event webhook captures lineUserId for marketing, so we
    // simply report back that the linking step is pending login.
    return NextResponse.json({ linked: false });
  }

  const admin = createAdminClient();
  const { error: updateError } = await admin
    .from("profiles")
    .update({
      line_user_id: lineUserId,
      line_linked_at: new Date().toISOString(),
    })
    .eq("id", user.id);

  if (updateError) {
    console.error("Failed to update profile.line_user_id:", updateError);
    return NextResponse.json({ error: "link_failed" }, { status: 500 });
  }

  return NextResponse.json({ linked: true });
}
