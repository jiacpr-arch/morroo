// Resus engine — ส่วน logic ล้วนของเกมหัตถการ (ไม่มี DOM/React)
//
// โมเดล interaction = select-then-act: ผู้เล่นแตะเลือกเครื่องมือ (armTool)
// แล้วทำ gesture บนเวที — UI แปลง pointer event เป็นพิกัด viewBox แล้วเรียก
// pointerDown/pointerMove/holdTick ที่นี่ ผลลัพธ์กลับเป็น ActionOutcome
// ให้ UI เอาไป map เป็นเสียง/เอฟเฟกต์เอง
//
// เวลากดดันของเกมนี้มี 3 ชั้น:
// 1. step ที่ติดธง hpDrain — "โอกาสรอด" ไหลลงต่อวินาที (ผ่าน tick)
//    จนกว่าจะทำหัตถการสำคัญสำเร็จ (recoverHp ฟื้นกลับได้)
// 2. timeLimitSec ต่อ step — ช้าเกินโดนหักครั้งเดียว (too_slow)
// 3. gesture rhythm — แตะตามจังหวะ (เช่น CPR 110/นาที) วัด interval จริง

import {
  RHYTHM_TOLERANCE_BPM_DEFAULT,
  TOOL_CATALOG,
  TRACE_COMPLETE_PCT,
  TRACE_TOLERANCE_DEFAULT,
  type Grade,
  type Operation,
  type OperationStep,
  type ResusState,
  type ToolId,
  type Zone,
} from "./types";
import { accumulateTrace, pointInZone, tracePoints, type Point } from "./geometry";

export interface Difficulty {
  id: string;
  label: string;
  /** ตัวคูณอัตราเลือดไหล + ดาเมจตอนพลาด */
  drainMult: number;
  damageMult: number;
  /** การชี้เป้า: full = วงเป้า+เส้นนำ, subtle = จุดวิบๆ, none = ไม่ช่วยเลย */
  highlight: "full" | "subtle" | "none";
  gradeStrict: boolean;
}

export const DIFFICULTY: Record<string, Difficulty> = {
  easy: { id: "easy", label: "ง่าย", drainMult: 0.5, damageMult: 0.5, highlight: "full", gradeStrict: false },
  normal: { id: "normal", label: "ปกติ", drainMult: 1, damageMult: 1, highlight: "subtle", gradeStrict: false },
  hard: { id: "hard", label: "ยาก", drainMult: 1.5, damageMult: 1.5, highlight: "none", gradeStrict: true },
};
export const DEFAULT_DIFFICULTY = "normal";
export const MAX_HP = 100;

export function getDifficulty(id: string): Difficulty {
  return DIFFICULTY[id] || DIFFICULTY[DEFAULT_DIFFICULTY];
}

export function createInitialState(difficultyId: string = DEFAULT_DIFFICULTY): ResusState {
  return {
    difficulty: getDifficulty(difficultyId).id,
    stepIdx: 0,
    subIdx: 0,
    tapsDone: 0,
    holdMs: 0,
    tracePct: 0,
    traceHits: [],
    hp: MAX_HP,
    maxHp: MAX_HP,
    elapsed: 0,
    stepElapsed: 0,
    timePenalized: false,
    lastTapMs: null,
    goodTaps: 0,
    offTempoTaps: 0,
    firstShockAt: -1,
    wrong: 0,
    activeTool: null,
    done: false,
    dead: false,
    timeline: [],
  };
}

export function currentStep(op: Operation, state: ResusState): OperationStep | null {
  return state.done || state.dead ? null : op.steps[state.stepIdx] ?? null;
}

/** zone เป้าปัจจุบัน — subZones มาก่อน zone หลักเมื่อ step มีเป้าย่อย */
export function currentZone(op: Operation, state: ResusState): Zone | null {
  const step = currentStep(op, state);
  if (!step) return null;
  if (step.subZones?.length) return step.subZones[state.subIdx] ?? step.zone;
  return step.zone;
}

export type ActionOutcome =
  | { kind: "noop" }
  | { kind: "step_progress" } // gesture คืบหน้า (นับ tap / เริ่ม hold / trace เดิน)
  | { kind: "sub_done"; step: OperationStep }
  | { kind: "step_done"; step: OperationStep }
  | { kind: "op_done"; step: OperationStep }
  | { kind: "wrong_tool"; note: string }
  | { kind: "wrong_zone"; note: string }
  | { kind: "too_slow"; note: string } // เกิน timeLimitSec ของ step (หักครั้งเดียว)
  | { kind: "rhythm_feedback"; quality: "good" | "fast" | "slow" }
  | { kind: "op_failed"; note: string };

export function armTool(state: ResusState, tool: ToolId): void {
  state.activeTool = state.activeTool === tool ? null : tool;
}

/** เดินเวลา + โอกาสรอดไหลลง + เส้นตายต่อ step — เรียกจาก interval ~4Hz, dt เป็นวินาที */
export function tick(state: ResusState, op: Operation, dt: number): ActionOutcome {
  if (state.done || state.dead) return { kind: "noop" };
  state.elapsed += dt;
  state.stepElapsed += dt;
  const step = currentStep(op, state);
  if (step?.hpDrain) {
    const drain = op.hpDrainPerSec * getDifficulty(state.difficulty).drainMult * dt;
    state.hp = Math.max(0, state.hp - drain);
    if (state.hp <= 0) return fail(state, "ช้าเกินไป — โอกาสรอดของผู้ป่วยหมดลง");
  }
  if (step?.timeLimitSec && !state.timePenalized && state.stepElapsed > step.timeLimitSec) {
    state.timePenalized = true;
    const note = `เกินเวลา ${step.timeLimitSec} วิ — ${step.title}ต้องเร็วกว่านี้!`;
    const out = damage(state, op, op.wrongToolDamage, "ช้าเกินไป!", note);
    return out.kind === "op_failed" ? out : { kind: "too_slow", note };
  }
  return { kind: "noop" };
}

function fail(state: ResusState, note: string): ActionOutcome {
  state.dead = true;
  state.timeline.push({ t: state.elapsed, ok: false, text: "ผู้ป่วยไปไม่ไหว", note });
  return { kind: "op_failed", note };
}

function damage(state: ResusState, op: Operation, amount: number, text: string, note: string): ActionOutcome {
  state.wrong += 1;
  state.hp = Math.max(0, state.hp - amount * getDifficulty(state.difficulty).damageMult);
  state.timeline.push({ t: state.elapsed, ok: false, text, note });
  if (state.hp <= 0) return fail(state, note);
  return { kind: "noop" };
}

function resetGestureProgress(state: ResusState): void {
  state.tapsDone = 0;
  state.holdMs = 0;
  state.tracePct = 0;
  state.traceHits = [];
  state.lastTapMs = null;
}

/** เป้าปัจจุบันเสร็จ 1 จุด — เลื่อน sub/step และรายงานผล */
function completeTarget(state: ResusState, op: Operation): ActionOutcome {
  const step = op.steps[state.stepIdx];
  resetGestureProgress(state);

  if (step.subZones?.length && state.subIdx < step.subZones.length - 1) {
    state.subIdx += 1;
    return { kind: "sub_done", step };
  }

  if (step.recoverHp) state.hp = Math.min(state.maxHp, state.hp + step.recoverHp);
  if (step.isShock && state.firstShockAt < 0) state.firstShockAt = state.elapsed;

  state.timeline.push({ t: state.elapsed, ok: true, text: step.title, note: step.why });
  state.subIdx = 0;
  state.stepIdx += 1;
  state.stepElapsed = 0;
  state.timePenalized = false;
  if (state.stepIdx >= op.steps.length) {
    state.done = true;
    return { kind: "op_done", step };
  }
  return { kind: "step_done", step };
}

/**
 * ผู้เล่นแตะเวทีด้วยเครื่องมือที่ arm ไว้
 * - ไม่มีเครื่องมือ → noop (UI เตือนให้เลือกก่อน)
 * - เครื่องมือผิด → หัก HP เต็ม (ไม่ว่าจะแตะตรงไหน)
 * - ถูกเครื่องมือแต่นอกเป้า → หัก HP เบา
 * - ถูกทั้งคู่ → เดิน gesture
 *
 * nowMs = performance.now() จาก UI — ใช้วัดจังหวะของ gesture rhythm
 * (ห้ามใช้ Date.now ใน engine เพื่อให้เทสต์ควบคุมเวลาได้)
 */
export function pointerDown(state: ResusState, op: Operation, p: Point, nowMs?: number): ActionOutcome {
  if (state.done || state.dead) return { kind: "noop" };
  const step = currentStep(op, state);
  if (!step || !state.activeTool) return { kind: "noop" };

  if (state.activeTool !== step.tool) {
    const note =
      step.wrongToolWhy?.[state.activeTool] ??
      `ยังไม่ถึงจังหวะใช้${toolLabel(state.activeTool)} — ตอนนี้ต้อง${step.title}`;
    const out = damage(state, op, op.wrongToolDamage, "หยิบเครื่องมือผิดจังหวะ", note);
    return out.kind === "op_failed" ? out : { kind: "wrong_tool", note };
  }

  const zone = currentZone(op, state);
  if (!zone || !pointInZone(zone, p)) {
    const note = "ถูกเครื่องมือแล้ว แต่ผิดตำแหน่ง — ดูเป้าให้ดี";
    const out = damage(state, op, op.wrongZoneDamage, "ลงมือผิดตำแหน่ง", note);
    return out.kind === "op_failed" ? out : { kind: "wrong_zone", note };
  }

  const g = step.gesture;
  if (g.kind === "tap") return completeTarget(state, op);
  if (g.kind === "taps") {
    state.tapsDone += 1;
    if (state.tapsDone >= g.count) return completeTarget(state, op);
    return { kind: "step_progress" };
  }
  if (g.kind === "rhythm") {
    state.tapsDone += 1;
    let quality: "good" | "fast" | "slow" = "good";
    if (state.lastTapMs != null && nowMs != null) {
      const interval = nowMs - state.lastTapMs;
      const tol = g.toleranceBpm ?? RHYTHM_TOLERANCE_BPM_DEFAULT;
      if (interval < 60000 / (g.targetBpm + tol)) quality = "fast";
      else if (interval > 60000 / (g.targetBpm - tol)) quality = "slow";
      if (quality === "good") state.goodTaps += 1;
      else state.offTempoTaps += 1;
    } else {
      // tap แรกยังไม่มี interval ให้วัด — นับเป็นดีไว้ก่อน
      state.goodTaps += 1;
    }
    state.lastTapMs = nowMs ?? null;
    if (state.tapsDone >= g.count) return completeTarget(state, op);
    return { kind: "rhythm_feedback", quality };
  }
  if (g.kind === "hold") {
    state.holdMs = 0;
    return { kind: "step_progress" };
  }
  // trace: เริ่มนับจุดจากตำแหน่งกดครั้งแรกเลย
  const pts = tracePoints(g.path);
  if (state.traceHits.length !== pts.length) state.traceHits = new Array(pts.length).fill(false);
  state.tracePct = accumulateTrace(pts, state.traceHits, p, g.tolerance ?? TRACE_TOLERANCE_DEFAULT);
  if (state.tracePct >= TRACE_COMPLETE_PCT) return completeTarget(state, op);
  return { kind: "step_progress" };
}

/** ลากต่อเนื่อง (เฉพาะ gesture trace ระหว่างกดค้าง) — นอกเส้นไม่ลงโทษ แค่ไม่คืบ */
export function pointerMove(state: ResusState, op: Operation, p: Point): ActionOutcome {
  if (state.done || state.dead) return { kind: "noop" };
  const step = currentStep(op, state);
  if (!step || state.activeTool !== step.tool) return { kind: "noop" };
  const g = step.gesture;
  if (g.kind !== "trace" || !state.traceHits.length) return { kind: "noop" };
  const pts = tracePoints(g.path);
  state.tracePct = accumulateTrace(pts, state.traceHits, p, g.tolerance ?? TRACE_TOLERANCE_DEFAULT);
  if (state.tracePct >= TRACE_COMPLETE_PCT) return completeTarget(state, op);
  return { kind: "step_progress" };
}

/** กดค้างสะสมเวลา (เฉพาะ gesture hold ระหว่างกดค้างในเป้า) — เรียกถี่ๆ จาก UI */
export function holdTick(state: ResusState, op: Operation, dtMs: number): ActionOutcome {
  if (state.done || state.dead) return { kind: "noop" };
  const step = currentStep(op, state);
  if (!step || state.activeTool !== step.tool) return { kind: "noop" };
  if (step.gesture.kind !== "hold") return { kind: "noop" };
  state.holdMs += dtMs;
  if (state.holdMs >= step.gesture.ms) return completeTarget(state, op);
  return { kind: "step_progress" };
}

/** ปล่อยนิ้ว — hold ที่ยังไม่ครบเวลาถูกรีเซ็ต (ไม่ลงโทษ), trace เก็บ progress ไว้ */
export function pointerUp(state: ResusState): void {
  state.holdMs = 0;
}

// ---- จบเกม: เกรด/ดาว/คะแนน ----

export function gradeFor(state: ResusState, won: boolean): Grade {
  if (!won) return "C";
  if (getDifficulty(state.difficulty).gradeStrict) {
    if (state.wrong === 0) return "S";
    if (state.wrong === 1) return "B";
    return "C";
  }
  if (state.wrong === 0) return "S";
  if (state.wrong === 1) return "A";
  if (state.wrong <= 3) return "B";
  return "C";
}

export function starsFor(grade: Grade, won: boolean): number {
  if (!won) return 0;
  if (grade === "S") return 3;
  if (grade === "C") return 1;
  return 2;
}

/** 100 ตั้งต้น − 12/พลาด + โบนัสเวลา (เร็วกว่า par สูงสุด +30) + โบนัส HP (สูงสุด +20) */
export function scoreFor(state: ResusState, op: Operation, won: boolean): number {
  if (!won) return 0;
  const timeBonus =
    state.elapsed <= op.parTimeSec
      ? 30
      : Math.max(0, Math.round(30 * ((2 * op.parTimeSec - state.elapsed) / op.parTimeSec)));
  const hpBonus = Math.round(20 * (state.hp / state.maxHp));
  return Math.max(10, 100 - state.wrong * 12 + timeBonus + hpBonus);
}

/** คุณภาพจังหวะ (0..1) จาก tap ทั้งรอบ — null ถ้าด่านไม่มี gesture rhythm เลย */
export function cprQualityFor(state: ResusState): number | null {
  const total = state.goodTaps + state.offTempoTaps;
  if (total === 0) return null;
  return state.goodTaps / total;
}

/** คลื่นบนจอ monitor ณ step ปัจจุบัน — ใช้ค่า rhythm ล่าสุดที่ประกาศไว้ก่อนหน้า */
export function currentRhythm(op: Operation, state: ResusState): "vf" | "nsr" | "flat" | null {
  const idx = Math.min(state.stepIdx, op.steps.length - 1);
  for (let i = idx; i >= 0; i--) {
    const r = op.steps[i].rhythm;
    if (r) return r;
  }
  return null;
}

export function fmtTime(s: number): string {
  if (s < 0) return "--:--";
  const m = Math.floor(s / 60);
  const ss = Math.floor(s % 60);
  return `${String(m).padStart(2, "0")}:${String(ss).padStart(2, "0")}`;
}

function toolLabel(tool: ToolId): string {
  return TOOL_CATALOG[tool]?.name ?? tool;
}
