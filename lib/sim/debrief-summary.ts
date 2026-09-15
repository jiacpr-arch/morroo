// ตัวช่วย pure สำหรับจอ debrief ท้ายเกมเคส (components/sim/DebriefResultCard.tsx
// + DebriefSignupCta.tsx) — แยกออกมาให้เทสต์ได้โดยไม่ต้อง render React
//
// ไม่มี I/O ทั้งไฟล์

import type { TimelineItem } from "./types";
import type { LocalRun } from "./local-progress";
import { weakSpecialties, type PlayedCase } from "@/lib/casegame/recommend";

export interface WeakestPoint {
  t: number;
  text: string;
  note: string | null;
  /** จำนวนจุดที่พลาดอื่นๆ นอกจากจุดนี้ — ใช้บอก "และอีก N จุด" */
  moreErrors: number;
}

/**
 * จุดที่พลาดที่ควรโชว์เด่นสุด — เลือกจุดแรกที่มี note (คำอธิบายว่าทำไมผิด)
 * ก่อน เพราะมีประโยชน์ต่อผู้เล่นมากกว่าจุดที่ผิดแต่ไม่มีคำอธิบาย ถ้าไม่มีจุด
 * ไหนมี note เลยก็ใช้จุดผิดแรกสุดแทน คืน null เมื่อไม่พลาดเลย
 */
export function weakestPoint(timeline: readonly TimelineItem[]): WeakestPoint | null {
  const errors = timeline.filter((it) => !it.ok);
  if (errors.length === 0) return null;
  const withNote = errors.find((it) => it.note && it.note.trim());
  const chosen = withNote ?? errors[0];
  return {
    t: chosen.t,
    text: chosen.text,
    note: chosen.note?.trim() || null,
    moreErrors: errors.length - 1,
  };
}

/** ห่อ weakSpecialties (lib/casegame/recommend.ts) ให้รับ LocalRun[] ของเกมเคสตรงๆ */
export function weakSpecialtiesFromLocal(history: readonly LocalRun[]): string[] {
  const played: PlayedCase[] = history.map((r) => ({
    slug: r.slug,
    specialty: r.specialty,
    won: r.won,
  }));
  return [...weakSpecialties(played)];
}

export type RankScope = "slug" | "category" | null;

export interface RankInput {
  won: boolean;
  scope: RankScope;
  sample: number;
  below: number;
  tie: number;
}

/**
 * ข้อความ "เทียบกับผู้เล่นอื่น" — เขียนให้ตรงกับความจริงเสมอ:
 *  - แพ้ (score 0) ไม่พูดว่า "ดีกว่า 0%" เพราะฟังดูแปลก ใช้ทวนความว่าไม่ได้
 *    แพ้คนเดียว
 *  - ตัวอย่างน้อยเกินจะเชื่อถือได้ (scope null) แต่ยังมีคนเล่นมาก่อนอย่างน้อย
 *    1 คน ให้บอก "คนที่ N" แทนเปอร์เซ็นต์ที่ไม่นิ่ง
 *  - ไม่มีข้อมูลเลย (sample 0) หรือดึงไม่สำเร็จ → คืน null ให้ UI ซ่อนแถวนี้ไป
 */
export function rankCopy(r: RankInput): string | null {
  if (r.sample <= 0) return null;

  if (!r.won) {
    const pct = Math.round((r.tie / r.sample) * 100);
    return `${pct}% ของคนที่เล่นเคสนี้ก็ยังไม่ผ่านเหมือนกัน — กลับมาแก้มือได้`;
  }

  if (r.scope === "slug" || r.scope === "category") {
    const pct = Math.round((r.below / r.sample) * 100);
    const scopeLabel = r.scope === "slug" ? "คนที่เล่นเคสนี้" : "คนที่เล่นเกมเคสหมวดนี้";
    return `คุณทำได้ดีกว่า ${pct}% ของ${scopeLabel} (จาก ${r.sample.toLocaleString("th-TH")} คน)`;
  }

  return `คุณเป็นผู้เล่นคนที่ ${(r.sample + 1).toLocaleString("th-TH")} ของเคสนี้`;
}

/** หัวข้อ CTA สมัครฟรี — ใช้ยศ+จำนวนเคสจริงเมื่อมีให้เห็นภาพเป็นรูปธรรม */
export function ctaTitle({
  localRuns,
  rankTitle,
}: {
  localRuns: number;
  rankTitle: string | null;
}): string {
  if (localRuns > 1 && rankTitle) {
    return `สมัครฟรี — เก็บยศ "${rankTitle}" และ ${localRuns} เคสที่เล่นไว้ให้ถาวร`;
  }
  return "สมัครฟรี — เก็บผลเคสนี้ไว้ในบัญชีของคุณ";
}
