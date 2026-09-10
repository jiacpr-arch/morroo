import Link from "next/link";
import { ArrowLeft } from "lucide-react";
import type { Metadata } from "next";
import {
  getMcqQuestionsByIds,
  getQuestionBankStats,
} from "@/lib/supabase/queries-mcq";
import McqMock from "@/components/McqMock";
import { createClient } from "@/lib/supabase/server";
import type { Profile } from "@/lib/types";

export const metadata: Metadata = {
  title: "ลองทำข้อสอบ NL ฟรี — MorRoo",
  description: "ทดลองทำข้อสอบ MCQ ใบประกอบวิชาชีพเวชกรรม 10 ข้อ คละสาขา ไม่ต้องสมัครสมาชิก",
};

export const dynamic = "force-dynamic";

// Hand-picked, diverse set (one per major subject) shown on this public,
// no-login "try it now" link. Deliberately a small fixed pool rather than
// `randomize` over the full bank, so a widely-shared marketing link can't be
// used to farm the real question bank for free — see getMcqQuestionsByIds.
const TRY_QUESTION_IDS = [
  "00359a28-0e11-4ed4-995f-047cbc35345f", // กุมารเวชศาสตร์
  "05bff767-fe44-4949-bc73-31567991890d", // ต่อมไร้ท่อ
  "00ec9122-097d-4592-82ad-addd3e27662f", // นิติเวชศาสตร์
  "005fe56f-5a4a-4298-abf6-0ec06265f642", // โรคติดเชื้อ
  "00787001-5441-4f10-b03b-988cb26b974c", // ศัลยศาสตร์
  "006f9bbc-fba6-4765-be19-275bdec5dcc0", // สูติศาสตร์-นรีเวชวิทยา
  "03bab23a-00b6-40f0-9eab-3dfa13c33c61", // โสต ศอ นาสิก
  "00a6f910-7552-46b2-b94a-a3875ed4a751", // ออร์โธปิดิกส์
  "01664c3f-2b05-44e3-8b45-6ee40a666390", // อายุรศาสตร์ (รวม)
  "018b8dbd-2f51-462b-8616-f2e02dac7974", // อายุรศาสตร์ทรวงอก
];

async function getIsPremium(): Promise<boolean> {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return false;

  const { data: profile } = await supabase
    .from("profiles")
    .select("membership_type, membership_expires_at")
    .eq("id", user.id)
    .maybeSingle();

  const p = profile as Pick<Profile, "membership_type" | "membership_expires_at"> | null;
  if (!p) return false;
  const isExpired = p.membership_expires_at
    ? new Date(p.membership_expires_at) < new Date()
    : false;
  return (
    (p.membership_type === "monthly" ||
      p.membership_type === "yearly" ||
      p.membership_type === "bundle") &&
    !isExpired
  );
}

export default async function TryExamPage() {
  const [questions, isPremium, bankStats] = await Promise.all([
    getMcqQuestionsByIds(TRY_QUESTION_IDS),
    getIsPremium(),
    getQuestionBankStats(),
  ]);
  const shuffled = [...questions].sort(() => Math.random() - 0.5);

  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="mb-6">
        <Link
          href="/nl"
          className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-brand mb-4"
        >
          <ArrowLeft className="h-4 w-4" /> กลับหน้า NL
        </Link>
        <h1 className="text-2xl font-bold">ลองทำข้อสอบ NL ฟรี</h1>
        <p className="text-muted-foreground text-sm mt-1">
          ตัวอย่างข้อสอบ {shuffled.length} ข้อ คละสาขา ไม่ต้องสมัครสมาชิก
        </p>
      </div>

      {shuffled.length === 0 ? (
        <div className="text-center py-16 text-muted-foreground">
          <p className="text-lg">ยังไม่มีข้อสอบตัวอย่างในระบบ</p>
          <Link href="/nl" className="text-brand hover:underline mt-2 inline-block">
            กลับหน้า NL
          </Link>
        </div>
      ) : (
        <McqMock
          questions={shuffled}
          timeLimitMinutes={shuffled.length}
          upsell={isPremium ? undefined : { totalQuestions: bankStats.nlReady }}
        />
      )}
    </div>
  );
}
