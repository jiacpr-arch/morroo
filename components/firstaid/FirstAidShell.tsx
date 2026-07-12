"use client";

import { useEffect, useState } from "react";
import { usePathname, useRouter } from "next/navigation";
import { useSettingsStore } from "@/lib/firstaid/stores/settingsStore";
import { useLearnerStore } from "@/lib/firstaid/stores/learnerStore";
import { initAuthListener } from "@/lib/firstaid/stores/authStore";
import { useEnsureLearner } from "@/lib/firstaid/hooks/useLearner";
import { initPostHog, identifyLearner, phCapture } from "@/lib/firstaid/posthog";
import { lessons } from "@/lib/firstaid/content/lessons";
import InAppBrowserNotice from "@/components/firstaid/InAppBrowserNotice";
import BottomTabBar from "@/components/firstaid/BottomTabBar";
import { HouseAdStrip } from "@/components/firstaid/HouseAdBanner";
import CallEmergencyButton from "@/components/firstaid/CallEmergencyButton";

const FIRST_LESSON_PATH = `/learn/${(lessons as Array<{ id: string }>)[0].id}`;

// Paths a brand-new (onboarding) visitor may see besides the first lesson:
// the 1669 call page must always work, and the LINE callback must be able to land.
const ONBOARDING_ALLOWED = new Set([
  FIRST_LESSON_PATH,
  "/call",
  "/auth/line/callback",
]);

// App shell ported from the old SPA's App.jsx: learner bootstrap, PostHog,
// auth listener, theme, pageview tracking, onboarding soft-gate, tab bar +
// house-ad strip. Rendered by app/(firstaid)/firstaid/layout.tsx around every
// firstaid page. (No admin branch — admin stays on the legacy app until Phase 3.)
export default function FirstAidShell({
  children,
}: {
  children: React.ReactNode;
}) {
  const pathname = usePathname() || "/";
  const router = useRouter();
  const theme = useSettingsStore((s) => s.theme);

  // มี learner ภายในเสมอ (anonymous) เพื่อเก็บโปรไฟล์/ความก้าวหน้า
  useEnsureLearner();
  const learner = useLearnerStore((s) => s.learner);

  // learner comes from a persisted zustand store (localStorage) — decisions
  // that depend on it must wait for mount, or SSR HTML and the first client
  // render disagree (hydration mismatch / redirect flash).
  const [mounted, setMounted] = useState(false);
  useEffect(() => {
    setMounted(true);
  }, []);

  useEffect(() => {
    initPostHog();
  }, []);

  // เปิด listener สถานะล็อกอิน (LINE → Supabase Auth) ครั้งเดียวตอนแอปเริ่ม
  useEffect(() => initAuthListener(), []);

  useEffect(() => {
    if (learner?.id)
      identifyLearner({
        learnerId: learner.id,
        lineUserId: learner.lineUserId,
        displayName: learner.name,
      });
  }, [learner?.id, learner?.lineUserId, learner?.name]);

  // ยิง $pageview เข้า PostHog ทุกครั้งที่เปลี่ยนหน้า (init ตั้ง capture_pageview:false)
  useEffect(() => {
    phCapture("$pageview");
  }, [pathname]);

  // Theme: toggle .dark on <html>, tracking the OS preference in "system" mode.
  useEffect(() => {
    const root = document.documentElement;
    const apply = (isDark: boolean) => root.classList.toggle("dark", isDark);
    if (theme === "system") {
      const mq = window.matchMedia("(prefers-color-scheme: dark)");
      apply(mq.matches);
      const onChange = (e: MediaQueryListEvent) => apply(e.matches);
      mq.addEventListener("change", onChange);
      return () => mq.removeEventListener("change", onChange);
    }
    apply(theme === "dark");
  }, [theme]);

  // On the subdomain the browser URL has no /firstaid prefix, but during
  // direct QA (localhost/preview) pages are reachable at /firstaid/* too —
  // normalise so the gate works in both, and keep redirects on the same base.
  const hasInternalPrefix = /^\/firstaid(\/|$)/.test(pathname);
  const publicPath = hasInternalPrefix
    ? pathname.replace(/^\/firstaid/, "") || "/"
    : pathname;
  const firstLessonHref = hasInternalPrefix
    ? `/firstaid${FIRST_LESSON_PATH}`
    : FIRST_LESSON_PATH;

  // Onboarding (soft gate): ครั้งแรกพาไปเริ่มที่บทแรกเพื่อให้ได้เห็นคำชวนแอด LINE
  // @jiacpr หลังเรียนจบบท 1 แต่ "ไม่บังคับ" — ถ้ากด "ดูภายหลัง" (lineSkippedAt)
  // หรือแอดแล้ว (lineAdded) ก็เข้าทุกหน้าได้อิสระ
  const onboarding =
    mounted && (!learner || (!learner.lineAdded && !learner.lineSkippedAt));
  const needsRedirect = onboarding && !ONBOARDING_ALLOWED.has(publicPath);

  useEffect(() => {
    if (needsRedirect) router.replace(firstLessonHref);
  }, [needsRedirect, firstLessonHref, router]);

  return (
    <div style={{ minHeight: "100vh" }}>
      <InAppBrowserNotice />
      {/* Null-render guard replaces the old synchronous <Navigate>: while the
          redirect to the first lesson is in flight, don't flash the gated page. */}
      {needsRedirect ? null : children}
      {mounted && !onboarding && <HouseAdStrip />}
      {mounted && !onboarding && <BottomTabBar />}
      {/* ระหว่าง onboarding ซ่อนแท็บบาร์เพื่อบังคับเรียนบทแรก แต่คงปุ่มโทร 1669 ไว้เสมอ */}
      {onboarding && <CallEmergencyButton />}
    </div>
  );
}
