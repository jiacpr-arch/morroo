"use client";

import {
  createContext,
  useCallback,
  useContext,
  useRef,
  useState,
} from "react";

interface Ctx {
  /** True when AI has failed repeatedly and the user hasn't dismissed the banner. */
  degraded: boolean;
  /** Call when an AI request surfaces an error to the user. */
  reportAiFailure: () => void;
  /** Call when an AI request succeeds — clears the degraded state. */
  reportAiSuccess: () => void;
  /** User dismissed the banner for this session. */
  dismiss: () => void;
}

const AiHealthContext = createContext<Ctx | null>(null);

// Show the banner only after a couple of failures in a short window, so a single
// transient blip doesn't alarm everyone. Auto-clear after a quiet period.
const FAILURE_WINDOW_MS = 60_000;
const FAILURE_THRESHOLD = 2;
const AUTO_CLEAR_MS = 120_000;

/**
 * Broadcasts a lightweight "AI is degraded" signal across the app so a
 * site-wide banner can warn users during a partial Anthropic outage. Mirrors the
 * BetaProvider pattern (React Context, safe no-op fallback hook).
 */
export function AiHealthProvider({ children }: { children: React.ReactNode }) {
  const [degraded, setDegraded] = useState(false);
  const [dismissed, setDismissed] = useState(false);
  const failuresRef = useRef<number[]>([]);
  const clearTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  const reportAiFailure = useCallback(() => {
    const now = Date.now();
    failuresRef.current = failuresRef.current.filter((t) => now - t < FAILURE_WINDOW_MS);
    failuresRef.current.push(now);
    if (failuresRef.current.length >= FAILURE_THRESHOLD) {
      setDegraded(true);
      setDismissed(false);
      if (clearTimerRef.current) clearTimeout(clearTimerRef.current);
      clearTimerRef.current = setTimeout(() => {
        setDegraded(false);
        failuresRef.current = [];
      }, AUTO_CLEAR_MS);
    }
  }, []);

  const reportAiSuccess = useCallback(() => {
    failuresRef.current = [];
    if (clearTimerRef.current) clearTimeout(clearTimerRef.current);
    setDegraded(false);
  }, []);

  const dismiss = useCallback(() => setDismissed(true), []);

  return (
    <AiHealthContext.Provider
      value={{ degraded: degraded && !dismissed, reportAiFailure, reportAiSuccess, dismiss }}
    >
      {children}
    </AiHealthContext.Provider>
  );
}

export function useAiHealth(): Ctx {
  const ctx = useContext(AiHealthContext);
  if (!ctx) {
    // Safe no-op fallback so components can call the hook without forcing every
    // page to be wrapped by the provider.
    return {
      degraded: false,
      reportAiFailure: () => {},
      reportAiSuccess: () => {},
      dismiss: () => {},
    };
  }
  return ctx;
}
