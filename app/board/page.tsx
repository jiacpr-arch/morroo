import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { ArrowLeft, GraduationCap } from "lucide-react";
import { getBoardSpecialties } from "@/lib/supabase/queries-board";
import BoardSpecialtyCard from "@/components/BoardSpecialtyCard";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "เตรียมสอบบอร์ดเฉพาะทาง (วว.) ทุกราชวิทยาลัย",
  description:
    "ฝึกข้อสอบ MCQ สำหรับสอบบอร์ดวุฒิบัตร (วว./Diplomate of Thai Board) ทุกราชวิทยาลัยฯ พร้อม Blueprint สอบจริง — เริ่มต้นที่เวชศาสตร์ฉุกเฉิน",
  alternates: { canonical: "https://www.morroo.com/board" },
  openGraph: {
    title: "เตรียมสอบบอร์ดเฉพาะทาง — หมอรู้",
    description:
      "ฝึกข้อสอบ MCQ สำหรับสอบบอร์ดวุฒิบัตรเฉพาะทาง ครบทุกราชวิทยาลัยฯ",
    url: "https://www.morroo.com/board",
  },
};

export const revalidate = 300;

export default async function BoardPage() {
  const specialties = await getBoardSpecialties();
  const publishedCount = specialties.filter((s) => s.is_published).length;

  return (
    <div className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="mb-8">
        <Link
          href="/"
          className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-brand mb-4"
        >
          <ArrowLeft className="h-4 w-4" /> กลับหน้าแรก
        </Link>
        <div className="flex items-center gap-2 mb-2">
          <Badge className="bg-purple-100 text-purple-700 gap-1">
            <GraduationCap className="h-3 w-3" />
            Board Exam
          </Badge>
          <Badge variant="secondary">
            {publishedCount} / {specialties.length} สาขา เปิดแล้ว
          </Badge>
        </div>
        <h1 className="text-3xl font-bold">
          เตรียมสอบบอร์ดเฉพาะทาง
        </h1>
        <p className="mt-2 text-muted-foreground max-w-2xl">
          ฝึกข้อสอบ MCQ ตาม Blueprint จริงของแต่ละราชวิทยาลัยฯ —
          ทบทวนหัวข้อตรงโครงสอบ ปรับคะแนนตามจุดอ่อนของตัวเอง
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {specialties.map((s) => (
          <BoardSpecialtyCard key={s.slug} specialty={s} />
        ))}
      </div>

      {specialties.length === 0 && (
        <div className="text-center py-16 text-muted-foreground">
          ยังไม่มีสาขาที่เปิดให้บริการ
        </div>
      )}

      <div className="mt-12 rounded-lg border bg-muted/30 p-5 text-sm text-muted-foreground">
        <p>
          <strong className="text-foreground">หมายเหตุ:</strong> ปัจจุบันเปิดให้ฝึกเฉพาะ
          เวชศาสตร์ฉุกเฉิน (EM) — สาขาอื่นกำลังจัดทำเนื้อหา หากสนใจใช้งานก่อนเปิดทั่วไป
          ติดต่อทีมงานได้ที่{" "}
          <Link href="/contact" className="text-brand hover:underline">
            หน้าติดต่อ
          </Link>
        </p>
      </div>
    </div>
  );
}
