// บันทึกผลการเล่นลง Supabase + แจก XP/Badge (client-safe)
//
// ผู้เล่นที่ไม่ได้ล็อกอินเล่นได้ปกติ — แค่ไม่บันทึกผล/ไม่ได้ XP
// ทุกอย่าง non-blocking: พังเงียบๆ ไม่ทำให้จอ debrief ค้าง
// (โครงเดียวกับ lib/sim/record.ts — เกมสองตัวให้ XP อัตราเดียวกัน)

import { createClient } from "@/lib/supabase/client";
import { awardBadge, awardXp } from "@/lib/school/xp";
import type { Grade, ResusState } from "./types";

export const RESUS_XP: Record<Grade, number> = { S: 150, A: 100, B: 60, C: 30 };
export const RESUS_XP_LOSS = 10;

export interface ResusRunResult {
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

export async function recordResusRun(
  operationSlug: string,
  state: ResusState,
  result: ResusRunResult,
): Promise<RecordedRun> {
  const out: RecordedRun = { loggedIn: false, xpEarned: 0, newBadges: [] };
  try {
    const supabase = createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return out;
    out.loggedIn = true;

    await supabase.from("resus_runs").insert({
      user_id: user.id,
      case_slug: operationSlug,
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

    const xp = result.won ? RESUS_XP[result.grade] : RESUS_XP_LOSS;
    await awardXp(xp, `resus:${operationSlug}:${result.won ? result.grade : "loss"}`);
    out.xpEarned = xp;

    if (result.won) {
      if (await awardBadge("resus_first_save")) out.newBadges.push("resus_first_save");
      if (result.grade === "S" && (await awardBadge("resus_grade_s"))) {
        out.newBadges.push("resus_grade_s");
      }
      if (state.wrong === 0 && state.difficulty !== "easy" && (await awardBadge("resus_perfect_code"))) {
        out.newBadges.push("resus_perfect_code");
      }
    }
  } catch {
    // Non-blocking
  }
  return out;
}

export const RESUS_BADGE_NAMES: Record<string, string> = {
  resus_first_save: "กู้ชีพสำเร็จด้วยมือตัวเอง",
  resus_grade_s: "มือกู้ชีพเกรด S",
  resus_perfect_code: "Perfect Code — ไม่พลาดสักจังหวะ",
};
