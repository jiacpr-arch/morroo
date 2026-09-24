// Shared config for the "Bug Hunter" program — students earn reporter_points
// by flagging bad MCQ questions (see 20260415_mcq_question_reports.sql) and
// can spend those points on free membership days (see
// 20260617_bug_hunter_rewards.sql). Keep API and UI in sync via this module.

export type RewardTierId = "days7" | "days30";

export interface RewardTier {
  id: RewardTierId;
  /** Points it costs to redeem this tier. */
  cost: number;
  /** Free membership days granted. */
  days: number;
  label: string;
}

export const REWARD_TIERS: Record<RewardTierId, RewardTier> = {
  days7: { id: "days7", cost: 30, days: 7, label: "สมาชิกฟรี 7 วัน" },
  days30: { id: "days30", cost: 75, days: 30, label: "สมาชิกฟรี 30 วัน" },
};

/** A user may redeem points for free days at most once per this many days. */
export const REDEEM_COOLDOWN_DAYS = 30;

export const REWARD_TIER_LIST: RewardTier[] = Object.values(REWARD_TIERS);

/** Points still available to spend (lifetime earned minus already spent). */
export function availableReporterPoints(p: {
  reporter_points?: number | null;
  reporter_points_spent?: number | null;
}): number {
  return Math.max(0, (p.reporter_points ?? 0) - (p.reporter_points_spent ?? 0));
}

// Labels reused by the admin review screen.
export const REPORT_REASON_LABELS: Record<string, string> = {
  wrong_answer: "เฉลยผิด",
  unclear_question: "โจทย์กำกวม",
  typo: "พิมพ์ผิด",
  outdated: "ข้อมูลล้าสมัย",
  duplicate: "ซ้ำกับข้ออื่น",
  other: "อื่น ๆ",
};

export const REPORT_STATUS_LABELS: Record<string, string> = {
  pending: "รอตรวจ",
  confirmed: "ยืนยันแล้ว (+10)",
  rejected: "ปฏิเสธ",
  duplicate: "ซ้ำ",
};
