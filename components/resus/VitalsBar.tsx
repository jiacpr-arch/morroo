"use client";

// แถบชีพจร — HP + หัวใจเต้น (เร็วขึ้นเมื่อ HP ต่ำ) + เวลา + จำนวนพลาด

import { fmtTime } from "@/lib/resus/engine";

interface VitalsBarProps {
  hp: number;
  maxHp: number;
  elapsed: number;
  parTimeSec: number;
  wrong: number;
}

export default function VitalsBar({ hp, maxHp, elapsed, parTimeSec, wrong }: VitalsBarProps) {
  const pct = Math.max(0, Math.min(100, (hp / maxHp) * 100));
  const tone = pct > 60 ? "rss-hp-good" : pct > 30 ? "rss-hp-warn" : "rss-hp-bad";
  const overPar = elapsed > parTimeSec;
  return (
    <div className="rss-vitals">
      <span
        className={`rss-heart ${pct <= 30 ? "rss-heart-fast" : ""}`}
        aria-hidden
      >
        ❤️
      </span>
      <div
        className="rss-hpbar"
        role="meter"
        aria-label="อาการผู้ป่วย"
        aria-valuenow={Math.round(pct)}
        aria-valuemin={0}
        aria-valuemax={100}
      >
        <div className={`rss-hpfill ${tone}`} style={{ width: `${pct}%` }} />
      </div>
      <span className={`rss-clock ${overPar ? "rss-clock-over" : ""}`}>
        ⏱ {fmtTime(elapsed)}
        <small> / {fmtTime(parTimeSec)}</small>
      </span>
      <span className="rss-wrongchip" title="จำนวนพลาด">✕ {wrong}</span>
    </div>
  );
}
