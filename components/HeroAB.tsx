"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { ArrowRight, BookOpen, Gamepad2, Shield, Sparkles, Stethoscope, Users } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { track } from "@/lib/analytics";
import { getVariant, type Variant } from "@/lib/ab";
import type { HomeExamStats } from "@/lib/supabase/queries";

const EXPERIMENT = "hero";

type Copy = {
  badge: string;
  headlineTop: string;
  headlineAccent: string;
  subline: string;
};

// Conservative floors used only when live counts are unavailable (e.g. a build
// with Supabase not configured). The real numbers come from the DB at runtime,
// so these are deliberately just below the current bank size — never above it.
const FALLBACK_TOTAL = "6,000+";
const FALLBACK_NL = "3,500+";

function buildCopy(totalStr: string, nlStr: string): Record<Variant, Copy> {
  return {
    A: {
      badge: "แพลตฟอร์มข้อสอบ MEQ + NL + Long Case ออนไลน์",
      headlineTop: "เตรียมสอบแพทย์",
      headlineAccent: "ด้วย AI ที่เข้าใจคุณ",
      subline: `ข้อสอบ MEQ แบบ Progressive Case + ข้อสอบ NL ใบประกอบวิชาชีพ ${nlStr} ข้อ + ฝึกสอบ Long Case กับ AI Patient & Examiner`,
    },
    B: {
      badge: `${totalStr} ข้อ • MEQ • NL Step 2 • Long Case`,
      headlineTop: "สอบผ่านครั้งแรก",
      headlineAccent: `ด้วยข้อสอบ AI ${totalStr} ข้อ`,
      subline:
        "ฝึก NL Step 2 + MEQ Progressive Case + Long Case กับ AI Patient ที่ตอบโต้เหมือนคนไข้จริง — เริ่มฟรีไม่ต้องใช้บัตรเครดิต",
    },
  };
}

function trackHeroCta(variant: Variant | null, cta: string) {
  track("hero_variant_convert", {
    variant: variant ?? "unknown",
    cta,
  });
}

export default function HeroAB({
  forced = null,
  stats = null,
}: {
  forced?: Variant | null;
  stats?: HomeExamStats | null;
}) {
  const [variant, setVariant] = useState<Variant | null>(forced);

  useEffect(() => {
    // `forced` is set by the autopilot once an A/B winner is locked in; skip
    // randomisation but keep logging views so we can still watch performance.
    if (forced) {
      track("hero_variant_view", { variant: forced });
      return;
    }
    const v = getVariant(EXPERIMENT);
    setVariant(v);
    if (v) track("hero_variant_view", { variant: v });
  }, [forced]);

  // Live numbers from the DB (refreshed every revalidate window on the server).
  const totalReady = stats?.totalReady ?? 0;
  const totalBuilding = stats?.totalBuilding ?? 0;
  const nlReady = stats?.nlReady ?? 0;
  const meqExamCount = stats?.meqExamCount ?? 0;
  const meqPartCount = stats?.meqPartCount ?? 0;
  const longCaseCount = stats?.longCaseCount ?? 0;
  const casegameCount = stats?.casegameCount ?? 0;
  const totalStr = totalReady > 0 ? totalReady.toLocaleString("en-US") : FALLBACK_TOTAL;
  const nlStr = nlReady > 0 ? nlReady.toLocaleString("en-US") : FALLBACK_NL;

  const copy = buildCopy(totalStr, nlStr)[variant ?? "A"];

  return (
    <section className="relative overflow-hidden bg-gradient-to-br from-brand-dark via-brand-dark to-brand py-20 sm:py-28">
      <div className="absolute inset-0 bg-[url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGRlZnM+PHBhdHRlcm4gaWQ9ImciIHdpZHRoPSI2MCIgaGVpZ2h0PSI2MCIgcGF0dGVyblVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+PHBhdGggZD0iTTAgMGg2MHY2MEgweiIgZmlsbD0ibm9uZSIvPjxjaXJjbGUgY3g9IjMwIiBjeT0iMzAiIHI9IjEiIGZpbGw9InJnYmEoMjU1LDI1NSwyNTUsMC4wNSkiLz48L3BhdHRlcm4+PC9kZWZzPjxyZWN0IHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjEwMCUiIGZpbGw9InVybCgjZykiLz48L3N2Zz4=')] opacity-40" />
      <div className="relative mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="text-center">
          <Badge className="mb-6 bg-white/10 text-white border-white/20 hover:bg-white/20">
            <Sparkles className="h-3 w-3 mr-1" /> {copy.badge}
          </Badge>
          <h1 className="text-4xl sm:text-5xl lg:text-6xl font-bold text-white leading-tight">
            {copy.headlineTop}
            <br />
            <span className="text-brand-light">{copy.headlineAccent}</span>
          </h1>
          <p className="mt-6 text-lg text-white/70 max-w-2xl mx-auto">
            {copy.subline}
          </p>
          <div className="mt-8 flex flex-col sm:flex-row items-center justify-center gap-4">
            <Link
              href="/exams"
              onClick={() => trackHeroCta(variant, "meq")}
            >
              <Button
                size="lg"
                className="bg-brand hover:bg-brand-light text-white px-8 text-base"
              >
                ข้อสอบ MEQ <ArrowRight className="ml-2 h-4 w-4" />
              </Button>
            </Link>
            <Link
              href="/longcase"
              onClick={() => trackHeroCta(variant, "longcase")}
            >
              <Button
                size="lg"
                className="bg-amber-500 hover:bg-amber-400 text-white px-8 text-base"
              >
                Long Case Exam <ArrowRight className="ml-2 h-4 w-4" />
              </Button>
            </Link>
            <Link
              href="/nl"
              onClick={() => trackHeroCta(variant, "mcq")}
            >
              <Button
                size="lg"
                className="bg-white/10 border border-white/30 text-white hover:bg-white/20 px-8 text-base"
              >
                MCQ <ArrowRight className="ml-2 h-4 w-4" />
              </Button>
            </Link>
          </div>
          <div className="mt-10 flex flex-wrap items-center justify-center gap-x-8 gap-y-3 text-sm text-white/60">
            <span className="flex items-center gap-1.5">
              <Users className="h-4 w-4" /> 1,000+ แพทย์ใช้งาน
            </span>
            <span className="flex items-center gap-1.5">
              <BookOpen className="h-4 w-4" /> {totalStr} ข้อสอบ MCQ พร้อมใช้
            </span>
            <span className="flex items-center gap-1.5">
              <Shield className="h-4 w-4" /> เฉลยจากผู้เชี่ยวชาญ
            </span>
          </div>

          {/* Real MEQ + Long Case counts — the premium, case-based content that
              sets us apart from plain MCQ banks. Numbers come live from the DB. */}
          {(meqExamCount > 0 || longCaseCount > 0 || casegameCount > 0) && (
            <div className="mt-6 flex flex-wrap items-center justify-center gap-3">
              {meqExamCount > 0 && (
                <span className="inline-flex items-center gap-2 rounded-full border border-purple-300/30 bg-purple-400/15 px-4 py-1.5 text-sm font-semibold text-purple-50">
                  <BookOpen className="h-4 w-4" />
                  MEQ Progressive Case {meqExamCount.toLocaleString("en-US")} ชุด
                  {meqPartCount > 0 && (
                    <span className="font-normal text-purple-100/80">
                      ({meqPartCount.toLocaleString("en-US")} ตอน)
                    </span>
                  )}
                </span>
              )}
              {longCaseCount > 0 && (
                <span className="inline-flex items-center gap-2 rounded-full border border-amber-300/30 bg-amber-400/15 px-4 py-1.5 text-sm font-semibold text-amber-50">
                  <Stethoscope className="h-4 w-4" />
                  Long Case กับ AI {longCaseCount.toLocaleString("en-US")} เคส
                </span>
              )}
              {casegameCount > 0 && (
                <Link
                  href="/casegame"
                  onClick={() => trackHeroCta(variant, "casegame")}
                  className="inline-flex items-center gap-2 rounded-full border border-teal-300/30 bg-teal-400/15 px-4 py-1.5 text-sm font-semibold text-teal-50 transition-colors hover:bg-teal-400/25"
                >
                  <Gamepad2 className="h-4 w-4" />
                  เกมเคส {casegameCount.toLocaleString("en-US")} เคส — เล่นฟรี
                </Link>
              )}
            </div>
          )}

          {/* Live "building" counter — shows how many questions are queued and
              being generated/reviewed right now. Auto-refreshes with the page. */}
          {totalBuilding > 0 && (
            <div className="mt-6 flex justify-center">
              <span className="inline-flex items-center gap-2 rounded-full border border-emerald-300/30 bg-emerald-400/15 px-4 py-1.5 text-sm font-medium text-emerald-50">
                <span className="relative flex h-2.5 w-2.5">
                  <span className="absolute inline-flex h-full w-full animate-ping rounded-full bg-emerald-300 opacity-75" />
                  <span className="relative inline-flex h-2.5 w-2.5 rounded-full bg-emerald-300" />
                </span>
                อีก {totalBuilding.toLocaleString("en-US")} ข้อกำลังสร้าง — เพิ่มเข้าคลังเรื่อยๆ ทุกวัน
              </span>
            </div>
          )}
        </div>
      </div>
    </section>
  );
}
