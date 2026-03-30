import { NextResponse } from "next/server";
import Anthropic from "@anthropic-ai/sdk";
import { createClient } from "@/lib/supabase/server";

export async function POST(request: Request) {
  try {
    // 1. Authenticate user via Supabase
    const supabase = await createClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json(
        { error: "กรุณาเข้าสู่ระบบก่อนใช้งาน AI ตรวจคำตอบ" },
        { status: 401 }
      );
    }

    // 2. Check membership — free users cannot use AI grading
    const { data: profile } = await supabase
      .from("users")
      .select("membership_type, membership_expires_at")
      .eq("id", user.id)
      .single();

    if (!profile || profile.membership_type === "free") {
      return NextResponse.json(
        { error: "ฟีเจอร์ AI ตรวจคำตอบสำหรับสมาชิก Premium เท่านั้น" },
        { status: 403 }
      );
    }

    // Check if membership has expired
    if (
      profile.membership_expires_at &&
      new Date(profile.membership_expires_at) < new Date()
    ) {
      return NextResponse.json(
        { error: "สมาชิกของคุณหมดอายุแล้ว กรุณาต่ออายุสมาชิก" },
        { status: 403 }
      );
    }

    // 3. Parse request body
    const body = await request.json();
    const { studentAnswer, correctAnswer, keyPoints, question } = body;

    if (!studentAnswer || !correctAnswer || !question) {
      return NextResponse.json(
        { error: "กรุณากรอกข้อมูลให้ครบถ้วน" },
        { status: 400 }
      );
    }

    // 4. Check API key
    const apiKey = process.env.ANTHROPIC_API_KEY;
    if (!apiKey) {
      console.error("ANTHROPIC_API_KEY is not configured");
      return NextResponse.json(
        { error: "ระบบ AI ยังไม่พร้อมใช้งาน กรุณาลองใหม่ภายหลัง" },
        { status: 500 }
      );
    }

    // 5. Call Claude Haiku
    const anthropic = new Anthropic({ apiKey });

    const keyPointsList = (keyPoints || [])
      .map((kp: string, i: number) => `${i + 1}. ${kp}`)
      .join("\n");

    const message = await anthropic.messages.create({
      model: "claude-haiku-4-5-20251001",
      max_tokens: 1024,
      messages: [
        {
          role: "user",
          content: `คุณเป็นอาจารย์แพทย์ผู้เชี่ยวชาญ กำลังตรวจคำตอบข้อสอบ MEQ (Modified Essay Question) ของนักศึกษาแพทย์

## โจทย์
${question}

## เฉลย (คำตอบที่ถูกต้อง)
${correctAnswer}

## Key Points ที่ควรตอบได้
${keyPointsList || "ไม่มี Key Points"}

## คำตอบของนักศึกษา
${studentAnswer}

---

กรุณาตรวจคำตอบและตอบกลับเป็น JSON ในรูปแบบนี้เท่านั้น (ห้ามมีข้อความอื่นนอก JSON):
{
  "score": <คะแนน 0-10>,
  "feedback": "<คำแนะนำสั้นๆ เป็นภาษาไทย 2-3 ประโยค ให้กำลังใจแต่ตรงไปตรงมา>",
  "matched_points": [<หมายเลข key points ที่นักศึกษาตอบได้ เช่น 1, 3, 5>]
}

เกณฑ์การให้คะแนน:
- 9-10: ตอบครบถ้วน ถูกต้อง ครอบคลุม key points เกือบทั้งหมด
- 7-8: ตอบได้ดี แต่ขาดบางประเด็นสำคัญ
- 5-6: ตอบได้พอสมควร แต่ยังขาดหลายประเด็น
- 3-4: ตอบได้บางส่วน มีข้อผิดพลาดที่สำคัญ
- 1-2: ตอบได้น้อยมาก หรือเข้าใจผิดในสาระสำคัญ
- 0: ไม่ได้ตอบ หรือคำตอบไม่เกี่ยวข้องกับคำถามเลย`,
        },
      ],
    });

    // 6. Parse Claude's response
    const responseText =
      message.content[0].type === "text" ? message.content[0].text : "";

    // Extract JSON from the response (handle potential markdown code blocks)
    const jsonMatch = responseText.match(/\{[\s\S]*\}/);
    if (!jsonMatch) {
      console.error("Failed to parse AI response:", responseText);
      return NextResponse.json(
        { error: "ไม่สามารถวิเคราะห์คำตอบจาก AI ได้ กรุณาลองใหม่" },
        { status: 500 }
      );
    }

    const result = JSON.parse(jsonMatch[0]);

    // Validate the response structure
    const score = Math.min(10, Math.max(0, Math.round(Number(result.score))));
    const feedback = String(result.feedback || "");
    const matchedPoints: number[] = Array.isArray(result.matched_points)
      ? result.matched_points.map(Number).filter((n: number) => !isNaN(n))
      : [];

    return NextResponse.json({
      score,
      feedback,
      matched_points: matchedPoints,
    });
  } catch (error) {
    console.error("AI grading error:", error);
    return NextResponse.json(
      { error: "เกิดข้อผิดพลาดในการตรวจคำตอบ กรุณาลองใหม่" },
      { status: 500 }
    );
  }
}
