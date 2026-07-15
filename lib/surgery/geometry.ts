// เรขาคณิตล้วนสำหรับ hit-test บนเวทีผ่าตัด (ไม่มี DOM — unit test ได้เต็มที่)
//
// พิกัดทั้งหมดอยู่ในระบบ viewBox ของเวที (0..1000 × 0..750) — ฝั่ง UI
// แปลง pointer event เป็นพิกัดนี้ก่อนส่งเข้า engine

import type { Zone } from "./types";

export interface Point {
  x: number;
  y: number;
}

export function pointInZone(zone: Zone, p: Point): boolean {
  if (zone.shape === "circle") {
    const dx = p.x - zone.cx;
    const dy = p.y - zone.cy;
    return dx * dx + dy * dy <= zone.r * zone.r;
  }
  if (zone.shape === "rect") {
    return p.x >= zone.x && p.x <= zone.x + zone.w && p.y >= zone.y && p.y <= zone.y + zone.h;
  }
  return pointInPolygon(zone.points, p);
}

// ray casting มาตรฐาน — นับจำนวนครั้งที่รังสีแนวนอนตัดขอบ polygon
function pointInPolygon(points: [number, number][], p: Point): boolean {
  let inside = false;
  for (let i = 0, j = points.length - 1; i < points.length; j = i++) {
    const [xi, yi] = points[i];
    const [xj, yj] = points[j];
    const intersects =
      yi > p.y !== yj > p.y &&
      p.x < ((xj - xi) * (p.y - yi)) / (yj - yi) + xi;
    if (intersects) inside = !inside;
  }
  return inside;
}

export function distToPoint(a: Point, bx: number, by: number): number {
  const dx = a.x - bx;
  const dy = a.y - by;
  return Math.sqrt(dx * dx + dy * dy);
}

/** จุดศูนย์กลางโดยประมาณของ zone — ใช้วาด highlight/ring */
export function zoneCenter(zone: Zone): Point {
  if (zone.shape === "circle") return { x: zone.cx, y: zone.cy };
  if (zone.shape === "rect") return { x: zone.x + zone.w / 2, y: zone.y + zone.h / 2 };
  const n = zone.points.length;
  const sum = zone.points.reduce((acc, [x, y]) => ({ x: acc.x + x, y: acc.y + y }), { x: 0, y: 0 });
  return { x: sum.x / n, y: sum.y / n };
}

/**
 * แตกเส้น trace เป็นจุดตรวจถี่ๆ (ทุก ~step หน่วย viewBox) — ผู้เล่นลากผ่าน
 * จุดไหน (ภายใน tolerance) จุดนั้นถือว่า "แตะแล้ว" สะสมจนครบสัดส่วนที่กำหนด
 * การแตะไม่มีลำดับบังคับ (ลากย้อนได้) และออกนอกเส้นไม่ถูกลงโทษ — progress
 * แค่หยุดนิ่ง ให้อภัยบนจอมือถือ
 */
export function tracePoints(path: [number, number][], step = 24): Point[] {
  const pts: Point[] = [];
  for (let i = 0; i < path.length - 1; i++) {
    const [x1, y1] = path[i];
    const [x2, y2] = path[i + 1];
    const segLen = Math.sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2);
    const n = Math.max(1, Math.round(segLen / step));
    for (let k = 0; k < n; k++) {
      const t = k / n;
      pts.push({ x: x1 + (x2 - x1) * t, y: y1 + (y2 - y1) * t });
    }
  }
  const [lx, ly] = path[path.length - 1];
  pts.push({ x: lx, y: ly });
  return pts;
}

/**
 * อัปเดต hit array ของ trace จากตำแหน่ง pointer ปัจจุบัน
 * คืนสัดส่วนที่ครอบคลุมแล้ว (0..1) — mutate hits in place
 */
export function accumulateTrace(
  points: Point[],
  hits: boolean[],
  p: Point,
  tolerance: number,
): number {
  let hitCount = 0;
  for (let i = 0; i < points.length; i++) {
    if (!hits[i] && distToPoint(p, points[i].x, points[i].y) <= tolerance) {
      hits[i] = true;
    }
    if (hits[i]) hitCount++;
  }
  return points.length ? hitCount / points.length : 0;
}
