import { Suspense } from "react";
import PricingCard from "@/components/PricingCard";
import PricingViewTracker from "@/components/PricingViewTracker";
import PricingPromo from "@/components/PricingPromo";
import PricingFaq, { PRICING_FAQ_ITEMS } from "@/components/PricingFaq";
import { LineCtaButton } from "@/components/SocialLinks";
import { PRICING_PLANS, BOARD_PRICING_PLANS } from "@/lib/types";
import { GraduationCap, Mic } from "lucide-react";
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
    "เลือกแพ็กเกจเตรียมสอบที่เหมาะกับคุณ — แพ็ก นศพ. (NL Step 2 + MEQ + Long Case) และแพ็ก Board (MCQ บอร์ด + Oral Exam ทุกสาขา)",
  alternates: { canonical: "https://www.morroo.com/pricing" },
  openGraph: {
    title: "แพ็กเกจราคา — หมอรู้",
    description:
      "แพ็ก นศพ. และแพ็ก Board ครอบคลุมทุกสาขา — เริ่มต้นฟรี หรือสมัครสมาชิกใช้ไม่จำกัด",
    url: "https://www.morroo.com/pricing",
  },
};

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
        <h1 className="text-3xl sm:text-4xl font-bold">แพ็กเกจราคา</h1>
        <p className="mt-3 text-lg text-muted-foreground max-w-xl mx-auto">
          แพ็ก นศพ. เตรียม NL Step 2 หรือแพ็ก Board เตรียมวุฒิบัตรราชวิทยาลัยฯ
        </p>
      </div>

      {/* Student / NL Step 2 plans */}
      <section className="mb-16">
        <div className="text-center mb-6">
          <h2 className="text-2xl font-bold">นักศึกษาแพทย์ / NL Step 2</h2>
          <p className="text-sm text-muted-foreground mt-1">
            MCQ NL + MEQ + Long Case สำหรับ extern / intern
          </p>
        </div>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 items-start">
          {PRICING_PLANS.map((plan) => (
            <PricingCard key={plan.name} {...plan} />
          ))}
        </div>
      </section>

      {/* Board exam plans */}
      <section className="mb-16">
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
          * แพ็ก นศพ. ไม่รวมเนื้อหา Board และในทางกลับกัน — เลือกแพ็กให้ตรงกับเป้าหมายสอบ
        </p>
      </section>

      {/* Still deciding? — capture hesitant visitors via LINE */}
      <div className="max-w-2xl mx-auto mb-16 rounded-2xl border border-[#06C755]/30 bg-[#06C755]/5 p-6 text-center">
        <h2 className="text-xl font-bold">ยังไม่แน่ใจว่าแพ็กไหนเหมาะ?</h2>
        <p className="mt-2 text-sm text-muted-foreground">
          แอด LINE มาปรึกษาได้เลย เราช่วยแนะนำแพ็กที่ตรงกับเป้าหมายสอบของคุณ + รับข้อสอบฟรีทุกเช้า
        </p>
        <LineCtaButton surface="pricing" className="mt-4" />
      </div>

      <PricingFaq surface="pricing_page" />
    </div>
  );
}
