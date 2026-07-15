// บันทึกผลการเล่นลง Supabase + แจก XP/Badge (client-safe)
//
// ผู้เล่นที่ไม่ได้ล็อกอินเล่นได้ปกติ — แค่ไม่บันทึกผล/ไม่ได้ XP
// ทุกอย่าง non-blocking: พังเงียบๆ ไม่ทำให้จอ debrief ค้าง
// (โครงเดียวกับ lib/sim/record.ts — เกมสองตัวให้ XP อัตราเดียวกัน)

import { createClient } from "@/lib/supabase/client";
import { awardBadge, awardXp } from "@/lib/school/xp";
import type { Grade, SurgeryState } from "./types";

export const SURGERY_XP: Record<Grade, number> = { S: 150, A: 100, B: 60, C: 30 };
export const SURGERY_XP_LOSS = 10;

export interface SurgeryRunResult {
  won: boolean;
  grade: Grade;
  score: number;
  stars: number;
}

export interface RecordedRun {
  loggedIn: boolean;
  xpEarned: number;
  newBadges: string[];
}

export async function recordSurgeryRun(
  operationSlug: string,
  state: SurgeryState,
  result: SurgeryRunResult,
): Promise<RecordedRun> {
  const out: RecordedRun = { loggedIn: false, xpEarned: 0, newBadges: [] };
  try {
    const supabase = createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return out;
    out.loggedIn = true;

    await supabase.from("surgery_runs").insert({
      user_id: user.id,
      operation_slug: operationSlug,
      difficulty: state.difficulty,
      won: result.won,
      grade: result.grade,
      score: result.score,
      stars: result.stars,
      wrong_count: state.wrong,
      duration_sec: Math.round(state.elapsed),
      hp_left: Math.round(state.hp),
      metrics: { timeline: state.timeline },
    });

    const xp = result.won ? SURGERY_XP[result.grade] : SURGERY_XP_LOSS;
    await awardXp(xp, `surgery:${operationSlug}:${result.won ? result.grade : "loss"}`);
    out.xpEarned = xp;

    if (result.won) {
      if (await awardBadge("surgery_first_op")) out.newBadges.push("surgery_first_op");
      if (result.grade === "S" && (await awardBadge("surgery_grade_s"))) {
        out.newBadges.push("surgery_grade_s");
      }
      if (state.wrong === 0 && state.difficulty !== "easy" && (await awardBadge("surgery_steady_hands"))) {
        out.newBadges.push("surgery_steady_hands");
      }
    }
  } catch {
    // Non-blocking
  }
  return out;
}

export const SURGERY_BADGE_NAMES: Record<string, string> = {
  surgery_first_op: "หัตถการแรกสำเร็จ",
  surgery_grade_s: "ศัลยแพทย์เกรด S",
  surgery_steady_hands: "มือนิ่ง — ไม่พลาดสักจังหวะ",
};
