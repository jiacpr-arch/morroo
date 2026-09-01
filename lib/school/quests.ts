/**
 * Weekly quests for the School home — a motivational lens over activity the
 * student is already doing, with one quest tied to their target specialty so
 * "what should I do next?" always has a concrete, goal-relevant answer.
 *
 * Client-safe: pure functions. The caller supplies metrics measured for the
 * current ISO week. Quests are display-only progress (the underlying actions
 * already award XP), so no extra "claimed reward" table is needed.
 */

import { getSpecialty } from "@/lib/school/specialty";

export interface Quest {
  id: string;
  title: string;
  desc: string;
  current: number;
  goal: number;
  href: string;
  /** Flavor reward text, e.g. "ปลดล็อกความมั่นใจ 💪". */
  reward?: string;
  done: boolean;
}

export interface WeeklyMetrics {
  activeDays: number; // distinct days with activity this week
  xpThisWeek: number;
  systemQuizCorrect: number; // correct quiz answers in the focus system this week
}

export interface QuestContext {
  targetSpecialtyId: string | null;
  /** Slug + Thai name of the focus system for the specialty quest. */
  focusSystem: { slug: string; name_th: string } | null;
}

/** Monday 00:00 (local) of the week containing `now`. */
export function weekStart(now: Date = new Date()): Date {
  const d = new Date(now);
  d.setHours(0, 0, 0, 0);
  const day = (d.getDay() + 6) % 7; // 0 = Monday
  d.setDate(d.getDate() - day);
  return d;
}

const DAILY_GOAL = 5;
const XP_GOAL = 150;
const SYSTEM_GOAL = 10;

export function buildWeeklyQuests(
  metrics: WeeklyMetrics,
  ctx: QuestContext
): Quest[] {
  const quests: Quest[] = [
    {
      id: "daily-days",
      title: "สม่ำเสมอ 5 วัน",
      desc: "ทำ Daily Lesson ให้ครบ 5 วันในสัปดาห์นี้",
      current: Math.min(metrics.activeDays, DAILY_GOAL),
      goal: DAILY_GOAL,
      href: "/school/daily",
      reward: "รักษา streak ไม่ให้ขาด 🔥",
      done: metrics.activeDays >= DAILY_GOAL,
    },
    {
      id: "xp-week",
      title: `เก็บ ${XP_GOAL} XP`,
      desc: "สะสม XP จากกิจกรรมใดก็ได้ในสัปดาห์นี้",
      current: Math.min(metrics.xpThisWeek, XP_GOAL),
      goal: XP_GOAL,
      href: "/school/daily",
      reward: "ไต่เลเวลเร็วขึ้น ⚡",
      done: metrics.xpThisWeek >= XP_GOAL,
    },
  ];

  // Specialty-tied quest — directs practice toward the dream specialty.
  const specialty = getSpecialty(ctx.targetSpecialtyId);
  if (specialty && ctx.focusSystem) {
    quests.push({
      id: "specialty-system",
      title: `สาย ${specialty.name_th}`,
      desc: `ตอบ quiz ${ctx.focusSystem.name_th} ให้ถูก ${SYSTEM_GOAL} ข้อ`,
      current: Math.min(metrics.systemQuizCorrect, SYSTEM_GOAL),
      goal: SYSTEM_GOAL,
      href: "/school/quiz",
      reward: `เข้าใกล้ ${specialty.name_th} ${specialty.icon}`,
      done: metrics.systemQuizCorrect >= SYSTEM_GOAL,
    });
  } else {
    // No target yet — nudge them to pick one (this also drives onboarding).
    quests.push({
      id: "pick-specialty",
      title: "เลือกอาชีพในฝัน",
      desc: "ตั้งเป้าสายเฉพาะทาง เพื่อปลดล็อกเควสต์เฉพาะสายของคุณ",
      current: 0,
      goal: 1,
      href: "/school/specialty",
      reward: "ได้เควสต์ที่ตรงเป้าหมาย 🎯",
      done: false,
    });
  }

  return quests;
}

/** The system a specialty leans on most — used as the focus for its quest. */
export function topSystemSlugFor(specialtyId: string | null): string | null {
  const sp = getSpecialty(specialtyId);
  if (!sp) return null;
  let best: string | null = null;
  let bestW = -1;
  for (const [slug, w] of Object.entries(sp.weights)) {
    if ((w ?? 0) > bestW) {
      bestW = w ?? 0;
      best = slug;
    }
  }
  return best;
}
