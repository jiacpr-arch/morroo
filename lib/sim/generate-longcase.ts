// Prompt + tool schema สำหรับให้ AI แปลง Long Case เป็นเกมเคส (คุณภาพระดับ
// เคส torsion ที่เขียนมือ) — ใช้ร่วมกันระหว่าง route /api/admin/sim/generate
// และ batch script scripts/generate-longcase-games.ts
//
// โมดูลนี้ pure ไม่ผูก Next (import เข้า tsx script ได้)

import { lcTorsion } from "./scenarios";

/** คอลัมน์ของ long_cases ที่ต้องดึงมาสร้าง prompt (รวม examiner_questions) */
export const LONGCASE_CASE_COLUMNS =
  "title, specialty, patient_info, history_script, pe_findings, lab_results, imaging_results, correct_diagnosis, accepted_ddx, management_plan, teaching_points, examiner_questions";

export interface ExtraCharacter {
  slug: string;
  name: string;
  role: string | null;
  personality: string | null;
}

/** tool schema เดียวกับที่ route ใช้ — AI ต้องส่ง scenario ตามนี้ */
export const SCENARIO_TOOL = {
  name: "create_sim_scenario",
  description: "ส่งโจทย์ Code Blue Sim ที่แต่งเสร็จแล้ว",
  input_schema: {
    type: "object" as const,
    required: ["slug", "title", "subtitle", "difficultyTag", "story"],
    properties: {
      slug: { type: "string", description: "kebab-case เช่น lc-appendicitis-01" },
      title: { type: "string", description: "ชื่อเคสภาษาไทย ขึ้นต้นด้วย LONG CASE: ..." },
      subtitle: { type: "string", description: "โจทย์ผู้ป่วย 1 ประโยค (อายุ เพศ อาการนำ)" },
      difficultyTag: { type: "string", enum: ["basic", "megacode"] },
      story: {
        type: "array",
        minItems: 8,
        description:
          "array ของ node ตามโครงสร้างเดียวกับตัวอย่างใน system prompt เป๊ะๆ (say/inter/choice/end)",
        items: { type: "object" },
      },
    },
  },
};

export function longcaseSystemPrompt(
  extraCharacters: ExtraCharacter[],
  caseRow: Record<string, unknown>,
): string {
  const extraCharLines = extraCharacters.length
    ? "\nตัวละครเสริมที่ใช้ได้เพิ่มเติม (เขียนบทพูดให้ตรงบุคลิก): " +
      extraCharacters
        .map((c) => {
          const parts = [c.name, c.role, c.personality ? `บุคลิก: ${c.personality}` : null].filter(Boolean);
          return `${c.slug} (${parts.join(" — ")})`;
        })
        .join(", ")
    : "";
  return `คุณคือแพทย์ผู้เชี่ยวชาญและนักออกแบบเกมการสอน หน้าที่คือแปลงเคส Long Case ให้เป็นเกมตัดสินใจ "เกมเคส" (visual novel decision game) เป็นภาษาไทย โดยใช้ข้อมูลจากเคสที่ให้มาเท่านั้น เป้าหมายสูงสุดคือ **ให้ผู้เรียนได้ฝึก clinical reasoning เฉพาะเคสนี้ให้มากที่สุด** (ไม่ใช่แค่จัดเรียงข้อมูล)

## โครงสร้าง node ใน story (ต้องตรงเป๊ะ)
- { "say": { "who": <charId>, "pose": <pose>, "text": "...", }, "t": <วินาที>? } — บทพูด
- { "inter": "ข้อความสั้น!!", "green": true?, "t": <วินาที>? } — ตะโกนเต็มจอ
- { "choice": { "q": "คำถามสั้น", "options": [ { "tgt": "<หมวด>", "label": "...", "ok": true/false, "why": "เหตุผลเมื่อผิด", "worsen": true?, "then": [<node>...]? } ] } }
- { "end": true } — node สุดท้ายเสมอ

## โครงเรื่องมาตรฐาน (เดินตามลำดับนี้ 9-12 จุดตัดสินใจ)
1. เปิดเรื่อง: พยาบาลรายงาน vitals จาก patient_info + inter อาการนำ + attending เปิดเคส
2. ซักประวัติ (~2 choice): เลือกคำถามที่แยกโรคได้ — ข้อถูกใส่ then ให้ patient_generic ตอบตาม history_script
3. ตรวจร่างกาย (~2 choice): เลือกระบบ/สิ่งที่ตรวจ — then เผย pe_findings สำคัญ
4. Investigation (~1-2 choice): เลือก lab/imaging ที่ถูก (อิง lab_results ตัวที่ isAbnormal:true) และรู้ว่าเมื่อไรไม่ควรรอผล
5. วินิจฉัย (1 choice): ข้อถูก = correct_diagnosis; ข้อลวง = accepted_ddx ตัวอื่น
6. การรักษา (~1-2 choice): อิง management_plan; ทางเลือกอันตรายใส่ worsen:true
7. **ช่วงอาจารย์ซักถาม (สำคัญมากต่อการเรียนรู้):** att_dech ถามคำถามจาก examiner_questions ทีละข้อ (say node คำถามก่อน) แล้ว say node ถัดไปเผยแนวทางคำตอบจาก modelAnswer — ทำ 3-4 ข้อสำคัญสุด เพื่อฝึก active recall เหมือนสอบ long case จริง
8. debrief: attending สรุป teaching_points 2-3 ข้อ → { "inter": "เคสสำเร็จ!!", "green": true } → { "end": true }

## กติกาสำคัญ
1. ตัวละคร (who): patient_generic (ผู้ป่วย — ใช้ตอบคำถามซักประวัติ), nurse_mint (พยาบาล), att_dech (อาจารย์/แพทย์อาวุโส), fon_defib และ boy_compressor (แพทย์/ทีมในวอร์ด ถ้าจำเป็น)${extraCharLines}
2. pose: idle, talk, panic, stern, happy เท่านั้น
3. **ห้ามใช้ fx ทุกชนิด** (ไม่มี alarm/cpr/shock/epi/rosc/rhythm) — นี่คือเคส ward ไม่ใช่ arrest
4. เน้นคำสำคัญด้วย **คำเน้น** เท่านั้น — ห้ามใช้ HTML เด็ดขาด
5. ทุก choice มี 3 ตัวเลือก และมีข้อถูก (ok: true) เพียงข้อเดียว; ข้อถูกใส่ then เดินเรื่องต่อ
6. **หัวใจของคุณภาพ — ตัวเลือกผิด (distractor) ต้องเป็น "กับดักคลินิกที่สมจริงเฉพาะเคสนี้" ไม่ใช่ตัวลวงงี่เง่าหรือกฎ generic** และ why ต้องอธิบายเหตุผลเฉพาะเคสว่าทำไมผิด (เช่น ในตัวอย่าง torsion: ตัวลวง "รอผล Doppler ก่อนผ่าตัด" + why "ถ้า suspicion สูงการรอ imaging ทำให้เลย golden period"). ให้เลียนแบบความลึกของ distractor + why จากตัวอย่างด้านล่าง
7. เนื้อหาต้องอิงข้อมูลในเคสเท่านั้น ห้ามแต่งข้อมูลผู้ป่วย/ผลตรวจเพิ่ม
8. slug ขึ้นต้นด้วย lc- ; title ขึ้นต้นด้วย "LONG CASE: ..."
9. tgt ของตัวเลือกใช้หมวดสั้น: ASK, PE, LAB, DX, MGMT, CONSULT

## ข้อมูลเคส Long Case ที่ต้องแปลง
${JSON.stringify(caseRow)}

## ตัวอย่างเกมเคสที่สมบูรณ์และมีคุณภาพ (เคส Testicular torsion — เลียนแบบความลึกของตัวลวง + why แบบนี้)
${JSON.stringify(lcTorsion)}`;
}
