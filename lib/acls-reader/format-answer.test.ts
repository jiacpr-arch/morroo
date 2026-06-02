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

  it("promotes a standalone numbered item with sub-content to a numbered heading", () => {
    const raw = "1. กลไกการทำงาน\nรายละเอียดของกลไก";
    expect(normalizeAnswer(raw)).toBe("## 1. กลไกการทำงาน\n\nรายละเอียดของกลไก");
  });

  it("keeps section numbers (no '1. … 1.') across an outline with sub-content", () => {
    const raw = [
      "1. กลไกการทำงาน",
      "รายละเอียดของกลไก",
      "2. เหตุผลเชิงจิตวิทยา",
      "คำอธิบายเหตุผล",
      "3. หลักฐานสนับสนุน",
      "ผลการศึกษา",
    ].join("\n");
    const out = normalizeAnswer(raw);
    expect(out).toContain("## 1. กลไกการทำงาน");
    expect(out).toContain("## 2. เหตุผลเชิงจิตวิทยา");
    expect(out).toContain("## 3. หลักฐานสนับสนุน");
    expect(out).not.toContain("## 1. เหตุผล");
  });

  it("still treats a tight numbered run as a single renumbered list", () => {
    const raw = "ประโยชน์ที่พบ:\n1. ทักษะดีขึ้น\n2. ภาระงานดีขึ้น\nสรุปต่อไป";
    const out = normalizeAnswer(raw);
    expect(out).toContain("## ประโยชน์ที่พบ");
    expect(out).toContain("1. ทักษะดีขึ้น\n2. ภาระงานดีขึ้น");
    expect(out).not.toContain("## 1.");
  });

  it("turns a 'เช่น:' lead-in plus short lines into a bullet list", () => {
    const raw = [
      "ทักษะที่เหมาะกับ RCDP เช่น:",
      "การกดหน้าอกคุณภาพสูง",
      "การใช้เครื่อง AED / Manual Defibrillator",
      "การจัดการทางเดินหายใจ",
    ].join("\n");
    const out = normalizeAnswer(raw);
    expect(out).toContain("- การกดหน้าอกคุณภาพสูง");
    expect(out).toContain("- การใช้เครื่อง AED / Manual Defibrillator");
    expect(out).toContain("- การจัดการทางเดินหายใจ");
  });

  it("ends a cued list before a wrap-up heading that owns a long paragraph", () => {
    const raw = [
      "ตัวอย่างได้แก่:",
      "ข้อหนึ่ง",
      "ข้อสอง",
      "สรุปเชิงลึก",
      "นี่คือย่อหน้าสรุปที่ยาวมากเกินเกณฑ์ความยาวของบรรทัดปกติเพื่อให้ถือเป็นเนื้อหาพารากราฟจริงๆ ไม่ใช่ไอเทมของลิสต์",
    ].join("\n");
    const out = normalizeAnswer(raw);
    expect(out).toContain("- ข้อหนึ่ง");
    expect(out).toContain("- ข้อสอง");
    expect(out).not.toContain("- สรุปเชิงลึก");
  });

  it("does not bullet label lines after a 'ต่อไปนี้:' cue", () => {
    const raw = [
      "พบผลลัพธ์เชิงบวกในด้านต่อไปนี้:",
      "คุณภาพการกดหน้าอก (CPR Quality): อัตราที่ถูกต้อง",
      "เวลาในการช็อก (Time to Defibrillation): เร็วขึ้น",
    ].join("\n");
    const out = normalizeAnswer(raw);
    expect(out).toContain("**คุณภาพการกดหน้าอก (CPR Quality):** อัตราที่ถูกต้อง");
    expect(out).not.toContain("- คุณภาพการกดหน้าอก");
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
