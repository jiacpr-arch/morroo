import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";

// Persists an ACLS pre/post-test attempt. Replaces the old app's direct
// anon insert into acls_assessment_attempts (that RLS hole is closed in
// morroo — this route validates and writes with the service role).

interface AttemptBody {
  setId?: string;
  score?: number;
  totalQuestions?: number;
  correctCount?: number;
  passed?: boolean;
  durationSeconds?: number | null;
  answers?: unknown;
  startedAt?: string | null;
  finishedAt?: string | null;
  studentLocalId?: string | null;
  studentCode?: string | null;
  studentName?: string | null;
  studentPhone?: string | null;
  studentEmail?: string | null;
}

const MAX_TEXT = 200;

function clampText(v: unknown): string | null {
  if (typeof v !== "string") return null;
  const t = v.trim();
  return t ? t.slice(0, MAX_TEXT) : null;
}

export async function POST(req: NextRequest) {
  let body: AttemptBody;
  try {
    body = await req.json();
  } catch {
    return NextResponse.json({ error: "invalid_json" }, { status: 400 });
  }

  const setId = typeof body.setId === "string" ? body.setId.slice(0, 100) : "";
  const score = Number(body.score);
  const totalQuestions = Number(body.totalQuestions);
  const correctCount = Number(body.correctCount);
  if (
    !setId ||
    !Number.isFinite(score) ||
    !Number.isInteger(totalQuestions) ||
    !Number.isInteger(correctCount) ||
    totalQuestions <= 0 ||
    totalQuestions > 500 ||
    correctCount < 0 ||
    correctCount > totalQuestions ||
    score < 0 ||
    score > 100
  ) {
    return NextResponse.json({ error: "invalid_payload" }, { status: 400 });
  }
  const answers = Array.isArray(body.answers) ? body.answers.slice(0, 500) : [];

  const supabase = createAdminClient();

  // Derive bank_id from the set — the client never supplies it.
  const { data: set, error: setErr } = await supabase
    .from("acls_assessment_sets")
    .select("id, bank_id")
    .eq("id", setId)
    .single();
  if (setErr || !set) {
    return NextResponse.json({ error: "unknown_set" }, { status: 400 });
  }

  const { data, error } = await supabase
    .from("acls_assessment_attempts")
    .insert({
      student_local_id: clampText(body.studentLocalId),
      student_code: clampText(body.studentCode),
      student_name: clampText(body.studentName),
      student_phone: clampText(body.studentPhone),
      student_email: clampText(body.studentEmail),
      bank_id: set.bank_id,
      set_id: set.id,
      score: Math.round(score),
      total_questions: totalQuestions,
      correct_count: correctCount,
      passed: !!body.passed,
      duration_seconds: Number.isInteger(body.durationSeconds)
        ? body.durationSeconds
        : null,
      answers,
      started_at: body.startedAt ?? null,
      finished_at: body.finishedAt ?? new Date().toISOString(),
    })
    .select("id")
    .single();

  if (error) {
    console.error("[acls/attempts] insert failed:", error.message);
    return NextResponse.json({ error: "insert_failed" }, { status: 500 });
  }
  return NextResponse.json({ id: data.id });
}
