import { describe, it, expect } from "vitest";
import {
  parseCsv, validateAndMap, CSV_HEADERS,
  type AdminBoardSubject, type AdminBoardTopicRef,
} from "./board-import";

describe("parseCsv", () => {
  it("parses simple rows", () => {
    expect(parseCsv("a,b,c\n1,2,3")).toEqual([["a","b","c"],["1","2","3"]]);
  });

  it("handles quoted fields with commas", () => {
    expect(parseCsv('a,b\n"hello, world","x"')).toEqual([
      ["a","b"], ["hello, world","x"],
    ]);
  });

  it("handles escaped quotes", () => {
    expect(parseCsv('a\n"he said ""hi"""')).toEqual([["a"], ['he said "hi"']]);
  });

  it("handles CRLF and trailing blank lines", () => {
    expect(parseCsv("a,b\r\n1,2\r\n\r\n")).toEqual([["a","b"],["1","2"]]);
  });

  it("handles newlines inside quoted fields", () => {
    expect(parseCsv('a\n"line1\nline2"')).toEqual([["a"],["line1\nline2"]]);
  });

  it("strips BOM", () => {
    expect(parseCsv("﻿a,b\n1,2")).toEqual([["a","b"],["1","2"]]);
  });
});

const subjects: AdminBoardSubject[] = [
  { id: "sub-em", name_th: "เวชศาสตร์ฉุกเฉิน", board_specialty: "emergency-medicine" },
];
const topics: AdminBoardTopicRef[] = [
  { specialty_slug: "emergency-medicine", section_code: "clinical_decision", slug: "sepsis" },
];

function makeCsv(row: Record<string, string>): string {
  const headerLine = CSV_HEADERS.join(",");
  const dataLine = CSV_HEADERS.map((h) => {
    const v = row[h] ?? "";
    return /[,"\n]/.test(v) ? `"${v.replace(/"/g, '""')}"` : v;
  }).join(",");
  return `${headerLine}\n${dataLine}`;
}

const validRow: Record<string, string> = {
  specialty: "emergency-medicine",
  section: "clinical_decision",
  topic: "sepsis",
  age_group: "adult",
  level: "2",
  difficulty: "medium",
  scenario: "ผู้ป่วยชาย 65 ปี...",
  choice_a: "Septic shock",
  choice_b: "Cardiogenic",
  choice_c: "Hypovolemic",
  choice_d: "Anaphylactic",
  choice_e: "Neurogenic",
  correct: "A",
  explanation: "เพราะ...",
  reference: "Tintinalli",
  status: "active",
};

describe("validateAndMap", () => {
  it("accepts a fully valid row", () => {
    const res = validateAndMap(parseCsv(makeCsv(validRow)), subjects, topics);
    expect(res.headerError).toBeNull();
    expect(res.parsed).toHaveLength(1);
    expect(res.parsed[0].errors).toEqual([]);
    expect(res.parsed[0].insert).toMatchObject({
      subject_id: "sub-em",
      audience: "board",
      board_specialty: "emergency-medicine",
      board_section: "clinical_decision",
      board_topic: "sepsis",
      board_age_group: "adult",
      board_level: 2,
      correct_answer: "A",
      difficulty: "medium",
      status: "active",
    });
    expect(res.parsed[0].insert?.choices).toHaveLength(5);
  });

  it("flags unknown specialty", () => {
    const csv = makeCsv({ ...validRow, specialty: "ghost-spec" });
    const res = validateAndMap(parseCsv(csv), subjects, topics);
    expect(res.parsed[0].insert).toBeNull();
    expect(res.parsed[0].errors.join(" ")).toMatch(/ghost-spec/);
  });

  it("flags topic not in blueprint", () => {
    const csv = makeCsv({ ...validRow, topic: "not-a-topic" });
    const res = validateAndMap(parseCsv(csv), subjects, topics);
    expect(res.parsed[0].errors.join(" ")).toMatch(/blueprint/);
  });

  it("flags bad correct answer", () => {
    const csv = makeCsv({ ...validRow, correct: "F" });
    const res = validateAndMap(parseCsv(csv), subjects, topics);
    expect(res.parsed[0].errors.join(" ")).toMatch(/correct/);
  });

  it("flags missing choices", () => {
    const csv = makeCsv({ ...validRow, choice_c: "" });
    const res = validateAndMap(parseCsv(csv), subjects, topics);
    expect(res.parsed[0].errors.join(" ")).toMatch(/choice_c/);
  });

  it("returns headerError when columns missing", () => {
    const res = validateAndMap([["specialty","section"]], subjects, topics);
    expect(res.headerError).toMatch(/ขาดคอลัมน์/);
  });

  it("defaults status to 'review' if blank", () => {
    const csv = makeCsv({ ...validRow, status: "" });
    const res = validateAndMap(parseCsv(csv), subjects, topics);
    expect(res.parsed[0].insert?.status).toBe("review");
  });

  it("allows blank optional fields (age, level, reference, explanation)", () => {
    const csv = makeCsv({
      ...validRow, age_group: "", level: "", reference: "", explanation: "",
    });
    const res = validateAndMap(parseCsv(csv), subjects, topics);
    expect(res.parsed[0].errors).toEqual([]);
    expect(res.parsed[0].insert).toMatchObject({
      board_age_group: null, board_level: null,
      reference_source: null, explanation: null,
    });
  });
});
