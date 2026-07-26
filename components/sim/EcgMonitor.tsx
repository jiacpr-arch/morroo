"use client";

import { useEffect, useRef } from "react";
import type { Rhythm } from "@/lib/sim/types";

interface Props {
  rhythm?: Rhythm;
  cpr?: boolean;
  width?: number;
  height?: number;
}

// จอกว้าง 1 จอ = กี่วินาทีของสัญญาณ — เทียบความเร็วกวาด 25 mm/s ของ monitor จริง
// (จอจริงเห็นคลื่นราว 4-6 วินาทีต่อหน้าจอ)
const SWEEP_SECONDS = 4;

// ECG แบบ sweep (เหมือนจอ monitor จริง): เส้นวาดทับของเก่า มีแถบดำกวาดนำหน้า
// rhythm: 'flat' | 'vf' | 'nsr' — cpr=true เพิ่ม compression artifact บน rhythm ที่ไม่ perfuse
// เดินตามเวลาจริง (ไม่ผูกกับ frame rate): t หน่วยเป็นวินาที ทุก rhythm ระบุอัตราจริงไว้
export default function EcgMonitor({ rhythm = "flat", cpr = false, width = 240, height = 52 }: Props) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const stateRef = useRef({ rhythm, cpr });
  useEffect(() => {
    stateRef.current = { rhythm, cpr };
  }, [rhythm, cpr]);

  useEffect(() => {
    const cv = canvasRef.current;
    const ctx = cv?.getContext("2d");
    if (!cv || !ctx) return undefined;
    ctx.fillStyle = "#040812";
    ctx.fillRect(0, 0, cv.width, cv.height);

    let sweepX = 0;
    let lastY: number | null = null;
    let tSec = 0;
    let prevTs: number | null = null;
    let raf = 0;
    const TAU = Math.PI * 2;

    const sample = (t: number) => {
      const { rhythm: r, cpr: c } = stateRef.current;
      if (r === "vf") {
        // coarse VF — คลื่นยุ่งเหยิงช่วง ~3-8 Hz
        return Math.sin(TAU * 4.7 * t) * 0.45 + Math.sin(TAU * 3.1 * t + 1) * 0.3 + Math.sin(TAU * 7.7 * t) * 0.15;
      }
      if (r === "nsr") {
        const b = (t * 1.2) % 1; // ~72 ครั้ง/นาที
        if (b < 0.05) return -0.1;
        if (b < 0.1) return 0.95;
        if (b < 0.15) return -0.3;
        if (b > 0.32 && b < 0.44) return 0.15;
        return 0;
      }
      let y = Math.sin(TAU * 8 * t) * 0.02;
      if (c) {
        const cc = (t * 1.83) % 1; // ~110 ครั้ง/นาที
        if (cc < 0.3) y += Math.sin((cc / 0.3) * Math.PI) * 0.5;
      }
      return y;
    };

    const draw = (ts: number) => {
      raf = requestAnimationFrame(draw);
      if (prevTs === null) {
        prevTs = ts;
        return;
      }
      const dt = Math.min((ts - prevTs) / 1000, 0.1); // กันกระโดดยาวตอน tab กลับมา active
      prevTs = ts;

      const W = cv.width, H = cv.height, mid = H * 0.55, amp = H * 0.4;
      const pxPerSec = W / SWEEP_SECONDS;
      const { rhythm: r } = stateRef.current;
      const col = r === "vf" ? "#E5484D" : "#37C871";
      let advance = dt * pxPerSec;
      while (advance > 0) {
        // เดินทีละ ≤1px เพื่อไม่ข้าม spike แคบๆ (QRS กว้างแค่ ~2px ที่ความเร็วนี้)
        const step = Math.min(advance, 1);
        advance -= step;
        tSec += step / pxPerSec;
        const x = sweepX + step;
        const y = mid - sample(tSec) * amp;
        ctx.fillStyle = "#040812";
        ctx.fillRect(x, 0, 14, H);
        if (lastY !== null) {
          ctx.strokeStyle = col;
          ctx.lineWidth = 2;
          ctx.lineCap = "round";
          ctx.beginPath();
          ctx.moveTo(sweepX, lastY);
          ctx.lineTo(x, y);
          ctx.stroke();
        }
        lastY = y;
        sweepX = x;
        if (sweepX >= W) { sweepX = 0; lastY = null; }
      }
    };
    raf = requestAnimationFrame(draw);
    return () => cancelAnimationFrame(raf);
  }, []);

  return <canvas ref={canvasRef} width={width} height={height} className="cbs-ecg" />;
}
