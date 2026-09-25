// Mock Exam: แยกข้อสอบเป็น "ส่วนที่ใช้แสดงระหว่างสอบ" กับ "เฉลย" + ตรวจคำตอบ — pure ทั้งไฟล์
// (ใช้ได้ทั้ง server และ client)
//
// ระหว่างสอบ client ได้แค่ McqMockQuestion (ไม่มี correct_answer / คำอธิบาย) เฉลย
// (McqMockReviewItem) มากับ response ของ /api/mcq/mock/submit หลังส่งแล้วเท่านั้น
// ยกเว้นโหมดไม่มี token (ผู้ใช้ยังไม่ล็อกอิน, /nl/try) ที่ตรวจใน browser และไม่บันทึกผล

import type { McqQuestion } from "./types-mcq";

/** ข้อสอบที่ส่งให้ browser ระหว่างสอบ — ห้ามมีเฉลยหรือคำอธิบาย */
export type McqMockQuestion = Pick<
  McqQuestion,
  "id" | "subject_id" | "exam_source" | "scenario" | "choices" | "mcq_subjects"
>;

/** เฉลยของข้อหนึ่ง — ส่งหลังตรวจแล้วเพื่อใช้ในหน้าผล/ทบทวน */
export interface McqMockReviewItem {
  id: string;
  /** null ถ้าข้อถูกลบออกจากคลังระหว่างสอบ (นับเป็นผิด) */
  correct_answer: string | null;
  explanation: string | null;
  detailed_explanation: McqQuestion["detailed_explanation"];
}

export type McqMockAnswers = Record<string, string | null>;

export interface McqMockGradeResult {
  correctCount: number;
  total: number;
  perQuestion: { id: string; selected: string | null; isCorrect: boolean }[];
}

export function toMockPublicQuestion(q: McqQuestion): McqMockQuestion {
  return {
    id: q.id,
    subject_id: q.subject_id,
    exam_source: q.exam_source,
    scenario: q.scenario,
    choices: q.choices.map((c) => ({ label: c.label, text: c.text })),
    mcq_subjects: q.mcq_subjects,
  };
}

export function toMockReviewItem(
  q: Pick<McqQuestion, "id" | "correct_answer" | "explanation" | "detailed_explanation">,
): McqMockReviewItem {
  return {
    id: q.id,
    correct_answer: q.correct_answer ?? null,
    explanation: q.explanation ?? null,
    detailed_explanation: q.detailed_explanation ?? null,
  };
}

/**
 * แปลงคำตอบดิบจาก request ให้เหลือเฉพาะ id ที่อยู่ในชุด และค่าที่เป็นตัวอักษร
 * ตัวเลือกสั้นๆ (A-J) — อย่างอื่นถือว่าไม่ได้ตอบ
 */
export function sanitizeMockAnswers(raw: unknown, questionIds: readonly string[]): McqMockAnswers {
  const out: McqMockAnswers = {};
  const src = raw && typeof raw === "object" && !Array.isArray(raw) ? (raw as Record<string, unknown>) : {};
  for (const id of questionIds) {
    const v = Object.prototype.hasOwnProperty.call(src, id) ? src[id] : null;
    out[id] = typeof v === "string" && /^[A-J]$/.test(v) ? v : null;
  }
  return out;
}

/**
 * ตรวจตามลำดับ questionIds (ลำดับจาก token) — ข้อที่ไม่มีเฉลย (ไม่อยู่ใน
 * answerKey) นับเป็นผิด ไม่ตัดออกจาก total เพื่อให้จำนวนข้อตรงกับที่ออกให้
 */
export function gradeMockAnswers(
  questionIds: readonly string[],
  answerKey: ReadonlyMap<string, string | null>,
  answers: McqMockAnswers,
): McqMockGradeResult {
  let correctCount = 0;
  const perQuestion = questionIds.map((id) => {
    const selected = answers[id] ?? null;
    const correct = answerKey.get(id) ?? null;
    const isCorrect = selected !== null && correct !== null && selected === correct;
    if (isCorrect) correctCount++;
    return { id, selected, isCorrect };
  });
  return { correctCount, total: questionIds.length, perQuestion };
}

// --- response ของ /api/mcq/mock/submit ---

/** เหตุที่รอบนี้ไม่นับอันดับ (ยังได้คะแนน + เฉลยตามปกติ) */
export type MockUnrankedReason = "too_fast" | "expired" | "already_submitted" | "save_failed";

export interface MockSubmitResponse {
  /** mcq_sessions.id — ใช้เรียก get_mock_percentile; null ถ้าบันทึกไม่สำเร็จ */
  sessionId: string | null;
  /** true = แถวนี้ graded_by_server และถูกนับใน percentile */
  ranked: boolean;
  unrankedReason: MockUnrankedReason | null;
  correctCount: number;
  total: number;
  perQuestion: (McqMockReviewItem & { selected: string | null; isCorrect: boolean })[];
}
