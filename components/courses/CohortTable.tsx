"use client";

import { Check, X, Trash } from "lucide-react";
import { cn } from "@/lib/utils";

export interface CohortTableRow {
  id: string;
  studentId: string;
  name: string;
  phone: string | null;
  read: boolean;
  attemptCount: number;
  bestScore: number | null;
  passed: boolean;
  lastAttemptAt: string | null;
}

export interface CohortTableLesson {
  title?: string;
  passingScore?: number;
}

interface CohortTableProps {
  rows: CohortTableRow[];
  lesson?: CohortTableLesson | null;
  onDeleteStudent?: (row: CohortTableRow) => void;
}

export default function CohortTable({ rows, lesson, onDeleteStudent }: CohortTableProps) {
  if (!rows.length) {
    return (
      <div className="rounded-xl border border-border bg-card p-6 text-center text-xs text-muted-foreground shadow-sm">
        ยังไม่มีนักเรียนทำ pre-course ในเครื่องนี้
      </div>
    );
  }
  return (
    <div className="overflow-x-auto rounded-xl border border-border bg-card shadow-sm">
      <table className="w-full text-xs">
        <thead className="bg-muted text-foreground/80">
          <tr>
            <th className="px-3 py-2 text-left">#</th>
            <th className="px-3 py-2 text-left">รหัส</th>
            <th className="px-3 py-2 text-left">ชื่อ</th>
            <th className="px-3 py-2 text-left">เบอร์โทร</th>
            <th className="px-3 py-2 text-center">อ่าน</th>
            <th className="px-3 py-2 text-center">ครั้งที่ทำ</th>
            <th className="px-3 py-2 text-center">คะแนนสูงสุด</th>
            <th className="px-3 py-2 text-center">ผลลัพธ์</th>
            <th className="px-3 py-2 text-left">ครั้งล่าสุด</th>
            {onDeleteStudent && <th className="px-3 py-2"></th>}
          </tr>
        </thead>
        <tbody>
          {rows.map((r, i) => (
            <tr key={r.id} className="border-t border-border">
              <td className="px-3 py-2 text-muted-foreground">{i + 1}</td>
              <td className="px-3 py-2 font-mono text-foreground/80">{r.studentId}</td>
              <td className="px-3 py-2 text-foreground">{r.name}</td>
              <td className="px-3 py-2 font-mono text-foreground/80">{r.phone || "-"}</td>
              <td className="px-3 py-2 text-center">
                {r.read ? (
                  <Check
                    size={14}
                    strokeWidth={2.4}
                    className="inline text-emerald-600 dark:text-emerald-400"
                  />
                ) : (
                  <X size={14} strokeWidth={2.4} className="inline text-muted-foreground" />
                )}
              </td>
              <td className="px-3 py-2 text-center text-foreground/80">{r.attemptCount}</td>
              <td
                className={cn(
                  "px-3 py-2 text-center font-bold",
                  r.bestScore == null
                    ? "text-muted-foreground"
                    : r.passed
                      ? "text-emerald-600 dark:text-emerald-400"
                      : "text-amber-600 dark:text-amber-400",
                )}
              >
                {r.bestScore != null ? `${r.bestScore}%` : "-"}
              </td>
              <td className="px-3 py-2 text-center">
                {r.bestScore == null ? (
                  <span className="text-muted-foreground">-</span>
                ) : r.passed ? (
                  <span className="rounded-full bg-emerald-500/15 px-2 py-0.5 text-[11px] font-bold text-emerald-600 dark:text-emerald-400">
                    PASS
                  </span>
                ) : (
                  <span className="rounded-full bg-amber-500/15 px-2 py-0.5 text-[11px] font-bold text-amber-600 dark:text-amber-400">
                    FAIL
                  </span>
                )}
              </td>
              <td className="px-3 py-2 text-[11px] text-muted-foreground">
                {r.lastAttemptAt
                  ? new Date(r.lastAttemptAt).toLocaleString("th-TH", {
                      day: "2-digit",
                      month: "short",
                      hour: "2-digit",
                      minute: "2-digit",
                    })
                  : "-"}
              </td>
              {onDeleteStudent && (
                <td className="px-2 py-2 text-right">
                  <button
                    onClick={() => onDeleteStudent(r)}
                    className="inline-flex h-7 w-7 items-center justify-center rounded-md text-red-600 hover:bg-red-500/10 dark:text-red-400"
                    title="ลบนักเรียน"
                  >
                    <Trash size={13} strokeWidth={2.2} />
                  </button>
                </td>
              )}
            </tr>
          ))}
        </tbody>
      </table>
      <div className="border-t border-border px-3 py-2 text-[11px] text-muted-foreground">
        {lesson?.title || ""} · เกณฑ์ผ่าน {lesson?.passingScore ?? 70}%
      </div>
    </div>
  );
}
