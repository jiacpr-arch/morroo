import PricingCard from "@/components/PricingCard";
import { PRICING_PLANS, MCQ_ONLY_PLANS, MEQ_ONLY_PLANS } from "@/lib/types";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "แพ็กเกจราคา",
  description: "เลือกแพ็กเกจที่เหมาะกับคุณ — MCQ, MEQ, หรือครบทั้งหมดรวม Long Case",
};

export default function PricingPage() {
  return (
    <div className="mx-auto max-w-7xl px-4 py-16 sm:px-6 lg:px-8">
      <div className="text-center mb-12">
        <h1 className="text-3xl sm:text-4xl font-bold">แพ็กเกจราคา</h1>
        <p className="mt-3 text-lg text-muted-foreground max-w-xl mx-auto">
          เลือกเฉพาะที่ต้องการ — MCQ, MEQ, หรือครบทุกอย่างรวม Long Case
        </p>
      </div>

      {/* Full access plans */}
      <div className="mb-14">
        <h2 className="text-xl font-bold mb-2 text-center">แพ็กเกจครบ (MCQ + MEQ + Long Case)</h2>
        <p className="text-sm text-muted-foreground text-center mb-6">เข้าถึงทุกอย่างในแพลตฟอร์ม</p>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 items-start">
          {PRICING_PLANS.map((plan) => (
            <PricingCard key={plan.name} {...plan} />
          ))}
        </div>
      </div>

      <div className="border-t pt-14 mb-14">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-12">
          {/* MCQ-only plans */}
          <div>
            <h2 className="text-xl font-bold mb-2 text-center">เฉพาะ MCQ</h2>
            <p className="text-sm text-muted-foreground text-center mb-6">
              ข้อสอบ MCQ ไม่จำกัด ราคาประหยัด — ไม่รวม MEQ และ Long Case
            </p>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              {MCQ_ONLY_PLANS.map((plan) => (
                <PricingCard key={plan.name} {...plan} />
              ))}
            </div>
          </div>

          {/* MEQ-only plans */}
          <div>
            <h2 className="text-xl font-bold mb-2 text-center">เฉพาะ MEQ</h2>
            <p className="text-sm text-muted-foreground text-center mb-6">
              ข้อสอบ MEQ ไม่จำกัด ราคาประหยัด — ไม่รวม MCQ และ Long Case
            </p>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              {MEQ_ONLY_PLANS.map((plan) => (
                <PricingCard key={plan.name} {...plan} />
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* FAQ */}
      <div className="mt-4 max-w-3xl mx-auto">
        <h2 className="text-2xl font-bold text-center mb-8">
          คำถามที่พบบ่อย
        </h2>
        <div className="space-y-6">
          {[
            {
              q: "MCQ กับ MEQ ต่างกันอย่างไร?",
              a: "MCQ คือข้อสอบแบบเลือกตอบ (Multiple Choice) MEQ คือข้อสอบเขียนตอบเชิงคลินิก (Modified Essay Questions) Long Case คือการสอบปากเปล่ากับ AI ที่รับบทผู้ป่วยและกรรมการ",
            },
            {
              q: "Long Case อยู่ในแพ็กเกจไหนบ้าง?",
              a: "Long Case รวมอยู่ในแพ็กเกจครบเท่านั้น (รายเดือนและรายปี) แพ็กเกจ MCQ-only และ MEQ-only ไม่รวม Long Case",
            },
            {
              q: "ข้อสอบฟรีดูเฉลยได้ไหม?",
              a: "ข้อสอบที่ระบุว่าฟรี สามารถดูทั้งโจทย์และเฉลยได้โดยไม่ต้องสมัครสมาชิก แต่จำกัดจำนวน 5 ข้อต่อสาขา",
            },
            {
              q: "สมัครแล้วยกเลิกได้ไหม?",
              a: "ได้เลย คุณสามารถยกเลิกได้ทุกเมื่อ สมาชิกจะยังคงใช้งานได้จนกว่าจะหมดรอบบิล",
            },
            {
              q: "ชุดข้อสอบ 10 ข้อ มีวันหมดอายุไหม?",
              a: "ไม่มีวันหมดอายุ คุณเลือก MCQ 10 ข้อที่ต้องการได้เลย ดูเฉลยได้ตลอด",
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
