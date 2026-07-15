import Link from "next/link";
import type { Metadata } from "next";
import { Play, Scissors, Sparkles, Stethoscope, Trophy } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { getMyResusBests, getResusCases } from "@/lib/supabase/queries-resus";

export const metadata: Metadata = {
  title: "Operation MorRoo — เกมหัตถการเสมือนจริง",
  description:
    "หยิบเครื่องมือให้ถูก ทำตามขั้นตอนหัตถการจริง — เย็บแผล ใส่ ICD ผ่าฝี ผู้ป่วยแย่ลงจริงเมื่อพลาด เก็บ XP ขึ้น Leaderboard",
};

export const dynamic = "force-dynamic";

const DIFF_TAG_LABEL: Record<string, string> = {
  basic: "หัตถการพื้นฐาน",
  advanced: "หัตถการขั้นสูง",
};

const GRADE_STYLE: Record<string, string> = {
  S: "bg-amber-100 text-amber-700",
  A: "bg-teal-100 text-teal-700",
  B: "bg-emerald-100 text-emerald-700",
  C: "bg-rose-100 text-rose-700",
};

function Stars({ n }: { n: number }) {
  return (
    <span className="text-amber-500" aria-label={`${n} ดาว`}>
      {"★".repeat(n)}
      <span className="text-muted-foreground/40">{"★".repeat(Math.max(0, 3 - n))}</span>
    </span>
  );
}

export default async function ResusHubPage() {
  const [operations, bests] = await Promise.all([getResusCases(), getMyResusBests()]);

  return (
    <div className="mx-auto max-w-3xl px-4 py-10 sm:px-6">
      {/* Hero โทนห้องผ่าตัด */}
      <section className="relative overflow-hidden rounded-2xl bg-[#0e211b] px-6 py-10 text-center text-white sm:px-10">
        <div
          className="pointer-events-none absolute inset-0 opacity-60"
          style={{
            background:
              "radial-gradient(ellipse 130% 60% at 50% -10%, rgba(45,212,167,.3), transparent 60%), radial-gradient(ellipse 120% 60% at 50% 115%, rgba(245,192,78,.18), transparent 55%)",
          }}
        />
        <div className="relative space-y-3">
          <p className="font-mono text-[11px] uppercase tracking-[.4em] text-teal-300">
            Operation Room · On Call
          </p>
          <h1 className="text-3xl font-black sm:text-4xl">
            OPERATION <span className="text-amber-400">MORROO</span>
          </h1>
          <p className="mx-auto max-w-md text-sm leading-7 text-slate-300">
            มือคุณคือเครื่องมือ — <b className="text-white">หยิบให้ถูก ทำให้ครบขั้นตอน</b>{" "}
            หัตถการจริงที่ต้องเจอในวอร์ด พลาดเมื่อไหร่ ผู้ป่วยแย่ลงจริง
          </p>
          <div className="flex flex-wrap items-center justify-center gap-2 pt-1 text-xs text-slate-300">
            <span className="inline-flex items-center gap-1 rounded-full border border-white/20 px-3 py-1">
              <Scissors className="h-3.5 w-3.5 text-teal-300" /> ขั้นตอนอิงหัตถการจริง
            </span>
            <span className="inline-flex items-center gap-1 rounded-full border border-white/20 px-3 py-1">
              <Sparkles className="h-3.5 w-3.5 text-amber-400" /> เก็บ XP + Badge + ดาว
            </span>
            <span className="inline-flex items-center gap-1 rounded-full border border-white/20 px-3 py-1">
              <Stethoscope className="h-3.5 w-3.5 text-rose-300" /> Debrief สอนทุกขั้น
            </span>
          </div>
        </div>
      </section>

      {/* รายการด่าน */}
      <h2 className="mb-3 mt-8 text-sm font-semibold uppercase tracking-wide text-muted-foreground">
        เลือกเคสผ่าตัด
      </h2>
      <div className="space-y-4">
        {operations.map((op) => {
          const best = bests[op.slug];
          return (
            <Card key={op.slug} className="transition-shadow hover:shadow-md hover:ring-brand/30">
              <CardContent className="flex flex-col gap-4 p-5 sm:flex-row sm:items-center">
                <div className="flex-1 space-y-1.5">
                  <div className="flex flex-wrap items-center gap-2">
                    <Badge className="bg-teal-100 text-teal-700">
                      {DIFF_TAG_LABEL[op.difficultyTag ?? "basic"] ?? op.difficultyTag}
                    </Badge>
                    {best && (
                      <Badge className={GRADE_STYLE[best.grade] ?? "bg-muted"}>
                        <Trophy className="mr-1 h-3 w-3" />
                        เกรดดีสุด {best.grade} · <Stars n={best.stars} /> · เล่นแล้ว {best.runs} รอบ
                      </Badge>
                    )}
                  </div>
                  <h3 className="text-lg font-bold">{op.title}</h3>
                  <p className="text-sm text-muted-foreground">{op.subtitle}</p>
                </div>
                <Link href={`/resus/${op.slug}`} className="shrink-0">
                  <Button size="lg" className="w-full gap-2 sm:w-auto">
                    <Play className="h-4 w-4" /> เข้าห้องผ่าตัด
                  </Button>
                </Link>
              </CardContent>
            </Card>
          );
        })}
      </div>

      <p className="mt-8 text-center text-sm text-muted-foreground">
        เล่นฟรีทุกด่าน · ล็อกอินเพื่อเก็บ XP และขึ้น{" "}
        <Link href="/school/leaderboard" className="font-semibold text-brand underline">
          Leaderboard
        </Link>{" "}
        · สายกู้ชีพไปต่อที่{" "}
        <Link href="/sim" className="font-semibold text-brand underline">
          Code Blue Sim
        </Link>
      </p>
    </div>
  );
}
