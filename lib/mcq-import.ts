// CSV bulk import helpers for NL (student) MCQ questions.
// Sibling of board-import.ts — keeps parsing + validation + row→insert mapping
// for /admin/mcq/import in one module. Reuses the RFC-4180 parser from
// board-import.ts so we don't duplicate CSV plumbing.

import { parseCsv } from "./board-import";
import type { McqChoice } from "./types-mcq";
import type { McqQuestionInput } from "./supabase/mutations-mcq-admin";

export { parseCsv };

export interface AdminStudentSubject {
  id: string;
  /** slug, matched case-sensitively against the CSV `subject` column */
  name: string;
  name_th: string;
}

export interface ParsedMcqRow {
  /** 1-indexed row number in the source CSV (data rows; header is row 0) */
  rowNum: number;
  raw: Record<string, string>;
  errors: string[];
  insert: McqQuestionInput | null;
}

export const MCQ_CSV_HEADERS = [
  "subject",
  "exam_type",
  "exam_source",
  "question_number",
  "scenario",
  "choice_a",
  "choice_b",
  "choice_c",
  "choice_d",
  "choice_e",
  "correct",
  "difficulty",
  "status",
] as const;

export type McqCsvHeader = (typeof MCQ_CSV_HEADERS)[number];

const VALID_EXAM_TYPE = new Set(["NL1", "NL2"]);
const VALID_DIFFICULTY = new Set(["easy", "medium", "hard"]);
const VALID_CORRECT = new Set(["A", "B", "C", "D", "E"]);
const VALID_STATUS = new Set(["active", "review", "disabled"]);

/**
 * Validate parsed CSV rows and map each valid one to an McqQuestionInput.
 *
 * Notes on intent:
 * - `correct` is the answer extracted from the source PDF — treated as a
 *   *draft*. Rows default to `status=review` so they stay hidden from learners
 *   (RLS only exposes status='active') until an admin verifies the key and
 *   writes the explanation. The blank default is therefore "review", not "active".
 * - student rows always carry exam_type (NL1/NL2) and null board_* fields to
 *   satisfy the mcq_questions audience-consistency CHECK constraint.
 */
export function validateAndMapMcq(
  rows: string[][],
  subjects: AdminStudentSubject[]
): { headerError: string | null; parsed: ParsedMcqRow[] } {
  if (rows.length === 0) {
    return { headerError: "ไฟล์ว่างเปล่า", parsed: [] };
  }
  const header = rows[0].map((h) => h.trim().toLowerCase());
  const missing = MCQ_CSV_HEADERS.filter((h) => !header.includes(h));
  if (missing.length > 0) {
    return { headerError: `ขาดคอลัมน์: ${missing.join(", ")}`, parsed: [] };
  }

  const idx = Object.fromEntries(
    MCQ_CSV_HEADERS.map((h) => [h, header.indexOf(h)])
  ) as Record<McqCsvHeader, number>;

  const subjectByName = new Map(subjects.map((s) => [s.name, s]));

  const parsed: ParsedMcqRow[] = [];

  for (let r = 1; r < rows.length; r++) {
    const cols = rows[r];
    const get = (h: McqCsvHeader) => (cols[idx[h]] ?? "").trim();

    const raw: Record<string, string> = {};
    for (const h of MCQ_CSV_HEADERS) raw[h] = get(h);

    const errors: string[] = [];

    const subjectName = raw.subject;
    const examType = raw.exam_type.toUpperCase();
    const scenario = raw.scenario;
    const choiceA = raw.choice_a;
    const choiceB = raw.choice_b;
    const choiceC = raw.choice_c;
    const choiceD = raw.choice_d;
    const choiceE = raw.choice_e;
    const correct = raw.correct.toUpperCase();
    const difficulty = (raw.difficulty || "medium").toLowerCase();
    const status = (raw.status || "review").toLowerCase();
    const questionNumber = raw.question_number;

    const subject = subjectByName.get(subjectName);
    if (!subjectName) errors.push("ขาด subject");
    else if (!subject)
      errors.push(`subject "${subjectName}" ไม่พบใน mcq_subjects (audience=student)`);

    if (!examType) errors.push("ขาด exam_type");
    else if (!VALID_EXAM_TYPE.has(examType))
      errors.push(`exam_type "${examType}" ต้องเป็น NL1 หรือ NL2`);

    if (!VALID_DIFFICULTY.has(difficulty))
      errors.push(`difficulty "${difficulty}" ไม่ถูกต้อง`);
    if (!VALID_CORRECT.has(correct)) errors.push(`correct "${correct}" ต้องเป็น A-E`);
    if (!VALID_STATUS.has(status)) errors.push(`status "${status}" ไม่ถูกต้อง`);

    if (!scenario) errors.push("ขาด scenario");
    for (const [k, v] of [
      ["choice_a", choiceA],
      ["choice_b", choiceB],
      ["choice_c", choiceC],
      ["choice_d", choiceD],
      ["choice_e", choiceE],
    ] as const) {
      if (!v) errors.push(`ขาด ${k}`);
    }

    if (questionNumber && !/^\d+$/.test(questionNumber)) {
      errors.push(`question_number "${questionNumber}" ต้องเป็นตัวเลข`);
    }

    let insert: McqQuestionInput | null = null;
    if (errors.length === 0 && subject) {
      const choices: McqChoice[] = [
        { label: "A", text: choiceA },
        { label: "B", text: choiceB },
        { label: "C", text: choiceC },
        { label: "D", text: choiceD },
        { label: "E", text: choiceE },
      ];
      insert = {
        subject_id: subject.id,
        audience: "student",
        exam_type: examType as "NL1" | "NL2",
        exam_source: raw.exam_source || null,
        question_number: questionNumber ? Number(questionNumber) : null,
        scenario,
        choices,
        correct_answer: correct,
        explanation: null,
        difficulty: difficulty as "easy" | "medium" | "hard",
        topic: null,
        status: status as "active" | "review" | "disabled",
        board_specialty: null,
        board_subspecialty: null,
        board_section: null,
        board_topic: null,
        board_age_group: null,
        board_level: null,
        reference_source: null,
      };
    }

    parsed.push({ rowNum: r, raw, errors, insert });
  }

  return { headerError: null, parsed };
}

export function buildMcqSampleCsv(): string {
  return [
    MCQ_CSV_HEADERS.join(","),
    [
      "surgery",
      "NL2",
      '"ศรว 2562"',
      "1",
      '"ผู้ป่วยชาย 30 ปี มาด้วยปวดท้องน้อยขวา 1 วัน ตรวจพบ McBurney point tenderness, Rovsing sign positive..."',
      '"Acute appendicitis"',
      '"Acute cholecystitis"',
      '"Ureteric stone"',
      '"Diverticulitis"',
      '"Mesenteric adenitis"',
      "A",
      "medium",
      "review",
    ].join(","),
  ].join("\n");
}
