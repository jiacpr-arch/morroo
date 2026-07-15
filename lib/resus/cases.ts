// Operation MorRoo — ด่าน built-in
//
// วิธีเขียนด่านใหม่:
// - พิกัดทุกอย่างอยู่ในกรอบ viewBox 0..1000 × 0..750 (FIELD_W × FIELD_H)
//   ให้สอดคล้องกับภาพใน components/resus/OperationArt.tsx (artId เดียวกัน)
// - steps เรียงตามลำดับหัตถการจริง — ผู้เล่นต้องทำทีละขั้น
// - gesture: tap (จิ้ม), taps (จิ้ม n ครั้ง), hold (กดค้าง ms), trace (ลากตามเส้น)
// - subZones = เป้าย่อยตามลำดับ ใช้ tool+gesture เดิมซ้ำทีละจุด
// - hpDrain: true = HP ไหลลงเรื่อยๆ จนกว่า step นี้จะเสร็จ (แรงกดดันหลักของเกม)
// - why = ประโยคสอน (โชว์ตอนทำสำเร็จ + debrief) ใช้ **คำเน้น** ได้ ห้าม HTML

import type { Operation } from "./types";

const SUTURE_LACERATION: Operation = {
  slug: "suture-laceration-01",
  title: "เย็บแผลฉีกขาด",
  subtitle: "วัยรุ่นล้มจักรยาน แผลฉีกขาดที่แขน 4 ซม. เลือดยังซึม",
  patient: {
    name: "น้องภูมิ",
    age: 16,
    story:
      "ล้มจักรยานมา แผลฉีกขาดที่แขนซ้ายยาวประมาณ 4 ซม. ขอบแผลไม่เรียบ มีเศษดินปน เลือดยังซึมตลอด — เย็บให้หน่อยครับหมอ",
  },
  difficultyTag: "basic",
  artId: "laceration",
  tools: [
    "gauze", "saline", "antiseptic", "syringe_lidocaine", "suture_set",
    "scissors", "dressing", "scalpel", "forceps",
  ],
  parTimeSec: 150,
  hpDrainPerSec: 1.2,
  wrongToolDamage: 8,
  wrongZoneDamage: 3,
  steps: [
    {
      id: "pressure",
      title: "กดห้ามเลือดด้วยผ้าก๊อซ",
      tool: "gauze",
      zone: { shape: "circle", cx: 500, cy: 375, r: 150 },
      gesture: { kind: "hold", ms: 2000 },
      hpDrain: true,
      why: "**Direct pressure** คือวิธีห้ามเลือดขั้นแรกเสมอ — กดแน่นๆ ก่อนคิดถึงอย่างอื่น",
      wrongToolWhy: {
        suture_set: "ยังไม่เย็บ! เลือดยังไหลอยู่ — ห้ามเลือดก่อน",
        scalpel: "นี่แผลฉีกขาด ไม่ต้องลงมีด — กดห้ามเลือดก่อน",
      },
      fxState: "pressed",
    },
    {
      id: "irrigate",
      title: "ล้างแผลด้วย NSS",
      tool: "saline",
      zone: { shape: "rect", x: 300, y: 290, w: 400, h: 180 },
      gesture: {
        kind: "trace",
        path: [
          [360, 340], [430, 358], [500, 375], [570, 393], [640, 410],
        ],
      },
      why: "การ**ล้างแผลด้วยแรงดัน**สำคัญที่สุดในการลด infection — ล้างเศษดินออกให้หมด",
      wrongToolWhy: {
        antiseptic: "อย่าเทน้ำยาฆ่าเชื้อลงในแผลเปิด — ทำลายเนื้อเยื่อ ใช้ NSS ล้างก่อน",
      },
      fxState: "cleaned",
    },
    {
      id: "prep",
      title: "ทาน้ำยาฆ่าเชื้อรอบแผล",
      tool: "antiseptic",
      zone: { shape: "circle", cx: 500, cy: 375, r: 220 },
      gesture: {
        kind: "trace",
        path: [
          [500, 205], [630, 250], [690, 375], [630, 500], [500, 545],
          [370, 500], [310, 375], [370, 250], [500, 205],
        ],
        tolerance: 80,
      },
      why: "ทาน้ำยาฆ่าเชื้อ**จากในออกนอก**เป็นวงรอบแผล — ไม่ราดลงในแผลโดยตรง",
      fxState: "prepped",
    },
    {
      id: "anesthesia",
      title: "ฉีดยาชาขอบแผล",
      tool: "syringe_lidocaine",
      zone: { shape: "circle", cx: 500, cy: 375, r: 150 },
      subZones: [
        { shape: "circle", cx: 405, cy: 330, r: 60 },
        { shape: "circle", cx: 595, cy: 420, r: 60 },
      ],
      gesture: { kind: "tap" },
      why: "Infiltrate **1% lidocaine** ตามขอบแผล — aspirate ก่อนฉีดทุกครั้ง, ขนาดสูงสุด ~4.5 mg/kg",
      wrongToolWhy: {
        suture_set: "เย็บทั้งที่ยังไม่ฉีดยาชา — คนไข้เจ็บมาก!",
      },
      fxState: "numbed",
    },
    {
      id: "suture",
      title: "เย็บแผล simple interrupted 4 เข็ม",
      tool: "suture_set",
      zone: { shape: "rect", x: 300, y: 280, w: 400, h: 200 },
      gesture: {
        kind: "trace",
        path: [
          [380, 310], [400, 400], [455, 330], [475, 418], [530, 350],
          [550, 435], [605, 370], [625, 455],
        ],
        tolerance: 70,
      },
      why: "เย็บ **simple interrupted** ระยะห่างแต่ละเข็ม ~0.5–1 ซม. ปมอยู่ด้านข้างแผล ไม่ดึงแน่นจนขอบบวม",
      fxState: "stitched",
    },
    {
      id: "cut",
      title: "ตัดไหมเหลือหางพอดี",
      tool: "scissors",
      zone: { shape: "circle", cx: 640, cy: 440, r: 90 },
      gesture: { kind: "tap" },
      why: "ตัดไหมเหลือหาง **~0.5 ซม.** — สั้นไปแกะยาก ยาวไประคายแผล",
      fxState: "trimmed",
    },
    {
      id: "dress",
      title: "ปิดแผล",
      tool: "dressing",
      zone: { shape: "circle", cx: 500, cy: 375, r: 170 },
      gesture: { kind: "tap" },
      why: "ปิดแผลกันปนเปื้อน — นัด**ตัดไหมแขน 7–10 วัน** และอย่าลืมเช็กประวัติ**วัคซีนบาดทะยัก**",
      fxState: "dressed",
    },
  ],
};

const TENSION_PNEUMO: Operation = {
  slug: "tension-pneumo-01",
  title: "Tension Pneumothorax — Needle + ICD",
  subtitle: "หนุ่มมอเตอร์ไซค์ล้ม หอบหนัก trachea เอียง — เวลาไม่รอ CXR",
  patient: {
    name: "คุณเก่ง",
    age: 24,
    story:
      "อุบัติเหตุมอเตอร์ไซค์ อกขวากระแทกแฮนด์ หายใจหอบ 36/นาที SpO2 84% หลอดลมเอียงไปซ้าย neck vein โป่ง — อาการแย่ลงทุกวินาที",
  },
  difficultyTag: "advanced",
  artId: "chest",
  tools: [
    "stethoscope", "o2_mask", "iv_catheter", "antiseptic", "syringe_lidocaine",
    "scalpel", "hemostat", "chest_tube", "seal_bottle", "suture_set", "dressing",
  ],
  parTimeSec: 210,
  hpDrainPerSec: 1.5,
  wrongToolDamage: 8,
  wrongZoneDamage: 3,
  steps: [
    {
      id: "listen",
      title: "ฟังเสียงปอดสองข้าง",
      tool: "stethoscope",
      zone: { shape: "rect", x: 280, y: 240, w: 440, h: 220 },
      subZones: [
        { shape: "circle", cx: 610, cy: 330, r: 75 },
        { shape: "circle", cx: 390, cy: 330, r: 75 },
      ],
      gesture: { kind: "tap" },
      hpDrain: true,
      why: "ข้างขวา**เสียงหายใจหายไป + เคาะโปร่ง** ร่วมกับ trachea เอียง = tension pneumothorax — วินิจฉัยจาก**อาการ ไม่ใช่ CXR**",
      wrongToolWhy: {
        scalpel: "ยังไม่รู้ว่าข้างไหน! ฟังปอดก่อนลงมือ",
      },
      fxState: "listened",
    },
    {
      id: "oxygen",
      title: "ให้ออกซิเจน high-flow",
      tool: "o2_mask",
      zone: { shape: "circle", cx: 500, cy: 130, r: 90 },
      gesture: { kind: "tap" },
      hpDrain: true,
      why: "O2 **high-flow** ทันทีระหว่างเตรียมหัตถการ — ซื้อเวลาให้ผู้ป่วย",
      fxState: "oxygen",
    },
    {
      id: "needle",
      title: "Needle decompression — 2nd ICS MCL ขวา",
      tool: "iv_catheter",
      zone: { shape: "circle", cx: 385, cy: 270, r: 48 },
      gesture: { kind: "tap" },
      hpDrain: true,
      why: "**เข็มก่อน สายทีหลัง** — แทง 2nd ICS ตำแหน่ง midclavicular line (หรือ 5th ICS anterior axillary) **เหนือขอบบนของ rib** เลี่ยง neurovascular bundle",
      wrongToolWhy: {
        chest_tube: "ICD ใช้เวลาเตรียมนาน — tension ต้อง**ระบายด้วยเข็มทันที**ก่อน",
        syringe_lidocaine: "ไม่มีเวลาฉีดยาชา — นี่คือภาวะฉุกเฉินถึงชีวิต แทงเข็มเลย",
      },
      fxState: "decompressed",
    },
    {
      id: "prep",
      title: "ทาน้ำยาฆ่าเชื้อบริเวณ safe triangle",
      tool: "antiseptic",
      zone: { shape: "circle", cx: 300, cy: 420, r: 130 },
      gesture: {
        kind: "trace",
        path: [
          [230, 360], [370, 360], [370, 480], [230, 480], [230, 360],
        ],
        tolerance: 75,
      },
      why: "อาการคงที่ขึ้นแล้ว — เตรียมใส่ ICD ใน **safe triangle** (ขอบ lat. dorsi, pec major, เหนือระดับ nipple)",
      fxState: "prepped",
    },
    {
      id: "anesthesia",
      title: "ฉีดยาชาถึงชั้น pleura",
      tool: "syringe_lidocaine",
      zone: { shape: "circle", cx: 300, cy: 420, r: 70 },
      gesture: { kind: "tap" },
      why: "ฉีดยาชาทุกชั้นจนถึง **parietal pleura** — ชั้นนี้เจ็บที่สุด",
      fxState: "numbed",
    },
    {
      id: "incise",
      title: "ลงมีดที่ 5th ICS anterior axillary line",
      tool: "scalpel",
      zone: { shape: "circle", cx: 300, cy: 420, r: 80 },
      gesture: {
        kind: "trace",
        path: [
          [255, 425], [345, 425],
        ],
        tolerance: 55,
      },
      why: "กรีดผิวหนัง ~2–3 ซม. **ขนานแนว rib เหนือขอบบนของซี่โครง** — เส้นเลือดเส้นประสาทวิ่งใต้ขอบล่าง",
      fxState: "incised",
    },
    {
      id: "dissect",
      title: "เลาะแบบทู่ด้วย hemostat จนทะลุ pleura",
      tool: "hemostat",
      zone: { shape: "circle", cx: 300, cy: 425, r: 70 },
      gesture: { kind: "hold", ms: 1800 },
      why: "**Blunt dissection** ค่อยๆ เลาะทะลุ pleura แล้วใช้นิ้วคลำยืนยันว่าเข้าช่องอกจริง ไม่โดนอวัยวะ",
      fxState: "dissected",
    },
    {
      id: "tube",
      title: "ใส่สาย ICD เข้าช่องอก",
      tool: "chest_tube",
      zone: { shape: "circle", cx: 310, cy: 420, r: 95 },
      gesture: {
        kind: "trace",
        path: [
          [250, 470], [300, 425], [355, 380],
        ],
        tolerance: 60,
      },
      why: "สอดสายไปทาง **apex** สำหรับลม (ทาง base สำหรับเลือด) — ดูไอน้ำในสาย/ลมออกเป็นสัญญาณว่าเข้าที่",
      fxState: "tubed",
    },
    {
      id: "seal",
      title: "ต่อขวด water seal",
      tool: "seal_bottle",
      zone: { shape: "rect", x: 80, y: 560, w: 180, h: 160 },
      gesture: { kind: "tap" },
      why: "ต่อ **underwater seal** — เห็นฟองอากาศปุดๆ ตอนหายใจออก = สายทำงาน ระบายลมได้จริง",
      fxState: "sealed",
    },
    {
      id: "fix",
      title: "เย็บยึดสายกับผิวหนัง",
      tool: "suture_set",
      zone: { shape: "circle", cx: 300, cy: 430, r: 75 },
      gesture: { kind: "tap" },
      why: "เย็บยึดสายกันหลุด — สายหลุดกลางทาง = เริ่มใหม่ทั้งหมด",
      fxState: "fixed",
    },
    {
      id: "dress",
      title: "ปิดแผลรอบสาย",
      tool: "dressing",
      zone: { shape: "circle", cx: 300, cy: 425, r: 95 },
      gesture: { kind: "tap" },
      why: "ปิดแผลรอบสาย แล้วส่ง **CXR ยืนยันตำแหน่ง** — ติดตาม SpO2 ต่อเนื่อง",
      fxState: "dressed",
    },
  ],
};

const ABSCESS_ID: Operation = {
  slug: "abscess-id-01",
  title: "ผ่าฝีระบายหนอง (I&D)",
  subtitle: "ฝีที่หลังปวดตุบๆ 5 วัน — กรีด ระบาย เลาะ ห้ามเย็บปิด",
  patient: {
    name: "คุณแพร",
    age: 35,
    story:
      "ก้อนที่หลังโตขึ้นเรื่อยๆ 5 วัน ปวดตุบๆ นอนไม่ได้ ผิวรอบก้อนแดงร้อน กดแล้วนุ่มๆ กลางก้อน — หมอช่วยจัดการทีเถอะ",
  },
  difficultyTag: "basic",
  artId: "abscess",
  tools: [
    "gloved_finger", "antiseptic", "syringe_lidocaine", "scalpel", "gauze",
    "hemostat", "saline", "packing_strip", "dressing", "suture_set",
  ],
  parTimeSec: 180,
  hpDrainPerSec: 1.0,
  wrongToolDamage: 8,
  wrongZoneDamage: 3,
  steps: [
    {
      id: "palpate",
      title: "คลำหา fluctuation",
      tool: "gloved_finger",
      zone: { shape: "circle", cx: 500, cy: 400, r: 130 },
      gesture: { kind: "hold", ms: 1500 },
      why: "**Fluctuation = พร้อมระบาย** — ถ้ายังแข็งเป็น induration ให้ยาปฏิชีวนะ + ประคบอุ่นก่อน ยังไม่กรีด",
      wrongToolWhy: {
        scalpel: "ยังไม่คลำเลย! ต้องยืนยัน fluctuation ก่อนกรีด",
      },
      fxState: "palpated",
    },
    {
      id: "prep",
      title: "ทาน้ำยาฆ่าเชื้อรอบฝี",
      tool: "antiseptic",
      zone: { shape: "circle", cx: 500, cy: 400, r: 210 },
      gesture: {
        kind: "trace",
        path: [
          [500, 240], [625, 285], [670, 400], [625, 515], [500, 560],
          [375, 515], [330, 400], [375, 285], [500, 240],
        ],
        tolerance: 80,
      },
      why: "ทำความสะอาดเป็นวงกว้างรอบฝี **จากในออกนอก**",
      fxState: "prepped",
    },
    {
      id: "fieldblock",
      title: "ฉีดยาชาแบบ field block รอบฝี",
      tool: "syringe_lidocaine",
      zone: { shape: "circle", cx: 500, cy: 400, r: 180 },
      subZones: [
        { shape: "circle", cx: 400, cy: 320, r: 55 },
        { shape: "circle", cx: 610, cy: 350, r: 55 },
        { shape: "circle", cx: 500, cy: 520, r: 55 },
      ],
      gesture: { kind: "tap" },
      why: "ฉีด**รอบๆ ฝี ไม่ฉีดเข้าโพรงฝี** — เนื้อเยื่ออักเสบ pH ต่ำ ยาชาออกฤทธิ์ไม่ดี บอกคนไข้ตรงๆ ว่ายังเจ็บได้",
      fxState: "numbed",
    },
    {
      id: "incise",
      title: "กรีดตามแนว skin lines",
      tool: "scalpel",
      zone: { shape: "circle", cx: 500, cy: 400, r: 110 },
      gesture: {
        kind: "trace",
        path: [
          [430, 390], [500, 400], [570, 410],
        ],
        tolerance: 55,
      },
      why: "กรีดยาวพอให้ระบายได้ **ตามแนว skin tension lines** — แผลเป็นจะสวยกว่า",
      fxState: "incised",
    },
    {
      id: "drain",
      title: "บีบและซับหนองออก",
      tool: "gauze",
      zone: { shape: "circle", cx: 500, cy: 400, r: 130 },
      gesture: { kind: "taps", count: 3 },
      hpDrain: true,
      why: "ระบายหนองออกให้มากที่สุด — **หนองที่ค้างคือเชื้อที่เหลือ**",
      fxState: "drained",
    },
    {
      id: "break",
      title: "เลาะ loculations ในโพรงฝี",
      tool: "hemostat",
      zone: { shape: "circle", cx: 500, cy: 400, r: 110 },
      gesture: { kind: "taps", count: 2 },
      why: "ใช้ hemostat กวาด**เลาะผนังกั้นในโพรง (loculations)** — ถ้าไม่เลาะ ฝีกลับมาใหม่",
      fxState: "broken",
    },
    {
      id: "irrigate",
      title: "ล้างโพรงฝีด้วย NSS",
      tool: "saline",
      zone: { shape: "circle", cx: 500, cy: 400, r: 120 },
      gesture: {
        kind: "trace",
        path: [
          [440, 370], [560, 380], [450, 430], [560, 440],
        ],
        tolerance: 70,
      },
      why: "ล้างจนน้ำใส — ลดปริมาณเชื้อในโพรง",
      fxState: "irrigated",
    },
    {
      id: "pack",
      title: "ใส่ packing ในโพรง",
      tool: "packing_strip",
      zone: { shape: "circle", cx: 500, cy: 400, r: 110 },
      gesture: { kind: "tap" },
      why: "**ห้ามเย็บปิดแผลฝี** — ใส่ packing ให้แผลหายจากก้นแผลขึ้นมา (secondary intention) นัดเปลี่ยน 24–48 ชม.",
      wrongToolWhy: {
        suture_set: "ห้ามเย็บปิดฝีเด็ดขาด! เชื้อจะถูกขังไว้ข้างใน — ใส่ packing แทน",
      },
      fxState: "packed",
    },
    {
      id: "dress",
      title: "ปิดแผล",
      tool: "dressing",
      zone: { shape: "circle", cx: 500, cy: 400, r: 150 },
      gesture: { kind: "tap" },
      why: "ปิดแผลหลวมๆ — ย้ำคนไข้กลับมา**เปลี่ยน packing ใน 24–48 ชม.** และสังเกตไข้/ปวดมากขึ้น",
      fxState: "dressed",
    },
  ],
};

export const CASES: Operation[] = [SUTURE_LACERATION, TENSION_PNEUMO, ABSCESS_ID];

export function getBuiltinCase(slug: string): Operation | null {
  return CASES.find((op) => op.slug === slug) ?? null;
}
