import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { broadcastLineMessages } from "@/lib/line";

export const runtime = "nodejs";

export async function POST(request: Request) {
  const { searchParams } = new URL(request.url);
  if (searchParams.get("secret") !== process.env.BLOG_GENERATE_SECRET) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const supabase = createAdminClient();

  // Get today's daily question via RPC
  const { data: questions, error } = await supabase.rpc("get_daily_mcq");

  if (error || !questions || questions.length === 0) {
    return NextResponse.json({ error: "No daily question available", detail: error }, { status: 500 });
  }

  const q = questions[0];
  const preview = q.scenario?.slice(0, 120) ?? "";
  const diffMap: Record<string, string> = { easy: "ง่าย", medium: "ปานกลาง", hard: "ยาก" };
  const diff = diffMap[q.difficulty] ?? q.difficulty;

  // Count new questions added in last 24 hours
  const { count: newCount } = await supabase
    .from("mcq_questions")
    .select("id", { count: "exact", head: true })
    .gte("created_at", new Date(Date.now() - 86400_000).toISOString())
    .eq("status", "active");

  const newLine = newCount && newCount > 0
    ? `\n🆕 เพิ่มข้อสอบใหม่ ${newCount} ข้อวันนี้!\n`
    : "";

  const message = [
    `📚 ข้อสอบ MCQ ประจำวัน`,
    ``,
    `${q.subject_icon ?? "🩺"} ${q.subject_name_th ?? ""}  |  ระดับ: ${diff}`,
    ``,
    `${preview}${q.scenario?.length > 120 ? "..." : ""}`,
    `${newLine}`,
    `👉 ทำข้อนี้เลย`,
    `https://www.morroo.com/nl/practice`,
    ``,
    `─────────────────`,
    `หมอรู้ — เตรียมสอบแพทย์ด้วย AI`,
  ].join("\n");

  const result = await broadcastLineMessages([{ type: "text", text: message }]);

  return NextResponse.json({ ok: result.ok, error: result.error });
}
