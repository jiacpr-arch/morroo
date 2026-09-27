"use client";

import { useState } from "react";
import Image from "next/image";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { createClient } from "@/lib/supabase/client";
import { CATEGORIES } from "@/lib/types";
import { CheckCircle2, ChevronRight, Loader2 } from "lucide-react";

type TargetExam = "NL1" | "NL2" | "both" | "board";

const EXAM_OPTIONS: { value: TargetExam; label: string; desc: string; icon: string }[] = [
  { value: "NL1", label: "NL1", desc: "ขั้นตอนที่ 1 — ข้อสอบเนื้อหา", icon: "📝" },
  { value: "NL2", label: "NL2", desc: "ขั้นตอนที่ 2 — ข้อสอบทักษะทางคลินิก", icon: "🩺" },
  { value: "both", label: "ทั้งสอง (NL1 + NL2)", desc: "เตรียมทุกขั้นตอนพร้อมกัน", icon: "🎯" },
  { value: "board", label: "Board เฉพาะทาง", desc: "สอบวุฒิบัตรราชวิทยาลัยฯ", icon: "🎓" },
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
    try {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) { router.push("/login"); return; }

      const { error } = await supabase.from("profiles").update({
        onboarding_done: true,
        daily_goal: dailyGoal ?? 20,
        target_exam: targetExam ?? "both",
        weak_subjects: weakSubjects.length > 0 ? weakSubjects : null,
      }).eq("id", user.id);

      if (error) throw error;

      // Hard navigation so middleware reads fresh onboarding_done value.
      // Board users land on /board where the specialty grid is the right
      // first action; NL users land on /dashboard with their study plan.
      window.location.href = targetExam === "board" ? "/board" : "/dashboard";
    } catch {
      setSaving(false);
    }
  };

  const canNext = () => {
    if (step === 1) return targetExam !== null;
    if (step === 2) return dailyGoal !== null;
    return true; // step 3 optional
  };

  return (
    <div className="min-h-screen bg-surface-warm/50 px-4 py-8 sm:px-6 lg:py-12">
      <div className="mx-auto grid w-full max-w-6xl items-start gap-8 lg:grid-cols-[0.85fr_1.15fr]">
        <aside className="hidden overflow-hidden rounded-3xl border border-surface-border bg-white shadow-sm lg:block">
          <div className="relative aspect-[4/3] overflow-hidden">
            <Image
              src="/images/learning/welcome-study.webp"
              alt="ภาพประกอบนักศึกษาแพทย์วางแผนการอ่านหนังสือในห้องสมุด"
              fill
              sizes="(max-width: 1023px) 0px, 420px"
              className="object-cover"
            />
            <span className="absolute bottom-3 right-3 rounded-full bg-black/55 px-2.5 py-1 text-[10px] text-white">ภาพประกอบ</span>
          </div>
          <div className="space-y-3 p-7">
            <p className="text-sm font-semibold text-brand">เริ่มต้นในแบบของคุณ</p>
            <p className="text-2xl font-bold leading-snug text-brand-dark">เป้าหมายชัดขึ้น การอ่านหนังสือก็ง่ายขึ้น</p>
            <p className="text-sm leading-7 text-ink-soft">เลือกการสอบและเวลาที่เหมาะกับคุณ แล้ว MorRoo จะจัดพื้นที่เรียนให้ตรงกับเป้าหมาย</p>
          </div>
        </aside>
        <div className="mx-auto w-full max-w-xl lg:mx-0">
      {/* Header */}
      <div className="mb-7 rounded-3xl border border-surface-border bg-surface-warm p-6 sm:p-8">
        <p className="text-sm font-semibold text-brand-dark">ตั้งค่าการเรียน · ใช้เวลาไม่นาน</p>
        <h1 className="mt-2 text-2xl font-bold leading-snug text-brand-dark sm:text-3xl">ยินดีต้อนรับสู่ MorRoo</h1>
        <p className="mt-2 text-sm leading-7 text-ink-soft">ตอบ 3 คำถามเพื่อปรับหน้าเรียนให้เหมาะกับคุณ เปลี่ยนเป้าหมายภายหลังได้</p>
        <div className="relative mt-5 aspect-[16/10] overflow-hidden rounded-2xl lg:hidden">
          <Image
            src="/images/learning/welcome-study.webp"
            alt="ภาพประกอบนักศึกษาแพทย์วางแผนการอ่านหนังสือในห้องสมุด"
            fill
            sizes="(max-width: 639px) calc(100vw - 80px), 500px"
            className="object-cover object-[center_40%]"
          />
          <span className="absolute bottom-3 right-3 rounded-full bg-black/55 px-2.5 py-1 text-[10px] text-white">ภาพประกอบ</span>
        </div>
      </div>

      {/* Progress */}
      <div className="mb-6 w-full px-1">
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
      <Card className="w-full shadow-sm">
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
                  type="button"
                  aria-pressed={targetExam === opt.value}
                  onClick={() => setTargetExam(opt.value)}
                  className={`w-full min-h-16 text-left rounded-xl border-2 p-4 transition-all hover:border-brand hover:bg-surface-warm focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-brand ${
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
                  type="button"
                  aria-pressed={dailyGoal === g.value}
                  onClick={() => setDailyGoal(g.value)}
                  className={`w-full min-h-16 text-left rounded-xl border-2 p-4 transition-all hover:border-brand hover:bg-surface-warm focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-brand ${
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
                    type="button"
                    aria-pressed={weakSubjects.includes(cat.slug)}
                    onClick={() => toggleSubject(cat.slug)}
                    className={`min-h-20 rounded-xl border-2 p-3 text-center transition-all hover:border-brand hover:bg-surface-warm focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-brand ${
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
        type="button"
        onClick={handleFinish}
        className="mt-4 rounded-md px-2 py-2 text-sm text-ink-soft underline-offset-4 hover:text-brand-dark hover:underline focus-visible:outline-2 focus-visible:outline-brand"
        disabled={saving}
      >
        ข้ามและไปหน้าหลัก
      </button>
        </div>
      </div>
    </div>
  );
}
