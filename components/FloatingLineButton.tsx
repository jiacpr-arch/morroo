"use client";

import { useEffect, useState } from "react";
import { usePathname } from "next/navigation";
import { X } from "lucide-react";
import { cn } from "@/lib/utils";
import { LineGlyph, SOCIAL_LINKS, trackLineClick } from "@/components/SocialLinks";
import type { LineCtaLevel } from "@/lib/line-cta-config";
import { isFocusedPracticeRoute } from "@/lib/focus-routes";

const DISMISS_KEY = "morroo_line_fab_dismissed";

/**
 * Desktop LINE add-friend bubble. Mobile visitors use the shared contact
 * launcher in ChatWidget so the two floating controls do not cover content.
 *
 * `level` comes from the Tier-1 config autopilot (app_settings). At level 2
 * the bubble gets an attention pulse — the daily cron raises it when LINE
 * click-through is low and drops it back once it recovers.
 */
export default function FloatingLineButton({
  level = 1,
}: {
  level?: LineCtaLevel;
}) {
  const pathname = usePathname();
  const [dismissed, setDismissed] = useState(true);

  useEffect(() => {
    setDismissed(sessionStorage.getItem(DISMISS_KEY) === "1");
  }, []);

  const hiddenRoute =
    pathname?.startsWith("/admin") || pathname?.startsWith("/line") || isFocusedPracticeRoute(pathname);
  if (hiddenRoute || dismissed) return null;

  const boosted = level === 2;

  return (
    <div className="fixed bottom-5 left-5 z-50 hidden items-center sm:flex">
      {boosted && (
        <span className="absolute left-0 top-1/2 -z-10 h-12 w-12 -translate-y-1/2 animate-ping rounded-full bg-[#06C755]/50" />
      )}
      <a
        href={SOCIAL_LINKS.line}
        target="_blank"
        rel="noopener noreferrer"
        aria-label="เพิ่มเพื่อนใน LINE OA หมอรู้ — รับข้อสอบฟรีทุกเช้า"
        onClick={() => trackLineClick("floating")}
        className={cn(
          "group flex items-center gap-2 rounded-full bg-[#06C755] py-2.5 pl-3 pr-4 text-white shadow-lg transition-all",
          "hover:bg-[#05b34c] hover:scale-105 active:scale-95",
          boosted && "ring-2 ring-[#06C755]/40 ring-offset-2",
        )}
      >
        <span className="h-6 w-6 shrink-0">
          <LineGlyph className="h-full w-full" />
        </span>
        <span className="text-sm font-semibold">แอด LINE รับข้อสอบฟรี</span>
      </a>
      <button
        type="button"
        onClick={() => {
          sessionStorage.setItem(DISMISS_KEY, "1");
          setDismissed(true);
        }}
        aria-label="ปิดปุ่ม LINE"
        className="ml-1 flex h-6 w-6 items-center justify-center rounded-full bg-black/40 text-white hover:bg-black/60"
      >
        <X className="h-3.5 w-3.5" />
      </button>
    </div>
  );
}
