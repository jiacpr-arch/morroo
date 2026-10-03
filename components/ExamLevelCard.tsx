"use client";

import { useState } from "react";
import {
  CURRENT_YEARS,
  EXAM_TARGETS,
  suggestTargetFromYear,
  type ExamTarget,
} from "@/lib/exam-level";

interface Props {
  initialTarget: ExamTarget | null;
  initialYear: number | null;
  /** "prompt" = dashboard nudge (shown until a level is set); "settings" = always-editable card. */
  variant?: "prompt" | "settings";
}

/** เลือกชั้นปี + ระดับข้อสอบ — ข้อสอบรายวัน LINE, เตือนวันสอบ และหน้าฝึกจะตามระดับนี้ */
export default function ExamLevelCard({ initialTarget, initialYear, variant = "settings" }: Props) {
  const [target, setTarget] = useState<ExamTarget | null>(initialTarget);
  const [year, setYear] = useState<number | null>(initialYear);
  const [saving, setSaving] = useState(false);
  const [status, setStatus] = useState<"idle" | "saved" | "error">("idle");

  async function save(next: { target_exam?: ExamTarget; current_year?: number }) {
    setSaving(true);
    setStatus("idle");
    try {
      const res = await fetch("/api/profile/exam-level", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(next),
      });
      if (!res.ok) throw new Error(String(res.status));
      setStatus("saved");
      return true;
    } catch {
      setStatus("error");
      return false;
    } finally {
      setSaving(false);
    }
  }

  async function pickYear(y: number) {
    const prevYear = year;
    const prevTarget = target;
    setYear(y);
    // Only preselect a level when the user hasn't chosen one yet.
    const suggested = target ? null : suggestTargetFromYear(y);
    if (suggested) setTarget(suggested);
    const ok = await save({ current_year: y, ...(suggested ? { target_exam: suggested } : {}) });
    if (!ok) {
      setYear(prevYear);
      setTarget(prevTarget);
    }
  }

  async function pickTarget(t: ExamTarget) {
    const prev = target;
    setTarget(t);
    if (!(await save({ target_exam: t }))) setTarget(prev);
  }

  return (
    <section className="rounded-3xl border border-surface-border bg-white p-5 shadow-sm sm:p-6">
      <h2 className="text-base font-bold text-brand-dark">
        {variant === "prompt" ? "🎯 ตั้งระดับข้อสอบของคุณ" : "ระดับข้อสอบ"}
      </h2>
      <p className="mt-1 text-sm leading-6 text-ink-soft">
        ข้อสอบรายวันใน LINE การเตือนวันสอบ และหน้าฝึก จะปรับตามระดับที่เลือก เปลี่ยนได้ตลอด
      </p>

      <p className="mt-4 text-xs font-semibold text-ink-soft">ชั้นปี</p>
      <div className="mt-2 flex flex-wrap gap-2" role="group" aria-label="ชั้นปี">
        {CURRENT_YEARS.map((y) => (
          <button
            key={y}
            type="button"
            disabled={saving}
            aria-pressed={year === y}
            onClick={() => pickYear(y)}
            className={`h-9 min-w-9 rounded-full border px-3 text-sm font-medium transition-colors ${
              year === y
                ? "border-brand bg-brand text-white"
                : "border-surface-border bg-white text-ink-soft hover:border-brand"
            }`}
          >
            ปี {y}
          </button>
        ))}
      </div>

      <p className="mt-4 text-xs font-semibold text-ink-soft">เตรียมสอบ</p>
      <div className="mt-2 grid gap-2 sm:grid-cols-2" role="group" aria-label="ระดับข้อสอบ">
        {EXAM_TARGETS.map((t) => (
          <button
            key={t.id}
            type="button"
            disabled={saving}
            aria-pressed={target === t.id}
            onClick={() => pickTarget(t.id)}
            className={`rounded-2xl border p-3 text-left transition-colors ${
              target === t.id
                ? "border-brand bg-surface-warm"
                : "border-surface-border bg-white hover:border-brand"
            }`}
          >
            <span className="text-sm font-semibold text-brand-dark">
              {t.icon} {t.label}
            </span>
            <span className="mt-0.5 block text-xs leading-5 text-ink-soft">{t.desc}</span>
          </button>
        ))}
      </div>

      <p className="mt-3 min-h-5 text-xs" aria-live="polite">
        {status === "saved" && <span className="text-brand-dark">✓ บันทึกแล้ว</span>}
        {status === "error" && <span className="text-red-600">บันทึกไม่สำเร็จ ลองใหม่อีกครั้ง</span>}
      </p>
    </section>
  );
}
