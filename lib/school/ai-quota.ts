import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";

/**
 * Quota คำถาม AI ต่อวันของโหมด School
 *
 * ทุกเส้น AI (`/api/school/{ask,tutor,explain,elaborate,compare}`) เรียก Anthropic
 * ทุกครั้งที่ถูกกด — เดิมเช็คแค่ล็อกอิน ใครก็ยิงได้ไม่จำกัด ค่า token จึงไหลออก
 * โดยไม่มีเพดาน ตัวนับอยู่ในตาราง `school_ai_usage` และเพิ่มค่าผ่าน RPC
 * `school_bump_ai_usage` ด้วย service role — ผู้ใช้อ่านของตัวเองได้แต่เขียนไม่ได้
 * (ถ้าให้เขียนได้จะรีเซ็ตตัวนับตัวเองผ่าน anon key ได้ทันที)
 */

export interface SchoolAiQuota {
  allowed: boolean;
  used: number;
  quota: number;
}

/**
 * นับ 1 ครั้งแล้วบอกว่าให้ผ่านไหม
 *
 * ถ้า RPC ล้ม (เช่นยัง deploy โค้ดก่อน migration) จะ "ปล่อยผ่าน" พร้อม log
 * ไว้ก่อน — ยอมเสีย quota ชั่วคราวดีกว่าทำให้ฟีเจอร์ AI ล่มทั้งระบบ
 */
export async function consumeSchoolAiQuota(
  userId: string,
  limit: number
): Promise<SchoolAiQuota> {
  const admin = createAdminClient();
  const { data, error } = await admin.rpc("school_bump_ai_usage", {
    p_user_id: userId,
    p_limit: limit,
  });

  if (error) {
    console.error("[school-ai-quota] rpc failed:", error.message);
    return { allowed: true, used: 0, quota: limit };
  }

  const row = (Array.isArray(data) ? data[0] : data) as
    | { allowed?: boolean; used?: number; quota?: number }
    | null;

  return {
    allowed: row?.allowed ?? true,
    used: row?.used ?? 0,
    quota: row?.quota ?? limit,
  };
}

/** 429 พร้อมข้อความไทย + ชี้ทางไปหน้าแพ็กเกจ */
export function quotaExceededResponse(quota: SchoolAiQuota, isPremium: boolean) {
  return NextResponse.json(
    {
      error: isPremium
        ? `ถามครบ ${quota.quota} คำถามของวันนี้แล้ว — พรุ่งนี้ถามต่อได้เลย`
        : `ผู้ใช้ฟรีถามได้ ${quota.quota} คำถาม/วัน — สมัครแพ็ก School เพื่อถามได้มากขึ้น`,
      code: "SCHOOL_AI_QUOTA_EXCEEDED",
      used: quota.used,
      quota: quota.quota,
      upgradeUrl: isPremium ? undefined : "/pricing#school",
    },
    { status: 429 }
  );
}
