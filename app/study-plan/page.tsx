"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Loader2, Sparkles, Calendar, ArrowLeft, RefreshCw } from "lucide-react";
import type { StudyPlan } from "@/lib/types-study-plan";

export default function StudyPlanPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [generating, setGenerating] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [examDate, setExamDate] = useState<string>("");
  const [dailyHours, setDailyHours] = useState<number>(2);
  const [plan, setPlan] = useState<StudyPlan | null>(null);
  const [generatedAt, setGeneratedAt] = useState<string | null>(null);

  useEffect(() => {
    async function init() {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) {
        router.push("/login");
        return;
      }
      const { data: profile } = await supabase
        .from("profiles")
        .select("exam_date, study_plan, study_plan_generated_at")
        .eq("id", user.id)
        .single();
      const p = profile as {
        exam_date: string | null;
        study_plan: StudyPlan | null;
        study_plan_generated_at: string | null;
      } | null;
      if (p?.exam_date) setExamDate(p.exam_date);
      if (p?.study_plan) setPlan(p.study_plan);
      if (p?.study_plan_generated_at) setGeneratedAt(p.study_plan_generated_at);
      setLoading(false);
    }
    init();
  }, [router]);

  async function generate() {
    setError(null);
    setGenerating(true);
    try {
      const res = await fetch("/api/study-plan/generate", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ daily_hours: dailyHours, exam_date: examDate || undefined }),
      });
      const json = await res.json();
      if (!res.ok) {
        setError(json.error ?? "Failed to generate plan");
      } else {
        setPlan(json.plan as StudyPlan);
        setGeneratedAt(json.plan.generated_at);
      }
    } catch {
      setError("เกิดข้อผิดพลาด ลองใหม่อีกครั้ง");
    }
    setGenerating(false);
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <Loader2 className="h-8 w-8 animate-spin text-brand" />
      </div>
    );
  }

  const daysUntil = examDate
    ? Math.ceil((new Date(examDate).getTime() - Date.now()) / 86400000)
    : null;

  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="mb-6">
        <Link
          href="/dashboard"
          className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-brand mb-4"
        >
          <ArrowLeft className="h-4 w-4" /> กลับ Dashboard
        </Link>
        <h1 className="text-2xl font-bold flex items-center gap-2">
          <Sparkles className="h-6 w-6 text-brand" />
          แผนอ่านหนังสือของคุณ
        </h1>
        <p className="text-muted-foreground text-sm mt-1">
          AI วางแผนรายสัปดาห์ตามวันสอบและจุดอ่อนของคุณ
        </p>
      </div>

      {/* Settings */}
      <Card className="mb-6">
        <CardHeader>
          <CardTitle className="text-base">ตั้งค่า</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div>
            <label className="block text-sm font-medium mb-1">วันสอบ</label>
            <div className="flex items-center gap-2">
              <Calendar className="h-4 w-4 text-muted-foreground" />
              <input
                type="date"
                value={examDate}
                onChange={(e) => setExamDate(e.target.value)}
                className="border rounded px-3 py-2 text-sm"
              />
              {daysUntil != null && daysUntil > 0 && (
                <span className="text-sm text-muted-foreground">
                  อีก {daysUntil} วัน
                </span>
              )}
            </div>
          </div>
          <div>
            <label className="block text-sm font-medium mb-1">
              เวลาอ่านหนังสือต่อวัน: {dailyHours} ชั่วโมง
            </label>
            <input
              type="range"
              min={1}
              max={8}
              value={dailyHours}
              onChange={(e) => setDailyHours(Number(e.target.value))}
              className="w-full"
            />
          </div>
          <Button
            onClick={generate}
            disabled={generating || !examDate}
            className="bg-brand hover:bg-brand-light text-white gap-2"
          >
            {generating ? (
              <>
                <Loader2 className="h-4 w-4 animate-spin" /> กำลังสร้างแผน...
              </>
            ) : plan ? (
              <>
                <RefreshCw className="h-4 w-4" /> สร้างแผนใหม่
              </>
            ) : (
              <>
                <Sparkles className="h-4 w-4" /> สร้างแผน
              </>
            )}
          </Button>
          {error && <p className="text-sm text-red-600">{error}</p>}
        </CardContent>
      </Card>

      {/* Plan */}
      {plan && (
        <>
          {generatedAt && (
            <p className="text-xs text-muted-foreground mb-4">
              สร้างเมื่อ{" "}
              {new Date(generatedAt).toLocaleDateString("th-TH", {
                day: "numeric",
                month: "short",
                year: "2-digit",
                hour: "2-digit",
                minute: "2-digit",
              })}
            </p>
          )}
          {plan.advice && (
            <Card className="mb-6 border-brand/30 bg-brand/5">
              <CardContent className="py-4">
                <p className="text-sm text-gray-700">{plan.advice}</p>
              </CardContent>
            </Card>
          )}
          <div className="space-y-4">
            {plan.weeks.map((week) => (
              <Card key={week.week_number}>
                <CardHeader className="pb-3">
                  <div className="flex items-center justify-between">
                    <CardTitle className="text-base">
                      สัปดาห์ที่ {week.week_number}
                    </CardTitle>
                    <span className="text-xs text-muted-foreground">
                      {week.start_date}
                    </span>
                  </div>
                  <p className="text-sm text-brand font-medium">{week.focus}</p>
                </CardHeader>
                <CardContent>
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    {week.daily_tasks.map((day, i) => (
                      <div key={i} className="rounded-lg border p-3 bg-muted/20">
                        <p className="text-sm font-semibold mb-2">{day.day}</p>
                        <ul className="text-sm text-gray-700 space-y-1">
                          {day.tasks.map((task, j) => (
                            <li key={j} className="flex gap-2">
                              <span className="text-brand shrink-0">•</span>
                              <span>{task}</span>
                            </li>
                          ))}
                        </ul>
                      </div>
                    ))}
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        </>
      )}
    </div>
  );
}
