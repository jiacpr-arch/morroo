// บันทึกผลการเล่นลง Supabase + แจก XP/Badge (client-safe)
//
// ผู้เล่นที่ไม่ได้ล็อกอินเล่นได้ปกติ — แค่ไม่บันทึกผล/ไม่ได้ XP
// ทุกอย่าง non-blocking: พังเงียบๆ ไม่ทำให้จอ debrief ค้าง

import { createClient } from "@/lib/supabase/client";
import { awardBadge, awardXp } from "@/lib/school/xp";
import type { Grade, SimState } from "./types";

/** XP ตามเกรด (แพ้ได้ปลอบใจ 10) — ระดับเดียวกับ challenge ของ school */
export const SIM_XP: Record<Grade, number> = { S: 150, A: 100, B: 60, C: 30 };
export const SIM_XP_LOSS = 10;

export interface SimRunResult {
  won: boolean;
  grade: Grade;
  score: number;
}

export interface RecordedRun {
  loggedIn: boolean;
  xpEarned: number;
  newBadges: string[];
}

export async function recordSimRun(
  scenarioSlug: string,
  state: SimState,
  result: SimRunResult,
): Promise<RecordedRun> {
  const out: RecordedRun = { loggedIn: false, xpEarned: 0, newBadges: [] };
  try {
    const supabase = createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return out;
    out.loggedIn = true;

    await supabase.from("sim_runs").insert({
      user_id: user.id,
      scenario_slug: scenarioSlug,
      difficulty: state.difficulty,
      won: result.won,
      grade: result.grade,
      score: result.score,
      wrong_count: state.wrong,
      time_to_cpr_sec: state.firstCPRAt >= 0 ? state.firstCPRAt : null,
      time_to_shock_sec: state.firstShockAt >= 0 ? state.firstShockAt : null,
      duration_sec: state.simTime,
      metrics: {
        shocks: state.shocks,
        epis: state.epis,
        etco2_trace: state.etco2Trace,
        timeline: state.timeline,
      },
    });

    const xp = result.won ? SIM_XP[result.grade] : SIM_XP_LOSS;
    await awardXp(xp, `sim:${scenarioSlug}:${result.won ? result.grade : "loss"}`);
    out.xpEarned = xp;

    if (result.won) {
      if (await awardBadge("sim_first_rosc")) out.newBadges.push("sim_first_rosc");
      if (result.grade === "S" && (await awardBadge("sim_grade_s"))) {
        out.newBadges.push("sim_grade_s");
      }
      if (state.wrong === 0 && state.difficulty !== "easy" && (await awardBadge("sim_no_mistake"))) {
        out.newBadges.push("sim_no_mistake");
      }
    }
  } catch {
    // Non-blocking
  }
  return out;
}

export const SIM_BADGE_NAMES: Record<string, string> = {
  sim_first_rosc: "กู้ชีพสำเร็จครั้งแรก",
  sim_grade_s: "Team Leader เกรด S",
  sim_no_mistake: "ไร้ที่ติ — ไม่พลาดสักคำสั่ง",
};
