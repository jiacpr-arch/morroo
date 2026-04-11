"use client";

import { useState, useEffect } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Sparkles, Clock, ArrowRight, BookOpen, Stethoscope, FileText } from "lucide-react";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { useTranslation } from "@/lib/i18n/context";

// Schedule: MCQ daily 02:00 UTC (09:00 ICT), MEQ Mon+Thu 03:00 UTC (10:00 ICT), Long Case Sun 04:00 UTC (11:00 ICT)
interface ScheduleItem {
  type: "mcq" | "meq" | "longcase";
  label: string;
  icon: React.ReactNode;
  frequency: string;
  color: string;
  bgColor: string;
  borderColor: string;
  href: string;
  getNextTime: () => Date;
}

function getNextMcqTime(): Date {
  const now = new Date();
  const next = new Date(now);
  next.setUTCHours(2, 0, 0, 0);
  if (now >= next) next.setUTCDate(next.getUTCDate() + 1);
  return next;
}

function getNextMeqTime(): Date {
  const now = new Date();
  const next = new Date(now);
  // Next Monday (1) or Thursday (4)
  const day = now.getUTCDay();
  let daysUntil: number;
  if (day < 1) daysUntil = 1; // Sun → Mon
  else if (day < 4) daysUntil = 4 - day; // Mon-Wed → Thu
  else if (day === 4) {
    // Thu: check if past 03:00 UTC
    const todayTarget = new Date(now);
    todayTarget.setUTCHours(3, 0, 0, 0);
    if (now < todayTarget) { daysUntil = 0; }
    else { daysUntil = 7 - day + 1; } // next Mon
  }
  else daysUntil = 7 - day + 1; // Fri-Sat → next Mon

  next.setUTCDate(next.getUTCDate() + daysUntil);
  next.setUTCHours(3, 0, 0, 0);

  // If it's Mon and before 03:00 UTC
  if (day === 1) {
    const todayTarget = new Date(now);
    todayTarget.setUTCHours(3, 0, 0, 0);
    if (now < todayTarget) return todayTarget;
  }

  return next;
}

function getNextLongCaseTime(): Date {
  const now = new Date();
  const next = new Date(now);
  const day = now.getUTCDay();
  // Next Sunday (0)
  const daysUntil = day === 0 ? 0 : 7 - day;
  next.setUTCDate(next.getUTCDate() + daysUntil);
  next.setUTCHours(4, 0, 0, 0);
  if (now >= next) next.setUTCDate(next.getUTCDate() + 7);
  return next;
}

function formatTimeLeft(diff: number) {
  if (diff <= 0) return { days: 0, hours: 0, minutes: 0, seconds: 0 };
  return {
    days: Math.floor(diff / (1000 * 60 * 60 * 24)),
    hours: Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)),
    minutes: Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60)),
    seconds: Math.floor((diff % (1000 * 60)) / 1000),
  };
}

function getSchedules(t: ReturnType<typeof useTranslation>["t"]): ScheduleItem[] {
  return [
    {
      type: "mcq",
      label: t.countdown.mcqNew,
      icon: <FileText className="h-4 w-4" />,
      frequency: t.countdown.mcqFreq,
      color: "text-blue-700",
      bgColor: "bg-blue-50",
      borderColor: "border-blue-200",
      href: "/nl",
      getNextTime: getNextMcqTime,
    },
    {
      type: "meq",
      label: t.countdown.meqNew,
      icon: <BookOpen className="h-4 w-4" />,
      frequency: t.countdown.meqFreq,
      color: "text-purple-700",
      bgColor: "bg-purple-50",
      borderColor: "border-purple-200",
      href: "/exams",
      getNextTime: getNextMeqTime,
    },
    {
      type: "longcase",
      label: t.countdown.longCaseNew,
      icon: <Stethoscope className="h-4 w-4" />,
      frequency: t.countdown.longCaseFreq,
      color: "text-amber-700",
      bgColor: "bg-amber-50",
      borderColor: "border-amber-200",
      href: "/longcase",
      getNextTime: getNextLongCaseTime,
    },
  ];
}

function CountdownUnit({ value, label, color }: { value: number; label: string; color: string }) {
  const bgMap: Record<string, string> = {
    "text-blue-700": "bg-blue-700",
    "text-purple-700": "bg-purple-700",
    "text-amber-700": "bg-amber-700",
  };
  return (
    <span className="flex items-center gap-0.5">
      <span className={`${bgMap[color] || "bg-gray-700"} text-white rounded px-1.5 py-0.5 font-mono text-xs font-bold tabular-nums min-w-[1.5rem] text-center`}>
        {String(value).padStart(2, "0")}
      </span>
      <span className="text-[10px] text-gray-500">{label}</span>
    </span>
  );
}

export default function AllExamsCountdown() {
  const { t } = useTranslation();
  const SCHEDULES = getSchedules(t);
  const [timers, setTimers] = useState<Record<string, ReturnType<typeof formatTimeLeft>>>({});
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    function update() {
      const now = Date.now();
      const newTimers: Record<string, ReturnType<typeof formatTimeLeft>> = {};
      for (const s of SCHEDULES) {
        newTimers[s.type] = formatTimeLeft(s.getNextTime().getTime() - now);
      }
      setTimers(newTimers);
    }
    update();
    const interval = setInterval(update, 1000);
    return () => clearInterval(interval);
  }, []);

  if (!mounted) return null;

  return (
    <Card className="border-gray-200 bg-gradient-to-br from-white to-gray-50 overflow-hidden">
      <CardContent className="py-4 px-5">
        <div className="flex items-center gap-2 mb-4">
          <Sparkles className="h-4 w-4 text-brand" />
          <span className="text-sm font-bold text-gray-900">
            {t.countdown.title}
          </span>
          <Badge className="bg-green-100 text-green-700 text-[10px]">LIVE</Badge>
        </div>

        <div className="space-y-3">
          {SCHEDULES.map((s) => {
            const timer = timers[s.type];
            if (!timer) return null;

            return (
              <div
                key={s.type}
                className={`flex items-center justify-between gap-3 rounded-lg ${s.bgColor} border ${s.borderColor} p-3`}
              >
                <div className="flex items-center gap-2.5 min-w-0">
                  <span className={s.color}>{s.icon}</span>
                  <div className="min-w-0">
                    <p className={`text-sm font-semibold ${s.color}`}>{s.label}</p>
                    <p className="text-[11px] text-gray-500">{s.frequency}</p>
                  </div>
                </div>

                <div className="flex items-center gap-2 shrink-0">
                  <div className="flex items-center gap-1">
                    <Clock className="h-3 w-3 text-gray-400" />
                    {timer.days > 0 && (
                      <>
                        <CountdownUnit value={timer.days} label={t.time.daysShort} color={s.color} />
                        <span className="text-gray-300 text-xs">:</span>
                      </>
                    )}
                    <CountdownUnit value={timer.hours} label={t.time.hoursShort} color={s.color} />
                    <span className="text-gray-300 text-xs">:</span>
                    <CountdownUnit value={timer.minutes} label={t.time.minutesShort} color={s.color} />
                    <span className="text-gray-300 text-xs">:</span>
                    <CountdownUnit value={timer.seconds} label={t.time.secondsShort} color={s.color} />
                  </div>
                  <Link href={s.href}>
                    <Button size="sm" variant="ghost" className={`h-7 w-7 p-0 ${s.color}`}>
                      <ArrowRight className="h-3.5 w-3.5" />
                    </Button>
                  </Link>
                </div>
              </div>
            );
          })}
        </div>
      </CardContent>
    </Card>
  );
}
