import { describe, it, expect } from "vitest";
import { SCHOOL_AI_DAILY_LIMIT, schoolAiDailyLimit } from "./ai-quota";

const future = new Date(Date.now() + 86400_000 * 30).toISOString();
const past = new Date(Date.now() - 86400_000).toISOString();
const free = { membership_type: "free", membership_expires_at: null };

describe("schoolAiDailyLimit", () => {
  it("ผู้ใช้ฟรีได้เพดานต่ำ", () => {
    expect(schoolAiDailyLimit(free, [])).toBe(SCHOOL_AI_DAILY_LIMIT.free);
    expect(schoolAiDailyLimit(null, null)).toBe(SCHOOL_AI_DAILY_LIMIT.free);
  });

  it("สิทธิ์ School ทั้งระบบได้เพดานสูง", () => {
    const ent = [{ product: "school", scope: "*", expires_at: future }];
    expect(schoolAiDailyLimit(free, ent)).toBe(SCHOOL_AI_DAILY_LIMIT.paid);
  });

  it("ซื้อแค่วิชาเดียว/ชั้นปีเดียวก็นับเป็นผู้จ่ายเงิน", () => {
    const topic = [{ product: "school", scope: "topic:t1", expires_at: null }];
    const year = [{ product: "school", scope: "year:1", expires_at: null }];
    expect(schoolAiDailyLimit(free, topic)).toBe(SCHOOL_AI_DAILY_LIMIT.paid);
    expect(schoolAiDailyLimit(free, year)).toBe(SCHOOL_AI_DAILY_LIMIT.paid);
  });

  it("แพ็ก นศพ. แบบเดิม (legacy monthly) รวมสิทธิ์ School", () => {
    expect(
      schoolAiDailyLimit({ membership_type: "monthly", membership_expires_at: future }, [])
    ).toBe(SCHOOL_AI_DAILY_LIMIT.paid);
  });

  it("สิทธิ์ระบบอื่นไม่นับ / สิทธิ์หมดอายุกลับเป็นฟรี", () => {
    const board = [{ product: "board", scope: "*", expires_at: future }];
    const expired = [{ product: "school", scope: "*", expires_at: past }];
    expect(schoolAiDailyLimit(free, board)).toBe(SCHOOL_AI_DAILY_LIMIT.free);
    expect(schoolAiDailyLimit(free, expired)).toBe(SCHOOL_AI_DAILY_LIMIT.free);
  });
});
