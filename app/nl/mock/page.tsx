import { Suspense } from "react";
import { getMcqQuestions } from "@/lib/supabase/queries-mcq";
import McqMock from "@/components/McqMock";
import Link from "next/link";
import { ArrowLeft } from "lucide-react";
import type { Metadata } from "next";
import MockSetup from "./MockSetup";

export const metadata: Metadata = {
  title: "จำลองสอบ MCQ — Mock Exam",
  description: "จำลองสอบ MCQ ใบประกอบวิชาชีพเวชกรรม คละทุกสาขา จับเวลา",
};

async function MockExamContent({ count }: { count: number }) {
  const questions = await getMcqQuestions({
    examType: "NL2",
    limit: count,
    randomize: true,
  });

  const timeLimitMinutes = count; // 1 min per question

  if (questions.length === 0) {
    return (
      <div className="text-center py-16 text-muted-foreground">
        <p className="text-lg">ยังไม่มีข้อสอบในระบบ</p>
        <Link
          href="/nl"
          className="text-brand hover:underline mt-2 inline-block"
        >
          กลับหน้า NL
        </Link>
      </div>
    );
  }

  const actualCount = Math.min(count, questions.length);

  return (
    <McqMock
      questions={questions.slice(0, actualCount)}
      timeLimitMinutes={timeLimitMinutes}
    />
  );
}

export default async function MockPage({
  searchParams,
}: {
  searchParams: Promise<{ count?: string }>;
}) {
  const params = await searchParams;
  const countParam = params.count;
  const validCounts = [20, 50, 100];
  const count = countParam && validCounts.includes(Number(countParam))
    ? Number(countParam)
    : null;

  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      {/* Header */}
      <div className="mb-6">
        <Link
          href="/nl"
          className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-brand mb-4"
        >
          <ArrowLeft className="h-4 w-4" /> กลับหน้า NL
        </Link>
        <h1 className="text-2xl font-bold">จำลองสอบ NL (Mock Exam)</h1>
        <p className="text-muted-foreground text-sm mt-1">
          สุ่มข้อคละทุกสาขา จับเวลาเหมือนสอบจริง เฉลยตอนจบ
        </p>
      </div>

      {count ? (
        <Suspense
          fallback={
            <div className="text-center py-8">กำลังโหลดข้อสอบ...</div>
          }
        >
          <MockExamContent count={count} />
        </Suspense>
      ) : (
        <MockSetup />
      )}
    </div>
  );
}
