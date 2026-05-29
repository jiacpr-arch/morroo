import Link from "next/link";
import type { Metadata } from "next";
import { Clock, ArrowRight } from "lucide-react";
import { GUIDES } from "@/lib/guides";

export const revalidate = 3600;

export const metadata: Metadata = {
  title: "บทเรียน — คู่มือเตรียมสอบแพทย์ MEQ · NL · Long Case",
  description:
    "รวมบทเรียนฟรีจากหมอรู้ ตั้งแต่วิธีอ่าน MEQ Progressive Case วิธีฝึก Long Case ด้วย AI ไปจนถึงตารางอ่าน 8 สัปดาห์เตรียมสอบ NL Step 3",
  alternates: { canonical: "https://www.morroo.com/learn" },
  openGraph: {
    title: "บทเรียนเตรียมสอบแพทย์ฟรี — หมอรู้",
    description:
      "คู่มือสรุปวิธีอ่าน เทคนิคทำข้อสอบ และตารางเตรียมตัวสำหรับ NL Step 3",
    url: "https://www.morroo.com/learn",
  },
};

export default function LearnIndexPage() {
  return (
    <div className="mx-auto max-w-4xl px-4 py-10 sm:px-6 sm:py-12">
      <header className="mb-10">
        <h1 className="text-3xl sm:text-4xl font-bold">บทเรียนเตรียมสอบแพทย์</h1>
        <p className="mt-3 text-lg text-muted-foreground">
          บทเรียนฟรีจากหมอรู้ — สรุปวิธีอ่าน เทคนิคทำข้อสอบ และตารางเตรียมตัว
        </p>
      </header>

      <div className="grid grid-cols-1 sm:grid-cols-2 gap-5">
        {GUIDES.map((g) => (
          <Link
            key={g.slug}
            href={`/learn/${g.slug}`}
            className="group flex flex-col gap-3 rounded-2xl border bg-card p-5 hover:border-brand/30 hover:shadow-md transition-all"
          >
            <div className="flex items-center gap-2 text-xs text-muted-foreground">
              <Clock className="h-3 w-3" /> อ่าน {g.readingMinutes} นาที
            </div>
            <h2 className="text-lg font-bold group-hover:text-brand transition-colors">
              {g.title}
            </h2>
            <p className="text-sm text-muted-foreground line-clamp-3 flex-1">
              {g.intro}
            </p>
            <div className="text-sm font-medium text-brand inline-flex items-center gap-1">
              อ่านต่อ <ArrowRight className="h-3 w-3" />
            </div>
          </Link>
        ))}
      </div>
    </div>
  );
}
