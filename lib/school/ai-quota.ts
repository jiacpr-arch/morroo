import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import {
  entitledScopes,
  resolveAccess,
  type EntitlementLike,
} from "@/lib/membership";
import { fetchEntitlements } from "@/lib/entitlements";

/**
 * Quota คำถาม AI ต่อวันของโหมด School
 *
 * ทุกเส้นใน `app/api/school/{ask,tutor,explain,elaborate,compare}` เรียก
 * Anthropic ทุกครั้งที่กด — เดิมเช็คแค่ล็อกอิน ใครก็ยิงได้ไม่จำกัด
 *
 * ตัวนับอยู่ในตาราง `school_ai_usage` และเพิ่มค่าผ่าน RPC
 * `school_bump_ai_usage` ด้วย service role เท่านั้น — ผู้ใช้อ่านตัวนับของ
 * ตัวเองได้แต่เขียนไม่ได้ (ถ้าเขียนได้จะรีเซ็ตตัวเองผ่าน anon key ได้ทันที)
 * นับตามวันเวลาไทย
 */

/** เพดานของผู้จ่ายเงินคือกันการยิงรัว ไม่ใช่กันคนใช้งานจริง */
export const SCHOOL_AI_DAILY_LIMIT = { free: 5, paid: 100 } as const;

interface MembershipLike {
  membership_type?: string | null;
  membership_expires_at?: string | null;
}

/**
 * เพดานต่อวันของผู้ใช้คนนี้ — มีสิทธิ์ School ทั้งระบบ หรือซื้อวิชา/ชั้นปีใด
 * ชั้นปีหนึ่งไว้ ถือเป็นผู้จ่ายเงิน
 */
export function schoolAiDailyLimit(
  profile: MembershipLike | null | undefined,
  entitlements: readonly EntitlementLike[] | null | undefined,
  now: Date = new Date()
): number {
  const paid =
    resolveAccess(profile, entitlements, now).school ||
    entitledScopes(entitlements, "school", now).size > 0;
  return paid ? SCHOOL_AI_DAILY_LIMIT.paid : SCHOOL_AI_DAILY_LIMIT.free;
}

type ServerClient = Parameters<typeof fetchEntitlements>[0];

/**
 * นับ 1 ครั้งแล้วบอกว่าให้ผ่านไหม — คืน `null` ถ้าผ่าน หรือ response 429
 * ให้ route ส่งกลับทันที
 *
 * ถ้า RPC ล้มจะปล่อยผ่านพร้อม log ไว้ ยอมเสีย quota ชั่วคราวดีกว่าทำให้
 * ฟีเจอร์ AI ของทั้งระบบล่ม
 */
export async function enforceSchoolAiQuota(
  supabase: ServerClient,
  userId: string
): Promise<NextResponse | null> {
  const [{ data: profile }, entitlements] = await Promise.all([
    supabase
      .from("profiles")
      .select("membership_type, membership_expires_at")
      .eq("id", userId)
      .maybeSingle(),
    fetchEntitlements(supabase, userId),
  ]);
  const limit = schoolAiDailyLimit(profile, entitlements);
  const paid = limit === SCHOOL_AI_DAILY_LIMIT.paid;

  const { data, error } = await createAdminClient().rpc("school_bump_ai_usage", {
    p_user_id: userId,
    p_limit: limit,
  });
  if (error) {
    console.error("[school-ai-quota] rpc failed:", error.message);
    return null;
  }

  const row = (Array.isArray(data) ? data[0] : data) as
    | { allowed?: boolean; used?: number; quota?: number }
    | null;
  if (row?.allowed !== false) return null;

  return NextResponse.json(
    {
      error: paid
        ? `ถามครบ ${limit} คำถามของวันนี้แล้ว — พรุ่งนี้ถามต่อได้เลย`
        : `ผู้ใช้ฟรีถามได้ ${limit} คำถาม/วัน — ปลดล็อกโหมด School เพื่อถามได้มากขึ้น`,
      code: "SCHOOL_AI_QUOTA_EXCEEDED",
      used: row.used ?? limit,
      quota: limit,
    },
    { status: 429 }
  );
}
