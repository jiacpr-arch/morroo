// ฝั่ง server ของหน้า Mock Exam: ออก token + ตัดเฉลยออกจากข้อสอบก่อนส่งให้ browser
// (ดู lib/mcq-mock-token.ts, app/api/mcq/mock/submit/route.ts)

import { createClient } from "@/lib/supabase/server";
import type { McqQuestion } from "@/lib/types-mcq";
import { toMockPublicQuestion, type McqMockQuestion } from "@/lib/mcq-mock-grade";
import {
  getMockSigningSecret,
  newMockNonce,
  signMockToken,
  type MockTokenCohort,
} from "@/lib/mcq-mock-token";

export type PreparedMockExam =
  /** ล็อกอินแล้ว: ข้อสอบไม่มีเฉลย + token สำหรับส่งให้ server ตรวจ/บันทึก/จัดอันดับ */
  | { mode: "graded"; questions: McqMockQuestion[]; mockToken: string }
  /** ยังไม่ล็อกอิน (หรือ server ไม่มีกุญแจเซ็น): ตรวจใน browser ไม่บันทึก ไม่จัดอันดับ */
  | { mode: "local"; questions: McqQuestion[]; mockToken: null };

export async function prepareMockExam(
  questions: McqQuestion[],
  cohort: MockTokenCohort,
  timeLimitMinutes: number,
): Promise<PreparedMockExam> {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return { mode: "local", questions, mockToken: null };

  const secret = getMockSigningSecret();
  if (!secret) {
    console.error(
      "[mock] MOCK_SIGNING_SECRET (หรือ SUPABASE_SERVICE_ROLE_KEY) ไม่ได้ตั้งค่า — mock จะไม่บันทึกผล/ไม่จัดอันดับ",
    );
    return { mode: "local", questions, mockToken: null };
  }

  const mockToken = signMockToken(
    {
      v: 1,
      uid: user.id,
      qids: questions.map((q) => q.id),
      cohort,
      tl: timeLimitMinutes,
      iat: Date.now(),
      nonce: newMockNonce(),
    },
    secret,
  );
  return { mode: "graded", questions: questions.map(toMockPublicQuestion), mockToken };
}
