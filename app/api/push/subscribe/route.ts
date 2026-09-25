// Web Push opt-in/out for the current browser (profile page toggle).
//
// POST   { subscription: PushSubscriptionJSON } → upsert by endpoint
// DELETE { endpoint }                           → remove this browser's row
//
// POST upserts through the service-role client: endpoint is unique per
// browser, so when a second account logs in on the same device the row has
// to move to the new user — an RLS-scoped upsert can't update a row the new
// user doesn't own yet. The user id always comes from the session, never the
// request body.

import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { parseSubscriptionJson } from "@/lib/push";

export const runtime = "nodejs";

export async function POST(request: Request) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const body = (await request.json().catch(() => null)) as { subscription?: unknown } | null;
  const sub = parseSubscriptionJson(body?.subscription);
  if (!sub) {
    return NextResponse.json({ error: "Invalid subscription" }, { status: 400 });
  }

  const userAgent = (request.headers.get("user-agent") ?? "").slice(0, 512) || null;
  const admin = createAdminClient();
  const { error } = await admin.from("push_subscriptions").upsert(
    {
      user_id: user.id,
      endpoint: sub.endpoint,
      p256dh: sub.p256dh,
      auth: sub.auth,
      user_agent: userAgent,
    },
    { onConflict: "endpoint" }
  );
  if (error) {
    console.error("[push/subscribe] upsert failed:", error.message);
    return NextResponse.json({ error: "บันทึกไม่สำเร็จ" }, { status: 500 });
  }
  return NextResponse.json({ ok: true });
}

export async function DELETE(request: Request) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const body = (await request.json().catch(() => null)) as { endpoint?: unknown } | null;
  const endpoint = typeof body?.endpoint === "string" ? body.endpoint : "";
  if (!endpoint) {
    return NextResponse.json({ error: "Missing endpoint" }, { status: 400 });
  }

  // RLS limits this to the caller's own rows; the eq on user_id is belt and braces.
  const { error } = await supabase
    .from("push_subscriptions")
    .delete()
    .eq("endpoint", endpoint)
    .eq("user_id", user.id);
  if (error) {
    console.error("[push/subscribe] delete failed:", error.message);
    return NextResponse.json({ error: "ลบไม่สำเร็จ" }, { status: 500 });
  }
  return NextResponse.json({ ok: true });
}
