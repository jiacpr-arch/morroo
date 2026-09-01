"use client";

import { useEffect, useState } from "react";

// ป้าย "เหลืออีก X วัน" สำหรับหน้าปฏิทินสอบ — คำนวณฝั่ง client เท่านั้น
// กัน hydration mismatch (หน้า parent เป็น static server component)
export default function ExamDaysLeft({
  date,
  confirmed,
}: {
  /** ISO date ของวันสอบ เช่น "2026-07-19" */
  date: string;
  confirmed: boolean;
}) {
  const [daysLeft, setDaysLeft] = useState<number | null>(null);

  useEffect(() => {
    const ms = new Date(`${date}T00:00:00+07:00`).getTime() - Date.now();
    setDaysLeft(Math.ceil(ms / 86_400_000));
  }, [date]);

  if (daysLeft === null || daysLeft < 0) return null;

  return (
    <span className="inline-flex items-center rounded-full bg-amber-100 px-2.5 py-0.5 text-xs font-semibold text-amber-800">
      เหลือ{confirmed ? "" : " ~"} {daysLeft} วัน
    </span>
  );
}
