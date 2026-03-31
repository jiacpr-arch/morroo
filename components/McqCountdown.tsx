"use client";

import { useState, useEffect } from "react";

export default function McqCountdown() {
  const [timeLeft, setTimeLeft] = useState({ hours: 0, minutes: 0, seconds: 0 });

  useEffect(() => {
    function calc() {
      const now = new Date();
      // Next activation: tomorrow 08:00 Thai time (01:00 UTC)
      const target = new Date(now);
      target.setUTCHours(1, 0, 0, 0);
      if (target.getTime() <= now.getTime()) {
        target.setUTCDate(target.getUTCDate() + 1);
      }
      const diff = Math.max(0, target.getTime() - now.getTime());
      return {
        hours: Math.floor(diff / (1000 * 60 * 60)),
        minutes: Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60)),
        seconds: Math.floor((diff % (1000 * 60)) / 1000),
      };
    }

    setTimeLeft(calc());
    const timer = setInterval(() => setTimeLeft(calc()), 1000);
    return () => clearInterval(timer);
  }, []);

  return (
    <div className="flex items-center gap-1.5 text-xs text-purple-600">
      {[
        { value: timeLeft.hours, label: "ชม." },
        { value: timeLeft.minutes, label: "นาที" },
        { value: timeLeft.seconds, label: "วิ." },
      ].map((item, i) => (
        <div key={i} className="flex items-center gap-0.5">
          <span className="bg-purple-100 text-purple-700 rounded px-1.5 py-0.5 font-mono font-bold tabular-nums min-w-[1.5rem] text-center">
            {String(item.value).padStart(2, "0")}
          </span>
          <span className="text-purple-400">{item.label}</span>
          {i < 2 && <span className="text-purple-300 mx-0.5">:</span>}
        </div>
      ))}
    </div>
  );
}
