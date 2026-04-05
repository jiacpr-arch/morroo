import { NextResponse } from "next/server";
import Anthropic from "@anthropic-ai/sdk";
import { createClient } from "@/lib/supabase/server";

export async function POST(request: Request) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    // ไม่ได้ login
    if (!user) {
      return NextResponse.json(
        { error: "not_logged_in" },
        { status: 401 }
      );
    }

    // เช็ค membership
    const { data: profile } = await supabase
      .from("profiles")
      .select("membership_type, membership_expires_at")
      .eq("id", user.id)
      .single();

    const isPremium =
      profile &&
      profile.membership_type !== "free" &&
      (!profile.membership_expires_at ||
        new Date(profile.membership_expires_at) > new Date());

    if (!isPremium) {
      return NextResponse.json(
        { error: "not_premium" },
        { status: 403 }
      );
    }

    const { question, userMessage, chatHistory } = await request.json();

    if (!userMessage?.trim()) {
      return NextResponse.json({ error: "no_message" }, { status: 400 });
    }

    const apiKey = process.env.ANTHROPIC_API_KEY;
    if (!apiKey) {
      return NextResponse.json({ error: "ai_unavailable" }, { status: 500 });
    }

    const anthropic = new Anthropic({ apiKey });

    // Build message history for multi-turn
    const messages: { role: "user" | "assistant"; content: string }[] = [
      ...(chatHistory || []),
      { role: "user", content: userMessage },
    ];

    const response = await anthropic.messages.create({
      model: "claude-haiku-4-5-20251001",
      max_tokens: 512,
      system: `คุณคืออาจารย์แพทย์ที่ช่วยสอน MCQ (ข้อสอบใบประกอบวิชาชีพเวชกรรม NL)

โจทย์ที่นักเรียนกำลังเรียนอยู่:
${question?.scenario || ""}

ตัวเลือก:
${(question?.choices || []).map((c: { label: string; text: string }) => `${c.label}. ${c.text}`).join("\n")}

คำตอบที่ถูกต้อง: ${question?.correct_answer || ""}

กฎ:
- ตอบภาษาไทยเสมอ กระชับ ตรงประเด็น
- อธิบายเหตุผลทางการแพทย์ที่ถูกต้อง
- ถ้าถามนอกเรื่องข้อสอบ ให้ดึงกลับมาที่โจทย์
- ห้ามบอกคำตอบตรงๆ ถ้ายังไม่ได้ตอบ — ให้ hint แทน`,
      messages,
    });

    const reply =
      response.content[0].type === "text" ? response.content[0].text : "";

    return NextResponse.json({ reply });
  } catch (error) {
    console.error("MCQ chat error:", error);
    return NextResponse.json({ error: "server_error" }, { status: 500 });
  }
}
