"use client";

import { useEffect, useRef } from "react";
import { usePathname, useSearchParams } from "next/navigation";
import { track } from "@/lib/analytics";
import { attributionEventProps, captureAttribution, getBrowserStores } from "@/lib/attribution";
import { phRegister } from "@/lib/posthog";

/**
 * Mirrors page navigation to analytics_events as `pageview`. Vercel
 * Analytics handles its own pageview counting; this exists so the cron
 * digest + admin dashboard can compute funnel ratios against page views.
 *
 * ยังเป็นจุดที่จับ utm ตอนเข้าเว็บ/navigate ภายในเว็บด้วย (lib/attribution.ts)
 * — รันทุกครั้งที่ path/query เปลี่ยน เพื่อให้ last-touch อัปเดตถ้ามี utm ใหม่
 * (เช่นคลิกลิงก์โฆษณาอีกอันจากในเว็บ) แล้วส่งเข้า PostHog เป็น super property
 * ด้วย เพื่อให้ $pageview อัตโนมัติของ PostHog เองก็พก utm ไปด้วย
 */
export default function AnalyticsPageviewTracker() {
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const lastRef = useRef<string | null>(null);

  useEffect(() => {
    const search = searchParams?.toString() ? `?${searchParams}` : "";
    const url = pathname + search;
    if (lastRef.current === url) return;
    lastRef.current = url;

    const stores = getBrowserStores();
    captureAttribution({ search, pathname }, stores);
    const props = attributionEventProps(stores);
    if (props) phRegister(props);

    track("pageview");
  }, [pathname, searchParams]);

  return null;
}
