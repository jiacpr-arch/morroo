"use client";

import { useEffect, useRef } from "react";
import { track } from "@/lib/analytics";
import { trackPricingViewContent } from "@/lib/analytics/conversions";

// Flag ต้องแยกตาม surface — เดิมใช้คีย์เดียวทั้งไซต์ ทำให้ tracker ของหน้าแรก
// (surface="home") ที่ยิงตอนคนกด "฿199 ดูแพ็กเกจ" → #pricing กินโควตาไปคนเดียว
// แล้วหน้า /pricing ที่เข้าทีหลังในsession เดียวกันเงียบสนิท ไม่ส่งทั้ง
// pricing_view และ Meta ViewContent — ทำให้ funnel ขั้น "เห็นราคา" ต่ำกว่าจริง
const sessionFlag = (surface: string) => `morroo_pricing_view_fired:${surface}`;

interface PricingViewTrackerProps {
  surface: string;
}

export default function PricingViewTracker({ surface }: PricingViewTrackerProps) {
  const sentinelRef = useRef<HTMLDivElement | null>(null);

  useEffect(() => {
    if (typeof window === "undefined") return;

    try {
      if (window.sessionStorage.getItem(sessionFlag(surface))) return;
    } catch {
      // sessionStorage may be unavailable in private mode; fall through and fire
    }

    const fire = () => {
      try {
        window.sessionStorage.setItem(sessionFlag(surface), "1");
      } catch {}
      track("pricing_view", { surface });
      trackPricingViewContent(surface);
    };

    const node = sentinelRef.current;
    if (!node || typeof IntersectionObserver === "undefined") {
      // Fallback: fire immediately
      fire();
      return;
    }

    const observer = new IntersectionObserver(
      (entries) => {
        for (const entry of entries) {
          if (entry.isIntersecting) {
            fire();
            observer.disconnect();
            return;
          }
        }
      },
      { threshold: 0.25 }
    );

    observer.observe(node);
    return () => observer.disconnect();
  }, [surface]);

  return <div ref={sentinelRef} aria-hidden className="h-px w-px" />;
}
