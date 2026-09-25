import { Suspense } from "react";
import { getExams, getExamPartCounts, sortExamsAvailableFirst } from "@/lib/supabase/queries";
import AllExamsCountdown from "@/components/AllExamsCountdown";
import InternalAdsBanner from "@/components/InternalAdsBanner";
import { LineCtaButton } from "@/components/SocialLinks";
import LandingPageTracker from "@/components/LandingPageTracker";
import SectionUpdatesBadge from "@/components/SectionUpdatesBadge";
import type { Metadata } from "next";
import ExamsFilterList from "@/components/ExamsFilterList";

export const metadata: Metadata = {
  title: "ข้อสอบ MEQ ออนไลน์ — ฝึกสอบแพทย์ Progressive Case",
  description:
    "ฝึกทำข้อสอบ MEQ แบบ Progressive Case 6 ตอน ครอบคลุม 6 สาขาหลัก อายุรศาสตร์ ศัลยศาสตร์ กุมารฯ สูติฯ ออร์โธฯ จิตเวช พร้อมเฉลยละเอียดและ AI ตรวจคำตอบ",
  alternates: { canonical: "https://www.morroo.com/exams" },
  openGraph: {
    title: "ข้อสอบ MEQ ออนไลน์ — หมอรู้",
    description:
      "ฝึกทำข้อสอบ MEQ แบบ Progressive Case 6 ตอน ครอบคลุม 6 สาขาหลัก พร้อมเฉลยละเอียดและ AI ตรวจคำตอบ",
    url: "https://www.morroo.com/exams",
  },
};

const courseSchema = {
  "@context": "https://schema.org",
  "@type": "Course",
  name: "ข้อสอบ MEQ ออนไลน์ — หมอรู้",
  description:
    "ข้อสอบ MEQ แบบ Progressive Case สำหรับเตรียมสอบใบประกอบวิชาชีพแพทย์",
  provider: {
    "@type": "EducationalOrganization",
    name: "หมอรู้ (MorRoo)",
    url: "https://www.morroo.com",
  },
  offers: {
    "@type": "Offer",
    price: "199",
    priceCurrency: "THB",
    availability: "https://schema.org/InStock",
  },
  educationalLevel: "Medical Student / Physician",
  inLanguage: "th",
};

// ISR: ห้ามอ่าน searchParams/cookies ใน server component ไม่งั้นหน้านี้จะกลายเป็น
// dynamic และ revalidate ไม่มีผล — ตัวกรองทั้งสามอยู่ใน ExamsFilterList (client)
export const revalidate = 60;

export default async function ExamsPage() {
  const [allExams, partCounts] = await Promise.all([getExams(), getExamPartCounts()]);
  const exams = sortExamsAvailableFirst(allExams, partCounts);

  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(courseSchema) }}
      />
    <div className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
      <LandingPageTracker event="exams_list_view" />
      <div className="mb-8 flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 className="text-3xl font-bold">ข้อสอบทั้งหมด</h1>
          <p className="mt-2 text-muted-foreground">
            เลือกข้อสอบที่ต้องการฝึก
          </p>
          <SectionUpdatesBadge section="exams" className="mt-3" />
        </div>
        <LineCtaButton
          surface="exams"
          label="แอด LINE รับข้อสอบฟรีทุกเช้า"
          className="shrink-0 self-start sm:self-auto"
        />
      </div>

      {/* Exam Countdown */}
      <div className="mb-8">
        <AllExamsCountdown />
      </div>

      <InternalAdsBanner placement="exams-top" className="mb-8" />

      <Suspense fallback={<div className="text-center py-8">กำลังโหลด...</div>}>
        <ExamsFilterList exams={exams} partCounts={partCounts} />
      </Suspense>
    </div>
    </>
  );
}
