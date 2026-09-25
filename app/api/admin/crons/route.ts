/**
 * GET /api/admin/crons — health of every Vercel cron for /admin/crons.
 *
 * `cron_runs` is service-role only (RLS on, no policies), so the admin page
 * can't read it with the browser client; this route checks the caller is an
 * admin and reads it with the service role.
 */

import { NextResponse } from "next/server";
import { requireAdmin } from "@/lib/admin-auth";
import { createAdminClient } from "@/lib/supabase/admin";
import { fetchCronHealth } from "@/lib/cron-runs";

export const runtime = "nodejs";

export async function GET() {
  const auth = await requireAdmin();
  if (!auth.ok) return auth.response;

  try {
    const now = new Date();
    const jobs = await fetchCronHealth(createAdminClient(), now);
    return NextResponse.json({ ok: true, generatedAt: now.toISOString(), jobs });
  } catch (err) {
    console.error("[admin/crons] fetch failed:", err);
    const message =
      err && typeof err === "object" && "message" in err ? String(err.message) : String(err);
    return NextResponse.json({ ok: false, error: message }, { status: 500 });
  }
}
