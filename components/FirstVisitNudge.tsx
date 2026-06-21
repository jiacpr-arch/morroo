"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { X, Sparkles, ArrowRight } from "lucide-react";
import { Button } from "@/components/ui/button";
import { track } from "@/lib/analytics";

const SEEN_KEY = "morroo_first_visit_nudge_v1";
const EXIT_INTENT_KEY = "morroo_exit_intent_shown";

// A gentle, non-blocking first-visit nudge that slides up from the bottom
// (corner card on desktop, full-width bar on mobile) inviting the visitor to
// try a free exam before signing up. Deliberately NOT a full-screen modal so
// it doesn't trip Google's intrusive-interstitial penalty on mobile (~60% of
// traffic) or spike bounce. Fires once per visitor (localStorage), after a
// short dwell or a bit of scrolling. Wired into the root layout.
export default function FirstVisitNudge() {
  const [open, setOpen] = useState(false);

  useEffect(() => {
    if (typeof window === "undefined") return;
    try {
      if (window.localStorage.getItem(SEEN_KEY)) return;
    } catch {
      // localStorage unavailable — still allow the nudge to fire
    }

    let fired = false;

    function cleanup() {
      window.clearTimeout(dwellTimer);
      window.removeEventListener("scroll", onScroll);
    }

    function show(trigger: "timer" | "scroll") {
      if (fired) return;
      fired = true;
      cleanup();
      // Don't stack on top of the exit-intent popup if it already fired.
      try {
        if (window.sessionStorage.getItem(EXIT_INTENT_KEY)) return;
      } catch {}
      try {
        window.localStorage.setItem(SEEN_KEY, "1");
      } catch {}
      track("first_visit_nudge_show", { trigger });
      setOpen(true);
    }

    function onScroll() {
      const scrollable =
        document.documentElement.scrollHeight - window.innerHeight;
      if (scrollable <= 0) return;
      if (window.scrollY / scrollable > 0.4) show("scroll");
    }

    // Whichever comes first: ~15s dwell, or scrolling past ~40% of the page.
    const dwellTimer = window.setTimeout(() => show("timer"), 15000);
    window.addEventListener("scroll", onScroll, { passive: true });

    return cleanup;
  }, []);

  function dismiss(method: "x" | "later") {
    track("first_visit_nudge_dismiss", { method });
    setOpen(false);
  }

  if (!open) return null;

  return (
    <div className="pointer-events-none fixed inset-x-0 bottom-0 z-[70] flex justify-center px-4 pb-4 sm:inset-x-auto sm:right-4 sm:justify-end">
      <div
        role="dialog"
        aria-label="ลองทำข้อสอบฟรี"
        className="pointer-events-auto relative w-full max-w-sm rounded-2xl bg-white p-5 shadow-2xl ring-1 ring-black/5 animate-in fade-in slide-in-from-bottom-4"
      >
        <button
          aria-label="ปิด"
          onClick={() => dismiss("x")}
          className="absolute right-3 top-3 rounded-full p-1.5 text-muted-foreground hover:bg-muted"
        >
          <X className="h-4 w-4" />
        </button>

        <div className="flex flex-col gap-3">
          <div className="flex items-center gap-2">
            <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-brand/10">
              <Sparkles className="h-5 w-5 text-brand" />
            </div>
            <h2 className="pr-6 text-base font-bold text-foreground">
              ลองทำข้อสอบฟรี ก่อนสมัคร
            </h2>
          </div>
          <p className="text-sm text-muted-foreground">
            เปิดดู{" "}
            <span className="font-semibold text-foreground">
              MCQ 5 ข้อ/สาขา · MEQ 2 เคส · Long Case 1 เคส
            </span>{" "}
            ได้เลย ไม่ต้องใส่บัตรเครดิต
          </p>
          <Link
            href="/exams"
            onClick={() => track("first_visit_nudge_cta_click")}
            className="w-full"
          >
            <Button
              size="lg"
              className="w-full bg-brand text-white hover:bg-brand-light"
            >
              ลองทำข้อสอบฟรี <ArrowRight className="ml-2 h-4 w-4" />
            </Button>
          </Link>
          <button
            onClick={() => dismiss("later")}
            className="text-xs text-muted-foreground hover:underline"
          >
            ไว้ก่อน
          </button>
        </div>
      </div>
    </div>
  );
}
