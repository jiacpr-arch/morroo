"use client";

import { create } from "zustand";
import type { Session } from "@supabase/supabase-js";
import { createClient } from "@/lib/supabase/client";

type AuthState = {
  session: Session | null;
  loading: boolean;
  setSession: (session: Session | null) => void;
};

// Learner Supabase Auth session (separate concern from the local learner profile).
// Initialized once from FirstAidShell via initAuthListener(); components read it
// reactively. Uses morroo's shared @supabase/ssr browser client, so the session
// cookie is the same one the server routes read.
export const useAuthStore = create<AuthState>((set) => ({
  session: null,
  loading: true,
  setSession: (session) => set({ session, loading: false }),
}));

let started = false;

// Wire getSession() + onAuthStateChange once. Returns an unsubscribe fn.
export function initAuthListener() {
  if (started) return () => {};
  started = true;
  const supabase = createClient();
  const { setSession } = useAuthStore.getState();

  supabase.auth
    .getSession()
    .then(({ data }: { data: { session: Session | null } }) =>
      setSession(data?.session ?? null),
    )
    .catch(() => setSession(null));
  const { data: sub } = supabase.auth.onAuthStateChange(
    (_event: string, session: Session | null) => {
      setSession(session ?? null);
    },
  );
  return () => {
    started = false;
    sub?.subscription?.unsubscribe?.();
  };
}
