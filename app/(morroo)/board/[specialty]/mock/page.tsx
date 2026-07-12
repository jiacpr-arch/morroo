import { notFound } from "next/navigation";
import Link from "next/link";
import { Suspense } from "react";
import { ArrowLeft, AlertTriangle, GraduationCap } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import {
  getBoardSpecialty,
  sampleBoardMock,
} from "@/lib/supabase/queries-board";
import McqMock from "@/components/McqMock";
import type { Metadata } from "next";

export async function generateMetadata({
  params,
}: {
  params: Promise<{ specialty: string }>;
}): Promise<Metadata> {
  const { specialty } = await params;
  const s = await getBoardSpecialty(specialty);
  if (!s) return { title: "ไม่พบสาขา" };
  return {
    title: `จำลองสอบบอร์ด${s.name_th} (Mock Exam)`,
    description: `จำลองสอบบอร์ดเฉพาะทาง${s.name_th} ตาม Blueprint จริง — จับเวลาเหมือนห้องสอบ`,
  };
}

// 1.2 min/q ตามสอบจริง EM board (200 ข้อ × 1.2 = 240 นาที = 4 ชม.)
const MINUTES_PER_QUESTION = 1.2;

async function MockContent({ specialty }: { specialty: string }) {
  const s = await getBoardSpecialty(specialty);
  if (!s) return notFound();

  if (!s.is_published) {
    return (
      <div className="text-center py-12 text-muted-foreground">
        สาขานี้ยังไม่เปิดให้สอบ —{" "}
        <Link href="/board" className="text-brand hover:underline">
          ดูสาขาที่เปิดแล้ว
        </Link>
      </div>
    );
  }

  const sample = await sampleBoardMock(specialty);

  if (sample.questions.length === 0) {
    return (
      <div className="text-center py-16 text-muted-foreground">
        <p className="text-lg">ยังไม่มีข้อสอบในระบบสำหรับสาขานี้</p>
        <p className="text-sm mt-1">รอ content team หรือ AI generator เก็บสะสมข้อสอบก่อน</p>
        <Link
          href={`/board/${specialty}`}
          className="text-brand hover:underline mt-3 inline-block"
        >
          กลับหน้าสาขา
        </Link>
      </div>
    );
  }

  const timeLimitMinutes = Math.max(
    15,
    Math.ceil(sample.totalAvailable * MINUTES_PER_QUESTION)
  );
  const isShortOnContent = sample.totalAvailable < sample.totalTarget;

  return (
    <div>
      <div className="mb-4 flex flex-wrap items-center gap-2">
        <Badge className="bg-purple-100 text-purple-700 gap-1">
          <GraduationCap className="h-3 w-3" />
          {s.icon} {s.name_th}
        </Badge>
        <Badge variant="secondary">
          {sample.totalAvailable}/{sample.totalTarget} ข้อ
        </Badge>
        <Badge variant="secondary">{timeLimitMinutes} นาที</Badge>
      </div>

      {isShortOnContent && (
        <div className="mb-4 rounded-md border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-800 flex items-start gap-2">
          <AlertTriangle className="h-4 w-4 mt-0.5 shrink-0" />
          <div>
            <div className="font-medium">ข้อสอบยังไม่ครบ Blueprint</div>
            <div className="text-xs mt-0.5">
              ระบบยังมี {sample.totalAvailable}/{sample.totalTarget} ข้อ —
              ยังเก็บสะสมข้อสอบในบางหมวด ลองอีกครั้งในไม่กี่วัน
            </div>
            <details className="mt-2">
              <summary className="cursor-pointer text-xs underline">
                ดูรายละเอียดตาม section
              </summary>
              <ul className="mt-1 space-y-0.5 text-xs">
                {sample.bySection.map((sec) => (
                  <li key={sec.section_code}>
                    <span className="font-medium">{sec.section_label_th}:</span>{" "}
                    {sec.available}/{sec.target}
                  </li>
                ))}
              </ul>
            </details>
          </div>
        </div>
      )}

      <McqMock
        questions={sample.questions}
        timeLimitMinutes={timeLimitMinutes}
      />
    </div>
  );
}

export default async function BoardMockPage({
  params,
}: {
  params: Promise<{ specialty: string }>;
}) {
  const { specialty } = await params;

  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="mb-6">
        <Link
          href={`/board/${specialty}`}
          className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-brand mb-4"
        >
          <ArrowLeft className="h-4 w-4" /> กลับหน้าสาขา
        </Link>
        <h1 className="text-2xl font-bold">จำลองสอบ Board (Mock Exam)</h1>
        <p className="text-muted-foreground text-sm mt-1">
          สุ่มข้อสอบตาม Blueprint จริง จับเวลาเหมือนห้องสอบ เฉลยตอนจบ
        </p>
      </div>

      <Suspense
        fallback={<div className="text-center py-8">กำลังสุ่มข้อสอบ...</div>}
      >
        <MockContent specialty={specialty} />
      </Suspense>
    </div>
  );
}
