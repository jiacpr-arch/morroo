import Link from "next/link";
import Image from "next/image";
import { Badge } from "@/components/ui/badge";
import SectionHeading from "@/components/SectionHeading";
import {
  GraduationCap,
  Brain,
  FileText,
  Stethoscope,
  Gamepad2,
  Award,
  Zap,
  Calendar,
  Target,
  BookOpen,
  ArrowRight,
  type LucideIcon,
} from "lucide-react";

type Feature = {
  href: string;
  icon: LucideIcon;
  iconBg: string;
  iconText: string;
  title: string;
  en: string;
  desc: string;
  badge?: { label: string; className: string };
};

// ฟีเจอร์ทั้งหมดที่ลูกค้าใช้ได้ — รวมไว้ที่เดียวเพื่อโปรโมตและให้เห็นภาพรวม
const FEATURES: Feature[] = [
  {
    href: "/school",
    icon: GraduationCap,
    iconBg: "bg-violet-100",
    iconText: "text-violet-600",
    title: "โหมด School",
    en: "เรียนแพทย์ Y1–Y6",
    desc: "Micro-learning: flashcard, quiz, AI tutor พร้อม spaced repetition เก็บ streak และ XP",
    badge: { label: "ฟรี", className: "bg-emerald-100 text-emerald-700" },
  },
  {
    href: "/nl",
    icon: Brain,
    iconBg: "bg-blue-100",
    iconText: "text-blue-600",
    title: "ข้อสอบ MCQ / NL",
    en: "ใบประกอบวิชาชีพ",
    desc: "คลังข้อสอบ MCQ NL ครบทุกสาขา โหมดฝึกซ้อม + จำลองสอบจับเวลา เฉลยทุกข้อ",
    badge: { label: "ยอดนิยม", className: "bg-blue-100 text-blue-700" },
  },
  {
    href: "/exams",
    icon: FileText,
    iconBg: "bg-teal-100",
    iconText: "text-teal-600",
    title: "ข้อสอบ MEQ",
    en: "Progressive Case",
    desc: "เคสจริง 6 ตอน ตั้งแต่ซักประวัติถึงภาวะแทรกซ้อน พร้อมเฉลยละเอียดและ AI ตรวจให้คะแนน",
  },
  {
    href: "/longcase",
    icon: Stethoscope,
    iconBg: "bg-amber-100",
    iconText: "text-amber-600",
    title: "Long Case",
    en: "AI Patient & Examiner",
    desc: "จำลองสอบ OSCE: ซักประวัติ AI คนไข้ → ตรวจร่างกาย → สั่ง Lab → นำเสนอต่อ AI กรรมการ",
    badge: { label: "AI", className: "bg-amber-100 text-amber-700" },
  },
  {
    href: "/casegame",
    icon: Gamepad2,
    iconBg: "bg-orange-100",
    iconText: "text-orange-600",
    title: "เกมเคส",
    en: "Long Case Decision Game",
    desc: "เล่นเป็นแพทย์เจ้าของไข้ ตัดสินใจซักประวัติ–สั่งแลป–รักษาภายใต้เวลากดดัน เก็บ XP ขึ้น Leaderboard",
    badge: { label: "ใหม่", className: "bg-orange-100 text-orange-700" },
  },
  {
    href: "/board",
    icon: Award,
    iconBg: "bg-purple-100",
    iconText: "text-purple-600",
    title: "สอบบอร์ดเฉพาะทาง",
    en: "Board Exam (วว.)",
    desc: "ฝึกข้อสอบ MCQ ตาม Blueprint จริงของแต่ละราชวิทยาลัยฯ ทบทวนตรงโครงสอบ",
  },
  {
    href: "/acls-reader",
    icon: Zap,
    iconBg: "bg-emerald-100",
    iconText: "text-emerald-600",
    title: "คู่มือ ACLS",
    en: "ILCOR 2025",
    desc: "อ่านเป็นบท เรียน pre-course ทำแบบทดสอบ และฝึกอ่าน EKG — ไม่ต้องสมัครสมาชิก",
    badge: { label: "ฟรี", className: "bg-emerald-100 text-emerald-700" },
  },
  {
    href: "/study-plan",
    icon: Calendar,
    iconBg: "bg-indigo-100",
    iconText: "text-indigo-600",
    title: "วางแผนอ่านหนังสือ",
    en: "Study Plan",
    desc: "ให้ AI วางแผนอ่านหนังสือรายวันจนถึงวันสอบ ปรับตามเวลาที่มีและจุดอ่อนของคุณ",
    badge: { label: "AI", className: "bg-indigo-100 text-indigo-700" },
  },
  {
    href: "/dashboard",
    icon: Target,
    iconBg: "bg-rose-100",
    iconText: "text-rose-600",
    title: "ผลการเรียน",
    en: "Dashboard",
    desc: "ติดตามพัฒนาการ สถิติความแม่นยำ และจุดอ่อนรายวิชา รู้ว่าควรทบทวนตรงไหนต่อ",
  },
  {
    href: "/blog",
    icon: BookOpen,
    iconBg: "bg-slate-100",
    iconText: "text-slate-600",
    title: "บทความ & เทคนิค",
    en: "Blog",
    desc: "บทความเทคนิคเตรียมสอบ สรุปแนวข้อสอบ และข่าวสอบล่าสุดจากทีมหมอรู้",
  },
];

export default function FeatureShowcase() {
  return (
    <section className="bg-[#f3f5ef] py-16 sm:py-20 lg:py-24">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="mb-10 grid items-center gap-8 lg:grid-cols-[1.1fr_1fr] lg:gap-16">
          <SectionHeading
            eyebrow="พื้นที่เล็ก ๆ สำหรับเป้าหมายที่ยิ่งใหญ่"
            title="เรียนรู้ในแบบที่ใช่ เตรียมพร้อมในแบบของคุณ"
            description="ตั้งแต่ทบทวนบทเรียน ฝึกข้อสอบ ไปจนถึงจำลองเคสกับ AI — เลือกเริ่มจากสิ่งที่อยากฝึก แล้วค่อย ๆ เติมความมั่นใจไปด้วยกัน"
            className="mb-0 sm:mb-0"
          />
          <Image
            src="/images/home/calm-study-desk.webp"
            width={1440}
            height={960}
            blurDataURL="data:image/webp;base64,UklGRlQAAABXRUJQVlA4IEgAAAAQAgCdASoMAAgAA4BaJZgCdAD7Fu0tB0IQAPAN5V11CfUcKzmxjdo4gmw84yYQerfRphUqiGmsux2VkqclzwWbj1rsieUAAAA="
            alt="มุมอ่านหนังสือแสงธรรมชาติ พร้อมสมุด หนังสือ และหูฟังแพทย์"
            sizes="(max-width: 639px) calc(100vw - 32px), (max-width: 1023px) calc(100vw - 48px), (max-width: 1279px) 44vw, 548px"
            placeholder="blur"
            className="aspect-[16/9] w-full rounded-3xl object-cover"
          />
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
          {FEATURES.map((f) => (
            <Link
              key={f.href}
              href={f.href}
              className="group relative flex flex-col rounded-2xl border border-border bg-card p-6 shadow-sm transition-all hover:border-brand/40 hover:shadow-lg hover:shadow-brand/5 motion-safe:hover:-translate-y-0.5 focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-brand"
            >
              {f.badge && (
                <Badge className={`absolute right-4 top-4 ${f.badge.className}`}>
                  {f.badge.label}
                </Badge>
              )}
              <div
                className={`mb-4 flex h-12 w-12 items-center justify-center rounded-xl ${f.iconBg}`}
              >
                <f.icon className={`h-6 w-6 ${f.iconText}`} />
              </div>
              <div className="flex flex-wrap items-baseline gap-x-2 gap-y-1">
                <h3 className="text-lg font-bold text-foreground transition-colors group-hover:text-brand">{f.title}</h3>
                <span className="text-xs text-muted-foreground">{f.en}</span>
              </div>
              <p className="mt-2 text-sm text-muted-foreground leading-relaxed">
                {f.desc}
              </p>
              <span className="mt-4 inline-flex items-center gap-1 text-sm font-medium text-brand">
                เปิดใช้งาน
                <ArrowRight className="h-4 w-4 transition-transform group-hover:translate-x-0.5" />
              </span>
            </Link>
          ))}
        </div>
      </div>
    </section>
  );
}
