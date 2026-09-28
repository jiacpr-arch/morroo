"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { X } from "lucide-react";
import { isPromoActive } from "@/lib/beta";

type Variant = "sticky-top" | "inline";

interface PromoInfo {
  endsAt: string | null;
  isActive: boolean;
}

interface BetaPromoBannerProps {
  variant: Variant;
  /**
   * Promo state read on the server (layout). When given, the banner is in the
   * initial HTML and no client fetch happens — inserting it after load pushed
   * the whole page down (CLS).
   */
  initialPromo?: PromoInfo;
}

// Also read by the pre-paint script in app/(morroo)/layout.tsx, which sets
// html[data-promo-dismissed] so a dismissed banner is hidden before first paint.
const DISMISS_KEY = "beta_promo_banner_dismissed_v1";

export default function BetaPromoBanner({ variant, initialPromo }: BetaPromoBannerProps) {
  const [promo, setPromo] = useState<PromoInfo | null>(initialPromo ?? null);
  const [dismissed, setDismissed] = useState(false);
  const [mounted, setMounted] = useState(!!initialPromo);

  useEffect(() => {
    setMounted(true);
    if (variant === "sticky-top") {
      try {
        if (localStorage.getItem(DISMISS_KEY)) setDismissed(true);
      } catch {
        /* storage blocked — just show it */
      }
    }
    if (initialPromo) {
      // Server HTML may be cached past the promo end — drop it if expired.
      if (initialPromo.isActive && !isPromoActive(initialPromo.endsAt)) {
        setPromo({ ...initialPromo, isActive: false });
      }
      return;
    }
    fetch("/api/beta/promo")
      .then((r) => r.json())
      .then((data: PromoInfo) => setPromo(data))
      .catch(() => {});
  }, [variant, initialPromo]);

  if (!mounted || !promo || !promo.isActive) return null;
  if (variant === "sticky-top" && dismissed) return null;

  const handleDismiss = () => {
    try {
      localStorage.setItem(DISMISS_KEY, "1");
    } catch {
      /* ignore */
    }
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
    <div data-promo-banner className="relative bg-gradient-to-r from-emerald-600 to-emerald-700 text-white text-sm">
      {/* แถบนี้อยู่บนสุดของทุกหน้า = สิ่งแรกที่คนเห็น จึงนำด้วย "ลองก่อน" ไม่ใช่
          "สมัครเลย" (2026-07-25 เจ้าของสั่งว่าอยากโชว์ของก่อน ค่อยให้ลงทะเบียน
          ทีหลัง) โปรโมชั่น Beta ยังอยู่ครบ แค่ลดเป็นข้อเสนอรอง */}
      <div className="mx-auto max-w-7xl px-4 py-2 pr-10 text-center">
        <span className="hidden sm:inline">🎉 </span>
        ทำข้อสอบจริงฟรีได้เลย ไม่ต้องสมัคร{" "}
        <Link href="/nl/practice" className="underline font-semibold hover:opacity-90">
          ลองเลย →
        </Link>
        <span className="mx-2 hidden opacity-50 sm:inline">|</span>
        <span className="block sm:inline">
          <span className="opacity-90">ช่วงเปิดตัว: สมัครแล้วรับ Beta 21 วัน ทำข้อสอบ 25 ข้อกับ AI</span>{" "}
          <Link href="/register" className="underline hover:opacity-90">
            สมัครฟรี
          </Link>
        </span>
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
