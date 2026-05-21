// CSV bulk import helpers for board MCQ questions
// Used by /admin/board/import — keeps parsing + validation + row→insert mapping
// in one module so the UI stays declarative.

import { BOARD_SECTIONS } from "./types-board";
import type { McqChoice } from "./types-mcq";

export interface AdminBoardSubject {
  id: string;
  name_th: string;
  board_specialty: string;
}

export interface AdminBoardTopicRef {
  specialty_slug: string;
  section_code: string;
  slug: string;
}

export interface ParsedRow {
  /** 1-indexed row number in the source CSV (data rows; header is row 0) */
  rowNum: number;
  raw: Record<string, string>;
  errors: string[];
  insert: BoardInsertPayload | null;
}

export interface BoardInsertPayload {
  subject_id: string;
  audience: "board";
  exam_type: null;
  scenario: string;
  choices: McqChoice[];
  correct_answer: string;
  explanation: string | null;
  difficulty: "easy" | "medium" | "hard";
  topic: string | null;
  status: "active" | "review" | "disabled";
  board_specialty: string;
  board_section: string;
  board_topic: string;
  board_age_group: "peds" | "adult" | "mixed" | null;
  board_level: number | null;
  reference_source: string | null;
}

export const CSV_HEADERS = [
  "specialty",
  "section",
  "topic",
  "age_group",
  "level",
  "difficulty",
  "scenario",
  "choice_a",
  "choice_b",
  "choice_c",
  "choice_d",
  "choice_e",
  "correct",
  "explanation",
  "reference",
  "status",
] as const;

export type CsvHeader = (typeof CSV_HEADERS)[number];

/**
 * Minimal RFC-4180 CSV parser. Handles quoted fields, escaped quotes (""),
 * commas and newlines inside quotes. Returns rows as string[][].
 */
export function parseCsv(text: string): string[][] {
  const rows: string[][] = [];
  let row: string[] = [];
  let field = "";
  let inQuotes = false;
  // Strip BOM
  if (text.charCodeAt(0) === 0xfeff) text = text.slice(1);

  for (let i = 0; i < text.length; i++) {
    const c = text[i];
    if (inQuotes) {
      if (c === '"') {
        if (text[i + 1] === '"') {
          field += '"';
          i++;
        } else {
          inQuotes = false;
        }
      } else {
        field += c;
      }
      continue;
    }
    if (c === '"') {
      inQuotes = true;
      continue;
    }
    if (c === ",") {
      row.push(field);
      field = "";
      continue;
    }
    if (c === "\n" || c === "\r") {
      // Handle \r\n: skip the \n on next iter
      if (c === "\r" && text[i + 1] === "\n") i++;
      row.push(field);
      // Drop fully-empty trailing lines
      if (row.length > 1 || row[0] !== "") rows.push(row);
      row = [];
      field = "";
      continue;
    }
    field += c;
  }
  // Flush last field/row
  if (field.length > 0 || row.length > 0) {
    row.push(field);
    if (row.length > 1 || row[0] !== "") rows.push(row);
  }
  return rows;
}

const VALID_SECTIONS: Set<string> = new Set(BOARD_SECTIONS.map((s) => s.code));
const VALID_DIFFICULTY = new Set(["easy", "medium", "hard"]);
const VALID_AGE = new Set(["peds", "adult", "mixed"]);
const VALID_LEVEL = new Set(["1", "2", "3"]);
const VALID_CORRECT = new Set(["A", "B", "C", "D", "E"]);
const VALID_STATUS = new Set(["active", "review", "disabled"]);

export function validateAndMap(
  rows: string[][],
  subjects: AdminBoardSubject[],
  topics: AdminBoardTopicRef[]
): { headerError: string | null; parsed: ParsedRow[] } {
  if (rows.length === 0) {
    return { headerError: "ไฟล์ว่างเปล่า", parsed: [] };
  }
  const header = rows[0].map((h) => h.trim().toLowerCase());
  const missing = CSV_HEADERS.filter((h) => !header.includes(h));
  if (missing.length > 0) {
    return {
      headerError: `ขาดคอลัมน์: ${missing.join(", ")}`,
      parsed: [],
    };
  }

  const idx = Object.fromEntries(
    CSV_HEADERS.map((h) => [h, header.indexOf(h)])
  ) as Record<CsvHeader, number>;

  const subjectBySpecialty = new Map(
    subjects.map((s) => [s.board_specialty, s])
  );
  const topicKey = (sp: string, sec: string, tp: string) => `${sp}::${sec}::${tp}`;
  const topicSet = new Set(
    topics.map((t) => topicKey(t.specialty_slug, t.section_code, t.slug))
  );

  const parsed: ParsedRow[] = [];

  for (let r = 1; r < rows.length; r++) {
    const cols = rows[r];
    const get = (h: CsvHeader) => (cols[idx[h]] ?? "").trim();

    const raw: Record<string, string> = {};
    for (const h of CSV_HEADERS) raw[h] = get(h);

    const errors: string[] = [];

    const specialty = raw.specialty;
    const section = raw.section;
    const topic = raw.topic;
    const age = raw.age_group;
    const level = raw.level;
    const difficulty = raw.difficulty.toLowerCase();
    const scenario = raw.scenario;
    const choiceA = raw.choice_a;
    const choiceB = raw.choice_b;
    const choiceC = raw.choice_c;
    const choiceD = raw.choice_d;
    const choiceE = raw.choice_e;
    const correct = raw.correct.toUpperCase();
    const explanation = raw.explanation;
    const reference = raw.reference;
    const status = (raw.status || "review").toLowerCase();

    const subject = subjectBySpecialty.get(specialty);
    if (!specialty) errors.push("ขาด specialty");
    else if (!subject) errors.push(`specialty "${specialty}" ไม่พบใน mcq_subjects`);

    if (!section) errors.push("ขาด section");
    else if (!VALID_SECTIONS.has(section)) errors.push(`section "${section}" ไม่ถูกต้อง`);

    if (!topic) errors.push("ขาด topic");
    else if (specialty && section && !topicSet.has(topicKey(specialty, section, topic))) {
      errors.push(`topic "${topic}" ไม่อยู่ใน blueprint (${specialty}/${section})`);
    }

    if (age && !VALID_AGE.has(age)) errors.push(`age_group "${age}" ไม่ถูกต้อง`);
    if (level && !VALID_LEVEL.has(level)) errors.push(`level "${level}" ไม่ถูกต้อง`);
    if (!VALID_DIFFICULTY.has(difficulty)) errors.push(`difficulty "${difficulty}" ไม่ถูกต้อง`);
    if (!VALID_CORRECT.has(correct)) errors.push(`correct "${correct}" ต้องเป็น A-E`);
    if (!VALID_STATUS.has(status)) errors.push(`status "${status}" ไม่ถูกต้อง`);

    if (!scenario) errors.push("ขาด scenario");
    for (const [k, v] of [
      ["choice_a", choiceA], ["choice_b", choiceB], ["choice_c", choiceC],
      ["choice_d", choiceD], ["choice_e", choiceE],
    ] as const) {
      if (!v) errors.push(`ขาด ${k}`);
    }

    let insert: BoardInsertPayload | null = null;
    if (errors.length === 0 && subject) {
      insert = {
        subject_id: subject.id,
        audience: "board",
        exam_type: null,
        scenario,
        choices: [
          { label: "A", text: choiceA },
          { label: "B", text: choiceB },
          { label: "C", text: choiceC },
          { label: "D", text: choiceD },
          { label: "E", text: choiceE },
        ],
        correct_answer: correct,
        explanation: explanation || null,
        difficulty: difficulty as "easy" | "medium" | "hard",
        topic: topic || null,
        status: status as "active" | "review" | "disabled",
        board_specialty: specialty,
        board_section: section,
        board_topic: topic,
        board_age_group: age ? (age as "peds" | "adult" | "mixed") : null,
        board_level: level ? Number(level) : null,
        reference_source: reference || null,
      };
    }

    parsed.push({ rowNum: r, raw, errors, insert });
  }

  return { headerError: null, parsed };
}

export function buildSampleCsv(): string {
  return [
    CSV_HEADERS.join(","),
    [
      "emergency-medicine",
      "clinical_decision",
      "sepsis-septic-shock",
      "adult",
      "2",
      "medium",
      '"ผู้ป่วยชาย 65 ปี มาด้วยไข้สูง ซึม BP 80/50 HR 130..."',
      '"Septic shock"',
      '"Cardiogenic shock"',
      '"Hypovolemic shock"',
      '"Anaphylactic shock"',
      '"Neurogenic shock"',
      "A",
      '"qSOFA ≥2 + suspected infection + hypotension despite fluid = septic shock"',
      "Tintinalli ch.135",
      "active",
    ].join(","),
  ].join("\n");
}
