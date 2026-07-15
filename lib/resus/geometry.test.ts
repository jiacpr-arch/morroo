import { describe, expect, it } from "vitest";
import { accumulateTrace, pointInZone, tracePoints, zoneCenter } from "./geometry";
import type { Zone } from "./types";

describe("pointInZone", () => {
  it("circle: ใน/ขอบ/นอก", () => {
    const z: Zone = { shape: "circle", cx: 100, cy: 100, r: 50 };
    expect(pointInZone(z, { x: 100, y: 100 })).toBe(true);
    expect(pointInZone(z, { x: 150, y: 100 })).toBe(true); // ขอบพอดีนับว่าใน
    expect(pointInZone(z, { x: 151, y: 100 })).toBe(false);
    expect(pointInZone(z, { x: 136, y: 136 })).toBe(false); // มุม 45° นอกวง
  });

  it("rect: ใน/ขอบ/นอก", () => {
    const z: Zone = { shape: "rect", x: 10, y: 20, w: 100, h: 50 };
    expect(pointInZone(z, { x: 60, y: 45 })).toBe(true);
    expect(pointInZone(z, { x: 10, y: 20 })).toBe(true);
    expect(pointInZone(z, { x: 110, y: 70 })).toBe(true);
    expect(pointInZone(z, { x: 111, y: 45 })).toBe(false);
    expect(pointInZone(z, { x: 60, y: 19 })).toBe(false);
  });

  it("poly: สามเหลี่ยม", () => {
    const z: Zone = { shape: "poly", points: [[0, 0], [100, 0], [50, 100]] };
    expect(pointInZone(z, { x: 50, y: 30 })).toBe(true);
    expect(pointInZone(z, { x: 5, y: 90 })).toBe(false);
    expect(pointInZone(z, { x: 95, y: 90 })).toBe(false);
  });
});

describe("zoneCenter", () => {
  it("คืนจุดกลางของแต่ละ shape", () => {
    expect(zoneCenter({ shape: "circle", cx: 5, cy: 7, r: 3 })).toEqual({ x: 5, y: 7 });
    expect(zoneCenter({ shape: "rect", x: 0, y: 0, w: 10, h: 20 })).toEqual({ x: 5, y: 10 });
    const c = zoneCenter({ shape: "poly", points: [[0, 0], [10, 0], [10, 10], [0, 10]] });
    expect(c).toEqual({ x: 5, y: 5 });
  });
});

describe("tracePoints", () => {
  it("แตกเส้นตรงเป็นจุดถี่ตาม step และรวมจุดปลาย", () => {
    const pts = tracePoints([[0, 0], [240, 0]], 24);
    expect(pts.length).toBe(11); // 10 ช่วง + จุดปลาย
    expect(pts[0]).toEqual({ x: 0, y: 0 });
    expect(pts[pts.length - 1]).toEqual({ x: 240, y: 0 });
  });

  it("เส้นสั้นกว่า step ยังได้อย่างน้อยต้น+ปลาย", () => {
    const pts = tracePoints([[0, 0], [5, 0]], 24);
    expect(pts.length).toBeGreaterThanOrEqual(2);
  });
});

describe("accumulateTrace", () => {
  it("ลากครบเส้น → coverage = 1 และลากซ้ำไม่ลด", () => {
    const pts = tracePoints([[0, 0], [100, 0]], 20);
    const hits = new Array(pts.length).fill(false);
    let pct = 0;
    for (let x = 0; x <= 100; x += 5) {
      pct = accumulateTrace(pts, hits, { x, y: 0 }, 15);
    }
    expect(pct).toBe(1);
    // ลากย้อนกลับ — progress คงเดิม (monotonic)
    expect(accumulateTrace(pts, hits, { x: 50, y: 0 }, 15)).toBe(1);
  });

  it("จุดนอกเส้นเกิน tolerance ไม่นับ", () => {
    const pts = tracePoints([[0, 0], [100, 0]], 20);
    const hits = new Array(pts.length).fill(false);
    const pct = accumulateTrace(pts, hits, { x: 50, y: 100 }, 15);
    expect(pct).toBe(0);
  });

  it("ครอบคลุมบางส่วน → สัดส่วนระหว่าง 0..1 และไม่ลดลง", () => {
    const pts = tracePoints([[0, 0], [100, 0]], 20);
    const hits = new Array(pts.length).fill(false);
    const p1 = accumulateTrace(pts, hits, { x: 0, y: 0 }, 15);
    expect(p1).toBeGreaterThan(0);
    expect(p1).toBeLessThan(1);
    const p2 = accumulateTrace(pts, hits, { x: 20, y: 0 }, 15);
    expect(p2).toBeGreaterThanOrEqual(p1);
  });
});
