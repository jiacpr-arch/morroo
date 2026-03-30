import { Suspense } from "react";
import {
  getMcqSubjects,
  getMcqQuestions,
  getFreeAttemptsCount,
} from "@/lib/supabase/queries-mcq";
import McqPractice from "@/components/McqPractice";
import { Badge } from "@/components/ui/badge";
import Link from "next/link";
import { ArrowLeft } from "lucide-react";
import type { Metadata } from "next";
import { createClient } from "@/lib/supabase/server";
import type { Profile } from "@/lib/types";

export const metadata: Metadata = {
  title: "ฝึกทำข้อสอบ NL",
  description: "ฝึกทำข้อสอบ MCQ ใบประกอบวิชาชีพเวชกรรม",
};

const FREE_LIMIT = 5;

async function PracticeContent({ subjectId }: { subjectId?: string }) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  // Check premium status
  let isPremium = false;
  let freeUsedCount = 0;

  if (user) {
    const { data: profile } = await supabase
      .from("users")
      .select("membership_type, membership_expires_at")
      .eq("id", user.id)
      .single();

    const p = profile as Pick<Profile, "membership_type" | "membership_expires_at"> | null;
    if (p) {
      const isExpired =
        p.membership_expires_at
          ? new Date(p.membership_expires_at) < new Date()
          : false;
      isPremium =
        (p.membership_type === "monthly" ||
          p.membership_type === "yearly" ||
          p.membership_type === "bundle") &&
        !isExpired;
    }

    if (!isPremium) {
      freeUsedCount = await getFreeAttemptsCount(user.id, subjectId);
    }
  }

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
        <McqPractice
          questions={questions}
          isPremium={isPremium}
          freeUsedCount={Math.min(freeUsedCount, FREE_LIMIT)}
          freeLimit={FREE_LIMIT}
        />
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
