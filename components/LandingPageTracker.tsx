"use client";

import { useEffect, useRef } from "react";
import { track } from "@/lib/analytics";

type Props = {
  event: string;
  properties?: Record<string, string | number | boolean | null>;
};

// Fires a Vercel + Supabase analytics event once per session for a landing
// page. Lives as a tiny client component so it can sit inside server-rendered
// pages without making the whole route client.
export default function LandingPageTracker({ event, properties }: Props) {
  const firedRef = useRef(false);

  useEffect(() => {
    if (firedRef.current) return;
    firedRef.current = true;
    track(event, properties);
  }, [event, properties]);

  return null;
}
