import Link from "next/link";
import type { Metadata } from "next";
import { ArrowRight, CalendarDays, CheckCircle2, Clock3 } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { formatThaiExamDate, type ExamRound } from "@/lib/exam-dates";
import { loadExamRounds } from "@/lib/exam-rounds";
import { createAdminClient } from "@/lib/supabase/admin";
import ExamDaysLeft from "@/components/ExamDaysLeft";

export const metadata: Metadata = {
  title: "ปฏิทินสอบ NL 2569–2570 — วันสอบใบประกอบวิชาชีพแพทย์ทุกรอบ (ศรว.)",
  description:
    "ตารางวันสอบ National License ปี 2569–2570 — ส่วนที่ 1 ระบบใหม่, NL2 เดิม และ OSCE ตามประกาศ ศรว. พร้อมนับถอยหลังถึงวันสอบ และคลังข้อสอบ MCQ ไว้เตรียมตัว",
  alternates: { canonical: "https://www.morroo.com/nl/calendar" },
  openGraph: {
    title: "ปฏิทินสอบ NL 2569–2570 — วันสอบทุกรอบ พร้อมนับถอยหลัง",
    description:
      "วันสอบใบประกอบวิชาชีพแพทย์ปี 2569–2570 ครบทุกขั้นตอนตามประกาศ ศรว. รวมระบบสอบใหม่",
    url: "https://www.morroo.com/nl/calendar",
  },
};

const KIND_SECTIONS: Array<{
  kind: ExamRound["kind"];
  title: string;
  subtitle: string;
}> = [
  {
    kind: "part1",
    title: "ส่วนที่ 1 — วิทยาศาสตร์การแพทย์ + การประกอบวิชาชีพเวชกรรม (ระบบใหม่ 2570)",
    subtitle: "พื้นฐาน + คลินิกในข้อสอบเดียว (MCQ) — แทน NL1 + NL2 เดิม",
  },
  {
    kind: "osce",
    title: "ทักษะทางคลินิก (OSCE) — ขั้นตอนที่ 3 เดิม / ส่วนที่ 2 ระบบใหม่",
    subtitle: "Objective Structured Clinical Examination",
  },
  {
    kind: "meq",
    title: "MEQ + Long case — ทักษะทางคลินิก (ผู้จบจากต่างประเทศ)",
    subtitle: "สอบอัตนัยประยุกต์ (MEQ) และ Long case",
  },
  {
    kind: "nl2",
    title: "NL ขั้นตอนที่ 2 เดิม — วิทยาศาสตร์การแพทย์คลินิก",
    subtitle: "สำหรับผู้ที่ผ่าน NL1 เดิมแล้ว — เปิดสอบถึงรอบ ต.ค. 2570",
  },
  {
    kind: "nl1",
    title: "NL ขั้นตอนที่ 1 เดิม — วิทยาศาสตร์การแพทย์พื้นฐาน",
    subtitle: "สอบครั้งสุดท้าย 24 ม.ค. 2569 — หลังจากนี้ไปสอบส่วนที่ 1",
  },
];

// วันสอบมาจากตาราง exam_rounds (อัปเดตเองจากประกาศ ศรว. + แก้ได้ที่ /admin/exam-dates)
// revalidate ทุก 10 นาที; ป้าย "เหลือ X วัน" คำนวณฝั่ง client ใน <ExamDaysLeft>
export const revalidate = 600;

export default async function NlCalendarPage() {
  const rounds = await loadExamRounds(createAdminClient());
  // สถานะ "ผ่านไปแล้ว" ตัดสินตอน render/revalidate ฝั่ง server ก็พอ
  // (ความละเอียดระดับวัน — ป้ายนับถอยหลังฝั่ง client เป็นตัวบอกเวลาจริง)
  const now = Date.now();

  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="mb-8">
        <div className="mb-2 flex items-center gap-2">
          <CalendarDays className="h-5 w-5 text-brand" />
          <Badge className="bg-blue-100 text-blue-700">ปี 2569–2570</Badge>
        </div>
        <h1 className="text-3xl font-bold">ปฏิทินสอบ NL 2569–2570</h1>
        <p className="mt-2 text-muted-foreground">
          วันสอบใบประกอบวิชาชีพแพทย์ (National License) ทุกขั้นตอน ทุกรอบ
          ตามประกาศศูนย์ประเมินและรับรองความรู้ความสามารถในการประกอบวิชาชีพเวชกรรม
          (ศรว.)
        </p>
        <p className="mt-3 rounded-xl border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-900">
          ระบบสอบใหม่ตามข้อบังคับแพทยสภา พ.ศ. 2568: ตั้งแต่ปี 2570 สอบ{" "}
          <strong>ส่วนที่ 1</strong> (พื้นฐาน + คลินิก รวมข้อสอบเดียว) และ{" "}
          <strong>ส่วนที่ 2</strong> (ทักษะทางคลินิก) — ผู้ที่ผ่าน NL1 เดิมแล้วยังสอบ NL2
          เดิมต่อได้ถึงรอบ ต.ค. 2570
        </p>
      </div>

      <div className="space-y-6">
        {KIND_SECTIONS.map((section) => {
          const sectionRounds = rounds.filter((r) => r.kind === section.kind);
          if (sectionRounds.length === 0) return null;

          return (
            <Card key={section.kind}>
              <CardHeader className="pb-2">
                <h2 className="text-xl font-bold">{section.title}</h2>
                <p className="text-sm text-muted-foreground">
                  {section.subtitle}
                </p>
              </CardHeader>
              <CardContent>
                <ul className="divide-y">
                  {sectionRounds.map((round) => {
                    const isPast =
                      new Date(`${round.date}T00:00:00+07:00`).getTime() < now;
                    // ดึงคำว่า "รอบ ..." ท้าย label พอ — ชื่อขั้นตอนอยู่ในหัวข้อแล้ว
                    const roundName =
                      round.label.match(/รอบ\S*\/\d+$/)?.[0] ?? round.label;

                    return (
                      <li
                        key={round.label}
                        className={`flex flex-wrap items-center justify-between gap-2 py-3 ${
                          isPast ? "opacity-50" : ""
                        }`}
                      >
                        <div>
                          <p className="font-semibold">{roundName}</p>
                          <p className="text-sm text-muted-foreground">
                            {formatThaiExamDate(round.date)}
                            {!round.confirmed && " (คาดการณ์)"}
                          </p>
                        </div>
                        <div className="flex items-center gap-2">
                          {isPast ? (
                            <Badge variant="secondary">ผ่านไปแล้ว</Badge>
                          ) : (
                            <>
                              {round.confirmed ? (
                                <Badge className="gap-1 bg-green-100 text-green-700">
                                  <CheckCircle2 className="h-3 w-3" />
                                  ประกาศแล้ว
                                </Badge>
                              ) : (
                                <Badge className="gap-1 bg-amber-100 text-amber-700">
                                  <Clock3 className="h-3 w-3" />
                                  รอประกาศ ศรว.
                                </Badge>
                              )}
                              <ExamDaysLeft
                                date={round.date}
                                confirmed={round.confirmed}
                              />
                            </>
                          )}
                        </div>
                      </li>
                    );
                  })}
                </ul>
              </CardContent>
            </Card>
          );
        })}
      </div>

      <p className="mt-6 text-xs text-muted-foreground">
        ที่มา: ประกาศ ศรว. (
        <a
          href="https://cmathai.org/news"
          target="_blank"
          rel="noopener noreferrer"
          className="underline hover:text-brand"
        >
          cmathai.org
        </a>
        ) — รอบที่ระบุ &ldquo;รอประกาศ ศรว.&rdquo;
        เป็นวันคาดการณ์จากกำหนดการปีก่อน
        หน้านี้อัพเดทอัตโนมัติเมื่อมีประกาศใหม่
        โปรดตรวจสอบวันสอบและกำหนดรับสมัครจากประกาศทางการอีกครั้ง
      </p>

      <Card className="mt-8 border-brand/30 bg-brand/5">
        <CardContent className="flex flex-wrap items-center justify-between gap-4 py-5">
          <div>
            <h2 className="text-lg font-bold">เตรียมสอบให้ทันรอบถัดไป</h2>
            <p className="text-sm text-muted-foreground">
              คลังข้อสอบ MCQ กว่า 3,000 ข้อ พร้อมเฉลยละเอียด + จำลองสอบจับเวลา
            </p>
          </div>
          <div className="flex gap-2">
            <Link href="/nl/practice">
              <Button className="gap-2 bg-brand text-white hover:bg-brand-light">
                เริ่มฝึกทำ <ArrowRight className="h-4 w-4" />
              </Button>
            </Link>
            <Link href="/nl/mock">
              <Button variant="outline">จำลองสอบ</Button>
            </Link>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
