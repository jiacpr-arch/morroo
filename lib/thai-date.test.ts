import { describe, expect, it } from "vitest";
import { isRealIsoDate, normalizeThaiText, parseThaiDate, weekdayOfIso } from "./thai-date";

describe("parseThaiDate", () => {
  it("reads a full date with weekday and converts the Buddhist year", () => {
    expect(parseThaiDate("วันเสาร์ที่ 10 ตุลาคม 2569")).toEqual({ iso: "2026-10-10", weekday: 6 });
    expect(parseThaiDate("วันอาทิตย์ที่ 19 กรกฎาคม 2569")).toEqual({ iso: "2026-07-19", weekday: 0 });
  });

  it("works without a weekday and with surrounding text", () => {
    expect(parseThaiDate("สอบวันที่ 1 พฤษภาคม 2570 เวลา 09.00 น.")).toEqual({ iso: "2027-05-01", weekday: null });
  });

  it("reads all twelve months", () => {
    const names = [
      "มกราคม", "กุมภาพันธ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน",
      "กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม",
    ];
    names.forEach((name, i) => {
      const iso = `2027-${String(i + 1).padStart(2, "0")}-05`;
      expect(parseThaiDate(`5 ${name} 2570`)?.iso).toBe(iso);
    });
  });

  it("reads abbreviated months, with or without the trailing dot", () => {
    expect(parseThaiDate("10 ต.ค. 2569")?.iso).toBe("2026-10-10");
    expect(parseThaiDate("10 ต.ค 2569")?.iso).toBe("2026-10-10");
    expect(parseThaiDate("11 ม.ค. 2570")?.iso).toBe("2027-01-11");
    expect(parseThaiDate("9 มี.ค. 2569")?.iso).toBe("2026-03-09");
    expect(parseThaiDate("9 มิ.ย. 2569")?.iso).toBe("2026-06-09");
  });

  it("does not confuse มกราคม/มีนาคม/มิถุนายน style prefixes", () => {
    expect(parseThaiDate("7 มิถุนายน 2569")?.iso).toBe("2026-06-07");
    expect(parseThaiDate("8 มีนาคม 2569")?.iso).toBe("2026-03-08");
  });

  it("reads Thai digits and a Gregorian year", () => {
    expect(parseThaiDate("วันเสาร์ที่ ๑๐ ตุลาคม ๒๕๖๙")?.iso).toBe("2026-10-10");
    expect(parseThaiDate("10 ตุลาคม 2026")?.iso).toBe("2026-10-10");
  });

  it("accepts a พ.ศ. marker before the year", () => {
    expect(parseThaiDate("10 ตุลาคม พ.ศ. 2569")?.iso).toBe("2026-10-10");
  });

  it("rejects impossible dates and garbage", () => {
    expect(parseThaiDate("31 กุมภาพันธ์ 2570")).toBeNull();
    expect(parseThaiDate("32 ตุลาคม 2569")).toBeNull();
    expect(parseThaiDate("ไม่มีวันที่")).toBeNull();
    expect(parseThaiDate("")).toBeNull();
  });
});

describe("helpers", () => {
  it("computes the real weekday", () => {
    expect(weekdayOfIso("2026-10-10")).toBe(6); // Saturday
    expect(weekdayOfIso("2027-01-10")).toBe(0); // Sunday
  });
  it("validates ISO dates", () => {
    expect(isRealIsoDate("2027-02-28")).toBe(true);
    expect(isRealIsoDate("2027-02-29")).toBe(false);
    expect(isRealIsoDate("2027-2-1")).toBe(false);
  });
  it("normalises digits and whitespace", () => {
    expect(normalizeThaiText("  ๑๐   ตุลาคม\n๒๕๖๙ ")).toBe("10 ตุลาคม 2569");
  });
});
