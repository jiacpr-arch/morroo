// ความเชี่ยวชาญรายสาขา — อีกครึ่งของ "ตัวละคร" คู่กับยศใน lib/school/rank.ts
//
// ยศบอกว่าเล่นมาเยอะแค่ไหน (XP รวมทั้งเว็บ) ส่วนความเชี่ยวชาญบอกว่า *เก่ง
// สาขาไหน* — นับจากเคสที่ชนะในสาขานั้น (sim_runs.specialty)
//
// pure ทั้งไฟล์ (ไม่มี I/O)

export interface ExpertiseTier {
  level: number;
  label: string;
  minWins: number;
  icon: string;
}

export const EXPERTISE_TIERS: readonly ExpertiseTier[] = [
  { level: 0, label: "ยังไม่เคยผ่าน", minWins: 0, icon: "○" },
  { level: 1, label: "เคยผ่านมือ", minWins: 1, icon: "◔" },
  { level: 2, label: "คุ้นเคย", minWins: 3, icon: "◑" },
  { level: 3, label: "ชำนาญ", minWins: 7, icon: "◕" },
  { level: 4, label: "เชี่ยวชาญ", minWins: 15, icon: "●" },
] as const;

/** ระดับที่ถือว่า "ผู้เชี่ยวชาญ" — ใช้ต่อท้ายชื่อยศได้ */
export const EXPERT_LEVEL = 4;

export function expertiseFor(wins: number): ExpertiseTier {
  const safeWins = Number.isFinite(wins) && wins > 0 ? Math.floor(wins) : 0;
  let tier = EXPERTISE_TIERS[0];
  for (const t of EXPERTISE_TIERS) {
    if (safeWins >= t.minWins) tier = t;
  }
  return tier;
}

export interface SpecialtyExpertise {
  specialty: string;
  wins: number;
  played: number;
  tier: ExpertiseTier;
  /** ชนะอีกกี่เคสถึงขั้นถัดไป — null เมื่อถึงขั้นสูงสุด */
  winsToNext: number | null;
}

export interface ExpertiseRun {
  specialty: string | null;
  won: boolean;
}

/**
 * สรุปความเชี่ยวชาญทุกสาขาจากประวัติการเล่น เรียงจากเก่งสุดไปน้อยสุด
 *
 * run ที่ไม่มีสาขา (เคส ACLS หรือข้อมูลเก่าที่ backfill ไม่ติด) ถูกข้าม —
 * ไม่ยัดลงถังรวมเพราะจะทำให้ "สาขาถนัด" เพี้ยน
 */
export function summarizeExpertise(runs: readonly ExpertiseRun[]): SpecialtyExpertise[] {
  const bySpecialty = new Map<string, { wins: number; played: number }>();
  for (const run of runs) {
    const specialty = run.specialty?.trim();
    if (!specialty) continue;
    const bucket = bySpecialty.get(specialty) ?? { wins: 0, played: 0 };
    bucket.played += 1;
    if (run.won) bucket.wins += 1;
    bySpecialty.set(specialty, bucket);
  }

  return [...bySpecialty.entries()]
    .map(([specialty, { wins, played }]) => {
      const tier = expertiseFor(wins);
      const next = EXPERTISE_TIERS[tier.level + 1] ?? null;
      return {
        specialty,
        wins,
        played,
        tier,
        winsToNext: next ? next.minWins - wins : null,
      };
    })
    .sort((a, b) => b.wins - a.wins || b.played - a.played || a.specialty.localeCompare(b.specialty, "th"));
}

/**
 * สาขาที่เรียกตัวเองว่าผู้เชี่ยวชาญได้ — เอาไปต่อท้ายชื่อยศใน fullTitle()
 * คืน null เมื่อยังไม่มีสาขาไหนถึงขั้น "เชี่ยวชาญ"
 */
export function expertSpecialty(runs: readonly ExpertiseRun[]): string | null {
  const top = summarizeExpertise(runs)[0];
  return top && top.tier.level >= EXPERT_LEVEL ? top.specialty : null;
}
