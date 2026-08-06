// Prompt + tool schema สำหรับให้ AI แปลงข้อสอบ MEQ (progressive case 6 ตอน)
// เป็นเกมเคส (visual novel decision game) — คู่ขนานกับ lib/sim/generate-longcase.ts
// ใช้ SCENARIO_TOOL / ExtraCharacter ตัวเดียวกัน และ lcTorsion เป็นแม่แบบคุณภาพ
//
// โมดูลนี้ pure ไม่ผูก Next (import เข้า tsx script ได้)

import { lcTorsion } from "./scenarios";
import { SCENARIO_TOOL, type ExtraCharacter } from "./generate-longcase";

// re-export ให้ script/route import จากที่เดียว
export { SCENARIO_TOOL };
export type { ExtraCharacter };

/** คอลัมน์ของ exam_parts ที่ต้องดึงมาสร้าง prompt (เรียงตาม part_number) */
export const MEQ_PART_COLUMNS =
  "part_number, title, scenario, question, answer, key_points, time_minutes";

export interface MeqPart {
  part_number: number;
  title: string | null;
  scenario: string | null;
  question: string | null;
  answer: string | null;
  key_points: string[] | null;
}

export interface MeqExamRow {
  title: string;
  category: string | null;
  difficulty: string | null;
  parts: MeqPart[];
}

export function meqSystemPrompt(
  extraCharacters: ExtraCharacter[],
  exam: MeqExamRow,
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

  return `คุณคือแพทย์ผู้เชี่ยวชาญและนักออกแบบเกมการสอน หน้าที่คือแปลงข้อสอบ **MEQ (Modified Essay Question) แบบเคสไล่ลำดับ** ให้เป็นเกมตัดสินใจ "เกมเคส" (visual novel decision game) เป็นภาษาไทย โดยใช้ข้อมูลจากข้อสอบที่ให้มาเท่านั้น เป้าหมายสูงสุดคือ **ให้ผู้เรียนได้ฝึก clinical reasoning เฉพาะเคสนี้ให้มากที่สุด** ไม่ใช่แค่ท่องเฉลย

MEQ ต้นฉบับเป็นเคสเดียวที่ไล่เป็น "ตอน" (parts) ทีละสเต็ป แต่ละตอนมี scenario (ข้อมูลใหม่ที่เพิ่มเข้ามา), question (คำถามปลายเปิด), answer (เฉลยละเอียด) และ key_points — ให้ใช้ answer/key_points ของแต่ละตอนเป็นวัตถุดิบสร้าง **ตัวเลือกที่ถูก, ตัวลวงที่สมจริง และ why เฉพาะเคส**

## โครงสร้าง node ใน story (ต้องตรงเป๊ะ)
- { "say": { "who": <charId>, "pose": <pose>, "text": "...", }, "t": <วินาที>? } — บทพูด
- { "inter": "ข้อความสั้น!!", "green": true?, "t": <วินาที>? } — ตะโกนเต็มจอ
- { "choice": { "q": "คำถามสั้น", "options": [ { "tgt": "<หมวด>", "label": "...", "ok": true/false, "why": "เหตุผลเมื่อผิด", "worsen": true?, "then": [<node>...]? } ] } }
- { "end": true } — node สุดท้ายเสมอ

## วิธีแปลง MEQ แต่ละตอนเป็นจุดตัดสินใจ (เดินตามลำดับตอนของข้อสอบ 9-12 จุดตัดสินใจ)
- แต่ละ part ของ MEQ = 1-2 choice: เปิดด้วย say/inter เผย scenario ของตอนนั้น แล้วให้ผู้เล่นตัดสินใจตามที่ question ของตอนนั้นถาม
- ข้อถูก (ok: true) มาจาก answer/key_points ของตอนนั้น; ข้อลวงคือกับดักคลินิกที่ answer ปฏิเสธหรือที่แพทย์มักพลาดในเคสแบบนี้
- เรียงจุดตัดสินใจตามธีมของแต่ละตอน เช่น initial assessment → แปลผล lab → differential → วินิจฉัยชัด → การรักษา → complication/follow-up (อิงลำดับตอนจริงในข้อสอบ)
- **ช่วงอาจารย์ซักถาม (สำคัญมากต่อการเรียนรู้):** แทรก att_dech ถาม 2-3 คำถามสำคัญจาก question ของตอนท้ายๆ (say node คำถามก่อน แล้ว say node ถัดไปเผยแนวทางคำตอบจาก answer) เพื่อฝึก active recall เหมือนสอบจริง
- ปิดด้วย att_dech สรุป key_points สำคัญ 2-3 ข้อ → { "inter": "เคสสำเร็จ!!", "green": true } → { "end": true }

## กติกาสำคัญ
1. ตัวละคร (who): ผู้ป่วยเลือกให้ตรงเพศ/วัยของเคส — patient_generic (ชายผู้ใหญ่), patient_female (หญิงผู้ใหญ่), patient_elderly (หญิงสูงอายุ), patient_pregnant (หญิงตั้งครรภ์), patient_child (เด็ก), mother_rel (แม่/ญาติ — ใช้ตอบซักประวัติแทนทารก/เด็กเล็กที่พูดเองไม่ได้); ทีมแพทย์: nurse_mint (พยาบาล), att_dech (อาจารย์/แพทย์อาวุโส), fon_defib และ boy_compressor (แพทย์/ทีมในวอร์ด ถ้าจำเป็น)${extraCharLines}
2. pose: idle, talk, panic, stern, happy เท่านั้น
3. **ห้ามใช้ fx ทุกชนิด** (ไม่มี alarm/cpr/shock/epi/rosc/rhythm) — นี่คือเคส ward ไม่ใช่ arrest
4. เน้นคำสำคัญด้วย **คำเน้น** เท่านั้น — ห้ามใช้ HTML เด็ดขาด
5. ทุก choice มี 3 ตัวเลือก และมีข้อถูก (ok: true) เพียงข้อเดียว; ข้อถูกใส่ then เดินเรื่องต่อ
6. **หัวใจของคุณภาพ — ตัวเลือกผิด (distractor) ต้องเป็น "กับดักคลินิกที่สมจริงเฉพาะเคสนี้" ไม่ใช่ตัวลวงงี่เง่าหรือกฎ generic** และ why ต้องอธิบายเหตุผลเฉพาะเคสว่าทำไมผิด (เลียนแบบความลึกของตัวลวง + why จากตัวอย่าง torsion ด้านล่าง)
7. เนื้อหาต้องอิงข้อมูลในข้อสอบเท่านั้น ห้ามแต่งข้อมูลผู้ป่วย/ผลตรวจเพิ่มนอกเหนือจาก scenario/answer/key_points
8. slug ขึ้นต้นด้วย meq- ; title ขึ้นต้นด้วย "MEQ: ..." — **ห้ามเฉลยโรคในชื่อเกม:** title/subtitle/slug ต้องตั้งจากอาการนำหรือสถานการณ์ที่ชวนติดตาม (เช่น "ชาย 25 ปี ปวดรอบสะดือย้ายลงท้องน้อยขวา") ห้ามมีชื่อโรค การวินิจฉัย หรือตัวย่อโรค (เช่น appendicitis, DKA, STEMI) เพราะผู้เล่นต้องได้ฝึกวินิจฉัยเอง (ห้ามใช้ title ของข้อสอบต้นฉบับถ้ามันเฉลยโรค)
9. tgt ของตัวเลือกใช้หมวดสั้น: ASK, PE, LAB, DX, MGMT, CONSULT
10. เลือก bg (ฉากหลัง) ให้ตรงบริบทของเคส: opd_room (ตรวจ OPD/คลินิก/เคสเรื้อรัง), er_bay (ฉุกเฉิน/trauma/ความดันตก), ward_day / ward_night (ผู้ป่วยใน — night เมื่อเหตุเกิดกลางดึก), labor_room (สูติฯ), nursery (ทารกแรกเกิด), icu (วิกฤต/ใส่ท่อแล้ว)
11. **ห้ามสปอยล์ในเนื้อเรื่องช่วงก่อนวินิจฉัย:** inter เปิดเรื่องและทุก node ก่อน choice วินิจฉัย ต้องพูดเป็นอาการ/ผลตรวจที่เจอ (เช่น "ซึม สับสน ความดันตก?!") ห้ามเอ่ยชื่อโรค คำวินิจฉัย หรือตัวย่อโรค — ชื่อโรคปรากฏได้ครั้งแรกหลังผู้เล่นเลือกวินิจฉัยแล้วเท่านั้น (ยกเว้นเคสที่โจทย์ให้การวินิจฉัยมาแต่ต้น)

## ข้อมูลข้อสอบ MEQ ที่ต้องแปลง (สาขา ${exam.category ?? "-"}, ความยาก ${exam.difficulty ?? "-"})
${JSON.stringify(exam)}

## ตัวอย่างเกมเคสที่สมบูรณ์และมีคุณภาพ (เคส Testicular torsion — เลียนแบบความลึกของตัวลวง + why แบบนี้)
${JSON.stringify(lcTorsion)}`;
}
