import type { Metadata } from "next";
import PricingContent from "@/components/PricingContent";

export const metadata: Metadata = {
  title: "แพ็กเกจราคา — เริ่มต้นฟรี | รู้ก่อนดี(รู้งี้)",
  description:
    "เลือกแพ็กเกจเตรียมสอบที่เหมาะกับคุณ เริ่มต้นฟรี หรือสมัครสมาชิกเข้าถึงทุกอย่างไม่จำกัด ข้อสอบ MEQ + MCQ + Long Case",
  alternates: { canonical: "https://www.morroo.com/pricing" },
  openGraph: {
    title: "แพ็กเกจราคา — รู้ก่อนดี(รู้งี้)",
    description:
      "เริ่มต้นฟรี หรือสมัครสมาชิกเข้าถึงข้อสอบ MEQ + MCQ + Long Case ไม่จำกัด",
    url: "https://www.morroo.com/pricing",
  },
};

export default function PricingPage() {
  return <PricingContent />;
}
