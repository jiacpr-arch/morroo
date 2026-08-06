import { describe, expect, it } from "vitest";
import { describeScenarioError } from "./validate";
import type { SimScenario } from "./types";

function scenarioWithOptions(options: { label: string; ok?: boolean }[]): SimScenario {
  return {
    slug: "test-choice-01",
    title: "เคสทดสอบ",
    subtitle: "",
    story: [
      {
        choice: {
          q: "คำถามทดสอบ",
          options: options.map((o) => ({ tgt: "ASK", label: o.label, ok: o.ok ?? false })),
        },
      },
      { end: true },
    ],
  } as SimScenario;
}

describe("choice anti-guessing guards", () => {
  it("ผ่านเมื่อ label ยาวใกล้เคียงกัน", () => {
    const s = scenarioWithOptions([
      { label: "คลำ carotid pulse ไม่เกิน 10 วินาที", ok: true },
      { label: "ฟังเสียงปอดละเอียดๆ สัก 1 นาที" },
      { label: "ติด 12-lead ECG ให้ครบก่อนทำอย่างอื่น" },
    ]);
    expect(describeScenarioError(s)).toBeNull();
  });

  it("ไม่ผ่านเมื่อข้อถูกยาวเกิน 1.5 เท่าของตัวลวงที่ยาวสุด", () => {
    const s = scenarioWithOptions([
      {
        label: "ส่งตรวจ UA และ CBC พร้อมสั่ง Scrotal Doppler ultrasound ควบคู่กับปรึกษาศัลยแพทย์ทันทีไม่รอผล",
        ok: true,
      },
      { label: "รอดูอาการก่อน" },
      { label: "ให้ยาแก้ปวดกลับบ้าน" },
    ]);
    expect(describeScenarioError(s)).toContain("เดาข้อถูกจากความยาว");
  });

  it("floor 25: ตัวลวงสั้นมากไม่ flag ถ้าข้อถูกไม่ยาวจริง", () => {
    const s = scenarioWithOptions([
      { label: "ตรวจ Cremasteric reflex สองข้าง", ok: true }, // ~30 ตัวอักษร
      { label: "ทำ Prehn's sign" },
      { label: "คลำต่อมน้ำเหลือง" },
    ]);
    expect(describeScenarioError(s)).toBeNull();
  });

  it("ไม่ผ่านเมื่อ label ซ้ำกันใน choice เดียว", () => {
    const s = scenarioWithOptions([
      { label: "ให้ออกซิเจน", ok: true },
      { label: "ให้ออกซิเจน" },
      { label: "เปิดเส้นน้ำเกลือ" },
    ]);
    expect(describeScenarioError(s)).toContain("label ซ้ำ");
  });
});
