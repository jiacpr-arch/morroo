/**
 * Stable A/B variant assignment for the browser. Variant is picked once,
 * cached in localStorage, then reused across sessions so the same visitor
 * always sees the same hero.
 *
 * SSR-safe: returns null on the server. Callers must render-defer the
 * variant-specific markup until after hydration.
 */

export type Variant = "A" | "B";

const STORAGE_PREFIX = "morroo_ab_";

export function getVariant(experiment: string): Variant | null {
  if (typeof window === "undefined") return null;
  const key = STORAGE_PREFIX + experiment;
  try {
    const cached = window.localStorage.getItem(key);
    if (cached === "A" || cached === "B") return cached;
    const picked: Variant = Math.random() < 0.5 ? "A" : "B";
    window.localStorage.setItem(key, picked);
    return picked;
  } catch {
    return Math.random() < 0.5 ? "A" : "B";
  }
}

export function readVariant(experiment: string): Variant | null {
  if (typeof window === "undefined") return null;
  try {
    const cached = window.localStorage.getItem(STORAGE_PREFIX + experiment);
    return cached === "A" || cached === "B" ? cached : null;
  } catch {
    return null;
  }
}
