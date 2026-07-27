// เลือกเคสถัดไปให้ผู้เล่น แทนการสุ่มมั่ว
//
// ทำไมต้องมี: ปุ่ม "สุ่มเคสถัดไป" สุ่มแบบ uniform จาก 157 เคส โดยไม่สนใจว่า
// ผู้เล่นเพิ่งพลาดสาขาอะไร เคยเล่นเคสนี้แล้วหรือยัง หรืออยู่ระดับไหน ผลคือคน
// แตะจริงแค่ 14 จาก 157 เคส (8%) — คนที่เพิ่งแพ้เคส sepsis กดปุ่มแล้วอาจได้
// เคสจักษุระดับยาก แล้วก็ปิดไป
//
// pure ทั้งไฟล์ (ไม่มี I/O, ไม่สุ่ม) — ผลลัพธ์คงที่สำหรับ input เดิม จึงเทสต์ได้
// และ debrief กับ route สุ่มใช้ตัวเดียวกันได้

import type { Difficulty } from "./normalize";

export interface CaseCandidate {
  slug: string;
  title: string;
  /** สาขาไทยที่ normalize แล้ว — "" เมื่อไม่มีสาขา (เช่นเคส ACLS) */
  specialty: string;
  difficulty: Difficulty;
}

/** ประวัติหนึ่งรอบที่ผู้เล่นเคยเล่น (จาก sim_runs หรือ localStorage) */
export interface PlayedCase {
  slug: string;
  specialty: string | null;
  won: boolean;
}

export interface Recommendation extends CaseCandidate {
  /** เหตุผลที่แนะนำ — แสดงให้ผู้เล่นเห็น ไม่ใช่แค่โยนเคสมาเฉยๆ */
  reason: string;
}

export interface RecommendInput {
  /** เคสที่เพิ่งเล่นจบ — ไม่แนะนำซ้ำตัวเอง */
  excludeSlug?: string;
  /** ผลของรอบที่เพิ่งจบ ใช้ปรับความยากของเคสถัดไป */
  lastWon?: boolean;
  lastGrade?: string | null;
  limit?: number;
}

const DEFAULT_LIMIT = 3;

/**
 * น้ำหนักการให้คะแนน — ตั้งให้ "สาขาที่เพิ่งพลาด" ชนะทุกอย่าง เพราะเป็นสัญญาณ
 * เดียวที่บอกว่าผู้เล่นยังไม่แม่นเรื่องอะไร ส่วนที่เหลือเป็นตัวคั่นลำดับ
 */
const W = {
  weakSpecialty: 50,
  neverPlayed: 20,
  retryLost: 15,
  alreadyWon: -100,
  difficultyMatch: 15,
  difficultyMismatch: -10,
} as const;

/** สาขาที่ผู้เล่นเคยแพ้และยังไม่เคยชนะเลย = จุดอ่อนที่ยังไม่ได้แก้ */
export function weakSpecialties(history: readonly PlayedCase[]): Set<string> {
  const lost = new Set<string>();
  const won = new Set<string>();
  for (const run of history) {
    const s = run.specialty?.trim();
    if (!s) continue;
    (run.won ? won : lost).add(s);
  }
  for (const s of won) lost.delete(s);
  return lost;
}

/**
 * ความยากที่อยากได้ในรอบถัดไป
 *   แพ้        → ถอยลงมาตั้งหลัก
 *   ชนะเกรด S  → ดันขึ้นไปอีกขั้น
 *   นอกนั้น    → คงระดับ (null = ไม่มีความชอบ)
 */
export function preferredDifficulty(
  lastWon?: boolean,
  lastGrade?: string | null,
): Difficulty | null {
  if (lastWon === false) return "ง่าย";
  if (lastWon === true && lastGrade === "S") return "ยาก";
  return null;
}

function reasonFor(
  candidate: CaseCandidate,
  weak: Set<string>,
  played: Map<string, PlayedCase>,
  want: Difficulty | null,
): string {
  // "เคยพลาดเคสนี้" เจาะจงกว่า "พลาดสาขานี้" จึงต้องมาก่อน ไม่งั้นเคสที่เขา
  // แพ้มากับมือจะขึ้นเหตุผลกว้างๆ ว่าอ่อนทั้งสาขา ซึ่งบอกอะไรเขาน้อยกว่า
  const prev = played.get(candidate.slug);
  if (prev && !prev.won) return "เคยพลาดเคสนี้ — กลับมาแก้มือ";
  if (candidate.specialty && weak.has(candidate.specialty)) {
    return `คุณเพิ่งพลาดเรื่อง${candidate.specialty}`;
  }
  if (want === "ง่าย" && candidate.difficulty === "ง่าย") {
    return "เริ่มจากเคสที่ง่ายกว่าเพื่อตั้งหลัก";
  }
  if (want === "ยาก" && candidate.difficulty === "ยาก") {
    return "ทำได้ดีมาก — ลองเคสที่ยากขึ้น";
  }
  if (!prev) return "เคสที่คุณยังไม่เคยเล่น";
  return "เล่นต่อได้เลย";
}

function scoreFor(
  candidate: CaseCandidate,
  weak: Set<string>,
  played: Map<string, PlayedCase>,
  want: Difficulty | null,
): number {
  let score = 0;

  if (candidate.specialty && weak.has(candidate.specialty)) score += W.weakSpecialty;

  const prev = played.get(candidate.slug);
  if (!prev) score += W.neverPlayed;
  else if (prev.won) score += W.alreadyWon;
  else score += W.retryLost;

  if (want) {
    score += candidate.difficulty === want ? W.difficultyMatch : W.difficultyMismatch;
  }

  return score;
}

/**
 * จัดอันดับเคสถัดไป — คืนรายการพร้อมเหตุผล เรียงจากเหมาะสุด
 *
 * เคสที่ชนะไปแล้วถูกดันลงท้ายสุด (ไม่ตัดทิ้ง) เผื่อกรณีที่ผู้เล่นชนะไปหมดแล้ว
 * จะได้ยังมีอะไรให้แนะนำ ไม่ใช่คืนลิสต์ว่าง
 */
export function recommendNextCases(
  candidates: readonly CaseCandidate[],
  history: readonly PlayedCase[],
  input: RecommendInput = {},
): Recommendation[] {
  const { excludeSlug, lastWon, lastGrade, limit = DEFAULT_LIMIT } = input;

  const weak = weakSpecialties(history);
  const want = preferredDifficulty(lastWon, lastGrade);
  // รอบล่าสุดของแต่ละเคสชนะ = ถือว่าผ่านแล้ว
  const played = new Map<string, PlayedCase>();
  for (const run of history) {
    const prev = played.get(run.slug);
    played.set(run.slug, prev?.won ? prev : run);
  }

  return candidates
    .filter((c) => c.slug !== excludeSlug)
    .map((c) => ({ candidate: c, score: scoreFor(c, weak, played, want) }))
    // เรียงด้วย slug เป็นตัวตัดสินสุดท้าย ให้ผลคงที่ ไม่กระโดดไปมาระหว่างรีเฟรช
    .sort((a, b) => b.score - a.score || a.candidate.slug.localeCompare(b.candidate.slug))
    .slice(0, Math.max(0, limit))
    .map(({ candidate }) => ({
      ...candidate,
      reason: reasonFor(candidate, weak, played, want),
    }));
}
