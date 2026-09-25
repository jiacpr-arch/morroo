// คอลัมน์ของ mcq_questions ที่ role anon/authenticated อ่านได้ — pure ใช้ได้ทั้ง server และ client
//
// เฉลย (correct_answer, explanation, detailed_explanation, ai_notes) ถูก revoke
// จาก anon/authenticated ใน supabase/migrations/20260927_hide_mcq_answers.sql
// ทุก query ผ่าน client ของผู้ใช้ (lib/supabase/server.ts / client.ts) ต้อง select
// เฉพาะคอลัมน์ในนี้ ห้าม select("*") — ถ้าต้องการเฉลยให้อ่านด้วย service role
// (lib/supabase/admin.ts) ฝั่ง server หลังตรวจสิทธิ์แล้วเท่านั้น
// (ดู lib/mcq-public.guard.test.ts ที่กันไม่ให้ถอยกลับ)

import type { McqQuestion } from "./types-mcq";

/** คอลัมน์ที่ซ่อนจาก anon/authenticated */
export const MCQ_HIDDEN_COLUMNS = [
  "correct_answer",
  "explanation",
  "detailed_explanation",
  "ai_notes",
] as const;

export type McqHiddenColumn = (typeof MCQ_HIDDEN_COLUMNS)[number];

/** คอลัมน์ที่ grant select ให้ anon/authenticated — ต้องตรงกับ migration */
export const MCQ_PUBLIC_COLUMN_LIST = [
  "id",
  "subject_id",
  "exam_type",
  "exam_source",
  "question_number",
  "scenario",
  "choices",
  "difficulty",
  "is_ai_enhanced",
  "status",
  "created_at",
  "difficulty_level",
  "topic",
  "audience",
  "board_specialty",
  "board_subspecialty",
  "board_section",
  "board_topic",
  "board_age_group",
  "board_level",
  "reference_source",
] as const;

export const MCQ_PUBLIC_COLUMNS = MCQ_PUBLIC_COLUMN_LIST.join(", ");

/** select มาตรฐานสำหรับหน้าฝึก/สอบ — คอลัมน์สาธารณะ + ชื่อวิชา */
export const MCQ_PUBLIC_SELECT = `${MCQ_PUBLIC_COLUMNS}, mcq_subjects(name, name_th, icon)`;

/** ข้อสอบที่ไม่มีเฉลย — สิ่งที่ client ของผู้ใช้อ่านได้ */
export type McqPublicQuestion = Omit<McqQuestion, McqHiddenColumn> & {
  difficulty_level?: number | null;
  topic?: string | null;
};

/** เฉลยของข้อหนึ่ง — ได้จาก /api/mcq/reveal หรือฝังมาจาก server (ผู้ใช้ยังไม่ล็อกอิน) */
export interface McqAnswerKey {
  correct_answer: string;
  explanation: string | null;
  detailed_explanation: McqQuestion["detailed_explanation"];
}

/** ข้อสอบโหมดฝึก — answerKey มีเฉพาะข้อที่ server ฝังเฉลยมาให้แล้ว */
export type McqPracticeQuestion = McqPublicQuestion & { answerKey?: McqAnswerKey };

/** response ของ POST /api/mcq/reveal */
export interface McqRevealResponse extends McqAnswerKey {
  isCorrect: boolean;
}

/** ตัดคอลัมน์เฉลยออก (ใช้กับแถวที่อ่านด้วย service role ก่อนส่งให้ browser) */
export function toPublicQuestion<T extends Partial<McqQuestion>>(q: T): Omit<T, McqHiddenColumn> {
  const out = { ...q } as Record<string, unknown>;
  for (const col of MCQ_HIDDEN_COLUMNS) delete out[col];
  return out as Omit<T, McqHiddenColumn>;
}

export function toAnswerKey(
  q: Pick<McqQuestion, "correct_answer" | "explanation" | "detailed_explanation">,
): McqAnswerKey {
  return {
    correct_answer: q.correct_answer,
    explanation: q.explanation ?? null,
    detailed_explanation: q.detailed_explanation ?? null,
  };
}

/** ตัวเลือกที่ส่งมาถูกรูปแบบไหม (ตัวอักษร A-J ตัวเดียว เหมือน mock) */
export function isChoiceLabel(v: unknown): v is string {
  return typeof v === "string" && /^[A-J]$/.test(v);
}
