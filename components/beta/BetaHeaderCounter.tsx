"use client";

import { useState } from "react";
import { formatHeaderCounter, formatThaiDate, getHeaderCounterColor } from "@/lib/beta";
import { cn } from "@/lib/utils";
import { useBeta } from "./BetaProvider";

export default function BetaHeaderCounter() {
  const [open, setOpen] = useState(false);
  const { status } = useBeta();

  if (!status || !status.isBeta) return null;

  const color = getHeaderCounterColor(status);
  const colorClass =
    color === "danger"
      ? "bg-red-50 text-red-700 ring-1 ring-red-200 animate-pulse"
      : color === "warning"
        ? "bg-amber-50 text-amber-700 ring-1 ring-amber-200"
        : "bg-gray-100 text-gray-700";

  const tooltip =
    color === "warning"
      ? "ใกล้ครบแล้ว ตอบ survey เพื่อรับคูปอง"
      : undefined;

  return (
    <div className="relative">
      <button
        type="button"
        onClick={() => setOpen((v) => !v)}
        title={tooltip}
        className={cn(
          "inline-flex items-center gap-1 rounded-full px-3 py-1 text-xs font-medium transition",
          colorClass
        )}
      >
        <span>{formatHeaderCounter(status)}</span>
      </button>
      {open && (
        <div
          className="absolute right-0 mt-2 w-72 rounded-xl border bg-white shadow-lg p-4 z-50 text-sm"
          onMouseLeave={() => setOpen(false)}
        >
          <div className="font-semibold mb-2 flex items-center gap-1">
            🧪 Beta Tester
          </div>
          <dl className="space-y-1 text-xs">
            <div className="flex justify-between">
              <dt className="text-muted-foreground">ข้อสอบที่ใช้</dt>
              <dd className="font-medium">
                {status.questionsUsed} / {status.questionsLimit} ข้อ
              </dd>
            </div>
            <div className="flex justify-between">
              <dt className="text-muted-foreground">วันหมดเขต</dt>
              <dd className="font-medium">
                {status.expiresAt ? formatThaiDate(status.expiresAt) : "-"}
              </dd>
            </div>
            <div className="flex justify-between">
              <dt className="text-muted-foreground">เหลือ</dt>
              <dd className="font-medium">
                {status.isExpired ? "หมดเขตแล้ว" : `${status.daysLeft} วัน`}
              </dd>
            </div>
            {status.couponCode && (
              <div className="pt-2 mt-2 border-t">
                <div className="text-muted-foreground">คูปอง</div>
                <div className="font-mono font-bold text-brand">
                  {status.couponCode}
                </div>
                <div className="text-[10px] text-muted-foreground">
                  ลด 50% สำหรับเดือนแรก
                </div>
              </div>
            )}
          </dl>
        </div>
      )}
    </div>
  );
}
