/**
 * Server-side mirror of @vercel/analytics track() — writes the same
 * event the client just fired into our analytics_events table so we
 * can build digests / admin dashboards (Vercel Analytics has no read
 * API). Called by lib/analytics.ts#trackEvent.
 *
 * Public POST. Fire-and-forget from the browser; failures are swallowed
 * to keep the UX silent.
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";

export const runtime = "nodejs";

const MAX_EVENT_NAME = 64;
const MAX_STRING = 512;

function clamp(value: unknown, max: number): string | null {
  if (typeof value !== "string") return null;
  const trimmed = value.trim();
  if (!trimmed) return null;
  return trimmed.length > max ? trimmed.slice(0, max) : trimmed;
}

export async function POST(request: Request) {
  let body: Record<string, unknown>;
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ ok: false }, { status: 400 });
  }

  const eventName = clamp(body.event_name, MAX_EVENT_NAME);
  if (!eventName) return NextResponse.json({ ok: false }, { status: 400 });

  const sessionId = clamp(body.session_id, 64);
  const path = clamp(body.path, MAX_STRING);
  const referrer = clamp(body.referrer, MAX_STRING);
  const properties =
    body.properties && typeof body.properties === "object" && !Array.isArray(body.properties)
      ? (body.properties as Record<string, unknown>)
      : null;

  const userAgent = clamp(request.headers.get("user-agent"), MAX_STRING);
  const country =
    clamp(request.headers.get("x-vercel-ip-country"), 8) ??
    clamp(request.headers.get("cf-ipcountry"), 8);

  let userId: string | null = null;
  try {
    const supabase = await createClient();
    const { data } = await supabase.auth.getUser();
    userId = data.user?.id ?? null;
  } catch {
    // anonymous — leave null
  }

  const admin = createAdminClient();
  const { error } = await admin.from("analytics_events").insert({
    event_name: eventName,
    properties,
    user_id: userId,
    session_id: sessionId,
    path,
    referrer,
    country,
    user_agent: userAgent,
  });

  if (error) {
    console.error("[analytics] insert failed:", error.message);
    return NextResponse.json({ ok: false }, { status: 500 });
  }

  return NextResponse.json({ ok: true });
}
