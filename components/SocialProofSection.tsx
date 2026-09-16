import { Quote, Stethoscope, BookOpen, Layers, Award } from "lucide-react";
import type { HomeExamStats } from "@/lib/supabase/queries";
import SectionHeading from "@/components/SectionHeading";

function buildStats(stats?: HomeExamStats | null) {
  const ready = stats?.totalReady ?? 0;
  const building = stats?.totalBuilding ?? 0;
  const meqExamCount = stats?.meqExamCount ?? 0;
  const meqPartCount = stats?.meqPartCount ?? 0;
  const longCaseCount = stats?.longCaseCount ?? 0;

  const mcqValue = ready > 0 ? ready.toLocaleString("en-US") : "6,000+";
  const mcqLabel =
    building > 0
      ? `ข้อสอบ MCQ พร้อมใช้ (+${building.toLocaleString("en-US")} กำลังสร้าง)`
      : "ข้อสอบ MCQ พร้อมใช้";

  const meqValue = meqExamCount > 0 ? meqExamCount.toLocaleString("en-US") : "40+";
  const meqLabel =
    meqPartCount > 0
      ? `ชุด MEQ Progressive Case (${meqPartCount.toLocaleString("en-US")} ตอน)`
      : "ชุด MEQ Progressive Case";

  const longCaseValue = longCaseCount > 0 ? longCaseCount.toLocaleString("en-US") : "20+";

  return [
    { icon: BookOpen, value: mcqValue, label: mcqLabel },
    { icon: Layers, value: meqValue, label: meqLabel },
    { icon: Stethoscope, value: longCaseValue, label: "เคส Long Case ฝึกกับ AI Patient" },
    { icon: Award, value: "100%", label: "เฉลยโดยผู้เชี่ยวชาญ" },
  ];
}

const TESTIMONIALS = [
  {
    quote:
      "ช่วยฝึก MEQ ได้เยอะมาก เคสครบ AI ให้ feedback ดีกว่าที่คิด ใช้ทบทวนก่อนสอบ NL3 ครบทุกสาขา",
    name: "นพ. ก.",
    role: "แพทย์ใช้ทุน ปีที่ 1",
  },
  {
    quote:
      "Long Case กับ AI Patient เหมือนสอบจริงเลย ฝึกซักประวัติ + นำเสนอ Examiner ได้เป็นชั่วโมงๆ คุ้มมาก",
    name: "นพ. ภ.",
    role: "นักศึกษาแพทย์ปี 6",
  },
  {
    quote:
      "ตอนสอบ NL Step 3 ทำข้อสอบของหมอรู้ก่อนสอบ 1 เดือน รู้สึกพร้อมขึ้นมาก เฉลยละเอียดและเข้าใจง่าย",
    name: "นพ. ส.",
    role: "เพิ่งสอบผ่าน NL3",
  },
];

export default function SocialProofSection({
  stats = null,
}: {
  stats?: HomeExamStats | null;
}) {
  const statItems = buildStats(stats);
  return (
    <section className="py-16 sm:py-20 lg:py-24 bg-card">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        {/* Stats */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-6 mb-16">
          {statItems.map((s) => (
            <div
              key={s.label}
              className="flex flex-col items-center gap-2 rounded-2xl border border-brand/10 bg-brand/5 p-4 text-center shadow-sm"
            >
              <s.icon className="h-7 w-7 text-brand" />
              <div className="text-2xl sm:text-3xl font-bold text-brand-dark">
                {s.value}
              </div>
              <div className="text-xs sm:text-sm text-muted-foreground">
                {s.label}
              </div>
            </div>
          ))}
        </div>

        {/* Testimonials */}
        <SectionHeading
          align="center"
          title="เสียงจากผู้ใช้งาน"
          description="แพทย์และนักศึกษาแพทย์ที่ใช้ตัวจริงพูดถึงหมอรู้"
        />
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {TESTIMONIALS.map((t) => (
            <div
              key={t.name}
              className="flex flex-col gap-4 rounded-2xl border border-border bg-card p-6 shadow-sm transition-all hover:-translate-y-0.5 hover:border-brand/40 hover:shadow-lg hover:shadow-brand/5"
            >
              <Quote className="h-6 w-6 text-brand/40 shrink-0" />
              <p className="text-sm leading-relaxed text-foreground/90 flex-1">
                &ldquo;{t.quote}&rdquo;
              </p>
              <div className="border-t pt-4">
                <div className="text-sm font-semibold">{t.name}</div>
                <div className="text-xs text-muted-foreground">{t.role}</div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
