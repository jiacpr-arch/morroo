import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { ipRateLimit, getRequestIp } from "@/lib/courses/ip-rate-limit";
import { processStudentQuestion } from "@/lib/courses/student-question/process";

// Public endpoint: student submits a question, the full AI pipeline
// (DeepSeek answer + classify + OpenAI image) runs synchronously, and the
// final status is returned. Ported from acls-emr's
// api/student-question/submit.js.

export const runtime = "nodejs";
export const maxDuration = 60;

const MIN_LEN = 5;
const MAX_LEN = 2000;
const MAX_NAME_LEN = 80;

export async function POST(req: NextRequest) {
  // Each submission runs a paid AI pipeline (DeepSeek + image gen) — keep it slow per IP.
  const rl = ipRateLimit(req, { key: "student-question", limit: 3, windowMs: 5 * 60_000 });
  if (!rl.ok) {
    return NextResponse.json(
      { error: "Too many requests — please try again later" },
      { status: 429, headers: { "Retry-After": String(rl.retryAfter) } },
    );
  }

  let body: Record<string, unknown>;
  try {
    body = await req.json();
  } catch {
    body = {};
  }

  const question = String(body.question || "").trim();
  const studentName = String(body.studentName || "").trim().slice(0, MAX_NAME_LEN) || null;
  const studentContact = String(body.studentContact || "").trim().slice(0, MAX_NAME_LEN) || null;

  if (question.length < MIN_LEN || question.length > MAX_LEN) {
    return NextResponse.json(
      { error: `คำถามต้องยาว ${MIN_LEN}-${MAX_LEN} ตัวอักษร` },
      { status: 400 },
    );
  }

  const supabase = createAdminClient();
  const requestIp = getRequestIp(req);

  // Insert pending row
  const { data: inserted, error: insErr } = await supabase
    .from("acls_student_questions")
    .insert({
      question,
      student_name: studentName,
      student_contact: studentContact,
      status: "pending",
      request_ip: requestIp === "unknown" ? null : requestIp,
    })
    .select("id")
    .single();
  if (insErr || !inserted) {
    console.error("insert student question failed:", insErr?.message);
    return NextResponse.json({ error: "บันทึกคำถามไม่สำเร็จ กรุณาลองใหม่อีกครั้ง" }, { status: 500 });
  }

  const id = (inserted as { id: string }).id;

  // Run the full pipeline synchronously (maxDuration = 60 above covers this).
  // If processing fails, mark the row 'failed' and surface a friendly error;
  // the question itself is preserved so an admin can retry/edit later.
  try {
    await processStudentQuestion(id);
  } catch (err) {
    await supabase
      .from("acls_student_questions")
      .update({
        status: "failed",
        error_message: String(err instanceof Error ? err.message : err).slice(0, 1000),
        updated_at: new Date().toISOString(),
      })
      .eq("id", id);
    return NextResponse.json(
      {
        id,
        status: "failed",
        message: "บันทึกคำถามแล้ว แต่ระบบสร้างคำตอบไม่สำเร็จ — admin จะตรวจสอบและตอบกลับให้",
      },
      { status: 202 },
    );
  }

  return NextResponse.json({
    id,
    status: "draft_ready",
    message: "ขอบคุณสำหรับคำถาม — ระบบสร้างคำตอบเรียบร้อย รอ admin ตรวจสอบก่อนเผยแพร่",
  });
}
