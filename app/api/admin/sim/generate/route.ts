import { NextResponse } from "next/server";
import { requireAdmin } from "@/lib/admin-auth";
import { CHAT_MODELS, createAnthropic, createWithFallback } from "@/lib/anthropic";
import { createAdminClient } from "@/lib/supabase/admin";
import { lcTorsion, vfArrest } from "@/lib/sim/scenarios";
import { describeScenarioError } from "@/lib/sim/validate";

export const runtime = "nodejs";
export const maxDuration = 60;

// คืน scenario JSON ให้ฟอร์มรีวิว/แก้ก่อน — ไม่ insert เอง (ทางเขียนมีทางเดียว
// คือ POST /api/admin/sim) เลยไม่มี draft กำพร้าจากการ generate ทิ้งขว้าง

const DIFFICULTY_HINT: Record<string, string> = {
  easy: "เคสพื้นฐาน เดินเรื่องตรงไปตรงมา ตัวเลือกหลอกไม่ซับซ้อน",
  medium: "เคสระดับกลาง มีจุดหลอกที่พบบ่อยในห้องฉุกเฉินจริง",
  hard: "เคสยาก มี distractor ที่แพทย์มักสับสน และมีจังหวะเปลี่ยน rhythm",
};

const SCENARIO_TOOL = {
  name: "create_sim_scenario",
  description: "ส่งโจทย์ Code Blue Sim ที่แต่งเสร็จแล้ว",
  input_schema: {
    type: "object" as const,
    required: ["slug", "title", "subtitle", "difficultyTag", "story"],
    properties: {
      slug: { type: "string", description: "kebab-case เช่น pea-arrest-01" },
      title: { type: "string", description: "ชื่อเคสภาษาไทย ขึ้นต้นด้วย CODE BLUE: ..." },
      subtitle: { type: "string", description: "โจทย์ผู้ป่วย 1 ประโยค (อายุ เพศ อาการนำ)" },
      difficultyTag: { type: "string", enum: ["basic", "megacode"] },
      story: {
        type: "array",
        minItems: 8,
        description:
          "array ของ node ตามโครงสร้างเดียวกับตัวอย่างใน system prompt เป๊ะๆ (say/inter/skip/choice/end)",
        items: { type: "object" },
      },
    },
  },
};

interface ExtraCharacter {
  slug: string;
  name: string;
  role: string | null;
  personality: string | null;
}

function systemPrompt(extraCharacters: ExtraCharacter[]): string {
  const extraCharLines = extraCharacters.length
    ? "\nตัวละครเสริมที่ใช้ได้เพิ่มเติม (เขียนบทพูดให้ตรงบุคลิกของแต่ละตัว): " +
      extraCharacters
        .map((c) => {
          const parts = [c.name, c.role, c.personality ? `บุคลิก: ${c.personality}` : null].filter(Boolean);
          return `${c.slug} (${parts.join(" — ")})`;
        })
        .join(", ")
    : "";
  return `คุณคือผู้เชี่ยวชาญ ACLS และนักออกแบบเกมการสอนแพทย์ หน้าที่คือแต่งโจทย์เกม "Code Blue Sim" (เกมตัดสินใจสไตล์ visual novel) เป็นภาษาไทย

## โครงสร้าง node ใน story (ต้องตรงเป๊ะ)
- { "say": { "who": <charId>, "pose": <pose>, "text": "...", "fx": {...}? }, "t": <วินาที>? } — บทพูด
- { "inter": "ข้อความสั้น!!", "drama": "red"?, "green": true?, "fx": {...}?, "t": <วินาที>? } — ตะโกนเต็มจอ
- { "skip": "คำบรรยาย", "t": <วินาที> } — ข้ามเวลา (เช่น CPR 2 นาที ใช้ t: 110)
- { "choice": { "q": "คำถามสั้น", "options": [ { "tgt": "<หมวด>", "label": "...", "ok": true/false, "why": "เหตุผลเมื่อผิด", "worsen": true?, "then": [<node>...]? } ] } }
- { "end": true } — node สุดท้ายเสมอ

## กติกาสำคัญ
1. ตัวละคร (who): nurse_mint (พยาบาล IV/ยา), boy_compressor (คนกดหน้าอก), fon_defib (หมอคุม defib/monitor), att_dech (อาจารย์ attending)${extraCharLines}
2. pose: idle, talk, panic, stern, happy เท่านั้น
3. fx ที่ใช้ได้: alarm, cpr, firstCPR, epi, shock, rosc, rhythm ("flat"|"vf"|"nsr")
4. เน้นคำสำคัญด้วย **คำเน้น** เท่านั้น — ห้ามใช้ HTML เด็ดขาด
5. ทุก choice มี 3 ตัวเลือก และมีข้อถูก (ok: true) เพียงข้อเดียว; ข้อถูกใส่ then เดินเรื่องต่อ; ข้อผิดใส่ why อธิบายตามหลัก ACLS
6. ความถูกต้องทางการแพทย์ต้องอิง AHA ACLS: ขนาดยา (Epi 1 mg q3-5min, Amiodarone 300→150 mg), พลังงาน shock (biphasic 120-200 J), ลำดับ CPR→rhythm check→shock→CPR ต่อทันที 2 นาที, H's & T's
7. เดินเรื่อง 8-11 จุดตัดสินใจ จบด้วยเส้นทาง ROSC (node ที่มี fx: { rosc: true }) แล้วปิดด้วย { "end": true }
8. tgt ของตัวเลือกใช้หมวดสั้น: YOU, CPR, DEFIB, DRUG, AIRWAY, MONITOR

## ตัวอย่างโจทย์ที่สมบูรณ์ (เคส VF arrest)
${JSON.stringify(vfArrest)}`;
}

function longcaseSystemPrompt(extraCharacters: ExtraCharacter[], caseRow: Record<string, unknown>): string {
  const extraCharLines = extraCharacters.length
    ? "\nตัวละครเสริมที่ใช้ได้เพิ่มเติม (เขียนบทพูดให้ตรงบุคลิก): " +
      extraCharacters
        .map((c) => {
          const parts = [c.name, c.role, c.personality ? `บุคลิก: ${c.personality}` : null].filter(Boolean);
          return `${c.slug} (${parts.join(" — ")})`;
        })
        .join(", ")
    : "";
  return `คุณคือแพทย์ผู้เชี่ยวชาญและนักออกแบบเกมการสอน หน้าที่คือแปลงเคส Long Case ให้เป็นเกมตัดสินใจ "เกมเคส" (visual novel decision game) เป็นภาษาไทย โดยใช้ข้อมูลจากเคสที่ให้มาเท่านั้น

## โครงสร้าง node ใน story (ต้องตรงเป๊ะ)
- { "say": { "who": <charId>, "pose": <pose>, "text": "...", }, "t": <วินาที>? } — บทพูด
- { "inter": "ข้อความสั้น!!", "green": true?, "t": <วินาที>? } — ตะโกนเต็มจอ
- { "choice": { "q": "คำถามสั้น", "options": [ { "tgt": "<หมวด>", "label": "...", "ok": true/false, "why": "เหตุผลเมื่อผิด", "worsen": true?, "then": [<node>...]? } ] } }
- { "end": true } — node สุดท้ายเสมอ

## โครงเรื่องมาตรฐาน (เดินตามลำดับนี้ 8-10 จุดตัดสินใจ)
1. เปิดเรื่อง: พยาบาลรายงาน vitals จาก patient_info + inter อาการนำ + attending เปิดเคส
2. ซักประวัติ (~2 choice): เลือกคำถามที่แยกโรคได้ — ข้อถูกใส่ then ให้ patient_generic ตอบตาม history_script
3. ตรวจร่างกาย (~2 choice): เลือกระบบที่ตรวจ — then เผย pe_findings สำคัญ
4. Investigation (~1-2 choice): เลือก lab/imaging ที่ถูก (อิง lab_results ตัวที่ isAbnormal:true) และรู้ว่าเมื่อไรไม่ควรรอผล
5. วินิจฉัย (1 choice): ข้อถูก = correct_diagnosis; ข้อลวง = accepted_ddx ตัวอื่น
6. การรักษา (~1-2 choice): อิง management_plan; ทางเลือกอันตรายใส่ worsen:true
7. debrief: attending (pose happy/talk) สรุป teaching_points 2-3 ข้อ → { "inter": "เคสสำเร็จ!!", "green": true } → { "end": true }

## กติกาสำคัญ
1. ตัวละคร (who): patient_generic (ผู้ป่วย — ใช้ตอบคำถามซักประวัติ), nurse_mint (พยาบาล), att_dech (อาจารย์/แพทย์อาวุโส), fon_defib และ boy_compressor (แพทย์/ทีมในวอร์ด ถ้าจำเป็น)${extraCharLines}
2. pose: idle, talk, panic, stern, happy เท่านั้น
3. **ห้ามใช้ fx ทุกชนิด** (ไม่มี alarm/cpr/shock/epi/rosc/rhythm) — นี่คือเคส ward ไม่ใช่ arrest
4. เน้นคำสำคัญด้วย **คำเน้น** เท่านั้น — ห้ามใช้ HTML เด็ดขาด
5. ทุก choice มี 3 ตัวเลือก และมีข้อถูก (ok: true) เพียงข้อเดียว; ข้อถูกใส่ then เดินเรื่องต่อ; ข้อผิดใส่ why อธิบายเหตุผลทางคลินิก
6. เนื้อหาต้องอิงข้อมูลในเคสเท่านั้น ห้ามแต่งข้อมูลผู้ป่วยเพิ่ม
7. slug ขึ้นต้นด้วย lc- (เช่น lc-appendicitis-01); title ขึ้นต้นด้วย "LONG CASE: ..."
8. tgt ของตัวเลือกใช้หมวดสั้น: ASK, PE, LAB, DX, MGMT, CONSULT

## ข้อมูลเคส Long Case ที่ต้องแปลง
${JSON.stringify(caseRow)}

## ตัวอย่างเกมเคสที่สมบูรณ์ (เคส Testicular torsion)
${JSON.stringify(lcTorsion)}`;
}

export async function POST(request: Request) {
  const auth = await requireAdmin();
  if (!auth.ok) return auth.response;

  if (!process.env.ANTHROPIC_API_KEY) {
    return NextResponse.json(
      { error: "ยังไม่ได้ตั้งค่า ANTHROPIC_API_KEY" },
      { status: 500 },
    );
  }

  let body: { topic?: string; difficulty?: string; extraInstructions?: string; longCaseId?: string };
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON" }, { status: 400 });
  }

  const longCaseId = body.longCaseId?.trim();

  // ตัวละครเสริมจาก DB — ใส่ใน prompt และใช้ตอน validate ผลลัพธ์
  const adminClient = createAdminClient();
  const { data: dbChars } = await adminClient
    .from("sim_characters")
    .select("slug, name, role, personality")
    .eq("status", "active");
  const extraCharacters = dbChars ?? [];

  // เตรียม system + user prompt ตามโหมด: แปลงจาก Long Case หรือแต่งใหม่จากหัวข้อ
  let system: string;
  let userPrompt: string;
  if (longCaseId) {
    const { data: caseRow, error: caseErr } = await adminClient
      .from("long_cases")
      .select(
        "title, specialty, patient_info, history_script, pe_findings, lab_results, imaging_results, correct_diagnosis, accepted_ddx, management_plan, teaching_points",
      )
      .eq("id", longCaseId)
      .maybeSingle();
    if (caseErr || !caseRow) {
      return NextResponse.json({ error: "ไม่พบ Long Case ที่เลือก" }, { status: 404 });
    }
    system = longcaseSystemPrompt(extraCharacters, caseRow as Record<string, unknown>);
    userPrompt = [
      "แปลงเคส Long Case ที่ให้ในระบบเป็นเกมเคส ตามโครงเรื่องมาตรฐานและกติกาทุกข้อ",
      body.extraInstructions?.trim() ? `คำสั่งเพิ่มเติม: ${body.extraInstructions.trim()}` : "",
      "ห้ามใช้ slug ว่า lc-testicular-torsion-01 (มีอยู่แล้ว)",
    ].filter(Boolean).join("\n");
  } else {
    const topic = body.topic?.trim();
    if (!topic) {
      return NextResponse.json({ error: "กรุณาระบุหัวข้อ/ภาวะของเคส" }, { status: 400 });
    }
    const difficulty = DIFFICULTY_HINT[body.difficulty ?? ""] ? body.difficulty! : "medium";
    system = systemPrompt(extraCharacters);
    userPrompt = [
      `แต่งโจทย์เคสใหม่ หัวข้อ: ${topic}`,
      `ระดับ: ${DIFFICULTY_HINT[difficulty]}`,
      body.extraInstructions?.trim() ? `คำสั่งเพิ่มเติม: ${body.extraInstructions.trim()}` : "",
      "ห้ามใช้ slug ว่า vf-arrest-01 (มีอยู่แล้ว)",
    ].filter(Boolean).join("\n");
  }

  try {
    const client = createAnthropic();
    const response = await createWithFallback(
      client,
      CHAT_MODELS,
      {
        max_tokens: 8192,
        system,
        tools: [SCENARIO_TOOL],
        tool_choice: { type: "tool", name: "create_sim_scenario" },
        messages: [{ role: "user", content: userPrompt }],
      },
      "sim-generate",
    );

    if (response.stop_reason === "max_tokens") {
      return NextResponse.json(
        { error: "โจทย์ยาวเกินขนาดที่กำหนด — ลองหัวข้อที่แคบลงหรือกดสร้างใหม่" },
        { status: 502 },
      );
    }

    const tool = response.content.find((b) => b.type === "tool_use");
    if (!tool || tool.type !== "tool_use") {
      return NextResponse.json(
        { error: "AI ไม่ได้ส่งโจทย์กลับมา — ลองใหม่อีกครั้ง" },
        { status: 502 },
      );
    }

    const scenario = tool.input as Record<string, unknown>;
    const invalid = describeScenarioError(scenario, extraCharacters.map((c) => c.slug));
    if (invalid) {
      return NextResponse.json(
        { error: `โจทย์ที่ AI สร้างไม่ผ่านการตรวจ: ${invalid} — ลองสร้างใหม่` },
        { status: 502 },
      );
    }

    if (longCaseId) {
      return NextResponse.json({
        scenario: { ...scenario, category: "longcase", sourceCaseId: longCaseId },
      });
    }
    return NextResponse.json({ scenario });
  } catch (err) {
    const message = err instanceof Error ? err.message : "unknown";
    return NextResponse.json(
      { error: `เรียก AI ไม่สำเร็จ: ${message}` },
      { status: 502 },
    );
  }
}
