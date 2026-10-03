"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";
import {
  CURRENT_YEARS,
  EXAM_TARGETS,
  suggestTargetFromYear,
  type ExamTarget,
} from "@/lib/exam-level";

interface Props {
  initialTarget: ExamTarget | null;
  initialYear: number | null;
  /** บอร์ดสาขาที่เลือกไว้ (board_specialties.slug) */
  initialBoardSpecialty?: string | null;
  /** "prompt" = dashboard nudge (shown until a level is set); "settings" = always-editable card. */
  variant?: "prompt" | "settings";
}

/** เลือกชั้นปี + ระดับข้อสอบ — ข้อสอบรายวัน LINE, เตือนวันสอบ และหน้าฝึกจะตามระดับนี้ */
interface BoardOption {
  slug: string;
  name_th: string;
  short_name_th: string | null;
}

export default function ExamLevelCard({
  initialTarget,
  initialYear,
  initialBoardSpecialty = null,
  variant = "settings",
}: Props) {
  const [target, setTarget] = useState<ExamTarget | null>(initialTarget);
  const [year, setYear] = useState<number | null>(initialYear);
  const [boardSpecialty, setBoardSpecialty] = useState<string | null>(initialBoardSpecialty);
  const [boardOptions, setBoardOptions] = useState<BoardOption[]>([]);
  const [saving, setSaving] = useState(false);
  const [status, setStatus] = useState<"idle" | "saved" | "error">("idle");

  // Board has many specialties — load the list (public-readable) once Board is the level.
  useEffect(() => {
    if (target !== "board" || boardOptions.length > 0) return;
    let cancelled = false;
    (async () => {
      const { data } = await createClient()
        .from("board_specialties")
        .select("slug, name_th, short_name_th")
        .eq("is_active", true)
        .order("display_order", { ascending: true });
      if (!cancelled) setBoardOptions((data as BoardOption[] | null) ?? []);
    })();
    return () => {
      cancelled = true;
    };
  }, [target, boardOptions.length]);

  async function save(next: {
    target_exam?: ExamTarget;
    current_year?: number;
    board_specialty?: string;
  }) {
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

  async function pickBoardSpecialty(slug: string) {
    const prev = boardSpecialty;
    setBoardSpecialty(slug);
    if (!(await save({ board_specialty: slug }))) setBoardSpecialty(prev);
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

      {target === "board" && (
        <div className="mt-4">
          <p className="text-xs font-semibold text-ink-soft">สาขา Board ที่เตรียมสอบ</p>
          {boardOptions.length === 0 ? (
            <p className="mt-2 text-sm text-ink-soft">กำลังโหลดสาขา…</p>
          ) : (
            <div className="mt-2 flex flex-wrap gap-2" role="group" aria-label="สาขา Board">
              {boardOptions.map((b) => (
                <button
                  key={b.slug}
                  type="button"
                  disabled={saving}
                  aria-pressed={boardSpecialty === b.slug}
                  onClick={() => pickBoardSpecialty(b.slug)}
                  className={`rounded-full border px-3 py-1.5 text-sm transition-colors ${
                    boardSpecialty === b.slug
                      ? "border-brand bg-brand text-white"
                      : "border-surface-border bg-white text-ink-soft hover:border-brand"
                  }`}
                >
                  {b.short_name_th ?? b.name_th}
                </button>
              ))}
            </div>
          )}
          {!boardSpecialty && boardOptions.length > 0 && (
            <p className="mt-2 text-xs text-ink-soft">เลือกสาขา เพื่อรับข้อสอบรายวันของสาขานั้น</p>
          )}
        </div>
      )}

      {target === "meq" && (
        <p className="mt-3 text-sm text-ink-soft">
          ฝึกต่อได้ที่{" "}
          <Link href="/exams" className="font-medium text-brand hover:underline">
            คลังข้อสอบ MEQ
          </Link>{" "}
          และ{" "}
          <Link href="/longcase" className="font-medium text-brand hover:underline">
            Long Case
          </Link>
        </p>
      )}

      <p className="mt-3 min-h-5 text-xs" aria-live="polite">
        {status === "saved" && <span className="text-brand-dark">✓ บันทึกแล้ว</span>}
        {status === "error" && <span className="text-red-600">บันทึกไม่สำเร็จ ลองใหม่อีกครั้ง</span>}
      </p>
    </section>
  );
}
