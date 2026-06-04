"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Check } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { SPECIALTIES } from "@/lib/school/specialty";

interface Props {
  systems: { slug: string; name_th: string; icon: string }[];
  initialInterests: Record<string, number> | null;
  initialTarget: string | null;
}

const RATINGS = [1, 2, 3, 4, 5] as const;

export default function SpecialtyExplorer({
  systems,
  initialInterests,
  initialTarget,
}: Props) {
  const router = useRouter();
  const [interests, setInterests] = useState<Record<string, number>>(() => {
    const base: Record<string, number> = {};
    for (const s of systems) base[s.slug] = initialInterests?.[s.slug] ?? 3;
    return base;
  });
  const [target, setTarget] = useState<string | null>(initialTarget);
  const [saving, setSaving] = useState(false);
  const [savedMsg, setSavedMsg] = useState(false);

  function setRating(slug: string, value: number) {
    setInterests((cur) => ({ ...cur, [slug]: value }));
  }

  async function save() {
    setSaving(true);
    setSavedMsg(false);
    try {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return;
      await supabase
        .from("profiles")
        .update({
          specialty_interests: interests,
          target_specialty: target,
        })
        .eq("id", user.id);
      setSavedMsg(true);
      router.refresh();
    } finally {
      setSaving(false);
    }
  }

  return (
    <div className="space-y-6">
      {/* Interest questionnaire */}
      <Card>
        <CardContent className="p-5 space-y-4">
          <div>
            <h2 className="font-semibold">คุณสนใจระบบไหนเป็นพิเศษ?</h2>
            <p className="text-xs text-muted-foreground mt-0.5">
              ให้คะแนน 1 (เฉยๆ) ถึง 5 (ชอบมาก) — ใช้ผสมกับผลเรียนจริงเพื่อแนะนำสาย
            </p>
          </div>
          <div className="space-y-2">
            {systems.map((s) => (
              <div
                key={s.slug}
                className="flex items-center justify-between gap-3 border-b pb-2 last:border-0"
              >
                <span className="text-sm flex items-center gap-1.5 min-w-0">
                  <span>{s.icon}</span>
                  <span className="truncate">{s.name_th}</span>
                </span>
                <div className="flex gap-1 shrink-0">
                  {RATINGS.map((r) => (
                    <button
                      key={r}
                      onClick={() => setRating(s.slug, r)}
                      aria-label={`${s.name_th} ${r}`}
                      className={`h-7 w-7 rounded-md border text-xs font-medium transition-colors ${
                        interests[s.slug] === r
                          ? "border-brand bg-brand/10 text-brand"
                          : "border-muted hover:border-brand/30"
                      }`}
                    >
                      {r}
                    </button>
                  ))}
                </div>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>

      {/* Target specialty picker */}
      <Card>
        <CardContent className="p-5 space-y-3">
          <div>
            <h2 className="font-semibold">เลือกอาชีพในฝัน (เป้าหมาย)</h2>
            <p className="text-xs text-muted-foreground mt-0.5">
              ระบบจะโชว์ว่าต้องเก่งวิชาไหนเพื่อไปสายนี้ และวิชาที่ควรเน้นเพิ่ม
            </p>
          </div>
          <div className="grid grid-cols-2 sm:grid-cols-3 gap-2">
            {SPECIALTIES.map((sp) => {
              const on = target === sp.id;
              return (
                <button
                  key={sp.id}
                  onClick={() => setTarget(on ? null : sp.id)}
                  className={`relative rounded-lg border-2 p-3 text-left transition-colors ${
                    on
                      ? "border-teal-500 bg-teal-50"
                      : "border-muted hover:border-teal-300"
                  }`}
                >
                  {on && (
                    <Check className="absolute right-2 top-2 h-4 w-4 text-teal-600" />
                  )}
                  <span className="text-xl block">{sp.icon}</span>
                  <span className="text-sm font-medium block mt-1">{sp.name_th}</span>
                  <span className="text-[11px] text-muted-foreground block">
                    {sp.name_en}
                  </span>
                </button>
              );
            })}
          </div>
        </CardContent>
      </Card>

      <div className="flex items-center gap-3">
        <Button onClick={save} disabled={saving} className="flex-1">
          {saving ? "กำลังบันทึก…" : "บันทึก แล้วดูผล"}
        </Button>
        {savedMsg && (
          <Badge className="bg-emerald-100 text-emerald-700">บันทึกแล้ว ✓</Badge>
        )}
      </div>
    </div>
  );
}
