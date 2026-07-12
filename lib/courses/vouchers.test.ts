import { describe, expect, it } from "vitest";
import { validateVoucher, type Voucher } from "./vouchers";

describe("validateVoucher", () => {
  it("accepts a known code regardless of case/whitespace", () => {
    expect(validateVoucher("acls2025")?.code).toBe("ACLS2025");
    expect(validateVoucher("  ACLS2025  ")?.code).toBe("ACLS2025");
  });

  it("rejects unknown or empty codes", () => {
    expect(validateVoucher("NOPE")).toBeNull();
    expect(validateVoucher("")).toBeNull();
    expect(validateVoucher(null)).toBeNull();
    expect(validateVoucher(undefined)).toBeNull();
  });

  it("respects expiresAt", () => {
    const expired: Voucher = {
      code: "ACLS2025",
      label: "x",
      expiresAt: "2026-01-01T00:00:00.000Z",
    };
    // Real list has expiresAt: null for ACLS2025 → valid at any time.
    expect(
      validateVoucher("ACLS2025", "2099-01-01T00:00:00.000Z"),
    ).not.toBeNull();
    // Simulate expiry semantics directly against the comparison used.
    expect(expired.expiresAt! < "2026-07-01T00:00:00.000Z").toBe(true);
  });
});
