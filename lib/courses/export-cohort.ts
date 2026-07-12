// Cohort CSV/PDF export — ported from acls-emr's src/utils/exportPreCourse.js
// for the instructor dashboard (components/courses/InstructorCohort.tsx).
//
// Simplification vs. the source: acls-emr rendered PDF tables with the
// `jspdf-autotable` plugin. That package isn't installed in morroo (per the
// "no new npm dependencies" constraint — only jsPDF + its Sarabun font are
// available, via lib/courses/cert/), so tables here are hand-drawn with a
// small grid helper (drawTable below) that reproduces the same look
// (branded header row, bordered cells, automatic page breaks).

import { jsPDF } from "jspdf";
import { registerPDFFonts, PDF_FONT } from "./cert/fonts/register-fonts";
import { sanitisePDFText as S } from "./cert/pdf-text";
import { getCertConfig } from "./cert/config";
import type { CourseMode } from "./config";
import type { CohortTableRow } from "@/components/courses/CohortTable";

registerPDFFonts();

function fmtDate(iso: string | null | undefined): string {
  if (!iso) return "-";
  try {
    return new Date(iso).toLocaleString("en-GB", {
      year: "numeric",
      month: "short",
      day: "2-digit",
      hour: "2-digit",
      minute: "2-digit",
    });
  } catch {
    return iso;
  }
}

function brandedHeader(doc: jsPDF, title: string, brandColor: [number, number, number]) {
  const pw = doc.internal.pageSize.getWidth();
  doc.setFillColor(...brandColor);
  doc.rect(0, 0, pw, 14, "F");
  doc.setFontSize(12);
  doc.setFont(PDF_FONT, "bold");
  doc.setTextColor(255);
  doc.text(S(title), pw / 2, 7, { align: "center" });
  doc.setFontSize(7);
  doc.text("JIA Trainer Center — jia1669.com", pw / 2, 12, { align: "center" });
  doc.setTextColor(0);
}

function pageFooter(doc: jsPDF, label: string) {
  const pw = doc.internal.pageSize.getWidth();
  const ph = doc.internal.pageSize.getHeight();
  const pages = doc.getNumberOfPages();
  for (let i = 1; i <= pages; i++) {
    doc.setPage(i);
    doc.setFontSize(6.5);
    doc.setTextColor(150);
    doc.setFont(PDF_FONT, "normal");
    doc.text(
      `${label} | สร้างเมื่อ ${new Date().toLocaleString("en-GB")} | หน้า ${i}/${pages}`,
      pw / 2,
      ph - 6,
      { align: "center" },
    );
  }
  doc.setTextColor(0);
}

// ---- hand-rolled grid table (jspdf-autotable stand-in) ----

interface TableColumn {
  header: string;
  width: number; // mm
  align?: "left" | "center" | "right";
}

const ROW_H = 6.4;
const HEAD_H = 6.4;
const BODY_FONT_SIZE = 7.5;
const BOTTOM_MARGIN = 15;

function drawTable(
  doc: jsPDF,
  {
    startY,
    marginLeft,
    columns,
    rows,
    brandColor,
  }: {
    startY: number;
    marginLeft: number;
    columns: TableColumn[];
    rows: string[][];
    brandColor: [number, number, number];
  },
): number {
  const pageHeight = doc.internal.pageSize.getHeight();
  let y = startY;

  const drawHead = () => {
    let x = marginLeft;
    doc.setFont(PDF_FONT, "bold");
    doc.setFontSize(BODY_FONT_SIZE);
    columns.forEach((col) => {
      doc.setFillColor(...brandColor);
      doc.setDrawColor(...brandColor);
      doc.rect(x, y, col.width, HEAD_H, "FD");
      doc.setTextColor(255);
      doc.text(S(col.header), x + col.width / 2, y + HEAD_H / 2 + 1, {
        align: "center",
        maxWidth: col.width - 2,
      });
      x += col.width;
    });
    y += HEAD_H;
    doc.setTextColor(0);
    doc.setFont(PDF_FONT, "normal");
  };

  drawHead();

  rows.forEach((row) => {
    if (y + ROW_H > pageHeight - BOTTOM_MARGIN) {
      doc.addPage();
      y = 18;
      drawHead();
    }
    let x = marginLeft;
    doc.setDrawColor(215);
    doc.setFontSize(BODY_FONT_SIZE);
    columns.forEach((col, i) => {
      doc.rect(x, y, col.width, ROW_H);
      const align = col.align ?? "left";
      const tx = align === "center" ? x + col.width / 2 : align === "right" ? x + col.width - 1.5 : x + 1.5;
      doc.text(S(row[i] ?? "-"), tx, y + ROW_H / 2 + 1.2, {
        align,
        maxWidth: col.width - 3,
      });
      x += col.width;
    });
    y += ROW_H;
  });

  return y;
}

function triggerCSVDownload(csv: string, filename: string) {
  // UTF-8 BOM so Excel opens Thai correctly.
  const blob = new Blob(["﻿" + csv], { type: "text/csv;charset=utf-8;" });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = filename;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);
}

function esc(v: unknown): string {
  if (v == null) return "";
  const s = String(v);
  if (/[",\n]/.test(s)) return `"${s.replace(/"/g, '""')}"`;
  return s;
}

// ===== per-lesson cohort export =====

export interface ExportLesson {
  id?: string;
  title?: string;
  passingScore?: number;
}

/** Export the whole cohort (for the selected lesson/pre-test/post-test) as a PDF table. */
export function exportCohortPDF({
  rows,
  lesson,
  course,
}: {
  rows: CohortTableRow[];
  lesson: ExportLesson | null | undefined;
  course: CourseMode;
}) {
  const cert = getCertConfig(course);
  const doc = new jsPDF("p", "mm", "a4");
  doc.setFont(PDF_FONT, "normal");
  brandedHeader(doc, `รายงานรวมทั้งกลุ่ม (${cert.subtitle})`, cert.brandColor);
  let y = 18;

  doc.setFontSize(10);
  doc.setFont(PDF_FONT, "bold");
  doc.text(`บทเรียน: ${S(lesson?.title || lesson?.id) || "-"}`, 14, y);
  y += 4;
  doc.setFontSize(8);
  doc.setFont(PDF_FONT, "normal");
  doc.text(`เกณฑ์ผ่าน: ${lesson?.passingScore ?? 70}%   |   จำนวนผู้เรียน: ${rows.length}`, 14, y);
  y += 4;

  const body = rows.map((r, i) => [
    String(i + 1),
    S(r.studentId) || "-",
    S(r.name) || "-",
    S(r.phone) || "-",
    r.read ? "อ่านแล้ว" : "ยัง",
    r.attemptCount ? String(r.attemptCount) : "0",
    r.bestScore != null ? `${r.bestScore}%` : "-",
    r.passed ? "ผ่าน" : r.attemptCount ? "ไม่ผ่าน" : "-",
    fmtDate(r.lastAttemptAt),
  ]);

  drawTable(doc, {
    startY: y,
    marginLeft: 10,
    brandColor: cert.brandColor,
    columns: [
      { header: "ลำดับ", width: 10, align: "center" },
      { header: "รหัสนักเรียน", width: 24 },
      { header: "ชื่อ", width: 38 },
      { header: "เบอร์โทร", width: 26 },
      { header: "อ่านบท", width: 14, align: "center" },
      { header: "จำนวนครั้ง", width: 16, align: "center" },
      { header: "สูงสุด", width: 14, align: "center" },
      { header: "ผล", width: 16, align: "center" },
      { header: "ล่าสุด", width: 32 },
    ],
    rows: body,
  });

  pageFooter(doc, `รายงานรวมทั้งกลุ่ม ${cert.title}`);
  const fname = `${course}_cohort_${lesson?.id || "lesson"}.pdf`;
  doc.save(fname);
  return fname;
}

/** CSV version of the per-lesson cohort export. */
export function exportCohortCSV({
  rows,
  lesson,
  course,
}: {
  rows: CohortTableRow[];
  lesson: ExportLesson | null | undefined;
  course: CourseMode;
}) {
  const headers = [
    "Student ID",
    "Name",
    "Phone",
    "Lesson",
    "Read",
    "Attempts",
    "Best score (%)",
    "Passing score (%)",
    "Result",
    "Last attempt",
  ];
  const lines = [headers.join(",")];
  for (const r of rows) {
    lines.push(
      [
        esc(r.studentId),
        esc(r.name),
        esc(r.phone || ""),
        esc(lesson?.title || lesson?.id || ""),
        r.read ? "YES" : "NO",
        r.attemptCount ?? 0,
        r.bestScore ?? "",
        lesson?.passingScore ?? 70,
        r.passed ? "PASS" : r.attemptCount ? "FAIL" : "",
        esc(r.lastAttemptAt || ""),
      ].join(","),
    );
  }
  triggerCSVDownload(lines.join("\n"), `${course}_cohort_${lesson?.id || "lesson"}.csv`);
}

// ===== overall cohort summary export =====

export interface CohortOverallExportRow {
  id: string;
  studentId: string;
  name: string;
  phone: string | null;
  readCount: number;
  passedCount: number;
  total: number;
  preTestScore: number | null;
  preTestPassed: boolean;
  postTestScore: number | null;
  postTestPassed: boolean;
}

/**
 * Export the cohort OVERALL summary — one row per student covering every
 * lesson (read/passed counts) plus pre-test (ACLS only) and post-test
 * results. This is the single-file report an instructor submits to a
 * committee.
 */
export function exportCohortSummaryPDF({
  rows,
  className,
  classCode,
  course,
  isAcls = true,
}: {
  rows: CohortOverallExportRow[];
  className: string | null;
  classCode: string | null;
  course: CourseMode;
  isAcls?: boolean;
}) {
  const cert = getCertConfig(course);
  const doc = new jsPDF("p", "mm", "a4");
  doc.setFont(PDF_FONT, "normal");
  brandedHeader(doc, `รายงานสรุปผลผู้เรียน (${cert.subtitle})`, cert.brandColor);
  let y = 18;

  doc.setFontSize(10);
  doc.setFont(PDF_FONT, "bold");
  doc.text(S(`คลาส: ${className || "-"}${classCode ? ` (${classCode})` : ""}`), 14, y);
  y += 4;
  doc.setFontSize(8);
  doc.setFont(PDF_FONT, "normal");
  doc.text(`จำนวนผู้เรียน: ${rows.length}`, 14, y);
  y += 4;

  const fmtTest = (score: number | null, passed: boolean) =>
    score != null ? `${score}% ${passed ? "(ผ่าน)" : "(ไม่ผ่าน)"}` : "-";

  const columns: TableColumn[] = [
    { header: "ลำดับ", width: 10, align: "center" },
    { header: "รหัส", width: 22 },
    { header: "ชื่อ", width: 36 },
    { header: "เบอร์โทร", width: 24 },
    { header: "อ่านบท", width: 16, align: "center" },
    { header: "ผ่านบท", width: 16, align: "center" },
    ...(isAcls ? [{ header: "Pre-test", width: 30, align: "center" as const }] : []),
    { header: "Post-test", width: 30, align: "center" },
  ];

  const body = rows.map((r, i) => {
    const base = [
      String(i + 1),
      S(r.studentId) || "-",
      S(r.name) || "-",
      S(r.phone) || "-",
      `${r.readCount}/${r.total}`,
      `${r.passedCount}/${r.total}`,
    ];
    const post = fmtTest(r.postTestScore, r.postTestPassed);
    return isAcls ? [...base, fmtTest(r.preTestScore, r.preTestPassed), post] : [...base, post];
  });

  drawTable(doc, { startY: y, marginLeft: 10, brandColor: cert.brandColor, columns, rows: body });

  pageFooter(doc, `รายงานสรุปผลผู้เรียน ${cert.title}`);
  const fname = `${course}_summary_${classCode || "local"}.pdf`;
  doc.save(fname);
  return fname;
}

/** CSV version of the overall summary. */
export function exportCohortSummaryCSV({
  rows,
  course,
  isAcls = true,
}: {
  rows: CohortOverallExportRow[];
  course: CourseMode;
  isAcls?: boolean;
}) {
  const headers = [
    "No",
    "Student ID",
    "Name",
    "Phone",
    "Lessons read",
    "Lessons passed",
    ...(isAcls ? ["Pre-test (%)", "Pre-test result"] : []),
    "Post-test (%)",
    "Post-test result",
  ];
  const result = (score: number | null, passed: boolean) => (score == null ? "" : passed ? "PASS" : "FAIL");
  const lines = [headers.join(",")];
  rows.forEach((r, i) => {
    const cells = [
      i + 1,
      esc(r.studentId),
      esc(r.name),
      esc(r.phone || ""),
      `${r.readCount}/${r.total}`,
      `${r.passedCount}/${r.total}`,
      ...(isAcls ? [r.preTestScore ?? "", result(r.preTestScore, r.preTestPassed)] : []),
      r.postTestScore ?? "",
      result(r.postTestScore, r.postTestPassed),
    ];
    lines.push(cells.join(","));
  });
  triggerCSVDownload(lines.join("\n"), `${course}_summary.csv`);
}
