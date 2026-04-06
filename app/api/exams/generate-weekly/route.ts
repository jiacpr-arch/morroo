import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// Auto-generate MEQ (Progressive Case) exams — 2 per week (Mon + Thu)
// Each exam has 6 parts with progressive scenario, using Sonnet for quality

const CATEGORIES = [
  "อายุรศาสตร์",
  "ศัลยศาสตร์",
  "กุมารเวชศาสตร์",
  "สูติศาสตร์-นรีเวชวิทยา",
  "ออร์โธปิดิกส์",
  "จิตเวชศาสตร์",
];

const DIFFICULTIES: Array<"easy" | "medium" | "hard"> = ["easy", "medium", "hard"];

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

  // Rotate category based on week number
  const weekOfYear = Math.floor(
    (now.getTime() - new Date(now.getFullYear(), 0, 1).getTime()) / (7 * 24 * 60 * 60 * 1000)
  );
  const dayOfWeek = now.getUTCDay(); // 0=Sun, 1=Mon, 4=Thu
  const categoryIndex = (weekOfYear * 2 + (dayOfWeek >= 4 ? 1 : 0)) % CATEGORIES.length;
  const category = CATEGORIES[categoryIndex];
  const difficulty = DIFFICULTIES[(weekOfYear + (dayOfWeek >= 4 ? 1 : 0)) % 3];

  // Count existing exams to avoid duplicate topics
  const { count: existingCount } = await supabase
    .from("exams")
    .select("id", { count: "exact", head: true })
    .eq("category", category);

  const prompt = `คุณเป็นอาจารย์แพทย์ผู้เชี่ยวชาญสาขา ${category} สร้างข้อสอบ MEQ แบบ Progressive Case สำหรับสอบใบประกอบวิชาชีพ (NL Step 2)

สร้าง 1 ข้อสอบ MEQ ที่มี 6 ตอน (parts) ต่อเนื่องกัน โดยแต่ละตอนเพิ่มข้อมูลใหม่เข้ามาเรื่อยๆ

กฎ:
1. สาขา: ${category}
2. ความยาก: ${difficulty === "easy" ? "ง่าย" : difficulty === "hard" ? "ยาก" : "ปานกลาง"}
3. เรื่องต้องไม่ซ้ำกับที่มี (มี ${existingCount ?? 0} ข้อในสาขานี้แล้ว)
4. ตอนที่ 1: ประวัติเบื้องต้น + vital signs → ถาม initial assessment
5. ตอนที่ 2: ผล lab/investigation → ถาม interpretation
6. ตอนที่ 3: เพิ่ม clinical progression → ถาม differential diagnosis
7. ตอนที่ 4: ผล imaging/special test → ถาม definitive diagnosis
8. ตอนที่ 5: ถาม management plan
9. ตอนที่ 6: complication หรือ follow-up → ถาม long-term management
10. แต่ละตอนต้องมี: scenario (สถานการณ์), question (คำถาม), answer (เฉลย), key_points (3-5 จุดสำคัญ)
11. เฉลยต้องละเอียด evidence-based
12. ภาษาไทย (medical term ภาษาอังกฤษได้)

ตอบเป็น JSON เท่านั้น:
{
  "title": "ชื่อ case เช่น 'ชาย 55 ปี อาเจียนเป็นเลือด'",
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
      model: "claude-sonnet-4-6-20250514",
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
