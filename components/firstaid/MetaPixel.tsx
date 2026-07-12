"use client";

import { useEffect } from "react";
import { usePathname } from "next/navigation";

// firstaid's own Meta Pixel (a different pixel than morroo's, which lives in
// app/(morroo)/layout.tsx and never loads on the firstaid host). No hardcoded
// fallback: when NEXT_PUBLIC_FIRSTAID_META_PIXEL_ID is unset (local dev,
// previews, forks) the pixel stays off so those environments never send events
// to the real production pixel.
const PIXEL_ID = process.env.NEXT_PUBLIC_FIRSTAID_META_PIXEL_ID || "";

declare global {
  interface Window {
    fbq?: (...args: unknown[]) => void;
    _fbq?: unknown;
  }
}

export default function MetaPixel() {
  const pathname = usePathname();

  useEffect(() => {
    if (!PIXEL_ID || window.fbq) return;
    /* eslint-disable */
    // prettier-ignore
    // @ts-expect-error — Meta's stock pixel bootstrap snippet, kept verbatim
    !function(f,b,e,v,n,t,s){if(f.fbq)return;n=f.fbq=function(){n.callMethod?
    n.callMethod.apply(n,arguments):n.queue.push(arguments)};if(!f._fbq)f._fbq=n;
    n.push=n;n.loaded=!0;n.version='2.0';n.queue=[];t=b.createElement(e);t.async=!0;
    t.src=v;s=b.getElementsByTagName(e)[0];s.parentNode.insertBefore(t,s)}
    (window,document,'script','https://connect.facebook.net/en_US/fbevents.js');
    /* eslint-enable */
    window.fbq!("init", PIXEL_ID);
  }, []);

  useEffect(() => {
    if (!PIXEL_ID || !window.fbq) return;
    window.fbq("track", "PageView");
  }, [pathname]);

  return null;
}
