"use client";

import { create } from "zustand";

type EntitlementState = {
  chapters: Set<number>;
  loaded: boolean;
  loading: boolean;
  refresh: (loggedIn: boolean) => Promise<void>;
};

// Which chapters (0 = whole-course bundle, 1-4 = single chapter) the logged-in
// learner has purchased. Entitlements only exist server-side against the
// durable learner_id, so an anonymous (not-logged-in) learner always resolves
// to an empty set here. Auth now travels via the Supabase SSR session cookie
// instead of a bearer header.
export const useEntitlementStore = create<EntitlementState>((set) => ({
  chapters: new Set<number>(),
  loaded: false,
  loading: false,
  refresh: async (loggedIn) => {
    if (!loggedIn) {
      set({ chapters: new Set(), loaded: true, loading: false });
      return;
    }
    set({ loading: true });
    try {
      const res = await fetch("/api/firstaid/entitlements");
      if (!res.ok) {
        set({ loaded: true, loading: false });
        return;
      }
      const data = (await res.json()) as { chapters?: number[] };
      set({
        chapters: new Set(data.chapters ?? []),
        loaded: true,
        loading: false,
      });
    } catch {
      // Network error — leave as locked rather than hang; a later refresh
      // (reconnect, revisit) retries.
      set({ loaded: true, loading: false });
    }
  },
}));
