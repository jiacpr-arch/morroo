"use client";

import { useState, useEffect } from "react";

// Each exam gets a different "coming soon" date based on its ID
function getTargetDate(examId: string): Date {
  // Simple hash to spread dates out 3-14 days from now
  let hash = 0;
  for (let i = 0; i < examId.length; i++) {
    hash = (hash * 31 + examId.charCodeAt(i)) % 12;
  }
  const daysFromNow = 3 + hash; // 3-14 days
  const target = new Date();
  target.setDate(target.getDate() + daysFromNow);
  target.setHours(9, 0, 0, 0); // 9:00 AM
  return target;
}

export default function ComingSoonCountdown({ examId }: { examId: string }) {
  const [timeLeft, setTimeLeft] = useState({ days: 0, hours: 0, minutes: 0, seconds: 0 });

  useEffect(() => {
    const target = getTargetDate(examId);

    function calc() {
      const now = new Date();
      const diff = Math.max(0, target.getTime() - now.getTime());
      return {
        days: Math.floor(diff / (1000 * 60 * 60 * 24)),
        hours: Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)),
        minutes: Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60)),
        seconds: Math.floor((diff % (1000 * 60)) / 1000),
      };
    }

    setTimeLeft(calc());
    const timer = setInterval(() => setTimeLeft(calc()), 1000);
    return () => clearInterval(timer);
  }, [examId]);

  return (
    <div className="flex items-center gap-1.5 text-xs text-purple-600">
      {[
        { value: timeLeft.days, label: "วัน" },
        { value: timeLeft.hours, label: "ชม." },
        { value: timeLeft.minutes, label: "นาที" },
        { value: timeLeft.seconds, label: "วิ." },
      ].map((item, i) => (
        <div key={i} className="flex items-center gap-0.5">
          <span className="bg-purple-100 text-purple-700 rounded px-1.5 py-0.5 font-mono font-bold tabular-nums min-w-[1.5rem] text-center">
            {String(item.value).padStart(2, "0")}
          </span>
          <span className="text-purple-400">{item.label}</span>
          {i < 3 && <span className="text-purple-300 mx-0.5">:</span>}
        </div>
      ))}
    </div>
  );
}
