import type { Metadata } from "next";
import Link from "next/link";
import LeadForm from "./LeadForm";

export const dynamic = "force-dynamic";

export const metadata: Metadata = {
  title: "ทดลองใช้ฟรี — หมอรู้",
  description:
    "ลงทะเบียนรับสิทธิ์ทดลองใช้หมอรู้ฟรี เลือกระหว่าง 1 เดือนเต็ม หรือ Bundle 10 ข้อ",
  alternates: { canonical: "https://www.morroo.com/lp/free-trial" },
};

type SearchParams = Promise<{
  campaign?: string;
  ad_set?: string;
  reward?: string;
}>;

export default async function FreeTrialLanding({
  searchParams,
}: {
  searchParams: SearchParams;
}) {
  const sp = await searchParams;

  return (
    <main className="min-h-screen bg-gradient-to-b from-teal-50 to-white">
      <div className="mx-auto max-w-3xl px-4 py-12 md:py-20">
        <header className="text-center">
          <p className="text-sm font-semibold uppercase tracking-wider text-teal-600">
            สำหรับนักศึกษาแพทย์ที่กำลังเตรียมสอบ
          </p>
          <h1 className="mt-3 text-3xl font-bold leading-tight md:text-5xl">
            ลองหมอรู้ฟรี
            <br className="hidden md:inline" /> ก่อนตัดสินใจสมัคร
          </h1>
          <p className="mx-auto mt-5 max-w-2xl text-base text-muted-foreground md:text-lg">
            ฝึก MCQ + MEQ + Long Case ด้วย AI ที่เข้าใจหลักสูตรแพทย์ไทย
            เลือกของขวัญที่ใช่สำหรับคุณ ลงทะเบียนแล้วได้โค้ดทันทีทางอีเมล
          </p>
        </header>

        <section className="mt-8 flex flex-wrap justify-center gap-8 rounded-2xl border bg-white px-6 py-5 shadow-sm">
          <Stat value="6,700+" label="ข้อสอบ MCQ" />
          <Stat value="12 สาขา" label="ครอบคลุม Board" />
          <Stat value="ฟรี 1 เดือน" label="ไม่ต้องใช้บัตรเครดิต" />
        </section>

        <section className="mt-6 grid gap-6 md:grid-cols-3">
          <FeatureCard
            title="MCQ ครอบคลุม 12 สาขา"
            body="ข้อสอบ MCQ คุณภาพสูงพร้อมเฉลยอ้างอิง — ครอบคลุมทุกสาขา Board ที่ต้องสอบ"
          />
          <FeatureCard
            title="MEQ + Long Case AI"
            body="ฝึกตอบเคสจริงกับ AI ที่ feedback ตรงประเด็น เหมือนมีอาจารย์ส่วนตัว"
          />
          <FeatureCard
            title="แดชบอร์ดติดตามความก้าวหน้า"
            body="รู้จุดอ่อนตัวเอง วิเคราะห์ผลรายสาขา และวางแผนอ่านอย่างเป็นระบบ"
          />
        </section>

        <section className="mt-12">
          <div className="rounded-2xl border bg-white p-6 shadow-sm md:p-10">
            <h2 className="text-2xl font-bold">รับสิทธิ์ทดลองใช้</h2>
            <p className="mt-2 text-sm text-muted-foreground">
              กรอกข้อมูลด้านล่าง เราจะส่งโค้ดไปที่อีเมลของคุณภายใน 1 นาที
            </p>
            <div className="mt-6">
              <LeadForm
                defaultReward={sp.reward === "bundle_10q" ? "bundle_10q" : "monthly_1m"}
                campaign={sp.campaign}
                adSet={sp.ad_set}
              />
            </div>
          </div>
        </section>

        <p className="mt-8 text-center text-xs text-muted-foreground">
          มีบัญชีอยู่แล้ว?{" "}
          <Link href="/login" className="underline">
            เข้าสู่ระบบ
          </Link>
        </p>
      </div>
    </main>
  );
}

function FeatureCard({ title, body }: { title: string; body: string }) {
  return (
    <div className="rounded-xl border bg-white p-5 shadow-sm">
      <h3 className="font-semibold text-teal-700">{title}</h3>
      <p className="mt-2 text-sm text-muted-foreground">{body}</p>
    </div>
  );
}

function Stat({ value, label }: { value: string; label: string }) {
  return (
    <div className="text-center">
      <p className="text-2xl font-bold text-teal-700">{value}</p>
      <p className="mt-0.5 text-sm text-muted-foreground">{label}</p>
    </div>
  );
}
