"use client";

import { useEffect, useRef } from "react";

interface GoodyEmbedProps {
  site: string;
  type: string;
  title?: string;
  className?: string;
}

export default function GoodyEmbed({ site, type, title, className }: GoodyEmbedProps) {
  const ref = useRef<HTMLIFrameElement>(null);

  useEffect(() => {
    function handler(e: MessageEvent) {
      if (e.source !== ref.current?.contentWindow) return;
      const data = e.data;
      if (data?.source === "goody" && typeof data.height === "number" && ref.current) {
        ref.current.style.height = `${data.height}px`;
      }
    }
    window.addEventListener("message", handler);
    return () => window.removeEventListener("message", handler);
  }, []);

  return (
    <iframe
      ref={ref}
      src={`https://goody-bay.vercel.app/?site=${site}&type=${type}`}
      title={title ?? `goody-${type}`}
      className={className}
      style={{ width: "100%", border: 0, display: "block" }}
      scrolling="no"
      loading="lazy"
    />
  );
}
