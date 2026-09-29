"use client";

import { useEffect, useState } from "react";
import { ExternalLink } from "lucide-react";
import { NETWORK_SITES } from "@/lib/network-sites";

const ROTATE_MS = 7000;

interface Props {
  placement: string;
  className?: string;
}

export default function InternalAdsBanner({ placement, className }: Props) {
  // Render the first ad on the server so the banner's space is there from the
  // first paint — it used to render null until mount, then pop in above the
  // page content and push it down (CLS on /nl/practice etc.). The random
  // starting ad is picked after mount; every ad has the same height.
  const [idx, setIdx] = useState(0);

  useEffect(() => {
    setIdx(Math.floor(Math.random() * NETWORK_SITES.length));
    const t = setInterval(() => {
      setIdx((i) => (i + 1) % NETWORK_SITES.length);
    }, ROTATE_MS);
    return () => clearInterval(t);
  }, []);

  const ad = NETWORK_SITES[idx];

  return (
    <a
      href={ad.href}
      target="_blank"
      rel="noopener noreferrer"
      data-placement={placement}
      data-ad-href={ad.href}
      className={`group block overflow-hidden rounded-xl border border-brand/30 bg-gradient-to-r from-brand/5 via-white to-amber-50/40 px-4 py-3 transition-all duration-300 hover:-translate-y-0.5 hover:border-brand/60 hover:shadow-md ${className ?? ""}`}
    >
      <div
        key={idx}
        className="flex items-center gap-3 animate-in fade-in slide-in-from-bottom-1 duration-500"
      >
        <span
          className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-gradient-to-br from-brand/15 to-amber-100/80 text-xl shadow-inner"
          aria-hidden
        >
          {ad.emoji}
        </span>
        <div className="min-w-0 flex-1">
          {/* Single line (no wrap) so rotating ads never change the height. */}
          <div className="flex items-center gap-2">
            <span className="truncate font-semibold text-sm text-gray-900">
              {ad.label}
            </span>
            <span className="shrink-0 text-[10px] uppercase tracking-wide text-brand bg-brand/10 px-1.5 py-0.5 rounded-full">
              เว็บในเครือเรา
            </span>
          </div>
          <p className="text-xs text-muted-foreground truncate">
            {ad.tagline}
          </p>
        </div>
        <ExternalLink className="h-4 w-4 text-brand shrink-0 transition group-hover:translate-x-0.5" />
      </div>
    </a>
  );
}
