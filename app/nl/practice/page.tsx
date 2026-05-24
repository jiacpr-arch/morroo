import { Suspense } from "react";
import {
  getMcqSubjects,
  getMcqQuestions,
  getFreeAttemptsCount,
} from "@/lib/supabase/queries-mcq";
import McqPractice from "@/components/McqPractice";
import InternalAdsBanner from "@/components/InternalAdsBanner";
import { Badge } from "@/components/ui/badge";
import Link from "next/link";
import { ArrowLeft, Sparkles } from "lucide-react";
import type { Metadata } from "next";
import { createClient } from "@/lib/supabase/server";
import type { Profile } from "@/lib/types";
import { computeBetaStatus } from "@/lib/beta";
import { getRecommendedQuestions } from "@/lib/mcq-recommendation";
import type { McqQuestion, McqSubject } from "@/lib/types-mcq";

export const metadata: Metadata = {
  title: "ฝึกทำข้อสอบ NL",
  description: "ฝึกทำข้อสอบ MCQ ใบประกอบวิชาชีพเวชกรรม",
};

const FREE_LIMIT = 5;

// Default-visible chips are the 4 หมวดหลัก of NL2: เด็ก / ศัลย์ / สูติ /
// อายุรกรรม. The first three map to a single mcq_subjects row;
// "อายุรกรรม" is a virtual category that bundles the internal-medicine
// sub-specialty rows (no umbrella row exists in the table).
const MAIN_SUBJECT_NAMES = ["ped", "surgery", "ob_gyn"] as const;
const INTERNAL_MED_SUBJECT_NAMES = [
  "cardio_med",
  "chest_med",
  "gi_med",
  "nephro_med",
  "hemato_med",
  "infectious_med",
  "neuro_med",
  "endocrine",
] as const;
const INTERNAL_MED_CATEGORY = "internal_med";

async function PracticeContent({
  subjectId,
  category,
  recommended,
}: {
  subjectId?: string;
  category?: string;
  recommended?: boolean;
}) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  // Check premium status
  let isPremium = false;
  let freeUsedCount = 0;

  if (user) {
    const { data: profile } = await supabase
      .from("profiles")
      .select(
        "membership_type, membership_expires_at, beta_enrolled_via, beta_started_at, beta_expires_at, beta_questions_used, beta_questions_limit, has_seen_beta_welcome, beta_coupon_code, beta_coupon_issued_at"
      )
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
      // Beta testers get a 25-question quota tracked on the profile row
      // (DB trigger). The legacy per-subject 5-free cap only applies to
      // plain-free users.
      const beta = computeBetaStatus(profile as Partial<Profile> as Profile | null);
      if (beta.isBeta) {
        freeUsedCount = 0;
      } else {
        freeUsedCount = await getFreeAttemptsCount(user.id, subjectId);
      }
    }
  }

  // Recommended mode requires a signed-in user with history. Fall back
  // to the normal random pool otherwise.
  const useRecommended = recommended && !!user;

  const allNl2Subjects = await getMcqSubjects("NL2");
  // Hide subjects that have no questions yet — there's nothing to practice
  // and an empty selection just confuses the user.
  const subjects = allNl2Subjects.filter((s) => s.question_count > 0);
  const mainSingles = MAIN_SUBJECT_NAMES.map((name) =>
    subjects.find((s) => s.name === name)
  ).filter((s): s is McqSubject => !!s);
  const mainSingleIds = new Set(mainSingles.map((s) => s.id));
  const internalMedSubjects = subjects.filter((s) =>
    (INTERNAL_MED_SUBJECT_NAMES as readonly string[]).includes(s.name)
  );
  const internalMedIds = internalMedSubjects.map((s) => s.id);
  const otherSubjects = subjects.filter(
    (s) =>
      !mainSingleIds.has(s.id) &&
      !(INTERNAL_MED_SUBJECT_NAMES as readonly string[]).includes(s.name)
  );
  const isInternalMed = category === INTERNAL_MED_CATEGORY;
  const otherSelected =
    !!subjectId && otherSubjects.some((s) => s.id === subjectId);

  let questions: McqQuestion[];
  let recBreakdown: Awaited<ReturnType<typeof getRecommendedQuestions>>["breakdown"] | null = null;

  if (useRecommended && user) {
    const rec = await getRecommendedQuestions(supabase, user.id, {
      examType: "NL2",
      limit: 20,
    });
    questions = rec.questions;
    recBreakdown = rec.breakdown;
  } else if (isInternalMed) {
    questions = await getMcqQuestions({
      subjectIds: internalMedIds,
      examType: "NL2",
      limit: 200,
      randomize: true,
    });
  } else {
    questions = await getMcqQuestions({
      subjectId,
      examType: "NL2",
      limit: 200,
      randomize: true,
    });
  }

  const currentSubject = subjectId
    ? allNl2Subjects.find((s) => s.id === subjectId)
    : null;

  return (
    <div>
      <InternalAdsBanner placement="practice-top" className="mb-4" />

      {/* Recommended banner */}
      {useRecommended && recBreakdown && (
        <div className="mb-6 rounded-xl border border-brand/30 bg-gradient-to-r from-brand/5 to-amber-50/60 px-4 py-3">
          <div className="flex items-center gap-2 mb-1">
            <Sparkles className="h-4 w-4 text-brand" />
            <span className="text-sm font-semibold text-brand">
              โหมดแนะนำ — จัดชุดให้ตามผลการเรียนของคุณ
            </span>
          </div>
          <p className="text-xs text-muted-foreground">
            {recBreakdown.review > 0 && <>ทบทวนข้อที่เคยผิด {recBreakdown.review} ข้อ · </>}
            {recBreakdown.weak > 0 && <>สาขาที่ควรเสริม {recBreakdown.weak} ข้อ · </>}
            ข้อใหม่ {recBreakdown.filler} ข้อ
          </p>
          {recBreakdown.weakSubjects.length > 0 && (
            <div className="mt-2 flex flex-wrap gap-1.5">
              {recBreakdown.weakSubjects.slice(0, 4).map((s) => (
                <span
                  key={s.subject_id}
                  className="inline-flex items-center gap-1 rounded-full bg-red-50 text-red-700 text-xs px-2 py-0.5 border border-red-100"
                >
                  {s.icon} {s.name_th} {s.accuracy}%
                </span>
              ))}
            </div>
          )}
        </div>
      )}

      {/* Mode toggle */}
      {user && (
        <div className="mb-4 flex flex-wrap gap-2">
          <Link href="/nl/practice?mode=recommended">
            <Badge
              variant={useRecommended ? "default" : "secondary"}
              className={`cursor-pointer gap-1 ${
                useRecommended ? "bg-brand text-white" : "hover:bg-brand/10"
              }`}
            >
              <Sparkles className="h-3 w-3" /> แนะนำให้คุณ
            </Badge>
          </Link>
          <Link href="/nl/practice">
            <Badge
              variant={!useRecommended ? "default" : "secondary"}
              className={`cursor-pointer ${
                !useRecommended ? "bg-brand text-white" : "hover:bg-brand/10"
              }`}
            >
              เลือกเอง
            </Badge>
          </Link>
        </div>
      )}

      {/* Subject Filter — hidden in recommended mode */}
      {!useRecommended && (
        <div className="mb-6">
          <h3 className="text-sm font-medium mb-2 text-muted-foreground">
            เลือกสาขา
          </h3>
          <div className="flex flex-wrap gap-2">
            <Link href="/nl/practice">
              <Badge
                variant={
                  !subjectId && !isInternalMed ? "default" : "secondary"
                }
                className={`cursor-pointer ${
                  !subjectId && !isInternalMed
                    ? "bg-brand text-white"
                    : "hover:bg-brand/10"
                }`}
              >
                คละทุกสาขา
              </Badge>
            </Link>
            {mainSingles.map((subject) => (
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
            {internalMedIds.length > 0 && (
              <Link href={`/nl/practice?category=${INTERNAL_MED_CATEGORY}`}>
                <Badge
                  variant={isInternalMed ? "default" : "secondary"}
                  className={`cursor-pointer ${
                    isInternalMed ? "bg-brand text-white" : "hover:bg-brand/10"
                  }`}
                >
                  🩺 อายุรกรรม
                </Badge>
              </Link>
            )}
          </div>
          {otherSubjects.length > 0 && (
            <details className="mt-2 group" open={otherSelected}>
              <summary className="cursor-pointer list-none text-sm text-brand hover:underline inline-flex items-center gap-1 select-none">
                <span className="group-open:hidden">
                  + ดูสาขาอื่น ๆ ({otherSubjects.length})
                </span>
                <span className="hidden group-open:inline">− ซ่อนสาขาอื่น</span>
              </summary>
              <div className="flex flex-wrap gap-2 mt-2">
                {otherSubjects.map((subject) => (
                  <Link
                    key={subject.id}
                    href={`/nl/practice?subject=${subject.id}`}
                  >
                    <Badge
                      variant={
                        subjectId === subject.id ? "default" : "secondary"
                      }
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
            </details>
          )}
        </div>
      )}

      {/* Info */}
      <div className="mb-6 text-sm text-muted-foreground">
        {useRecommended ? (
          <span>ชุดแนะนำ — {questions.length} ข้อ</span>
        ) : isInternalMed ? (
          <span>🩺 อายุรกรรม — {questions.length} ข้อ</span>
        ) : currentSubject ? (
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
          viaRecommendation={useRecommended}
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
  searchParams: Promise<{
    subject?: string;
    category?: string;
    mode?: string;
  }>;
}) {
  const params = await searchParams;
  const { subject, category, mode } = params;
  const recommended = mode === "recommended";

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
        <PracticeContent
          subjectId={subject}
          category={category}
          recommended={recommended}
        />
      </Suspense>
    </div>
  );
}
