import { describe, expect, it } from "vitest";
import {
  DIRECT_UPLOAD_MAX,
  extensionForType,
  mediaTypeForPath,
  planUpload,
  TOTAL_MAX,
  type UploadCandidate,
} from "./import-files";

const MB = 1024 * 1024;

function pdf(name: string, sizeMb: number): UploadCandidate {
  return { name, size: Math.round(sizeMb * MB), type: "application/pdf" };
}
function png(name: string, sizeMb: number): UploadCandidate {
  return { name, size: Math.round(sizeMb * MB), type: "image/png" };
}

describe("planUpload", () => {
  it("ไม่เลือกไฟล์เลยถือว่าไม่ผ่าน", () => {
    expect(planUpload([])).toEqual({ ok: false, error: "เลือกไฟล์ก่อน" });
  });

  it("ไฟล์รวมเล็กส่งตรงไปกับ request", () => {
    const plan = planUpload([pdf("a.pdf", 1), pdf("b.pdf", 1.5)]);
    expect(plan).toMatchObject({ ok: true, mode: "inline" });
  });

  it("รวมเกิน 4 MB ต้องผ่าน storage ทั้งชุด", () => {
    const plan = planUpload([pdf("a.pdf", 3), pdf("b.pdf", 3)]);
    expect(plan).toMatchObject({ ok: true, mode: "storage", totalBytes: 6 * MB });
  });

  it("ตัดสินจากขนาดรวม ไม่ใช่ไฟล์ที่ใหญ่ที่สุด", () => {
    // ไฟล์ละ 2.5 MB ไม่มีไฟล์ไหนเกิน 4 MB แต่รวมแล้วเกิน
    const plan = planUpload([pdf("a.pdf", 2.5), pdf("b.pdf", 2.5)]);
    expect(plan).toMatchObject({ ok: true, mode: "storage" });
  });

  it("พอดี 4 MB ยังส่งตรงได้", () => {
    const plan = planUpload([{ name: "a.pdf", size: DIRECT_UPLOAD_MAX, type: "application/pdf" }]);
    expect(plan).toMatchObject({ ok: true, mode: "inline" });
  });

  it("รวมเกิน 32 MB ไม่ผ่าน และบอกขนาดรวม", () => {
    const plan = planUpload([pdf("a.pdf", 20), pdf("b.pdf", 20)]);
    expect(plan.ok).toBe(false);
    if (!plan.ok) expect(plan.error).toContain("40.0 MB");
  });

  it("พอดี 32 MB ยังผ่าน", () => {
    const plan = planUpload([{ name: "a.pdf", size: TOTAL_MAX, type: "application/pdf" }]);
    expect(plan).toMatchObject({ ok: true, mode: "storage" });
  });

  it("รูปภาพเกิน 4 MB ไม่ผ่านแม้ขนาดรวมจะยังไม่ตัน", () => {
    const plan = planUpload([png("big.png", 5)]);
    expect(plan.ok).toBe(false);
    if (!plan.ok) expect(plan.error).toContain("big.png");
  });

  it("PDF ไฟล์เดียวเกิน 4 MB ยังผ่าน (ไปทาง storage)", () => {
    expect(planUpload([pdf("a.pdf", 10)])).toMatchObject({ ok: true, mode: "storage" });
  });

  it("ชนิดไฟล์ที่ไม่รับ ถูกรวบบอกในข้อความเดียว", () => {
    const plan = planUpload([
      pdf("ok.pdf", 1),
      { name: "notes.docx", size: MB, type: "application/vnd.openxmlformats" },
      { name: "sheet.csv", size: MB, type: "text/csv" },
    ]);
    expect(plan.ok).toBe(false);
    if (!plan.ok) {
      expect(plan.error).toContain("notes.docx");
      expect(plan.error).toContain("sheet.csv");
    }
  });

  it("ไฟล์ว่างไม่ผ่าน", () => {
    const plan = planUpload([{ name: "empty.pdf", size: 0, type: "application/pdf" }]);
    expect(plan.ok).toBe(false);
    if (!plan.ok) expect(plan.error).toContain("empty.pdf");
  });
});

describe("extensionForType / mediaTypeForPath", () => {
  it("แปลงไป-กลับได้ครบทุกชนิดที่รับ", () => {
    for (const type of ["application/pdf", "image/png", "image/jpeg", "image/webp"]) {
      const ext = extensionForType(type);
      expect(ext).not.toBeNull();
      expect(mediaTypeForPath(`user-id/abc.${ext}`)).toBe(type);
    }
  });

  it("ชนิดที่ไม่รับคืน null", () => {
    expect(extensionForType("text/csv")).toBeNull();
  });

  it("อ่านนามสกุลแบบไม่สนตัวพิมพ์ และรับ .jpeg ด้วย", () => {
    expect(mediaTypeForPath("x/y.JPG")).toBe("image/jpeg");
    expect(mediaTypeForPath("x/y.jpeg")).toBe("image/jpeg");
  });

  it("path ที่ไม่มีนามสกุลรู้จักคืน null", () => {
    expect(mediaTypeForPath("x/y.bin")).toBeNull();
    expect(mediaTypeForPath("noextension")).toBeNull();
  });
});
