"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { X } from "lucide-react";

interface TrialInfo {
  active: boolean;
  endsAt?: string;
  daysLeft?: number;
  prices?: { monthly: number; yearly: number; monthlyIntro: number; yearlyIntro: number };
}

// Hidden for the rest of the browser session once closed; it comes back on
// the next visit so the end date and price stay in front of the user.
const DISMISS_KEY = "trial_banner_dismissed_v1";

function formatThaiDate(iso: string): string {
  return new Date(iso).toLocaleDateString("th-TH", {
    timeZone: "Asia/Bangkok",
    day: "numeric",
    month: "short",
    year: "numeric",
  });
}

function baht(n: number): string {
  return `฿${n.toLocaleString("en-US")}`;
}

/**
 * Site-wide notice for users on the 7-day free trial: tells them it is a
 * one-time trial, the exact day it ends, and the full price afterwards.
 * POST /api/trial also starts the trial for a brand-new account.
 */
export default function TrialBanner() {
  const [trial, setTrial] = useState<TrialInfo | null>(null);
  const [dismissed, setDismissed] = useState(false);

  useEffect(() => {
    try {
      if (sessionStorage.getItem(DISMISS_KEY)) setDismissed(true);
    } catch {
      /* storage blocked — just show it */
    }
    fetch("/api/trial", { method: "POST" })
      .then((r) => (r.ok ? r.json() : null))
      .then((data: TrialInfo | null) => setTrial(data))
      .catch(() => {});
  }, []);

  if (!trial?.active || !trial.endsAt || dismissed) return null;

  const daysLeft = trial.daysLeft ?? 0;
  const urgent = daysLeft <= 2;
  const prices = trial.prices;

  const handleDismiss = () => {
    try {
      sessionStorage.setItem(DISMISS_KEY, "1");
    } catch {
      /* ignore */
    }
    setDismissed(true);
  };

  return (
    <div
      className={
        urgent
          ? "border-b border-amber-300 bg-amber-50 text-amber-950"
          : "border-b border-emerald-300 bg-emerald-50 text-emerald-950"
      }
    >
      <div className="mx-auto flex max-w-6xl items-start gap-3 px-4 py-2.5 text-sm">
        <span className="mt-0.5 text-base leading-none">{urgent ? "⏰" : "🎁"}</span>
        <div className="flex-1 min-w-0">
          <p>
            <strong>คุณกำลังทดลองใช้ฟรี 7 วัน (ทุกฟีเจอร์)</strong> — สิทธิ์ทดลองมีครั้งเดียวต่อบัญชี
            {" · "}
            หมด <strong>{formatThaiDate(trial.endsAt)}</strong> (เหลือ {daysLeft} วัน)
          </p>
          {prices && (
            <p className="mt-0.5 opacity-90">
              หลังหมดสิทธิ์ ราคาเต็ม: รายเดือน <strong>{baht(prices.monthly)}</strong> · รายปี{" "}
              <strong>{baht(prices.yearly)}</strong>
              {(prices.monthlyIntro < prices.monthly || prices.yearlyIntro < prices.yearly) && (
                <>
                  {" "}(ซื้อครั้งแรกเหลือ {baht(prices.monthlyIntro)} / {baht(prices.yearlyIntro)})
                </>
              )}{" "}
              <Link href="/pricing" className="font-semibold underline underline-offset-2">
                ดูแพ็กเกจ
              </Link>
            </p>
          )}
        </div>
        <button
          type="button"
          onClick={handleDismiss}
          aria-label="ปิด"
          className="shrink-0 rounded p-1 opacity-60 hover:opacity-100"
        >
          <X className="h-4 w-4" />
        </button>
      </div>
    </div>
  );
}
