import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import {
  pickMeqSlot,
  isDuplicateMeqTitle,
  existingCasesPromptBlock,
} from "@/lib/meq-schedule.mjs";

// Auto-generate MEQ (Progressive Case) exams — 2 per week (Mon + Thu)
// Each exam has 6 parts with progressive scenario, using Sonnet for quality

interface GeneratedExam {
  title: string;
  category: string;
  difficulty: string;
  parts: Array<{
    part_number: number;
    title: string;
    scenario: string;
    question: string;
    answer: string;
    key_points: string[];
    time_minutes: number;
  }>;
}

export async function POST(request: Request) {
  const { searchParams } = new URL(request.url);
  const secret = searchParams.get("secret");
  if (secret !== process.env.BLOG_GENERATE_SECRET) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const anthropicApiKey = process.env.ANTHROPIC_API_KEY;
  if (!anthropicApiKey) {
    return NextResponse.json({ error: "ANTHROPIC_API_KEY not set" }, { status: 500 });
  }

  const supabase = await createClient();
  const now = new Date();

  const { category, difficulty } = pickMeqSlot(now);

  // Pass existing titles so the model avoids repeating cases (a bare count
  // wasn't enough), and reject exact/near-duplicate titles below.
  const { data: existingRows } = await supabase
    .from("exams")
    .select("title")
    .eq("category", category)
    .order("created_at", { ascending: false })
    .limit(300);
  const existingTitles: string[] = (existingRows ?? [])
    .map((r: { title: string | null }) => r.title ?? "")
    .filter(Boolean);

  const prompt = `คุณเป็นอาจารย์แพทย์ผู้เชี่ยวชาญสาขา ${category} สร้างข้อสอบ MEQ แบบ Progressive Case สำหรับสอบใบประกอบวิชาชีพ (NL Step 2)

สร้าง 1 ข้อสอบ MEQ ที่มี 6 ตอน (parts) ต่อเนื่องกัน โดยแต่ละตอนเพิ่มข้อมูลใหม่เข้ามาเรื่อยๆ

กฎ:
1. สาขา: ${category}
2. ความยาก: ${difficulty === "easy" ? "ง่าย" : difficulty === "hard" ? "ยาก" : "ปานกลาง"}
3. เรื่องต้องไม่ซ้ำกับเคสที่มีอยู่แล้ว (ดูรายการด้านล่าง)
4. ตอนที่ 1: ประวัติเบื้องต้น + vital signs → ถาม initial assessment
5. ตอนที่ 2: ผล lab/investigation → ถาม interpretation
6. ตอนที่ 3: เพิ่ม clinical progression → ถาม differential diagnosis
7. ตอนที่ 4: ผล imaging/special test → ถาม definitive diagnosis
8. ตอนที่ 5: ถาม management plan
9. ตอนที่ 6: complication หรือ follow-up → ถาม long-term management
10. แต่ละตอนต้องมี: scenario (สถานการณ์), question (คำถาม), answer (เฉลย), key_points (3-5 จุดสำคัญ)
11. เฉลยต้องละเอียด evidence-based
12. ภาษาไทย (medical term ภาษาอังกฤษได้)
13. ห้ามเฉลยการวินิจฉัยในชื่อข้อสอบ (title) เด็ดขาด — ตั้งชื่อจากอาการนำ/สถานการณ์ผู้ป่วยเท่านั้น ห้ามมีชื่อโรค คำวินิจฉัย หรือตัวย่อโรคปรากฏในชื่อ
${existingCasesPromptBlock(existingTitles)}
ตอบเป็น JSON เท่านั้น:
{
  "title": "ชื่อ case จากอาการนำ ห้ามเฉลยโรค เช่น 'ชาย 55 ปี อาเจียนเป็นเลือด'",
  "parts": [
    {
      "part_number": 1,
      "title": "ตอนที่ 1: ...",
      "scenario": "สถานการณ์...",
      "question": "คำถาม...",
      "answer": "เฉลยละเอียด...",
      "key_points": ["จุดสำคัญ 1", "จุดสำคัญ 2", "จุดสำคัญ 3"],
      "time_minutes": 10
    }
  ]
}`;

  const claudeRes = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "x-api-key": anthropicApiKey,
      "anthropic-version": "2023-06-01",
      "content-type": "application/json",
    },
    body: JSON.stringify({
      model: "claude-sonnet-5",
      max_tokens: 8000,
      messages: [{ role: "user", content: prompt }],
    }),
  });

  if (!claudeRes.ok) {
    const err = await claudeRes.text();
    return NextResponse.json({ error: "Claude API error", details: err }, { status: 500 });
  }

  const claudeData = await claudeRes.json();
  const rawContent: string = claudeData.content?.[0]?.text ?? "";
  if (!rawContent) {
    return NextResponse.json({ error: "Empty response" }, { status: 500 });
  }

  // Parse JSON
  let exam: GeneratedExam;
  try {
    let cleaned = rawContent.trim();
    if (cleaned.startsWith("```")) {
      cleaned = cleaned.replace(/^```\w*\n?/, "").replace(/\n?```$/, "");
    }
    exam = JSON.parse(cleaned);
  } catch {
    const match = rawContent.match(/\{[\s\S]*\}/);
    if (match) {
      try { exam = JSON.parse(match[0]); } catch {
        return NextResponse.json({ error: "Failed to parse JSON" }, { status: 500 });
      }
    } else {
      return NextResponse.json({ error: "No JSON in response" }, { status: 500 });
    }
  }

  if (!exam.title || !Array.isArray(exam.parts) || exam.parts.length < 4) {
    return NextResponse.json({ error: "Invalid exam structure" }, { status: 500 });
  }

  if (isDuplicateMeqTitle(exam.title, existingTitles)) {
    return NextResponse.json(
      { error: "Duplicate case generated", title: exam.title },
      { status: 409 }
    );
  }

  // Set publish_date to next available slot (today or future)
  const publishDate = now.toISOString().split("T")[0];

  // Insert exam
  const { data: examRow, error: examError } = await supabase
    .from("exams")
    .insert({
      title: exam.title,
      category,
      difficulty,
      status: "published",
      is_free: false,
      publish_date: publishDate,
      created_by: "ai-auto",
    })
    .select("id")
    .single();

  if (examError || !examRow) {
    return NextResponse.json({ error: examError?.message ?? "Insert failed" }, { status: 500 });
  }

  // Insert parts
  const parts = exam.parts.map((p) => ({
    exam_id: examRow.id,
    part_number: p.part_number,
    title: p.title,
    scenario: p.scenario,
    question: p.question,
    answer: p.answer,
    key_points: p.key_points || [],
    time_minutes: p.time_minutes || 10,
  }));

  const { error: partsError } = await supabase.from("exam_parts").insert(parts);

  if (partsError) {
    return NextResponse.json({ error: partsError.message }, { status: 500 });
  }

  return NextResponse.json({
    success: true,
    exam: {
      id: examRow.id,
      title: exam.title,
      category,
      difficulty,
      parts_count: parts.length,
    },
  });
}
