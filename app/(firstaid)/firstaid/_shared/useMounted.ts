"use client";

import { useEffect, useState } from "react";

// True only after the first client render. Values that come from localStorage
// or persisted zustand stores must be gated behind this before they influence
// markup, or SSR HTML and the hydration render disagree.
export function useMounted() {
  const [mounted, setMounted] = useState(false);
  useEffect(() => {
    setMounted(true);
  }, []);
  return mounted;
}
