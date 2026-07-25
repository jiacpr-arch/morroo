// บันทึกผลการเล่นลง Supabase + แจก XP/Badge (client-safe)
//
// ผู้เล่นที่ไม่ได้ล็อกอินเล่นได้ปกติ — แค่ไม่บันทึกผล/ไม่ได้ XP
// ทุกอย่าง non-blocking: พังเงียบๆ ไม่ทำให้จอ debrief ค้าง

import { createClient } from "@/lib/supabase/client";
import { awardBadge, awardXp } from "@/lib/school/xp";
import { NO_RANK_DELTA, rankDelta, readSchoolXp } from "@/lib/school/rank-delta";
import type { RankProgress } from "@/lib/school/rank";
import { normalizeSpecialty, OTHER_SPECIALTY } from "@/lib/casegame/normalize";
import {
  EXPERT_LEVEL,
  expertiseFor,
  summarizeExpertise,
  type ExpertiseRun,
  type SpecialtyExpertise,
} from "./expertise";
import type { Grade, SimState } from "./types";

/** XP ตามเกรด (แพ้ได้ปลอบใจ 10) — ระดับเดียวกับ challenge ของ school */
export const SIM_XP: Record<Grade, number> = { S: 150, A: 100, B: 60, C: 30 };
export const SIM_XP_LOSS = 10;

/** เพดานประวัติที่ดึงมาคิดความเชี่ยวชาญ — พอสำหรับผู้เล่นหนักสุดโดยไม่ดึงทั้งตาราง */
const EXPERTISE_HISTORY_LIMIT = 500;

export interface SimRunResult {
  won: boolean;
  grade: Grade;
  score: number;
}

export interface RecordedRun {
  loggedIn: boolean;
  xpEarned: number;
  newBadges: string[];
  /** ยศก่อน/หลังรอบนี้ — null เมื่อไม่ได้ล็อกอินหรืออ่าน XP ไม่สำเร็จ */
  rankBefore: RankProgress | null;
  rankAfter: RankProgress | null;
  rankedUp: boolean;
  /** ความเชี่ยวชาญของสาขาที่เพิ่งเล่น — null เมื่อเคสนี้ไม่มีสาขา */
  expertise: SpecialtyExpertise | null;
  /** ความเชี่ยวชาญสาขานี้ขยับขั้นจากรอบนี้ */
  expertiseUp: boolean;
}

function emptyRun(): RecordedRun {
  return {
    loggedIn: false,
    xpEarned: 0,
    newBadges: [],
    ...NO_RANK_DELTA,
    expertise: null,
    expertiseUp: false,
  };
}

type Supabase = ReturnType<typeof createClient>;

/**
 * สาขาที่เอาไปเก็บ/นับความเชี่ยวชาญ — normalize ให้เป็นชื่อไทยมาตรฐานก่อนเสมอ
 * ไม่งั้น "Surgery" กับ "ศัลยศาสตร์" จะกลายเป็นคนละสาขาแล้วไต่ขั้นไม่ถึงสักอัน
 *
 * "อื่น ๆ" ถือว่าไม่มีสาขา — เอามานับรวมกันจะทำให้ถังนี้บวมจนแซงสาขาจริง
 */
function specialtyForRun(raw?: string | null): string | null {
  if (!raw?.trim()) return null;
  const canonical = normalizeSpecialty(raw);
  return canonical === OTHER_SPECIALTY ? null : canonical;
}

export async function recordSimRun(
  scenarioSlug: string,
  state: SimState,
  result: SimRunResult,
  specialtyRaw?: string | null,
): Promise<RecordedRun> {
  const out = emptyRun();
  try {
    const supabase = createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return out;
    out.loggedIn = true;

    const specialty = specialtyForRun(specialtyRaw);
    const xpBefore = await readSchoolXp(user.id);

    await supabase.from("sim_runs").insert({
      user_id: user.id,
      scenario_slug: scenarioSlug,
      specialty,
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

    if (specialty) {
      const expertise = await readExpertise(supabase, user.id, specialty);
      if (expertise) {
        out.expertise = expertise;
        // รอบนี้ถูกนับไปแล้ว — ย้อนออกเพื่อดูว่าเป็นรอบที่ทำให้ขยับขั้นหรือเปล่า
        const winsBefore = result.won ? expertise.wins - 1 : expertise.wins;
        out.expertiseUp = expertise.tier.level > expertiseFor(winsBefore).level;
        if (expertise.tier.level >= EXPERT_LEVEL && (await awardBadge("sim_specialist"))) {
          out.newBadges.push("sim_specialist");
        }
      }
    }

    // อ่านหลังแจกเหรียญ เพราะเหรียญแถม XP ด้วย (awardBadge → awardXp)
    Object.assign(out, rankDelta(xpBefore, await readSchoolXp(user.id)));
  } catch {
    // Non-blocking
  }
  return out;
}

/** ความเชี่ยวชาญของสาขาเดียวจากประวัติทั้งหมดของผู้ใช้ (รวมรอบที่เพิ่งบันทึก) */
async function readExpertise(
  supabase: Supabase,
  userId: string,
  specialty: string,
): Promise<SpecialtyExpertise | null> {
  const { data } = await supabase
    .from("sim_runs")
    .select("specialty, won")
    .eq("user_id", userId)
    .not("specialty", "is", null)
    .order("created_at", { ascending: false })
    .limit(EXPERTISE_HISTORY_LIMIT);
  const rows = (data as ExpertiseRun[] | null) ?? [];
  // normalize อีกชั้นเพราะแถวที่ backfill มาเก็บค่าดิบไว้ (ไทย/อังกฤษปนกัน)
  const runs = rows.map((r) => ({ specialty: specialtyForRun(r.specialty), won: r.won }));
  return summarizeExpertise(runs).find((s) => s.specialty === specialty) ?? null;
}

export const SIM_BADGE_NAMES: Record<string, string> = {
  sim_first_rosc: "กู้ชีพสำเร็จครั้งแรก",
  sim_grade_s: "Team Leader เกรด S",
  sim_no_mistake: "ไร้ที่ติ — ไม่พลาดสักคำสั่ง",
  sim_specialist: "ผู้เชี่ยวชาญเฉพาะสาขา",
};
