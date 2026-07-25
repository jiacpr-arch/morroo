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
import {
  appendLocalRun,
  clearLocalRuns,
  readLocalRuns,
  summarizeLocal,
} from "./local-progress";
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
  /**
   * ยศ/XP ที่แสดงมาจาก localStorage ไม่ใช่บัญชีจริง — จอ debrief ต้องบอกผู้เล่น
   * ตามตรงว่ายังไม่ถาวรจนกว่าจะล็อกอิน
   */
  isLocal: boolean;
  /** จำนวนรอบที่เก็บไว้ในเครื่อง (โหมดยังไม่ล็อกอิน) */
  localRuns: number;
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
    isLocal: false,
    localRuns: 0,
    xpEarned: 0,
    newBadges: [],
    ...NO_RANK_DELTA,
    expertise: null,
    expertiseUp: false,
  };
}

/**
 * บันทึกผลของผู้เล่นที่ยังไม่ล็อกอินลงเครื่อง แล้วคืนยศ/ความเชี่ยวชาญที่คิดจาก
 * ประวัติในเครื่อง — จอ debrief จะได้แสดงความคืบหน้าเหมือนคนที่ล็อกอิน
 * (ติดป้ายว่ายังไม่ถาวร) แทนที่จะไม่เห็นอะไรเลย
 */
function recordLocalRun(
  scenarioSlug: string,
  state: SimState,
  result: SimRunResult,
  specialty: string | null,
): RecordedRun {
  const xp = result.won ? SIM_XP[result.grade] : SIM_XP_LOSS;
  const runs = appendLocalRun({
    slug: scenarioSlug,
    won: result.won,
    grade: result.grade,
    score: result.score,
    specialty,
    difficulty: state.difficulty,
    xp,
    at: Date.now(),
  });

  const before = summarizeLocal(runs.slice(0, -1));
  const after = summarizeLocal(runs);
  const expertise = specialty
    ? summarizeExpertise(runs.map((r) => ({ specialty: r.specialty, won: r.won })))
        .find((s) => s.specialty === specialty) ?? null
    : null;

  return {
    loggedIn: false,
    isLocal: true,
    localRuns: runs.length,
    xpEarned: xp,
    newBadges: [],
    ...rankDelta(before.xp, after.xp),
    expertise,
    expertiseUp: expertise
      ? expertise.tier.level > expertiseFor(result.won ? expertise.wins - 1 : expertise.wins).level
      : false,
  };
}

/**
 * ยกผลที่เล่นไว้ตอนยังไม่ล็อกอินเข้าบัญชี — เรียกครั้งเดียวตอนบันทึกผลรอบแรก
 * หลังล็อกอิน แล้วล้างของในเครื่องทิ้ง
 *
 * XP รวมเป็นก้อนเดียว (reason `sim:claim:<n>`) แทนที่จะยิงทีละรอบ เพื่อให้ตาม
 * รอยได้ว่าก้อนไหนมาจากการยกเข้า ไม่ใช่การเล่นจริงหลังล็อกอิน
 */
async function claimLocalRuns(supabase: Supabase, userId: string): Promise<void> {
  const runs = readLocalRuns();
  if (runs.length === 0) return;
  // ล้างก่อนเขียน — ถ้า insert ล้มกลางทาง จะยอมเสียประวัติในเครื่องดีกว่าเสี่ยง
  // ยกซ้ำสองรอบแล้ว XP เด้งเป็นเท่าตัว
  clearLocalRuns();
  try {
    await supabase.from("sim_runs").insert(
      runs.map((r) => ({
        user_id: userId,
        scenario_slug: r.slug,
        specialty: r.specialty,
        difficulty: r.difficulty,
        won: r.won,
        grade: r.grade,
        score: r.score,
        wrong_count: 0,
        duration_sec: 0,
        metrics: { claimed_from_local: true, played_at: r.at },
      })),
    );
    const total = summarizeLocal(runs).xp;
    if (total > 0) await awardXp(total, `sim:claim:${runs.length}`);
  } catch {
    // Non-blocking — ผู้เล่นยังเล่นต่อได้ แค่ประวัติเก่าไม่ได้ยกเข้า
  }
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
  const specialty = specialtyForRun(specialtyRaw);
  try {
    const supabase = createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return recordLocalRun(scenarioSlug, state, result, specialty);
    out.loggedIn = true;

    // ล็อกอินแล้วเจอประวัติค้างในเครื่อง = เพิ่งสมัคร/เพิ่งเข้าระบบ → ยกเข้าบัญชี
    await claimLocalRuns(supabase, user.id);

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
