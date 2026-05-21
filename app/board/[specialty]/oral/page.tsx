import { notFound } from "next/navigation";
import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { ArrowLeft, GraduationCap, Mic, BookOpen, Lock } from "lucide-react";
import {
  getBoardSpecialty,
} from "@/lib/supabase/queries-board";
import { getBoardOralCases } from "@/lib/supabase/queries-longcase";
import { createClient } from "@/lib/supabase/server";
import { hasBoardAccess } from "@/lib/membership";
import LongCaseStartButton from "@/app/longcase/LongCaseStartButton";
import { BOARD_SPECIALTY_SLUGS } from "@/lib/types-board";
import type { Metadata } from "next";

export const revalidate = 300;

export async function generateStaticParams() {
  return BOARD_SPECIALTY_SLUGS.map((specialty) => ({ specialty }));
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ specialty: string }>;
}): Promise<Metadata> {
  const { specialty } = await params;
  const s = await getBoardSpecialty(specialty);
  if (!s) return { title: "ไม่พบสาขา" };
  return {
    title: `ฝึกสอบบอร์ดปากเปล่า (Oral) — ${s.name_th}`,
    description: `สอบ Long Case oral exam ในสาขา${s.name_th} กับ อ.บอร์ด AI ที่ challenge เหมือนสอบจริง`,
    alternates: {
      canonical: `https://www.morroo.com/board/${specialty}/oral`,
    },
  };
}

const DIFFICULTY_LABEL: Record<string, { label: string; color: string }> = {
  easy: { label: "ง่าย", color: "bg-green-100 text-green-700" },
  medium: { label: "ปานกลาง", color: "bg-yellow-100 text-yellow-700" },
  hard: { label: "ยาก", color: "bg-red-100 text-red-700" },
};

export default async function BoardOralPage({
  params,
}: {
  params: Promise<{ specialty: string }>;
}) {
  const { specialty } = await params;
  const s = await getBoardSpecialty(specialty);
  if (!s) return notFound();

  const [cases, accessData] = await Promise.all([
    getBoardOralCases(specialty),
    (async () => {
      const supabase = await createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return { hasAccess: false };
      const { data: profile } = await supabase
        .from("profiles")
        .select("membership_type, membership_expires_at")
        .eq("id", user.id)
        .single();
      return { hasAccess: hasBoardAccess(profile) };
    })(),
  ]);

  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="mb-6">
        <Link
          href={`/board/${specialty}`}
          className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-brand"
        >
          <ArrowLeft className="h-4 w-4" /> กลับหน้า{s.name_th}
        </Link>
      </div>

      <div className="flex items-start gap-3 mb-6">
        <span className="text-4xl leading-none">{s.icon}</span>
        <div>
          <div className="flex items-center gap-2 mb-1 flex-wrap">
            <Badge className="bg-purple-100 text-purple-700 gap-1">
              <GraduationCap className="h-3 w-3" />
              Board Oral
            </Badge>
            <Badge variant="secondary" className="gap-1">
              <Mic className="h-3 w-3" /> อ.บอร์ด AI
            </Badge>
          </div>
          <h1 className="text-2xl font-bold">
            สอบปากเปล่า — {s.name_th}
          </h1>
          <p className="text-sm text-muted-foreground mt-1">
            จำลอง oral exam แบบราชวิทยาลัยฯ — present case + ตอบ follow-up
            เชิงลึก ระบบจะ challenge เหมือนสอบจริง
          </p>
        </div>
      </div>

      {!accessData.hasAccess && (
        <Card className="mb-4 border-amber-200 bg-amber-50">
          <CardContent className="pt-5 flex items-start gap-3">
            <Lock className="h-5 w-5 text-amber-600 mt-0.5" />
            <div className="text-sm flex-1">
              <div className="font-semibold text-amber-900">
                สอบ oral ต้องสมาชิก Board
              </div>
              <p className="text-amber-700 mt-0.5">
                แพ็ก Board รายเดือน ฿499 หรือรายปี ฿4,990 — รวม MCQ บอร์ดทุกสาขา + Oral Exam ไม่จำกัด
              </p>
              <Link
                href="/pricing"
                className="inline-block mt-2 text-amber-900 font-medium hover:underline"
              >
                ดูแพ็กเกจ Board →
              </Link>
            </div>
          </CardContent>
        </Card>
      )}

      {cases.length === 0 ? (
        <Card className="border-dashed">
          <CardContent className="py-10 text-center">
            <BookOpen className="h-10 w-10 mx-auto text-muted-foreground mb-3" />
            <p className="text-muted-foreground">
              เคส oral exam สำหรับสาขานี้กำลังจัดทำ
            </p>
            <Link
              href={`/board/${specialty}`}
              className="inline-block mt-3 text-sm text-brand hover:underline"
            >
              ← ฝึก MCQ ก่อนได้
            </Link>
          </CardContent>
        </Card>
      ) : (
        <div className="space-y-3">
          {cases.map((c) => {
            const diff = DIFFICULTY_LABEL[c.difficulty] ?? DIFFICULTY_LABEL.medium;
            const patient = c.patient_info as {
              age?: number;
              gender?: string;
            } | null;
            return (
              <Card key={c.id} className="hover:shadow-md transition-shadow">
                <CardContent className="pt-5">
                  <div className="flex items-start justify-between gap-3 flex-wrap">
                    <div className="flex-1 min-w-[240px]">
                      <div className="flex items-center gap-2 mb-1 flex-wrap">
                        <Badge className={diff.color}>{diff.label}</Badge>
                        {patient?.age && (
                          <Badge variant="secondary">
                            {patient.gender || "ผู้ป่วย"} {patient.age} ปี
                          </Badge>
                        )}
                      </div>
                      <h3 className="font-bold text-lg">{c.title}</h3>
                    </div>
                    <div className="w-full sm:w-48">
                      <LongCaseStartButton
                        caseId={c.id}
                        hasAccess={accessData.hasAccess}
                      />
                    </div>
                  </div>
                </CardContent>
              </Card>
            );
          })}
        </div>
      )}
    </div>
  );
}
