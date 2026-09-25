// ฝั่ง server ของหน้า Mock Exam: ออก token + ตัดเฉลยออกจากข้อสอบก่อนส่งให้ browser
// (ดู lib/mcq-mock-token.ts, app/api/mcq/mock/submit/route.ts)
//
// ข้อสอบที่รับเข้ามาอ่านด้วย client ของผู้ใช้ จึงไม่มีเฉลยอยู่แล้ว (lib/mcq-public.ts)
// - โหมด graded: บันทึกชุดลง mock_active_sets ให้ /api/mcq/reveal ปฏิเสธข้อในชุด
//   จนกว่าจะส่งข้อสอบ/หมดเวลา (lib/mcq-active-mock.ts)
// - โหมด local (ยังไม่ล็อกอิน / server ไม่มีกุญแจเซ็น): ตรวจใน browser จึงต้องฝังเฉลย
//   — อ่านด้วย service role ที่นี่

import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { getMcqAnswerKeys } from "@/lib/supabase/queries-mcq";
import type { McqQuestion } from "@/lib/types-mcq";
import type { McqPublicQuestion } from "@/lib/mcq-public";
import { toMockPublicQuestion, type McqMockQuestion } from "@/lib/mcq-mock-grade";
import {
  getMockSigningSecret,
  mockTokenExpiresAt,
  mockTokenHash,
  newMockNonce,
  signMockToken,
  type MockTokenCohort,
  type MockTokenPayload,
} from "@/lib/mcq-mock-token";
import { recordActiveMockSet } from "@/lib/mcq-active-mock";

export type PreparedMockExam =
  /** ล็อกอินแล้ว: ข้อสอบไม่มีเฉลย + token สำหรับส่งให้ server ตรวจ/บันทึก/จัดอันดับ */
  | { mode: "graded"; questions: McqMockQuestion[]; mockToken: string }
  /** ยังไม่ล็อกอิน (หรือ server ไม่มีกุญแจเซ็น): ตรวจใน browser ไม่บันทึก ไม่จัดอันดับ */
  | { mode: "local"; questions: McqQuestion[]; mockToken: null };

async function withAnswerKeys(questions: McqPublicQuestion[]): Promise<McqQuestion[]> {
  const keys = await getMcqAnswerKeys(questions.map((q) => q.id));
  return questions.flatMap((q) => {
    const key = keys.get(q.id);
    // ไม่มีเฉลย (ข้อหายระหว่างโหลด) — ตัดทิ้ง ไม่งั้นตรวจใน browser ไม่ได้
    return key ? [{ ...q, ...key, ai_notes: null } as McqQuestion] : [];
  });
}

export async function prepareMockExam(
  questions: McqPublicQuestion[],
  cohort: MockTokenCohort,
  timeLimitMinutes: number,
): Promise<PreparedMockExam> {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return { mode: "local", questions: await withAnswerKeys(questions), mockToken: null };

  const secret = getMockSigningSecret();
  if (!secret) {
    console.error(
      "[mock] MOCK_SIGNING_SECRET (หรือ SUPABASE_SERVICE_ROLE_KEY) ไม่ได้ตั้งค่า — mock จะไม่บันทึกผล/ไม่จัดอันดับ",
    );
    return { mode: "local", questions: await withAnswerKeys(questions), mockToken: null };
  }

  const payload: MockTokenPayload = {
    v: 1,
    uid: user.id,
    qids: questions.map((q) => q.id),
    cohort,
    tl: timeLimitMinutes,
    iat: Date.now(),
    nonce: newMockNonce(),
  };
  const mockToken = signMockToken(payload, secret);

  // ระหว่างสอบห้ามขอเฉลยข้อในชุดนี้ผ่าน /api/mcq/reveal (ปลดเมื่อส่ง/หมดเวลา)
  await recordActiveMockSet(createAdminClient(), {
    userId: user.id,
    questionIds: payload.qids,
    expiresAt: mockTokenExpiresAt(payload),
    tokenHash: mockTokenHash(mockToken),
  });

  return { mode: "graded", questions: questions.map(toMockPublicQuestion), mockToken };
}
