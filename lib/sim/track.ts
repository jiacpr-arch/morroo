// Payload builders สำหรับ analytics ของเกมเคส / Code Blue Sim
//
// แยกออกมาจาก SimRunner เพราะ vitest รันบน environment "node" — เทส React
// component ไม่ได้ แต่ตรรกะประกอบ payload (ซึ่งเป็นตัวที่พังเงียบแล้วทำให้
// แคมเปญโฆษณาวัดผลไม่ได้) ต้องมีเทสคุม
//
// ข้อจำกัดสำคัญ: track() รับ props เป็น Record<string, string|number|boolean|null>
// เท่านั้น (lib/analytics.ts) — ห้ามส่ง object/array ซ้อนลงไป

import type { SimState } from "./types";

/**
 * SimRunner ตัวเดียวเสิร์ฟทุกหมวด — Code Blue (acls), เกมเคสจาก Long Case
 * (longcase) และเกมเคสที่แปลงจากข้อสอบ MEQ (meq)
 */
export type CaseGameCategory = "acls" | "longcase" | "meq";

const KNOWN_CATEGORIES = new Set<CaseGameCategory>(["acls", "longcase", "meq"]);

export type TrackProps = Record<string, string | number | boolean | null>;

/** ชื่อ event — ใช้ชื่อเดียวครอบทั้งสองหมวด แล้วแยกด้วย prop `category` */
export const CASEGAME_EVENTS = {
  start: "casegame_start",
  /**
   * แตะเดินเรื่องครั้งแรกของรอบเล่น — ขั้นที่หายไประหว่าง start กับ firstDecision
   *
   * ก่อนหน้านี้ระหว่างสองตัวนั้นไม่มีอะไรคั่นเลย พอเห็นว่าคนจากโฆษณา 373 คน
   * เริ่มเล่นแต่ตัดสินใจข้อแรกแค่ 168 (45%) จึงบอกไม่ได้ว่าที่หายไปคือ "ไม่เคย
   * แตะสักครั้ง" (ปัญหาอยู่ที่จอแรก/ไม่รู้ว่าต้องทำอะไร) หรือ "แตะไปหลายทีแล้ว
   * เบื่อก่อนถึงตัวเลือกแรก" (ปัญหาอยู่ที่บทเกริ่นยาวไป) — สองอย่างนี้แก้คนละทาง
   */
  firstTap: "casegame_first_tap",
  firstDecision: "casegame_first_decision",
  complete: "casegame_complete",
  /**
   * ตัวหารของ CTA ท้ายเกม — ยิงตอน CTA โผล่บนจอ debrief
   *
   * ถ้ามีแต่ ctaClick อย่างเดียว เห็นเลข 0 แล้วแยกไม่ออกว่า "ไม่มีใครเล่นจนจบ",
   * "จบแล้วแต่ไม่กด" หรือ "CTA พัง" — ซึ่งเป็นสามปัญหาที่แก้คนละทางกันหมด
   */
  ctaView: "casegame_cta_view",
  /**
   * ปลายทางของ funnel นี้ตั้งแต่ 2026-07-25 — เดิมคือ `casegame_lead` (เก็บอีเมล)
   * แต่เจ้าของเลิกเก็บ lead แล้วเพราะไม่มีคนตามต่อ ตัวชี้ขาดจึงเป็น "คนเล่นจบ
   * แล้วกดเข้าไปดูเนื้อหาจริงในเว็บ" แทน ดู prop `target` ว่าเข้าหน้าไหน
   */
  ctaClick: "casegame_cta_click",
} as const;

/**
 * `category` ใน SimScenario เป็น string ล้วนและ optional — built-in ที่ไม่ระบุ
 * ถือเป็น acls (ตาม getSimScenariosByCategory) หมวดที่ไม่รู้จักก็ยุบเป็น acls
 * เช่นกัน แต่ต้องเพิ่มหมวดใหม่ที่นี่ทุกครั้ง ไม่งั้นสถิติจะติดป้ายผิด
 */
export function caseGameCategory(category?: string): CaseGameCategory {
  return category && KNOWN_CATEGORIES.has(category as CaseGameCategory)
    ? (category as CaseGameCategory)
    : "acls";
}

/**
 * `run_id` = 1 รอบการเล่น ต้องติดไปกับทุก event ของเกม
 *
 * เดิม runId ส่งเข้าแค่ Meta CAPI ทำให้ฝั่ง analytics_events ของเราเองต่อ
 * funnel ไม่ได้เลย: ในโหมด autostart การรีโหลดหน้าหนึ่งครั้งเท่ากับ start
 * หนึ่งครั้ง แยกจากการกด "เล่นอีกครั้ง" ไม่ออก และ start กับ complete จับคู่กัน
 * ได้แค่ระดับ session+slug ซึ่งพังทันทีที่คนเล่นเคสเดิมซ้ำ
 */
export interface RunScoped {
  /** id ต่อหนึ่งรอบเล่น (newRunId) — "" ถ้ายังไม่เริ่มรอบใหม่ */
  runId: string;
}

export interface StartInput extends RunScoped {
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
    run_id: input.runId,
  };
}

export interface FirstTapInput extends RunScoped {
  slug: string;
  category?: string;
  /** เวลาจริงตั้งแต่เริ่มรอบเล่นจนแตะครั้งแรก (ms) */
  msToFirstTap: number;
}

export function buildFirstTapProps(input: FirstTapInput): TrackProps {
  return {
    slug: input.slug,
    category: caseGameCategory(input.category),
    sec_to_first_tap: durationSeconds(input.msToFirstTap),
    run_id: input.runId,
  };
}

export interface FirstDecisionInput extends RunScoped {
  slug: string;
  category?: string;
  /**
   * จำนวนแตะเดินเรื่องก่อนถึงตัวเลือกแรก — ถ้าค่านี้สูงแปลว่าบทเกริ่นยาวเกินไป
   * ซึ่งเป็นคนละปัญหากับ "ไม่รู้ว่าต้องแตะตรงไหน" ที่แก้ไปแล้วใน #368
   */
  tapsBefore: number;
  /** เวลาจริงตั้งแต่เริ่มรอบเล่นจนตัดสินใจข้อแรก (ms) */
  msToFirstDecision: number;
}

export function buildFirstDecisionProps(input: FirstDecisionInput): TrackProps {
  return {
    slug: input.slug,
    category: caseGameCategory(input.category),
    taps_before: input.tapsBefore,
    sec_to_first_decision: durationSeconds(input.msToFirstDecision),
    run_id: input.runId,
  };
}

export interface CompleteInput extends RunScoped {
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
    run_id: input.runId,
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

export interface CtaViewInput extends RunScoped {
  slug: string;
  category?: string;
  /** เกรดที่เพิ่งได้ — ใช้ดูว่าคนเล่นที่ได้เกรดไหนเดินต่อเข้าเว็บมากกว่ากัน */
  grade: string | null;
}

export function buildCtaViewProps(input: CtaViewInput): TrackProps {
  return {
    slug: input.slug,
    category: caseGameCategory(input.category),
    grade: input.grade,
    run_id: input.runId,
  };
}

export interface CtaClickInput extends CtaViewInput {
  target: string;
}

export function buildCtaClickProps(input: CtaClickInput): TrackProps {
  return {
    ...buildCtaViewProps(input),
    target: input.target,
  };
}

// ---------------------------------------------------------------------------
// ฝั่ง Meta CAPI
// ---------------------------------------------------------------------------

/**
 * `first_decision` ส่งเข้า Meta ด้วย เพราะเมื่อโฆษณายิงเข้าโหมด autostart แล้ว
 * `start` จะเกิดทุกครั้งที่หน้าโหลด = มีค่าเท่ากับ Landing Page View ใช้เป็น
 * optimization target ไม่ได้อีกต่อไป — "ตัดสินใจข้อแรก" คือสัญญาณแรกที่พิสูจน์
 * ว่าคนคนนั้นเล่นจริง และยังมีปริมาณมากพอให้อัลกอริทึมเรียนรู้
 */
export type CaseGameCapiEvent = "start" | "first_decision" | "complete";

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
