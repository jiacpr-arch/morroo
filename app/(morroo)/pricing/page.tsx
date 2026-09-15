import { Suspense } from "react";
import Link from "next/link";
import PricingCard from "@/components/PricingCard";
import PricingViewTracker from "@/components/PricingViewTracker";
import PricingFreeCta from "@/components/PricingFreeCta";
import PricingPromo from "@/components/PricingPromo";
import PricingFaq from "@/components/PricingFaq";
import PricingCompareTable from "@/components/PricingCompareTable";
import NlExamCountdown from "@/components/NlExamCountdown";
import SocialProofSection from "@/components/SocialProofSection";
import { PRICING_FAQ_ITEMS } from "@/lib/pricing-faq";
import { LineCtaButton } from "@/components/SocialLinks";
import { PRICING_PLANS, BOARD_PRICING_PLANS } from "@/lib/types";
import { PLAN_CATALOG } from "@/lib/membership";
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

const SCHOOL_PLANS = [
  {
    name: "School รายเดือน",
    price: PLAN_CATALOG.school_monthly.amount,
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
    price: PLAN_CATALOG.school_yearly.amount,
    period: "/ ปี",
    description: "ใช้ทั้งปีการศึกษา",
    features: [
      "ทุกอย่างในแพ็กรายเดือน",
      `ประหยัด ฿${(PLAN_CATALOG.school_monthly.amount * 12 - PLAN_CATALOG.school_yearly.amount).toLocaleString()}/ปี`,
    ],
    cta: "สมัคร School รายปี",
    popular: false,
    type: "school_yearly" as const,
  },
] as const;

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
    <div className="mx-auto max-w-7xl px-4 py-16 sm:px-6 lg:px-8">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(faqSchema) }}
      />
      <PricingViewTracker surface="pricing_page" />
      <Suspense fallback={null}>
        <PricingPromo />
      </Suspense>
      <div className="text-center mb-12">
        <h1 className="text-3xl sm:text-4xl font-bold">คุณกำลังเตรียมสอบอะไร?</h1>
        <p className="mt-3 text-lg text-muted-foreground max-w-xl mx-auto">
          เลือกแทร็กที่ตรงกับเป้าหมาย — แต่ละแทร็กมีแค่รายเดือนกับรายปี
        </p>
        <PricingFreeCta />
      </div>

      {/* Track jump links */}
      <nav className="flex flex-wrap justify-center gap-2 mb-12" aria-label="เลือกแทร็ก">
        <a href="#student" className="inline-flex items-center gap-1.5 rounded-full border px-4 py-2 text-sm font-medium hover:border-brand hover:text-brand">
          <Stethoscope className="h-4 w-4" /> นศพ. / NL Step 2
        </a>
        <a href="#board" className="inline-flex items-center gap-1.5 rounded-full border px-4 py-2 text-sm font-medium hover:border-purple-500 hover:text-purple-700">
          <GraduationCap className="h-4 w-4" /> Board
        </a>
        <a href="#school" className="inline-flex items-center gap-1.5 rounded-full border px-4 py-2 text-sm font-medium hover:border-emerald-500 hover:text-emerald-700">
          <BookOpen className="h-4 w-4" /> School ปี 1–6
        </a>
      </nav>

      <NlExamCountdown />

      {/* Track 1 — Student / NL Step 2 */}
      <section id="student" className="mb-16 scroll-mt-24">
        <div className="text-center mb-6">
          <div className="inline-flex items-center gap-2 bg-brand/10 text-brand px-3 py-1 rounded-full text-xs font-semibold mb-3">
            <Stethoscope className="h-3.5 w-3.5" />
            สำหรับ extern / intern
          </div>
          <h2 className="text-2xl font-bold">นักศึกษาแพทย์ / NL Step 2</h2>
          <p className="text-sm text-muted-foreground mt-1">
            MCQ NL + MEQ + Long Case + School รวมในแพ็กเดียว
          </p>
        </div>
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
          <MiniLink href="/payment/mcq_monthly">MCQ ฿{PLAN_CATALOG.mcq_monthly.amount}/เดือน</MiniLink>
          <MiniLink href="/payment/meq_monthly">MEQ ฿{PLAN_CATALOG.meq_monthly.amount}/เดือน</MiniLink>
          <MiniLink href="/payment/longcase_monthly">Long Case ฿{PLAN_CATALOG.longcase_monthly.amount}/เดือน</MiniLink>
        </div>
      </section>

      {/* Track 2 — Board */}
      <section id="board" className="mb-16 scroll-mt-24">
        <div className="text-center mb-6">
          <div className="inline-flex items-center gap-2 bg-purple-100 text-purple-700 px-3 py-1 rounded-full text-xs font-semibold mb-3">
            <GraduationCap className="h-3.5 w-3.5" />
            สำหรับสอบบอร์ดราชวิทยาลัยฯ
          </div>
          <h2 className="text-2xl font-bold">แพทย์เฉพาะทาง / Board Exam</h2>
          <p className="text-sm text-muted-foreground mt-1 max-w-xl mx-auto">
            ครอบคลุมทุกสาขา — MCQ ตาม Blueprint + Oral Exam (Long Case)
            กับ <span className="inline-flex items-center gap-1 font-semibold text-purple-700"><Mic className="h-3 w-3" />อ.บอร์ด AI</span>
          </p>
        </div>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-6 max-w-3xl mx-auto items-start">
          {BOARD_PRICING_PLANS.map((plan) => (
            <PricingCard key={plan.name} {...plan} />
          ))}
        </div>
        <p className="text-xs text-muted-foreground text-center mt-4">
          * แพ็ก Board ไม่รวมเนื้อหา นศพ. และในทางกลับกัน — ถือทั้งสองแพ็กพร้อมกันได้
        </p>
      </section>

      {/* Track 3 — School */}
      <section id="school" className="mb-16 scroll-mt-24">
        <div className="text-center mb-6">
          <div className="inline-flex items-center gap-2 bg-emerald-100 text-emerald-700 px-3 py-1 rounded-full text-xs font-semibold mb-3">
            <BookOpen className="h-3.5 w-3.5" />
            สำหรับนักศึกษาแพทย์ระหว่างเรียน
          </div>
          <h2 className="text-2xl font-bold">School ปี 1–6</h2>
          <p className="text-sm text-muted-foreground mt-1 max-w-xl mx-auto">
            ทบทวนทีละบทตาม curriculum — flashcard, quiz และบทเรียนรายวัน (แพ็ก นศพ. รวม School ไว้แล้ว)
          </p>
        </div>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-6 max-w-3xl mx-auto items-start">
          {SCHOOL_PLANS.map((plan) => (
            <PricingCard key={plan.name} {...plan} />
          ))}
        </div>
      </section>

      {/* Full comparison — collapsed */}
      <div className="max-w-4xl mx-auto mb-16">
        <PricingCompareTable />
      </div>

      {/* Still deciding? — capture hesitant visitors via LINE */}
      <div className="max-w-2xl mx-auto mb-16 rounded-2xl border border-[#06C755]/30 bg-[#06C755]/5 p-6 text-center">
        <h2 className="text-xl font-bold">ยังไม่แน่ใจว่าแพ็กไหนเหมาะ?</h2>
        <p className="mt-2 text-sm text-muted-foreground">
          แอด LINE มาปรึกษาได้เลย เราช่วยแนะนำแพ็กที่ตรงกับเป้าหมายสอบของคุณ + รับข้อสอบฟรีทุกเช้า
        </p>
        <LineCtaButton surface="pricing" className="mt-4" />
      </div>

      {/* Testimonials + stats — same section as the landing page, helps hesitant buyers */}
      <div className="mb-16 -mx-4 sm:-mx-6 lg:-mx-8">
        <SocialProofSection />
      </div>

      <PricingFaq surface="pricing_page" />
    </div>
  );
}
