import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { getLongCases } from "@/lib/supabase/queries-longcase";
import { createClient } from "@/lib/supabase/server";
import { BookOpen, Stethoscope, Clock, Star, Lock } from "lucide-react";
import type { Metadata } from "next";
import LongCaseStartButton from "./LongCaseStartButton";

export const metadata: Metadata = {
  title: "Long Case Exam — หมอรู้",
  description: "ฝึกสอบ Long Case กับ AI รับบท Patient + Examiner ข้อสอบใหม่ทุกสัปดาห์ เหมาะสำหรับ Intern และ Extern",
};

export const revalidate = 300;

const SPECIALTY_COLORS: Record<string, string> = {
  Medicine: "bg-blue-100 text-blue-700",
  Surgery: "bg-red-100 text-red-700",
  Obstetrics: "bg-pink-100 text-pink-700",
  Pediatrics: "bg-green-100 text-green-700",
  Emergency: "bg-orange-100 text-orange-700",
  Cardiology: "bg-rose-100 text-rose-700",
  Neurology: "bg-purple-100 text-purple-700",
  Orthopedics: "bg-amber-100 text-amber-700",
};

const DIFFICULTY_LABEL: Record<string, { label: string; color: string }> = {
  easy: { label: "ง่าย", color: "bg-green-100 text-green-700" },
  medium: { label: "ปานกลาง", color: "bg-yellow-100 text-yellow-700" },
  hard: { label: "ยาก", color: "bg-red-100 text-red-700" },
};

export default async function LongCasePage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  let hasAccess = false;
  if (user) {
    const { data: profile } = await supabase
      .from("profiles")
      .select("membership_type, membership_expires_at")
      .eq("id", user.id)
      .single();
    const now = new Date();
    const expires = profile?.membership_expires_at ? new Date(profile.membership_expires_at) : null;
    hasAccess = profile?.membership_type !== "free" && !!expires && expires > now;
  }

  const cases = await getLongCases();
  const weeklyCases = cases.filter(c => c.is_weekly);
  const regularCases = cases.filter(c => !c.is_weekly);

  return (
    <div className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
      {/* Header */}
      <div className="mb-8">
        <div className="flex items-center gap-2 mb-3">
          <Badge className="bg-amber-100 text-amber-800 border-amber-300">Long Case Exam</Badge>
          <Badge variant="secondary">{cases.length} เคส</Badge>
        </div>
        <h1 className="text-3xl font-bold text-gray-900">ฝึกสอบ Long Case</h1>
        <p className="mt-2 text-muted-foreground max-w-2xl">
          AI รับบทเป็นผู้ป่วย คุณซักประวัติ ตรวจร่างกาย สั่ง Lab แล้วนำเสนอต่อ AI Examiner
          ที่ให้ feedback และคะแนนแบบสอบจริง
        </p>
      </div>

      {/* How it works */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-10">
        {[
          { icon: "🗣️", step: "1", label: "ซักประวัติ", desc: "คุยกับ AI Patient" },
          { icon: "🩺", step: "2", label: "ตรวจร่างกาย", desc: "เลือก PE ที่จะตรวจ" },
          { icon: "🔬", step: "3", label: "สั่ง Lab", desc: "เลือก Lab/Imaging" },
          { icon: "👨‍⚕️", step: "4", label: "สัมภาษณ์ Examiner", desc: "นำเสนอและรับคะแนน" },
        ].map((s) => (
          <div key={s.step} className="rounded-xl border bg-white p-4 text-center">
            <div className="text-2xl mb-1">{s.icon}</div>
            <div className="text-xs font-semibold text-amber-600 mb-0.5">Step {s.step}</div>
            <div className="font-semibold text-sm text-gray-900">{s.label}</div>
            <div className="text-xs text-muted-foreground mt-0.5">{s.desc}</div>
          </div>
        ))}
      </div>

      {/* Access banner for free users */}
      {!hasAccess && (
        <div className="mb-8 rounded-xl border-2 border-amber-300 bg-amber-50 p-5 flex items-center gap-4">
          <div className="text-3xl shrink-0">🎁</div>
          <div className="flex-1">
            <p className="font-semibold text-amber-900">ฟรี 1 เคส/เดือน สำหรับสมาชิกทั่วไป</p>
            <p className="text-sm text-amber-700">อัปเกรดเป็นรายเดือนหรือรายปีเพื่อเล่น Long Case ไม่จำกัด</p>
          </div>
          <Link href="/pricing">
            <Button className="bg-amber-500 hover:bg-amber-600 text-white shrink-0">
              ดูแพ็กเกจ
            </Button>
          </Link>
        </div>
      )}

      {/* Weekly Cases */}
      {weeklyCases.length > 0 && (
        <div className="mb-10">
          <div className="flex items-center gap-2 mb-4">
            <Star className="h-5 w-5 text-amber-500 fill-amber-500" />
            <h2 className="text-xl font-bold text-gray-900">Case ประจำสัปดาห์</h2>
          </div>
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-5">
            {weeklyCases.map((c) => (
              <CaseCard key={c.id} lc={c} hasAccess={hasAccess} isWeekly />
            ))}
          </div>
        </div>
      )}

      {/* All Cases */}
      {regularCases.length > 0 && (
        <div>
          <h2 className="text-xl font-bold text-gray-900 mb-4">เคสทั้งหมด</h2>
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-5">
            {regularCases.map((c) => (
              <CaseCard key={c.id} lc={c} hasAccess={hasAccess} />
            ))}
          </div>
        </div>
      )}

      {cases.length === 0 && (
        <div className="text-center py-16 text-muted-foreground">
          <BookOpen className="h-12 w-12 mx-auto mb-3 opacity-30" />
          <p>กำลังเพิ่มเคสใหม่ เร็วๆ นี้</p>
        </div>
      )}
    </div>
  );
}

function CaseCard({ lc, hasAccess, isWeekly }: {
  lc: Awaited<ReturnType<typeof getLongCases>>[0];
  hasAccess: boolean;
  isWeekly?: boolean;
}) {
  const diff = DIFFICULTY_LABEL[lc.difficulty] || DIFFICULTY_LABEL.medium;
  const specColor = SPECIALTY_COLORS[lc.specialty] || "bg-gray-100 text-gray-700";

  return (
    <Card className={`overflow-hidden transition-all hover:shadow-md ${isWeekly ? "border-amber-300" : ""}`}>
      {isWeekly && (
        <div className="bg-amber-500 text-white text-xs font-semibold text-center py-1 flex items-center justify-center gap-1">
          <Star className="h-3 w-3 fill-white" /> Case ประจำสัปดาห์ {lc.week_number ? `#${lc.week_number}` : ""}
        </div>
      )}
      <CardContent className="p-5">
        <div className="flex flex-wrap gap-1.5 mb-3">
          <span className={`text-xs font-medium px-2 py-0.5 rounded-full ${specColor}`}>
            {lc.specialty}
          </span>
          <span className={`text-xs font-medium px-2 py-0.5 rounded-full ${diff.color}`}>
            {diff.label}
          </span>
        </div>
        <h3 className="font-semibold text-gray-900 text-base leading-snug mb-3">
          {lc.title}
        </h3>
        <div className="flex items-center gap-3 text-xs text-muted-foreground mb-4">
          <span className="flex items-center gap-1">
            <Stethoscope className="h-3.5 w-3.5" /> ซักประวัติ + PE + Lab
          </span>
          <span className="flex items-center gap-1">
            <Clock className="h-3.5 w-3.5" /> ~30 นาที
          </span>
        </div>
        <LongCaseStartButton caseId={lc.id} hasAccess={hasAccess} />
      </CardContent>
    </Card>
  );
}
