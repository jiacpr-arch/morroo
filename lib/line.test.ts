import { describe, it, expect } from "vitest";
import {
  computeLineQuotaStatus,
  LINE_QUOTA_RESERVE_MIN,
  LINE_QUOTA_RESERVE_FRACTION,
} from "./line";

describe("computeLineQuotaStatus", () => {
  it("never throttles when the plan is unlimited (limit === null)", () => {
    const status = computeLineQuotaStatus(null, 999_999);
    expect(status).toEqual({ limit: null, used: 999_999, remaining: null, throttled: false });
  });

  it("never throttles when usage is unknown (used === null)", () => {
    const status = computeLineQuotaStatus(1000, null);
    expect(status.throttled).toBe(false);
    expect(status.remaining).toBeNull();
  });

  it("does not throttle with plenty of headroom", () => {
    const status = computeLineQuotaStatus(15000, 1000);
    expect(status.remaining).toBe(14000);
    expect(status.throttled).toBe(false);
  });

  it("throttles once remaining drops to the reserve (fraction-based on a large plan)", () => {
    const limit = 15000;
    const reserve = Math.max(LINE_QUOTA_RESERVE_MIN, Math.ceil(limit * LINE_QUOTA_RESERVE_FRACTION));
    expect(reserve).toBe(750); // 5% of 15000

    const justAboveReserve = computeLineQuotaStatus(limit, limit - reserve - 1);
    expect(justAboveReserve.throttled).toBe(false);

    const atReserve = computeLineQuotaStatus(limit, limit - reserve);
    expect(atReserve.throttled).toBe(true);
  });

  it("throttles using the flat minimum reserve on a small plan", () => {
    const limit = 1000; // 5% would be 50, less than the 300 floor
    const reserve = Math.max(LINE_QUOTA_RESERVE_MIN, Math.ceil(limit * LINE_QUOTA_RESERVE_FRACTION));
    expect(reserve).toBe(LINE_QUOTA_RESERVE_MIN);

    const status = computeLineQuotaStatus(limit, limit - LINE_QUOTA_RESERVE_MIN);
    expect(status.throttled).toBe(true);
  });

  it("throttles when quota is fully exhausted", () => {
    const status = computeLineQuotaStatus(15000, 15000);
    expect(status.remaining).toBe(0);
    expect(status.throttled).toBe(true);
  });
});
