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
  | "antiseptic"
  | "saline"
  | "gauze"
  | "syringe_lidocaine"
  | "scalpel"
  | "suture_set"
  | "forceps"
  | "hemostat"
  | "scissors"
  | "dressing"
  | "iv_catheter"
  | "chest_tube"
  | "seal_bottle"
  | "stethoscope"
  | "o2_mask"
  | "packing_strip"
  | "gloved_finger";

export interface ResusTool {
  id: ToolId;
  name: string;
  emoji: string;
  /** คำใบ้สั้นๆ บนปุ่ม (โหมดง่าย) */
  hint?: string;
}

export const TOOL_CATALOG: Record<ToolId, ResusTool> = {
  antiseptic: { id: "antiseptic", name: "น้ำยาฆ่าเชื้อ", emoji: "🧴", hint: "ทาฆ่าเชื้อรอบแผล" },
  saline: { id: "saline", name: "NSS ล้างแผล", emoji: "💧", hint: "ล้างสิ่งสกปรกออกจากแผล" },
  gauze: { id: "gauze", name: "ผ้าก๊อซ", emoji: "🩹", hint: "กดห้ามเลือด / ซับ" },
  syringe_lidocaine: { id: "syringe_lidocaine", name: "ยาชา 1% Lidocaine", emoji: "💉", hint: "ฉีดยาชาก่อนทำหัตถการ" },
  scalpel: { id: "scalpel", name: "มีดผ่าตัด", emoji: "🔪", hint: "ลงมีดตามแนวที่กำหนด" },
  suture_set: { id: "suture_set", name: "ชุดเย็บแผล", emoji: "🪡", hint: "เย็บปิดแผล" },
  forceps: { id: "forceps", name: "Forceps", emoji: "🥢", hint: "คีบจับเนื้อเยื่อ" },
  hemostat: { id: "hemostat", name: "Hemostat / Kelly", emoji: "✂️", hint: "หนีบ / เลาะแบบทู่" },
  scissors: { id: "scissors", name: "กรรไกร", emoji: "✄", hint: "ตัดไหม" },
  dressing: { id: "dressing", name: "ผ้าปิดแผล", emoji: "🩺", hint: "ปิดแผลเมื่อเสร็จ" },
  iv_catheter: { id: "iv_catheter", name: "เข็ม IV เบอร์ใหญ่", emoji: "📍", hint: "Needle decompression" },
  chest_tube: { id: "chest_tube", name: "สายระบายทรวงอก (ICD)", emoji: "🧪", hint: "ใส่สายระบายลม/ของเหลว" },
  seal_bottle: { id: "seal_bottle", name: "ขวด Water Seal", emoji: "⚗️", hint: "ต่อปลายสาย ICD" },
  stethoscope: { id: "stethoscope", name: "หูฟัง", emoji: "🩻", hint: "ฟังเสียงปอดสองข้าง" },
  o2_mask: { id: "o2_mask", name: "หน้ากากออกซิเจน", emoji: "😮‍💨", hint: "ให้ O2 ก่อนเสมอ" },
  packing_strip: { id: "packing_strip", name: "Packing gauze", emoji: "🎗️", hint: "ใส่ในโพรงฝี ห้ามเย็บปิด" },
  gloved_finger: { id: "gloved_finger", name: "มือ (ใส่ถุงมือ)", emoji: "🖐️", hint: "คลำตรวจก่อนลงมือ" },
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
  | { kind: "trace"; path: [number, number][]; tolerance?: number };

export const TRACE_TOLERANCE_DEFAULT = 60;
/** trace ถือว่าสำเร็จเมื่อครอบคลุมจุดบนเส้น ≥ สัดส่วนนี้ */
export const TRACE_COMPLETE_PCT = 0.9;

export interface OperationStep {
  id: string;
  /** ชื่อขั้นตอนบนแบนเนอร์ เช่น "ฉีดยาชารอบแผล" */
  title: string;
  tool: ToolId;
  zone: Zone;
  /** เป้าย่อยตามลำดับ (เย็บ 4 เข็ม, ฉีดยาชา 3 จุด) — ใช้ tool+gesture เดิมซ้ำทีละจุด */
  subZones?: Zone[];
  gesture: Gesture;
  /** ระหว่าง step นี้ยังไม่เสร็จ HP ไหลลงตาม hpDrainPerSec ของด่าน */
  bleeding?: boolean;
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

export type OperationArtId = "laceration" | "chest" | "abscess";

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
  /** อัตรา HP ไหลลงต่อวินาทีระหว่างมี step ที่ bleeding ค้างอยู่ */
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
  return false;
}
