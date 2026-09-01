import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

/**
 * POST /api/admin/leads/[id]/stage
 *
 * Body: { stage: "new" | "contacted" | "code_issued" | "registered" | "redeemed" | "paid" | "dropped" }
 *
 * Manual stage transitions for the lead pipeline. The DB CHECK constraint
 * on `leads.stage` rejects unknown values.
 */
const VALID_STAGES = [
  "new",
  "contacted",
  "code_issued",
  "registered",
  "redeemed",
  "paid",
  "dropped",
] as const;

type Stage = (typeof VALID_STAGES)[number];

export async function POST(
  request: Request,
  { params }: { params: Promise<{ id: string }> }
) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const { id } = await params;

  let body: { stage?: unknown };
  try {
    body = (await request.json()) as { stage?: unknown };
  } catch {
    return NextResponse.json({ error: "invalid_body" }, { status: 400 });
  }

  const stage =
    typeof body.stage === "string" &&
    (VALID_STAGES as readonly string[]).includes(body.stage)
      ? (body.stage as Stage)
      : null;

  if (!stage) {
    return NextResponse.json({ error: "invalid_stage" }, { status: 400 });
  }

  const supabase = createAdminClient();
  const { data, error } = await supabase
    .from("leads")
    .update({ stage, updated_at: new Date().toISOString() })
    .eq("id", id)
    .select("id, stage")
    .maybeSingle();

  if (error) {
    console.error("[admin/leads/stage] update failed:", error);
    return NextResponse.json({ error: "db_error" }, { status: 500 });
  }
  if (!data) {
    return NextResponse.json({ error: "lead_not_found" }, { status: 404 });
  }

  return NextResponse.json({ ok: true, stage: data.stage });
}
