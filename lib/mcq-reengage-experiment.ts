/**
 * 1-week A/B test: one regular MCQ card a week (Monday) to dormant LINE users.
 *
 * Cohort lives in experiment_daily_mcq_reengage (frozen by the migration of
 * the same name); this module is the only code that reads or updates it:
 *   - getReengageTestArm      → who gets the Monday card (daily-reminder route)
 *   - markReengageSent        → stamps sent_at on the first Monday send
 *   - getReengageExperimentStatus → the readout shown in the admin's daily
 *                                   LINE digest until the decision is made
 */
import type { SupabaseClient } from "@supabase/supabase-js";

export const REENGAGE_TEST_DAYS = 7;
// Keep the digest line up for a few days past day 7 so the decision isn't missed.
const DIGEST_GRACE_DAYS = 3;

export interface ReengageArmStats {
  size: number;
  blocked: number;
  answered: number;
  converted: number;
}

export interface ReengageExperimentStatus {
  /** First Monday send; null while the card hasn't gone out yet. */
  startedAt: string | null;
  /** 1-based day of the test; 0 before the first send. */
  dayN: number;
  testDays: number;
  test: ReengageArmStats;
  control: ReengageArmStats;
}

interface CohortRow {
  line_user_id: string;
  user_id: string;
  variant: "control" | "weekly_mcq";
  sent_at: string | null;
}

export async function getReengageTestArm(supabase: SupabaseClient): Promise<string[]> {
  const { data, error } = await supabase
    .from("experiment_daily_mcq_reengage")
    .select("line_user_id")
    .eq("variant", "weekly_mcq");
  if (error) {
    console.error("[reengage] test arm lookup failed:", error);
    return [];
  }
  return ((data ?? []) as { line_user_id: string }[]).map((r) => r.line_user_id);
}

/** Stamp the start of the test on the first Monday send (no-op afterwards). */
export async function markReengageSent(supabase: SupabaseClient): Promise<void> {
  const { error } = await supabase
    .from("experiment_daily_mcq_reengage")
    .update({ sent_at: new Date().toISOString() })
    .is("sent_at", null);
  if (error) console.error("[reengage] markReengageSent failed:", error);
}

export async function getReengageExperimentStatus(
  supabase: SupabaseClient
): Promise<ReengageExperimentStatus | null> {
  const { data, error } = await supabase
    .from("experiment_daily_mcq_reengage")
    .select("line_user_id, user_id, variant, sent_at");
  if (error || !data?.length) return null;

  const rows = data as CohortRow[];
  const startedAt = rows.reduce<string | null>(
    (min, r) => (r.sent_at && (!min || r.sent_at < min) ? r.sent_at : min),
    null
  );
  const dayN = startedAt
    ? Math.floor((Date.now() - new Date(startedAt).getTime()) / 86400_000) + 1
    : 0;

  const lineIds = rows.map((r) => r.line_user_id);
  const userIds = rows.map((r) => r.user_id);

  const [{ data: unfollows }, { data: answers }, { data: paid }] = await Promise.all([
    startedAt
      ? supabase
          .from("line_unfollow_events")
          .select("line_user_id")
          .in("line_user_id", lineIds)
          .gte("unfollowed_at", startedAt)
      : Promise.resolve({ data: [] as { line_user_id: string }[] }),
    startedAt
      ? supabase
          .from("daily_quiz_answers")
          .select("line_user_id")
          .in("line_user_id", lineIds)
          .gte("created_at", startedAt)
      : Promise.resolve({ data: [] as { line_user_id: string }[] }),
    supabase
      .from("profiles")
      .select("id")
      .in("id", userIds)
      .neq("membership_type", "free")
      .gt("membership_expires_at", new Date().toISOString()),
  ]);

  const blocked = new Set(((unfollows ?? []) as { line_user_id: string }[]).map((r) => r.line_user_id));
  const answered = new Set(((answers ?? []) as { line_user_id: string }[]).map((r) => r.line_user_id));
  const converted = new Set(((paid ?? []) as { id: string }[]).map((r) => r.id));

  const arm = (variant: CohortRow["variant"]): ReengageArmStats => {
    const members = rows.filter((r) => r.variant === variant);
    return {
      size: members.length,
      blocked: members.filter((r) => blocked.has(r.line_user_id)).length,
      answered: members.filter((r) => answered.has(r.line_user_id)).length,
      converted: members.filter((r) => converted.has(r.user_id)).length,
    };
  };

  return {
    startedAt,
    dayN,
    testDays: REENGAGE_TEST_DAYS,
    test: arm("weekly_mcq"),
    control: arm("control"),
  };
}

/** Show in the digest until a few days after day 7, then drop out on its own. */
export function shouldShowReengageInDigest(status: ReengageExperimentStatus | null): boolean {
  if (!status) return false;
  return status.dayN <= status.testDays + DIGEST_GRACE_DAYS;
}
