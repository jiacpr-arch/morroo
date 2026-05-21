import PricingCard from "@/components/PricingCard";
import { PRICING_PLANS, BOARD_PRICING_PLANS } from "@/lib/types";
import { GraduationCap, Mic } from "lucide-react";
import type { Metadata } from "next";

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

      {/* FAQ */}
      <div className="max-w-3xl mx-auto">
        <h2 className="text-2xl font-bold text-center mb-8">
          คำถามที่พบบ่อย
        </h2>
        <div className="space-y-6">
          {[
            {
              q: "แพ็ก นศพ. และ Board ต่างกันยังไง?",
              a: "แพ็ก นศพ. เหมาะกับ extern/intern ที่เตรียมสอบ NL Step 2 มีคลัง MCQ NL + MEQ + Long Case แพ็ก Board เหมาะกับแพทย์ที่กำลังสอบวุฒิบัตรเฉพาะทาง มีคลัง MCQ ตาม Blueprint ของราชวิทยาลัยฯ + Oral Exam แบบสอบจริง",
            },
            {
              q: "ซื้อทั้ง 2 แพ็กได้ไหม?",
              a: "ได้เลย ระบบรองรับการถือสมาชิกหลายแพ็กพร้อมกัน เหมาะกับช่วงเปลี่ยนผ่าน intern → ก่อนสอบบอร์ด",
            },
            {
              q: "ข้อสอบฟรีดูเฉลยได้ไหม?",
              a: "ข้อสอบที่ระบุว่าฟรี สามารถดูทั้งโจทย์และเฉลยได้โดยไม่ต้องสมัครสมาชิก แต่จำกัดจำนวน 2 ข้อต่อเดือน",
            },
            {
              q: "สมัครแล้วยกเลิกได้ไหม?",
              a: "ได้เลย คุณสามารถยกเลิกได้ทุกเมื่อ สมาชิกจะยังคงใช้งานได้จนกว่าจะหมดรอบบิล",
            },
            {
              q: "Oral Exam คือยังไง?",
              a: "เป็นการ present long case ต่อ AI examiner (อ.บอร์ด) ที่จำลองสไตล์อาจารย์สอบจริง challenge ด้วยคำถาม follow-up เชิงลึก อ้างอิงตำราหลักของสาขา (Tintinalli/Harrison/Nelson/Williams/ฯลฯ) แล้วให้คะแนน",
            },
            {
              q: "มีข้อสอบเพิ่มบ่อยแค่ไหน?",
              a: "เราเพิ่มข้อสอบ MCQ ใหม่ทุกวันผ่าน AI generator + เคส Oral ใหม่ทุกวันหมุนเวียนทุกสาขา",
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
