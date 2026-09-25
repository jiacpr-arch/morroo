// ชุดข้อสอบ Mock ที่กำลังสอบอยู่ (ตาราง mock_active_sets, service role เท่านั้น)
//
// หน้า mock ออก token (lib/mcq-mock-server.ts) → บันทึก id ข้อสอบของชุดไว้ที่นี่
// จนกว่าจะส่งข้อสอบ (app/api/mcq/mock/submit) หรือหมดเวลา ระหว่างนั้น
// /api/mcq/reveal, /api/ai/mcq-chat และการอ่านคอมเมนต์ปฏิเสธข้อในชุด —
// ไม่งั้นเปิดอีกแท็บไปขอเฉลยทีละข้อระหว่างสอบได้
//
// ทุกฟังก์ชันไม่ throw: บันทึกไม่สำเร็จ = สอบต่อได้ปกติ (แค่ไม่ได้กันโกง),
// ตรวจไม่สำเร็จ (เช่นยังไม่ได้ apply migration) = ปล่อยผ่านและ log ไว้

import type { SupabaseClient } from "@supabase/supabase-js";

export const MOCK_ACTIVE_SETS_TABLE = "mock_active_sets";

/** ข้อความตอบกลับเมื่อขอเฉลยข้อที่อยู่ในชุด mock ที่ยังสอบไม่เสร็จ */
export const ACTIVE_MOCK_BLOCK_MESSAGE =
  "ข้อนี้อยู่ในชุด Mock ที่กำลังสอบอยู่ — ส่งข้อสอบก่อนแล้วจะเห็นเฉลยในหน้าผลสอบ";

export async function recordActiveMockSet(
  admin: SupabaseClient,
  set: { userId: string; questionIds: string[]; expiresAt: number; tokenHash: string },
): Promise<void> {
  try {
    const nowIso = new Date().toISOString();
    // เก็บกวาดชุดที่หมดอายุของคนนี้ไปด้วย ตารางจะได้ไม่โต
    await admin
      .from(MOCK_ACTIVE_SETS_TABLE)
      .delete()
      .eq("user_id", set.userId)
      .lt("expires_at", nowIso);
    const { error } = await admin.from(MOCK_ACTIVE_SETS_TABLE).insert({
      user_id: set.userId,
      question_ids: set.questionIds,
      expires_at: new Date(set.expiresAt).toISOString(),
      token_hash: set.tokenHash,
    });
    if (error) console.error("[mock-active] record failed:", error);
  } catch (err) {
    console.error("[mock-active] record threw:", err);
  }
}

/** ส่งข้อสอบแล้ว — ปลดล็อกให้ดูเฉลยข้อในชุดนี้ได้ */
export async function releaseActiveMockSet(
  admin: SupabaseClient,
  userId: string,
  tokenHash: string,
): Promise<void> {
  try {
    const { error } = await admin
      .from(MOCK_ACTIVE_SETS_TABLE)
      .delete()
      .eq("user_id", userId)
      .eq("token_hash", tokenHash);
    if (error) console.error("[mock-active] release failed:", error);
  } catch (err) {
    console.error("[mock-active] release threw:", err);
  }
}

/** ข้อนี้อยู่ในชุด mock ที่ผู้ใช้ยังสอบไม่เสร็จ (ยังไม่หมดเวลา) หรือไม่ */
export async function isQuestionInActiveMock(
  admin: SupabaseClient,
  userId: string,
  questionId: string,
  now: Date = new Date(),
): Promise<boolean> {
  try {
    const { data, error } = await admin
      .from(MOCK_ACTIVE_SETS_TABLE)
      .select("token_hash")
      .eq("user_id", userId)
      .contains("question_ids", [questionId])
      .gt("expires_at", now.toISOString())
      .limit(1);
    if (error) {
      console.error("[mock-active] lookup failed:", error);
      return false;
    }
    return Array.isArray(data) && data.length > 0;
  } catch (err) {
    console.error("[mock-active] lookup threw:", err);
    return false;
  }
}
