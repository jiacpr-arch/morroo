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
import { SocialButtonsRow, LineCtaButton } from "@/components/SocialLinks";
import { CATEGORIES, PRICING_PLANS } from "@/lib/types";
import { getExams, getExamPartCounts, sortExamsAvailableFirst } from "@/lib/supabase/queries";
import { getNewsItems } from "@/lib/news";
import NewsCard from "@/components/NewsCard";
import { createAdminClient } from "@/lib/supabase/admin";
import { getHeroForcedVariant } from "@/lib/site-config";
import { ArrowRight } from "lucide-react";

export const revalidate = 60; // revalidate every 60 seconds

export default async function HomePage() {
  const [allExams, partCounts, newsItems, forcedHero] = await Promise.all([
    getExams(),
    getExamPartCounts(),
    getNewsItems({ limit: 6 }),
    getHeroForcedVariant(createAdminClient()),
  ]);
  const exams = sortExamsAvailableFirst(allExams, partCounts);
  const latestExams = exams.slice(0, 6);

  return (
    <>
      <HeroAB forced={forcedHero} />

      {/* LINE add-friend strip — high-visibility CTA above the fold */}
      <section className="bg-[#06C755]/10 border-b border-[#06C755]/20">
        <div className="mx-auto flex max-w-7xl flex-col items-center justify-center gap-3 px-4 py-4 text-center sm:flex-row sm:gap-5 sm:py-3 sm:text-left">
          <p className="text-sm font-medium text-foreground sm:text-base">
            📩 รับข้อสอบฟรีทุกเช้า 7 โมง + เทคนิคเตรียมสอบ ผ่าน LINE
          </p>
          <LineCtaButton surface="home_hero" label="แอด LINE ฟรี" className="shrink-0" />
        </div>
      </section>

      {/* Feature Showcase — overview of every tool customers can use, up top */}
      <FeatureShowcase />

      {/* All Exams Countdown */}
      <section className="py-8 bg-white border-b">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <NlExamCountdown />
          <AllExamsCountdown />
        </div>
      </section>

      {/* Categories */}
      <section className="py-16">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold">หมวดหมู่สาขาวิชา</h2>
            <p className="mt-2 text-muted-foreground">ครอบคลุม 6 สาขาหลักที่ออกสอบ</p>
          </div>
          <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-4">
            {CATEGORIES.map((cat) => (
              <Link
                key={cat.slug}
                href={`/exams?category=${encodeURIComponent(cat.name)}`}
                className="group flex flex-col items-center gap-3 rounded-xl border p-6 transition-all hover:shadow-md hover:border-brand/30"
              >
                <span className="text-4xl group-hover:scale-110 transition-transform">
                  {cat.icon}
                </span>
                <span className="text-sm font-medium text-center">{cat.name}</span>
              </Link>
            ))}
          </div>
        </div>
      </section>

      {/* Latest Exams */}
      <section className="py-16 bg-muted/30">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between mb-8">
            <div>
              <h2 className="text-3xl font-bold">ข้อสอบล่าสุด</h2>
              <p className="mt-1 text-muted-foreground">อัปเดตใหม่ทุกสัปดาห์</p>
            </div>
            <Link href="/exams">
              <Button variant="outline" className="gap-2">
                ดูทั้งหมด <ArrowRight className="h-4 w-4" />
              </Button>
            </Link>
          </div>
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
      <SocialProofSection />

      {/* Pricing */}
      <section className="py-16 bg-muted/30" id="pricing">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold">แพ็กเกจราคา</h2>
            <p className="mt-2 text-muted-foreground">เลือกแพ็กเกจที่เหมาะกับคุณ</p>
          </div>
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
      {newsItems.length > 0 && (
        <section className="py-16">
          <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
            <div className="flex items-center justify-between mb-8">
              <div>
                <h2 className="text-3xl font-bold">ข่าวและอัปเดตล่าสุด</h2>
                <p className="mt-1 text-muted-foreground">ฟีเจอร์ใหม่ บทความ และข่าวสอบล่าสุด</p>
              </div>
              <Link href="/news">
                <Button variant="outline" className="gap-2">
                  ดูข่าวทั้งหมด <ArrowRight className="h-4 w-4" />
                </Button>
              </Link>
            </div>
            <div className="space-y-4">
              {newsItems.slice(0, 4).map((item) => (
                <NewsCard key={item.id} item={item} />
              ))}
            </div>
          </div>
        </section>
      )}

      {/* Social */}
      <section className="py-12 bg-white border-b">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-2xl sm:text-3xl font-bold">ติดตามหมอรู้</h2>
          <p className="mt-2 text-muted-foreground">
            แอด LINE, Facebook, Instagram เพื่อรับข่าวสารและเทคนิคเตรียมสอบใหม่ๆ
          </p>
          <SocialButtonsRow className="mt-6" />
        </div>
      </section>

      {/* CTA */}
      <section className="py-20 bg-brand-dark text-white">
        <div className="mx-auto max-w-3xl px-4 text-center">
          <h2 className="text-3xl sm:text-4xl font-bold">
            พร้อมเริ่มเตรียมสอบแล้วหรือยัง?
          </h2>
          <p className="mt-4 text-white/70 text-lg">
            สมัครสมาชิกวันนี้ เข้าถึงข้อสอบ MEQ + NL + Long Case กับ AI พร้อมเฉลยละเอียดจากผู้เชี่ยวชาญ
          </p>
          <div className="mt-8 flex flex-col sm:flex-row items-center justify-center gap-4">
            <Link href="/register">
              <Button
                size="lg"
                className="bg-brand hover:bg-brand-light text-white px-8 text-base"
              >
                สมัครสมาชิกฟรี
              </Button>
            </Link>
            <Link href="/exams">
              <Button
                size="lg"
                className="bg-transparent border border-white/30 text-white hover:bg-white/10 px-8 text-base"
              >
                ดูข้อสอบตัวอย่าง
              </Button>
            </Link>
          </div>
        </div>
      </section>
    </>
  );
}
