import { NextRequest, NextResponse } from "next/server";
import Anthropic from "@anthropic-ai/sdk";
import { createClient } from "@/lib/supabase/server";
import { checkRateLimit, rateLimitResponse, RATE_LIMITS } from "@/lib/rate-limit";
import type { StudyPlan } from "@/lib/types-study-plan";

export const runtime = "nodejs";
export const maxDuration = 60;

const MODEL = "claude-sonnet-4-6";

// POST /api/study-plan/generate
// Body: { daily_hours?: number (1..8), exam_date?: string (YYYY-MM-DD) }
// Generates a personalised week-by-week study plan with Claude, saves it
// onto the profile, and returns it. Rate-limited via aiChat bucket.
export async function POST(request: NextRequest) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const rl = await checkRateLimit(supabase, user.id, "study-plan:generate", RATE_LIMITS.aiChat);
  const rlResp = rateLimitResponse(rl, RATE_LIMITS.aiChat);
  if (rlResp) return rlResp;

  let body: { daily_hours?: number; exam_date?: string };
  try {
    body = await request.json();
  } catch {
    body = {};
  }

  const dailyHours = Math.min(Math.max(Math.round(body.daily_hours ?? 2), 1), 8);

  // Pull profile + persist exam_date if the client is updating it in the same call.
  const update: { exam_date?: string } = {};
  if (body.exam_date && /^\d{4}-\d{2}-\d{2}$/.test(body.exam_date)) {
    update.exam_date = body.exam_date;
  }
  if (update.exam_date) {
    await supabase.from("profiles").update(update).eq("id", user.id);
  }

  const { data: profile } = await supabase
    .from("profiles")
    .select("name, exam_date, target_exam, weak_subjects")
    .eq("id", user.id)
    .single();

  const p = profile as {
    name: string | null;
    exam_date: string | null;
    target_exam: string | null;
    weak_subjects: string[] | null;
  } | null;

  if (!p?.exam_date) {
    return NextResponse.json(
      { error: "exam_date required — ตั้งวันสอบก่อนสร้างแผน" },
      { status: 400 }
    );
  }

  const examDate = new Date(p.exam_date);
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const daysUntil = Math.ceil((examDate.getTime() - today.getTime()) / 86400000);

  if (daysUntil <= 0) {
    return NextResponse.json(
      { error: "วันสอบผ่านมาแล้ว — อัปเดตวันสอบก่อน" },
      { status: 400 }
    );
  }

  const weeksCount = Math.min(Math.max(Math.ceil(daysUntil / 7), 1), 16);

  // Pull recent per-subject accuracy to ground the plan.
  const { data: stats } = await supabase.rpc("get_user_subject_stats", { p_user_id: user.id });
  const subjectStats = (stats as Array<{
    subject_name_th: string;
    accuracy: number;
    total_attempts: number;
  }> | null) ?? [];

  const weakFromHistory = subjectStats
    .filter((s) => s.total_attempts >= 3 && s.accuracy < 60)
    .map((s) => `${s.subject_name_th} (${s.accuracy}%)`);

  const topSubjects = subjectStats
    .slice()
    .sort((a, b) => b.accuracy - a.accuracy)
    .slice(0, 3)
    .map((s) => `${s.subject_name_th} (${s.accuracy}%)`);

  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) {
    return NextResponse.json({ error: "API key not configured" }, { status: 500 });
  }

  const systemPrompt = `คุณเป็นที่ปรึกษาการเตรียมสอบแพทย์ (NL1/NL2) วางแผนอ่านรายสัปดาห์ให้นักศึกษา
ตอบเป็น JSON เท่านั้น ห้ามมีข้อความอื่นใดนอกเหนือจาก JSON
ภาษาทุกข้อความใน JSON ต้องเป็นภาษาไทยที่กระชับและใช้งานได้จริง`;

  const userPrompt = `ข้อมูลนักศึกษา:
- ชื่อ: ${p.name ?? "ไม่ระบุ"}
- สอบ: ${p.target_exam ?? "NL2"}
- วันสอบ: ${p.exam_date} (อีก ${daysUntil} วัน, ${weeksCount} สัปดาห์)
- เวลาอ่านหนังสือที่ทำได้ต่อวัน: ${dailyHours} ชั่วโมง
- สาขาที่เคยระบุว่าไม่มั่นใจ: ${(p.weak_subjects ?? []).join(", ") || "-"}
- สาขาที่คะแนนต่ำจากข้อสอบ (<60%): ${weakFromHistory.join(", ") || "-"}
- สาขาที่คะแนนสูง: ${topSubjects.join(", ") || "-"}

สร้างแผนอ่านหนังสือเป็น JSON ในรูปแบบนี้ (เป็น object เดียว ไม่ต้องห่อ markdown):
{
  "generated_at": "<ISO timestamp>",
  "exam_date": "${p.exam_date}",
  "daily_hours": ${dailyHours},
  "weeks": [
    {
      "week_number": 1,
      "start_date": "<ISO date ของวันจันทร์สัปดาห์นั้น>",
      "focus": "หัวข้อหลักของสัปดาห์",
      "daily_tasks": [
        { "day": "จันทร์", "tasks": ["ภารกิจ 1", "ภารกิจ 2"] },
        { "day": "อังคาร", "tasks": [...] },
        { "day": "พุธ", "tasks": [...] },
        { "day": "พฤหัส", "tasks": [...] },
        { "day": "ศุกร์", "tasks": [...] },
        { "day": "เสาร์", "tasks": [...] },
        { "day": "อาทิตย์", "tasks": [...] }
      ]
    }
  ],
  "advice": "คำแนะนำภาพรวม 2-3 ประโยค"
}

กฎการสร้างแผน:
- สร้าง ${weeksCount} สัปดาห์พอดี
- เน้นสาขาที่อ่อนในสัปดาห์ต้นๆ ทบทวนรวมใน 2 สัปดาห์สุดท้าย
- สัปดาห์สุดท้ายทำ mock exam + review
- ภารกิจแต่ละวันรวมเวลา ~${dailyHours} ชั่วโมง (แยกเป็น 2-3 ภารกิจ)
- ภารกิจต้อง concrete เช่น "ทำ MCQ สาขาหัวใจ 30 ข้อ", "อ่านสรุป HTN + ทำ MCQ 15 ข้อ"`;

  const client = new Anthropic({ apiKey });
  const response = await client.messages.create({
    model: MODEL,
    max_tokens: 4000,
    system: systemPrompt,
    messages: [{ role: "user", content: userPrompt }],
  });

  const raw = response.content[0].type === "text" ? response.content[0].text : "";
  const match = raw.match(/\{[\s\S]*\}/);
  if (!match) {
    return NextResponse.json({ error: "Failed to parse plan", raw }, { status: 500 });
  }

  let plan: StudyPlan;
  try {
    plan = JSON.parse(match[0]) as StudyPlan;
  } catch {
    return NextResponse.json({ error: "Invalid JSON from Claude", raw }, { status: 500 });
  }

  const now = new Date().toISOString();
  plan.generated_at = now;

  await supabase
    .from("profiles")
    .update({ study_plan: plan, study_plan_generated_at: now })
    .eq("id", user.id);

  return NextResponse.json({ plan });
}
