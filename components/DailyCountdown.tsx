"use client";

import { useState, useEffect } from "react";

export default function DailyCountdown() {
  const [timeLeft, setTimeLeft] = useState({ hours: 0, minutes: 0, seconds: 0 });

  useEffect(() => {
    function calcTimeLeft() {
      const now = new Date();
      const tomorrow = new Date(now);
      tomorrow.setDate(tomorrow.getDate() + 1);
      tomorrow.setHours(0, 0, 0, 0);
      const diff = tomorrow.getTime() - now.getTime();
      return {
        hours: Math.floor(diff / (1000 * 60 * 60)),
        minutes: Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60)),
        seconds: Math.floor((diff % (1000 * 60)) / 1000),
      };
    }

    setTimeLeft(calcTimeLeft());
    const timer = setInterval(() => setTimeLeft(calcTimeLeft()), 1000);
    return () => clearInterval(timer);
  }, []);

  return (
    <div className="flex items-center gap-2">
      {[
        { value: timeLeft.hours, label: "ชม." },
        { value: timeLeft.minutes, label: "นาที" },
        { value: timeLeft.seconds, label: "วินาที" },
      ].map((item, i) => (
        <div key={i} className="flex items-center gap-1">
          <span className="bg-brand-dark text-white rounded-md px-2 py-1 font-mono text-lg font-bold tabular-nums min-w-[2.5rem] text-center">
            {String(item.value).padStart(2, "0")}
          </span>
          <span className="text-xs text-muted-foreground">{item.label}</span>
          {i < 2 && <span className="text-muted-foreground font-bold mx-0.5">:</span>}
        </div>
      ))}
    </div>
  );
}
