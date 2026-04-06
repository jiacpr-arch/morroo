import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// Auto-generate Long Case exam — 1 per week (Sunday)
// Uses Sonnet for complex patient scripts with full clinical detail

const SPECIALTIES = [
  "Medicine", "Surgery", "Pediatrics", "Obstetrics",
  "Orthopedics", "Psychiatry", "Emergency", "Cardiology",
];

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

  // Rotate specialty weekly
  const weekOfYear = Math.floor(
    (now.getTime() - new Date(now.getFullYear(), 0, 1).getTime()) / (7 * 24 * 60 * 60 * 1000)
  );
  const specialty = SPECIALTIES[weekOfYear % SPECIALTIES.length];

  // Get existing count
  const { count: existingCount } = await supabase
    .from("long_cases")
    .select("id", { count: "exact", head: true })
    .eq("specialty", specialty);

  const prompt = `คุณเป็นอาจารย์แพทย์ผู้เชี่ยวชาญสาขา ${specialty} สร้าง Long Case Exam สำหรับสอบใบประกอบวิชาชีพ

สร้าง 1 Long Case ที่จำลองผู้ป่วยจริง ให้นักศึกษาฝึก:
- ซักประวัติ (AI Patient)
- ตรวจร่างกาย (เลือก system)
- สั่ง Lab/Imaging
- วินิจฉัยแยกโรค
- วางแผนการรักษา
- ตอบคำถาม Examiner

กฎ:
1. สาขา: ${specialty}
2. ความยาก: medium หรือ hard
3. ห้ามซ้ำกับที่มี (มี ${existingCount ?? 0} cases แล้ว)
4. ต้องสมจริง มีรายละเอียดทางคลินิกครบถ้วน
5. patient_info: ข้อมูลที่เห็นก่อนเริ่ม (อายุ เพศ สถานที่ ไม่บอก chief complaint)
6. history_script: ประวัติทั้งหมดที่ AI Patient จะตอบ (chief complaint, HPI, PMH, medications, family, social, review of systems)
7. pe_findings: ผลตรวจร่างกายแยกตาม system
8. lab_results: ผล lab ทั้ง normal และ abnormal
9. ภาษาไทย (medical terms อังกฤษได้)

ตอบเป็น JSON เท่านั้น:
{
  "title": "ชื่อ case เช่น 'ชาย 45 ปี แน่นหน้าอก'",
  "difficulty": "medium|hard",
  "patient_info": {
    "age": 45,
    "gender": "male",
    "setting": "ห้องฉุกเฉิน",
    "appearance": "ชายวัยกลางคน ลักษณะเหนื่อย เหงื่อออก"
  },
  "history_script": {
    "chief_complaint": "แน่นหน้าอก 2 ชั่วโมง",
    "hpi": "รายละเอียด onset, duration, character, radiation, aggravating/relieving factors...",
    "past_medical": "โรคประจำตัว...",
    "medications": "ยาที่ใช้...",
    "allergies": "แพ้ยา...",
    "family_history": "ประวัติครอบครัว...",
    "social_history": "สูบบุหรี่ ดื่มเหล้า อาชีพ...",
    "review_of_systems": "ระบบอื่นๆ ที่เกี่ยวข้อง..."
  },
  "pe_findings": {
    "General": "ลักษณะทั่วไป vital signs...",
    "Cardiovascular": "ผลตรวจหัวใจ...",
    "Respiratory": "ผลตรวจปอด...",
    "Abdomen": "ผลตรวจท้อง...",
    "Neurological": "ผลตรวจระบบประสาท...",
    "Extremities": "ผลตรวจแขนขา...",
    "HEENT": "ผลตรวจ หู ตา คอ จมูก..."
  },
  "lab_results": {
    "CBC": "WBC 12,000 (H), Hb 14, Plt 250,000",
    "Chemistry": "BUN 18, Cr 1.0, Na 140, K 4.0",
    "Specific test": "ผลตรวจจำเพาะ..."
  },
  "correct_diagnosis": "การวินิจฉัยที่ถูกต้อง",
  "accepted_ddx": ["DD 1", "DD 2", "DD 3"],
  "management_plan": "แผนการรักษาละเอียด...",
  "teaching_points": ["จุดสอน 1", "จุดสอน 2", "จุดสอน 3"],
  "examiner_questions": [
    "คำถาม examiner 1?",
    "คำถาม examiner 2?",
    "คำถาม examiner 3?"
  ],
  "scoring_rubric": {
    "history": 25,
    "pe": 20,
    "lab": 15,
    "ddx": 20,
    "management": 20
  }
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
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  let longCase: any;
  try {
    let cleaned = rawContent.trim();
    if (cleaned.startsWith("```")) {
      cleaned = cleaned.replace(/^```\w*\n?/, "").replace(/\n?```$/, "");
    }
    longCase = JSON.parse(cleaned);
  } catch {
    const match = rawContent.match(/\{[\s\S]*\}/);
    if (match) {
      try { longCase = JSON.parse(match[0]); } catch {
        return NextResponse.json({ error: "Failed to parse JSON" }, { status: 500 });
      }
    } else {
      return NextResponse.json({ error: "No JSON in response" }, { status: 500 });
    }
  }

  if (!longCase.title || !longCase.patient_info || !longCase.history_script) {
    return NextResponse.json({ error: "Invalid long case structure" }, { status: 500 });
  }

  // Get next week number
  const { data: maxWeek } = await supabase
    .from("long_cases")
    .select("week_number")
    .order("week_number", { ascending: false })
    .limit(1)
    .single();

  const nextWeek = ((maxWeek?.week_number as number) ?? 0) + 1;

  // Insert long case
  const { data: inserted, error } = await supabase
    .from("long_cases")
    .insert({
      title: longCase.title,
      specialty,
      difficulty: longCase.difficulty || "medium",
      week_number: nextWeek,
      is_weekly: true,
      is_published: true,
      patient_info: longCase.patient_info,
      history_script: longCase.history_script,
      pe_findings: longCase.pe_findings || {},
      lab_results: longCase.lab_results || {},
      imaging_results: longCase.imaging_results || null,
      correct_diagnosis: longCase.correct_diagnosis || "",
      accepted_ddx: longCase.accepted_ddx || [],
      management_plan: longCase.management_plan || "",
      teaching_points: longCase.teaching_points || [],
      examiner_questions: longCase.examiner_questions || [],
      scoring_rubric: longCase.scoring_rubric || { history: 25, pe: 20, lab: 15, ddx: 20, management: 20 },
    })
    .select("id")
    .single();

  if (error || !inserted) {
    return NextResponse.json({ error: error?.message ?? "Insert failed" }, { status: 500 });
  }

  return NextResponse.json({
    success: true,
    longCase: {
      id: inserted.id,
      title: longCase.title,
      specialty,
      difficulty: longCase.difficulty,
      week_number: nextWeek,
    },
  });
}
