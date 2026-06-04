/**
 * Progressive-disclosure "journey" for the School home page (client-safe).
 *
 * Goal: a brand-new student should not be hit with all ~17 tools at once.
 * Tools stay *visible* (so they know what's coming) but locked tools are
 * dimmed with an unlock condition until the student progresses. Unlock state
 * is derived purely from data we already have (level / streak / mastery) —
 * no extra DB column is needed.
 */

import { xpToLevel } from "@/lib/school/xp";

/** Signals used to decide what is unlocked. */
export interface JourneyContext {
  hasYear: boolean;
  xp: number;
  streak: number;
  masteredCount: number;
  dueCount?: number;
}

export interface JourneyStage {
  id: string;
  title: string;
  desc: string;
  /** Hrefs unlocked when this stage (and all earlier ones) is reached. */
  unlocks: readonly string[];
  /** Human-readable Thai condition shown on locked tools. */
  unlockLabel: string;
  reachedWhen: (ctx: { level: number } & JourneyContext) => boolean;
}

/** Tools that are always available regardless of progress. */
export const ALWAYS_UNLOCKED: readonly string[] = ["/school/settings"];

/**
 * Ordered stages. Progression is naturally monotonic for real users
 * (set year during onboarding → earn XP → master topics), so we treat a
 * stage as "reached" only when it and every earlier stage is satisfied.
 */
export const STAGES: readonly JourneyStage[] = [
  {
    id: "start",
    title: "เริ่มต้น",
    desc: "ทำความรู้จักโหมด School — เริ่มที่ Daily Lesson",
    unlocks: ["/school/daily"],
    unlockLabel: "พร้อมใช้ได้เลย",
    reachedWhen: () => true,
  },
  {
    id: "day-one",
    title: "วันแรก",
    desc: "ตั้งชั้นปีแล้ว — ลองทบทวน และตั้ง 'อาชีพในฝัน' เป็นเป้าหมาย",
    unlocks: ["/school/review", "/school/specialty"],
    unlockLabel: "ปลดล็อกเมื่อเลือกชั้นปี",
    reachedWhen: (ctx) => ctx.hasYear,
  },
  {
    id: "habit",
    title: "สร้างนิสัย",
    desc: "ฝึกเองด้วย Flashcards / Quiz และดูความก้าวหน้า",
    unlocks: ["/school/flashcards", "/school/quiz", "/school/progress"],
    unlockLabel: "ปลดล็อกที่ Level 2 (หรือ streak 3 วัน)",
    reachedWhen: (ctx) => ctx.level >= 2 || ctx.streak >= 3,
  },
  {
    id: "deepen",
    title: "เจาะลึก",
    desc: "สลับหัวข้อ ทำเคส และถาม AI Tutor",
    unlocks: [
      "/school/mixed",
      "/school/cases",
      "/school/tutor",
      "/school/search",
      "/school/saved",
    ],
    unlockLabel: "ปลดล็อกที่ Level 3 (หรือ master 1 หัวข้อ)",
    reachedWhen: (ctx) => ctx.level >= 3 || ctx.masteredCount >= 1,
  },
  {
    id: "master",
    title: "เชี่ยวชาญ",
    desc: "เครื่องมือขั้นสูง — เชื่อมข้ามวิชา เทียบ และไต่อันดับ",
    unlocks: [
      "/school/concepts",
      "/school/compare",
      "/school/visuals",
      "/school/tracks",
      "/school/badges",
      "/school/leaderboard",
    ],
    unlockLabel: "ปลดล็อกที่ Level 5",
    reachedWhen: (ctx) => ctx.level >= 5,
  },
] as const;

export interface UnlockState {
  /** Index of the highest contiguous stage reached. */
  stageIndex: number;
  stage: JourneyStage;
  level: number;
  /** Every href the student can currently open. */
  unlockedHrefs: Set<string>;
  /** Hrefs unlocked at the most-recently-reached stage (for "ใหม่!" badge). */
  newHrefs: Set<string>;
  /** Per-href unlock condition for locked tools. */
  unlockLabelFor: (href: string) => string | null;
  /** The next stage to reach, or null if everything is unlocked. */
  nextStage: JourneyStage | null;
}

export function getUnlockState(ctx: JourneyContext): UnlockState {
  const level = xpToLevel(ctx.xp).level;
  const full = { ...ctx, level };

  // Highest contiguous reached stage.
  let stageIndex = 0;
  for (let i = 0; i < STAGES.length; i++) {
    if (STAGES[i].reachedWhen(full)) stageIndex = i;
    else break;
  }

  const unlockedHrefs = new Set<string>(ALWAYS_UNLOCKED);
  for (let i = 0; i <= stageIndex; i++) {
    for (const href of STAGES[i].unlocks) unlockedHrefs.add(href);
  }
  const newHrefs = new Set<string>(STAGES[stageIndex].unlocks);

  // Map each still-locked href to the label of the stage that unlocks it.
  const labelByHref = new Map<string, string>();
  for (let i = stageIndex + 1; i < STAGES.length; i++) {
    for (const href of STAGES[i].unlocks) {
      if (!labelByHref.has(href)) labelByHref.set(href, STAGES[i].unlockLabel);
    }
  }

  return {
    stageIndex,
    stage: STAGES[stageIndex],
    level,
    unlockedHrefs,
    newHrefs,
    unlockLabelFor: (href) => labelByHref.get(href) ?? null,
    nextStage: stageIndex < STAGES.length - 1 ? STAGES[stageIndex + 1] : null,
  };
}

/** The single next action to highlight, reducing choice overload. */
export function nextRecommendedAction(ctx: JourneyContext): {
  href: string;
  label: string;
  hint: string;
} {
  if (!ctx.hasYear) {
    return {
      href: "/school/onboarding",
      label: "ตั้งค่าชั้นปีของคุณ",
      hint: "บอกเราว่าคุณอยู่ Y1–Y6 เพื่อจัดบทเรียนให้ตรง",
    };
  }
  if ((ctx.dueCount ?? 0) > 0) {
    return {
      href: "/school/review",
      label: `ทบทวน ${ctx.dueCount} รายการที่ใกล้ลืม`,
      hint: "เคลียร์คิวทบทวนก่อน แล้วค่อยเรียนใหม่",
    };
  }
  return {
    href: "/school/daily",
    label: "ทำ Daily Lesson วันนี้",
    hint: "วันละ 5 นาทีก็พอ — สร้าง streak ต่อเนื่อง",
  };
}
