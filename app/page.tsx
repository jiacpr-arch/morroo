import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import ExamCard from "@/components/ExamCard";
import PricingCard from "@/components/PricingCard";
import DailyCountdown from "@/components/DailyCountdown";
import AllExamsCountdown from "@/components/AllExamsCountdown";
import GoodyEmbed from "@/components/GoodyEmbed";
import { CATEGORIES, PRICING_PLANS } from "@/lib/types";
import { getExams, getExamPartCounts, sortExamsAvailableFirst } from "@/lib/supabase/queries";
import { getBlogPosts } from "@/lib/blog";
import {
  BookOpen,
  Clock,
  CheckCircle,
  ArrowRight,
  Sparkles,
  Users,
  Shield,
  Stethoscope,
} from "lucide-react";

export const revalidate = 60; // revalidate every 60 seconds

export default async function HomePage() {
  const [allExams, partCounts, blogPosts] = await Promise.all([
    getExams(),
    getExamPartCounts(),
    getBlogPosts(),
  ]);
  const exams = sortExamsAvailableFirst(allExams, partCounts);
  const latestExams = exams.slice(0, 6);
  const dayIndex = Math.floor(Date.now() / (1000 * 60 * 60 * 24));
  const dailyExam = exams.length > 0 ? exams[dayIndex % exams.length] : null;

  return (
    <>
      {/* Hero */}
      <section className="relative overflow-hidden bg-gradient-to-br from-brand-dark via-brand-dark to-brand py-20 sm:py-28">
        <div className="absolute inset-0 bg-[url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGRlZnM+PHBhdHRlcm4gaWQ9ImciIHdpZHRoPSI2MCIgaGVpZ2h0PSI2MCIgcGF0dGVyblVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+PHBhdGggZD0iTTAgMGg2MHY2MEgweiIgZmlsbD0ibm9uZSIvPjxjaXJjbGUgY3g9IjMwIiBjeT0iMzAiIHI9IjEiIGZpbGw9InJnYmEoMjU1LDI1NSwyNTUsMC4wNSkiLz48L3BhdHRlcm4+PC9kZWZzPjxyZWN0IHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjEwMCUiIGZpbGw9InVybCgjZykiLz48L3N2Zz4=')] opacity-40" />
        <div className="relative mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div className="text-center">
            <Badge className="mb-6 bg-white/10 text-white border-white/20 hover:bg-white/20">
              <Sparkles className="h-3 w-3 mr-1" /> แพลตฟอร์มข้อสอบ MEQ + NL + Long Case ออนไลน์
            </Badge>
            <h1 className="text-4xl sm:text-5xl lg:text-6xl font-bold text-white leading-tight">
              เตรียมสอบแพทย์
              <br />
              <span className="text-brand-light">ด้วย AI ที่เข้าใจคุณ</span>
            </h1>
            <p className="mt-6 text-lg text-white/70 max-w-2xl mx-auto">
              ข้อสอบ MEQ แบบ Progressive Case + ข้อสอบ NL ใบประกอบวิชาชีพ 1,300+ ข้อ +
              ฝึกสอบ Long Case กับ AI Patient & Examiner
            </p>
            <div className="mt-8 flex flex-col sm:flex-row items-center justify-center gap-4">
              <Link href="/exams">
                <Button
                  size="lg"
                  className="bg-brand hover:bg-brand-light text-white px-8 text-base"
                >
                  ข้อสอบ MEQ <ArrowRight className="ml-2 h-4 w-4" />
                </Button>
              </Link>
              <Link href="/longcase">
                <Button
                  size="lg"
                  className="bg-amber-500 hover:bg-amber-400 text-white px-8 text-base"
                >
                  Long Case Exam <ArrowRight className="ml-2 h-4 w-4" />
                </Button>
              </Link>
              <Link href="/nl">
                <Button
                  size="lg"
                  className="bg-white/10 border border-white/30 text-white hover:bg-white/20 px-8 text-base"
                >
                  MCQ <ArrowRight className="ml-2 h-4 w-4" />
                </Button>
              </Link>
            </div>
            <div className="mt-10 flex items-center justify-center gap-8 text-sm text-white/60">
              <span className="flex items-center gap-1.5">
                <Users className="h-4 w-4" /> 1,000+ แพทย์ใช้งาน
              </span>
              <span className="flex items-center gap-1.5">
                <BookOpen className="h-4 w-4" /> 1,300+ ข้อสอบ
              </span>
              <span className="flex items-center gap-1.5">
                <Shield className="h-4 w-4" /> เฉลยจากผู้เชี่ยวชาญ
              </span>
            </div>
          </div>
        </div>
      </section>

      {/* All Exams Countdown */}
      <section className="py-8 bg-white border-b">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <AllExamsCountdown />
        </div>
      </section>

      {/* Daily Exam */}
      {dailyExam && (
        <section className="py-12 bg-white border-b">
          <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
            <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 p-6 rounded-2xl bg-gradient-to-r from-brand/5 to-brand-light/5 border border-brand/10">
              <div>
                <div className="flex items-center gap-2 mb-2">
                  <Badge className="bg-brand text-white">ข้อสอบประจำวัน</Badge>
                  {dailyExam.is_free && (
                    <Badge variant="secondary">ฟรี</Badge>
                  )}
                </div>
                <h3 className="text-lg font-semibold">{dailyExam.title}</h3>
                <p className="text-sm text-muted-foreground mt-1">
                  {dailyExam.category} &bull; 6 ตอน
                </p>
              </div>
              <div className="flex flex-col sm:items-end gap-3">
                <div className="text-sm text-muted-foreground">ข้อถัดไปใน</div>
                <DailyCountdown />
                <Link href={`/exams/${dailyExam.id}`}>
                  <Button className="bg-brand hover:bg-brand-light text-white">
                    เริ่มทำข้อสอบ <ArrowRight className="ml-2 h-4 w-4" />
                  </Button>
                </Link>
              </div>
            </div>
          </div>
        </section>
      )}

      {/* Categories */}
      <section className="py-16">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold">หมวดหมู่สาขาวิชา</h2>
            <p className="mt-2 text-muted-foreground">ครอบคลุม 6 สาขาหลักที่ออกสอบ</p>
          </div>
          <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-4">
            {CATEGORIES.map((cat) => (
              <Link
                key={cat.slug}
                href={`/exams?category=${encodeURIComponent(cat.name)}`}
                className="group flex flex-col items-center gap-3 rounded-xl border p-6 transition-all hover:shadow-md hover:border-brand/30"
              >
                <span className="text-4xl group-hover:scale-110 transition-transform">
                  {cat.icon}
                </span>
                <span className="text-sm font-medium text-center">{cat.name}</span>
              </Link>
            ))}
          </div>
        </div>
      </section>

      {/* Latest Exams */}
      <section className="py-16 bg-muted/30">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between mb-8">
            <div>
              <h2 className="text-3xl font-bold">ข้อสอบล่าสุด</h2>
              <p className="mt-1 text-muted-foreground">อัปเดตใหม่ทุกสัปดาห์</p>
            </div>
            <Link href="/exams">
              <Button variant="outline" className="gap-2">
                ดูทั้งหมด <ArrowRight className="h-4 w-4" />
              </Button>
            </Link>
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
            {latestExams.length > 0 ? (
              latestExams.map((exam) => (
                <ExamCard key={exam.id} exam={exam} partCount={partCounts[exam.id] || 0} />
              ))
            ) : (
              <p className="col-span-full text-center text-muted-foreground py-8">
                กำลังเตรียมข้อสอบ... กลับมาเร็วๆ นี้
              </p>
            )}
          </div>
        </div>
      </section>

      {/* Long Case Feature */}
      <section className="py-16 bg-amber-50 border-y border-amber-100">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div className="grid md:grid-cols-2 gap-12 items-center">
            <div>
              <Badge className="mb-4 bg-amber-100 text-amber-800 border-amber-300">
                <Stethoscope className="h-3 w-3 mr-1" /> ใหม่ — Long Case Exam
              </Badge>
              <h2 className="text-3xl font-bold text-gray-900">
                ฝึกสอบ Long Case
                <br />
                <span className="text-amber-600">กับ AI Patient & Examiner</span>
              </h2>
              <p className="mt-4 text-muted-foreground text-lg">
                AI รับบทเป็นผู้ป่วย คุณซักประวัติ ตรวจร่างกาย สั่ง Lab แล้วนำเสนอต่อ AI Examiner
                ที่ให้ feedback และคะแนนแบบสอบจริง
              </p>
              <div className="mt-6 grid grid-cols-2 gap-3">
                {[
                  { icon: "🗣️", label: "ซักประวัติ", desc: "คุยกับ AI Patient" },
                  { icon: "🩺", label: "ตรวจร่างกาย", desc: "เลือก PE ที่จะตรวจ" },
                  { icon: "🔬", label: "สั่ง Lab", desc: "เลือก Lab/Imaging" },
                  { icon: "👨‍⚕️", label: "สัมภาษณ์ Examiner", desc: "รับคะแนน + Feedback" },
                ].map((s) => (
                  <div key={s.label} className="flex items-start gap-2 p-3 rounded-lg bg-white border border-amber-100">
                    <span className="text-xl shrink-0">{s.icon}</span>
                    <div>
                      <div className="text-sm font-semibold text-gray-900">{s.label}</div>
                      <div className="text-xs text-muted-foreground">{s.desc}</div>
                    </div>
                  </div>
                ))}
              </div>
              <div className="mt-6">
                <Link href="/longcase">
                  <Button className="bg-amber-500 hover:bg-amber-600 text-white gap-2">
                    ดูเคสทั้งหมด <ArrowRight className="h-4 w-4" />
                  </Button>
                </Link>
              </div>
            </div>
            <div className="space-y-3">
              {[
                { specialty: "Surgery", title: "Testicular Torsion", diff: "ยาก", badge: "bg-red-100 text-red-700", weekly: true },
                { specialty: "Cardiology", title: "Inferior STEMI", diff: "ปานกลาง", badge: "bg-rose-100 text-rose-700", weekly: false },
                { specialty: "Obstetrics", title: "Ectopic Pregnancy", diff: "ยาก", badge: "bg-pink-100 text-pink-700", weekly: false },
              ].map((c) => (
                <div key={c.title} className="rounded-xl border bg-white p-4 flex items-center justify-between gap-4 shadow-sm">
                  <div>
                    <div className="flex gap-1.5 mb-1.5">
                      <span className={`text-xs font-medium px-2 py-0.5 rounded-full ${c.badge}`}>{c.specialty}</span>
                      <span className="text-xs font-medium px-2 py-0.5 rounded-full bg-red-100 text-red-700">{c.diff}</span>
                      {c.weekly && <span className="text-xs font-medium px-2 py-0.5 rounded-full bg-amber-100 text-amber-700">⭐ ประจำสัปดาห์</span>}
                    </div>
                    <p className="font-semibold text-sm text-gray-900">{c.title}</p>
                    <p className="text-xs text-muted-foreground mt-0.5">ซักประวัติ + PE + Lab + Examiner · ~30 นาที</p>
                  </div>
                  <Link href="/longcase">
                    <Button size="sm" variant="outline" className="shrink-0 border-amber-300 text-amber-700 hover:bg-amber-50">
                      ลอง
                    </Button>
                  </Link>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* How it works */}
      <section className="py-16">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold">วิธีใช้งาน</h2>
            <p className="mt-2 text-muted-foreground">3 ขั้นตอนง่ายๆ</p>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {[
              {
                icon: BookOpen,
                step: "1",
                title: "เลือกข้อสอบ",
                desc: "เลือกสาขาวิชาและข้อสอบที่ต้องการฝึก กรองตามระดับความยาก",
              },
              {
                icon: Clock,
                step: "2",
                title: "ทำข้อสอบจับเวลา",
                desc: "อ่านโจทย์ Progressive Case 6 ตอน พร้อมตัวจับเวลาแต่ละข้อ",
              },
              {
                icon: CheckCircle,
                step: "3",
                title: "ดูเฉลยละเอียด",
                desc: "ดูเฉลยพร้อม Key Points และคำอธิบายโดยผู้เชี่ยวชาญ",
              },
            ].map((item) => (
              <div key={item.step} className="text-center space-y-4 p-6 rounded-xl">
                <div className="mx-auto w-16 h-16 rounded-full bg-brand/10 flex items-center justify-center">
                  <item.icon className="h-8 w-8 text-brand" />
                </div>
                <div className="inline-flex items-center justify-center w-8 h-8 rounded-full bg-brand text-white text-sm font-bold">
                  {item.step}
                </div>
                <h3 className="text-xl font-bold">{item.title}</h3>
                <p className="text-muted-foreground">{item.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Pricing */}
      <section className="py-16 bg-muted/30" id="pricing">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold">แพ็กเกจราคา</h2>
            <p className="mt-2 text-muted-foreground">เลือกแพ็กเกจที่เหมาะกับคุณ</p>
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 items-start">
            {PRICING_PLANS.map((plan) => (
              <PricingCard key={plan.name} {...plan} />
            ))}
          </div>
        </div>
      </section>

      {/* Blog */}
      {blogPosts.length > 0 && (
        <section className="py-16">
          <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
            <div className="flex items-center justify-between mb-8">
              <div>
                <h2 className="text-3xl font-bold">บทความล่าสุด</h2>
                <p className="mt-1 text-muted-foreground">ความรู้และเทคนิคเตรียมสอบแพทย์</p>
              </div>
              <Link href="/blog">
                <Button variant="outline" className="gap-2">
                  ดูทั้งหมด <ArrowRight className="h-4 w-4" />
                </Button>
              </Link>
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
              {blogPosts.slice(0, 3).map((post) => (
                <Link key={post.slug} href={`/blog/${post.slug}`}>
                  <article className="group rounded-xl border border-border bg-card p-6 h-full flex flex-col transition-shadow hover:shadow-md">
                    <div className="mb-3 flex items-center gap-2">
                      <span className="rounded-full bg-brand/10 px-3 py-0.5 text-xs font-medium text-brand">
                        {post.category}
                      </span>
                      <span className="text-xs text-muted-foreground">อ่าน {post.readingTime} นาที</span>
                    </div>
                    <h3 className="font-semibold text-foreground group-hover:text-brand transition-colors line-clamp-2 flex-1">
                      {post.title}
                    </h3>
                    <p className="mt-2 text-sm text-muted-foreground line-clamp-2">{post.description}</p>
                    <div className="mt-4 text-sm font-medium text-brand">อ่านต่อ →</div>
                  </article>
                </Link>
              ))}
            </div>
          </div>
        </section>
      )}

      {/* Health News */}
      <section className="py-16 bg-muted/30 border-y">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div className="mb-8">
            <h2 className="text-3xl font-bold">ข่าวสุขภาพ</h2>
            <p className="mt-1 text-muted-foreground">อัปเดตข่าวสารวงการแพทย์และสุขภาพ</p>
          </div>
          <div className="rounded-xl border bg-card overflow-hidden">
            <GoodyEmbed site="health" type="news" title="ข่าวสุขภาพ" />
          </div>
        </div>
      </section>

      {/* Wandee */}
      <section className="py-12">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div className="mb-6 text-center">
            <h2 className="text-2xl font-bold">วันดีประจำวัน</h2>
            <p className="mt-1 text-sm text-muted-foreground">เกร็ดผ่อนคลายระหว่างอ่านหนังสือ</p>
          </div>
          <div className="rounded-xl border bg-card overflow-hidden">
            <GoodyEmbed site="jiacpr" type="wandee" title="วันดี" />
          </div>
        </div>
      </section>

      {/* CTA */}
      <section className="py-20 bg-brand-dark text-white">
        <div className="mx-auto max-w-3xl px-4 text-center">
          <h2 className="text-3xl sm:text-4xl font-bold">
            พร้อมเริ่มเตรียมสอบแล้วหรือยัง?
          </h2>
          <p className="mt-4 text-white/70 text-lg">
            สมัครสมาชิกวันนี้ เข้าถึงข้อสอบ MEQ + NL + Long Case กับ AI พร้อมเฉลยละเอียดจากผู้เชี่ยวชาญ
          </p>
          <div className="mt-8 flex flex-col sm:flex-row items-center justify-center gap-4">
            <Link href="/register">
              <Button
                size="lg"
                className="bg-brand hover:bg-brand-light text-white px-8 text-base"
              >
                สมัครสมาชิกฟรี
              </Button>
            </Link>
            <Link href="/exams">
              <Button
                size="lg"
                className="bg-transparent border border-white/30 text-white hover:bg-white/10 px-8 text-base"
              >
                ดูข้อสอบตัวอย่าง
              </Button>
            </Link>
          </div>
        </div>
      </section>
    </>
  );
}
