import { describe, it, expect } from "vitest";
import { normalizeAnswer } from "./format-answer";

describe("normalizeAnswer", () => {
  it("returns empty string for blank input", () => {
    expect(normalizeAnswer("")).toBe("");
    expect(normalizeAnswer(null)).toBe("");
    expect(normalizeAnswer("   \n  ")).toBe("");
  });

  it("promotes a label-only line to an h2 heading", () => {
    expect(normalizeAnswer("ประโยชน์ที่พบ:")).toBe("## ประโยชน์ที่พบ");
  });

  it("bolds an inline 'Label: content' definition", () => {
    expect(normalizeAnswer("ใจความหลัก: ควรนำ RCDP มาใช้")).toBe(
      "**ใจความหลัก:** ควรนำ RCDP มาใช้"
    );
  });

  it("separates run-on single-newline lines into paragraphs", () => {
    const raw = "บรรทัดแรก\nบรรทัดสอง\nบรรทัดสาม";
    expect(normalizeAnswer(raw)).toBe(
      "บรรทัดแรก\n\nบรรทัดสอง\n\nบรรทัดสาม"
    );
  });

  it("groups numbered points into a single ordered list", () => {
    const raw = "1. หนึ่ง\n2. สอง\n3. สาม";
    expect(normalizeAnswer(raw)).toBe("1. หนึ่ง\n2. สอง\n3. สาม");
  });

  it("renumbers ordered lists that drift", () => {
    const raw = "1. หนึ่ง\n1. สอง\n5. สาม";
    expect(normalizeAnswer(raw)).toBe("1. หนึ่ง\n2. สอง\n3. สาม");
  });

  it("groups bullet points into a single unordered list", () => {
    const raw = "- หนึ่ง\n* สอง\n• สาม";
    expect(normalizeAnswer(raw)).toBe("- หนึ่ง\n- สอง\n- สาม");
  });

  it("leaves already-structured Markdown (headings) untouched", () => {
    const raw = "### หัวข้อ\nให้ **Epinephrine 1 mg** ทันที";
    expect(normalizeAnswer(raw)).toBe(raw);
  });

  it("leaves Markdown tables intact (no paragraph splitting)", () => {
    const raw = "| ยา | ขนาด |\n| --- | --- |\n| Epi | 1 mg |";
    expect(normalizeAnswer(raw)).toBe(raw);
  });

  it("does not treat a URL as a label", () => {
    const raw = "https://example.com/path";
    expect(normalizeAnswer(raw)).toBe("https://example.com/path");
  });

  it("does not double-bold an already-bold label (idempotent shape)", () => {
    const raw = "**ใจความหลัก:** ควรนำ RCDP มาใช้";
    expect(normalizeAnswer(raw)).toBe(raw);
  });

  it("is idempotent on realistic mixed content", () => {
    const raw = [
      "RCDP คืออะไร: เป็นวิธีการฝึกโดยใช้การจำลองสถานการณ์",
      "ประโยชน์ที่พบ:",
      "1. ทักษะการทำ CPR ดีขึ้น",
      "2. ภาระงานจัดการได้ดีขึ้น",
    ].join("\n");
    const once = normalizeAnswer(raw);
    expect(normalizeAnswer(once)).toBe(once);
    expect(once).toContain("## ประโยชน์ที่พบ");
    expect(once).toContain("**RCDP คืออะไร:**");
    expect(once).toContain("1. ทักษะการทำ CPR ดีขึ้น");
    expect(once).toContain("2. ภาระงานจัดการได้ดีขึ้น");
  });

  it("collapses excessive blank runs", () => {
    expect(normalizeAnswer("ก\n\n\n\nข")).toBe("ก\n\nข");
  });
});
