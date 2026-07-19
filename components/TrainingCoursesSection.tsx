import { Badge } from "@/components/ui/badge";
import { TRAINING_COURSES } from "@/lib/network-sites";
import { ArrowRight, CheckCircle2 } from "lucide-react";

// คอร์สอบรม + ใบเซอร์ในเครือ MorRoo — cross-sell จากหน้าแรก
// การ์ดแต่ละใบใช้สี accent ประจำคอร์ส (sub-brand) ผ่าน inline CSS variable
// เพื่อให้เพิ่ม/แก้คอร์สได้จาก lib/network-sites.ts ที่เดียว
export default function TrainingCoursesSection() {
  return (
    <section className="py-16">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12">
          <h2 className="text-3xl font-bold">คอร์สอบรม + ใบเซอร์</h2>
          <p className="mt-2 text-muted-foreground">
            เรียนออนไลน์จบใน 1 วัน สอบผ่านรับใบเซอร์ได้ทันที โดย Jia Training Center
          </p>
        </div>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
          {TRAINING_COURSES.map((course) => (
            <a
              key={course.href}
              href={`${course.href}?utm_source=morroo.com&utm_medium=home_courses&utm_campaign=morroo_network`}
              className="group flex flex-col rounded-xl border border-t-4 bg-white p-6 transition-all hover:shadow-md"
              style={{ borderTopColor: course.accent }}
            >
              <div className="flex items-start justify-between">
                <span className="text-4xl">{course.emoji}</span>
                <Badge
                  variant="outline"
                  className="border-current"
                  style={{ color: course.accent }}
                >
                  {course.audience}
                </Badge>
              </div>
              <h3 className="mt-4 text-lg font-bold">{course.label}</h3>
              <p className="mt-1 text-sm text-muted-foreground">{course.tagline}</p>
              <ul className="mt-4 space-y-1.5 flex-1">
                {course.highlights.map((h) => (
                  <li key={h} className="flex items-center gap-2 text-sm">
                    <CheckCircle2
                      className="h-4 w-4 shrink-0"
                      style={{ color: course.accent }}
                    />
                    {h}
                  </li>
                ))}
              </ul>
              <span
                className="mt-5 inline-flex items-center gap-1.5 text-sm font-semibold"
                style={{ color: course.accent }}
              >
                เริ่มเรียนเลย
                <ArrowRight className="h-4 w-4 transition-transform group-hover:translate-x-1" />
              </span>
            </a>
          ))}
        </div>
      </div>
    </section>
  );
}
