"use client";

// เวทีผ่าตัด — SVG ตัวเดียวรับ pointer ทุกอย่าง (mouse + touch ผ่าน Pointer Events)
// แปลงพิกัดจอ → viewBox แล้วส่งขึ้นไปให้ ResusRunner ตัดสินผ่าน engine
//
// การชี้เป้าตามความยาก: full = วงเป้า+เส้นนำชัด, subtle = จุดวิบๆ, none = ไม่ช่วย

import { useRef } from "react";
import OperationArt from "./OperationArt";
import { zoneCenter, type Point } from "@/lib/resus/geometry";
import { FIELD_H, FIELD_W, type Operation, type OperationStep, type ResusState, type Zone } from "@/lib/resus/types";

interface ResusFieldProps {
  op: Operation;
  view: ResusState;
  step: OperationStep | null;
  zone: Zone | null;
  highlight: "full" | "subtle" | "none";
  holdPct: number;
  onDown: (p: Point) => void;
  onMove: (p: Point) => void;
  onUp: () => void;
}

export default function ResusField({
  op, view, step, zone, highlight, holdPct, onDown, onMove, onUp,
}: ResusFieldProps) {
  const svgRef = useRef<SVGSVGElement>(null);
  const downRef = useRef(false);

  function toViewBox(e: React.PointerEvent): Point | null {
    const svg = svgRef.current;
    if (!svg) return null;
    const ctm = svg.getScreenCTM();
    if (!ctm) return null;
    const pt = new DOMPoint(e.clientX, e.clientY).matrixTransform(ctm.inverse());
    return { x: pt.x, y: pt.y };
  }

  function handleDown(e: React.PointerEvent) {
    const p = toViewBox(e);
    if (!p) return;
    downRef.current = true;
    (e.target as Element).setPointerCapture?.(e.pointerId);
    onDown(p);
  }

  function handleMove(e: React.PointerEvent) {
    if (!downRef.current) return;
    const p = toViewBox(e);
    if (p) onMove(p);
  }

  function handleUp() {
    if (!downRef.current) return;
    downRef.current = false;
    onUp();
  }

  // ภาพสะสมจาก step ที่เสร็จแล้ว
  const doneStates = new Set<string>();
  for (let i = 0; i < view.stepIdx && i < op.steps.length; i++) {
    const fx = op.steps[i].fxState;
    if (fx) doneStates.add(fx);
  }
  const stitchProgress = step?.id === "suture" ? view.tracePct : 0;
  const bleedingActive = !!step?.bleeding && !view.done && !view.dead;

  const center = zone ? zoneCenter(zone) : null;
  const showGuide = highlight === "full";
  const showDot = highlight !== "none";
  const trace = step?.gesture.kind === "trace" ? step.gesture : null;
  const hold = step?.gesture.kind === "hold" ? step.gesture : null;
  const taps = step?.gesture.kind === "taps" ? step.gesture : null;

  return (
    <svg
      ref={svgRef}
      className="rss-field"
      viewBox={`0 0 ${FIELD_W} ${FIELD_H}`}
      onPointerDown={handleDown}
      onPointerMove={handleMove}
      onPointerUp={handleUp}
      onPointerCancel={handleUp}
      onPointerLeave={handleUp}
      role="img"
      aria-label={step ? `เป้าหมายปัจจุบัน: ${step.title}` : "เวทีผ่าตัด"}
    >
      <OperationArt
        artId={op.artId}
        states={doneStates}
        stitchProgress={stitchProgress}
        bleedingActive={bleedingActive}
      />

      {/* เส้นนำสำหรับ trace (โหมดง่าย) + progress ที่ลากแล้ว */}
      {trace && showGuide && (
        <polyline
          points={trace.path.map(([x, y]) => `${x},${y}`).join(" ")}
          className="rss-guide"
        />
      )}
      {trace && view.tracePct > 0 && (
        <polyline
          points={trace.path.map(([x, y]) => `${x},${y}`).join(" ")}
          className="rss-guide-done"
          style={{
            strokeDasharray: 2200,
            strokeDashoffset: 2200 * (1 - view.tracePct),
          }}
        />
      )}

      {/* เป้าปัจจุบัน */}
      {zone && center && (
        <g>
          {showGuide && <ZoneOutline zone={zone} />}
          {showDot && (
            <circle cx={center.x} cy={center.y} r="14" className="rss-target-dot" />
          )}
          {/* วงแหวน progress ตอนกดค้าง */}
          {hold && holdPct > 0 && (
            <circle
              cx={center.x}
              cy={center.y}
              r="52"
              className="rss-hold-ring"
              strokeDasharray={2 * Math.PI * 52}
              strokeDashoffset={2 * Math.PI * 52 * (1 - holdPct)}
            />
          )}
          {/* pips นับ taps */}
          {taps && (
            <g className="rss-pips">
              {Array.from({ length: taps.count }).map((_, i) => (
                <circle
                  key={i}
                  cx={center.x - ((taps.count - 1) * 26) / 2 + i * 26}
                  cy={center.y - 70}
                  r="9"
                  className={i < view.tapsDone ? "rss-pip-on" : "rss-pip-off"}
                />
              ))}
            </g>
          )}
          {/* โซนโปร่งใสสำหรับ e2e + ขยายพื้นที่แตะ */}
          <ZoneHit zone={zone} />
        </g>
      )}
    </svg>
  );
}

function ZoneOutline({ zone }: { zone: Zone }) {
  if (zone.shape === "circle") {
    return <circle cx={zone.cx} cy={zone.cy} r={zone.r} className="rss-zone" />;
  }
  if (zone.shape === "rect") {
    return <rect x={zone.x} y={zone.y} width={zone.w} height={zone.h} rx="14" className="rss-zone" />;
  }
  return <polygon points={zone.points.map(([x, y]) => `${x},${y}`).join(" ")} className="rss-zone" />;
}

/** shape ล่องหนทับเป้า — ให้ Playwright คลิกได้และไม่บังภาพ */
function ZoneHit({ zone }: { zone: Zone }) {
  const common = { fill: "transparent", "data-testid": "zone-active" } as const;
  if (zone.shape === "circle") {
    return <circle cx={zone.cx} cy={zone.cy} r={zone.r} {...common} />;
  }
  if (zone.shape === "rect") {
    return <rect x={zone.x} y={zone.y} width={zone.w} height={zone.h} {...common} />;
  }
  return <polygon points={zone.points.map(([x, y]) => `${x},${y}`).join(" ")} {...common} />;
}
