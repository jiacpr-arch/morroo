"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Plus, Trash2, CalendarDays } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import type { ExamScheduleItem } from "@/lib/types";

interface Props {
  initialYear: number | null;
  initialGoal: number;
  initialExamDate?: string | null;
  initialExamSchedule?: ExamScheduleItem[] | null;
  systems: { id: string; name_th: string; icon: string }[];
  initialWeakSubjects?: string[];
}

// Build the starting schedule list. Prefer the new exam_schedule; otherwise
// migrate a legacy single exam_date into a one-row schedule (no topic yet).
function buildInitialSchedule(
  schedule: ExamScheduleItem[] | null | undefined,
  legacyDate: string | null | undefined
): ExamScheduleItem[] {
  if (schedule && schedule.length) {
    return schedule.map((e) => ({ topic: e.topic ?? "", date: e.date?.slice(0, 10) ?? "" }));
  }
  if (legacyDate) return [{ topic: "", date: legacyDate.slice(0, 10) }];
  return [];
}

// Thai-friendly long date label, e.g. "15 ก.ค. 2026".
function formatThaiDate(iso: string): string {
  const d = new Date(iso + "T00:00:00");
  if (Number.isNaN(d.getTime())) return iso;
  return d.toLocaleDateString("th-TH", {
    day: "numeric",
    month: "short",
    year: "numeric",
  });
}

const YEARS = [1, 2, 3, 4, 5, 6] as const;
const GOAL_PRESETS = [10, 20, 30, 50] as const;

export default function OnboardingForm({
  initialYear,
  initialGoal,
  initialExamDate,
  initialExamSchedule,
  systems,
  initialWeakSubjects = [],
}: Props) {
  const router = useRouter();
  const [year, setYear] = useState<number | null>(initialYear);
  const [goal, setGoal] = useState<number>(initialGoal);
  const [exams, setExams] = useState<ExamScheduleItem[]>(() =>
    buildInitialSchedule(initialExamSchedule, initialExamDate)
  );
  const [weak, setWeak] = useState<string[]>(initialWeakSubjects);
  const [saving, setSaving] = useState(false);

  function toggleWeak(slug: string) {
    setWeak((cur) =>
      cur.includes(slug) ? cur.filter((s) => s !== slug) : [...cur, slug]
    );
  }

  function addExam() {
    setExams((cur) => [...cur, { topic: "", date: "" }]);
  }

  function updateExam(index: number, patch: Partial<ExamScheduleItem>) {
    setExams((cur) =>
      cur.map((e, i) => (i === index ? { ...e, ...patch } : e))
    );
  }

  function removeExam(index: number) {
    setExams((cur) => cur.filter((_, i) => i !== index));
  }

  async function save() {
    if (!year) return;
    setSaving(true);
    try {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return;

      // Keep only fully-filled rows, sorted by date.
      const schedule = exams
        .filter((e) => e.date && e.topic.trim())
        .map((e) => ({ topic: e.topic.trim(), date: e.date }))
        .sort((a, b) => a.date.localeCompare(b.date));

      // Sync legacy exam_date to the nearest upcoming exam (today or later) so
      // study-plan generation keeps working; fall back to the earliest entry.
      const today = new Date().toISOString().slice(0, 10);
      const nearest =
        schedule.find((e) => e.date >= today)?.date ??
        schedule[0]?.date ??
        null;

      await supabase
        .from("profiles")
        .update({
          current_year: year,
          school_daily_goal: goal,
          weak_subjects: weak.length ? weak : null,
          exam_schedule: schedule.length ? schedule : null,
          exam_date: nearest,
        })
        .eq("id", user.id);
      router.push("/school");
      router.refresh();
    } finally {
      setSaving(false);
    }
  }

  return (
    <div className="space-y-6">
      <Card>
        <CardContent className="p-5 space-y-3">
          <h2 className="font-semibold">คุณอยู่ชั้นปีไหน?</h2>
          <div className="grid grid-cols-3 sm:grid-cols-6 gap-2">
            {YEARS.map((y) => (
              <button
                key={y}
                onClick={() => setYear(y)}
                className={`rounded-lg border-2 p-3 text-center font-semibold transition-colors ${
                  year === y
                    ? "border-brand bg-brand/10 text-brand"
                    : "border-muted hover:border-brand/30"
                }`}
              >
                Y{y}
              </button>
            ))}
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardContent className="p-5 space-y-3">
          <h2 className="font-semibold">เป้าหมายรายวัน</h2>
          <p className="text-xs text-muted-foreground">
            จำนวนหน่วยที่อยากทำให้ได้ทุกวันเพื่อสร้าง streak
          </p>
          <div className="grid grid-cols-4 gap-2">
            {GOAL_PRESETS.map((g) => (
              <button
                key={g}
                onClick={() => setGoal(g)}
                className={`rounded-lg border-2 p-3 text-center font-semibold transition-colors ${
                  goal === g
                    ? "border-brand bg-brand/10 text-brand"
                    : "border-muted hover:border-brand/30"
                }`}
              >
                {g}
              </button>
            ))}
          </div>
          <div className="flex items-center gap-2 mt-2">
            <Badge variant="outline">{goal} หน่วย/วัน</Badge>
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardContent className="p-5 space-y-3">
          <h2 className="font-semibold flex items-center gap-2">
            <CalendarDays className="h-5 w-5 text-brand" /> ตารางสอบ (optional)
          </h2>
          <p className="text-xs text-muted-foreground">
            ใส่ว่าสอบหัวข้ออะไร วันไหน — ใช้คำนวณว่าควรเร่งทบทวนหัวข้อไหนก่อน
          </p>

          {exams.length === 0 ? (
            <p className="text-sm text-muted-foreground italic">
              ยังไม่มีวันสอบ — กดปุ่มด้านล่างเพื่อเพิ่ม
            </p>
          ) : (
            <div className="space-y-3">
              {exams.map((exam, i) => (
                <div
                  key={i}
                  className="rounded-lg border bg-muted/30 p-3 space-y-2"
                >
                  <div className="flex items-start gap-2">
                    <div className="flex-1 space-y-2">
                      <input
                        type="text"
                        value={exam.topic}
                        onChange={(e) =>
                          updateExam(i, { topic: e.target.value })
                        }
                        placeholder="สอบหัวข้ออะไร เช่น ระบบหัวใจและหลอดเลือด"
                        className="w-full border rounded-md p-2 text-sm"
                      />
                      <input
                        type="date"
                        value={exam.date}
                        onChange={(e) =>
                          updateExam(i, { date: e.target.value })
                        }
                        className="w-full border rounded-md p-2 text-sm"
                      />
                      {exam.date && (
                        <p className="text-xs text-brand">
                          📅 {formatThaiDate(exam.date)}
                        </p>
                      )}
                    </div>
                    <button
                      type="button"
                      onClick={() => removeExam(i)}
                      aria-label="ลบวันสอบ"
                      className="shrink-0 rounded-md p-2 text-muted-foreground hover:bg-rose-50 hover:text-rose-600 transition-colors"
                    >
                      <Trash2 className="h-4 w-4" />
                    </button>
                  </div>
                </div>
              ))}
            </div>
          )}

          <Button
            type="button"
            variant="outline"
            size="sm"
            onClick={addExam}
            className="gap-2"
          >
            <Plus className="h-4 w-4" /> เพิ่มวันสอบ
          </Button>
        </CardContent>
      </Card>

      <Card>
        <CardContent className="p-5 space-y-3">
          <h2 className="font-semibold">ระบบที่คุณไม่ถนัด (optional)</h2>
          <p className="text-xs text-muted-foreground">
            ระบบเหล่านี้จะถูกหยิบมา quiz บ่อยกว่าใน Daily/Mixed mode
          </p>
          <div className="grid grid-cols-2 sm:grid-cols-3 gap-2">
            {systems.map((s) => {
              const on = weak.includes(s.id);
              return (
                <button
                  key={s.id}
                  onClick={() => toggleWeak(s.id)}
                  className={`rounded-lg border-2 p-2 text-center text-sm transition-colors ${
                    on
                      ? "border-rose-400 bg-rose-50 text-rose-700"
                      : "border-muted hover:border-rose-300"
                  }`}
                >
                  <span className="mr-1">{s.icon}</span>
                  {s.name_th}
                </button>
              );
            })}
          </div>
        </CardContent>
      </Card>

      <Button
        onClick={save}
        disabled={!year || saving}
        className="w-full"
      >
        {saving ? "กำลังบันทึก…" : "บันทึก แล้วเริ่ม"}
      </Button>
    </div>
  );
}
