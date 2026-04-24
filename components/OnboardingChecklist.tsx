"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { CheckCircle2, Circle, X, ArrowRight } from "lucide-react";
import { createClient } from "@/lib/supabase/client";

interface Props {
  userId: string;
}

interface Task {
  id: string;
  label: string;
  done: boolean;
  href: string;
  cta: string;
}

export default function OnboardingChecklist({ userId }: Props) {
  const [loading, setLoading] = useState(true);
  const [dismissed, setDismissed] = useState(false);
  const [tasks, setTasks] = useState<Task[]>([]);

  useEffect(() => {
    let cancelled = false;
    async function load() {
      const supabase = createClient();
      const [profileRes, attemptsRes] = await Promise.all([
        supabase
          .from("profiles")
          .select(
            "target_exam, weak_subjects, exam_date, line_user_id, onboarding_checklist_dismissed_at"
          )
          .eq("id", userId)
          .single(),
        supabase
          .from("mcq_attempts")
          .select("id", { count: "exact", head: true })
          .eq("user_id", userId),
      ]);

      if (cancelled) return;

      const p = profileRes.data as {
        target_exam: string | null;
        weak_subjects: string[] | null;
        exam_date: string | null;
        line_user_id: string | null;
        onboarding_checklist_dismissed_at: string | null;
      } | null;

      if (p?.onboarding_checklist_dismissed_at) {
        setDismissed(true);
        setLoading(false);
        return;
      }

      const attemptCount = attemptsRes.count ?? 0;
      setTasks([
        {
          id: "profile",
          label: "เลือกเป้าหมายสอบ (NL1 / NL2)",
          done: !!p?.target_exam,
          href: "/onboarding",
          cta: "ตั้งค่า",
        },
        {
          id: "first-attempt",
          label: "ทำข้อสอบครั้งแรก",
          done: attemptCount > 0,
          href: "/nl/practice",
          cta: "เริ่มทำ",
        },
        {
          id: "exam-date",
          label: "ตั้งวันสอบ + สร้างแผนอ่าน",
          done: !!p?.exam_date,
          href: "/study-plan",
          cta: "ตั้งวันสอบ",
        },
        {
          id: "line",
          label: "เพิ่มเพื่อน LINE เพื่อรับโจทย์ประจำวัน",
          done: !!p?.line_user_id,
          href: "https://line.me/R/ti/p/@508srmcr",
          cta: "เพิ่มเพื่อน",
        },
      ]);
      setLoading(false);
    }
    load();
    return () => {
      cancelled = true;
    };
  }, [userId]);

  async function dismiss() {
    setDismissed(true);
    const supabase = createClient();
    await supabase
      .from("profiles")
      .update({ onboarding_checklist_dismissed_at: new Date().toISOString() })
      .eq("id", userId);
  }

  if (loading || dismissed) return null;

  const done = tasks.filter((t) => t.done).length;
  const total = tasks.length;
  if (done === total) return null; // auto-hide when complete; no dismiss needed

  const pct = Math.round((done / total) * 100);

  return (
    <Card className="mb-6 border-brand/30 bg-gradient-to-br from-brand/5 to-amber-50/40">
      <CardHeader className="pb-3">
        <div className="flex items-center justify-between">
          <CardTitle className="text-base">เริ่มต้นใช้งานหมอรู้</CardTitle>
          <button
            onClick={dismiss}
            aria-label="dismiss"
            className="text-muted-foreground hover:text-foreground p-1"
          >
            <X className="h-4 w-4" />
          </button>
        </div>
        <div className="mt-2">
          <div className="flex items-center justify-between text-xs text-muted-foreground mb-1">
            <span>{done} / {total} ขั้นตอน</span>
            <span>{pct}%</span>
          </div>
          <div className="w-full bg-muted rounded-full h-2 overflow-hidden">
            <div
              className="h-2 bg-brand transition-all"
              style={{ width: `${pct}%` }}
            />
          </div>
        </div>
      </CardHeader>
      <CardContent>
        <div className="space-y-2">
          {tasks.map((task) => (
            <div
              key={task.id}
              className={`flex items-center gap-3 rounded-lg px-3 py-2 border ${
                task.done ? "bg-green-50/60 border-green-100" : "bg-white"
              }`}
            >
              {task.done ? (
                <CheckCircle2 className="h-5 w-5 text-green-600 shrink-0" />
              ) : (
                <Circle className="h-5 w-5 text-muted-foreground shrink-0" />
              )}
              <span
                className={`flex-1 text-sm ${
                  task.done ? "text-muted-foreground line-through" : "text-foreground"
                }`}
              >
                {task.label}
              </span>
              {!task.done && (
                <Link
                  href={task.href}
                  target={task.href.startsWith("http") ? "_blank" : undefined}
                  rel={task.href.startsWith("http") ? "noopener noreferrer" : undefined}
                >
                  <Button size="sm" variant="outline" className="text-xs gap-1 shrink-0">
                    {task.cta} <ArrowRight className="h-3 w-3" />
                  </Button>
                </Link>
              )}
            </div>
          ))}
        </div>
      </CardContent>
    </Card>
  );
}
