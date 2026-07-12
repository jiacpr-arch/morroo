"use client";

import { useEffect } from "react";
import { usePathname } from "next/navigation";

// firstaid's own Meta Pixel (a different pixel than morroo's, which lives in
// app/(morroo)/layout.tsx and never loads on the firstaid host). No hardcoded
// fallback: when NEXT_PUBLIC_FIRSTAID_META_PIXEL_ID is unset (local dev,
// previews, forks) the pixel stays off so those environments never send events
// to the real production pixel.
//
// window.fbq's type is declared once repo-wide in lib/analytics/conversions.ts
// as (...args: unknown[]) => void — don't redeclare it here.
const PIXEL_ID = process.env.NEXT_PUBLIC_FIRSTAID_META_PIXEL_ID || "";

type FbqStub = ((...args: unknown[]) => void) & {
  callMethod?: (...args: unknown[]) => void;
  queue: unknown[];
  push: unknown;
  loaded: boolean;
  version: string;
};

// Typed equivalent of Meta's stock bootstrap snippet: install a queueing fbq
// stub, then load fbevents.js which drains the queue.
function installFbq(): FbqStub {
  const fbq = ((...args: unknown[]) => {
    if (fbq.callMethod) {
      fbq.callMethod(...args);
    } else {
      fbq.queue.push(args);
    }
  }) as FbqStub;
  fbq.queue = [];
  fbq.push = fbq;
  fbq.loaded = true;
  fbq.version = "2.0";
  window.fbq = fbq;
  const w = window as unknown as Record<string, unknown>;
  if (!w._fbq) w._fbq = fbq;
  const script = document.createElement("script");
  script.async = true;
  script.src = "https://connect.facebook.net/en_US/fbevents.js";
  document.head.appendChild(script);
  return fbq;
}

export default function MetaPixel() {
  const pathname = usePathname();

  useEffect(() => {
    if (!PIXEL_ID || window.fbq) return;
    const fbq = installFbq();
    fbq("init", PIXEL_ID);
  }, []);

  useEffect(() => {
    if (!PIXEL_ID || !window.fbq) return;
    window.fbq("track", "PageView");
  }, [pathname]);

  return null;
}
