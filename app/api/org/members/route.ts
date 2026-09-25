import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { getOrgRole } from "@/lib/organizations-server";

export const runtime = "nodejs";

/**
 * DELETE /api/org/members  Body: { org_id, user_id }
 *
 * An org owner (or a site admin) removes a member. Group access ends on the
 * member's next request — org entitlements are derived live from this row
 * (lib/organizations.ts), nothing else needs revoking. Owners cannot be
 * removed here (site admin does that from /admin/organizations → delete org,
 * or directly in the DB) so an org is never left without a manager by
 * accident.
 */
export async function DELETE(request: Request) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  let body: { org_id?: unknown; user_id?: unknown };
  try {
    body = (await request.json()) as typeof body;
  } catch {
    return NextResponse.json({ error: "Invalid JSON" }, { status: 400 });
  }
  const orgId = typeof body.org_id === "string" ? body.org_id : "";
  const targetId = typeof body.user_id === "string" ? body.user_id : "";
  if (!orgId || !targetId) {
    return NextResponse.json({ error: "org_id and user_id are required" }, { status: 400 });
  }

  const [callerRole, { data: profile }] = await Promise.all([
    getOrgRole(orgId, user.id),
    supabase.from("profiles").select("role").eq("id", user.id).maybeSingle(),
  ]);
  const isSiteAdmin = (profile as { role?: string } | null)?.role === "admin";
  if (callerRole !== "owner" && !isSiteAdmin) {
    return NextResponse.json({ error: "เฉพาะผู้ดูแลกลุ่มเท่านั้น" }, { status: 403 });
  }

  const targetRole = await getOrgRole(orgId, targetId);
  if (!targetRole) return NextResponse.json({ error: "ไม่พบสมาชิกนี้ในกลุ่ม" }, { status: 404 });
  if (targetRole === "owner" && !isSiteAdmin) {
    return NextResponse.json({ error: "ลบผู้ดูแลกลุ่มไม่ได้ กรุณาติดต่อทีมงาน" }, { status: 400 });
  }

  const admin = createAdminClient();
  const { error } = await admin
    .from("organization_members")
    .delete()
    .eq("org_id", orgId)
    .eq("user_id", targetId);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ ok: true });
}
