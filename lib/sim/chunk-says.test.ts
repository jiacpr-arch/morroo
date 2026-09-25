import { describe, expect, it } from "vitest";
import { SAY_MAX_CHARS, chunkLongSays, chunkText } from "./chunk-says";
import type { StoryNode } from "./types";

const long =
  "ผู้ป่วยมีไข้สูง 3 วัน หนาวสั่น ปวดหลังด้านขวา ปัสสาวะแสบขัด กินยาลดไข้แล้วไม่ดีขึ้น " +
  "วันนี้เริ่มคลื่นไส้อาเจียน กินอาหารไม่ได้ ญาติจึงพามาโรงพยาบาล " +
  "มีโรคประจำตัวเป็นเบาหวานมา 10 ปี กิน metformin อยู่ ไม่เคยแพ้ยา";

describe("chunkText", () => {
  it("leaves short text alone", () => {
    expect(chunkText("สั้นๆ")).toEqual(["สั้นๆ"]);
  });

  it("splits long text into short chunks at spaces without losing words", () => {
    const parts = chunkText(long);
    expect(parts.length).toBeGreaterThan(1);
    for (const p of parts) expect(p.length).toBeLessThanOrEqual(SAY_MAX_CHARS);
    expect(parts.join(" ")).toBe(long);
  });

  it("keeps **emphasis** balanced across a cut", () => {
    const text = `${"ก".repeat(20)} **${Array.from({ length: 30 }, () => "เน้น").join(" ")}** จบ`;
    const parts = chunkText(text, 60);
    expect(parts.length).toBeGreaterThan(1);
    for (const p of parts) expect((p.split("**").length - 1) % 2).toBe(0);
  });
});

describe("chunkLongSays", () => {
  it("turns one long say into several consecutive says, including inside choice then", () => {
    const story: StoryNode[] = [
      { say: { who: "att_dech", pose: "talk", text: long }, t: 9 },
      {
        choice: {
          q: "q",
          options: [
            { tgt: "ASK", label: "a", ok: true, then: [{ say: { who: "patient_generic", pose: "talk", text: long } }] },
            { tgt: "ASK", label: "b", ok: false },
          ],
        },
      },
      { end: true },
    ];
    const out = chunkLongSays(story);
    const top = out.filter((n) => "say" in n);
    expect(top.length).toBeGreaterThan(1);
    expect(top.every((n) => "say" in n && n.say.who === "att_dech")).toBe(true);
    const choice = out.find((n) => "choice" in n);
    const then = choice && "choice" in choice ? choice.choice.options[0].then! : [];
    expect(then.length).toBeGreaterThan(1);
    // ไม่แตะ story เดิม
    expect(story[0]).toMatchObject({ say: { text: long } });
  });
});
