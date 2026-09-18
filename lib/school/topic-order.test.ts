import { describe, expect, it } from "vitest";
import { sortTopicsByCode } from "./topic-order";

describe("sortTopicsByCode", () => {
  it("เรียงรหัสวิชาจากน้อยไปมาก", () => {
    const topics = [
      { code: "FMMD 1108" },
      { code: "FMMD 1201" },
      { code: "FMMD 1101" },
      { code: "FMMD 1501" },
      { code: "FMMD 1111" },
    ];
    expect(sortTopicsByCode(topics).map((t) => t.code)).toEqual([
      "FMMD 1101",
      "FMMD 1108",
      "FMMD 1111",
      "FMMD 1201",
      "FMMD 1501",
    ]);
  });

  it("เทียบตัวเลขแบบ numeric ไม่ใช่ทีละอักษร", () => {
    const topics = [{ code: "FMMD 100" }, { code: "FMMD 99" }];
    expect(sortTopicsByCode(topics).map((t) => t.code)).toEqual([
      "FMMD 99",
      "FMMD 100",
    ]);
  });

  it("วิชาที่ยังไม่ผูกรหัสไปต่อท้าย โดยคงลำดับเดิม", () => {
    const topics = [
      { code: null, name: "ยังไม่มีรหัส A" },
      { code: "FMMD 1201", name: "ชีววิทยาของเซลล์" },
      { code: "  ", name: "ยังไม่มีรหัส B" },
      { code: "FMMD 1101", name: "คำศัพท์ทางการแพทย์" },
    ];
    expect(sortTopicsByCode(topics).map((t) => t.name)).toEqual([
      "คำศัพท์ทางการแพทย์",
      "ชีววิทยาของเซลล์",
      "ยังไม่มีรหัส A",
      "ยังไม่มีรหัส B",
    ]);
  });

  it("ไม่แก้ array เดิม", () => {
    const topics = [{ code: "FMMD 1201" }, { code: "FMMD 1101" }];
    sortTopicsByCode(topics);
    expect(topics.map((t) => t.code)).toEqual(["FMMD 1201", "FMMD 1101"]);
  });
});
