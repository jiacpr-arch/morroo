import { describe, expect, it } from "vitest";
import { buildCertMessage } from "./cert-notify";

describe("buildCertMessage", () => {
  it("includes ACLS-specific fields (pre-test, EKG)", () => {
    const msg = buildCertMessage({
      studentName: "อนันต์ ใจดี",
      studentPhone: "0812345678",
      course: "acls",
      courseTitle: "ACLS Provider",
      certId: "JIA-ACLS-ABC123",
      completedAt: "2026-07-12T00:00:00.000Z",
      preTestScore: 90,
      postTestScore: 95,
      ekgPassed: true,
    });
    expect(msg).toContain("อนันต์ ใจดี");
    expect(msg).toContain("Pre-test 90%");
    expect(msg).toContain("Post-test 95%");
    expect(msg).toContain("EKG ผ่าน");
    expect(msg).toContain("JIA-ACLS-ABC123");
  });

  it("omits pre-test and EKG for BLS", () => {
    const msg = buildCertMessage({
      studentName: "Test",
      course: "bls",
      certId: "JIA-BLS-XYZ",
      postTestScore: 88,
    });
    expect(msg).not.toContain("Pre-test");
    expect(msg).not.toContain("EKG");
    expect(msg).toContain("Post-test 88%");
  });

  it("falls back gracefully on missing fields", () => {
    const msg = buildCertMessage({});
    expect(msg).toContain("(ไม่ระบุชื่อ)");
    expect(msg).toContain("รหัสใบ: —");
  });
});
