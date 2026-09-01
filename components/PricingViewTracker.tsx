"use client";

import { useEffect, useRef } from "react";
import { track } from "@/lib/analytics";

const SESSION_FLAG = "morroo_pricing_view_fired";

interface PricingViewTrackerProps {
  surface: string;
}

export default function PricingViewTracker({ surface }: PricingViewTrackerProps) {
  const sentinelRef = useRef<HTMLDivElement | null>(null);

  useEffect(() => {
    if (typeof window === "undefined") return;

    try {
      if (window.sessionStorage.getItem(SESSION_FLAG)) return;
    } catch {
      // sessionStorage may be unavailable in private mode; fall through and fire
    }

    const node = sentinelRef.current;
    if (!node || typeof IntersectionObserver === "undefined") {
      // Fallback: fire immediately
      try {
        window.sessionStorage.setItem(SESSION_FLAG, "1");
      } catch {}
      track("pricing_view", { surface });
      return;
    }

    const observer = new IntersectionObserver(
      (entries) => {
        for (const entry of entries) {
          if (entry.isIntersecting) {
            try {
              window.sessionStorage.setItem(SESSION_FLAG, "1");
            } catch {}
            track("pricing_view", { surface });
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
