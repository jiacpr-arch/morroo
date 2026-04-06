"use client";

import { useState, useEffect } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Sparkles, Clock, ArrowRight } from "lucide-react";
import Link from "next/link";
import { Button } from "@/components/ui/button";

// Daily generation happens at 02:00 UTC (09:00 ICT)
const GENERATION_HOUR_UTC = 2;

interface NewQuestionsCountdownProps {
  /** Number of new questions added today (0 = not yet generated) */
  newTodayCount: number;
  /** Subject name of today's batch */
  todaySubject?: string;
  /** Subject icon */
  todaySubjectIcon?: string;
  /** Subject ID for link */
  todaySubjectId?: string;
}

function getNextGenerationTime(): Date {
  const now = new Date();
  const next = new Date(now);
  next.setUTCHours(GENERATION_HOUR_UTC, 0, 0, 0);

  // If we've already passed 02:00 UTC today, next is tomorrow
  if (now >= next) {
    next.setUTCDate(next.getUTCDate() + 1);
  }
  return next;
}

function formatTimeLeft(diff: number) {
  if (diff <= 0) return { hours: 0, minutes: 0, seconds: 0 };
  return {
    hours: Math.floor(diff / (1000 * 60 * 60)),
    minutes: Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60)),
    seconds: Math.floor((diff % (1000 * 60)) / 1000),
  };
}

export default function NewQuestionsCountdown({
  newTodayCount,
  todaySubject,
  todaySubjectIcon,
  todaySubjectId,
}: NewQuestionsCountdownProps) {
  const [timeLeft, setTimeLeft] = useState(formatTimeLeft(0));
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    function update() {
      const diff = getNextGenerationTime().getTime() - Date.now();
      setTimeLeft(formatTimeLeft(diff));
    }
    update();
    const timer = setInterval(update, 1000);
    return () => clearInterval(timer);
  }, []);

  if (!mounted) return null;

  // If new questions were added today, show "new questions" banner
  if (newTodayCount > 0) {
    return (
      <Card className="border-emerald-300 bg-gradient-to-r from-emerald-50 to-teal-50 overflow-hidden">
        <CardContent className="py-4 px-5">
          <div className="flex items-center justify-between gap-4">
            <div className="flex-1 min-w-0">
              <div className="flex items-center gap-2 mb-1.5">
                <Sparkles className="h-4 w-4 text-emerald-600 shrink-0" />
                <span className="text-xs font-semibold text-emerald-700 uppercase tracking-wide">
                  ข้อสอบใหม่วันนี้
                </span>
                <Badge className="bg-emerald-100 text-emerald-700 text-xs">
                  +{newTodayCount} ข้อ
                </Badge>
              </div>
              <p className="text-sm text-emerald-800">
                {todaySubjectIcon && <span className="mr-1">{todaySubjectIcon}</span>}
                เพิ่มข้อสอบ{todaySubject ? ` ${todaySubject}` : ""} {newTodayCount} ข้อใหม่
                พร้อมให้ฝึกแล้ว!
              </p>
            </div>
            {todaySubjectId ? (
              <Link href={`/nl/practice?subject=${todaySubjectId}`} className="shrink-0">
                <Button size="sm" className="bg-emerald-600 hover:bg-emerald-700 text-white gap-1.5">
                  ฝึกเลย <ArrowRight className="h-3.5 w-3.5" />
                </Button>
              </Link>
            ) : (
              <Link href="/nl" className="shrink-0">
                <Button size="sm" className="bg-emerald-600 hover:bg-emerald-700 text-white gap-1.5">
                  ฝึกเลย <ArrowRight className="h-3.5 w-3.5" />
                </Button>
              </Link>
            )}
          </div>

          {/* Countdown to next batch */}
          <div className="mt-3 pt-3 border-t border-emerald-200/60 flex items-center gap-2">
            <Clock className="h-3.5 w-3.5 text-emerald-500" />
            <span className="text-xs text-emerald-600">ชุดถัดไปอีก</span>
            <div className="flex items-center gap-1">
              {[
                { value: timeLeft.hours, label: "ชม." },
                { value: timeLeft.minutes, label: "น." },
                { value: timeLeft.seconds, label: "วิ." },
              ].map((item, i) => (
                <span key={i} className="flex items-center gap-0.5">
                  <span className="bg-emerald-700 text-white rounded px-1.5 py-0.5 font-mono text-xs font-bold tabular-nums min-w-[1.5rem] text-center">
                    {String(item.value).padStart(2, "0")}
                  </span>
                  <span className="text-[10px] text-emerald-500">{item.label}</span>
                  {i < 2 && <span className="text-emerald-400 font-bold mx-0.5 text-xs">:</span>}
                </span>
              ))}
            </div>
          </div>
        </CardContent>
      </Card>
    );
  }

  // No new questions yet today — show countdown only
  return (
    <Card className="border-blue-200 bg-gradient-to-r from-blue-50 to-indigo-50 overflow-hidden">
      <CardContent className="py-4 px-5">
        <div className="flex items-center justify-between gap-4">
          <div className="flex-1 min-w-0">
            <div className="flex items-center gap-2 mb-1.5">
              <Clock className="h-4 w-4 text-blue-600 shrink-0" />
              <span className="text-xs font-semibold text-blue-700 uppercase tracking-wide">
                ข้อสอบใหม่กำลังจะมา
              </span>
            </div>
            <p className="text-sm text-blue-700">
              ข้อสอบชุดใหม่จะเข้าระบบอัตโนมัติทุกวัน 09:00 น.
            </p>
          </div>
          <div className="flex items-center gap-1 shrink-0">
            {[
              { value: timeLeft.hours, label: "ชม." },
              { value: timeLeft.minutes, label: "น." },
              { value: timeLeft.seconds, label: "วิ." },
            ].map((item, i) => (
              <span key={i} className="flex items-center gap-0.5">
                <span className="bg-blue-700 text-white rounded-md px-2 py-1 font-mono text-lg font-bold tabular-nums min-w-[2.5rem] text-center">
                  {String(item.value).padStart(2, "0")}
                </span>
                <span className="text-xs text-blue-500">{item.label}</span>
                {i < 2 && <span className="text-blue-400 font-bold mx-0.5">:</span>}
              </span>
            ))}
          </div>
        </div>
      </CardContent>
    </Card>
  );
}
