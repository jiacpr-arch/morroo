"use client";

import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useState,
} from "react";
import type { BetaStatus } from "@/lib/beta";

interface RawStatus
  extends Omit<BetaStatus, "expiresAt" | "couponIssuedAt"> {
  expiresAt: string | null;
  couponIssuedAt: string | null;
}

interface Ctx {
  status: BetaStatus | null;
  loading: boolean;
  refresh: () => Promise<void>;
  recordAttempt: () => void;
  markWelcomeSeen: () => Promise<void>;
}

const BetaContext = createContext<Ctx | null>(null);

function hydrate(raw: RawStatus | null): BetaStatus | null {
  if (!raw) return null;
  return {
    ...raw,
    expiresAt: raw.expiresAt ? new Date(raw.expiresAt) : null,
    couponIssuedAt: raw.couponIssuedAt ? new Date(raw.couponIssuedAt) : null,
  };
}

export function BetaProvider({ children }: { children: React.ReactNode }) {
  const [status, setStatus] = useState<BetaStatus | null>(null);
  const [loading, setLoading] = useState(true);

  const refresh = useCallback(async () => {
    try {
      const res = await fetch("/api/beta/status", { cache: "no-store" });
      const data = (await res.json()) as {
        authenticated: boolean;
        status: RawStatus | null;
      };
      setStatus(hydrate(data.status));
    } catch {
      setStatus(null);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    refresh();
  }, [refresh]);

  // Client-side optimistic bump so header counter feels instant.
  // DB trigger is the source of truth; we reconcile on next refresh().
  const recordAttempt = useCallback(() => {
    setStatus((prev) => {
      if (!prev || !prev.isBeta) return prev;
      const used = Math.min(prev.questionsLimit, prev.questionsUsed + 1);
      const remaining = Math.max(0, prev.questionsLimit - used);
      return {
        ...prev,
        questionsUsed: used,
        questionsRemaining: remaining,
        isQuotaExhausted: remaining === 0,
        tier: remaining === 0 || prev.isExpired ? "beta_exhausted" : "beta",
      };
    });
  }, []);

  const markWelcomeSeen = useCallback(async () => {
    setStatus((prev) => (prev ? { ...prev, hasSeenWelcome: true } : prev));
    try {
      await fetch("/api/beta/welcome", { method: "POST" });
    } catch {
      /* best-effort */
    }
  }, []);

  return (
    <BetaContext.Provider value={{ status, loading, refresh, recordAttempt, markWelcomeSeen }}>
      {children}
    </BetaContext.Provider>
  );
}

export function useBeta(): Ctx {
  const ctx = useContext(BetaContext);
  if (!ctx) {
    // Safe no-op fallback: lets components import the hook without forcing
    // every page to be wrapped by the provider.
    return {
      status: null,
      loading: false,
      refresh: async () => {},
      recordAttempt: () => {},
      markWelcomeSeen: async () => {},
    };
  }
  return ctx;
}
