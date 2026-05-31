/**
 * XP / level helpers (client-safe).
 *
 * XP awards:
 *   flashcard rated good/easy    = 2 / 3
 *   flashcard rated hard         = 1
 *   flashcard rated again        = 0
 *   quiz correct (easy/med/hard) = 5 / 8 / 12
 *   quiz wrong                   = 1 (consolation)
 *   lesson completed             = 10
 *   daily lesson completed       = 20
 *   topic mastered (first time)  = 100
 *   challenge passed (>=80%)     = 150
 */

import { createClient } from "@/lib/supabase/client";

export const XP = {
  flashcardAgain: 0,
  flashcardHard: 1,
  flashcardGood: 2,
  flashcardEasy: 3,
  quizWrong: 1,
  quizEasy: 5,
  quizMedium: 8,
  quizHard: 12,
  lessonRead: 10,
  dailyComplete: 20,
  topicMastered: 100,
  challengePassed: 150,
} as const;

/** Levels: 0-100 XP = L1, +200, +400, +800, ... (geometric) */
export function xpToLevel(xp: number): { level: number; nextAt: number; progress: number } {
  let lvl = 1;
  let need = 100;
  let cum = 0;
  while (xp >= cum + need) {
    cum += need;
    lvl += 1;
    need = Math.round(need * 1.6);
  }
  return {
    level: lvl,
    nextAt: cum + need,
    progress: Math.round(((xp - cum) / need) * 100),
  };
}

/**
 * Add XP to the current user. Writes an audit row + increments
 * profiles.school_xp. Non-blocking on errors.
 */
export async function awardXp(amount: number, reason: string): Promise<void> {
  if (!amount) return;
  try {
    const supabase = createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return;
    await supabase.from("school_xp_events").insert({
      user_id: user.id,
      amount,
      reason,
    });
    const { data: prof } = await supabase
      .from("profiles")
      .select("school_xp")
      .eq("id", user.id)
      .maybeSingle();
    const current = prof?.school_xp ?? 0;
    await supabase
      .from("profiles")
      .update({ school_xp: current + amount })
      .eq("id", user.id);
  } catch {
    // Non-blocking
  }
}

/**
 * Auto-detect badges that should be awarded based on current cumulative
 * state. Cheap to call after any meaningful action — bails early if user
 * is anonymous.
 *
 * Detects: streak_3/7/30, cards_100/500, quiz_50, all_systems, night_owl,
 * early_bird, feynman_5, first_mastered, perfect_daily (when forceContext
 * passes pct === 100).
 */
export async function detectBadges(forceContext: {
  perfectDaily?: boolean;
  feynmanCompleted?: boolean;
} = {}): Promise<string[]> {
  const awarded: string[] = [];
  try {
    const supabase = createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return awarded;

    // Streak
    const { data: streak } = await supabase
      .from("school_streaks")
      .select("current_streak")
      .eq("user_id", user.id)
      .maybeSingle();
    const s = streak?.current_streak ?? 0;
    if (s >= 3) awarded.push("streak_3");
    if (s >= 7) awarded.push("streak_7");
    if (s >= 30) awarded.push("streak_30");

    // Card / quiz counts
    const { count: cardCount } = await supabase
      .from("school_progress")
      .select("id", { count: "exact", head: true })
      .eq("user_id", user.id)
      .eq("unit_type", "flashcard");
    if ((cardCount ?? 0) >= 100) awarded.push("cards_100");
    if ((cardCount ?? 0) >= 500) awarded.push("cards_500");

    const { count: quizCount } = await supabase
      .from("school_progress")
      .select("id", { count: "exact", head: true })
      .eq("user_id", user.id)
      .eq("unit_type", "quiz");
    if ((quizCount ?? 0) >= 50) awarded.push("quiz_50");

    // All systems: distinct school_systems touched via flashcards
    const { data: sys } = await supabase
      .from("school_progress")
      .select("unit_id, school_flashcards!inner(school_topics(system_id))")
      .eq("user_id", user.id)
      .eq("unit_type", "flashcard")
      .limit(1000);
    type SysRow = {
      school_flashcards?: { school_topics?: { system_id?: string } | null } | null;
    };
    const systemIds = new Set(
      (sys as SysRow[] | null ?? [])
        .map((r) => r.school_flashcards?.school_topics?.system_id)
        .filter(Boolean) as string[]
    );
    if (systemIds.size >= 12) awarded.push("all_systems");

    // Time-of-day
    const hour = new Date().getHours();
    if (hour < 7) awarded.push("early_bird");
    if (hour >= 22) awarded.push("night_owl");

    // First mastery — any topic with >=5 quizzes & >=80% correct
    const { data: quizProg } = await supabase
      .from("school_progress")
      .select("outcome, school_quizzes:unit_id(topic_id)")
      .eq("user_id", user.id)
      .eq("unit_type", "quiz")
      .limit(1000);
    type QP = { outcome: string; school_quizzes?: { topic_id?: string } | null };
    const byTopic = new Map<string, { c: number; t: number }>();
    for (const r of (quizProg as QP[] | null ?? [])) {
      const tid = r.school_quizzes?.topic_id;
      if (!tid) continue;
      const b = byTopic.get(tid) ?? { c: 0, t: 0 };
      b.t += 1;
      if (r.outcome === "correct") b.c += 1;
      byTopic.set(tid, b);
    }
    const anyMastered = [...byTopic.values()].some(
      (b) => b.t >= 5 && b.c / b.t >= 0.8
    );
    if (anyMastered) awarded.push("first_mastered");

    // Feynman count via xp_events with reason starting with 'feynman'
    if (forceContext.feynmanCompleted) {
      const { count: feyCount } = await supabase
        .from("school_xp_events")
        .select("id", { count: "exact", head: true })
        .eq("user_id", user.id)
        .like("reason", "feynman%");
      if ((feyCount ?? 0) >= 5) awarded.push("feynman_5");
    }

    if (forceContext.perfectDaily) awarded.push("perfect_daily");

    // Award each (idempotent)
    const newlyAwarded: string[] = [];
    for (const slug of awarded) {
      const ok = await awardBadge(slug);
      if (ok) newlyAwarded.push(slug);
    }
    return newlyAwarded;
  } catch {
    return awarded;
  }
}

/**
 * Award a badge by slug if user does not already own it. Returns true if
 * newly awarded so caller can show a celebration UI.
 */
export async function awardBadge(slug: string): Promise<boolean> {
  try {
    const supabase = createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return false;
    const { data: badge } = await supabase
      .from("school_badges")
      .select("id, xp_reward")
      .eq("slug", slug)
      .maybeSingle();
    if (!badge) return false;
    const { data: existing } = await supabase
      .from("school_user_badges")
      .select("user_id")
      .eq("user_id", user.id)
      .eq("badge_id", badge.id)
      .maybeSingle();
    if (existing) return false;
    await supabase.from("school_user_badges").insert({
      user_id: user.id,
      badge_id: badge.id,
    });
    if (badge.xp_reward) {
      await awardXp(badge.xp_reward, `badge:${slug}`);
    }
    return true;
  } catch {
    return false;
  }
}
