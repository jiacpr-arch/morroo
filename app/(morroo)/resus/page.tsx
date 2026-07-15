import Link from "next/link";
import type { Metadata } from "next";
import { Activity, HeartPulse, Timer, Trophy, Zap } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { getMyResusBests, getResusCases } from "@/lib/supabase/queries-resus";

export const metadata: Metadata = {
  title: "Resus Hero — เกมหัตถการกู้ชีพ ACLS",
  description:
    "ลงมือกู้ชีพเอง — ปั๊มหัวใจตามจังหวะ 110/นาที ช็อกไฟฟ้าแข่งกับเวลา ใส่ท่อ เปิด IV ให้ยา ตามลำดับ ACLS จริง เก็บ XP ขึ้น Leaderboard",
};

export const dynamic = "force-dynamic";

const DIFF_TAG_LABEL: Record<string, string> = {
  basic: "พื้นฐาน",
  intermediate: "ปานกลาง",
  advanced: "ขั้นสูง",
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
  const [cases, bests] = await Promise.all([getResusCases(), getMyResusBests()]);

  return (
    <div className="mx-auto max-w-3xl px-4 py-10 sm:px-6">
      {/* Hero โทน ER กลางดึก */}
      <section className="relative overflow-hidden rounded-2xl bg-[#0d1a24] px-6 py-10 text-center text-white sm:px-10">
        <div
          className="pointer-events-none absolute inset-0 opacity-60"
          style={{
            background:
              "radial-gradient(ellipse 130% 60% at 50% -10%, rgba(229,72,77,.35), transparent 60%), radial-gradient(ellipse 120% 60% at 50% 115%, rgba(46,204,113,.22), transparent 55%)",
          }}
        />
        <div className="relative space-y-3">
          <p className="font-mono text-[11px] uppercase tracking-[.4em] text-rose-400">
            Code · Resuscitation · Hands-On
          </p>
          <h1 className="text-3xl font-black sm:text-4xl">
            RESUS <span className="text-emerald-400">HERO</span>
          </h1>
          <p className="mx-auto max-w-md text-sm leading-7 text-slate-300">
            คุณคือคนที่ <b className="text-white">ลงมือกู้ชีพเอง</b> — ปั๊มหัวใจ ช็อกไฟฟ้า
            ใส่ท่อ เปิดเส้น ให้ยา ตามลำดับ ACLS จริง ทุกวินาทีมีความหมาย
          </p>
          <div className="flex flex-wrap items-center justify-center gap-2 pt-1 text-xs text-slate-300">
            <span className="inline-flex items-center gap-1 rounded-full border border-white/20 px-3 py-1">
              <HeartPulse className="h-3.5 w-3.5 text-rose-400" /> ปั๊มตามจังหวะ 110/นาที
            </span>
            <span className="inline-flex items-center gap-1 rounded-full border border-white/20 px-3 py-1">
              <Timer className="h-3.5 w-3.5 text-amber-400" /> ช็อกแข่งกับเวลา
            </span>
            <span className="inline-flex items-center gap-1 rounded-full border border-white/20 px-3 py-1">
              <Activity className="h-3.5 w-3.5 text-emerald-400" /> อิงแนวทาง ACLS
            </span>
          </div>
        </div>
      </section>

      {/* รายการเคส */}
      <h2 className="mb-3 mt-8 text-sm font-semibold uppercase tracking-wide text-muted-foreground">
        เลือกเคสกู้ชีพ
      </h2>
      <div className="space-y-4">
        {cases.map((op) => {
          const best = bests[op.slug];
          return (
            <Card key={op.slug} className="transition-shadow hover:shadow-md hover:ring-brand/30">
              <CardContent className="flex flex-col gap-4 p-5 sm:flex-row sm:items-center">
                <div className="flex-1 space-y-1.5">
                  <div className="flex flex-wrap items-center gap-2">
                    <Badge className="bg-rose-100 text-rose-700">
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
                    <Zap className="h-4 w-4" /> เริ่มกู้ชีพ
                  </Button>
                </Link>
              </CardContent>
            </Card>
          );
        })}
      </div>

      <p className="mt-8 text-center text-sm text-muted-foreground">
        เล่นฟรีทุกเคส · ล็อกอินเพื่อเก็บ XP และขึ้น{" "}
        <Link href="/school/leaderboard" className="font-semibold text-brand underline">
          Leaderboard
        </Link>{" "}
        · อยากฝึกเป็น Team Leader สั่งการ ลอง{" "}
        <Link href="/sim" className="font-semibold text-brand underline">
          Code Blue Sim
        </Link>{" "}
        · ทบทวนเนื้อหาที่{" "}
        <Link href="/acls-reader" className="font-semibold text-brand underline">
          คู่มือ ACLS
        </Link>
      </p>
    </div>
  );
}
