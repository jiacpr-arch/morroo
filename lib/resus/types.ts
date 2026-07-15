// Operation MorRoo — ชนิดข้อมูลของด่านหัตถการ (Operation) และสถานะเกม
//
// ด่านเป็น data ล้วน (เขียนใน lib/resus/cases.ts หรืออนาคตจากตาราง
// resus_cases) — พิกัดทั้งหมดอยู่ในระบบ viewBox 0..1000 × 0..750
//
// ข้อความสอน (why) เป็น plain text — เน้นคำด้วย **คำเน้น** (render ผ่าน
// parseEmphasis ของ lib/sim/types เท่านั้น ห้าม HTML เพื่อรองรับด่านจาก
// แอดมิน/AI ในอนาคตอย่างปลอดภัย)

export type Grade = "S" | "A" | "B" | "C";

/** ขนาดเวที SVG — zone/path ทุกอันต้องอยู่ในกรอบนี้ */
export const FIELD_W = 1000;
export const FIELD_H = 750;

export type ToolId =
  | "hands"
  | "fingers_pulse"
  | "cpr_hands"
  | "defib_pads"
  | "defib_button"
  | "bag_mask"
  | "laryngoscope"
  | "ett_tube"
  | "stethoscope"
  | "iv_catheter"
  | "saline_bag"
  | "syringe_epi"
  | "syringe_amio"
  | "o2_mask";

export interface ResusTool {
  id: ToolId;
  name: string;
  emoji: string;
  /** คำใบ้สั้นๆ บนปุ่ม (โหมดง่าย) */
  hint?: string;
}

export const TOOL_CATALOG: Record<ToolId, ResusTool> = {
  hands: { id: "hands", name: "มือเปล่า", emoji: "🫱", hint: "เขย่าปลุก / จัดท่าเปิดทางเดินหายใจ" },
  fingers_pulse: { id: "fingers_pulse", name: "คลำชีพจร", emoji: "✌️", hint: "คลำ carotid ไม่เกิน 10 วินาที" },
  cpr_hands: { id: "cpr_hands", name: "ปั๊มหัวใจ", emoji: "🫸", hint: "กดกลางอก 100-120/นาที ลึก 5-6 ซม." },
  defib_pads: { id: "defib_pads", name: "แผ่น Pads", emoji: "🩹", hint: "ใต้ไหปลาร้าขวา + ชายโครงซ้าย" },
  defib_button: { id: "defib_button", name: "ช็อกไฟฟ้า", emoji: "⚡", hint: "ประจุ เคลียร์คน แล้วช็อก" },
  bag_mask: { id: "bag_mask", name: "Ambu Bag", emoji: "🫧", hint: "บีบช่วยหายใจ — อย่าเร็วเกิน" },
  laryngoscope: { id: "laryngoscope", name: "Laryngoscope", emoji: "🔦", hint: "เปิดดู vocal cords ก่อนใส่ท่อ" },
  ett_tube: { id: "ett_tube", name: "ท่อช่วยหายใจ (ETT)", emoji: "🪈", hint: "สอดผ่าน vocal cords" },
  stethoscope: { id: "stethoscope", name: "หูฟัง", emoji: "🩺", hint: "ฟังเสียงปอดสองข้าง" },
  iv_catheter: { id: "iv_catheter", name: "เข็มเปิดเส้น IV", emoji: "💉", hint: "เปิดเส้นที่ข้อพับแขน" },
  saline_bag: { id: "saline_bag", name: "สารน้ำ NSS", emoji: "💧", hint: "ต่อถุงน้ำเกลือ / โหลด volume" },
  syringe_epi: { id: "syringe_epi", name: "Epinephrine 1 mg", emoji: "🧪", hint: "ฉีดเข้า IV ทุก 3-5 นาที" },
  syringe_amio: { id: "syringe_amio", name: "Amiodarone 300 mg", emoji: "💊", hint: "ยากันชักหัวใจสำหรับ VF ดื้อช็อก" },
  o2_mask: { id: "o2_mask", name: "หน้ากากออกซิเจน", emoji: "😷", hint: "ให้ O2 เต็มที่" },
};

// ---- Zone & Gesture (พิกัด viewBox) ----

export type Zone =
  | { shape: "circle"; cx: number; cy: number; r: number }
  | { shape: "rect"; x: number; y: number; w: number; h: number }
  | { shape: "poly"; points: [number, number][] };

export type Gesture =
  | { kind: "tap" }
  | { kind: "taps"; count: number }
  | { kind: "hold"; ms: number }
  | { kind: "trace"; path: [number, number][]; tolerance?: number }
  /** แตะตามจังหวะ (CPR/bag) — วัด interval ระหว่าง tap เทียบ targetBpm */
  | { kind: "rhythm"; count: number; targetBpm: number; toleranceBpm?: number };

export const TRACE_TOLERANCE_DEFAULT = 60;
/** trace ถือว่าสำเร็จเมื่อครอบคลุมจุดบนเส้น ≥ สัดส่วนนี้ */
export const TRACE_COMPLETE_PCT = 0.9;
/** rhythm: ช่วง BPM ที่ยังนับว่า "ตรงจังหวะ" (± ค่านี้) */
export const RHYTHM_TOLERANCE_BPM_DEFAULT = 15;

/** สถานะคลื่นไฟฟ้าหัวใจบนจอ monitor (ตรงกับ prop ของ components/sim/EcgMonitor) */
export type MonitorRhythm = "vf" | "nsr" | "flat";

export interface OperationStep {
  id: string;
  /** ชื่อขั้นตอนบนแบนเนอร์ เช่น "ฉีดยาชารอบแผล" */
  title: string;
  tool: ToolId;
  zone: Zone;
  /** เป้าย่อยตามลำดับ (เย็บ 4 เข็ม, ฉีดยาชา 3 จุด) — ใช้ tool+gesture เดิมซ้ำทีละจุด */
  subZones?: Zone[];
  gesture: Gesture;
  /** ระหว่าง step นี้ยังไม่เสร็จ "โอกาสรอด" ไหลลงตาม hpDrainPerSec ของด่าน */
  hpDrain?: boolean;
  /** จบ step นี้แล้วโอกาสรอดฟื้นกลับ (เช่น ช็อกสำเร็จ +10, ROSC +25) */
  recoverHp?: number;
  /** เส้นตายของ step (วินาทีนับจากเริ่ม step) — เกินแล้วโดนหักครั้งเดียว */
  timeLimitSec?: number;
  /** คลื่นบนจอ monitor ระหว่าง step นี้ (ไม่ใส่ = คงค่าเดิม) */
  rhythm?: MonitorRhythm;
  /** step นี้คือการช็อกไฟฟ้า — ใช้เก็บ metric เวลาถึงช็อกแรก */
  isShock?: boolean;
  /** ข้อความสอนตอนทำสำเร็จ + ใน debrief (plain text, **เน้น** ได้) */
  why: string;
  /** ข้อความเฉพาะเมื่อหยิบเครื่องมือผิดตัวที่พบบ่อย */
  wrongToolWhy?: Partial<Record<ToolId, string>>;
  /** key สถานะภาพที่ OperationArt สลับไปเมื่อ step นี้เสร็จ */
  fxState?: string;
}

export interface OperationPatient {
  name: string;
  age: number;
  story: string;
}

/** v1 มีฉากเดียว: ผู้ป่วยหัวใจหยุดเต้นบนเตียง ER (ทุกเคสใช้ร่วมกัน) */
export type OperationArtId = "arrest";

export interface Operation {
  slug: string;
  title: string;
  subtitle: string;
  patient: OperationPatient;
  /** ป้ายระดับเนื้อหา (ไม่ใช่ความยากของเกม) เช่น 'basic' | 'advanced' */
  difficultyTag?: string;
  artId: OperationArtId;
  /** เครื่องมือบนถาดตามลำดับ — รวมตัวหลอก (distractor) ด้วย */
  tools: ToolId[];
  steps: OperationStep[];
  parTimeSec: number;
  /** อัตรา HP ไหลลงต่อวินาทีระหว่างมี step ที่ hpDrain ค้างอยู่ */
  hpDrainPerSec: number;
  wrongToolDamage: number;
  wrongZoneDamage: number;
}

// ---- สถานะเกม (mutable ใน ref ของ ResusRunner) ----

export interface TimelineItem {
  t: number;
  ok: boolean;
  text: string;
  note?: string;
}

export interface ResusState {
  difficulty: string;
  /** index ของ step ปัจจุบัน (steps[stepIdx]) — เกิน length = จบด่าน */
  stepIdx: number;
  /** index ของ subZone ปัจจุบันใน step ที่มี subZones */
  subIdx: number;
  /** progress ของ gesture ปัจจุบัน */
  tapsDone: number;
  holdMs: number;
  /** สัดส่วนจุดบนเส้น trace ที่ครอบคลุมแล้ว (0..1) */
  tracePct: number;
  /** จุดบนเส้น trace ที่แตะแล้ว (index → true) — reset ทุก sub/step */
  traceHits: boolean[];
  hp: number;
  maxHp: number;
  elapsed: number;
  /** วินาทีที่ผ่านไปใน step ปัจจุบัน — ใช้กับ timeLimitSec */
  stepElapsed: number;
  /** step ปัจจุบันโดนหักเพราะช้าเกิน timeLimitSec ไปแล้ว (หักครั้งเดียว) */
  timePenalized: boolean;
  /** เวลาของ tap ล่าสุดใน gesture rhythm (ms จาก performance.now ของ UI) */
  lastTapMs: number | null;
  /** สถิติจังหวะสะสมทั้งรอบ — ใช้คิดคุณภาพ CPR ใน debrief */
  goodTaps: number;
  offTempoTaps: number;
  /** วินาทีที่ช็อกไฟฟ้าครั้งแรกสำเร็จ (-1 = ยังไม่ช็อก) */
  firstShockAt: number;
  wrong: number;
  activeTool: ToolId | null;
  done: boolean;
  dead: boolean;
  timeline: TimelineItem[];
}

/** ตรวจโครงด่านจาก DB/AI แบบหลวมๆ ก่อนเอาไปเล่น — กันข้อมูลพังทำเกมค้าง */
export function isValidOperation(x: unknown): x is Operation {
  if (!x || typeof x !== "object") return false;
  const op = x as Record<string, unknown>;
  if (typeof op.slug !== "string" || typeof op.title !== "string") return false;
  if (!Array.isArray(op.tools) || op.tools.length === 0) return false;
  if (typeof op.parTimeSec !== "number" || typeof op.hpDrainPerSec !== "number") return false;
  if (!op.artId || typeof op.artId !== "string") return false;
  if (!Array.isArray(op.steps) || op.steps.length === 0) return false;
  return op.steps.every((s) => {
    if (!s || typeof s !== "object") return false;
    const step = s as Record<string, unknown>;
    if (typeof step.id !== "string" || typeof step.title !== "string") return false;
    if (typeof step.tool !== "string" || typeof step.why !== "string") return false;
    if (!isValidZone(step.zone)) return false;
    if (step.subZones !== undefined) {
      if (!Array.isArray(step.subZones) || !step.subZones.every(isValidZone)) return false;
    }
    return isValidGesture(step.gesture);
  });
}

function isValidZone(z: unknown): z is Zone {
  if (!z || typeof z !== "object") return false;
  const zone = z as Record<string, unknown>;
  if (zone.shape === "circle") {
    return [zone.cx, zone.cy, zone.r].every((v) => typeof v === "number");
  }
  if (zone.shape === "rect") {
    return [zone.x, zone.y, zone.w, zone.h].every((v) => typeof v === "number");
  }
  if (zone.shape === "poly") {
    return Array.isArray(zone.points) && zone.points.length >= 3;
  }
  return false;
}

function isValidGesture(g: unknown): g is Gesture {
  if (!g || typeof g !== "object") return false;
  const ges = g as Record<string, unknown>;
  if (ges.kind === "tap") return true;
  if (ges.kind === "taps") return typeof ges.count === "number" && ges.count >= 1;
  if (ges.kind === "hold") return typeof ges.ms === "number" && ges.ms > 0;
  if (ges.kind === "trace") return Array.isArray(ges.path) && ges.path.length >= 2;
  if (ges.kind === "rhythm") {
    return (
      typeof ges.count === "number" &&
      ges.count >= 1 &&
      typeof ges.targetBpm === "number" &&
      ges.targetBpm > 0
    );
  }
  return false;
}
