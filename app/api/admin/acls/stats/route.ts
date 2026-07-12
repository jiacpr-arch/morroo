import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

// Admin-only: aggregate dashboard numbers for the ACLS/BLS stats page.
// Computed by public.get_acls_admin_stats() (service-role only RPC).
// Ported from acls-emr's api/admin/stats.js.

export const runtime = "nodejs";
export const maxDuration = 10;

export async function GET() {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const supabase = createAdminClient();
  const { data, error } = await supabase.rpc("get_acls_admin_stats");
  if (error) {
    console.error("get_acls_admin_stats failed:", error.message);
    return NextResponse.json({ error: "Failed to load admin stats" }, { status: 500 });
  }
  return NextResponse.json(data || {});
}
