"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { CalendarClock } from "lucide-react";
import { getNextExamRound, type ExamRound } from "@/lib/exam-dates";
import type { ExamKind } from "@/lib/exam-level";

// Urgency banner สำหรับหน้า pricing — แสดงเฉพาะเมื่อมีรอบสอบใน lib/exam-dates.ts
// ที่ยังมาไม่ถึง ไม่มีข้อมูล = ไม่ render อะไรเลย
export default function NlExamCountdown({
  kinds,
  className = "mb-10",
}: {
  /** จำกัดเฉพาะรอบของระดับผู้ใช้ (lib/exam-level examKindsForTarget); ไม่ส่ง = รอบ MCQ ทั้งหมด */
  kinds?: ExamKind[];
  className?: string;
} = {}) {
  const [round, setRound] = useState<ExamRound | null>(null);
  const [daysLeft, setDaysLeft] = useState(0);
  const kindsKey = kinds?.join(",") ?? "";

  // คำนวณฝั่ง client เท่านั้น กัน hydration mismatch จากเวลา server/client ต่างกัน
  useEffect(() => {
    const parsed = kindsKey ? (kindsKey.split(",") as ExamKind[]) : undefined;
    const next = getNextExamRound(new Date(), parsed);
    if (!next) {
      setRound(null);
      return;
    }
    const ms =
      new Date(`${next.date}T00:00:00+07:00`).getTime() - Date.now();
    setDaysLeft(Math.max(0, Math.ceil(ms / 86_400_000)));
    setRound(next);
  }, [kindsKey]);

  if (!round) return null;

  return (
    <div className={`max-w-2xl mx-auto ${className} flex items-center justify-center gap-3 rounded-2xl border border-amber-300 bg-amber-50 px-5 py-3 text-center`}>
      <CalendarClock className="h-5 w-5 shrink-0 text-amber-600" />
      <p className="text-sm sm:text-base">
        <span className="font-semibold">{round.label}</span> เหลืออีก{" "}
        <span className="font-bold text-amber-700">
          {round.confirmed ? "" : "~"}
          {daysLeft} วัน
        </span>{" "}
        — เริ่มฝึกวันนี้ให้ทันรอบสอบ
        {!round.confirmed && (
          <span className="block text-xs text-amber-600/80 sm:inline sm:ml-1">
            (กำหนดการคาดการณ์ — รอประกาศ ศรว.)
          </span>
        )}
        <Link
          href="/nl/calendar"
          className="block text-xs font-medium text-amber-700 underline hover:text-amber-800 sm:inline sm:ml-2"
        >
          ดูปฏิทินสอบทุกรอบ
        </Link>
      </p>
    </div>
  );
}
