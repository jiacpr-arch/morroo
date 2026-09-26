import { describe, it, expect } from "vitest";
import { safeImageUrl, toLongCaseResult } from "@/lib/longcase-media";

describe("safeImageUrl", () => {
  it("accepts https and site-relative paths", () => {
    expect(safeImageUrl("https://x.supabase.co/storage/v1/object/public/a.webp")).toBe(
      "https://x.supabase.co/storage/v1/object/public/a.webp",
    );
    expect(safeImageUrl("/images/longcase/ecg.webp")).toBe("/images/longcase/ecg.webp");
  });

  it("rejects unsafe or malformed values", () => {
    expect(safeImageUrl("javascript:alert(1)")).toBeUndefined();
    expect(safeImageUrl("data:image/png;base64,AAAA")).toBeUndefined();
    expect(safeImageUrl("http://example.com/a.png")).toBeUndefined();
    expect(safeImageUrl("//evil.com/a.png")).toBeUndefined();
    expect(safeImageUrl("not a url")).toBeUndefined();
    expect(safeImageUrl("")).toBeUndefined();
    expect(safeImageUrl(42)).toBeUndefined();
  });
});

describe("toLongCaseResult", () => {
  it("keeps legacy text-only results", () => {
    expect(toLongCaseResult({ value: "WBC 12", isAbnormal: true })).toEqual({ value: "WBC 12", isAbnormal: true });
    expect(toLongCaseResult("Sinus rhythm")).toEqual({ value: "Sinus rhythm", isAbnormal: false });
  });

  it("carries a safe image and its credit", () => {
    expect(
      toLongCaseResult({ value: "ST elevation V1-V4", isAbnormal: true, image_url: "/images/longcase/ecg.webp", image_credit: "Case courtesy of X" }),
    ).toEqual({ value: "ST elevation V1-V4", isAbnormal: true, image_url: "/images/longcase/ecg.webp", image_credit: "Case courtesy of X" });
  });

  it("drops unsafe images but keeps the text", () => {
    expect(toLongCaseResult({ value: "Normal", isAbnormal: false, image_url: "javascript:x", image_credit: "c" })).toEqual({
      value: "Normal",
      isAbnormal: false,
    });
  });

  it("allows an image-only result and rejects empty entries", () => {
    expect(toLongCaseResult({ image_url: "/a.webp" })).toEqual({ value: "", isAbnormal: false, image_url: "/a.webp" });
    expect(toLongCaseResult({})).toBeUndefined();
    expect(toLongCaseResult(null)).toBeUndefined();
  });
});
