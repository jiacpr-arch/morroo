import PricingCard from "@/components/PricingCard";
import { PRICING_PLANS } from "@/lib/types";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "แพ็กเกจราคา — เริ่มต้นฟรี",
  description:
    "เลือกแพ็กเกจเตรียมสอบที่เหมาะกับคุณ เริ่มต้นฟรี หรือสมัครสมาชิกเข้าถึงทุกอย่างไม่จำกัด ข้อสอบ MEQ + MCQ + Long Case",
  alternates: { canonical: "https://www.morroo.com/pricing" },
  openGraph: {
    title: "แพ็กเกจราคา — หมอรู้",
    description:
      "เริ่มต้นฟรี หรือสมัครสมาชิกเข้าถึงข้อสอบ MEQ + MCQ + Long Case ไม่จำกัด",
    url: "https://www.morroo.com/pricing",
  },
};

export default function PricingPage() {
  return (
    <div className="mx-auto max-w-7xl px-4 py-16 sm:px-6 lg:px-8">
      <div className="text-center mb-12">
        <h1 className="text-3xl sm:text-4xl font-bold">แพ็กเกจราคา</h1>
        <p className="mt-3 text-lg text-muted-foreground max-w-xl mx-auto">
          เลือกแพ็กเกจที่เหมาะกับการเตรียมสอบของคุณ ทุกแพ็กเกจเข้าถึงข้อสอบ MEQ
          คุณภาพสูง
        </p>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 items-start">
        {PRICING_PLANS.map((plan) => (
          <PricingCard key={plan.name} {...plan} />
        ))}
      </div>

      {/* FAQ */}
      <div className="mt-20 max-w-3xl mx-auto">
        <h2 className="text-2xl font-bold text-center mb-8">
          คำถามที่พบบ่อย
        </h2>
        <div className="space-y-6">
          {[
            {
              q: "ข้อสอบฟรีดูเฉลยได้ไหม?",
              a: "ข้อสอบที่ระบุว่าฟรี สามารถดูทั้งโจทย์และเฉลยได้โดยไม่ต้องสมัครสมาชิก แต่จำกัดจำนวน 2 ข้อต่อเดือน",
            },
            {
              q: "สมัครแล้วยกเลิกได้ไหม?",
              a: "ได้เลย คุณสามารถยกเลิกได้ทุกเมื่อ สมาชิกจะยังคงใช้งานได้จนกว่าจะหมดรอบบิล",
            },
            {
              q: "ชุดข้อสอบ 10 ข้อ มีวันหมดอายุไหม?",
              a: "ไม่มีวันหมดอายุ คุณเลือก 10 ข้อสอบที่ต้องการได้เลย ดูเฉลยได้ตลอด",
            },
            {
              q: "มีข้อสอบเพิ่มบ่อยแค่ไหน?",
              a: "เราเพิ่มข้อสอบใหม่ทุกสัปดาห์ ครอบคลุมทั้ง 6 สาขาวิชาหลัก",
            },
          ].map((faq) => (
            <div key={faq.q} className="border rounded-lg p-5">
              <h3 className="font-semibold">{faq.q}</h3>
              <p className="mt-2 text-sm text-muted-foreground">{faq.a}</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
