"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { track } from "@/lib/analytics";
import { trackLead } from "@/lib/analytics/conversions";

type Reward = "monthly_1m" | "bundle_10q";

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
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [consent, setConsent] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [errorMsg, setErrorMsg] = useState("");

  useEffect(() => {
    track("lp_lead_form_view", {
      campaign: campaign ?? null,
      ad_set: adSet ?? null,
    });
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!consent) return;
    setSubmitting(true);
    setErrorMsg("");
    try {
      const res = await fetch("/api/leads/create", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          name,
          email,
          reward_choice: defaultReward,
          consent_pdpa: true,
          campaign,
          ad_set: adSet,
        }),
      });
      const json = (await res.json()) as { error?: string; code?: string };
      if (!res.ok) {
        track("lp_lead_form_error", {
          error: json.error ?? "unknown",
          campaign: campaign ?? null,
          ad_set: adSet ?? null,
        });
        setErrorMsg(translateError(json.error));
        setSubmitting(false);
        return;
      }
      track("lp_lead_form_submit", {
        reward_choice: defaultReward,
        campaign: campaign ?? null,
        ad_set: adSet ?? null,
      });
      if (json.code) trackLead(json.code);
      window.location.href = `/redeem/${json.code}`;
    } catch (err) {
      setErrorMsg(err instanceof Error ? err.message : "ลองใหม่อีกครั้ง");
      setSubmitting(false);
    }
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-5">
      <div className="rounded-lg border-2 border-teal-500 bg-teal-50 px-4 py-3">
        <p className="text-sm font-semibold text-teal-800">
          สิทธิ์ที่คุณจะได้รับ: สมาชิกรายเดือน 1 เดือน (มูลค่า ฿199)
        </p>
        <p className="mt-0.5 text-xs text-teal-700">
          ใช้ทุกฟีเจอร์ไม่จำกัด — MCQ, MEQ, Long Case, แดชบอร์ด
        </p>
      </div>

      <div className="space-y-4">
        <div className="space-y-1.5">
          <Label htmlFor="name">ชื่อ-นามสกุล</Label>
          <Input
            id="name"
            value={name}
            onChange={(e) => setName(e.target.value)}
            required
            placeholder="เช่น สมชาย ใจดี"
            autoComplete="name"
          />
        </div>
        <div className="space-y-1.5">
          <Label htmlFor="email">อีเมล</Label>
          <Input
            id="email"
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
            placeholder="email@example.com"
            autoComplete="email"
          />
        </div>
      </div>

      <label className="flex cursor-pointer items-start gap-3 rounded-lg border border-gray-200 p-3 transition hover:border-teal-300">
        <input
          type="checkbox"
          checked={consent}
          onChange={(e) => setConsent(e.target.checked)}
          className="mt-0.5 h-4 w-4 accent-teal-600"
        />
        <span className="text-sm text-muted-foreground">
          ยินยอมให้หมอรู้เก็บและใช้ข้อมูลของฉันเพื่อส่งสิทธิ์ทดลองใช้และข้อมูลข่าวสาร
          ตาม{" "}
          <Link
            href="/privacy"
            className="text-teal-700 underline"
            onClick={(e) => e.stopPropagation()}
          >
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
        {submitting ? "กำลังส่งโค้ด..." : "รับโค้ดทดลองฟรี 1 เดือน →"}
      </Button>

      {!consent && name && email && (
        <p className="text-center text-xs text-muted-foreground">
          ติ๊กยินยอมด้านบนก่อนกดรับโค้ด
        </p>
      )}

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
    case "missing_consent":
      return "กรุณายอมรับเงื่อนไข PDPA";
    default:
      return "เกิดข้อผิดพลาด ลองใหม่อีกครั้ง";
  }
}
