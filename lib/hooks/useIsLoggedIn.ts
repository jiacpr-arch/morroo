"use client";

import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";

/**
 * Whether the visitor has a Supabase session. Returns `null` until resolved,
 * so callers can treat "unknown" as logged-in and avoid flashing guest-only UI.
 * Reads the locally stored session (`getSession`) rather than `getUser` — this
 * runs on every page via the root layout, so it must not cost a network call.
 */
export function useIsLoggedIn(): boolean | null {
  const [isLoggedIn, setIsLoggedIn] = useState<boolean | null>(null);

  useEffect(() => {
    let cancelled = false;
    const supabase = createClient();
    Promise.resolve()
      // The env-less mock client has no getSession — treat any failure as guest.
      .then(() => supabase.auth.getSession())
      .then(({ data }) => {
        if (!cancelled) setIsLoggedIn(!!data.session);
      })
      .catch(() => {
        if (!cancelled) setIsLoggedIn(false);
      });
    return () => {
      cancelled = true;
    };
  }, []);

  return isLoggedIn;
}
