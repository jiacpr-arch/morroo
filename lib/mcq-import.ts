// Bulk import helpers for NL (student) MCQ questions.
// Shared by the CSV importer (/admin/mcq/import) and the AI PDF importer
// (/admin/mcq/import-pdf): both produce "raw row" objects and run them through
// the same validator → McqQuestionInput. Reuses the RFC-4180 parser from
// board-import.ts so we don't duplicate CSV plumbing.

import { parseCsv } from "./board-import";
import type { McqChoice } from "./types-mcq";
import type { McqQuestionInput } from "./supabase/mutations-mcq-admin";

export { parseCsv };

export interface AdminStudentSubject {
  id: string;
  /** slug, matched case-sensitively against the `subject` field */
  name: string;
  name_th: string;
}

export interface ParsedMcqRow {
  /** 1-indexed row number (data rows; header is row 0 for CSV) */
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

/** Object form of one row (keys = MCQ_CSV_HEADERS). The AI importer builds these
 *  directly; the CSV importer builds them from parsed CSV cells. */
export type RawMcqRow = Partial<Record<McqCsvHeader, string>>;

const VALID_EXAM_TYPE = new Set(["NL1", "NL2"]);
const VALID_DIFFICULTY = new Set(["easy", "medium", "hard"]);
const VALID_CORRECT = new Set(["A", "B", "C", "D", "E"]);
const VALID_STATUS = new Set(["active", "review", "disabled"]);

/**
 * Validate one raw row and map it to an McqQuestionInput.
 *
 * Intent:
 * - `correct` is a *draft* from the source — when blank we store a placeholder
 *   "A" (the admin sets the real answer during review). Rows default to
 *   `status=review` so they stay hidden from learners (RLS exposes only active)
 *   until verified.
 * - student rows always carry exam_type (NL1/NL2) and null board_* fields to
 *   satisfy the mcq_questions audience-consistency CHECK constraint.
 */
function mapOneRow(
  raw: Record<string, string>,
  rowNum: number,
  subjectByName: Map<string, AdminStudentSubject>
): ParsedMcqRow {
  const errors: string[] = [];

  const subjectName = (raw.subject ?? "").trim();
  const examType = (raw.exam_type ?? "").trim().toUpperCase();
  const scenario = (raw.scenario ?? "").trim();
  const choiceA = (raw.choice_a ?? "").trim();
  const choiceB = (raw.choice_b ?? "").trim();
  const choiceC = (raw.choice_c ?? "").trim();
  const choiceD = (raw.choice_d ?? "").trim();
  const choiceE = (raw.choice_e ?? "").trim();
  const correctRaw = (raw.correct ?? "").trim().toUpperCase();
  const difficulty = ((raw.difficulty ?? "").trim() || "medium").toLowerCase();
  const status = ((raw.status ?? "").trim() || "review").toLowerCase();
  const questionNumber = (raw.question_number ?? "").trim();

  const subject = subjectByName.get(subjectName);
  if (!subjectName) errors.push("ขาด subject");
  else if (!subject)
    errors.push(`subject "${subjectName}" ไม่พบใน mcq_subjects (audience=student)`);

  if (!examType) errors.push("ขาด exam_type");
  else if (!VALID_EXAM_TYPE.has(examType))
    errors.push(`exam_type "${examType}" ต้องเป็น NL1 หรือ NL2`);

  if (!VALID_DIFFICULTY.has(difficulty))
    errors.push(`difficulty "${difficulty}" ไม่ถูกต้อง`);
  // correct may be blank (→ placeholder "A"); if provided it must be A-E
  if (correctRaw && !VALID_CORRECT.has(correctRaw))
    errors.push(`correct "${correctRaw}" ต้องเป็น A-E`);
  if (!VALID_STATUS.has(status)) errors.push(`status "${status}" ไม่ถูกต้อง`);

  if (!scenario) errors.push("ขาด scenario");

  // Keep only non-empty choices. NL MCQ have 4–5 options, so require ≥4 — this
  // lets legit 4-option questions through while dropping truncated 1–3 ones.
  const presentChoices: McqChoice[] = (
    [
      ["A", choiceA],
      ["B", choiceB],
      ["C", choiceC],
      ["D", choiceD],
      ["E", choiceE],
    ] as const
  )
    .filter(([, t]) => t)
    .map(([label, text]) => ({ label, text }));
  const presentLabels = presentChoices.map((c) => c.label);
  if (presentChoices.length < 4) {
    errors.push(`ตัวเลือกไม่ครบ (ต้องมี ≥4 ตัว, ได้ ${presentChoices.length})`);
  }

  if (questionNumber && !/^\d+$/.test(questionNumber)) {
    errors.push(`question_number "${questionNumber}" ต้องเป็นตัวเลข`);
  }

  let insert: McqQuestionInput | null = null;
  if (errors.length === 0 && subject) {
    insert = {
      subject_id: subject.id,
      audience: "student",
      exam_type: examType as "NL1" | "NL2",
      exam_source: (raw.exam_source ?? "").trim() || null,
      question_number: questionNumber ? Number(questionNumber) : null,
      scenario,
      choices: presentChoices,
      // placeholder when the source has no (usable) answer — admin verifies
      correct_answer:
        correctRaw && presentLabels.includes(correctRaw)
          ? correctRaw
          : presentLabels[0],
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

  return { rowNum, raw: { ...raw }, errors, insert };
}

/** Validate a list of raw row objects (used by the AI PDF importer). */
export function validateMcqRows(
  raws: RawMcqRow[],
  subjects: AdminStudentSubject[]
): ParsedMcqRow[] {
  const subjectByName = new Map(subjects.map((s) => [s.name, s]));
  return raws.map((raw, i) =>
    mapOneRow(raw as Record<string, string>, i + 1, subjectByName)
  );
}

/** CSV entry point: header check + parse cells into raw rows, then validate. */
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

  const raws: RawMcqRow[] = rows.slice(1).map((cols) => {
    const raw: RawMcqRow = {};
    for (const h of MCQ_CSV_HEADERS) raw[h] = (cols[idx[h]] ?? "").trim();
    return raw;
  });

  return { headerError: null, parsed: validateMcqRows(raws, subjects) };
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
