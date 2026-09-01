// Story engine — ส่วน logic ล้วนของเกมตัดสินใจ (ไม่มี DOM/React)
//
// ตอบถูก → node ใน then ของตัวเลือกถูก run ก่อนแล้วไปข้อถัดไป
// ตอบผิด → หัก HP, เล่นจุดตัดสินใจเดิมซ้ำ (สภาพแย่ลงแล้ว)

import type {
  ChoiceOption,
  Grade,
  NodeFx,
  SimState,
  StoryNode,
} from "./types";

export interface Difficulty {
  id: string;
  label: string;
  decisionTime: number;
  hp: number;
  hints: boolean;
  showWhyOnWrong: boolean;
  gradeStrict: boolean;
}

// ระดับความยาก — คุมเวลาตัดสินใจ, จำนวน HP, การใบ้/เฉลย, และความเข้มของ grade
export const DIFFICULTY: Record<string, Difficulty> = {
  easy: { id: "easy", label: "ง่าย", decisionTime: 30, hp: 7, hints: true, showWhyOnWrong: true, gradeStrict: false },
  normal: { id: "normal", label: "ปกติ", decisionTime: 20, hp: 5, hints: false, showWhyOnWrong: true, gradeStrict: false },
  hard: { id: "hard", label: "ยาก", decisionTime: 12, hp: 3, hints: false, showWhyOnWrong: false, gradeStrict: true },
};
export const DEFAULT_DIFFICULTY = "normal";

export function getDifficulty(id: string): Difficulty {
  return DIFFICULTY[id] || DIFFICULTY[DEFAULT_DIFFICULTY];
}

export function createInitialState(difficultyId: string = DEFAULT_DIFFICULTY): SimState {
  const diff = getDifficulty(difficultyId);
  return {
    difficulty: diff.id,
    ptr: 0,
    queue: [],
    simTime: 0,
    hp: diff.hp,
    maxHp: diff.hp,
    rhythm: "flat",
    cpr: false,
    alarm: false,
    shocks: 0,
    epis: 0,
    wrong: 0,
    firstCPRAt: -1,
    firstShockAt: -1,
    rosc: false,
    timeline: [],
    etco2Trace: [], // ค่าสะท้อนคุณภาพ CPR ตามเวลา สำหรับกราฟใน debrief
  };
}

// EtCO2 (mmHg) สะท้อนคุณภาพ CPR: 0 ก่อนเริ่มกด, ~15 ระหว่าง CPR (ตกเมื่อพลาด),
// พุ่ง ~40 เมื่อ ROSC — ใช้ทำ sparkline สอนผู้เรียน
export function currentEtco2(state: SimState): number {
  if (state.rosc) return 40;
  if (!state.cpr) return 0;
  return Math.max(6, 16 - state.wrong * 2);
}

export function pushEtco2(state: SimState): void {
  state.etco2Trace.push({ t: state.simTime, v: currentEtco2(state) });
}

// ผลของ node ต่อสถานะผู้ป่วย/เคส (mutate state ที่ถือใน ref ของหน้าเกม)
export function applyFx(state: SimState, fx?: NodeFx): void {
  if (!fx) return;
  if (fx.alarm) state.alarm = true;
  if (fx.cpr) state.cpr = true;
  if (fx.rhythm) state.rhythm = fx.rhythm;
  if (fx.firstCPR && state.firstCPRAt < 0) state.firstCPRAt = state.simTime;
  if (fx.epi) state.epis += 1;
  if (fx.shock) {
    state.shocks += 1;
    state.cpr = false;
    if (state.firstShockAt < 0) state.firstShockAt = state.simTime;
  }
  if (fx.rosc) {
    state.rosc = true;
    state.rhythm = "nsr";
    state.cpr = false;
    state.alarm = false;
  }
}

// ดึง node ถัดไป — queue (จาก then ของตัวเลือก) มาก่อน story หลัก
export function nextNode(state: SimState, story: StoryNode[]): StoryNode | null {
  if (state.queue.length) return state.queue.shift() ?? null;
  if (state.ptr < story.length) return story[state.ptr++];
  return null;
}

export function recordCorrect(state: SimState, option: ChoiceOption): void {
  state.timeline.push({ t: state.simTime, ok: true, text: option.label });
  state.simTime += 8;
  state.queue.push(...(option.then || []));
}

export function recordWrong(state: SimState, option: ChoiceOption): void {
  state.wrong += 1;
  state.hp = Math.max(0, state.hp - 1);
  state.simTime += 20; // ความผิดพลาดกินเวลาเสมอ
  state.timeline.push({
    t: state.simTime,
    ok: false,
    text: option.timeout ? "(หมดเวลา — ไม่มีคำสั่ง)" : "สั่งผิดจังหวะ",
    note: option.why,
  });
}

export function gradeFor(state: SimState, won: boolean): Grade {
  if (!won) return "C";
  const strict = getDifficulty(state.difficulty).gradeStrict;
  if (strict) {
    // โหมดยาก: เกณฑ์เข้มขึ้น (ผิดแม้ครั้งเดียวก็ตกจาก S)
    if (state.wrong === 0) return "S";
    if (state.wrong === 1) return "B";
    return "C";
  }
  if (state.wrong === 0) return "S";
  if (state.wrong === 1) return "A";
  if (state.wrong <= 3) return "B";
  return "C";
}

export function scoreFor(state: SimState, won: boolean): number {
  return won ? Math.max(10, 100 - state.wrong * 15) : 0;
}

export function fmtTime(s: number): string {
  if (s < 0) return "--:--";
  const m = Math.floor(s / 60);
  const ss = Math.floor(s % 60);
  return `${String(m).padStart(2, "0")}:${String(ss).padStart(2, "0")}`;
}

export function shuffled<T>(arr: T[]): T[] {
  const a = [...arr];
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}
