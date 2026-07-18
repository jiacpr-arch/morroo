import Link from "next/link";
import type { Metadata } from "next";
import { BookOpen, Play, Sparkles, Stethoscope, Trophy, Zap } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import {
  getLongcaseGameCards,
  getMySimBests,
  getSimScenariosByCategory,
  type SimBest,
} from "@/lib/supabase/queries-sim";

export const metadata: Metadata = {
  title: "เกมเคส — Long Case Decision Game",
  description:
    "เล่นเคสผู้ป่วยแบบเกมตัดสินใจ ซักประวัติ ตรวจร่างกาย สั่งแลป วินิจฉัยและรักษาภายใต้เวลากดดัน อิงจาก Long Case จริงทุกเคส เก็บ XP ขึ้น Leaderboard",
  alternates: { canonical: "https://www.morroo.com/casegame" },
};

export const dynamic = "force-dynamic";

const GRADE_STYLE: Record<string, string> = {
  S: "bg-amber-100 text-amber-700",
  A: "bg-teal-100 text-teal-700",
  B: "bg-emerald-100 text-emerald-700",
  C: "bg-rose-100 text-rose-700",
};

const SPECIALTY_COLOR: Record<string, string> = {
  Medicine: "bg-blue-100 text-blue-700",
  Surgery: "bg-red-100 text-red-700",
  Obstetrics: "bg-pink-100 text-pink-700",
  Pediatrics: "bg-green-100 text-green-700",
  Emergency: "bg-orange-100 text-orange-700",
  Cardiology: "bg-rose-100 text-rose-700",
  Neurology: "bg-purple-100 text-purple-700",
  Orthopedics: "bg-amber-100 text-amber-700",
};

function BestBadge({ best }: { best?: SimBest }) {
  if (!best) return null;
  return (
    <Badge className={GRADE_STYLE[best.grade] ?? "bg-muted"}>
      <Trophy className="mr-1 h-3 w-3" />
      เกรดดีสุด {best.grade}
    </Badge>
  );
}

export default async function CaseGameHubPage() {
  const [polished, cards, bests] = await Promise.all([
    getSimScenariosByCategory("longcase"),
    getLongcaseGameCards(),
    getMySimBests(),
  ]);

  const total = polished.length + cards.length;

  return (
    <div className="mx-auto max-w-4xl px-4 py-10 sm:px-6">
      {/* Hero โทน ward (amber/teal) */}
      <section className="relative overflow-hidden rounded-2xl bg-[#132320] px-6 py-10 text-center text-white sm:px-10">
        <div
          className="pointer-events-none absolute inset-0 opacity-60"
          style={{
            background:
              "radial-gradient(ellipse 130% 60% at 50% -10%, rgba(217,138,43,.35), transparent 60%), radial-gradient(ellipse 120% 60% at 50% 115%, rgba(26,188,156,.28), transparent 55%)",
          }}
        />
        <div className="relative space-y-3">
          <p className="font-mono text-[11px] uppercase tracking-[.4em] text-amber-400">
            Long Case · Ward Round
          </p>
          <h1 className="text-3xl font-black sm:text-4xl">
            เกม<span className="text-amber-400">เคส</span>
          </h1>
          <p className="mx-auto max-w-md text-sm leading-7 text-slate-300">
            คุณคือ <b className="text-white">แพทย์เจ้าของไข้</b> — ซักประวัติ ตรวจร่างกาย
            สั่งแลป วินิจฉัยและรักษา ทุกการตัดสินใจมีผลต่อผู้ป่วยจริง
          </p>
          <div className="flex flex-wrap items-center justify-center gap-2 pt-1 text-xs text-slate-300">
            <span className="inline-flex items-center gap-1 rounded-full border border-white/20 px-3 py-1">
              <Stethoscope className="h-3.5 w-3.5 text-teal-400" /> อิงจาก Long Case จริงทุกเคส
            </span>
            <span className="inline-flex items-center gap-1 rounded-full border border-white/20 px-3 py-1">
              <Zap className="h-3.5 w-3.5 text-amber-400" /> เก็บ XP + Badge
            </span>
          </div>
        </div>
      </section>

      {total === 0 ? (
        <div className="mt-8 rounded-xl border bg-white py-16 text-center text-muted-foreground">
          <BookOpen className="mx-auto mb-3 h-12 w-12 opacity-30" />
          <p>กำลังเพิ่มเกมเคสใหม่ เร็วๆ นี้</p>
        </div>
      ) : (
        <>
          {/* เกมเคสที่คัดมือ/ขัดเงาแล้ว (built-in + DB) */}
          {polished.length > 0 && (
            <>
              <h2 className="mb-3 mt-8 flex items-center gap-1.5 text-sm font-semibold uppercase tracking-wide text-muted-foreground">
                <Sparkles className="h-4 w-4 text-amber-500" /> เคสแนะนำ
              </h2>
              <div className="space-y-4">
                {polished.map((s) => (
                  <Card key={s.slug} className="transition-shadow hover:shadow-md hover:ring-brand/30">
                    <CardContent className="flex flex-col gap-4 p-5 sm:flex-row sm:items-center">
                      <div className="flex-1 space-y-1.5">
                        <div className="flex flex-wrap items-center gap-2">
                          <Badge className="bg-amber-100 text-amber-700">เคสแนะนำ</Badge>
                          <BestBadge best={bests[s.slug]} />
                        </div>
                        <h3 className="text-lg font-bold">{s.title.replace(/^LONG CASE:\s*/, "")}</h3>
                        <p className="text-sm text-muted-foreground">{s.subtitle}</p>
                      </div>
                      <Link href={`/sim/${s.slug}`} className="shrink-0">
                        <Button size="lg" className="w-full gap-2 sm:w-auto">
                          <Play className="h-4 w-4" /> รับเคส
                        </Button>
                      </Link>
                    </CardContent>
                  </Card>
                ))}
              </div>
            </>
          )}

          {/* เคสทั้งหมด (สังเคราะห์จาก long_cases) */}
          {cards.length > 0 && (
            <>
              <h2 className="mb-3 mt-8 text-sm font-semibold uppercase tracking-wide text-muted-foreground">
                เคสทั้งหมด · {total} เคส
              </h2>
              <div className="grid gap-3 sm:grid-cols-2">
                {cards.map((c) => (
                  <Link
                    key={c.slug}
                    href={`/sim/${c.slug}`}
                    className="group rounded-xl border bg-white p-4 transition-shadow hover:shadow-md"
                  >
                    <div className="mb-2 flex flex-wrap items-center gap-1.5">
                      <span
                        className={`rounded-full px-2 py-0.5 text-xs font-medium ${SPECIALTY_COLOR[c.specialty] ?? "bg-gray-100 text-gray-700"}`}
                      >
                        {c.specialty || "เคส"}
                      </span>
                      {c.audience === "board" && (
                        <span className="rounded-full bg-purple-100 px-2 py-0.5 text-xs font-medium text-purple-700">
                          บอร์ด
                        </span>
                      )}
                      <BestBadge best={bests[c.slug]} />
                    </div>
                    <h3 className="text-sm font-semibold leading-snug text-gray-900 group-hover:text-brand">
                      {c.title}
                    </h3>
                    <span className="mt-2 inline-flex items-center gap-1 text-xs font-medium text-brand">
                      <Play className="h-3 w-3" /> เล่นเคสนี้
                    </span>
                  </Link>
                ))}
              </div>
            </>
          )}
        </>
      )}

      <p className="mt-8 text-center text-sm text-muted-foreground">
        เล่นฟรีทุกเคส · ล็อกอินเพื่อเก็บ XP และขึ้น{" "}
        <Link href="/school/leaderboard" className="font-semibold text-brand underline">
          Leaderboard
        </Link>{" "}
        · อยากฝึกสอบเต็มรูปแบบกับ AI Examiner ลอง{" "}
        <Link href="/longcase" className="font-semibold text-brand underline">
          ฝึกสอบ Long Case
        </Link>{" "}
        · เกมกู้ชีพ ACLS ที่{" "}
        <Link href="/sim" className="font-semibold text-brand underline">
          Code Blue Sim
        </Link>
      </p>
    </div>
  );
}
