"use client";

import { useEffect, useState } from "react";
import { CalendarClock } from "lucide-react";
import { getNextExamRound, type ExamRound } from "@/lib/exam-dates";

// Urgency banner สำหรับหน้า pricing — แสดงเฉพาะเมื่อมีรอบสอบใน lib/exam-dates.ts
// ที่ยังมาไม่ถึง ไม่มีข้อมูล = ไม่ render อะไรเลย
export default function NlExamCountdown() {
  const [round, setRound] = useState<ExamRound | null>(null);
  const [daysLeft, setDaysLeft] = useState(0);

  // คำนวณฝั่ง client เท่านั้น กัน hydration mismatch จากเวลา server/client ต่างกัน
  useEffect(() => {
    const next = getNextExamRound();
    if (!next) return;
    const ms =
      new Date(`${next.date}T00:00:00+07:00`).getTime() - Date.now();
    setDaysLeft(Math.max(0, Math.ceil(ms / 86_400_000)));
    setRound(next);
  }, []);

  if (!round) return null;

  return (
    <div className="max-w-2xl mx-auto mb-10 flex items-center justify-center gap-3 rounded-2xl border border-amber-300 bg-amber-50 px-5 py-3 text-center">
      <CalendarClock className="h-5 w-5 shrink-0 text-amber-600" />
      <p className="text-sm sm:text-base">
        <span className="font-semibold">{round.label}</span> เหลืออีก{" "}
        <span className="font-bold text-amber-700">{daysLeft} วัน</span>{" "}
        — เริ่มฝึกวันนี้ให้ทันรอบสอบ
      </p>
    </div>
  );
}
