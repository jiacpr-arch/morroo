import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";

export const runtime = "nodejs";

async function broadcast(message: string): Promise<{ ok: boolean; error?: string }> {
  const token = process.env.LINE_CHANNEL_ACCESS_TOKEN;
  if (!token) return { ok: false, error: "LINE_CHANNEL_ACCESS_TOKEN not set" };

  const res = await fetch("https://api.line.me/v2/bot/message/broadcast", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify({ messages: [{ type: "text", text: message }] }),
  });

  if (!res.ok) {
    const err = await res.text();
    return { ok: false, error: err };
  }
  return { ok: true };
}

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

  const message = [
    `📚 ข้อสอบ MCQ ประจำวัน`,
    ``,
    `${q.subject_icon ?? "🩺"} ${q.subject_name_th ?? ""}  |  ระดับ: ${diff}`,
    ``,
    `${preview}${q.scenario?.length > 120 ? "..." : ""}`,
    ``,
    `👉 ทำข้อนี้เลย`,
    `https://www.morroo.com/nl/practice`,
    ``,
    `─────────────────`,
    `หมอรู้ — เตรียมสอบแพทย์ด้วย AI`,
  ].join("\n");

  const result = await broadcast(message);

  return NextResponse.json({ ok: result.ok, error: result.error });
}
