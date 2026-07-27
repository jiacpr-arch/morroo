import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { resolveTestEventCode } from "./events-api";

// เทสนี้คุมบั๊กที่เคยเกิดจริงและพังแบบเงียบสนิท: META_TEST_EVENT_CODE ถูกตั้ง
// บน Vercel แบบ All Environments (รวม Production) ค้างไว้สองเดือนกว่า
// Meta ตอบ 200 ทุกครั้ง ไม่มี error ให้เห็น แต่ conversion ไม่เข้า dataset เลย
// แคมเปญจึงยิงเงินไปโดยไม่มีอะไรให้อัลกอริทึมเรียนรู้

const ORIGINAL = { ...process.env };

beforeEach(() => {
  vi.spyOn(console, "warn").mockImplementation(() => {});
});

afterEach(() => {
  process.env = { ...ORIGINAL };
  vi.restoreAllMocks();
});

describe("resolveTestEventCode", () => {
  it("ไม่แนบ test code บน production แม้ env จะตั้งค้างไว้", () => {
    process.env.META_TEST_EVENT_CODE = "TEST31694";
    process.env.VERCEL_ENV = "production";
    expect(resolveTestEventCode("ViewContent")).toBeUndefined();
  });

  it("เตือนไว้ใน log ว่ามีค่าค้างที่ต้องไปลบ ไม่ใช่เพิกเฉยเงียบๆ", () => {
    process.env.META_TEST_EVENT_CODE = "TEST31694";
    process.env.VERCEL_ENV = "production";
    resolveTestEventCode("ViewContent");
    expect(console.warn).toHaveBeenCalledOnce();
    expect(vi.mocked(console.warn).mock.calls[0][0]).toContain("META_TEST_EVENT_CODE");
  });

  it("ยังใช้ได้บน preview — จุดประสงค์เดิมของตัวแปรนี้คือเทสก่อนขึ้นจริง", () => {
    process.env.META_TEST_EVENT_CODE = "TEST31694";
    process.env.VERCEL_ENV = "preview";
    expect(resolveTestEventCode("ViewContent")).toBe("TEST31694");
  });

  it("ยังใช้ได้ตอนรันในเครื่อง (ไม่มี VERCEL_ENV)", () => {
    process.env.META_TEST_EVENT_CODE = "TEST31694";
    delete process.env.VERCEL_ENV;
    expect(resolveTestEventCode("ViewContent")).toBe("TEST31694");
  });

  it("ไม่ตั้งค่าไว้ = ไม่แนบ ไม่ว่าจะ environment ไหน", () => {
    delete process.env.META_TEST_EVENT_CODE;
    for (const env of ["production", "preview", "development"]) {
      process.env.VERCEL_ENV = env;
      expect(resolveTestEventCode("PageView")).toBeUndefined();
    }
  });

  it("ค่าว่าง/ช่องว่างล้วน ไม่นับว่าตั้งไว้", () => {
    process.env.META_TEST_EVENT_CODE = "   ";
    process.env.VERCEL_ENV = "preview";
    expect(resolveTestEventCode("PageView")).toBeUndefined();
  });
});
