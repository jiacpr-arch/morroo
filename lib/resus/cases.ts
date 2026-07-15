// Resus Hero — ด่าน built-in (หัตถการกู้ชีพ ACLS)
//
// วิธีเขียนด่านใหม่:
// - พิกัดทุกอย่างอยู่ในกรอบ viewBox 0..1000 × 0..750 (FIELD_W × FIELD_H)
//   ให้สอดคล้องกับภาพผู้ป่วยใน components/resus/OperationArt.tsx (artId "arrest")
//   จุดอ้างอิงหลัก: ปาก/airway ~(500,120), คอ/carotid ~(455,215),
//   กลางอก/CPR ~(500,355), pad บนขวา ~(410,300), pad ล่างซ้าย ~(605,430),
//   แขนซ้าย/IV ~(775,430)
// - steps เรียงตามลำดับ ACLS จริง — ผู้เล่นต้องทำทีละขั้น
// - gesture: tap (จิ้ม), taps (จิ้ม n ครั้ง), hold (กดค้าง ms),
//   trace (ลากตามเส้น), rhythm (แตะตามจังหวะ targetBpm เช่น CPR 110)
// - subZones = เป้าย่อยตามลำดับ ใช้ tool+gesture เดิมซ้ำทีละจุด
// - hpDrain: true = "โอกาสรอด" ไหลลงเรื่อยๆ จนกว่า step นี้จะเสร็จ (แรงกดดันหลัก)
// - recoverHp = จบ step แล้วโอกาสรอดฟื้นกลับ (ช็อกสำเร็จ / ROSC)
// - timeLimitSec = เส้นตายต่อ step (ช้าเกินโดนหักครั้งเดียว)
// - rhythm = คลื่นบนจอ monitor ("vf"|"nsr"|"flat"), isShock = step ช็อกไฟฟ้า
// - why = ประโยคสอน (โชว์ตอนสำเร็จ + debrief) ใช้ **คำเน้น** ได้ ห้าม HTML

import type { Operation } from "./types";

// จุดอ้างอิงร่วมทุกเคส (ให้ zone ตรงกับภาพผู้ป่วยเดียวกัน)
const AIRWAY = { cx: 500, cy: 120, r: 70 };
const CAROTID = { cx: 455, cy: 215, r: 55 };
const CHEST_CENTER = { cx: 500, cy: 355, r: 95 };
const PAD_UPPER_R = { cx: 405, cy: 300, r: 55 };
const PAD_LOWER_L = { cx: 610, cy: 435, r: 55 };
const ARM_IV = { cx: 775, cy: 430, r: 70 };
const DEFIB = { cx: 165, cy: 470, r: 80 };
const LUNG_L = { cx: 430, cy: 330, r: 48 };
const LUNG_R = { cx: 575, cy: 330, r: 48 };

// ============================================================
// ด่าน 1 — VF Arrest: ช็อกให้ไว!
// ============================================================
const VF_ARREST: Operation = {
  slug: "vf-arrest-01",
  title: "VF Arrest: ช็อกให้ไว!",
  subtitle: "ชาย 58 ปี จุกแน่นอกแล้วล้มหมดสติใน ER — จอขึ้น VF",
  patient: {
    name: "คุณสมชาย",
    age: 58,
    story:
      "กำลังนั่งรอตรวจ จู่ๆ กุมอกแล้วล้มหมดสติ เรียกไม่รู้สึกตัว! จอ monitor เป็นคลื่นหยักถี่ — VF ทีมกำลังรอคำสั่งจากคุณ",
  },
  difficultyTag: "basic",
  artId: "arrest",
  tools: [
    "hands", "fingers_pulse", "cpr_hands", "defib_pads", "defib_button",
    "iv_catheter", "syringe_epi", "syringe_amio", "saline_bag", "bag_mask",
  ],
  parTimeSec: 240,
  hpDrainPerSec: 0.9,
  wrongToolDamage: 8,
  wrongZoneDamage: 3,
  steps: [
    {
      id: "check-response",
      title: "เขย่าเรียกดูการตอบสนอง",
      tool: "hands",
      zone: { shape: "circle", ...AIRWAY },
      gesture: { kind: "tap" },
      rhythm: "vf",
      why: "**ตบไหล่เรียกดัง ๆ** ก่อนเสมอ — ยืนยันว่าหมดสติจริงก่อนเริ่มกู้ชีพ",
      wrongToolWhy: {
        defib_button: "ยังไม่รู้เลยว่าเกิดอะไร — **ประเมินการตอบสนองก่อน**",
      },
    },
    {
      id: "check-pulse",
      title: "คลำชีพจร carotid (≤10 วิ)",
      tool: "fingers_pulse",
      zone: { shape: "circle", ...CAROTID },
      gesture: { kind: "hold", ms: 1800 },
      hpDrain: true,
      why: "คลำ carotid **ไม่เกิน 10 วินาที** — คลำไม่ได้ชีพจร = เริ่ม CPR ทันที",
    },
    {
      id: "cpr-1",
      title: "ปั๊มหัวใจ 30 ครั้ง ตามจังหวะ",
      tool: "cpr_hands",
      zone: { shape: "circle", ...CHEST_CENTER },
      gesture: { kind: "rhythm", count: 30, targetBpm: 110, toleranceBpm: 18 },
      hpDrain: true,
      rhythm: "vf",
      why: "กด **100-120 ครั้ง/นาที ลึก 5-6 ซม.** ปล่อยให้อกคืนตัวเต็มที่ — เลือดถึงจะไปเลี้ยงสมอง",
      wrongToolWhy: {
        defib_button: "เครื่องยังชาร์จไม่เสร็จ + ยังไม่ติด pad — **ระหว่างรอให้ปั๊มไปก่อน**",
      },
    },
    {
      id: "pads",
      title: "แปะแผ่น Pads 2 ตำแหน่ง",
      tool: "defib_pads",
      zone: { shape: "circle", ...PAD_UPPER_R },
      subZones: [
        { shape: "circle", ...PAD_UPPER_R },
        { shape: "circle", ...PAD_LOWER_L },
      ],
      gesture: { kind: "tap" },
      rhythm: "vf",
      fxState: "pads_on",
      why: "วาง pad **ใต้ไหปลาร้าขวา** และ **ชายโครงซ้ายแนวรักแร้** ให้กระแสไฟผ่านหัวใจ",
    },
    {
      id: "shock-1",
      title: "ช็อกไฟฟ้า! (ภายใน 45 วิ)",
      tool: "defib_button",
      zone: { shape: "circle", ...DEFIB },
      gesture: { kind: "tap" },
      hpDrain: true,
      timeLimitSec: 45,
      isShock: true,
      recoverHp: 10,
      rhythm: "vf",
      fxState: "shock_flash",
      why: "VF ต้อง **defibrillation เร็วที่สุด** — ทุกนาทีที่ช้า อัตรารอดลดลง 7-10%",
      wrongToolWhy: {
        cpr_hands: "ติด pad แล้ว จอยังเป็น VF — **นี่คือจังหวะช็อก ไม่ใช่ปั๊ม**",
      },
    },
    {
      id: "cpr-2",
      title: "ปั๊มต่อทันทีหลังช็อก 2 นาที",
      tool: "cpr_hands",
      zone: { shape: "circle", ...CHEST_CENTER },
      gesture: { kind: "rhythm", count: 20, targetBpm: 110, toleranceBpm: 18 },
      hpDrain: true,
      rhythm: "vf",
      why: "หลังช็อก **อย่าเพิ่งหยุดคลำชีพจร** — ปั๊มต่อทันที 2 นาทีค่อยประเมินซ้ำ",
    },
    {
      id: "iv",
      title: "เปิดเส้น IV",
      tool: "iv_catheter",
      zone: { shape: "circle", ...ARM_IV },
      gesture: { kind: "trace", path: [[720, 470], [820, 400]], tolerance: 55 },
      hpDrain: true,
      rhythm: "vf",
      fxState: "iv_in",
      why: "เปิดเส้นเลือดใหญ่ไว้ให้ยา — ถ้าเปิด IV ไม่ได้ ใช้ **IO (intraosseous)** แทนได้",
    },
    {
      id: "epi",
      title: "ให้ Epinephrine 1 mg",
      tool: "syringe_epi",
      zone: { shape: "circle", ...ARM_IV },
      gesture: { kind: "tap" },
      hpDrain: true,
      rhythm: "vf",
      why: "**Epinephrine 1 mg IV ทุก 3-5 นาที** ในภาวะหัวใจหยุดเต้นทุกชนิด",
      wrongToolWhy: {
        syringe_amio: "Amiodarone ให้หลังช็อกครั้งที่ 3 — **ตอนนี้ให้ Epi ก่อน**",
      },
    },
    {
      id: "shock-2",
      title: "ช็อกซ้ำ (ภายใน 45 วิ)",
      tool: "defib_button",
      zone: { shape: "circle", ...DEFIB },
      gesture: { kind: "tap" },
      hpDrain: true,
      timeLimitSec: 45,
      isShock: true,
      recoverHp: 10,
      rhythm: "vf",
      fxState: "shock_flash",
      why: "ยังเป็น VF — **ช็อกซ้ำ** สลับกับ CPR ทุก 2 นาที",
    },
    {
      id: "amio",
      title: "ให้ Amiodarone 300 mg",
      tool: "syringe_amio",
      zone: { shape: "circle", ...ARM_IV },
      gesture: { kind: "tap" },
      hpDrain: true,
      rhythm: "vf",
      why: "**Amiodarone 300 mg IV** สำหรับ VF/pVT ที่ดื้อต่อการช็อก (ตามด้วย 150 mg ได้)",
    },
    {
      id: "rosc",
      title: "ปั๊มต่อจนได้ ROSC",
      tool: "cpr_hands",
      zone: { shape: "circle", ...CHEST_CENTER },
      gesture: { kind: "rhythm", count: 16, targetBpm: 110, toleranceBpm: 20 },
      recoverHp: 25,
      rhythm: "nsr",
      fxState: "rosc",
      why: "จอกลับมาเป็นจังหวะปกติ คลำชีพจรได้ — **ROSC!** เข้าสู่การดูแลหลังกู้ชีพต่อ",
    },
  ],
};

// ============================================================
// ด่าน 2 — PEA: อย่าเพิ่งช็อก!
// ============================================================
const PEA_ARREST: Operation = {
  slug: "pea-arrest-01",
  title: "PEA: อย่าเพิ่งช็อก!",
  subtitle: "หญิง 24 ปี ท้องเสียรุนแรง 3 วัน แล้วหมดสติ — จอมีคลื่นแต่คลำชีพจรไม่ได้",
  patient: {
    name: "คุณแนน",
    age: 24,
    story:
      "ท้องเสียถ่ายเป็นน้ำมา 3 วัน อ่อนเพลียมากจนหมดสติ จอ monitor มีคลื่นดูคล้ายปกติ แต่ **คลำชีพจรไม่ได้เลย** — นี่คือ PEA",
  },
  difficultyTag: "intermediate",
  artId: "arrest",
  tools: [
    "hands", "fingers_pulse", "cpr_hands", "defib_button", "iv_catheter",
    "syringe_epi", "saline_bag", "stethoscope", "o2_mask",
  ],
  parTimeSec: 240,
  hpDrainPerSec: 1.0,
  wrongToolDamage: 9,
  wrongZoneDamage: 3,
  steps: [
    {
      id: "check-pulse",
      title: "คลำชีพจร — มีคลื่นแต่ไม่มีชีพจร",
      tool: "fingers_pulse",
      zone: { shape: "circle", ...CAROTID },
      gesture: { kind: "hold", ms: 1800 },
      hpDrain: true,
      rhythm: "nsr",
      why: "มีคลื่นไฟฟ้าแต่คลำชีพจรไม่ได้ = **PEA** — ต้อง CPR + หาสาเหตุ ไม่ใช่ช็อก",
    },
    {
      id: "cpr-1",
      title: "เริ่ม CPR ทันที",
      tool: "cpr_hands",
      zone: { shape: "circle", ...CHEST_CENTER },
      gesture: { kind: "rhythm", count: 24, targetBpm: 110, toleranceBpm: 18 },
      hpDrain: true,
      rhythm: "nsr",
      why: "PEA/Asystole รักษาด้วย **CPR คุณภาพดี + Epinephrine** — เดินหา 5H 5T คู่กันไป",
      wrongToolWhy: {
        defib_button: "**PEA ห้ามช็อก!** ช็อกได้เฉพาะ VF/pVT — เสียเวลาปั๊มและเสี่ยงอันตราย",
      },
    },
    {
      id: "iv",
      title: "เปิดเส้น IV เบอร์ใหญ่",
      tool: "iv_catheter",
      zone: { shape: "circle", ...ARM_IV },
      gesture: { kind: "trace", path: [[720, 470], [820, 400]], tolerance: 55 },
      hpDrain: true,
      rhythm: "nsr",
      fxState: "iv_in",
      why: "เปิดเส้นใหญ่ **2 เส้น** ไว้ให้ทั้งยาและสารน้ำปริมาณมาก",
    },
    {
      id: "epi",
      title: "ให้ Epinephrine 1 mg",
      tool: "syringe_epi",
      zone: { shape: "circle", ...ARM_IV },
      gesture: { kind: "tap" },
      hpDrain: true,
      rhythm: "nsr",
      why: "**Epinephrine 1 mg IV ทุก 3-5 นาที** — ให้ได้เร็วใน PEA ยิ่งดี (ไม่ต้องรอช็อก)",
    },
    {
      id: "fluid",
      title: "โหลดสารน้ำเร็ว (แก้ Hypovolemia)",
      tool: "saline_bag",
      zone: { shape: "circle", ...ARM_IV },
      gesture: { kind: "hold", ms: 2200 },
      recoverHp: 20,
      rhythm: "nsr",
      fxState: "saline_running",
      why: "สาเหตุคือ **Hypovolemia** จากท้องเสีย — เปิดสารน้ำ NSS/LRS เต็มที่คือการรักษาที่ตรงจุด (1 ใน 5H)",
      wrongToolWhy: {
        syringe_epi: "ให้ Epi ไปแล้ว — คราวนี้ต้อง **แก้ที่ต้นเหตุ: เติมน้ำ**",
      },
    },
    {
      id: "listen",
      title: "ฟังปอดยืนยันไม่มีสาเหตุอื่น",
      tool: "stethoscope",
      zone: { shape: "circle", ...LUNG_L },
      subZones: [
        { shape: "circle", ...LUNG_L },
        { shape: "circle", ...LUNG_R },
      ],
      gesture: { kind: "tap" },
      rhythm: "nsr",
      why: "ฟังปอด 2 ข้างเท่ากัน = ตัด **Tension pneumothorax** ออก (อีก 1 ใน 5T)",
    },
    {
      id: "rosc",
      title: "ปั๊มต่อจนได้ ROSC",
      tool: "cpr_hands",
      zone: { shape: "circle", ...CHEST_CENTER },
      gesture: { kind: "rhythm", count: 16, targetBpm: 110, toleranceBpm: 20 },
      recoverHp: 25,
      rhythm: "nsr",
      fxState: "rosc",
      why: "เมื่อแก้ volume + Epi ได้ผล ชีพจรกลับมา — **ROSC!** ส่งต่อ ICU หาสาเหตุที่เหลือ",
    },
  ],
};

// ============================================================
// ด่าน 3 — Airway & Post-ROSC
// ============================================================
const AIRWAY_ROSC: Operation = {
  slug: "airway-rosc-01",
  title: "Airway & Post-ROSC",
  subtitle: "ผู้ป่วยเพิ่งได้ ROSC แต่ยังไม่หายใจเอง — ต้องจัดการทางเดินหายใจ",
  patient: {
    name: "คุณสมชาย",
    age: 58,
    story:
      "กู้ชีพสำเร็จ ชีพจรกลับมาแล้ว แต่ยังไม่หายใจเอง GCS ต่ำ — ต้องเปิดทางเดินหายใจและใส่ท่อช่วยหายใจให้มั่นคง",
  },
  difficultyTag: "advanced",
  artId: "arrest",
  tools: [
    "hands", "bag_mask", "o2_mask", "laryngoscope", "ett_tube",
    "stethoscope", "saline_bag", "iv_catheter",
  ],
  parTimeSec: 300,
  hpDrainPerSec: 0.7,
  wrongToolDamage: 8,
  wrongZoneDamage: 4,
  steps: [
    {
      id: "airway-open",
      title: "เปิดทางเดินหายใจ (head tilt-chin lift)",
      tool: "hands",
      zone: { shape: "circle", ...AIRWAY },
      gesture: { kind: "hold", ms: 1400 },
      hpDrain: true,
      rhythm: "nsr",
      why: "**เชยคาง-เงยหน้า** เปิดทางเดินหายใจก่อน (ถ้าสงสัยบาดเจ็บคอใช้ jaw thrust)",
    },
    {
      id: "bag",
      title: "ช่วยหายใจด้วย Bag ตามจังหวะช้า",
      tool: "bag_mask",
      zone: { shape: "circle", ...AIRWAY },
      gesture: { kind: "rhythm", count: 6, targetBpm: 11, toleranceBpm: 4 },
      hpDrain: true,
      rhythm: "nsr",
      fxState: "bagging",
      why: "บีบ bag **ช้า ๆ ~10 ครั้ง/นาที** — บีบเร็วเกินทำให้ความดันในอกสูง เลือดไหลกลับหัวใจลดลง",
    },
    {
      id: "laryngoscope",
      title: "เปิด laryngoscope ดู vocal cords",
      tool: "laryngoscope",
      zone: { shape: "circle", ...AIRWAY },
      gesture: { kind: "hold", ms: 1600 },
      hpDrain: true,
      rhythm: "nsr",
      why: "ยกลิ้นเปิดให้เห็น **vocal cords** ชัด — ห้ามใช้ฟันเป็นจุดงัด",
    },
    {
      id: "intubate",
      title: "ใส่ท่อช่วยหายใจ (ETT) ผ่าน vocal cords",
      tool: "ett_tube",
      zone: { shape: "circle", cx: 500, cy: 105, r: 62 },
      gesture: { kind: "trace", path: [[500, 70], [500, 145]], tolerance: 48 },
      hpDrain: true,
      rhythm: "nsr",
      fxState: "tube_in",
      why: "สอดท่อผ่าน **glottis เข้าหลอดลม** — ถ้าเข้าหลอดอาหารจะช่วยหายใจไม่ได้ อันตรายมาก",
      wrongToolWhy: {
        bag_mask: "เห็น cords แล้ว — จังหวะนี้ **สอดท่อ ETT** ไม่ใช่ bag",
      },
    },
    {
      id: "confirm",
      title: "ยืนยันตำแหน่งท่อ — ฟังปอด 2 ข้าง",
      tool: "stethoscope",
      zone: { shape: "circle", ...LUNG_L },
      subZones: [
        { shape: "circle", ...LUNG_L },
        { shape: "circle", ...LUNG_R },
        { shape: "circle", cx: 500, cy: 470, r: 45 },
      ],
      gesture: { kind: "tap" },
      rhythm: "nsr",
      why: "ฟังปอด 2 ข้างเท่ากัน + ท้องไม่โป่ง + ยืนยันด้วย **EtCO₂ (capnography)** ว่าท่ออยู่ในหลอดลม",
    },
    {
      id: "o2",
      title: "ต่อออกซิเจน/เครื่องช่วยหายใจ",
      tool: "o2_mask",
      zone: { shape: "circle", ...AIRWAY },
      gesture: { kind: "tap" },
      rhythm: "nsr",
      fxState: "o2_on",
      why: "คุม **SpO₂ 92-98%** อย่าให้ออกซิเจนเกินจำเป็น (hyperoxia ก็มีโทษ)",
    },
    {
      id: "maintain",
      title: "ให้สารน้ำประคอง ความดัน",
      tool: "saline_bag",
      zone: { shape: "circle", ...ARM_IV },
      gesture: { kind: "hold", ms: 1600 },
      recoverHp: 15,
      rhythm: "nsr",
      fxState: "saline_running",
      why: "Post-ROSC คุม **MAP ≥ 65 mmHg** ด้วยสารน้ำ/vasopressor แล้วตามหาสาเหตุ (ECG หา STEMI → cath lab)",
    },
  ],
};

export const CASES: Operation[] = [VF_ARREST, PEA_ARREST, AIRWAY_ROSC];

export function getBuiltinCase(slug: string): Operation | undefined {
  return CASES.find((c) => c.slug === slug);
}
