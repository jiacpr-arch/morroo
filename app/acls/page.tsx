import Link from "next/link";
import { getChapters } from "@/lib/acls-reader/content";
import { getAssessmentSets } from "@/lib/acls-reader/assessment";
import { preCourseLessons } from "@/lib/acls-reader/precourse";
import ReaderProgress from "@/components/acls-reader/ReaderProgress";
import LandingPageTracker from "@/components/LandingPageTracker";
import SectionUpdatesBadge from "@/components/SectionUpdatesBadge";
import { Card, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";

export const revalidate = 600;

const tools = [
  {
    href: "/acls/learn",
    icon: "🎓",
    title: "บทเรียน Pre-course",
    desc: "13 บทแบบอ่าน-ควิซ พร้อมเฉลย",
  },
  {
    href: "/acls/test",
    icon: "📝",
    title: "แบบทดสอบ",
    desc: "Pre-test / Post-test พร้อมเฉลยทุกข้อ",
  },
  {
    href: "/acls/ekg",
    icon: "💓",
    title: "ฝึกอ่าน EKG",
    desc: "ดูคลื่นแล้วเลือกจังหวะที่ถูกต้อง",
  },
  {
    href: "/acls/qa-deep",
    icon: "💬",
    title: "Q&A เชิงลึก",
    desc: "คำถาม-คำตอบประกอบ infographic",
  },
];

export default async function AclsReaderHome() {
  const [chapters, sets] = await Promise.all([getChapters(), getAssessmentSets()]);

  return (
    <div className="mx-auto max-w-5xl px-4 py-12 sm:px-6 lg:px-8">
      <LandingPageTracker event="acls_reader_view" />
      <header className="mb-10 text-center">
        <h1 className="text-3xl font-bold sm:text-4xl">คู่มือทบทวน ACLS</h1>
        <p className="mt-3 text-lg text-muted-foreground">
          อ่านเป็นบท · เรียน pre-course · ทำแบบทดสอบ · ฝึกอ่าน EKG
        </p>
        <div className="mt-3 flex justify-center">
          <SectionUpdatesBadge section="acls" />
        </div>
      </header>

      <ReaderProgress
        lessons={preCourseLessons.map((l) => ({ id: l.id, passingScore: l.passingScore }))}
        testSets={sets.map((s) => ({ id: s.id, title: s.title }))}
      />

      <div className="mb-12 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
        {tools.map((t) => (
          <Link key={t.href} href={t.href} className="block">
            <Card className="h-full transition-shadow hover:shadow-md hover:ring-brand/30">
              <CardHeader>
                <span className="text-3xl">{t.icon}</span>
                <CardTitle className="text-base">{t.title}</CardTitle>
                <CardDescription>{t.desc}</CardDescription>
              </CardHeader>
            </Card>
          </Link>
        ))}
      </div>

      <h2 className="mb-4 text-sm font-semibold uppercase tracking-wide text-muted-foreground">
        อ่านเป็นบท
      </h2>
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {chapters.map((c) => (
          <Link key={c.id} href={`/acls/chapter/${c.id}`} className="block">
            <Card className="h-full transition-shadow hover:shadow-md hover:ring-brand/30">
              <CardHeader>
                <span className="text-3xl">{c.icon ?? "📘"}</span>
                <CardTitle className="text-base">{c.title}</CardTitle>
                <CardDescription>{c.sections.length} หัวข้อ</CardDescription>
              </CardHeader>
            </Card>
          </Link>
        ))}
      </div>
    </div>
  );
}
