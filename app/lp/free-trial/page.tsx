"use client";

import { Suspense, useState } from "react";
import { useSearchParams } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { CheckCircle, Gift, Loader2, Stethoscope } from "lucide-react";

type Reward = "monthly_1m" | "bundle_10q";
type StatusYear = "extern" | "intern" | "เพิ่มพูนทักษะ" | "GP" | "อื่นๆ";
type ExamTarget = "NL1" | "NL2" | "both" | "unknown";

const REWARD_OPTIONS: { value: Reward; title: string; price: string; desc: string }[] = [
  {
    value: "monthly_1m",
    title: "Premium รายเดือน — ฟรี 30 วัน",
    price: "มูลค่า ฿199",
    desc: "MEQ + MCQ + Long Case ไม่จำกัด · AI ตรวจคำตอบ",
  },
  {
    value: "bundle_10q",
    title: "Bundle 10 ข้อ — ใช้ตลอดชีพ",
    price: "มูลค่า ฿299",
    desc: "เลือกข้อสอบ 10 ข้อ · เฉลยละเอียด · Key Points",
  },
];

const STATUS_OPTIONS: StatusYear[] = ["extern", "intern", "เพิ่มพูนทักษะ", "GP", "อื่นๆ"];
const EXAM_OPTIONS: { value: ExamTarget; label: string }[] = [
  { value: "NL1", label: "NL1" },
  { value: "NL2", label: "NL2" },
  { value: "both", label: "ทั้งสอง" },
  { value: "unknown", label: "ยังไม่แน่ใจ" },
];

export default function FreeTrialLandingPage() {
  return (
    <Suspense fallback={null}>
      <FreeTrialLanding />
    </Suspense>
  );
}

function FreeTrialLanding() {
  const sp = useSearchParams();
  const campaign = sp.get("utm_campaign") ?? "fb-test-2026-05";
  const adSet = sp.get("utm_content") ?? undefined;

  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [phone, setPhone] = useState("");
  const [statusYear, setStatusYear] = useState<StatusYear>("intern");
  const [examTarget, setExamTarget] = useState<ExamTarget>("NL2");
  const [reward, setReward] = useState<Reward>("monthly_1m");
  const [consent, setConsent] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [success, setSuccess] = useState<{ code: string; redeemUrl: string } | null>(null);
  const [error, setError] = useState("");

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError("");
    setSubmitting(true);
    try {
      const res = await fetch("/api/leads/create", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          name,
          email,
          phone: phone || undefined,
          status_year: statusYear,
          exam_target: examTarget,
          reward_choice: reward,
          consent_pdpa: consent,
          campaign,
          ad_set: adSet,
          source: "landing",
        }),
      });
      const data = await res.json();
      if (!data.ok) {
        setError(data.error || "ไม่สามารถบันทึกข้อมูลได้");
        return;
      }
      setSuccess({ code: data.code, redeemUrl: data.redeemUrl });
    } catch (e) {
      setError(e instanceof Error ? e.message : "เกิดข้อผิดพลาด");
    } finally {
      setSubmitting(false);
    }
  }

  if (success) {
    return (
      <main className="min-h-screen bg-gradient-to-br from-emerald-50 via-white to-teal-50 px-4 py-16">
        <Card className="mx-auto max-w-md text-center">
          <CardHeader>
            <div className="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-emerald-500 text-white">
              <CheckCircle className="h-8 w-8" />
            </div>
            <h1 className="mt-3 text-2xl font-bold text-emerald-900">ลงทะเบียนสำเร็จ! 🎉</h1>
          </CardHeader>
          <CardContent className="space-y-4">
            <p className="text-sm text-gray-700">
              เราส่งโค้ดไปที่อีเมลของคุณแล้ว — เช็คกล่องอีเมล (และ Spam) ใน 1-2 นาที
            </p>
            <div className="rounded border-2 border-dashed border-emerald-500 bg-emerald-50 p-4">
              <p className="text-xs text-gray-600">โค้ดของคุณ</p>
              <p className="font-mono text-xl font-bold tracking-widest text-emerald-900">
                {success.code}
              </p>
            </div>
            <Button asChild className="w-full">
              <Link href={success.redeemUrl}>กดรับสิทธิ์เลย →</Link>
            </Button>
          </CardContent>
        </Card>
      </main>
    );
  }

  return (
    <main className="min-h-screen bg-gradient-to-br from-emerald-50 via-white to-teal-50">
      <section className="mx-auto max-w-3xl px-4 pt-12 pb-6 text-center">
        <div className="mx-auto mb-3 flex h-12 w-12 items-center justify-center rounded-full bg-emerald-100 text-emerald-700">
          <Stethoscope className="h-6 w-6" />
        </div>
        <h1 className="text-3xl font-bold text-emerald-900 sm:text-4xl">
          ฝึก MEQ + Long Case กับ AI — ฟรี 30 วัน
        </h1>
        <p className="mx-auto mt-3 max-w-xl text-sm text-gray-700 sm:text-base">
          กรอกข้อมูลสั้น ๆ รับโค้ดทันทีที่อีเมล · หมอ 800+ คนใช้หมอรู้ฝึกสอบทุกวัน
        </p>
      </section>

      <section className="mx-auto max-w-md px-4 pb-16">
        <Card>
          <CardHeader>
            <div className="flex items-center gap-2 text-emerald-700">
              <Gift className="h-5 w-5" />
              <span className="font-semibold">รับสิทธิ์ฟรี</span>
            </div>
          </CardHeader>
          <CardContent>
            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <Label htmlFor="name">ชื่อจริง *</Label>
                <Input id="name" value={name} onChange={(e) => setName(e.target.value)} required />
              </div>
              <div>
                <Label htmlFor="email">อีเมล *</Label>
                <Input
                  id="email"
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                  placeholder="คุณ@example.com"
                />
              </div>
              <div>
                <Label htmlFor="phone">เบอร์โทร (ไม่บังคับ)</Label>
                <Input id="phone" value={phone} onChange={(e) => setPhone(e.target.value)} />
              </div>

              <div>
                <Label>สถานะปัจจุบัน *</Label>
                <div className="mt-2 flex flex-wrap gap-2">
                  {STATUS_OPTIONS.map((s) => (
                    <button
                      key={s}
                      type="button"
                      onClick={() => setStatusYear(s)}
                      className={`rounded-full border px-3 py-1 text-sm transition ${
                        statusYear === s
                          ? "border-emerald-600 bg-emerald-600 text-white"
                          : "border-gray-300 bg-white text-gray-700 hover:border-emerald-400"
                      }`}
                    >
                      {s}
                    </button>
                  ))}
                </div>
              </div>

              <div>
                <Label>สอบที่เตรียม *</Label>
                <div className="mt-2 flex flex-wrap gap-2">
                  {EXAM_OPTIONS.map((opt) => (
                    <button
                      key={opt.value}
                      type="button"
                      onClick={() => setExamTarget(opt.value)}
                      className={`rounded-full border px-3 py-1 text-sm transition ${
                        examTarget === opt.value
                          ? "border-emerald-600 bg-emerald-600 text-white"
                          : "border-gray-300 bg-white text-gray-700 hover:border-emerald-400"
                      }`}
                    >
                      {opt.label}
                    </button>
                  ))}
                </div>
              </div>

              <div>
                <Label>เลือกรางวัล *</Label>
                <div className="mt-2 space-y-2">
                  {REWARD_OPTIONS.map((r) => (
                    <button
                      key={r.value}
                      type="button"
                      onClick={() => setReward(r.value)}
                      className={`w-full rounded-lg border-2 p-3 text-left transition ${
                        reward === r.value
                          ? "border-emerald-600 bg-emerald-50"
                          : "border-gray-200 hover:border-emerald-400"
                      }`}
                    >
                      <div className="flex items-center justify-between">
                        <span className="font-semibold text-gray-900">{r.title}</span>
                        <span className="text-xs text-emerald-700">{r.price}</span>
                      </div>
                      <p className="mt-1 text-xs text-gray-600">{r.desc}</p>
                    </button>
                  ))}
                </div>
              </div>

              <label className="flex items-start gap-2 text-xs text-gray-600">
                <input
                  type="checkbox"
                  checked={consent}
                  onChange={(e) => setConsent(e.target.checked)}
                  className="mt-0.5"
                  required
                />
                <span>
                  ยินยอมให้ Morroo ติดต่อกลับทาง email / Messenger / LINE เพื่อส่งโค้ดและข้อมูลที่เกี่ยวข้อง (PDPA){" "}
                  <Link href="/privacy" className="text-emerald-700 underline">
                    นโยบายความเป็นส่วนตัว
                  </Link>
                </span>
              </label>

              {error && (
                <p className="rounded bg-red-50 px-3 py-2 text-sm text-red-700">{error}</p>
              )}

              <Button type="submit" className="w-full" disabled={submitting || !consent}>
                {submitting ? (
                  <>
                    <Loader2 className="mr-2 h-4 w-4 animate-spin" /> กำลังส่ง...
                  </>
                ) : (
                  "รับโค้ดฟรีทันที"
                )}
              </Button>

              <p className="text-center text-xs text-gray-500">
                ไม่มีค่าใช้จ่ายแอบแฝง · ยกเลิกได้ตลอด
              </p>
            </form>
          </CardContent>
        </Card>
      </section>
    </main>
  );
}
