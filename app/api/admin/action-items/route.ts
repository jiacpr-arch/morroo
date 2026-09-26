import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";
import { getAdminActionItems, sortActionItems } from "@/lib/admin-action-items";

/**
 * GET /api/admin/action-items
 *
 * The admin's action queue (same list as the "📋 งานรอแอดมิน" section of the
 * morning LINE digest) — non-zero / failed items only, most urgent first.
 */
export async function GET() {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const items = await getAdminActionItems(createAdminClient());
  return NextResponse.json({ items: sortActionItems(items) });
}
