import { describe, it, expect } from "vitest";
import {
  FREE_SAMPLE_LESSONS,
  isFreeSampleLesson,
  schoolTopicScopes,
} from "./topic-access";
import { hasScopedAccess } from "@/lib/membership";

const future = new Date(Date.now() + 86400_000 * 30).toISOString();
const past = new Date(Date.now() - 86400_000).toISOString();

describe("isFreeSampleLesson", () => {
  const ids = ["a", "b", "c"];

  it("เปิดบทแรกของวิชาให้อ่านฟรี", () => {
    expect(FREE_SAMPLE_LESSONS).toBe(1);
    expect(isFreeSampleLesson("a", ids)).toBe(true);
  });

  it("บทถัดไปไม่ใช่ตัวอย่างฟรี", () => {
    expect(isFreeSampleLesson("b", ids)).toBe(false);
    expect(isFreeSampleLesson("c", ids)).toBe(false);
  });

  it("บทที่ไม่อยู่ในวิชานี้ ไม่นับเป็นตัวอย่าง", () => {
    expect(isFreeSampleLesson("x", ids)).toBe(false);
    expect(isFreeSampleLesson("a", [])).toBe(false);
  });
});

describe("schoolTopicScopes + hasScopedAccess", () => {
  const topic = { id: "t1", year: 2 };
  const scopes = schoolTopicScopes(topic);
  const free = { membership_type: "free", membership_expires_at: null };

  it("ใช้ scope วิชาและชั้นปี", () => {
    expect(scopes).toEqual(["topic:t1", "year:2"]);
  });

  it("ซื้อวิชานี้ → เปิดได้", () => {
    const ent = [{ product: "school", scope: "topic:t1", expires_at: null }];
    expect(hasScopedAccess("school", scopes, free, ent)).toBe(true);
  });

  it("ซื้อทั้งชั้นปี → เปิดได้", () => {
    const ent = [{ product: "school", scope: "year:2", expires_at: null }];
    expect(hasScopedAccess("school", scopes, free, ent)).toBe(true);
  });

  it("ซื้อวิชาอื่น / ปีอื่น → ยังล็อก", () => {
    const ent = [
      { product: "school", scope: "topic:t9", expires_at: null },
      { product: "school", scope: "year:3", expires_at: null },
    ];
    expect(hasScopedAccess("school", scopes, free, ent)).toBe(false);
  });

  it("สิทธิ์ School ทั้งระบบ → เปิดได้ทุกวิชา", () => {
    const ent = [{ product: "school", scope: "*", expires_at: future }];
    expect(hasScopedAccess("school", scopes, free, ent)).toBe(true);
  });

  it("สิทธิ์หมดอายุ → ล็อก", () => {
    const ent = [{ product: "school", scope: "*", expires_at: past }];
    expect(hasScopedAccess("school", scopes, free, ent)).toBe(false);
  });

  it("ไม่มีสิทธิ์อะไรเลย → ล็อก", () => {
    expect(hasScopedAccess("school", scopes, free, [])).toBe(false);
    expect(hasScopedAccess("school", scopes, null, null)).toBe(false);
  });
});
