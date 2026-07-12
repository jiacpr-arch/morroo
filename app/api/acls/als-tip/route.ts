import { NextRequest, NextResponse } from "next/server";
import { createAnthropic } from "@/lib/anthropic";
import { ipRateLimit } from "@/lib/courses/ip-rate-limit";

// Tiny AI tip generator (Claude haiku) shown as a loading-screen distraction
// / knowledge nugget. Ported from acls-emr's api/als-tip.js. Deliberately
// avoids the word "ACLS" in the prompt — says "ALS" instead, per the source.

export const runtime = "nodejs";

export async function POST(req: NextRequest) {
  const rl = ipRateLimit(req, { key: "acls-als-tip", limit: 5, windowMs: 60_000 });
  if (!rl.ok) {
    return NextResponse.json(
      { error: "Too many requests — please try again later" },
      { status: 429, headers: { "Retry-After": String(rl.retryAfter) } },
    );
  }

  if (!process.env.ANTHROPIC_API_KEY) {
    return NextResponse.json({ error: "API key not configured" }, { status: 500 });
  }

  let body: { topic?: string };
  try {
    body = await req.json();
  } catch {
    body = {};
  }

  const topic = body?.topic;
  const prompt = topic
    ? `ให้เกร็ดความรู้เกี่ยวกับ ALS (Advanced Life Support) ในหัวข้อ "${topic}" สำหรับบุคลากรทางการแพทย์ เขียนเป็นภาษาไทย กระชับ 3-5 ข้อ แต่ละข้อ 1-2 ประโยค ห้ามใช้คำว่า ACLS ให้ใช้ ALS แทน`
    : `ให้เกร็ดความรู้ ALS (Advanced Life Support) และห้องฉุกเฉิน 1 เรื่อง สำหรับบุคลากรทางการแพทย์ เขียนเป็นภาษาไทย กระชับ 3-5 ข้อ แต่ละข้อ 1-2 ประโยค ห้ามใช้คำว่า ACLS ให้ใช้ ALS แทน เลือกหัวข้อแบบสุ่ม`;

  try {
    const client = createAnthropic();
    const response = await client.messages.create({
      model: "claude-haiku-4-5",
      max_tokens: 1024,
      messages: [{ role: "user", content: prompt }],
    });

    const text = response.content
      .filter((b) => b.type === "text")
      .map((b) => (b as { type: "text"; text: string }).text)
      .join("");

    return NextResponse.json({ tip: text });
  } catch (err) {
    return NextResponse.json(
      { error: err instanceof Error ? err.message : String(err) },
      { status: 500 },
    );
  }
}
