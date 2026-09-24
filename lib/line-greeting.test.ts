import { describe, it, expect } from "vitest";
import {
  buildFollowGreeting,
  buildNonTextGreeting,
  describeNonTextMessage,
  isNonTextMessage,
} from "./line-greeting";

describe("isNonTextMessage", () => {
  it("treats every LINE message type except text as non-text", () => {
    expect(isNonTextMessage("sticker")).toBe(true);
    expect(isNonTextMessage("image")).toBe(true);
    expect(isNonTextMessage("audio")).toBe(true);
    expect(isNonTextMessage("text")).toBe(false);
    expect(isNonTextMessage(undefined)).toBe(false);
  });
});

describe("describeNonTextMessage", () => {
  it("returns a Thai placeholder for known types and a generic one otherwise", () => {
    expect(describeNonTextMessage("sticker")).toBe("[สติกเกอร์]");
    expect(describeNonTextMessage("image")).toBe("[รูปภาพ]");
    expect(describeNonTextMessage("imagemap")).toBe("[ข้อความที่ไม่ใช่ตัวอักษร]");
    expect(describeNonTextMessage(undefined)).toBe("[ข้อความที่ไม่ใช่ตัวอักษร]");
  });
});

describe("sales greetings", () => {
  it("open with the free-trial hook and a qualifying question", () => {
    for (const text of [buildFollowGreeting(), buildNonTextGreeting()]) {
      expect(text).toContain("ฟรี 7 วัน");
      expect(text).toContain("เตรียมสอบอะไร");
      expect(text.length).toBeLessThan(400);
    }
  });

  it("tells sticker senders how to ask for the trial code", () => {
    expect(buildNonTextGreeting()).toContain("ขอโค้ดทดลอง");
  });
});
