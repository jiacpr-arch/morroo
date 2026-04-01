import PricingCard from "@/components/PricingCard";
import { FREE_PLAN, BUNDLE_PLAN, SINGLE_PLANS, FULL_PLANS } from "@/lib/types";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "แพ็กเกจราคา — หมอรู้",
  description: "เลือกเฉพาะที่ต้องการ MCQ, MEQ, Long Case หรือครบทุกอย่าง",
};

export default function PricingPage() {
  return (
    <div className="mx-auto max-w-6xl px-4 py-16 sm:px-6 lg:px-8">
      <div className="text-center mb-4">
        <h1 className="text-3xl sm:text-4xl font-bold">แพ็กเกจราคา</h1>
        <p className="mt-3 text-lg text-muted-foreground max-w-2xl mx-auto">
          MCQ, MEQ และ Long Case เป็นการสอบคนละใบ — เลือกเตรียมเฉพาะที่ต้องการได้เลย
        </p>
        <p className="mt-2 text-sm text-brand font-medium">
          ราคา Launch พิเศษ — ประหยัดสูงสุด 33%
        </p>
      </div>

      {/* Single subject plans */}
      <div className="mb-14 mt-12">
        <div className="text-center mb-6">
          <h2 className="text-xl font-bold">เตรียมสอบเฉพาะวิชา</h2>
          <p className="text-sm text-muted-foreground mt-1">
            เหมาะสำหรับนักเรียนแพทย์ที่เตรียมสอบแค่วิชาเดียวในช่วงนั้น
          </p>
        </div>
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-6 items-start">
          {SINGLE_PLANS.map((plan) => (
            <PricingCard key={plan.type} {...plan} />
          ))}
        </div>
      </div>

      {/* Full plans */}
      <div className="border-t pt-14 mb-14">
        <div className="text-center mb-6">
          <h2 className="text-xl font-bold">Full Access — ครบทุกอย่าง</h2>
          <p className="text-sm text-muted-foreground mt-1">
            MCQ + MEQ + Long Case ในแพ็กเกจเดียว คุ้มกว่าซื้อแยก
          </p>
        </div>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-6 max-w-2xl mx-auto items-start">
          {FULL_PLANS.map((plan) => (
            <PricingCard key={plan.type} {...plan} />
          ))}
        </div>
      </div>

      {/* Free + Bundle */}
      <div className="border-t pt-14 mb-14">
        <div className="text-center mb-6">
          <h2 className="text-xl font-bold">ทดลองก่อน</h2>
          <p className="text-sm text-muted-foreground mt-1">
            ลองใช้ฟรีหรือซื้อชุด MCQ เพื่อทดสอบก่อนสมัคร
          </p>
        </div>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-6 max-w-2xl mx-auto items-start">
          <PricingCard {...FREE_PLAN} />
          <PricingCard {...BUNDLE_PLAN} />
        </div>
      </div>

      {/* Comparison table */}
      <div className="border-t pt-14 mb-14 overflow-x-auto">
        <h2 className="text-xl font-bold text-center mb-6">เปรียบเทียบแพ็กเกจ</h2>
        <table className="w-full text-sm text-center border-collapse">
          <thead>
            <tr className="border-b">
              <th className="text-left py-3 pr-4 font-semibold">แพ็กเกจ</th>
              <th className="py-3 px-3">ราคา</th>
              <th className="py-3 px-3">MCQ</th>
              <th className="py-3 px-3">MEQ</th>
              <th className="py-3 px-3">Long Case</th>
              <th className="py-3 px-3">อายุ</th>
            </tr>
          </thead>
          <tbody className="divide-y">
            <tr className="text-muted-foreground">
              <td className="text-left py-3 pr-4 font-medium">ฟรี</td>
              <td>฿0</td>
              <td>5 ข้อ/สาขา</td>
              <td>2 เคส</td>
              <td>1 เคส</td>
              <td>—</td>
            </tr>
            <tr>
              <td className="text-left py-3 pr-4 font-medium">Bundle</td>
              <td>฿99</td>
              <td>20 ข้อ</td>
              <td>5 เคส</td>
              <td>2 เคส</td>
              <td>30 วัน</td>
            </tr>
            <tr className="bg-muted/30">
              <td className="text-left py-3 pr-4 font-medium">MCQ</td>
              <td><span className="line-through text-muted-foreground text-xs mr-1">฿149</span>฿99/เดือน</td>
              <td>✅ ไม่จำกัด</td>
              <td>❌</td>
              <td>❌</td>
              <td>30 วัน</td>
            </tr>
            <tr className="bg-muted/30">
              <td className="text-left py-3 pr-4 font-medium">MEQ</td>
              <td><span className="line-through text-muted-foreground text-xs mr-1">฿149</span>฿99/เดือน</td>
              <td>❌</td>
              <td>✅ ไม่จำกัด</td>
              <td>❌</td>
              <td>30 วัน</td>
            </tr>
            <tr className="bg-muted/30">
              <td className="text-left py-3 pr-4 font-medium">Long Case</td>
              <td><span className="line-through text-muted-foreground text-xs mr-1">฿149</span>฿99/เดือน</td>
              <td>❌</td>
              <td>❌</td>
              <td>✅ ไม่จำกัด</td>
              <td>30 วัน</td>
            </tr>
            <tr className="border-brand/30">
              <td className="text-left py-3 pr-4 font-medium text-brand">Full รายเดือน</td>
              <td className="text-brand font-semibold"><span className="line-through text-muted-foreground text-xs mr-1">฿299</span>฿199/เดือน</td>
              <td>✅ ไม่จำกัด</td>
              <td>✅ ไม่จำกัด</td>
              <td>✅ ไม่จำกัด</td>
              <td>30 วัน</td>
            </tr>
            <tr>
              <td className="text-left py-3 pr-4 font-medium text-brand">Full รายปี</td>
              <td className="text-brand font-semibold"><span className="line-through text-muted-foreground text-xs mr-1">฿2,388</span>฿1,490/ปี</td>
              <td>✅ ไม่จำกัด</td>
              <td>✅ ไม่จำกัด</td>
              <td>✅ ไม่จำกัด</td>
              <td>365 วัน</td>
            </tr>
          </tbody>
        </table>
      </div>

      {/* FAQ */}
      <div className="max-w-3xl mx-auto">
        <h2 className="text-2xl font-bold text-center mb-8">คำถามที่พบบ่อย</h2>
        <div className="space-y-6">
          {[
            {
              q: "MCQ, MEQ และ Long Case ต่างกันอย่างไร?",
              a: "MCQ คือข้อสอบแบบเลือกตอบ (NL1/NL2), MEQ คือข้อสอบเขียนตอบเชิงคลินิก, Long Case คือการสอบปากเปล่ากับ AI ที่รับบทผู้ป่วยและกรรมการ ทั้ง 3 เป็นการสอบคนละใบ ไม่พร้อมกัน",
            },
            {
              q: "ซื้อแค่วิชาเดียวได้ไหม?",
              a: "ได้เลย เลือกเฉพาะที่กำลังเตรียมสอบ ประหยัดกว่าซื้อครบ ถ้าอยากได้ทุกอย่างแนะนำ Full Plan",
            },
            {
              q: "ราคา Launch จะขึ้นเมื่อไหร่?",
              a: "ยังไม่มีกำหนด แต่เมื่อ content และ user base โตขึ้นจะค่อยๆ ปรับราคา คนที่สมัครช่วง launch จะได้ราคานี้ตลอด cycle นั้น",
            },
            {
              q: "ฟรีใช้ได้แค่ไหน?",
              a: "MCQ 5 ข้อต่อสาขา (เห็นเฉลยสั้น), MEQ 2 เคส (เห็น feedback สั้น), Long Case 1 เคส (ลองซักประวัติได้ แต่ไม่เห็นคะแนนละเอียด)",
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
