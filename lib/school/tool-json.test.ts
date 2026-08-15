import { describe, expect, it } from "vitest";
import {
  TRUNCATION_NOTE,
  estimateMinutes,
  keepComplete,
  recoverStringField,
  tidyTruncatedBody,
} from "./tool-json";

describe("recoverStringField", () => {
  it("reads a completed field", () => {
    const raw = '{"title":"Calculus","body_md":"## บทนำ","layer":"foundation"}';
    expect(recoverStringField(raw, "title")).toBe("Calculus");
    expect(recoverStringField(raw, "body_md")).toBe("## บทนำ");
  });

  it("reads a field whose closing quote never arrived", () => {
    const raw = '{"title":"Calculus","body_md":"## บทนำ\\nเนื้อหาที่กำลังเขียนอยู่';
    expect(recoverStringField(raw, "body_md")).toBe("## บทนำ\nเนื้อหาที่กำลังเขียนอยู่");
  });

  it("keeps escapes that did make it through", () => {
    const raw = '{"body_md":"บรรทัด 1\\nบรรทัด \\"สอง\\"\\tจบ';
    expect(recoverStringField(raw, "body_md")).toBe('บรรทัด 1\nบรรทัด "สอง"\tจบ');
  });

  it("drops a cut that landed inside an escape sequence", () => {
    expect(recoverStringField('{"body_md":"ok\\', "body_md")).toBe("ok");
    expect(recoverStringField('{"body_md":"ok\\u00', "body_md")).toBe("ok");
    // An escaped backslash is complete and must survive.
    expect(recoverStringField('{"body_md":"ok\\\\', "body_md")).toBe("ok\\");
  });

  it("returns null when the field is not in the buffer", () => {
    expect(recoverStringField('{"title":"Calculus"', "body_md")).toBeNull();
    expect(recoverStringField("", "body_md")).toBeNull();
  });

  it("does not confuse a later field with an earlier one", () => {
    const raw = '{"title":"A","body_md":"B","layer":"path"}';
    expect(recoverStringField(raw, "layer")).toBe("path");
  });
});

describe("tidyTruncatedBody", () => {
  it("closes off a half-written fenced quiz block", () => {
    const md = '## ส่วนที่ 1\n\nเนื้อหา\n\n## ⏸ Mini Quiz\n\n```quiz\n{ "stem": "อะไร';
    const out = tidyTruncatedBody(md);
    expect(out).not.toContain("```");
    expect(out).toContain("## ส่วนที่ 1");
    expect(out.endsWith(TRUNCATION_NOTE)).toBe(true);
  });

  it("drops the dangling last paragraph", () => {
    const md = `${"เนื้อหาย่อหน้าแรกที่ยาวพอสมควร".repeat(6)}\n\nย่อหน้าท้ายที่ขาดกลางคำ`;
    const out = tidyTruncatedBody(md);
    expect(out).not.toContain("ย่อหน้าท้ายที่ขาดกลางคำ");
  });

  it("keeps the text when there is no good boundary to cut back to", () => {
    const md = "สั้นมาก\n\nแต่ที่เหลือยาวกว่าครึ่งของทั้งหมดอยู่ตรงนี้ ยาวมากจริง ๆ นะ";
    expect(tidyTruncatedBody(md)).toContain("แต่ที่เหลือยาวกว่าครึ่ง");
  });
});

describe("estimateMinutes", () => {
  it("scales with length and stays in range", () => {
    expect(estimateMinutes("")).toBe(5);
    expect(estimateMinutes("x".repeat(5000))).toBe(10);
    expect(estimateMinutes("x".repeat(500_000))).toBe(120);
  });
});

describe("keepComplete", () => {
  it("drops half-built objects", () => {
    const items = [
      { front: "a", back: "b", difficulty: "easy" },
      { front: "c" },
      { front: "d", back: "  ", difficulty: "easy" },
      null,
    ];
    expect(keepComplete(items, ["front", "back", "difficulty"])).toEqual([
      { front: "a", back: "b", difficulty: "easy" },
    ]);
  });

  it("requires non-empty arrays for array fields", () => {
    const items = [
      { stem: "s", choices: [{ label: "A", text: "t" }] },
      { stem: "s2", choices: [] },
    ];
    expect(keepComplete(items, ["stem", "choices"])).toHaveLength(1);
  });

  it("tolerates a missing or non-array payload", () => {
    expect(keepComplete(undefined, ["front"])).toEqual([]);
    expect(keepComplete({}, ["front"])).toEqual([]);
  });
});
