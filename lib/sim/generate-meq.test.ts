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
    expect(p).toContain("อ่านน้อยแต่บ่อย");
    expect(p).toContain("ห้ามมี say ติดกันเกิน 2 node");
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

  it("strips a leading 'ถูกต้อง —' from say text but keeps the explanation and balanced emphasis", () => {
    const say = (text: string) => ({ say: { who: "att_dech", pose: "talk", text } });
    const nested = say("ถูกต้อง — **BNP** สูงจาก wall stress");
    const story = [
      say("ถูกต้อง — AG 27 สูงมาก"),
      say("**ถูกต้อง!** ต้องให้ insulin"),
      say("**ถูกต้อง — ห้ามใช้ ATD** ตลอดชีวิต"),
      say("ถูกต้อง"),
      say("ผลนี้ถูกต้องตามเกณฑ์"),
      { choice: { q: "q", options: [{ tgt: "LAB", label: "a", ok: true, then: [nested] }, { tgt: "LAB", label: "b", ok: false }] } },
    ];
    applyMeqConventions(story);
    const texts = story.slice(0, 5).map((n) => (n as { say: { text: string } }).say.text);
    expect(texts[0]).toBe("AG 27 สูงมาก");
    expect(texts[1]).toBe("ต้องให้ insulin");
    // ** ตัวเปิดของคำเน้นที่ปิดทีหลังต้องไม่หาย
    expect(texts[2]).toBe("**ห้ามใช้ ATD** ตลอดชีวิต");
    expect(texts[3]).toBe("ถูกต้อง"); // ไม่เหลืออะไร → คงเดิม
    expect(texts[4]).toBe("ผลนี้ถูกต้องตามเกณฑ์"); // ไม่ได้ขึ้นต้น → ไม่แตะ
    expect(nested.say.text).toBe("**BNP** สูงจาก wall stress");
  });

  it("moves the attending's explanation after a correct diagnosis into the debrief", () => {
    const explain = { say: { who: "att_dech", pose: "talk", text: "นับ major criteria ได้ 4 ข้อ" } };
    const next = { choice: { q: "ผลตรวจใดสนับสนุน", options: [{ tgt: "DX", label: "x", ok: true }, { tgt: "DX", label: "y", ok: false }] } };
    const story: unknown[] = [
      { choice: { q: "วินิจฉัย", options: [{ tgt: "DX", label: "RF", ok: true, then: [explain, next] }, { tgt: "DX", label: "JIA", ok: false }] } },
      { say: { who: "att_dech", pose: "happy", text: "สรุป" } },
      { inter: "เคสสำเร็จ!!", green: true },
      { end: true },
    ];
    applyMeqConventions(story);
    const dx = (story[0] as { choice: { options: { then?: unknown[] }[] } }).choice.options[0];
    expect(dx.then).toEqual([next]);
    expect(story[2]).toEqual(explain);
    expect(story[3]).toMatchObject({ inter: "เคสสำเร็จ!!" });
  });

  it("ignores malformed input", () => {
    expect(() => applyMeqConventions(null)).not.toThrow();
    expect(() => applyMeqConventions([null, { choice: { options: "x" } }])).not.toThrow();
  });
});
