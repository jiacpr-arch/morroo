import { describe, it, expect } from "vitest";
import {
  parseCsv, validateAndMapMcq, MCQ_CSV_HEADERS,
  type AdminStudentSubject,
} from "./mcq-import";

const subjects: AdminStudentSubject[] = [
  { id: "sub-surg", name: "surgery", name_th: "ศัลยศาสตร์" },
];

function makeCsv(row: Record<string, string>): string {
  const headerLine = MCQ_CSV_HEADERS.join(",");
  const dataLine = MCQ_CSV_HEADERS.map((h) => {
    const v = row[h] ?? "";
    return /[,"\n]/.test(v) ? `"${v.replace(/"/g, '""')}"` : v;
  }).join(",");
  return `${headerLine}\n${dataLine}`;
}

const validRow: Record<string, string> = {
  subject: "surgery",
  exam_type: "NL2",
  exam_source: "ศรว 2562",
  question_number: "1",
  scenario: "ผู้ป่วยชาย 30 ปี ปวดท้องน้อยขวา...",
  choice_a: "Acute appendicitis",
  choice_b: "Acute cholecystitis",
  choice_c: "Ureteric stone",
  choice_d: "Diverticulitis",
  choice_e: "Mesenteric adenitis",
  correct: "A",
  difficulty: "medium",
  status: "review",
};

describe("validateAndMapMcq", () => {
  it("accepts a fully valid student row", () => {
    const res = validateAndMapMcq(parseCsv(makeCsv(validRow)), subjects);
    expect(res.headerError).toBeNull();
    expect(res.parsed).toHaveLength(1);
    expect(res.parsed[0].errors).toEqual([]);
    expect(res.parsed[0].insert).toMatchObject({
      subject_id: "sub-surg",
      audience: "student",
      exam_type: "NL2",
      exam_source: "ศรว 2562",
      question_number: 1,
      correct_answer: "A",
      difficulty: "medium",
      status: "review",
      board_specialty: null,
      board_section: null,
    });
    expect(res.parsed[0].insert?.choices).toHaveLength(5);
  });

  it("flags unknown subject", () => {
    const res = validateAndMapMcq(parseCsv(makeCsv({ ...validRow, subject: "ghost" })), subjects);
    expect(res.parsed[0].insert).toBeNull();
    expect(res.parsed[0].errors.join(" ")).toMatch(/ghost/);
  });

  it("flags bad exam_type", () => {
    const res = validateAndMapMcq(parseCsv(makeCsv({ ...validRow, exam_type: "NL9" })), subjects);
    expect(res.parsed[0].errors.join(" ")).toMatch(/exam_type/);
  });

  it("flags bad correct answer", () => {
    const res = validateAndMapMcq(parseCsv(makeCsv({ ...validRow, correct: "F" })), subjects);
    expect(res.parsed[0].errors.join(" ")).toMatch(/correct/);
  });

  it("flags missing choices", () => {
    const res = validateAndMapMcq(parseCsv(makeCsv({ ...validRow, choice_e: "" })), subjects);
    expect(res.parsed[0].errors.join(" ")).toMatch(/choice_e/);
  });

  it("defaults status to 'review' and difficulty to 'medium' when blank", () => {
    const res = validateAndMapMcq(
      parseCsv(makeCsv({ ...validRow, status: "", difficulty: "" })),
      subjects
    );
    expect(res.parsed[0].errors).toEqual([]);
    expect(res.parsed[0].insert?.status).toBe("review");
    expect(res.parsed[0].insert?.difficulty).toBe("medium");
  });

  it("allows blank exam_source and question_number", () => {
    const res = validateAndMapMcq(
      parseCsv(makeCsv({ ...validRow, exam_source: "", question_number: "" })),
      subjects
    );
    expect(res.parsed[0].errors).toEqual([]);
    expect(res.parsed[0].insert).toMatchObject({
      exam_source: null,
      question_number: null,
    });
  });

  it("flags non-numeric question_number", () => {
    const res = validateAndMapMcq(parseCsv(makeCsv({ ...validRow, question_number: "1a" })), subjects);
    expect(res.parsed[0].errors.join(" ")).toMatch(/question_number/);
  });

  it("returns headerError when columns missing", () => {
    const res = validateAndMapMcq([["subject", "exam_type"]], subjects);
    expect(res.headerError).toMatch(/ขาดคอลัมน์/);
  });
});
