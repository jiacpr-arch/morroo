"use client";

import { useEffect } from "react";
import { usePathname } from "next/navigation";

// firstaid's own Meta Pixel (a different pixel than morroo's, which lives in
// app/(morroo)/layout.tsx and never loads on the firstaid host). No hardcoded
// fallback: when NEXT_PUBLIC_FIRSTAID_META_PIXEL_ID is unset (local dev,
// previews, forks) the pixel stays off so those environments never send events
// to the real production pixel.
const PIXEL_ID = process.env.NEXT_PUBLIC_FIRSTAID_META_PIXEL_ID || "";

type Fbq = {
  (...args: unknown[]): void;
  callMethod?: (...args: unknown[]) => void;
  queue: unknown[];
  push: Fbq;
  loaded: boolean;
  version: string;
};

declare global {
  interface Window {
    fbq?: Fbq;
    _fbq?: Fbq;
  }
}

// Typed equivalent of Meta's stock bootstrap snippet: install a queueing fbq
// stub, then load fbevents.js which drains the queue.
function installFbq() {
  if (window.fbq) return;
  const fbq = ((...args: unknown[]) => {
    if (fbq.callMethod) {
      fbq.callMethod(...args);
    } else {
      fbq.queue.push(args);
    }
  }) as Fbq;
  fbq.queue = [];
  fbq.push = fbq;
  fbq.loaded = true;
  fbq.version = "2.0";
  window.fbq = fbq;
  if (!window._fbq) window._fbq = fbq;
  const script = document.createElement("script");
  script.async = true;
  script.src = "https://connect.facebook.net/en_US/fbevents.js";
  document.head.appendChild(script);
}

export default function MetaPixel() {
  const pathname = usePathname();

  useEffect(() => {
    if (!PIXEL_ID || window.fbq) return;
    installFbq();
    window.fbq!("init", PIXEL_ID);
  }, []);

  useEffect(() => {
    if (!PIXEL_ID || !window.fbq) return;
    window.fbq("track", "PageView");
  }, [pathname]);

  return null;
}
