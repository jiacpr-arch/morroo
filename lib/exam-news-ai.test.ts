import { describe, expect, it } from "vitest";
import {
  isPublishableExamNews,
  looksExamRelated,
  parseExamNewsDraft,
  type ExamNewsDraft,
} from "./exam-news-ai";

const draft = (over: Partial<ExamNewsDraft> = {}): ExamNewsDraft => ({
  relevant: true,
  title: "ศรว. ประกาศ",
  summary: "สรุป",
  country: "th",
  exam_schedule: false,
  section: "nl",
  ...over,
});

describe("isPublishableExamNews", () => {
  it("publishes relevant Thai news", () => {
    expect(isPublishableExamNews(draft())).toBe(true);
  });
  it("hides foreign news, even when relevant", () => {
    expect(isPublishableExamNews(draft({ country: "foreign" }))).toBe(false);
  });
  it("hides irrelevant news", () => {
    expect(isPublishableExamNews(draft({ relevant: false }))).toBe(false);
  });
});

describe("parseExamNewsDraft — fail-closed", () => {
  it("reads a well-formed answer, even inside surrounding text", () => {
    const d = parseExamNewsDraft(
      'ได้เลย ```json\n{"relevant":true,"title":"หัวข้อ","summary":"สรุป","country":"th","exam_schedule":true,"section":"nl"}\n```'
    );
    expect(d).toEqual({
      relevant: true,
      title: "หัวข้อ",
      summary: "สรุป",
      country: "th",
      exam_schedule: true,
      section: "nl",
    });
  });

  it("treats a missing or non-true `relevant` as not relevant", () => {
    expect(parseExamNewsDraft('{"title":"x","summary":"y","country":"th"}')?.relevant).toBe(false);
    expect(parseExamNewsDraft('{"relevant":"true","country":"th"}')?.relevant).toBe(false);
    expect(parseExamNewsDraft('{"relevant":1,"country":"th"}')?.relevant).toBe(false);
  });

  it("treats anything but exactly 'th' as foreign", () => {
    expect(parseExamNewsDraft('{"relevant":true,"country":"TH"}')?.country).toBe("foreign");
    expect(parseExamNewsDraft('{"relevant":true}')?.country).toBe("foreign");
  });

  it("rejects unknown sections and caps lengths", () => {
    const d = parseExamNewsDraft(
      JSON.stringify({ relevant: true, country: "th", section: "admin", title: "ก".repeat(500), summary: "ข".repeat(2000) })
    );
    expect(d?.section).toBeNull();
    expect(d?.title).toHaveLength(160);
    expect(d?.summary).toHaveLength(600);
  });

  it("returns null for unreadable output", () => {
    expect(parseExamNewsDraft("ขออภัย ตอบไม่ได้")).toBeNull();
    expect(parseExamNewsDraft("{not json}")).toBeNull();
    expect(parseExamNewsDraft("")).toBeNull();
  });

  it("ignores non-boolean exam_schedule (no accidental admin alert)", () => {
    expect(parseExamNewsDraft('{"relevant":true,"country":"th","exam_schedule":"yes"}')?.exam_schedule).toBe(false);
  });
});

describe("looksExamRelated", () => {
  it.each([
    "ศรว. ประกาศกำหนดการสอบ",
    "แพทยสภาออกข้อบังคับใหม่",
    "เปิดรับสมัครสอบ NL ขั้นตอนที่ 2",
    "ตารางสอบ OSCE รอบ 1",
    "ราชวิทยาลัยประกาศสอบวุฒิบัตร",
    "จับสลากแพทย์เพิ่มพูนทักษะ",
    "ประกาศผลแพทย์ใช้ทุน",
  ])("accepts: %s", (t) => expect(looksExamRelated(t)).toBe(true));

  it.each([
    "ราคาน้ำมันวันนี้",
    "TCAS รอบ 3 เปิดรับสมัคร",
    "NLP model released",
    "ผลบอลเมื่อคืน",
  ])("rejects: %s", (t) => expect(looksExamRelated(t)).toBe(false));
});
