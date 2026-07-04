/**
 * Server-side CAPI mirror for email/password registrations.
 *
 * OAuth (Google/LINE) signups fire CompleteRegistration server-side from
 * app/auth/callback, but email signups never pass through that route — they
 * only fired the browser pixel (lib/analytics/conversions.ts#trackEmailSignup),
 * so iOS / ad-blocker users were invisible to Meta/TikTok and the conversion
 * campaigns were starved of signal. This route adds the missing server copy.
 *
 * The eventId is `signup:<userId>` — identical to the browser pixel's eventID —
 * so Meta/TikTok dedupe the browser+server pair into one CompleteRegistration.
 *
 * Public POST, fire-and-forget from the register page. The user has just
 * signed up but isn't authenticated yet (email confirmation is pending), so we
 * can't use the session. Instead we verify the userId against auth.users via
 * the service role and only emit for a freshly-created account, which keeps a
 * stranger from spamming fake registration conversions.
 */

import { NextResponse, after } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendMetaEvent } from "@/lib/meta/events-api";
import { sendTikTokEvent } from "@/lib/tiktok/events-api";

export const runtime = "nodejs";

const UUID_RE =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

// Only mirror accounts created in the last few minutes. The register page calls
// this immediately after signUp(), so a wider window would just let someone
// replay old user ids to inflate conversions.
const FRESH_SIGNUP_WINDOW_MS = 15 * 60_000;

export async function POST(request: Request) {
  let body: { userId?: unknown };
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ ok: false }, { status: 400 });
  }

  const userId = typeof body.userId === "string" ? body.userId : "";
  if (!UUID_RE.test(userId)) {
    return NextResponse.json({ ok: false }, { status: 400 });
  }

  const admin = createAdminClient();
  const { data, error } = await admin.auth.admin.getUserById(userId);
  const user = data?.user;
  // Silently no-op (200) for unknown/stale ids so the client stays quiet, but
  // never emit a conversion we can't tie to a real, fresh account.
  if (error || !user) return NextResponse.json({ ok: true });

  const createdAt = user.created_at ? new Date(user.created_at).getTime() : 0;
  if (!createdAt || Date.now() - createdAt > FRESH_SIGNUP_WINDOW_MS) {
    return NextResponse.json({ ok: true });
  }

  const cookies = request.headers.get("cookie") ?? "";
  const readCookie = (name: string): string | null => {
    const match = cookies.match(
      new RegExp(`(?:^|;\\s*)${name}=([^;]+)`)
    );
    return match ? decodeURIComponent(match[1]) : null;
  };

  const userAgent = request.headers.get("user-agent");
  const ip =
    request.headers.get("x-forwarded-for")?.split(",")[0]?.trim() ?? null;
  const fbc = readCookie("_fbc");
  const fbp = readCookie("_fbp");
  const ttclid = readCookie("ttclid");
  const ttp = readCookie("_ttp");
  const eventId = `signup:${user.id}`;
  const url = request.headers.get("referer");

  after(() =>
    sendMetaEvent({
      event: "CompleteRegistration",
      eventId,
      email: user.email ?? null,
      externalId: user.id,
      ip,
      userAgent,
      fbc,
      fbp,
      url,
      contentName: "signup",
    })
  );
  after(() =>
    sendTikTokEvent({
      event: "CompleteRegistration",
      eventId,
      email: user.email ?? null,
      externalId: user.id,
      ip,
      userAgent,
      ttclid,
      ttp,
      url,
      contentName: "signup",
    })
  );

  return NextResponse.json({ ok: true });
}
