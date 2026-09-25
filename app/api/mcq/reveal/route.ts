import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { checkRateLimit, rateLimitResponse, RATE_LIMITS } from "@/lib/rate-limit";
import { isUuid } from "@/lib/school/ids";
import { isChoiceLabel, toAnswerKey, type McqRevealResponse } from "@/lib/mcq-public";
import { ACTIVE_MOCK_BLOCK_MESSAGE, isQuestionInActiveMock } from "@/lib/mcq-active-mock";
import type { McqQuestion } from "@/lib/types-mcq";

type RevealRow = Pick<
  McqQuestion,
  "id" | "choices" | "correct_answer" | "explanation" | "detailed_explanation"
>;

// POST /api/mcq/reveal
// Body: { questionId, selected }
//
// โหมดฝึก: browser ได้ข้อสอบที่ไม่มีเฉลย (mcq_questions ซ่อนคอลัมน์เฉลยจาก
// anon/authenticated) ตอบแล้วค่อยขอเฉลยข้อนั้นที่นี่ — ต้องล็อกอิน, จำกัดจำนวน
// ต่อชั่วโมง, เฉพาะข้อ active, และไม่ให้ข้อที่อยู่ในชุด Mock ที่ยังสอบไม่เสร็จ
export async function POST(request: NextRequest) {
  let body: { questionId?: unknown; selected?: unknown };
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON body" }, { status: 400 });
  }

  const { questionId, selected } = body ?? {};
  if (!isUuid(questionId) || !isChoiceLabel(selected)) {
    return NextResponse.json({ error: "ข้อมูลไม่ถูกต้อง" }, { status: 400 });
  }

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json({ error: "เข้าสู่ระบบเพื่อดูเฉลย" }, { status: 401 });
  }

  const rl = await checkRateLimit(supabase, user.id, "mcq:reveal", RATE_LIMITS.mcqReveal);
  const rlResp = rateLimitResponse(rl, RATE_LIMITS.mcqReveal);
  if (rlResp) return rlResp;

  const admin = createAdminClient();

  if (await isQuestionInActiveMock(admin, user.id, questionId)) {
    return NextResponse.json({ error: ACTIVE_MOCK_BLOCK_MESSAGE }, { status: 403 });
  }

  const { data, error } = await admin
    .from("mcq_questions")
    .select("id, choices, correct_answer, explanation, detailed_explanation")
    .eq("id", questionId)
    .eq("status", "active")
    .maybeSingle();
  if (error) {
    console.error("[mcq/reveal] question fetch failed:", error);
    return NextResponse.json({ error: "โหลดเฉลยไม่สำเร็จ ลองใหม่อีกครั้ง" }, { status: 500 });
  }
  const row = data as RevealRow | null;
  if (!row) {
    return NextResponse.json({ error: "ไม่พบข้อสอบนี้" }, { status: 404 });
  }
  if (!(row.choices ?? []).some((c) => c.label === selected)) {
    return NextResponse.json({ error: "ตัวเลือกไม่ถูกต้อง" }, { status: 400 });
  }

  const result: McqRevealResponse = {
    ...toAnswerKey(row),
    isCorrect: selected === row.correct_answer,
  };
  return NextResponse.json(result, { headers: { "Cache-Control": "no-store" } });
}
