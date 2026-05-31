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
