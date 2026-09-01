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
      slug: {
        type: "string",
        description: "kebab-case จากอาการนำ เช่น lc-abd-pain-01 — ห้ามมีชื่อโรค/การวินิจฉัยใน slug",
      },
      title: {
        type: "string",
        description:
          "ชื่อเคสภาษาไทย ขึ้นต้นด้วย LONG CASE: ... — ตั้งจากอาการนำ/สถานการณ์ให้ชวนติดตาม ห้ามมีชื่อโรค การวินิจฉัย หรือตัวย่อโรค (ห้ามสปอยล์เฉลย)",
      },
      subtitle: {
        type: "string",
        description: "โจทย์ผู้ป่วย 1 ประโยค (อายุ เพศ อาการนำ) — ห้ามเฉลยการวินิจฉัย",
      },
      difficultyTag: { type: "string", enum: ["basic", "megacode"] },
      bg: {
        type: "string",
        enum: ["er_bay", "opd_room", "ward_day", "ward_night", "labor_room", "nursery", "icu"],
        description:
          "ฉากหลังตามบริบทของเคส: er_bay (ฉุกเฉิน/arrest/trauma), opd_room (ตรวจ OPD/คลินิก/เคสเรื้อรัง), ward_day (หอผู้ป่วยกลางวัน), ward_night (เวรดึก), labor_room (สูติฯ/ห้องคลอด), nursery (ทารกแรกเกิด), icu (ผู้ป่วยวิกฤตใน ICU)",
      },
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
2. ซักประวัติ (~2 choice): เลือกคำถามที่แยกโรคได้ — ข้อถูกใส่ then ให้ผู้ป่วยตอบตาม history_script (ใช้ sprite ผู้ป่วยที่ตรงเพศ/วัยตามกติกาข้อ 1 — ทารก/เด็กเล็กให้ mother_rel ตอบแทน)
3. ตรวจร่างกาย (~2 choice): เลือกระบบ/สิ่งที่ตรวจ — then เผย pe_findings สำคัญ
4. Investigation (~1-2 choice): เลือก lab/imaging ที่ถูก (อิง lab_results ตัวที่ isAbnormal:true) และรู้ว่าเมื่อไรไม่ควรรอผล
5. วินิจฉัย (1 choice): ข้อถูก = correct_diagnosis; ข้อลวง = accepted_ddx ตัวอื่น
6. การรักษา (~1-2 choice): อิง management_plan; ทางเลือกอันตรายใส่ worsen:true
7. **ช่วงอาจารย์ซักถาม (สำคัญมากต่อการเรียนรู้):** att_dech ถามคำถามจาก examiner_questions ทีละข้อ (say node คำถามก่อน) แล้ว say node ถัดไปเผยแนวทางคำตอบจาก modelAnswer — ทำ 3-4 ข้อสำคัญสุด เพื่อฝึก active recall เหมือนสอบ long case จริง
8. debrief: attending สรุป teaching_points 2-3 ข้อ → { "inter": "เคสสำเร็จ!!", "green": true } → { "end": true }

## กติกาสำคัญ
1. ตัวละคร (who): ผู้ป่วยเลือกให้ตรงเพศ/วัยของเคส — patient_young_male (ชายอายุ <35), patient_generic (ชายวัยกลางคน 35-59), patient_elderly_male (ชายอายุ ≥60), patient_female (หญิงผู้ใหญ่), patient_elderly (หญิงสูงอายุ ≥60), patient_pregnant (หญิงตั้งครรภ์แก่/เห็นท้องชัด), patient_child (เด็กอายุ <15), mother_rel (แม่/ญาติ — ใช้ตอบซักประวัติแทนทารก/เด็กเล็กอายุ <7 ที่พูดเองไม่ได้); ทีมแพทย์: nurse_mint (พยาบาล), att_dech (อาจารย์/แพทย์อาวุโส), fon_defib และ boy_compressor (แพทย์/ทีมในวอร์ด ถ้าจำเป็น)${extraCharLines}
2. pose: idle, talk, panic, stern, happy เท่านั้น
3. **ห้ามใช้ fx ทุกชนิด** (ไม่มี alarm/cpr/shock/epi/rosc/rhythm) — นี่คือเคส ward ไม่ใช่ arrest
4. เน้นคำสำคัญด้วย **คำเน้น** เท่านั้น — ห้ามใช้ HTML เด็ดขาด
5. ทุก choice มี 3 ตัวเลือก และมีข้อถูก (ok: true) เพียงข้อเดียว; ข้อถูกใส่ then เดินเรื่องต่อ
6. **หัวใจของคุณภาพ — ตัวเลือกผิด (distractor) ต้องเป็น "กับดักคลินิกที่สมจริงเฉพาะเคสนี้" ไม่ใช่ตัวลวงงี่เง่าหรือกฎ generic** และ why ต้องอธิบายเหตุผลเฉพาะเคสว่าทำไมผิด (เช่น ในตัวอย่าง torsion: ตัวลวง "รอผล Doppler ก่อนผ่าตัด" + why "ถ้า suspicion สูงการรอ imaging ทำให้เลย golden period"). ให้เลียนแบบความลึกของ distractor + why จากตัวอย่างด้านล่าง
7. เนื้อหาต้องอิงข้อมูลในเคสเท่านั้น ห้ามแต่งข้อมูลผู้ป่วย/ผลตรวจเพิ่ม
8. slug ขึ้นต้นด้วย lc- ; title ขึ้นต้นด้วย "LONG CASE: ..." — **ห้ามเฉลยโรคในชื่อเกม:** title/subtitle/slug ต้องตั้งจากอาการนำหรือสถานการณ์ที่ชวนติดตาม (เช่น "ปวดท้องย้ายลงท้องน้อยขวา") ห้ามมีชื่อโรค การวินิจฉัย หรือตัวย่อโรค (เช่น appendicitis, DKA, STEMI) เพราะผู้เล่นต้องได้ฝึกวินิจฉัยเอง — ยกเว้นเคสที่โจทย์ให้การวินิจฉัยมาตั้งแต่ต้นและเกมวัดการจัดการ (เช่น เคสวิสัญญีเตรียมผ่าตัด)
9. tgt ของตัวเลือกใช้หมวดสั้น: ASK, PE, LAB, DX, MGMT, CONSULT
10. เลือก bg (ฉากหลัง) ให้ตรงบริบทของเคส: opd_room (ตรวจ OPD/คลินิก/เคสเรื้อรัง), er_bay (ฉุกเฉิน/trauma/ความดันตก), ward_day / ward_night (ผู้ป่วยใน — night เมื่อเหตุเกิดกลางดึก), labor_room (สูติฯ), nursery (ทารกแรกเกิด), icu (วิกฤต/ใส่ท่อแล้ว)
11. **ห้ามสปอยล์ในเนื้อเรื่องช่วงก่อนวินิจฉัย:** inter เปิดเรื่องและทุก node ก่อน choice วินิจฉัย ต้องพูดเป็นอาการ/ผลตรวจที่เจอ (เช่น "ซึม สับสน ความดันตก?!") ห้ามเอ่ยชื่อโรค คำวินิจฉัย หรือตัวย่อโรค — ชื่อโรคปรากฏได้ครั้งแรกหลังผู้เล่นเลือกวินิจฉัยแล้วเท่านั้น (ยกเว้นเคสที่โจทย์ให้การวินิจฉัยมาแต่ต้น)
12. **ห้ามให้เดาข้อถูกได้จากรูปแบบตัวเลือก:** ทั้ง 3 label ใน choice เดียวกันต้องยาวใกล้เคียงกัน โครงสร้างประโยคและระดับความเฉพาะเจาะจงขนานกัน — ห้ามให้ข้อถูกเป็นข้อที่ยาวสุด/ละเอียดสุด/มีตัวเลขมากสุดเป็นประจำ **วิธีแก้ที่ถูกต้องคือเติมรายละเอียดคลินิกให้ตัวลวงที่สั้นเกินไป ไม่ใช่ตัดข้อถูกให้สั้นจนเสียความชัดเจน** — ถ้าข้อถูกต้องพูดถึงขนาดยา/วิธีทำ/เหตุผลสั้นๆ ตัวลวงก็ควรมีรายละเอียดระดับเดียวกัน (เช่น แทนที่จะเขียน "รอดูอาการ" ให้เขียน "รอดูอาการที่ห้องสังเกตอาการ 2 ชม.ก่อนตัดสินใจ" — ยังผิดเหมือนเดิมแต่ยาวสมจริงขึ้น)

## ข้อมูลเคส Long Case ที่ต้องแปลง
${JSON.stringify(caseRow)}

## ตัวอย่างเกมเคสที่สมบูรณ์และมีคุณภาพ (เคส Testicular torsion — เลียนแบบความลึกของตัวลวง + why แบบนี้)
${JSON.stringify(lcTorsion)}`;
}
