/**
 * อ่านรอบสอบ ศรว. จากตาราง exam_rounds (แก้ได้ที่ /admin/exam-dates และอัปเดตเองจาก cron exam-watch)
 * ถ้าอ่านฐานข้อมูลไม่ได้หรือยังว่าง → ใช้ค่าสำรองจาก lib/exam-dates.ts เพื่อไม่ให้ปฏิทินว่าง
 */

import type { SupabaseClient } from "@supabase/supabase-js";
import { NL_EXAM_ROUNDS, type ExamRound } from "@/lib/exam-dates";
import { ROUND_KINDS } from "@/lib/exam-round-extract";
import type { ExamKind } from "@/lib/exam-level";

interface RoundRow {
  kind: string;
  label: string;
  exam_date: string;
  confirmed: boolean;
}

export function rowsToRounds(rows: readonly RoundRow[]): ExamRound[] {
  return rows
    .filter((r) => ROUND_KINDS.includes(r.kind as ExamKind) && /^\d{4}-\d{2}-\d{2}$/.test(r.exam_date))
    .map((r) => ({ kind: r.kind as ExamKind, label: r.label, date: r.exam_date, confirmed: !!r.confirmed }))
    .sort((a, b) => a.date.localeCompare(b.date));
}

export async function loadExamRounds(db: SupabaseClient): Promise<ExamRound[]> {
  try {
    const { data, error } = await db
      .from("exam_rounds")
      .select("kind, label, exam_date, confirmed")
      .eq("is_active", true)
      .order("exam_date", { ascending: true });
    if (error) throw error;
    const rounds = rowsToRounds((data as RoundRow[] | null) ?? []);
    return rounds.length > 0 ? rounds : NL_EXAM_ROUNDS;
  } catch (err) {
    console.error("[exam-rounds] falling back to static rounds:", err);
    return NL_EXAM_ROUNDS;
  }
}
