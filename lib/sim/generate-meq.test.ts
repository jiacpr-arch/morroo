import { describe, expect, it } from "vitest";
import { applyMeqConventions, meqSystemPrompt } from "./generate-meq";

const exam = { title: "t", category: "อายุรศาสตร์", difficulty: "medium", parts: [] };

describe("meqSystemPrompt", () => {
  it("requires the order shelf and forbids revealing the diagnosis", () => {
    const p = meqSystemPrompt([], exam);
    expect(p).toContain('"shelf": true');
    expect(p).toContain("orderSheet");
    expect(p).toContain("ห้ามมีใครเฉลย");
    expect(p).toContain('ห้าม say ที่ขึ้นต้นด้วย "ถูกต้อง"');
    // ตัวอย่าง torsion เป็นรุ่นเก่า — ต้องบอก AI ว่ากติกาชนะตัวอย่าง
    expect(p).toContain("ตัวอย่างนี้เป็นรูปแบบรุ่นเก่า");
  });
});

describe("applyMeqConventions", () => {
  it("turns any choice whose right answer yields an order sheet into an order shelf, including nested ones", () => {
    const orderChoice = (q: string) => ({
      choice: {
        q,
        options: [
          { tgt: "MGMT", label: "A", ok: true, then: [{ orderSheet: { orders: [{ text: "A", isNew: true }] } }] },
          { tgt: "MGMT", label: "B", ok: false },
        ],
      },
    });
    const nested = orderChoice("nested");
    const story = [
      { choice: { q: "dx", options: [{ tgt: "DX", label: "x", ok: true, then: [nested] }, { tgt: "DX", label: "y", ok: false }] } },
      orderChoice("top"),
      { say: { who: "att_dech", pose: "talk", text: "hi" } },
    ];
    applyMeqConventions(story);
    expect((story[0] as { choice: { shelf?: boolean } }).choice.shelf).toBeUndefined();
    expect((story[1] as { choice: { shelf?: boolean } }).choice.shelf).toBe(true);
    expect(nested.choice).toMatchObject({ shelf: true });
  });

  it("ignores malformed input", () => {
    expect(() => applyMeqConventions(null)).not.toThrow();
    expect(() => applyMeqConventions([null, { choice: { options: "x" } }])).not.toThrow();
  });
});
