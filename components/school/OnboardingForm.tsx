"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { createClient } from "@/lib/supabase/client";

interface Props {
  initialYear: number | null;
  initialGoal: number;
}

const YEARS = [1, 2, 3, 4, 5, 6] as const;
const GOAL_PRESETS = [10, 20, 30, 50] as const;

export default function OnboardingForm({ initialYear, initialGoal }: Props) {
  const router = useRouter();
  const [year, setYear] = useState<number | null>(initialYear);
  const [goal, setGoal] = useState<number>(initialGoal);
  const [saving, setSaving] = useState(false);

  async function save() {
    if (!year) return;
    setSaving(true);
    try {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return;
      await supabase
        .from("profiles")
        .update({ current_year: year, school_daily_goal: goal })
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
            จำนวนหน่วย (flashcard + quiz) ที่อยากทำให้ได้ทุกวันเพื่อสร้าง streak
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
