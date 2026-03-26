import { Suspense } from "react";
import { getMcqSubjects, getMcqQuestions } from "@/lib/supabase/queries-mcq";
import McqPractice from "@/components/McqPractice";
import { Badge } from "@/components/ui/badge";
import Link from "next/link";
import { ArrowLeft } from "lucide-react";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "ฝึกทำข้อสอบ NL",
  description: "ฝึกทำข้อสอบ MCQ ใบประกอบวิชาชีพเวชกรรม",
};

async function PracticeContent({ subjectId }: { subjectId?: string }) {
  const [subjects, questions] = await Promise.all([
    getMcqSubjects(),
    getMcqQuestions({
      subjectId,
      examType: "NL2",
      limit: 200,
      randomize: true,
    }),
  ]);

  const currentSubject = subjectId
    ? subjects.find((s) => s.id === subjectId)
    : null;

  return (
    <div>
      {/* Subject Filter */}
      <div className="mb-6">
        <h3 className="text-sm font-medium mb-2 text-muted-foreground">
          เลือกสาขา
        </h3>
        <div className="flex flex-wrap gap-2">
          <Link href="/nl/practice">
            <Badge
              variant={!subjectId ? "default" : "secondary"}
              className={`cursor-pointer ${
                !subjectId ? "bg-brand text-white" : "hover:bg-brand/10"
              }`}
            >
              คละทุกสาขา
            </Badge>
          </Link>
          {subjects.map((subject) => (
            <Link
              key={subject.id}
              href={`/nl/practice?subject=${subject.id}`}
            >
              <Badge
                variant={subjectId === subject.id ? "default" : "secondary"}
                className={`cursor-pointer ${
                  subjectId === subject.id
                    ? "bg-brand text-white"
                    : "hover:bg-brand/10"
                }`}
              >
                {subject.icon} {subject.name_th}
              </Badge>
            </Link>
          ))}
        </div>
      </div>

      {/* Info */}
      <div className="mb-6 text-sm text-muted-foreground">
        {currentSubject ? (
          <span>
            {currentSubject.icon} {currentSubject.name_th} — {questions.length}{" "}
            ข้อ
          </span>
        ) : (
          <span>คละทุกสาขา — {questions.length} ข้อ</span>
        )}
      </div>

      {/* Practice Component */}
      {questions.length > 0 ? (
        <McqPractice questions={questions} />
      ) : (
        <div className="text-center py-16 text-muted-foreground">
          <p className="text-lg">ยังไม่มีข้อสอบในสาขานี้</p>
          <Link
            href="/nl/practice"
            className="text-brand hover:underline mt-2 inline-block"
          >
            ดูสาขาอื่น
          </Link>
        </div>
      )}
    </div>
  );
}

export default async function PracticePage({
  searchParams,
}: {
  searchParams: Promise<{ subject?: string }>;
}) {
  const params = await searchParams;
  const { subject } = params;

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
        <h1 className="text-2xl font-bold">ฝึกทำข้อสอบ NL</h1>
        <p className="text-muted-foreground text-sm mt-1">
          เลือกตอบแล้วดูเฉลยทันที
        </p>
      </div>

      <Suspense
        fallback={<div className="text-center py-8">กำลังโหลดข้อสอบ...</div>}
      >
        <PracticeContent subjectId={subject} />
      </Suspense>
    </div>
  );
}
