import { describe, expect, it } from "vitest";
import { appendDictation, localThaiVoices, recognitionError, speechChunks } from "./device-speech";

describe("Long Case device speech", () => {
  it("appends dictation without losing typed text or adding empty results", () => {
    expect(appendDictation("เจ็บหน้าอก", " มาสองวัน ")).toBe("เจ็บหน้าอก มาสองวัน");
    expect(appendDictation("1. โรคหัวใจ\n", "2. โรคปอด")).toBe("1. โรคหัวใจ\n2. โรคปอด");
    expect(appendDictation("", "สวัสดี")).toBe("สวัสดี");
    expect(appendDictation("ยังอยู่", "  ")).toBe("ยังอยู่");
  });
  it("never picks remote or non-Thai voices", () => {
    const voices = [
      { voiceURI: "remote-th", lang: "th-TH", localService: false },
      { voiceURI: "local-en", lang: "en-US", localService: true },
      { voiceURI: "local-th", lang: "th-TH", localService: true },
      { voiceURI: "local-th2", lang: "th_TH", localService: true },
    ] as SpeechSynthesisVoice[];
    expect(localThaiVoices(voices).map(v => v.voiceURI)).toEqual(["local-th", "local-th2"]);
    expect(localThaiVoices(voices.slice(0, 2))).toEqual([]);
  });
  it("cleans Markdown and splits long speech without dropping content", () => {
    expect(speechChunks("**สวัสดี** [คุณหมอ](https://example.com)\n```code```"))
      .toEqual(["สวัสดี คุณหมอ"]);
    const text = "ก".repeat(550) + "😀";
    const chunks = speechChunks(text);
    expect(chunks.join("")).toBe(text);
    expect(chunks.every(chunk => Array.from(chunk).length <= 180)).toBe(true);
    expect(speechChunks("  ")).toEqual([]);
  });
  it("provides recoverable permission/language/network errors", () => {
    expect(recognitionError("not-allowed")).toContain("สิทธิ์ไมโครโฟน");
    expect(recognitionError("language-not-supported")).toContain("ถอดเสียงไทย");
    expect(recognitionError("network")).toContain("พิมพ์ตอบได้");
    expect(recognitionError("unknown")).toContain("ข้อความเดิมยังอยู่");
  });
});
