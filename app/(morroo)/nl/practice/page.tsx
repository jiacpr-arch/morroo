import { Suspense } from "react";
import {
  getMcqSubjects,
  getMcqQuestions,
  getFreeAttemptsCount,
  getMcqQuestion,
  getMcqAnswerKeys,
} from "@/lib/supabase/queries-mcq";
import McqPractice from "@/components/McqPractice";
import InternalAdsBanner from "@/components/InternalAdsBanner";
import LandingPageTracker from "@/components/LandingPageTracker";
import FreeTrialBanner from "@/components/FreeTrialBanner";
import { Badge } from "@/components/ui/badge";
import Link from "next/link";
import { ArrowLeft, RotateCcw, Sparkles } from "lucide-react";
import type { Metadata } from "next";
import { createClient } from "@/lib/supabase/server";
import type { Profile } from "@/lib/types";
import { computeBetaStatus } from "@/lib/beta";
import { hasMcqAccess, hasScopedAccess, type EntitlementLike } from "@/lib/membership";
import { fetchEntitlements } from "@/lib/entitlements";
import { ITEM_PRICES, itemPlanType, mcqSubjectPrice } from "@/lib/items";
import ItemUpsell from "@/components/ItemUpsell";
import { getRecommendedQuestions } from "@/lib/mcq-recommendation";
import { getDueReviewQuestions, getMcqReviewDueCount } from "@/lib/mcq-review";
import type { McqSubject } from "@/lib/types-mcq";
import type { McqPracticeQuestion } from "@/lib/mcq-public";
import { practiceExamForTarget, type PracticeExam } from "@/lib/exam-level";

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
  review,
  pinnedQuestionId,
  examParam,
}: {
  subjectId?: string;
  category?: string;
  recommended?: boolean;
  review?: boolean;
  pinnedQuestionId?: string;
  examParam?: string;
}) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  // Deep link from the LINE daily quiz / dashboard card (?q=<question id>).
  // getMcqQuestion() already scopes to audience="student" + status="active",
  // so a stale/foreign id just resolves to null and this silently falls
  // back to the normal pool.
  const pinnedQuestion = pinnedQuestionId
    ? await getMcqQuestion(pinnedQuestionId)
    : null;
  // No explicit ?subject= — default the subject filter/header to the pinned
  // question's own subject so the chips and single-subject unlock logic
  // below match what's actually shown first.
  if (!subjectId && pinnedQuestion) {
    subjectId = pinnedQuestion.subject_id;
  }
  // Check premium status
  let isPremium = false;
  let freeUsedCount = 0;
  let entitlements: EntitlementLike[] = [];
  let profileTarget: string | null = null;

  if (user) {
    const { data: profile } = await supabase
      .from("profiles")
      .select(
        "membership_type, membership_expires_at, beta_enrolled_via, beta_started_at, beta_expires_at, beta_questions_used, beta_questions_limit, has_seen_beta_welcome, beta_coupon_code, beta_coupon_issued_at, target_exam"
      )
      .eq("id", user.id)
      .single();

    profileTarget = (profile as { target_exam?: string | null } | null)?.target_exam ?? null;
    const p = profile as Pick<Profile, "membership_type" | "membership_expires_at"> | null;
    // NL MCQ is its own product — student pack, bundle or mcq_* plan.
    entitlements = await fetchEntitlements(supabase, user.id);
    isPremium = hasMcqAccess(p, entitlements);

    if (!isPremium) {
      // Beta testers get a 25-question quota tracked on the profile row
      // (DB trigger). The legacy per-subject 5-free cap only applies to
      // plain-free users.
      const beta = computeBetaStatus(profile as Partial<Profile> as Profile | null);
      // Once Beta expires the user falls back to the normal free cap.
      if (beta.isBeta && !beta.isExpired) {
        freeUsedCount = 0;
      } else {
        freeUsedCount = await getFreeAttemptsCount(user.id, subjectId);
      }
    }
  }

  // Which exam pool to practice: explicit ?exam= wins, then the exam type of
  // a deep-linked question (daily quiz can be NL1 or NL2, so a pinned question
  // isn't padded with the other exam's), then the user's chosen level
  // (profiles.target_exam, see lib/exam-level), then NL2 as before.
  // "all" = ส่วนที่ 1 ระบบใหม่ (พื้นฐาน + คลินิก รวมกัน).
  const pinnedExam =
    pinnedQuestion?.exam_type === "NL1" || pinnedQuestion?.exam_type === "NL2"
      ? pinnedQuestion.exam_type
      : null;
  const examType: PracticeExam =
    examParam === "NL1" || examParam === "NL2" || examParam === "all"
      ? examParam
      : (pinnedExam ?? practiceExamForTarget(profileTarget));
  // Query filter: undefined = no exam_type filter (all student questions).
  const examFilter = examType === "all" ? undefined : examType;
  // Every internal link keeps the chosen exam so switching subject/mode doesn't reset it.
  const practiceHref = (params: Record<string, string> = {}, exam = examType) =>
    `/nl/practice?${new URLSearchParams({ ...params, exam }).toString()}`;

  // Recommended mode requires a signed-in user with history. Fall back
  // to the normal random pool otherwise.
  const useRecommended = recommended && !!user;
  // Review mode (ทบทวนข้อที่ผิด) serves the user's SRS queue — see
  // lib/mcq-review.ts. Also signed-in only.
  const useReview = review && !!user;
  // Selected-mode flags for the toggle; subject filter + upsell only apply
  // to the manual pool.
  const isManual = !useRecommended && !useReview;
  const reviewDueCount = user ? await getMcqReviewDueCount(supabase, user.id) : 0;

  const examSubjects = await getMcqSubjects(examFilter);
  // Hide subjects that have no questions yet — there's nothing to practice
  // and an empty selection just confuses the user.
  const subjects = examSubjects.filter((s) => s.question_count > 0);
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

  // Single-subject / internal-med-bundle purchases unlock just this page.
  if (user && !isPremium && (subjectId || isInternalMed)) {
    const scopes = isInternalMed
      ? ["category:internal_med"]
      : [
          `subject:${subjectId}`,
          ...(internalMedIds.includes(subjectId as string) ? ["category:internal_med"] : []),
        ];
    isPremium = hasScopedAccess("mcq", scopes, null, entitlements);
  }
  const otherSelected =
    !!subjectId && otherSubjects.some((s) => s.id === subjectId);

  let questions: McqPracticeQuestion[];
  let recBreakdown: Awaited<ReturnType<typeof getRecommendedQuestions>>["breakdown"] | null = null;

  if (useReview && user) {
    questions = await getDueReviewQuestions(supabase, user.id, { limit: 20 });
  } else if (useRecommended && user) {
    const rec = await getRecommendedQuestions(supabase, user.id, {
      // Recommendation pools are per exam type; the mixed view falls back to NL2 as before.
      examType: examFilter ?? "NL2",
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
      examType: examFilter,
      limit: 200,
      randomize: true,
    });
  }

  if (pinnedQuestion && !useReview) {
    // Always show the deep-linked question first; McqPractice renders
    // questions[currentIndex] in order, no client-side shuffle.
    questions = [
      pinnedQuestion,
      ...questions.filter((q) => q.id !== pinnedQuestion.id),
    ];
  }

  // ยังไม่ล็อกอิน: /api/mcq/reveal ต้องล็อกอิน จึงฝังเฉลยมาให้เฉพาะข้อฟรี
  // (FREE_LIMIT ข้อแรก — ครบแล้วเจอกำแพงสมัคร, "ทำใหม่" กลับไปข้อแรก)
  // ล็อกอินแล้วไม่ฝังเลย ขอเฉลยทีละข้อหลังตอบ
  if (!user && questions.length > 0) {
    const keys = await getMcqAnswerKeys(questions.slice(0, FREE_LIMIT).map((q) => q.id));
    questions = questions.map((q) => {
      const answerKey = keys.get(q.id);
      return answerKey ? { ...q, answerKey } : q;
    });
  }

  const currentSubject = subjectId
    ? examSubjects.find((s) => s.id === subjectId)
    : null;
  // Once a subject is picked, the chip grid collapses to a one-line summary
  // so the questions aren't pushed below the fold on mobile.
  const hasSelection = isManual && (isInternalMed || !!currentSubject);
  const selectionLabel = isInternalMed
    ? "🩺 อายุรกรรม"
    : currentSubject
      ? `${currentSubject.icon} ${currentSubject.name_th}`
      : "";

  return (
    <div>
      <LandingPageTracker event="nl_practice_view" />
      {!user && (
        <FreeTrialBanner
          surface="nl_practice"
          tryHref="/casegame"
          tryLabel="ลองเกมเคสฟรี"
        />
      )}
      <div className={hasSelection ? "hidden sm:block" : undefined}>
        <InternalAdsBanner placement="practice-top" className="mb-3 sm:mb-4" />
      </div>

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

      {/* Review banner */}
      {useReview && (
        <div className="mb-6 rounded-xl border border-violet-200 bg-gradient-to-r from-violet-50 to-brand/5 px-4 py-3">
          <div className="flex items-center gap-2 mb-1">
            <RotateCcw className="h-4 w-4 text-violet-600" />
            <span className="text-sm font-semibold text-violet-700">
              ทบทวนข้อที่ผิด — ข้อที่ถึงรอบทบทวนวันนี้
            </span>
          </div>
          <p className="text-xs text-muted-foreground">
            ตอบถูก ระบบจะเว้นระยะก่อนถามซ้ำให้นานขึ้น (1 → 3 → 8 → 20 วัน …) ·
            ตอบผิด กลับมาเริ่มทบทวนใหม่พรุ่งนี้
          </p>
        </div>
      )}

      {/* Exam switch — defaults to the user's level (profiles.target_exam) */}
      <div className="mb-3 flex flex-wrap items-center gap-2 sm:mb-4" role="group" aria-label="เลือกข้อสอบ">
        {(["all", "NL1", "NL2"] as const).map((t) => (
          <Link key={t} href={practiceHref({}, t)}>
            <Badge
              variant={examType === t ? "default" : "secondary"}
              className={`cursor-pointer ${examType === t ? "bg-brand text-white" : "hover:bg-brand/10"}`}
            >
              {t === "all" ? "ส่วนที่ 1 · รวม" : t === "NL1" ? "พื้นฐาน (NL1)" : "คลินิก (NL2)"}
            </Badge>
          </Link>
        ))}
      </div>

      {/* Mode toggle */}
      {user && (
        <div className="mb-3 flex flex-wrap gap-2 sm:mb-4">
          <Link href={practiceHref({ mode: "recommended" })}>
            <Badge
              variant={useRecommended ? "default" : "secondary"}
              className={`cursor-pointer gap-1 ${
                useRecommended ? "bg-brand text-white" : "hover:bg-brand/10"
              }`}
            >
              <Sparkles className="h-3 w-3" /> แนะนำให้คุณ
            </Badge>
          </Link>
          <Link href={practiceHref({ mode: "review" })}>
            <Badge
              variant={useReview ? "default" : "secondary"}
              className={`cursor-pointer gap-1 ${
                useReview ? "bg-brand text-white" : "hover:bg-brand/10"
              }`}
            >
              <RotateCcw className="h-3 w-3" /> ทบทวนข้อที่ผิด
              {reviewDueCount > 0 && (
                <span
                  className="ml-0.5 inline-flex min-w-[1.25rem] items-center justify-center rounded-full bg-red-500 px-1.5 text-[10px] font-bold leading-4 text-white"
                  aria-label={`ถึงรอบทบทวน ${reviewDueCount} ข้อ`}
                >
                  {reviewDueCount > 99 ? "99+" : reviewDueCount}
                </span>
              )}
            </Badge>
          </Link>
          <Link href={practiceHref()}>
            <Badge
              variant={isManual ? "default" : "secondary"}
              className={`cursor-pointer ${
                isManual ? "bg-brand text-white" : "hover:bg-brand/10"
              }`}
            >
              เลือกเอง
            </Badge>
          </Link>
        </div>
      )}

      {/* Subject Filter — manual mode only */}
      {isManual && (
        <details
          className="group/subjects mb-4 sm:mb-6"
          open={!hasSelection}
        >
          <summary className="flex cursor-pointer list-none items-center justify-between gap-2 select-none [&::-webkit-details-marker]:hidden">
            {hasSelection ? (
              <span className="min-w-0 truncate text-sm font-medium">
                {selectionLabel}{" "}
                <span className="font-normal text-muted-foreground">
                  — {questions.length} ข้อ
                </span>
              </span>
            ) : (
              <span className="text-sm font-medium text-muted-foreground">
                เลือกสาขา
              </span>
            )}
            <span className="shrink-0 text-sm text-brand hover:underline">
              <span className="group-open/subjects:hidden">เปลี่ยนสาขา ▾</span>
              <span className="hidden group-open/subjects:inline">
                {hasSelection ? "ซ่อน ▴" : ""}
              </span>
            </span>
          </summary>
          <div className="mt-2 flex flex-wrap gap-2">
            <Link href={practiceHref()}>
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
                href={practiceHref({ subject: subject.id })}
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
              <Link href={practiceHref({ category: INTERNAL_MED_CATEGORY })}>
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
            <details className="mt-2 group/others" open={otherSelected}>
              <summary className="cursor-pointer list-none text-sm text-brand hover:underline inline-flex items-center gap-1 select-none">
                <span className="group-open/others:hidden">
                  + ดูสาขาอื่น ๆ ({otherSubjects.length})
                </span>
                <span className="hidden group-open/others:inline">− ซ่อนสาขาอื่น</span>
              </summary>
              <div className="flex flex-wrap gap-2 mt-2">
                {otherSubjects.map((subject) => (
                  <Link
                    key={subject.id}
                    href={practiceHref({ subject: subject.id })}
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
        </details>
      )}

      {/* Info — once a subject is picked, the collapsed summary shows this */}
      {!hasSelection && (
        <div className="mb-4 text-sm text-muted-foreground sm:mb-6">
          {useReview
            ? "ถึงรอบทบทวน"
            : useRecommended
              ? "ชุดแนะนำ"
              : "คละทุกสาขา"} — {questions.length} ข้อ
        </div>
      )}

      {/* Buy just this subject — shown in context, not on /pricing */}
      {user && !isPremium && isManual && (isInternalMed || currentSubject) && (
        <ItemUpsell
          collapsible
          className="mb-4 sm:mb-6"
          title={isInternalMed ? "ปลดล็อกหมวดอายุรกรรมทั้งหมด" : "ปลดล็อกวิชานี้ไม่จำกัด"}
          itemPlan={
            isInternalMed
              ? itemPlanType("mcq_category", "internal_med")
              : itemPlanType("mcq_subject", currentSubject!.id)
          }
          itemLabel={
            isInternalMed
              ? "🩺 อายุรกรรม ทุก sub-specialty"
              : `${currentSubject!.icon} ${currentSubject!.name_th}`
          }
          itemAmount={
            isInternalMed
              ? ITEM_PRICES.mcq_category_internal_med
              : mcqSubjectPrice(currentSubject!.question_count ?? 0)
          }
          productPlan="mcq_monthly"
          packPlan="monthly"
          note="ซื้อขาด = ใช้ได้ตลอด เฉลยละเอียดทุกข้อ · แพ็ก นศพ. รวม MCQ + MEQ + Long Case + School"
        />
      )}

      {/* Practice Component */}
      {questions.length > 0 ? (
        <McqPractice
          questions={questions}
          isPremium={isPremium}
          freeUsedCount={Math.min(freeUsedCount, FREE_LIMIT)}
          freeLimit={FREE_LIMIT}
          viaRecommendation={useRecommended}
        />
      ) : useReview ? (
        <div className="text-center py-16 text-muted-foreground">
          <p className="text-lg">🎉 วันนี้ไม่มีข้อที่ถึงรอบทบทวน</p>
          <p className="text-sm mt-1">
            ข้อที่ตอบผิดจะถูกเก็บไว้ให้กลับมาทบทวนตามรอบโดยอัตโนมัติ
          </p>
          <Link
            href={practiceHref({ mode: "recommended" })}
            className="text-brand hover:underline mt-2 inline-block"
          >
            ทำชุดแนะนำต่อ
          </Link>
        </div>
      ) : (
        <div className="text-center py-16 text-muted-foreground">
          <p className="text-lg">ยังไม่มีข้อสอบในสาขานี้</p>
          <Link
            href={practiceHref()}
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
    q?: string;
    exam?: string;
  }>;
}) {
  const params = await searchParams;
  const { subject, category, mode, q, exam } = params;
  const recommended = mode === "recommended";
  const review = mode === "review";

  return (
    <div className="mx-auto max-w-4xl px-4 py-4 sm:px-6 sm:py-8 lg:px-8">
      {/* Header — kept compact on mobile so the questions sit near the top */}
      <div className="mb-3 sm:mb-6">
        <Link
          href="/nl"
          className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-brand mb-1 sm:mb-4"
        >
          <ArrowLeft className="h-4 w-4" /> กลับหน้า NL
        </Link>
        <h1 className="text-xl font-bold sm:text-2xl">ฝึกทำข้อสอบ NL</h1>
        <p className="hidden text-muted-foreground text-sm mt-1 sm:block">
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
          review={review}
          pinnedQuestionId={q}
          examParam={exam}
        />
      </Suspense>
    </div>
  );
}
