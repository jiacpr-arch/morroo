import Link from "next/link";
import { Button } from "@/components/ui/button";
import ExamCard from "@/components/ExamCard";
import PricingCard from "@/components/PricingCard";
import PricingFaq from "@/components/PricingFaq";
import AllExamsCountdown from "@/components/AllExamsCountdown";
import NlExamCountdown from "@/components/NlExamCountdown";
import HeroAB from "@/components/HeroAB";
import PricingViewTracker from "@/components/PricingViewTracker";
import SocialProofSection from "@/components/SocialProofSection";
import FeatureShowcase from "@/components/FeatureShowcase";
import CaseGamePromo from "@/components/CaseGamePromo";
import SectionHeading from "@/components/SectionHeading";
import HeroPriceLine from "@/components/HeroPriceLine";
import { SocialButtonsRow, LineCtaButton } from "@/components/SocialLinks";
import { CATEGORIES, PRICING_PLANS } from "@/lib/types";
import { getExams, getExamPartCounts, sortExamsAvailableFirst } from "@/lib/supabase/queries";
import { getQuestionBankStats } from "@/lib/supabase/queries-mcq";
import { getLongCaseCount } from "@/lib/supabase/queries-longcase";
import { getCasegameCount } from "@/lib/supabase/queries-sim";
import { getNewsItems } from "@/lib/news";
import { getJiaAedNewsItems } from "@/lib/jiaaed-news";
import NewsCard from "@/components/NewsCard";
import { createAdminClient } from "@/lib/supabase/admin";
import { getHeroForcedVariant } from "@/lib/site-config";
import { ArrowRight } from "lucide-react";

export const revalidate = 60; // revalidate every 60 seconds

export default async function HomePage() {
  const [allExams, partCounts, newsItems, aedNewsItems, forcedHero, bankStats, longCaseCount, casegameCount] = await Promise.all([
    getExams(),
    getExamPartCounts(),
    getNewsItems({ limit: 6 }),
    getJiaAedNewsItems(2),
    getHeroForcedVariant(createAdminClient()),
    getQuestionBankStats(),
    getLongCaseCount(),
    getCasegameCount(),
  ]);
  const homeNewsItems = [...newsItems.slice(0, 4), ...aedNewsItems];
  const exams = sortExamsAvailableFirst(allExams, partCounts);
  const latestExams = exams.slice(0, 6);

  // Real MEQ counts from published exams (getExams returns published only).
  // Each MEQ exam is a Progressive Case made of several "parts" (ตอน).
  const meqExamCount = allExams.length;
  const meqPartCount = allExams.reduce((sum, e) => sum + (partCounts[e.id] || 0), 0);

  const examStats = {
    ...bankStats,
    meqExamCount,
    meqPartCount,
    longCaseCount,
    casegameCount,
  };

  return (
    <>
      <HeroAB forced={forcedHero} stats={examStats} />

      {/* เดิมตรงนี้เป็นแถบ "ลองทำข้อสอบฟรี/เล่นเกมเคส" ซ้ำกับ CTA หลักใน hero
          แล้ว (2026-09-15 ลดเหลือ CTA เดียวต่อจอ ตาม HeroAB) ตัดแถบซ้ำออก —
          เกมเคสยังโปรโมตต่อด้านล่างด้วย CTA ของตัวเองอยู่แล้ว */}

      {/* เกมเคส — new flagship game, promoted prominently right below the fold */}
      <CaseGamePromo count={casegameCount} />

      {/* Feature Showcase — overview of every tool customers can use, up top */}
      <FeatureShowcase />

      {/* All Exams Countdown */}
      <section className="py-10 border-y border-border/60 sm:py-12">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <NlExamCountdown />
          <AllExamsCountdown />
        </div>
      </section>

      {/* Categories */}
      <section className="py-16 sm:py-20 lg:py-24">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <SectionHeading
            align="center"
            title="หมวดหมู่สาขาวิชา"
            description="ครอบคลุม 6 สาขาหลักที่ออกสอบ"
          />
          <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-4">
            {CATEGORIES.map((cat) => (
              <Link
                key={cat.slug}
                href={`/exams?category=${encodeURIComponent(cat.name)}`}
                className="group flex flex-col items-center gap-3 rounded-2xl border border-border bg-card p-5 text-center shadow-sm transition-all hover:-translate-y-0.5 hover:border-brand/40 hover:shadow-lg hover:shadow-brand/5 sm:p-6"
              >
                <span className="flex h-14 w-14 items-center justify-center rounded-xl bg-brand/10 text-3xl transition-all group-hover:scale-105 group-hover:bg-brand/15">
                  {cat.icon}
                </span>
                <span className="text-sm font-semibold leading-snug text-foreground transition-colors group-hover:text-brand">
                  {cat.name}
                </span>
              </Link>
            ))}
          </div>
        </div>
      </section>

      {/* Latest Exams */}
      <section className="py-16 sm:py-20 lg:py-24 bg-muted">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <SectionHeading
            title="ข้อสอบล่าสุด"
            description="อัปเดตใหม่ทุกสัปดาห์"
            action={
              <Link href="/exams">
                <Button variant="outline" className="gap-2">
                  ดูทั้งหมด <ArrowRight className="h-4 w-4" />
                </Button>
              </Link>
            }
          />
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
            {latestExams.length > 0 ? (
              latestExams.map((exam) => (
                <ExamCard key={exam.id} exam={exam} partCount={partCounts[exam.id] || 0} />
              ))
            ) : (
              <p className="col-span-full text-center text-muted-foreground py-8">
                กำลังเตรียมข้อสอบ... กลับมาเร็วๆ นี้
              </p>
            )}
          </div>
        </div>
      </section>

      {/* Social Proof — testimonials + stats above pricing decision */}
      <SocialProofSection stats={examStats} />

      {/* Pricing */}
      <section className="py-16 sm:py-20 lg:py-24 scroll-mt-20 bg-gradient-to-b from-brand/[0.06] via-transparent to-brand/[0.06]" id="pricing">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <SectionHeading
            align="center"
            eyebrow="เริ่มฟรี ไม่ต้องใช้บัตรเครดิต"
            title="แพ็กเกจราคา"
            description="เลือกแพ็กเกจที่เหมาะกับคุณ"
          />
          <PricingViewTracker surface="home" />
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 items-start">
            {PRICING_PLANS.map((plan) => (
              <PricingCard key={plan.name} {...plan} />
            ))}
          </div>
          <div className="mt-16">
            <PricingFaq surface="home_pricing" />
          </div>
        </div>
      </section>

      {/* News & Updates */}
      {homeNewsItems.length > 0 && (
        <section className="py-16 sm:py-20 lg:py-24">
          <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
            <SectionHeading
              title="ข่าวและอัปเดตล่าสุด"
              description="ฟีเจอร์ใหม่ บทความ ข่าวสอบ และข่าวกู้ชีพล่าสุด"
              action={
                <Link href="/news">
                  <Button variant="outline" className="gap-2">
                    ดูข่าวทั้งหมด <ArrowRight className="h-4 w-4" />
                  </Button>
                </Link>
              }
            />
            <div className="space-y-4">
              {homeNewsItems.map((item) => (
                <NewsCard key={item.id} item={item} />
              ))}
            </div>
          </div>
        </section>
      )}

      {/* Social */}
      <section className="py-16 sm:py-20 lg:py-24 bg-muted">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 text-center">
          <SectionHeading
            align="center"
            title="ติดตามหมอรู้"
            description="📩 แอด LINE รับข้อสอบฟรีทุกเช้า 7 โมง + เทคนิคเตรียมสอบ · ติดตาม Facebook, Instagram เพื่อรับข่าวสารใหม่ๆ"
            className="mb-6 sm:mb-8"
            action={<LineCtaButton surface="home_social" label="แอด LINE ฟรี" />}
          />
          <SocialButtonsRow />
        </div>
      </section>

      {/* CTA */}
      <section className="py-20 bg-brand-dark text-white sm:py-24">
        <div className="mx-auto max-w-3xl px-4 text-center">
          <SectionHeading
            align="center"
            tone="dark"
            title="ลองก่อนได้ ไม่ต้องสมัคร"
            description="ทำข้อสอบจริง เล่นเกมเคส และลองข้อสอบ MEQ ได้เลยโดยไม่ต้องมีบัญชี — ถูกใจแล้วค่อยสมัครเพื่อเก็บความคืบหน้าและปลดล็อกเฉลยละเอียด"
            className="mb-8 sm:mb-10"
          />
          <div className="flex flex-col items-center gap-3">
            <Link href="/nl/practice">
              <Button
                size="lg"
                className="bg-brand hover:bg-brand-light text-white px-8 text-base"
              >
                ลองทำข้อสอบฟรี
              </Button>
            </Link>
            <HeroPriceLine surface="footer_cta" dark />
          </div>
          <p className="mt-6 text-sm text-white/60">
            <Link href="/exams" className="underline hover:text-white">ดูข้อสอบ MEQ</Link>
            {" · "}
            มีบัญชีแล้ว?{" "}
            <Link href="/login" className="underline hover:text-white">เข้าสู่ระบบ</Link>
            {" · "}
            ยังไม่มี?{" "}
            <Link href="/register" className="underline hover:text-white">สมัครฟรี</Link>
          </p>
        </div>
      </section>
    </>
  );
}
