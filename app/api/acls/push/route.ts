import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";

// Ported from acls-emr's api/push/subscribe.js. Writes go to
// acls_push_subscriptions (renamed from push_subscriptions), which has no
// client RLS policies — service-role only, tighter than the source — so all
// access goes through createAdminClient() here.

interface SubscribeBody {
  subscription?: {
    endpoint?: string;
    keys?: { p256dh?: string; auth?: string };
  };
  course?: string;
  userAgent?: string;
}

export async function POST(request: NextRequest) {
  const supabase = createAdminClient();

  let body: SubscribeBody;
  try {
    body = (await request.json()) as SubscribeBody;
  } catch {
    body = {};
  }

  const sub = body.subscription;
  if (!sub?.endpoint || !sub?.keys?.p256dh || !sub?.keys?.auth) {
    return NextResponse.json({ error: "invalid subscription" }, { status: 400 });
  }
  const course = ["acls", "bls", "both"].includes(body.course ?? "") ? body.course : "both";

  const { error } = await supabase.from("acls_push_subscriptions").upsert(
    {
      endpoint: sub.endpoint,
      p256dh: sub.keys.p256dh,
      auth: sub.keys.auth,
      course,
      user_agent: String(body.userAgent || "").slice(0, 200) || null,
      failure_count: 0,
      disabled_at: null,
    },
    { onConflict: "endpoint" },
  );

  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ ok: true });
}

export async function DELETE(request: NextRequest) {
  const supabase = createAdminClient();

  let body: { endpoint?: string };
  try {
    body = (await request.json()) as { endpoint?: string };
  } catch {
    body = {};
  }

  const endpoint = body.endpoint;
  if (!endpoint) {
    return NextResponse.json({ error: "missing endpoint" }, { status: 400 });
  }

  const { error } = await supabase
    .from("acls_push_subscriptions")
    .delete()
    .eq("endpoint", endpoint);

  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ ok: true });
}
