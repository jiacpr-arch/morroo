"use client";

import { useEffect, useRef } from "react";
import { usePathname, useSearchParams } from "next/navigation";
import { track } from "@/lib/analytics";

/**
 * Mirrors page navigation to analytics_events as `pageview`. Vercel
 * Analytics handles its own pageview counting; this exists so the cron
 * digest + admin dashboard can compute funnel ratios against page views.
 */
export default function AnalyticsPageviewTracker() {
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const lastRef = useRef<string | null>(null);

  useEffect(() => {
    const url = pathname + (searchParams?.toString() ? `?${searchParams}` : "");
    if (lastRef.current === url) return;
    lastRef.current = url;
    track("pageview");
  }, [pathname, searchParams]);

  return null;
}
