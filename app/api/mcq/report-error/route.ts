import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { checkRateLimit, rateLimitResponse, RATE_LIMITS } from "@/lib/rate-limit";

// Accepted reasons — must stay in sync with the CHECK constraint on
// public.mcq_question_reports.reason (see migration
// 20260415_mcq_question_reports.sql).
const REASONS = [
  "wrong_answer",
  "unclear_question",
  "typo",
  "outdated",
  "duplicate",
  "other",
] as const;
type Reason = (typeof REASONS)[number];

// POST /api/mcq/report-error
// Body: { question_id, reason, note?, suggested_answer? }
export async function POST(request: NextRequest) {
  let body: {
    question_id?: string;
    reason?: Reason;
    note?: string | null;
    suggested_answer?: string | null;
  };
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON body" }, { status: 400 });
  }

  const { question_id, reason, note, suggested_answer } = body;

  if (!question_id || typeof question_id !== "string") {
    return NextResponse.json({ error: "question_id is required" }, { status: 400 });
  }
  if (!reason || !REASONS.includes(reason)) {
    return NextResponse.json(
      { error: `reason must be one of: ${REASONS.join(", ")}` },
      { status: 400 }
    );
  }
  if (suggested_answer && !/^[A-E]$/.test(suggested_answer)) {
    return NextResponse.json(
      { error: "suggested_answer must be a single letter A-E" },
      { status: 400 }
    );
  }

  // Require an authenticated user so we can award points
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json(
      { error: "ต้องเข้าสู่ระบบก่อนจึงจะแจ้งเฉลยผิดได้" },
      { status: 401 }
    );
  }

  const rl = await checkRateLimit(supabase, user.id, "mcq:report-error", RATE_LIMITS.reportError);
  const rlResp = rateLimitResponse(rl, RATE_LIMITS.reportError);
  if (rlResp) return rlResp;

  // Use the admin client to bypass RLS and let the trigger update profile points.
  const admin = createAdminClient();

  const { error } = await admin.from("mcq_question_reports").insert({
    question_id,
    user_id: user.id,
    reason,
    note: (note ?? "").trim() || null,
    suggested_answer: suggested_answer || null,
  });

  if (error) {
    // Duplicate (same user + question + reason) -> unique_violation 23505
    if (error.code === "23505") {
      return NextResponse.json(
        { error: "คุณเคยแจ้งข้อนี้ด้วยเหตุผลนี้แล้ว" },
        { status: 409 }
      );
    }
    console.error("[mcq/report-error] insert error:", error);
    return NextResponse.json({ error: "บันทึกรายงานไม่สำเร็จ" }, { status: 500 });
  }

  // Fetch the user's updated total so the UI can show "+1 point"
  const { data: profile } = await admin
    .from("profiles")
    .select("reporter_points")
    .eq("id", user.id)
    .single();

  return NextResponse.json({
    success: true,
    points_awarded: 1,
    reporter_points: profile?.reporter_points ?? null,
  });
}
