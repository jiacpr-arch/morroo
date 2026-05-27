"use client";

import { useEffect, useState } from "react";
import { usePathname } from "next/navigation";
import { X } from "lucide-react";
import { track } from "@/lib/analytics";
import { cn } from "@/lib/utils";
import { LineGlyph, SOCIAL_LINKS } from "@/components/SocialLinks";

const DISMISS_KEY = "morroo_line_fab_dismissed";

/**
 * Always-visible LINE add-friend bubble, pinned bottom-left so it never
 * overlaps the chat launcher (bottom-right). Hidden on admin / LIFF routes
 * and once the visitor dismisses it for the session.
 */
export default function FloatingLineButton() {
  const pathname = usePathname();
  const [dismissed, setDismissed] = useState(true);

  useEffect(() => {
    setDismissed(sessionStorage.getItem(DISMISS_KEY) === "1");
  }, []);

  const hiddenRoute =
    pathname?.startsWith("/admin") || pathname?.startsWith("/line");
  if (hiddenRoute || dismissed) return null;

  return (
    <div className="fixed bottom-5 left-5 z-50 flex items-center">
      <a
        href={SOCIAL_LINKS.line}
        target="_blank"
        rel="noopener noreferrer"
        aria-label="เพิ่มเพื่อนใน LINE OA หมอรู้ — รับข้อสอบฟรีทุกเช้า"
        onClick={() => track("social_click", { platform: "line", surface: "floating" })}
        className={cn(
          "group flex items-center gap-2 rounded-full bg-[#06C755] py-2.5 pl-3 pr-4 text-white shadow-lg transition-all",
          "hover:bg-[#05b34c] hover:scale-105 active:scale-95",
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
