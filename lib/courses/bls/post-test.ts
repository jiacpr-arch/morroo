// BLS-HCP post-test question banks — ported from acls-emr's
// src/courses/bls-hcp/postTest/{index,setA,setB}.js. Unlike ACLS, the BLS
// post-test content is static (not Supabase-backed), so it's shaped to
// match lib/acls-reader/assessment.ts's AssessmentQuestion interface here
// and consumed directly by components/courses/bls/BlsPostTestExam.tsx
// (which — per the migration plan — skips the /api/acls/attempts POST since
// there's no matching acls_assessment_sets/bank_id row for these ids).
//
// Distribution per set (23 Q): HQ-CPR 5, AED 3, team/2-rescuer 3,
// in-hospital-defib 4, infant 4, choking 3, chain 1.
// ต้องผ่าน medical review โดยแพทย์ EM/ICU ก่อนปล่อย production

import type { AssessmentQuestion } from "@/lib/acls-reader/assessment";

export interface BlsPostTestSet {
  id: string;
  title: string;
  questions: AssessmentQuestion[];
}

export const POST_TEST_LESSON_ID = "bls-post-test";
export const POST_TEST_PASS_PERCENT = 84; // BLS standard (ILCOR 2025) — matches COURSES.bls.passingScore.postTest
export const POST_TEST_QUESTION_COUNT = 23;

// Source questions don't carry a `difficulty`/`reference` field (unlike the
// ACLS Supabase bank) — normalize to the shared AssessmentQuestion shape.
function q(
  id: string,
  topic: string,
  question: string,
  choices: { id: string; text: string }[],
  correctId: string,
  explanation: string,
): AssessmentQuestion {
  return { id, topic, difficulty: "standard", question, choices, correctId, explanation, reference: null };
}

const setA: BlsPostTestSet = {
  id: "bls-set-a",
  title: "ชุด A",
  questions: [
    q(
      "bls-a-1",
      "chain",
      "พบผู้ป่วยใน ward หมดสติ ไม่ตอบสนอง ขั้นตอนแรกที่ถูกต้องคือ?",
      [
        { id: "a", text: "เริ่มกดหน้าอกทันที" },
        { id: "b", text: "เรียก code blue/RRT พร้อมขอ defibrillator" },
        { id: "c", text: "ตรวจชีพจร 30 วินาที" },
        { id: "d", text: "ไปตามแพทย์เวรเอง" },
      ],
      "b",
      "IHCA: activate code blue/RRT พร้อมขอ defib ทันที",
    ),
    q(
      "bls-a-2",
      "high-quality-cpr",
      "อัตราการกดหน้าอกในผู้ใหญ่ตาม ILCOR 2025 คือเท่าไร?",
      [
        { id: "a", text: "60–80/min" },
        { id: "b", text: "80–100/min" },
        { id: "c", text: "100–120/min" },
        { id: "d", text: ">120/min" },
      ],
      "c",
      "100–120 ครั้ง/นาที",
    ),
    q(
      "bls-a-3",
      "high-quality-cpr",
      "ความลึกการกดหน้าอกผู้ใหญ่ที่เหมาะสมคือ?",
      [
        { id: "a", text: "2–3 ซม." },
        { id: "b", text: "3–4 ซม." },
        { id: "c", text: "5–6 ซม." },
        { id: "d", text: ">7 ซม." },
      ],
      "c",
      "ผู้ใหญ่: อย่างน้อย 5 ซม. ไม่เกิน 6 ซม. (เกณฑ์ 1/3 AP diameter ใช้สำหรับเด็ก/ทารก)",
    ),
    q(
      "bls-a-4",
      "high-quality-cpr",
      "Chest Compression Fraction (CCF) เป้าหมายตามแนวทาง 2025 คือเท่าไร?",
      [
        { id: "a", text: "> 40%" },
        { id: "b", text: "> 60%" },
        { id: "c", text: "> 80%" },
        { id: "d", text: "100%" },
      ],
      "c",
      "แนวทาง 2025: CCF > 80% เป็น quality benchmark — สัมพันธ์กับ ROSC และ survival",
    ),
    q(
      "bls-a-5",
      "high-quality-cpr",
      "ทำไมต้องปล่อยให้หน้าอกคืนตัวเต็มที่ (full recoil)?",
      [
        { id: "a", text: "เพื่อพักกล้ามเนื้อผู้กด" },
        { id: "b", text: "เพิ่ม venous return ใน diastole" },
        { id: "c", text: "ให้ผู้ป่วยหายใจเอง" },
        { id: "d", text: "ลดอัตราการกด" },
      ],
      "b",
      "Incomplete recoil ลด venous return → ลด cardiac output",
    ),
    q(
      "bls-a-6",
      "high-quality-cpr",
      "ตามแนวทาง 2025 ทุกการหยุดกดหน้าอก (interruption) ไม่ควรเกินกี่วินาที?",
      [
        { id: "a", text: "5 วินาที" },
        { id: "b", text: "10 วินาที" },
        { id: "c", text: "20 วินาที" },
        { id: "d", text: "30 วินาที" },
      ],
      "b",
      "แนวทาง 2025: limit interruption ทุกประเภท < 10 วินาที (เป้าฝึกสลับคน < 5 วินาที แต่ formal limit = 10 วินาที)",
    ),
    q(
      "bls-a-7",
      "aed",
      "ทันทีหลัง AED shock ควรทำอะไร?",
      [
        { id: "a", text: "ตรวจชีพจรทันที" },
        { id: "b", text: "เริ่มกดหน้าอกต่อ 2 นาที" },
        { id: "c", text: "รอวิเคราะห์ rhythm ซ้ำ" },
        { id: "d", text: "ใส่ ETT" },
      ],
      "b",
      "หลัง shock → CPR ต่อ 2 นาที ห้ามตรวจ pulse",
    ),
    q(
      "bls-a-8",
      "aed",
      "AED ในเด็ก < 8 ปี (หรือ < 25 กก.) ควรใช้อย่างไรถ้าไม่มี pediatric pads?",
      [
        { id: "a", text: "ห้ามใช้" },
        { id: "b", text: "ใช้ผู้ใหญ่ได้ defib เป็นชีวิต" },
        { id: "c", text: "รอ EMS" },
        { id: "d", text: "ใช้ครึ่งพลังงาน" },
      ],
      "b",
      "เด็ก < 8 ปี หรือ < 25 กก. ใช้ peds pads/attenuator ถ้ามี; ถ้าไม่มีใช้ adult pads ได้ — ห้ามชะลอ defib",
    ),
    q(
      "bls-a-9",
      "aed",
      "ผู้ป่วยมี pacemaker ตำแหน่งวาง pads ควรเป็นอย่างไร?",
      [
        { id: "a", text: "วางบน pacemaker เลย" },
        { id: "b", text: "วางห่างจาก pacemaker มากที่สุดเท่าที่ทำได้ (ควร ≥ 8 ซม.) ห้ามวางทับ" },
        { id: "c", text: "ไม่ shock" },
        { id: "d", text: "ปิด pacemaker ก่อน" },
      ],
      "b",
      "หลักคือวางให้ห่าง pacemaker มากที่สุดเท่าที่ทำได้ ควร ≥ 8 ซม. (3.1 นิ้ว) ห้ามวางทับ — ค่า 2.5 ซม./1 นิ้ว เป็นของแผ่นแปะยา ไม่ใช่ pacemaker",
    ),
    q(
      "bls-a-10",
      "team",
      "ใส่ advanced airway แล้ว ventilate อย่างไร?",
      [
        { id: "a", text: "30:2 ตามปกติ" },
        { id: "b", text: "1 ครั้ง/6 วินาที (10/min) + continuous compressions" },
        { id: "c", text: "1 ครั้ง/3 วินาที" },
        { id: "d", text: "ไม่ ventilate" },
      ],
      "b",
      "หลัง advanced airway: continuous compressions + 10 breaths/min",
    ),
    q(
      "bls-a-11",
      "team",
      "ควรสลับคนกดทุกกี่นาที?",
      [
        { id: "a", text: "ทุก 30 วินาที" },
        { id: "b", text: "ทุก 2 นาที" },
        { id: "c", text: "ทุก 10 นาที" },
        { id: "d", text: "ไม่ต้องสลับ" },
      ],
      "b",
      "ทุก 2 นาที เพื่อรักษาคุณภาพ",
    ),
    q(
      "bls-a-12",
      "team",
      "Closed-loop communication คืออะไร?",
      [
        { id: "a", text: "การสั่งงานต่อกันเป็นทอด ๆ" },
        { id: "b", text: "Leader สั่ง → ผู้รับยืนยัน → ทำเสร็จรายงานกลับ" },
        { id: "c", text: "ปิดประตูห้อง" },
        { id: "d", text: "ส่งสัญญาณมือ" },
      ],
      "b",
      "Closed-loop ลด error ใน high-stress",
    ),
    q(
      "bls-a-13",
      "in-hospital-defib",
      "ในโรงพยาบาล BLS provider เจอ cardiac arrest นำเครื่อง defib/monitor มาถึง ใช้ mode ไหน?",
      [
        { id: "a", text: "Manual mode" },
        { id: "b", text: "AED mode" },
        { id: "c", text: "Sync cardioversion" },
        { id: "d", text: "Pacing mode" },
      ],
      "b",
      "BLS provider ใช้ AED mode (ไม่ได้รับการสอนอ่าน rhythm) — Manual = ALS",
    ),
    q(
      "bls-a-14",
      "in-hospital-defib",
      "ทำไม BLS provider ไม่ควรรอ ALS team มาก่อนใช้ defib?",
      [
        { id: "a", text: "ALS มาช้ากว่า" },
        { id: "b", text: "Defib เร็ว → ROSC สูงขึ้น ทุกนาที delay ลดโอกาสรอด ~10%" },
        { id: "c", text: "ALS ไม่อยากให้รอ" },
        { id: "d", text: "BLS provider ต้องโชว์ฝีมือ" },
      ],
      "b",
      "Time to first shock เป็น factor สำคัญสุดต่อ survival ใน VF/pVT",
    ),
    q(
      "bls-a-15",
      "in-hospital-defib",
      "AED mode บน defib monitor ทำงานต่างจาก AED stand-alone อย่างไร?",
      [
        { id: "a", text: "Shock แรงกว่า" },
        { id: "b", text: "Flow เหมือนกัน แต่ defib monitor switch ไป manual mode ได้เมื่อ ALS มา" },
        { id: "c", text: "ไม่มี voice prompt" },
        { id: "d", text: "ใช้ paddles แทน pads" },
      ],
      "b",
      "AED mode flow เหมือนกัน — ข้อดีคือ ALS switch manual ได้ ไม่ต้องเปลี่ยนเครื่อง",
    ),
    q(
      "bls-a-16",
      "in-hospital-defib",
      "ALS team มาถึงระหว่าง code ที่ BLS ใช้ AED mode อยู่ — ทำอะไรกับเครื่อง?",
      [
        { id: "a", text: "ปิดเครื่อง เปลี่ยนเครื่องใหม่" },
        { id: "b", text: "ถอด pads ติดใหม่" },
        { id: "c", text: "หัวหน้า ALS switch ไป manual + รับ hand-off (เวลา shock, rhythm, ยา)" },
        { id: "d", text: "Continue AED mode ตลอด code" },
      ],
      "c",
      "Switch manual mode เพื่ออ่าน rhythm ละเอียด + ใช้ sync/pacing; pads เดิมใช้ต่อ",
    ),
    q(
      "bls-a-17",
      "infant",
      "ตรวจชีพจรในทารกใช้ตำแหน่งใด?",
      [
        { id: "a", text: "Carotid" },
        { id: "b", text: "Radial" },
        { id: "c", text: "Brachial หรือ Femoral" },
        { id: "d", text: "Popliteal" },
      ],
      "c",
      "Brachial หรือ femoral — carotid ยากในทารก",
    ),
    q(
      "bls-a-18",
      "infant",
      "2-rescuer CPR ในทารก เทคนิคไหนแนะนำ?",
      [
        { id: "a", text: "1-hand technique" },
        { id: "b", text: "2-finger technique" },
        { id: "c", text: "2-thumb encircling" },
        { id: "d", text: "Heel of hand" },
      ],
      "c",
      "2-thumb encircling ให้ output ดีกว่า",
    ),
    q(
      "bls-a-19",
      "infant",
      "ความลึกการกดในทารกคือ?",
      [
        { id: "a", text: "~2 ซม." },
        { id: "b", text: "~4 ซม. หรือ 1/3 AP" },
        { id: "c", text: "~5–6 ซม." },
        { id: "d", text: "เท่าผู้ใหญ่" },
      ],
      "b",
      "1/3 AP ~ 4 ซม.",
    ),
    q(
      "bls-a-20",
      "infant",
      "อัตราการกดหน้าอกในทารกคือ?",
      [
        { id: "a", text: "60–80/min" },
        { id: "b", text: "80–100/min" },
        { id: "c", text: "100–120/min" },
        { id: "d", text: ">120/min" },
      ],
      "c",
      "100–120/min เหมือนผู้ใหญ่",
    ),
    q(
      "bls-a-21",
      "choking",
      "ทารกสำลัก รู้สึกตัว ทำอะไร?",
      [
        { id: "a", text: "Abdominal thrust 5 ครั้ง" },
        { id: "b", text: "Back blows 5 + chest thrusts 5" },
        { id: "c", text: "เริ่ม CPR" },
        { id: "d", text: "ฉีดน้ำเข้าจมูก" },
      ],
      "b",
      "ทารกใช้ back blows + chest thrusts (ห้าม abdominal)",
    ),
    q(
      "bls-a-22",
      "choking",
      "ผู้ป่วย FBAO หมดสติแล้ว ทำอะไรต่อ?",
      [
        { id: "a", text: "Abdominal thrusts ต่อ" },
        { id: "b", text: "เริ่ม CPR + ดูในปากก่อนแต่ละ breath" },
        { id: "c", text: "รอ EMS" },
        { id: "d", text: "Blind finger sweep" },
      ],
      "b",
      "หมดสติ → CPR; ดูในปากก่อน breath ห้าม blind sweep",
    ),
    q(
      "bls-a-23",
      "choking",
      "หญิงตั้งครรภ์ไตรมาส 3 สำลัก ใช้อะไรแทน abdominal thrust?",
      [
        { id: "a", text: "Chest thrusts" },
        { id: "b", text: "Back blows อย่างเดียว" },
        { id: "c", text: "CPR" },
        { id: "d", text: "รอ EMS" },
      ],
      "a",
      "ครรภ์แก่/อ้วนมาก: chest thrusts",
    ),
  ],
};

const setB: BlsPostTestSet = {
  id: "bls-set-b",
  title: "ชุด B",
  questions: [
    q(
      "bls-b-1",
      "chain",
      "พบคนหมดสติริมถนน ไม่ตอบสนอง สิ่งแรกที่ทำคือ?",
      [
        { id: "a", text: "เริ่ม CPR ทันที" },
        { id: "b", text: "ดู scene safety แล้วเรียก EMS 1669 (speakerphone)" },
        { id: "c", text: "ตามเจ้าหน้าที่" },
        { id: "d", text: "หยุดรถ" },
      ],
      "b",
      "OHCA: scene safety + เรียก EMS (1669) ก่อน ใช้ speakerphone จะได้ทำ CPR ได้",
    ),
    q(
      "bls-b-2",
      "high-quality-cpr",
      "ตำแหน่งวางมือกดหน้าอกผู้ใหญ่ที่ถูกต้องคือ?",
      [
        { id: "a", text: "กลาง sternum ครึ่งบน" },
        { id: "b", text: "ครึ่งล่างของ sternum กลางอก" },
        { id: "c", text: "ปลาย xiphoid" },
        { id: "d", text: "ด้านซ้ายของ sternum" },
      ],
      "b",
      "ครึ่งล่างของ sternum กลางอก ห้ามกดตรง xiphoid",
    ),
    q(
      "bls-b-3",
      "high-quality-cpr",
      "ถ้ากดหน้าอกเร็วเกิน 120/min จะเกิดอะไร?",
      [
        { id: "a", text: "Cardiac output ดีขึ้น" },
        { id: "b", text: "ความลึกการกดมักไม่พอ" },
        { id: "c", text: "ไม่มีผล" },
        { id: "d", text: "AED ทำงานเร็วขึ้น" },
      ],
      "b",
      "กดเร็วเกิน → depth ไม่พอ + incomplete recoil",
    ),
    q(
      "bls-b-4",
      "high-quality-cpr",
      "ผู้ป่วยอยู่บนเตียงนุ่ม ควรทำอะไรก่อน CPR?",
      [
        { id: "a", text: "กดบนเตียงเลย" },
        { id: "b", text: "ใส่ backboard ใต้หลังผู้ป่วย" },
        { id: "c", text: "ย้ายผู้ป่วยลงพื้น" },
        { id: "d", text: "พลิกผู้ป่วยตะแคง" },
      ],
      "b",
      "พื้นนุ่มลด effective depth → ใส่ backboard ใต้หลังผู้ป่วย; ไม่ควรย้ายลงพื้นเพราะเสียเวลา CPR และเสี่ยงบาดเจ็บเพิ่ม",
    ),
    q(
      "bls-b-5",
      "high-quality-cpr",
      "การ over-ventilation มีผลเสียอย่างไร?",
      [
        { id: "a", text: "เพิ่ม cardiac output" },
        { id: "b", text: "เพิ่ม intrathoracic pressure → ลด venous return → ลด CO" },
        { id: "c", text: "ไม่มีผล" },
        { id: "d", text: "ช่วยให้ผู้ป่วยฟื้น" },
      ],
      "b",
      "Hyperventilation เพิ่ม ITP ลด venous return + แย่ neurologic outcome",
    ),
    q(
      "bls-b-6",
      "high-quality-cpr",
      "อัตรา ventilation ใน BVM โดยไม่มี advanced airway (30:2) แต่ละ breath ใช้เวลาเท่าไร?",
      [
        { id: "a", text: "< 0.5 วินาที" },
        { id: "b", text: "~ 1 วินาที (จนหน้าอกขยาย)" },
        { id: "c", text: "~ 3 วินาที" },
        { id: "d", text: "~ 5 วินาที" },
      ],
      "b",
      "~ 1 วินาที จนเห็นหน้าอกขยาย ห้ามอัดแรง",
    ),
    q(
      "bls-b-7",
      "aed",
      "ผู้ป่วยขนหน้าอกหนา ติด AED ลำบาก ควรทำอะไร?",
      [
        { id: "a", text: "ไม่ใช้ AED" },
        { id: "b", text: "โกนหรือดึงขนออกด้วย pads สำรอง — เร็วที่สุด" },
        { id: "c", text: "รอ EMS" },
        { id: "d", text: "กด pads แรง ๆ" },
      ],
      "b",
      "โกนเร็ว ๆ หรือใช้ pads สำรองดึงขน — ห้ามเสียเวลา",
    ),
    q(
      "bls-b-8",
      "aed",
      "ผู้ป่วยมี transdermal patch (เช่น nitroglycerin) ตรงตำแหน่งจะวาง pads ทำไง?",
      [
        { id: "a", text: "วางทับ patch" },
        { id: "b", text: "ดึง patch ออก เช็ดยาออก แล้ววาง pads" },
        { id: "c", text: "หลีกเลี่ยง AED" },
        { id: "d", text: "รอ patch ออกฤทธิ์หมด" },
      ],
      "b",
      "ดึง patch + เช็ดออก ห้าม shock ผ่าน patch (ลุกไหม้/burn) — ถ้าดึงไม่ทันให้วาง pad ห่างจาก patch ≥ 2.5 ซม. (1 นิ้ว)",
    ),
    q(
      "bls-b-9",
      "aed",
      'AED แนะนำ "no shock advised" + ผู้ป่วยไม่มีชีพจร ทำอะไรต่อ?',
      [
        { id: "a", text: "รอ AED วิเคราะห์ใหม่" },
        { id: "b", text: "เริ่ม CPR ต่อ 2 นาที" },
        { id: "c", text: "หยุดทุกอย่าง" },
        { id: "d", text: "ปิดเครื่อง" },
      ],
      "b",
      "No shock = non-shockable rhythm → CPR ต่อ 2 นาที (PEA/asystole)",
    ),
    q(
      "bls-b-10",
      "team",
      "ใน team CPR ใครเป็นคนตรวจสอบคุณภาพการกด (depth/rate/recoil)?",
      [
        { id: "a", text: "ผู้กดเอง" },
        { id: "b", text: "Leader / ผู้ที่ไม่ได้กด — coaching แบบ real-time" },
        { id: "c", text: "ผู้ป่วย" },
        { id: "d", text: "AED เท่านั้น" },
      ],
      "b",
      "Team member ที่ไม่ได้กด เป็นคน coach quality real-time",
    ),
    q(
      "bls-b-11",
      "team",
      "การส่งต่อข้อมูลผู้ป่วยจาก BLS team ไป ALS team ควรใช้รูปแบบใด?",
      [
        { id: "a", text: "SBAR หรือ structured handover" },
        { id: "b", text: "เล่าตามใจ" },
        { id: "c", text: "ส่งเอกสารเท่านั้น" },
        { id: "d", text: "ไม่ต้องส่งต่อ" },
      ],
      "a",
      "SBAR (Situation-Background-Assessment-Recommendation) ลด miscommunication",
    ),
    q(
      "bls-b-12",
      "team",
      "หลัง code จบ ควรทำอะไรเพื่อพัฒนา team?",
      [
        { id: "a", text: "แยกย้ายทันที" },
        { id: "b", text: "Debriefing — review สิ่งที่ทำได้ดี/ปรับปรุง" },
        { id: "c", text: "รายงานหัวหน้าอย่างเดียว" },
        { id: "d", text: "ลบ recording" },
      ],
      "b",
      "Hot/cold debrief พัฒนา team performance",
    ),
    q(
      "bls-b-13",
      "in-hospital-defib",
      "รุ่น defib monitor ในโรงพยาบาล (Philips/Zoll/Lifepak/Mindray) ส่วนใหญ่มี mode อะไรบ้าง?",
      [
        { id: "a", text: "มีแค่ manual mode" },
        { id: "b", text: "AED mode + Manual mode (+ sync, pacing)" },
        { id: "c", text: "มีแค่ AED mode" },
        { id: "d", text: "ขึ้นกับยี่ห้อ ไม่มีมาตรฐาน" },
      ],
      "b",
      "Defib monitor มี dual mode — BLS ใช้ AED, ALS switch manual ได้ในเครื่องเดียวกัน",
    ),
    q(
      "bls-b-14",
      "in-hospital-defib",
      "BLS provider เปิด defib เลือก AED mode แล้ว ขั้นตอนต่อไปคือ?",
      [
        { id: "a", text: "รออ่าน rhythm บนจอ" },
        { id: "b", text: "ติด pads (anterolateral หรือ AP) — เครื่องจะวิเคราะห์เอง" },
        { id: "c", text: "ตั้ง energy ที่ 200J" },
        { id: "d", text: "ใส่ ETT ก่อน" },
      ],
      "b",
      "AED mode: ติด pads → เครื่องวิเคราะห์อัตโนมัติ → ทำตามคำสั่งเสียง",
    ),
    q(
      "bls-b-15",
      "in-hospital-defib",
      'AED mode บอก "no shock advised" ผู้ป่วยไม่มี pulse — ทำอะไรต่อ?',
      [
        { id: "a", text: "Switch ไป manual mode shock เอง" },
        { id: "b", text: "CPR ต่อ 2 นาที (PEA/asystole — non-shockable)" },
        { id: "c", text: "หยุด CPR" },
        { id: "d", text: "รอ ALS team" },
      ],
      "b",
      "No shock advised = non-shockable rhythm → CPR ต่อ 2 นาที เครื่องจะวิเคราะห์ซ้ำเอง",
    ),
    q(
      "bls-b-16",
      "in-hospital-defib",
      "Hand-off จาก BLS → ALS team ควรรายงานอะไรเกี่ยวกับ defib?",
      [
        { id: "a", text: "แค่ส่งเครื่องให้" },
        { id: "b", text: "เวลาเริ่ม CPR, จำนวน shock + เวลา shock ล่าสุด, rhythm ที่เห็น, ยาที่ให้" },
        { id: "c", text: "แค่จำนวน shock" },
        { id: "d", text: "ปิดเครื่องก่อน hand-off" },
      ],
      "b",
      "Structured hand-off (เช่น SBAR) ลด miscommunication; ALS ต้องรู้ context ก่อน switch manual",
    ),
    q(
      "bls-b-17",
      "infant",
      "อัตราส่วน C:V ในทารก 2-rescuer คือ?",
      [
        { id: "a", text: "30:2" },
        { id: "b", text: "15:2" },
        { id: "c", text: "5:1" },
        { id: "d", text: "10:2" },
      ],
      "b",
      "2-rescuer ทารก: 15:2 (เน้น oxygenation ในเด็ก)",
    ),
    q(
      "bls-b-18",
      "infant",
      "ใน 1-rescuer ทารก ใช้เทคนิคใดกดหน้าอก?",
      [
        { id: "a", text: "2-finger technique" },
        { id: "b", text: "2-thumb encircling" },
        { id: "c", text: "Heel of hand" },
        { id: "d", text: "1 hand" },
      ],
      "a",
      "1-rescuer: 2-finger; 2-rescuer (HCP): 2-thumb encircling",
    ),
    q(
      "bls-b-19",
      "infant",
      "AED ในทารก < 1 ปี ที่ไม่มี manual defib + ไม่มี peds attenuator ใช้อะไร?",
      [
        { id: "a", text: "รอเครื่องที่มี attenuator" },
        { id: "b", text: "ห้ามใช้ AED" },
        { id: "c", text: "ใช้ adult AED ได้" },
        { id: "d", text: "CPR อย่างเดียวจนกว่า EMS มา" },
      ],
      "c",
      "ILCOR 2025: ถ้าไม่มี manual/attenuator ใช้ adult AED ได้ในทารก — ดีกว่าไม่ defib เลย",
    ),
    q(
      "bls-b-20",
      "infant",
      "ทารก HR 45 + cyanosis แต่ตรวจ pulse ได้ — ทำอะไร?",
      [
        { id: "a", text: "ให้ O2 อย่างเดียว" },
        { id: "b", text: "เริ่มกดหน้าอกทันที + ventilation" },
        { id: "c", text: "รอดู 5 นาที" },
        { id: "d", text: "ฉีด epinephrine" },
      ],
      "b",
      "HR < 60 + poor perfusion ในทารก/เด็ก → start CPR ทันที",
    ),
    q(
      "bls-b-21",
      "choking",
      "ผู้ใหญ่สำลัก ไอออก พูดได้ ทำอย่างไร?",
      [
        { id: "a", text: "Abdominal thrust ทันที" },
        { id: "b", text: "ให้ไอเอง อย่ารบกวน" },
        { id: "c", text: "เริ่ม CPR" },
        { id: "d", text: "ดื่มน้ำ" },
      ],
      "b",
      "Mild obstruction → ให้ไอเอง ไอเป็น cough ที่ effective ที่สุด",
    ),
    q(
      "bls-b-22",
      "choking",
      "เด็กอายุ 3 ปี สำลัก ไอไม่ออก พูดไม่ได้ ทำอะไรตามแนวทาง ILCOR 2025?",
      [
        { id: "a", text: "Back blows อย่างเดียว" },
        { id: "b", text: "5 back blows สลับ 5 abdominal thrusts (Heimlich)" },
        { id: "c", text: "CPR ทันที" },
        { id: "d", text: "รอ EMS" },
      ],
      "b",
      "ILCOR 2025: เด็ก ≥ 1 ปี severe obstruction ใช้ back blows สลับ abdominal thrusts (ครั้งละ 5 เหมือนผู้ใหญ่)",
    ),
    q(
      "bls-b-23",
      "choking",
      "ทารก choking — ห้ามทำสิ่งใด?",
      [
        { id: "a", text: "Back blows" },
        { id: "b", text: "Chest thrusts" },
        { id: "c", text: "Abdominal thrust" },
        { id: "d", text: "CPR ถ้าหมดสติ" },
      ],
      "c",
      "ห้าม abdominal thrust ในทารก เสี่ยง liver injury",
    ),
  ],
};

export const postTestSets: BlsPostTestSet[] = [setA, setB];

export function getPostTestSetById(setId: string): BlsPostTestSet | null {
  return postTestSets.find((s) => s.id === setId) ?? null;
}

export function pickRandomPostTestSet(excludeId?: string | null): BlsPostTestSet {
  const pool = excludeId ? postTestSets.filter((s) => s.id !== excludeId) : postTestSets;
  const choices = pool.length ? pool : postTestSets;
  return choices[Math.floor(Math.random() * choices.length)];
}
