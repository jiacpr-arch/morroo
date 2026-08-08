import { describe, it, expect } from "vitest";
import {
  ANONYMOUS_SCHOOL_ACCESS,
  SCHOOL_AI_DAILY_LIMIT,
  canOpenTopic,
  schoolAccessFor,
} from "./access";

const future = new Date(Date.now() + 86400_000 * 30).toISOString();
const past = new Date(Date.now() - 86400_000).toISOString();

describe("schoolAccessFor", () => {
  it("ให้สิทธิ์เต็มกับ tier School ทุกแบบ", () => {
    for (const type of ["school_monthly", "school_term", "school_yearly"]) {
      const access = schoolAccessFor({
        membership_type: type,
        membership_expires_at: future,
      });
      expect(access.isPremium).toBe(true);
      expect(access.previewOnly).toBe(false);
      expect(access.aiDailyLimit).toBe(SCHOOL_AI_DAILY_LIMIT.premium);
    }
  });

  it("แพ็ก นศพ. (monthly/yearly) รวมสิทธิ์ School ด้วย", () => {
    expect(
      schoolAccessFor({ membership_type: "monthly", membership_expires_at: future })
        .isPremium
    ).toBe(true);
    expect(
      schoolAccessFor({ membership_type: "yearly", membership_expires_at: future })
        .isPremium
    ).toBe(true);
  });

  it("แพ็ก Board ไม่รวมสิทธิ์ School", () => {
    expect(
      schoolAccessFor({
        membership_type: "board_monthly",
        membership_expires_at: future,
      }).previewOnly
    ).toBe(true);
  });

  it("หมดอายุแล้วกลับไปเป็นผู้ใช้ฟรี", () => {
    const access = schoolAccessFor({
      membership_type: "school_monthly",
      membership_expires_at: past,
    });
    expect(access.isPremium).toBe(false);
    expect(access.aiDailyLimit).toBe(SCHOOL_AI_DAILY_LIMIT.free);
  });

  it("free / null / undefined = ดูได้เฉพาะหัวข้อตัวอย่าง", () => {
    expect(schoolAccessFor(null).previewOnly).toBe(true);
    expect(schoolAccessFor({}).previewOnly).toBe(true);
    expect(
      schoolAccessFor({ membership_type: "free", membership_expires_at: null })
        .previewOnly
    ).toBe(true);
  });
});

describe("canOpenTopic", () => {
  it("ผู้จ่ายเงินเปิดได้ทุกหัวข้อ", () => {
    expect(canOpenTopic({ isPremium: true }, { is_preview: false })).toBe(true);
    expect(canOpenTopic({ isPremium: true }, null)).toBe(true);
  });

  it("ผู้ใช้ฟรีเปิดได้เฉพาะหัวข้อตัวอย่าง", () => {
    expect(canOpenTopic(ANONYMOUS_SCHOOL_ACCESS, { is_preview: true })).toBe(true);
    expect(canOpenTopic(ANONYMOUS_SCHOOL_ACCESS, { is_preview: false })).toBe(false);
    expect(canOpenTopic(ANONYMOUS_SCHOOL_ACCESS, {})).toBe(false);
    expect(canOpenTopic(ANONYMOUS_SCHOOL_ACCESS, null)).toBe(false);
  });
});
