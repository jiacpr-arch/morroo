import { Quote, Sparkles, Users, BookOpen, Award } from "lucide-react";

const STATS = [
  { icon: Users, value: "1,000+", label: "แพทย์ใช้งาน" },
  { icon: BookOpen, value: "1,300+", label: "ข้อสอบครบ MEQ + MCQ" },
  { icon: Sparkles, value: "AI", label: "ตรวจคำตอบทันที 24/7" },
  { icon: Award, value: "100%", label: "เฉลยโดยผู้เชี่ยวชาญ" },
];

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

export default function SocialProofSection() {
  return (
    <section className="py-16 bg-white border-y">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        {/* Stats */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-6 mb-16">
          {STATS.map((s) => (
            <div
              key={s.label}
              className="flex flex-col items-center text-center gap-2 p-4 rounded-xl bg-brand/5 border border-brand/10"
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
        <div className="text-center mb-10">
          <h2 className="text-2xl sm:text-3xl font-bold">เสียงจากผู้ใช้งาน</h2>
          <p className="mt-2 text-muted-foreground">
            แพทย์และนักศึกษาแพทย์ที่ใช้ตัวจริงพูดถึงหมอรู้
          </p>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {TESTIMONIALS.map((t) => (
            <div
              key={t.name}
              className="rounded-2xl border bg-card p-6 flex flex-col gap-4 shadow-sm hover:shadow-md transition-shadow"
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
