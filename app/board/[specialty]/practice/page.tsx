import { notFound } from "next/navigation";
import Link from "next/link";
import { Suspense } from "react";
import { ArrowLeft } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { createClient } from "@/lib/supabase/server";
import {
  getBoardSpecialty,
  getBoardBlueprint,
} from "@/lib/supabase/queries-board";
import { getMcqQuestions, getFreeAttemptsCount } from "@/lib/supabase/queries-mcq";
import McqPractice from "@/components/McqPractice";
import { computeBetaStatus } from "@/lib/beta";
import { hasBoardAccess, hasFullStudentAccess } from "@/lib/membership";
import { BOARD_SECTIONS } from "@/lib/types-board";
import type { Profile } from "@/lib/types";
import type { Metadata } from "next";

const FREE_LIMIT = 5;

export async function generateMetadata({
  params,
}: {
  params: Promise<{ specialty: string }>;
}): Promise<Metadata> {
  const { specialty } = await params;
  const s = await getBoardSpecialty(specialty);
  if (!s) return { title: "ไม่พบสาขา" };
  return {
    title: `ฝึก MCQ บอร์ด${s.name_th}`,
    description: `ฝึกข้อสอบ MCQ สำหรับสอบบอร์ด${s.name_th} ตาม Blueprint จริง`,
  };
}

async function PracticeContent({
  specialty,
  section,
}: {
  specialty: string;
  section?: string;
}) {
  const s = await getBoardSpecialty(specialty);
  if (!s) return notFound();

  if (!s.is_published) {
    return (
      <div className="text-center py-12 text-muted-foreground">
        สาขานี้ยังไม่เปิดให้ฝึก —{" "}
        <Link href="/board" className="text-brand hover:underline">
          ดูสาขาที่เปิดแล้ว
        </Link>
      </div>
    );
  }

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

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
    // Board practice = unlocked by board tier OR full student tier (legacy
    // grandfathering — student-tier holders who used board before launch
    // keep access for the remainder of their subscription).
    isPremium = hasBoardAccess(p) || hasFullStudentAccess(p);
    if (!isPremium) {
      const beta = computeBetaStatus(profile as Partial<Profile> as Profile | null);
      if (beta.isBeta) {
        freeUsedCount = 0;
      } else {
        freeUsedCount = await getFreeAttemptsCount(user.id);
      }
    }
  }

  const questions = await getMcqQuestions({
    audience: "board",
    boardSpecialty: specialty,
    boardSection: section,
    limit: 200,
    randomize: true,
  });

  const sectionMeta = section
    ? BOARD_SECTIONS.find((sec) => sec.code === section)
    : null;

  // Pull the latest blueprint to know the official section size; used for context only
  const blueprints = await getBoardBlueprint(specialty);
  const officialCount = sectionMeta
    ? blueprints.find((b) => b.section_code === sectionMeta.code)?.question_count
    : blueprints.reduce((sum, b) => sum + b.question_count, 0);

  return (
    <div>
      <div className="mb-4 flex flex-wrap gap-2 items-center text-sm">
        <Badge className="bg-purple-100 text-purple-700">
          {s.icon} {s.short_name_th ?? s.name_th}
        </Badge>
        {sectionMeta ? (
          <>
            <span className="text-muted-foreground">·</span>
            <span className="font-medium">{sectionMeta.label_th}</span>
          </>
        ) : (
          <span className="text-muted-foreground">· คละทุกหมวด</span>
        )}
        {officialCount && (
          <span className="text-xs text-muted-foreground ml-auto">
            Blueprint: {officialCount} ข้อ
          </span>
        )}
      </div>

      {/* Section quick-switch */}
      <div className="mb-6 flex flex-wrap gap-2">
        <Link href={`/board/${specialty}/practice`}>
          <Badge
            variant={!section ? "default" : "secondary"}
            className={`cursor-pointer ${
              !section ? "bg-brand text-white" : "hover:bg-brand/10"
            }`}
          >
            คละทุกหมวด
          </Badge>
        </Link>
        {BOARD_SECTIONS.map((sec) => (
          <Link
            key={sec.code}
            href={`/board/${specialty}/practice?section=${sec.code}`}
          >
            <Badge
              variant={section === sec.code ? "default" : "secondary"}
              className={`cursor-pointer ${
                section === sec.code ? "bg-brand text-white" : "hover:bg-brand/10"
              }`}
            >
              {sec.label_th}
            </Badge>
          </Link>
        ))}
      </div>

      {questions.length > 0 ? (
        <McqPractice
          questions={questions}
          isPremium={isPremium}
          freeUsedCount={Math.min(freeUsedCount, FREE_LIMIT)}
          freeLimit={FREE_LIMIT}
          sessionAudience="board"
          sessionExamType={null}
          sessionBoardSpecialty={specialty}
          sessionBoardSection={section ?? null}
        />
      ) : (
        <div className="text-center py-16 text-muted-foreground">
          <p className="text-lg">ยังไม่มีข้อสอบในหมวดนี้</p>
          <p className="text-sm mt-1">ทีมงานกำลังเตรียมเนื้อหา</p>
          <Link
            href={`/board/${specialty}`}
            className="text-brand hover:underline mt-3 inline-block"
          >
            กลับหน้าสาขา
          </Link>
        </div>
      )}
    </div>
  );
}

export default async function BoardPracticePage({
  params,
  searchParams,
}: {
  params: Promise<{ specialty: string }>;
  searchParams: Promise<{ section?: string }>;
}) {
  const [{ specialty }, { section }] = await Promise.all([
    params,
    searchParams,
  ]);

  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="mb-6">
        <Link
          href={`/board/${specialty}`}
          className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-brand mb-4"
        >
          <ArrowLeft className="h-4 w-4" /> กลับหน้าสาขา
        </Link>
        <h1 className="text-2xl font-bold">ฝึกทำข้อสอบ Board</h1>
        <p className="text-muted-foreground text-sm mt-1">
          เลือกตอบแล้วดูเฉลยทันที ตาม Blueprint จริง
        </p>
      </div>

      <Suspense
        fallback={<div className="text-center py-8">กำลังโหลดข้อสอบ...</div>}
      >
        <PracticeContent specialty={specialty} section={section} />
      </Suspense>
    </div>
  );
}
