"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { ArrowRight, BookOpen, Shield, Sparkles, Users } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { track } from "@/lib/analytics";
import { getVariant, type Variant } from "@/lib/ab";

const EXPERIMENT = "hero";

type Copy = {
  badge: string;
  headlineTop: string;
  headlineAccent: string;
  subline: string;
};

const COPY: Record<Variant, Copy> = {
  A: {
    badge: "แพลตฟอร์มข้อสอบ MEQ + NL + Long Case ออนไลน์",
    headlineTop: "เตรียมสอบแพทย์",
    headlineAccent: "ด้วย AI ที่เข้าใจคุณ",
    subline:
      "ข้อสอบ MEQ แบบ Progressive Case + ข้อสอบ NL ใบประกอบวิชาชีพ 1,300+ ข้อ + ฝึกสอบ Long Case กับ AI Patient & Examiner",
  },
  B: {
    badge: "1,300+ ข้อ • MEQ • NL Step 2 • Long Case",
    headlineTop: "สอบผ่านครั้งแรก",
    headlineAccent: "ด้วยข้อสอบ AI 1,300+ ข้อ",
    subline:
      "ฝึก NL Step 2 + MEQ Progressive Case + Long Case กับ AI Patient ที่ตอบโต้เหมือนคนไข้จริง — เริ่มฟรีไม่ต้องใช้บัตรเครดิต",
  },
};

function trackHeroCta(variant: Variant | null, cta: string) {
  track("hero_variant_convert", {
    variant: variant ?? "unknown",
    cta,
  });
}

export default function HeroAB({ forced = null }: { forced?: Variant | null }) {
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

  const copy = COPY[variant ?? "A"];

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
          <div className="mt-10 flex items-center justify-center gap-8 text-sm text-white/60">
            <span className="flex items-center gap-1.5">
              <Users className="h-4 w-4" /> 1,000+ แพทย์ใช้งาน
            </span>
            <span className="flex items-center gap-1.5">
              <BookOpen className="h-4 w-4" /> 1,300+ ข้อสอบ
            </span>
            <span className="flex items-center gap-1.5">
              <Shield className="h-4 w-4" /> เฉลยจากผู้เชี่ยวชาญ
            </span>
          </div>
        </div>
      </div>
    </section>
  );
}
