"use client";

import { useState, useEffect, useRef } from "react";
import { Button } from "@/components/ui/button";
import { SkipForward } from "lucide-react";

interface ExamTimerProps {
  minutes: number;
  onTimeUp: () => void;
  running: boolean;
}

export default function ExamTimer({ minutes, onTimeUp, running }: ExamTimerProps) {
  const totalSeconds = minutes * 60;
  const [seconds, setSeconds] = useState(totalSeconds);
  const intervalRef = useRef<NodeJS.Timeout | null>(null);
  const calledRef = useRef(false);

  useEffect(() => {
    if (running && seconds > 0) {
      intervalRef.current = setInterval(() => {
        setSeconds((s) => s - 1);
      }, 1000);
    } else {
      if (intervalRef.current) clearInterval(intervalRef.current);
      if (seconds === 0 && running && !calledRef.current) {
        calledRef.current = true;
        onTimeUp();
      }
    }
    return () => {
      if (intervalRef.current) clearInterval(intervalRef.current);
    };
  }, [running, seconds, onTimeUp]);

  const mins = Math.floor(seconds / 60);
  const secs = seconds % 60;
  const progress = ((totalSeconds - seconds) / totalSeconds) * 100;
  const isExpired = seconds === 0;
  const isWarning = seconds <= 60 && seconds > 0;

  return (
    <div className="flex items-center justify-between w-full">
      <div className="flex items-center gap-3">
        <div className="relative h-10 w-10">
          <svg className="h-10 w-10 -rotate-90" viewBox="0 0 36 36">
            <circle
              cx="18" cy="18" r="16"
              fill="none" stroke="currentColor" strokeWidth="2"
              className="text-muted/30"
            />
            <circle
              cx="18" cy="18" r="16"
              fill="none" stroke="currentColor" strokeWidth="2"
              strokeDasharray={`${progress} 100`}
              className={isExpired ? "text-destructive" : isWarning ? "text-amber-500" : "text-brand"}
            />
          </svg>
        </div>
        <span
          className={`font-mono text-lg font-semibold tabular-nums ${
            isExpired ? "text-destructive" : isWarning ? "text-amber-500 animate-pulse" : ""
          }`}
        >
          {String(mins).padStart(2, "0")}:{String(secs).padStart(2, "0")}
        </span>
        {isExpired && (
          <span className="text-sm text-destructive font-medium">หมดเวลา!</span>
        )}
      </div>
      {running && !isExpired && (
        <Button
          variant="outline"
          size="sm"
          className="gap-1.5"
          onClick={onTimeUp}
        >
          <SkipForward className="h-4 w-4" />
          ข้ามไปตอนถัดไป
        </Button>
      )}
    </div>
  );
}
