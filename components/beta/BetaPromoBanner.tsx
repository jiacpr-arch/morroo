"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { X } from "lucide-react";

type Variant = "sticky-top" | "inline";

interface PromoInfo {
  endsAt: string | null;
  isActive: boolean;
}

interface BetaPromoBannerProps {
  variant: Variant;
}

const DISMISS_KEY = "beta_promo_banner_dismissed_v1";

export default function BetaPromoBanner({ variant }: BetaPromoBannerProps) {
  const [promo, setPromo] = useState<PromoInfo | null>(null);
  const [dismissed, setDismissed] = useState(false);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    if (variant === "sticky-top" && typeof window !== "undefined") {
      if (localStorage.getItem(DISMISS_KEY)) setDismissed(true);
    }
    fetch("/api/beta/promo")
      .then((r) => r.json())
      .then((data: PromoInfo) => setPromo(data))
      .catch(() => {});
  }, [variant]);

  if (!mounted || !promo || !promo.isActive) return null;
  if (variant === "sticky-top" && dismissed) return null;

  const handleDismiss = () => {
    localStorage.setItem(DISMISS_KEY, "1");
    setDismissed(true);
  };

  if (variant === "inline") {
    return (
      <div className="rounded-md border border-emerald-500/40 bg-emerald-50 px-4 py-3 text-sm text-emerald-900">
        <div className="flex items-start gap-2">
          <span className="text-base leading-none mt-0.5">🧪</span>
          <div>
            <p className="font-semibold">โปรโมชั่นพิเศษช่วงเปิดตัว</p>
            <p className="mt-0.5 text-emerald-800">
              สมัครวันนี้รับ <strong>Beta ฟรี 21 วัน</strong> · ทำข้อสอบ{" "}
              <strong>25 ข้อ</strong> พร้อม AI ตรวจคำตอบ
            </p>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="relative bg-gradient-to-r from-emerald-600 to-emerald-700 text-white text-sm">
      <div className="mx-auto max-w-7xl px-4 py-2 pr-10 text-center">
        <span className="hidden sm:inline">🎉 </span>
        <span className="font-medium">ช่วงเปิดตัว:</span>{" "}
        สมัครฟรีรับ Beta 21 วัน · ทำข้อสอบ 25 ข้อกับ AI{" "}
        <Link
          href="/register"
          className="underline font-semibold hover:opacity-90 ml-1"
        >
          สมัครเลย →
        </Link>
      </div>
      <button
        onClick={handleDismiss}
        aria-label="ปิด"
        className="absolute right-2 top-1/2 -translate-y-1/2 p-1 rounded hover:bg-white/10"
      >
        <X className="h-4 w-4" />
      </button>
    </div>
  );
}
