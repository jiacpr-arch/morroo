"use client";

import { useState } from "react";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

type Reward = "monthly_1m" | "bundle_10q";

const REWARD_OPTIONS: { value: Reward; label: string; sub: string }[] = [
  {
    value: "monthly_1m",
    label: "สมาชิกรายเดือน 1 เดือน",
    sub: "ใช้ทุกฟีเจอร์ไม่จำกัด มูลค่า ฿199",
  },
  {
    value: "bundle_10q",
    label: "Bundle 10 ข้อ",
    sub: "ปลดล็อก MCQ 10 ข้อตามสาขาที่เลือก",
  },
];

const STATUS_YEARS = ["Y3", "Y4", "Y5", "Y6", "extern", "อื่นๆ"];
const EXAM_TARGETS: { value: string; label: string }[] = [
  { value: "NL1", label: "NL Step 1" },
  { value: "NL2", label: "NL Step 2" },
  { value: "both", label: "ทั้งสอง" },
  { value: "unknown", label: "ยังไม่แน่ใจ" },
];

type Props = {
  defaultReward?: Reward;
  campaign?: string;
  adSet?: string;
};

export default function LeadForm({
  defaultReward = "monthly_1m",
  campaign,
  adSet,
}: Props) {
  const [reward, setReward] = useState<Reward>(defaultReward);
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [phone, setPhone] = useState("");
  const [statusYear, setStatusYear] = useState("");
  const [examTarget, setExamTarget] = useState("");
  const [consent, setConsent] = useState(false);

  const [submitting, setSubmitting] = useState(false);
  const [errorMsg, setErrorMsg] = useState("");
  const [success, setSuccess] = useState<{ code: string } | null>(null);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setSubmitting(true);
    setErrorMsg("");
    try {
      const res = await fetch("/api/leads/create", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          name,
          email,
          phone: phone || undefined,
          status_year: statusYear || undefined,
          exam_target: examTarget || undefined,
          reward_choice: reward,
          consent_pdpa: consent,
          campaign,
          ad_set: adSet,
        }),
      });
      const json = (await res.json()) as { error?: string; code?: string };
      if (!res.ok) {
        setErrorMsg(translateError(json.error));
        setSubmitting(false);
        return;
      }
      setSuccess({ code: json.code ?? "" });
    } catch (e) {
      setErrorMsg(e instanceof Error ? e.message : "ลองใหม่อีกครั้ง");
      setSubmitting(false);
    }
  }

  if (success) {
    return (
      <div className="rounded-xl border-2 border-teal-200 bg-teal-50 p-6 text-center">
        <div className="mx-auto mb-3 flex h-12 w-12 items-center justify-center rounded-full bg-teal-600 text-2xl text-white">
          ✓
        </div>
        <h3 className="text-lg font-semibold text-teal-900">
          ส่งโค้ดให้ทางอีเมลแล้ว!
        </h3>
        <p className="mt-2 text-sm text-teal-800">
          เช็คกล่องจดหมายที่ <strong>{email}</strong> (รวมถึง spam folder)
        </p>
        {success.code && (
          <p className="mt-4 font-mono text-base font-semibold text-teal-900">
            {success.code}
          </p>
        )}
        <Link
          href={`/redeem/${success.code}`}
          className="mt-4 inline-block text-sm font-medium text-teal-700 underline"
        >
          ใช้โค้ดทันที →
        </Link>
      </div>
    );
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-5">
      <fieldset className="space-y-3">
        <legend className="mb-2 text-sm font-semibold">เลือกของขวัญ</legend>
        <div className="grid gap-3 md:grid-cols-2">
          {REWARD_OPTIONS.map((opt) => (
            <label
              key={opt.value}
              className={`cursor-pointer rounded-lg border-2 p-4 transition ${
                reward === opt.value
                  ? "border-teal-600 bg-teal-50"
                  : "border-gray-200 hover:border-gray-300"
              }`}
            >
              <input
                type="radio"
                name="reward"
                value={opt.value}
                checked={reward === opt.value}
                onChange={() => setReward(opt.value)}
                className="sr-only"
              />
              <div className="font-medium">{opt.label}</div>
              <div className="mt-1 text-xs text-muted-foreground">{opt.sub}</div>
            </label>
          ))}
        </div>
      </fieldset>

      <div className="grid gap-4 md:grid-cols-2">
        <div className="space-y-1.5">
          <Label htmlFor="name">ชื่อ-นามสกุล *</Label>
          <Input
            id="name"
            value={name}
            onChange={(e) => setName(e.target.value)}
            required
          />
        </div>
        <div className="space-y-1.5">
          <Label htmlFor="email">อีเมล *</Label>
          <Input
            id="email"
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
          />
        </div>
        <div className="space-y-1.5">
          <Label htmlFor="phone">เบอร์โทร (ไม่บังคับ)</Label>
          <Input
            id="phone"
            type="tel"
            inputMode="tel"
            value={phone}
            onChange={(e) => setPhone(e.target.value)}
          />
        </div>
        <div className="space-y-1.5">
          <Label htmlFor="status_year">ชั้นปี / สถานะ</Label>
          <select
            id="status_year"
            value={statusYear}
            onChange={(e) => setStatusYear(e.target.value)}
            className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm"
          >
            <option value="">เลือก...</option>
            {STATUS_YEARS.map((s) => (
              <option key={s} value={s}>
                {s}
              </option>
            ))}
          </select>
        </div>
      </div>

      <fieldset>
        <legend className="mb-2 text-sm font-semibold">เป้าหมายสอบ</legend>
        <div className="flex flex-wrap gap-2">
          {EXAM_TARGETS.map((t) => (
            <label
              key={t.value}
              className={`cursor-pointer rounded-full border px-4 py-1.5 text-sm transition ${
                examTarget === t.value
                  ? "border-teal-600 bg-teal-50 text-teal-700"
                  : "border-gray-200 hover:border-gray-300"
              }`}
            >
              <input
                type="radio"
                name="exam_target"
                value={t.value}
                checked={examTarget === t.value}
                onChange={() => setExamTarget(t.value)}
                className="sr-only"
              />
              {t.label}
            </label>
          ))}
        </div>
      </fieldset>

      <label className="flex items-start gap-2 text-sm">
        <input
          type="checkbox"
          checked={consent}
          onChange={(e) => setConsent(e.target.checked)}
          className="mt-1"
          required
        />
        <span className="text-muted-foreground">
          ยินยอมให้หมอรู้เก็บและใช้ข้อมูลของฉันเพื่อส่งสิทธิ์ทดลองใช้และข้อมูลข่าวสาร
          ตาม{" "}
          <Link href="/privacy" className="underline">
            นโยบายความเป็นส่วนตัว
          </Link>
        </span>
      </label>

      <Button
        type="submit"
        disabled={submitting || !consent}
        className="w-full bg-teal-600 hover:bg-teal-700"
        size="lg"
      >
        {submitting ? "กำลังส่ง..." : "รับโค้ดทดลองฟรี"}
      </Button>

      {errorMsg && (
        <p className="text-center text-sm text-red-600">{errorMsg}</p>
      )}
    </form>
  );
}

function translateError(code?: string): string {
  switch (code) {
    case "missing_email":
    case "invalid_email":
      return "กรุณากรอกอีเมลที่ถูกต้อง";
    case "missing_reward":
      return "กรุณาเลือกของขวัญ";
    case "missing_consent":
      return "กรุณายอมรับเงื่อนไข PDPA";
    default:
      return "เกิดข้อผิดพลาด ลองใหม่อีกครั้ง";
  }
}
