import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

// Statuses an admin may set. Transitioning to 'confirmed' fires the DB trigger
// (award_reporter_points) that grants the reporter +10 points.
const ALLOWED_STATUS = ["pending", "confirmed", "rejected", "duplicate"] as const;
type ReportStatus = (typeof ALLOWED_STATUS)[number];

/**
 * PATCH /api/admin/mcq/reports/[id]
 * Body: { status: "confirmed" | "rejected" | "duplicate" | "pending" }
 *
 * Updates an MCQ report's review status. Confirming awards the reporter the
 * +10 Bug Hunter bonus via the trigger on mcq_question_reports.
 */
export async function PATCH(
  request: Request,
  { params }: { params: Promise<{ id: string }> }
) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const { id } = await params;

  let body: { status?: string };
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON body" }, { status: 400 });
  }

  const status = body.status as ReportStatus;
  if (!ALLOWED_STATUS.includes(status)) {
    return NextResponse.json(
      { error: `status must be one of: ${ALLOWED_STATUS.join(", ")}` },
      { status: 400 }
    );
  }

  const admin = createAdminClient();
  const { data, error } = await admin
    .from("mcq_question_reports")
    .update({ status, reviewed_by: guard.userId })
    .eq("id", id)
    .select("id, status, points_awarded, user_id")
    .maybeSingle();

  if (error) {
    console.error("[admin/mcq/reports] update error:", error);
    return NextResponse.json({ error: "อัปเดตไม่สำเร็จ" }, { status: 500 });
  }
  if (!data) {
    return NextResponse.json({ error: "ไม่พบรายงานนี้" }, { status: 404 });
  }

  return NextResponse.json({ ok: true, report: data });
}
