// อ่าน XP สะสมแล้วเทียบยศก่อน/หลัง (client-safe)
//
// แยกออกมาจาก lib/sim/record.ts เพราะเกมทั้งสองตัว (เกมเคส + Resus Hero) ต้อง
// รายงานการเลื่อนขั้นแบบเดียวกัน — ตรรกะอยู่ที่เดียวจะได้ไม่เพี้ยนกัน
//
// lib/school/rank.ts เป็น pure ล้วน ส่วนไฟล์นี้คือชั้นที่แตะ Supabase

import { createClient } from "@/lib/supabase/client";
import { xpToRank, type RankProgress } from "./rank";

export interface RankDelta {
  /** ยศก่อน/หลังรอบนี้ — null เมื่ออ่าน XP ไม่สำเร็จ */
  rankBefore: RankProgress | null;
  rankAfter: RankProgress | null;
  rankedUp: boolean;
}

export const NO_RANK_DELTA: RankDelta = {
  rankBefore: null,
  rankAfter: null,
  rankedUp: false,
};

/** XP สะสมของผู้ใช้ — null เมื่ออ่านไม่ได้ (ต่างจาก 0 ที่แปลว่าเพิ่งเริ่ม) */
export async function readSchoolXp(userId: string): Promise<number | null> {
  try {
    const supabase = createClient();
    const { data } = await supabase
      .from("profiles")
      .select("school_xp")
      .eq("id", userId)
      .maybeSingle();
    return data ? (data.school_xp ?? 0) : null;
  } catch {
    return null;
  }
}

/**
 * เทียบยศก่อน/หลัง — คืน NO_RANK_DELTA เมื่อฝั่งใดฝั่งหนึ่งอ่านไม่ได้ เพื่อไม่ให้
 * UI เดาว่า "เลื่อนขั้น" จากข้อมูลที่ไม่ครบ
 */
export function rankDelta(xpBefore: number | null, xpAfter: number | null): RankDelta {
  if (xpBefore === null || xpAfter === null) return NO_RANK_DELTA;
  const rankBefore = xpToRank(xpBefore);
  const rankAfter = xpToRank(xpAfter);
  return {
    rankBefore,
    rankAfter,
    rankedUp: rankAfter.rank.tier > rankBefore.rank.tier,
  };
}
