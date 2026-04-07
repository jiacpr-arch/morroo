import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendLineMessage } from "@/lib/line";
import { buildExpiryWarningMessage } from "@/lib/line-flex-templates";

export const runtime = "nodejs";

export async function POST(request: Request) {
  const { searchParams } = new URL(request.url);
  if (searchParams.get("secret") !== process.env.BLOG_GENERATE_SECRET) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const supabase = createAdminClient();
  const now = new Date();
  const from = new Date(now.getTime() + 6 * 86400_000); // +6 days
  const to = new Date(now.getTime() + 7 * 86400_000);   // +7 days

  const { data: users, error } = await supabase
    .from("profiles")
    .select("id, name, line_user_id, membership_type, membership_expires_at")
    .not("line_user_id", "is", null)
    .neq("membership_type", "free")
    .gte("membership_expires_at", from.toISOString())
    .lte("membership_expires_at", to.toISOString());

  if (error) {
    console.error("[expiry-warning] query error:", error);
    return NextResponse.json({ error: "DB query failed" }, { status: 500 });
  }

  let sent = 0;
  for (const user of users ?? []) {
    const msg = buildExpiryWarningMessage({
      name: user.name ?? "",
      expiresAt: new Date(user.membership_expires_at),
      membershipType: user.membership_type,
    });

    const ok = await sendLineMessage(user.line_user_id, [msg]);
    if (ok) sent++;
  }

  console.log(`[expiry-warning] sent ${sent}/${(users ?? []).length}`);
  return NextResponse.json({ ok: true, sent, total: (users ?? []).length });
}
