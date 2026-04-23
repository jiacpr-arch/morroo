import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";

type DifficultyVote = "too_easy" | "just_right" | "too_hard";
const DIFFICULTY_VOTES: readonly DifficultyVote[] = [
  "too_easy",
  "just_right",
  "too_hard",
] as const;

// GET /api/longcase/feedback?sessionId=xxx
// Returns { submitted: boolean } so the UI knows whether to show the form
export async function GET(request: NextRequest) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const { searchParams } = new URL(request.url);
  const sessionId = searchParams.get("sessionId");
  if (!sessionId) {
    return NextResponse.json({ error: "Missing sessionId" }, { status: 400 });
  }

  const { data } = await supabase
    .from("long_case_feedback")
    .select("id")
    .eq("session_id", sessionId)
    .eq("user_id", user.id)
    .maybeSingle();

  return NextResponse.json({ submitted: !!data });
}

// POST /api/longcase/feedback
// Body: { sessionId, case_rating (1-5), difficulty_vote, examiner_fairness (1-5),
//         comment?, flag_issue? }
export async function POST(request: NextRequest) {
  let body: {
    sessionId?: string;
    case_rating?: number;
    difficulty_vote?: DifficultyVote;
    examiner_fairness?: number;
    comment?: string | null;
    flag_issue?: boolean;
  };
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON body" }, { status: 400 });
  }

  const {
    sessionId,
    case_rating,
    difficulty_vote,
    examiner_fairness,
    comment,
    flag_issue,
  } = body;

  if (!sessionId || typeof sessionId !== "string") {
    return NextResponse.json({ error: "sessionId is required" }, { status: 400 });
  }
  if (
    typeof case_rating !== "number" ||
    !Number.isInteger(case_rating) ||
    case_rating < 1 ||
    case_rating > 5
  ) {
    return NextResponse.json(
      { error: "case_rating must be an integer 1–5" },
      { status: 400 }
    );
  }
  if (!difficulty_vote || !DIFFICULTY_VOTES.includes(difficulty_vote)) {
    return NextResponse.json(
      { error: `difficulty_vote must be one of: ${DIFFICULTY_VOTES.join(", ")}` },
      { status: 400 }
    );
  }
  if (
    typeof examiner_fairness !== "number" ||
    !Number.isInteger(examiner_fairness) ||
    examiner_fairness < 1 ||
    examiner_fairness > 5
  ) {
    return NextResponse.json(
      { error: "examiner_fairness must be an integer 1–5" },
      { status: 400 }
    );
  }

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json(
      { error: "ต้องเข้าสู่ระบบก่อนจึงจะส่งความเห็นได้" },
      { status: 401 }
    );
  }

  // Verify the session belongs to this user and is completed
  const { data: session, error: sessionErr } = await supabase
    .from("long_case_sessions")
    .select("id, case_id, user_id, completed_at")
    .eq("id", sessionId)
    .single();

  if (sessionErr || !session || session.user_id !== user.id) {
    return NextResponse.json({ error: "Session not found" }, { status: 404 });
  }
  if (!session.completed_at) {
    return NextResponse.json(
      { error: "ต้องทำเคสให้จบก่อนจึงจะส่ง feedback ได้" },
      { status: 400 }
    );
  }

  // Admin client so the trigger can update profiles.meq_coins
  const admin = createAdminClient();

  const { error: insertErr } = await admin.from("long_case_feedback").insert({
    session_id: sessionId,
    case_id: session.case_id,
    user_id: user.id,
    case_rating,
    difficulty_vote,
    examiner_fairness,
    comment: (comment ?? "").trim() || null,
    flag_issue: !!flag_issue,
  });

  if (insertErr) {
    // UNIQUE(session_id) — duplicate submission
    if (insertErr.code === "23505") {
      return NextResponse.json(
        { error: "คุณส่ง feedback ของเคสนี้ไปแล้ว" },
        { status: 409 }
      );
    }
    console.error("[longcase/feedback] insert error:", insertErr);
    return NextResponse.json(
      { error: "บันทึก feedback ไม่สำเร็จ" },
      { status: 500 }
    );
  }

  // Fetch updated coin balance so the UI can animate "+10 coins"
  const { data: profile } = await admin
    .from("profiles")
    .select("meq_coins")
    .eq("id", user.id)
    .single();

  return NextResponse.json({
    success: true,
    coins_awarded: 10,
    meq_coins: profile?.meq_coins ?? null,
  });
}
