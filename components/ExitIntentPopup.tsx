"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { X, Sparkles, ArrowRight } from "lucide-react";
import { Button } from "@/components/ui/button";
import { track } from "@/lib/analytics";
import { useIsLoggedIn } from "@/lib/hooks/useIsLoggedIn";

const SHOWN_KEY = "morroo_exit_intent_shown";

// Fires a single free-trial promo when the visitor signals they're about to
// leave: desktop = mouse exits through the top of the viewport, mobile = a
// fast upward swipe. Guests only — the CTA is "สมัครฟรีเลย" → /register, which
// makes no sense for anyone already logged in. Stored in sessionStorage so we
// never pester twice in the same tab. Wired into the root layout via
// <Suspense> so it doesn't bail the rest of the page out of static rendering.
export default function ExitIntentPopup() {
  const [open, setOpen] = useState(false);
  const isLoggedIn = useIsLoggedIn();

  useEffect(() => {
    if (typeof window === "undefined") return;
    // null = session still resolving; only arm the triggers for known guests.
    if (isLoggedIn !== false) return;
    try {
      if (window.sessionStorage.getItem(SHOWN_KEY)) return;
    } catch {
      // sessionStorage unavailable — still allow the popup to fire
    }

    let lastTouchY = 0;
    let scrollAccum = 0;
    let armed = false;
    // Once we've shown the popup, stop listening — otherwise every subsequent
    // mouse-out / swipe re-fires show() and spams the tracker (was seen firing
    // 80×/session) because the sessionStorage guard only runs on mount.
    let fired = false;

    // Arm only after the visitor has been on the page for a few seconds and
    // has scrolled a little; otherwise an instant exit feels spammy.
    const armTimer = window.setTimeout(() => {
      armed = true;
    }, 5000);

    function show(reason: "desktop_top" | "mobile_swipe") {
      if (!armed || fired) return;
      fired = true;
      document.removeEventListener("mouseleave", onMouseLeave);
      document.removeEventListener("touchstart", onTouchStart);
      document.removeEventListener("touchmove", onTouchMove);
      try {
        window.sessionStorage.setItem(SHOWN_KEY, "1");
      } catch {}
      track("exit_intent_show", { reason });
      setOpen(true);
    }

    function onMouseLeave(e: MouseEvent) {
      // Only treat "exit through the top" as intent; sideways or bottom is noisy.
      if (e.clientY <= 0) show("desktop_top");
    }

    function onTouchStart(e: TouchEvent) {
      lastTouchY = e.touches[0]?.clientY ?? 0;
      scrollAccum = 0;
    }

    function onTouchMove(e: TouchEvent) {
      const y = e.touches[0]?.clientY ?? 0;
      const dy = y - lastTouchY;
      lastTouchY = y;
      // Fast upward swipe near the top of the page = "I'm leaving" gesture.
      if (window.scrollY < 40 && dy > 8) {
        scrollAccum += dy;
        if (scrollAccum > 80) show("mobile_swipe");
      } else {
        scrollAccum = 0;
      }
    }

    document.addEventListener("mouseleave", onMouseLeave);
    document.addEventListener("touchstart", onTouchStart, { passive: true });
    document.addEventListener("touchmove", onTouchMove, { passive: true });

    return () => {
      window.clearTimeout(armTimer);
      document.removeEventListener("mouseleave", onMouseLeave);
      document.removeEventListener("touchstart", onTouchStart);
      document.removeEventListener("touchmove", onTouchMove);
    };
  }, [isLoggedIn]);

  if (!open) return null;

  return (
    <div
      className="fixed inset-0 z-[80] flex items-center justify-center bg-black/60 p-4 backdrop-blur-sm"
      onClick={() => {
        track("exit_intent_dismiss", { method: "backdrop" });
        setOpen(false);
      }}
    >
      <div
        role="dialog"
        aria-modal="true"
        className="relative w-full max-w-md rounded-2xl bg-white p-6 shadow-2xl"
        onClick={(e) => e.stopPropagation()}
      >
        <button
          aria-label="close"
          onClick={() => {
            track("exit_intent_dismiss", { method: "x" });
            setOpen(false);
          }}
          className="absolute right-3 top-3 rounded-full p-1.5 text-muted-foreground hover:bg-muted"
        >
          <X className="h-4 w-4" />
        </button>

        <div className="flex flex-col items-center text-center gap-3">
          <div className="h-14 w-14 rounded-full bg-brand/10 flex items-center justify-center">
            <Sparkles className="h-7 w-7 text-brand" />
          </div>
          <h2 className="text-xl font-bold text-foreground">
            รอเดี๋ยว! ลองข้อสอบฟรีก่อนไปไหม?
          </h2>
          <p className="text-sm text-muted-foreground">
            สมัครฟรีเข้าถึง <span className="font-semibold text-foreground">MCQ 5 ข้อ/สาขา · MEQ 2 เคส · Long Case 1 เคส</span>
            <br />
            ไม่ต้องใส่บัตรเครดิต ใช้เวลาแค่ 30 วินาที
          </p>
          <Link
            href="/register"
            onClick={() => track("exit_intent_cta_click")}
            className="w-full"
          >
            <Button
              size="lg"
              className="w-full bg-brand hover:bg-brand-light text-white"
            >
              สมัครฟรีเลย <ArrowRight className="ml-2 h-4 w-4" />
            </Button>
          </Link>
          <button
            onClick={() => {
              track("exit_intent_dismiss", { method: "later" });
              setOpen(false);
            }}
            className="text-xs text-muted-foreground hover:underline"
          >
            ไว้ก่อน
          </button>
        </div>
      </div>
    </div>
  );
}
