"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { createClient } from "@/lib/supabase/client";
import { CATEGORIES } from "@/lib/types";
import { CheckCircle2, ChevronRight, Loader2 } from "lucide-react";

type TargetExam = "NL1" | "NL2" | "both";

const EXAM_OPTIONS: { value: TargetExam; label: string; desc: string; icon: string }[] = [
  { value: "NL1", label: "NL1", desc: "ขั้นตอนที่ 1 — ข้อสอบเนื้อหา", icon: "📝" },
  { value: "NL2", label: "NL2", desc: "ขั้นตอนที่ 2 — ข้อสอบทักษะทางคลินิก", icon: "🩺" },
  { value: "both", label: "ทั้งสอง", desc: "เตรียมทุกขั้นตอนพร้อมกัน", icon: "🎯" },
];

const DAILY_GOALS = [
  { value: 10, label: "10 ข้อ", desc: "เบาๆ สบายๆ", icon: "🌱" },
  { value: 20, label: "20 ข้อ", desc: "พอดีๆ สม่ำเสมอ", icon: "🔥" },
  { value: 30, label: "30 ข้อ", desc: "จริงจัง เข้มข้น", icon: "💪" },
];

const TOTAL_STEPS = 3;

export default function OnboardingPage() {
  const router = useRouter();
  const [step, setStep] = useState(1);
  const [targetExam, setTargetExam] = useState<TargetExam | null>(null);
  const [dailyGoal, setDailyGoal] = useState<number | null>(null);
  const [weakSubjects, setWeakSubjects] = useState<string[]>([]);
  const [saving, setSaving] = useState(false);

  const toggleSubject = (slug: string) => {
    setWeakSubjects((prev) =>
      prev.includes(slug) ? prev.filter((s) => s !== slug) : [...prev, slug]
    );
  };

  const handleFinish = async () => {
    setSaving(true);
    const supabase = createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) { router.push("/login"); return; }

    await supabase.from("profiles").update({
      onboarding_done: true,
      daily_goal: dailyGoal ?? 20,
      target_exam: targetExam ?? "both",
      weak_subjects: weakSubjects.length > 0 ? weakSubjects : null,
    }).eq("id", user.id);

    router.push("/dashboard");
  };

  const canNext = () => {
    if (step === 1) return targetExam !== null;
    if (step === 2) return dailyGoal !== null;
    return true; // step 3 optional
  };

  return (
    <div className="min-h-screen flex flex-col items-center justify-center px-4 py-12 bg-gradient-to-b from-brand/5 to-background">
      {/* Header */}
      <div className="mb-8 text-center">
        <div className="text-4xl mb-3">🩺</div>
        <h1 className="text-2xl font-bold">ยินดีต้อนรับสู่ MorRoo</h1>
        <p className="text-muted-foreground mt-1">ตอบ 3 คำถามเพื่อปรับ dashboard ให้เหมาะกับคุณ</p>
      </div>

      {/* Progress */}
      <div className="w-full max-w-md mb-6">
        <div className="flex items-center justify-between mb-2">
          {Array.from({ length: TOTAL_STEPS }).map((_, i) => (
            <div key={i} className="flex items-center flex-1">
              <div
                className={`h-8 w-8 rounded-full flex items-center justify-center text-sm font-semibold transition-colors ${
                  i + 1 < step
                    ? "bg-brand text-white"
                    : i + 1 === step
                    ? "bg-brand text-white ring-4 ring-brand/20"
                    : "bg-muted text-muted-foreground"
                }`}
              >
                {i + 1 < step ? <CheckCircle2 className="h-4 w-4" /> : i + 1}
              </div>
              {i < TOTAL_STEPS - 1 && (
                <div
                  className={`flex-1 h-1 mx-2 rounded-full transition-colors ${
                    i + 1 < step ? "bg-brand" : "bg-muted"
                  }`}
                />
              )}
            </div>
          ))}
        </div>
        <p className="text-xs text-muted-foreground text-center">ขั้นตอนที่ {step} จาก {TOTAL_STEPS}</p>
      </div>

      {/* Card */}
      <Card className="w-full max-w-md">
        {/* Step 1 — Target Exam */}
        {step === 1 && (
          <>
            <CardHeader className="pb-2">
              <h2 className="text-lg font-semibold">คุณเตรียมสอบอะไร?</h2>
              <p className="text-sm text-muted-foreground">เลือกประเภทการสอบที่คุณกำลังเตรียม</p>
            </CardHeader>
            <CardContent className="space-y-3">
              {EXAM_OPTIONS.map((opt) => (
                <button
                  key={opt.value}
                  onClick={() => setTargetExam(opt.value)}
                  className={`w-full text-left rounded-xl border-2 p-4 transition-all hover:border-brand hover:bg-brand/5 ${
                    targetExam === opt.value
                      ? "border-brand bg-brand/10"
                      : "border-border"
                  }`}
                >
                  <div className="flex items-center gap-3">
                    <span className="text-2xl">{opt.icon}</span>
                    <div>
                      <p className="font-semibold">{opt.label}</p>
                      <p className="text-sm text-muted-foreground">{opt.desc}</p>
                    </div>
                    {targetExam === opt.value && (
                      <CheckCircle2 className="h-5 w-5 text-brand ml-auto" />
                    )}
                  </div>
                </button>
              ))}
            </CardContent>
          </>
        )}

        {/* Step 2 — Daily Goal */}
        {step === 2 && (
          <>
            <CardHeader className="pb-2">
              <h2 className="text-lg font-semibold">เป้าหมายต่อวัน?</h2>
              <p className="text-sm text-muted-foreground">จะทำกี่ข้อต่อวัน — ทำสม่ำเสมอดีกว่าทำทีเดียวเยอะ</p>
            </CardHeader>
            <CardContent className="space-y-3">
              {DAILY_GOALS.map((g) => (
                <button
                  key={g.value}
                  onClick={() => setDailyGoal(g.value)}
                  className={`w-full text-left rounded-xl border-2 p-4 transition-all hover:border-brand hover:bg-brand/5 ${
                    dailyGoal === g.value
                      ? "border-brand bg-brand/10"
                      : "border-border"
                  }`}
                >
                  <div className="flex items-center gap-3">
                    <span className="text-2xl">{g.icon}</span>
                    <div>
                      <p className="font-semibold">{g.label}</p>
                      <p className="text-sm text-muted-foreground">{g.desc}</p>
                    </div>
                    {dailyGoal === g.value && (
                      <CheckCircle2 className="h-5 w-5 text-brand ml-auto" />
                    )}
                  </div>
                </button>
              ))}
            </CardContent>
          </>
        )}

        {/* Step 3 — Weak Subjects */}
        {step === 3 && (
          <>
            <CardHeader className="pb-2">
              <h2 className="text-lg font-semibold">สาขาที่รู้สึกอ่อน?</h2>
              <p className="text-sm text-muted-foreground">เลือกได้หลายสาขา — ข้ามได้ถ้าไม่แน่ใจ</p>
            </CardHeader>
            <CardContent>
              <div className="grid grid-cols-2 gap-3">
                {CATEGORIES.map((cat) => (
                  <button
                    key={cat.slug}
                    onClick={() => toggleSubject(cat.slug)}
                    className={`rounded-xl border-2 p-3 text-center transition-all hover:border-brand hover:bg-brand/5 ${
                      weakSubjects.includes(cat.slug)
                        ? "border-brand bg-brand/10"
                        : "border-border"
                    }`}
                  >
                    <div className="text-2xl mb-1">{cat.icon}</div>
                    <p className="text-xs font-medium leading-tight">{cat.name}</p>
                    {weakSubjects.includes(cat.slug) && (
                      <CheckCircle2 className="h-4 w-4 text-brand mx-auto mt-1" />
                    )}
                  </button>
                ))}
              </div>
            </CardContent>
          </>
        )}

        {/* Footer */}
        <div className="px-6 pb-6 flex gap-3">
          {step > 1 && (
            <Button
              variant="outline"
              className="flex-1"
              onClick={() => setStep((s) => s - 1)}
              disabled={saving}
            >
              ย้อนกลับ
            </Button>
          )}
          {step < TOTAL_STEPS ? (
            <Button
              className="flex-1 bg-brand hover:bg-brand-light text-white"
              onClick={() => setStep((s) => s + 1)}
              disabled={!canNext()}
            >
              ถัดไป <ChevronRight className="h-4 w-4 ml-1" />
            </Button>
          ) : (
            <Button
              className="flex-1 bg-brand hover:bg-brand-light text-white"
              onClick={handleFinish}
              disabled={saving}
            >
              {saving ? (
                <><Loader2 className="h-4 w-4 mr-2 animate-spin" />กำลังบันทึก...</>
              ) : (
                "เริ่มเลย!"
              )}
            </Button>
          )}
        </div>
      </Card>

      {/* Skip */}
      <button
        onClick={handleFinish}
        className="mt-4 text-sm text-muted-foreground hover:text-foreground underline-offset-4 hover:underline"
        disabled={saving}
      >
        ข้ามและไปหน้าหลัก
      </button>
    </div>
  );
}
