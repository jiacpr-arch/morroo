import { NextRequest } from "next/server";
import Anthropic from "@anthropic-ai/sdk";
import { createClient } from "@/lib/supabase/server";
import { getLongCaseSession } from "@/lib/supabase/queries-longcase";

const MODEL = "claude-sonnet-4-6";

export async function POST(request: NextRequest) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return new Response(JSON.stringify({ error: "Unauthorized" }), { status: 401 });

  const { sessionId, type, input }: {
    sessionId: string;
    type: "ddx" | "management";
    input: string; // JSON string of student's entries
  } = await request.json();

  const session = await getLongCaseSession(sessionId);
  if (!session || session.user_id !== user.id) {
    return new Response(JSON.stringify({ error: "Session not found" }), { status: 404 });
  }

  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) return new Response(JSON.stringify({ error: "API key not configured" }), { status: 500 });

  const client = new Anthropic({ apiKey });
  const lc = session.long_case;
  const correctDiagnosis = lc.correct_diagnosis;
  const acceptedDdx = lc.accepted_ddx as string[];
  const managementPlan = lc.management_plan;

  let systemPrompt = "";

  if (type === "ddx") {
    systemPrompt = `คุณเป็นอาจารย์แพทย์ที่กำลังให้คำแนะนำนักศึกษาแพทย์

เคส: ${lc.title} (${lc.specialty})
การวินิจฉัยที่ถูกต้อง: ${correctDiagnosis}
DDx ที่ยอมรับ: ${acceptedDdx.join(", ")}

นักศึกษาส่ง DDx มาดังนี้:
${input}

ให้คำแนะนำสั้นๆ (1-2 ประโยค) โดย:
- ห้ามเฉลยคำตอบโดยตรง
- ถ้ามีข้อที่ถูกต้อง ให้บอกว่า "มีบางข้อที่ดี" โดยไม่ระบุว่าข้อไหน
- ถ้าขาดข้อสำคัญ ให้ใบ้ด้วยอาการหรือ finding ที่เกี่ยวข้อง
- ถ้าเรียงลำดับไม่ถูก ให้แนะนำให้ทบทวนลำดับ
- ตอบเป็นภาษาไทย`;
  } else {
    systemPrompt = `คุณเป็นอาจารย์แพทย์ที่กำลังให้คำแนะนำนักศึกษาแพทย์

เคส: ${lc.title} (${lc.specialty})
แผนการรักษาที่ถูกต้อง: ${managementPlan}

นักศึกษาเขียน order มาดังนี้:
${input}

ให้คำแนะนำสั้นๆ (1-2 ประโยค) สำหรับ order ล่าสุดที่เขียน:
- ห้ามเฉลยแผนการรักษาทั้งหมด
- ถ้า order ถูกต้อง ให้ชมและแนะนำว่ายังขาดอะไรอีกไหม (โดยไม่ระบุตรงๆ)
- ถ้า order ไม่เหมาะสม ให้แนะนำทางอ้อม เช่น "ลองพิจารณาเรื่อง..."
- ถ้าขนาดยาหรือวิธีบริหารยาไม่ถูก ให้แนะนำให้ทบทวน
- ตอบเป็นภาษาไทย`;
  }

  try {
    const response = await client.messages.create({
      model: MODEL,
      max_tokens: 256,
      system: systemPrompt,
      messages: [{ role: "user", content: "ให้คำแนะนำ" }],
    });

    const hint = response.content[0].type === "text" ? response.content[0].text : "";
    return new Response(JSON.stringify({ hint }), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    return new Response(JSON.stringify({ error: String(err) }), { status: 500 });
  }
}
