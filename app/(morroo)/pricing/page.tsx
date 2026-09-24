import { Suspense } from "react";
import Link from "next/link";
import PricingCard from "@/components/PricingCard";
import PricingViewTracker from "@/components/PricingViewTracker";
import PricingFreeCta from "@/components/PricingFreeCta";
import PricingPromo from "@/components/PricingPromo";
import PricingFaq from "@/components/PricingFaq";
import PricingCompareTable from "@/components/PricingCompareTable";
import NlExamCountdown from "@/components/NlExamCountdown";
import SectionHeading from "@/components/SectionHeading";
import SocialProofSection from "@/components/SocialProofSection";
import { PRICING_FAQ_ITEMS } from "@/lib/pricing-faq";
import { LineCtaButton } from "@/components/SocialLinks";
import { PRICING_PLANS, BOARD_PRICING_PLANS, planCardPrice, yearlySaving } from "@/lib/types";
import { PLAN_CATALOG, PLAN_TYPES, planDisplayPrice } from "@/lib/membership";
import { GraduationCap, Mic, Stethoscope, BookOpen } from "lucide-react";
import type { Metadata } from "next";

const faqSchema = {
  "@context": "https://schema.org",
  "@type": "FAQPage",
  mainEntity: PRICING_FAQ_ITEMS.map((f) => ({
    "@type": "Question",
    name: f.q,
    acceptedAnswer: { "@type": "Answer", text: f.a },
  })),
};

export const metadata: Metadata = {
  title: "แพ็กเกจราคา — เริ่มต้นฟรี",
  description:
    "เลือกแพ็กเกจเตรียมสอบที่เหมาะกับคุณ — แพ็ก นศพ. (NL Step 2 + MEQ + Long Case) แพ็ก Board (MCQ บอร์ด + Oral Exam ทุกสาขา) และ School สำหรับปี 1–6",
  alternates: { canonical: "https://www.morroo.com/pricing" },
  openGraph: {
    title: "แพ็กเกจราคา — หมอรู้",
    description:
      "แพ็ก นศพ. แพ็ก Board และ School — เริ่มต้นฟรี หรือสมัครสมาชิกใช้ไม่จำกัด",
    url: "https://www.morroo.com/pricing",
  },
};

// Main decision on this page = which exam track. Each track shows only its
// monthly + yearly card; smaller SKUs (free, bundle, per-system) live in a
// one-line strip under the track and in-context on the practice pages, so
// the page never turns into a 10-card menu.
const STUDENT_MAIN = PRICING_PLANS.filter(
  (p) => p.type === "monthly" || p.type === "yearly"
);

const SCHOOL_SAVING = yearlySaving("school_monthly", "school_yearly");

const SCHOOL_PLANS = [
  {
    name: "School รายเดือน",
    ...planCardPrice("school_monthly"),
    period: "/ เดือน",
    description: "นักศึกษาแพทย์ปี 1–6 ทบทวนตาม curriculum",
    features: [
      "Flashcard / Quiz ไม่จำกัด",
      "บทเรียนรายวัน + SRS review",
      "ตาม curriculum ปีที่เรียน",
    ],
    cta: "สมัคร School รายเดือน",
    popular: true,
    type: "school_monthly" as const,
  },
  {
    name: "School รายปี",
    ...planCardPrice("school_yearly"),
    period: "/ ปี",
    description: "ใช้ทั้งปีการศึกษา",
    features: [
      "ทุกอย่างในแพ็กรายเดือน",
      `ประหยัด ฿${SCHOOL_SAVING.baht.toLocaleString()}/ปี (${SCHOOL_SAVING.percent}%)`,
    ],
    cta: "สมัคร School รายปี",
    popular: false,
    badge: "คุ้มที่สุด",
    type: "school_yearly" as const,
  },
] as const;

// Headline for the first-purchase banner.
const MAX_INTRO_SAVE = Math.max(...PLAN_TYPES.map((p) => planDisplayPrice(p).savePercent));

function MiniLink({ href, children }: { href: string; children: React.ReactNode }) {
  return (
    <Link
      href={href}
      className="inline-flex items-center rounded-full border bg-background px-3 py-1 text-xs text-muted-foreground hover:border-brand hover:text-brand transition-colors"
    >
      {children}
    </Link>
  );
}

export default function PricingPage() {
  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(faqSchema) }}
      />
      <PricingViewTracker surface="pricing_page" />

      {/* แถบเปิดหน้า — คำถามเดียวที่ผู้เข้าชมต้องตอบ แล้วตามด้วยทางลัดไปแต่ละแทร็ก */}
      <section className="bg-muted py-14 sm:py-16">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <Suspense fallback={null}>
            <PricingPromo />
          </Suspense>
          <div className="text-center">
            <h1 className="text-3xl font-extrabold text-brand-dark sm:text-4xl lg:text-5xl">
              คุณกำลังเตรียมสอบอะไร?
            </h1>
            <span className="mx-auto mt-4 block h-1 w-12 rounded-full bg-gradient-to-r from-brand to-brand-light" />
            <p className="mx-auto mt-4 max-w-xl text-base leading-relaxed text-muted-foreground sm:text-lg">
              เลือกแทร็กที่ตรงกับเป้าหมาย — แต่ละแทร็กมีแค่รายเดือนกับรายปี
            </p>
            <p className="mx-auto mt-3 inline-flex rounded-full bg-brand/10 px-4 py-1.5 text-sm font-semibold text-brand">
              🎉 สมาชิกใหม่ — ซื้อครั้งแรกลดสูงสุด {MAX_INTRO_SAVE}%
            </p>
            <PricingFreeCta />
          </div>

          {/* Track jump links — สีตรงกับ accent ของแต่ละแทร็กด้านล่าง */}
          <nav className="mt-8 flex flex-wrap justify-center gap-2" aria-label="เลือกแทร็ก">
            <a href="#student" className="inline-flex items-center gap-1.5 rounded-full border px-4 py-2 text-sm font-medium transition-colors border-brand/30 bg-brand/5 text-brand hover:bg-brand/10">
              <Stethoscope className="h-4 w-4" /> นศพ. / NL Step 2
            </a>
            <a href="#board" className="inline-flex items-center gap-1.5 rounded-full border px-4 py-2 text-sm font-medium transition-colors border-purple-300 bg-purple-50 text-purple-700 hover:bg-purple-100">
              <GraduationCap className="h-4 w-4" /> Board
            </a>
            <a href="#school" className="inline-flex items-center gap-1.5 rounded-full border px-4 py-2 text-sm font-medium transition-colors border-emerald-300 bg-emerald-50 text-emerald-700 hover:bg-emerald-100">
              <BookOpen className="h-4 w-4" /> School ปี 1–6
            </a>
          </nav>

          <div className="mt-8">
            <NlExamCountdown />
          </div>
        </div>
      </section>

      {/* Track 1 — Student / NL Step 2 */}
      <section id="student" className="scroll-mt-20 py-16 sm:py-20">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <SectionHeading
            align="center"
            accent="brand"
            eyebrow={<><Stethoscope className="h-3.5 w-3.5" /> สำหรับ extern / intern</>}
            title="นักศึกษาแพทย์ / NL Step 2"
            description="MCQ NL + MEQ + Long Case + School รวมในแพ็กเดียว"
          />
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-6 max-w-3xl mx-auto items-start">
            {STUDENT_MAIN.map((plan) => (
              <PricingCard key={plan.name} {...plan} />
            ))}
          </div>
          {/* Smaller SKUs — one strip, not more cards */}
          <div className="mt-6 flex flex-wrap items-center justify-center gap-2 text-xs text-muted-foreground">
            <span>ยังไม่พร้อมสมัคร?</span>
            <MiniLink href="/register">เริ่มฟรี 5 ข้อ/สาขา</MiniLink>
            <MiniLink href="/payment/bundle">ชุด 10 ข้อ ฿{PLAN_CATALOG.bundle.amount}</MiniLink>
            <span className="mx-1 hidden sm:inline">·</span>
            <span>หรือซื้อแยกรายระบบ:</span>
            <MiniLink href="/payment/mcq_monthly">MCQ ฿{planDisplayPrice("mcq_monthly").price}/เดือน</MiniLink>
            <MiniLink href="/payment/meq_monthly">MEQ ฿{planDisplayPrice("meq_monthly").price}/เดือน</MiniLink>
            <MiniLink href="/payment/longcase_monthly">Long Case ฿{planDisplayPrice("longcase_monthly").price}/เดือน</MiniLink>
          </div>
        </div>
      </section>

      {/* Track 2 — Board */}
      <section id="board" className="scroll-mt-20 bg-muted py-16 sm:py-20">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <SectionHeading
            align="center"
            accent="purple"
            eyebrow={<><GraduationCap className="h-3.5 w-3.5" /> สำหรับสอบบอร์ดราชวิทยาลัยฯ</>}
            title="แพทย์เฉพาะทาง / Board Exam"
            description={
              <>
                ครอบคลุมทุกสาขา — MCQ ตาม Blueprint + Oral Exam (Long Case) กับ{" "}
                <span className="inline-flex items-center gap-1 font-semibold text-purple-700">
                  <Mic className="h-3 w-3" />อ.บอร์ด AI
                </span>
              </>
            }
          />
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-6 max-w-3xl mx-auto items-start">
            {BOARD_PRICING_PLANS.map((plan) => (
              <PricingCard key={plan.name} {...plan} />
            ))}
          </div>
          <p className="text-xs text-muted-foreground text-center mt-4">
            * แพ็ก Board ไม่รวมเนื้อหา นศพ. และในทางกลับกัน — ถือทั้งสองแพ็กพร้อมกันได้
          </p>
        </div>
      </section>

      {/* Track 3 — School */}
      <section id="school" className="scroll-mt-20 py-16 sm:py-20">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <SectionHeading
            align="center"
            accent="emerald"
            eyebrow={<><BookOpen className="h-3.5 w-3.5" /> สำหรับนักศึกษาแพทย์ระหว่างเรียน</>}
            title="School ปี 1–6"
            description="ทบทวนทีละบทตาม curriculum — flashcard, quiz และบทเรียนรายวัน (แพ็ก นศพ. รวม School ไว้แล้ว)"
          />
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-6 max-w-3xl mx-auto items-start">
            {SCHOOL_PLANS.map((plan) => (
              <PricingCard key={plan.name} {...plan} />
            ))}
          </div>
        </div>
      </section>

      {/* ตารางเทียบแบบเต็ม (พับไว้) + ทางออกสำหรับคนที่ยังไม่ตัดสินใจ */}
      <section className="bg-muted py-16 sm:py-20">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div className="mx-auto max-w-4xl">
            <PricingCompareTable />
          </div>
          <div className="mx-auto mt-12 max-w-2xl rounded-2xl border border-[#06C755]/30 bg-[#06C755]/5 p-6 text-center shadow-sm">
            <h2 className="text-xl font-bold text-brand-dark">ยังไม่แน่ใจว่าแพ็กไหนเหมาะ?</h2>
            <p className="mt-2 text-sm text-muted-foreground">
              แอด LINE มาปรึกษาได้เลย เราช่วยแนะนำแพ็กที่ตรงกับเป้าหมายสอบของคุณ + รับข้อสอบฟรีทุกเช้า
            </p>
            <LineCtaButton surface="pricing" className="mt-4" />
          </div>
        </div>
      </section>

      {/* Testimonials + stats — same section as the landing page, helps hesitant buyers */}
      <SocialProofSection />

      <section className="py-16 sm:py-20">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <PricingFaq surface="pricing_page" />
        </div>
      </section>
    </>
  );
}
