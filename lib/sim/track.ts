// Payload builders สำหรับ analytics ของเกมเคส / Code Blue Sim
//
// แยกออกมาจาก SimRunner เพราะ vitest รันบน environment "node" — เทส React
// component ไม่ได้ แต่ตรรกะประกอบ payload (ซึ่งเป็นตัวที่พังเงียบแล้วทำให้
// แคมเปญโฆษณาวัดผลไม่ได้) ต้องมีเทสคุม
//
// ข้อจำกัดสำคัญ: track() รับ props เป็น Record<string, string|number|boolean|null>
// เท่านั้น (lib/analytics.ts) — ห้ามส่ง object/array ซ้อนลงไป

import type { SimState } from "./types";

/** SimRunner ตัวเดียวเสิร์ฟทั้ง Code Blue (acls) และเกมเคส (longcase) */
export type CaseGameCategory = "acls" | "longcase";

export type TrackProps = Record<string, string | number | boolean | null>;

/** ชื่อ event — ใช้ชื่อเดียวครอบทั้งสองหมวด แล้วแยกด้วย prop `category` */
export const CASEGAME_EVENTS = {
  start: "casegame_start",
  firstDecision: "casegame_first_decision",
  complete: "casegame_complete",
  ctaClick: "casegame_cta_click",
  /**
   * ยิงคู่กับ `lp_lead_form_submit` ตอนเก็บ lead ได้ท้ายเกม — ต้องเป็นชื่อ event
   * แยก เพราะหน้าแอดมินอ่าน analytics_events โดยไม่ดึงคอลัมน์ properties
   * (จำกัด 50k แถว) จึงแยก lead ของเกมด้วย prop ไม่ได้
   */
  lead: "casegame_lead",
} as const;

/** `category` ใน SimScenario เป็น string ล้วนและ optional — built-in ที่ไม่ระบุถือเป็น acls */
export function caseGameCategory(category?: string): CaseGameCategory {
  return category === "longcase" ? "longcase" : "acls";
}

export interface StartInput {
  slug: string;
  category?: string;
  difficulty: string;
  /** true เมื่อกดจากปุ่ม "เล่นเคสนี้อีกครั้ง" ในหน้า debrief */
  isReplay: boolean;
  sourceCaseId?: string | null;
}

export function buildStartProps(input: StartInput): TrackProps {
  return {
    slug: input.slug,
    category: caseGameCategory(input.category),
    difficulty: input.difficulty,
    is_replay: input.isReplay,
    source_case_id: input.sourceCaseId ?? null,
  };
}

export interface FirstDecisionInput {
  slug: string;
  category?: string;
}

export function buildFirstDecisionProps(input: FirstDecisionInput): TrackProps {
  return {
    slug: input.slug,
    category: caseGameCategory(input.category),
  };
}

export interface CompleteInput {
  slug: string;
  category?: string;
  state: Pick<SimState, "difficulty" | "wrong" | "simTime">;
  won: boolean;
  grade: string;
  score: number;
  isHiscore: boolean;
  /** เวลาจริงที่ใช้เล่น (ms) — ไม่ใช่ simTime ซึ่งเป็นนาฬิกาในเนื้อเรื่อง */
  durationMs: number;
}

export function buildCompleteProps(input: CompleteInput): TrackProps {
  return {
    slug: input.slug,
    category: caseGameCategory(input.category),
    difficulty: input.state.difficulty,
    won: input.won,
    grade: input.grade,
    score: input.score,
    wrong: input.state.wrong,
    sim_time: input.state.simTime,
    duration_sec: durationSeconds(input.durationMs),
    is_hiscore: input.isHiscore,
  };
}

/**
 * ms → วินาที (ปัดลง ไม่ติดลบ) — startedAt อาจเป็น 0 ได้ถ้า mount แล้วเข้า
 * debrief โดยไม่ผ่าน startGame ซึ่งจะทำให้ค่าเพี้ยนมหาศาล จึงตัดเป็น 0
 */
export function durationSeconds(durationMs: number): number {
  if (!Number.isFinite(durationMs) || durationMs <= 0) return 0;
  return Math.round(durationMs / 1000);
}

export interface CtaClickInput {
  slug: string;
  category?: string;
  grade: string | null;
  target: string;
}

export function buildCtaClickProps(input: CtaClickInput): TrackProps {
  return {
    slug: input.slug,
    category: caseGameCategory(input.category),
    grade: input.grade,
    target: input.target,
  };
}

// ---------------------------------------------------------------------------
// ฝั่ง Meta CAPI
// ---------------------------------------------------------------------------

export type CaseGameCapiEvent = "start" | "complete";

/**
 * content_name ที่ใช้สร้าง Custom Conversion ใน Events Manager
 * (กติกา: content_name ขึ้นต้นด้วย "casegame_start")
 */
export function capiContentName(event: CaseGameCapiEvent, slug: string): string {
  return `casegame_${event}:${slug}`;
}

/**
 * eventId ผูกกับ runId (1 รอบการเล่น = 1 id) เพื่อให้การยิงซ้ำจากการ retry
 * ของ beacon ไม่ถูกนับเป็นสอง conversion
 */
export function capiEventId(event: CaseGameCapiEvent, runId: string): string {
  return `casegame:${event}:${runId}`;
}

/** id ต่อหนึ่งรอบการเล่น — ผูก start/complete คู่เดียวกันเข้าด้วยกัน */
export function newRunId(): string {
  if (typeof crypto !== "undefined" && crypto.randomUUID) return crypto.randomUUID();
  return `r-${Date.now().toString(36)}-${Math.random().toString(36).slice(2, 10)}`;
}

/**
 * ยิง conversion เข้า Meta ผ่าน server (app/api/track/casegame) — fire-and-forget
 * keepalive เพื่อให้รอดตอนผู้ใช้กดออกจากหน้าทันทีหลังเล่นจบ
 */
export function sendCaseGameCapi(
  event: CaseGameCapiEvent,
  slug: string,
  runId: string
): void {
  if (typeof window === "undefined") return;
  try {
    void fetch("/api/track/casegame", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ event, slug, runId }),
      keepalive: true,
    }).catch(() => {});
  } catch {
    // analytics ต้องไม่ทำให้เกมพัง
  }
}
