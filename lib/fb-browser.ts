"use client";

/**
 * Browser-side helpers for Facebook Pixel.
 *
 * Safe on SSR — every function no-ops when `window.fbq` is unavailable
 * (which is also the case when ad-blockers strip the script).
 */

import type { FbEventName } from "@/lib/facebook-pixel";

declare global {
  interface Window {
    fbq?: ((...args: unknown[]) => void) & { queue?: unknown[]; loaded?: boolean };
    _fbq?: unknown;
  }
}

/**
 * Fire a Pixel event. `eventId` is optional — pass it when the same event
 * is also being mirrored via CAPI server-side, so Meta dedups them.
 */
export function trackFbEvent(
  name: FbEventName,
  params?: Record<string, unknown>,
  eventId?: string
) {
  if (typeof window === "undefined" || typeof window.fbq !== "function") return;
  if (eventId) {
    window.fbq("track", name, params ?? {}, { eventID: eventId });
  } else {
    window.fbq("track", name, params ?? {});
  }
}

export type FbAttribution = {
  fbclid?: string;
  fbc?: string;
  fbp?: string;
};

const FB_ATTRIBUTION_KEY = "morroo:fb_attribution";

/** Read a cookie by name. Returns undefined if not present or on SSR. */
function readCookie(name: string): string | undefined {
  if (typeof document === "undefined") return undefined;
  const match = document.cookie.match(
    new RegExp(`(?:^|;\\s*)${name}=([^;]+)`)
  );
  return match ? decodeURIComponent(match[1]) : undefined;
}

/**
 * Read fbclid from URL + _fbp/_fbc cookies (set by fbq) and persist into
 * sessionStorage so subsequent navigations can reuse them.
 *
 * If we have fbclid but no _fbc cookie yet (Pixel not initialised in time),
 * we synthesize the _fbc value in Meta's documented format so CAPI can
 * still match.
 */
export function captureFbAttribution(): FbAttribution | null {
  if (typeof window === "undefined") return null;

  const url = new URL(window.location.href);
  const fbclid = url.searchParams.get("fbclid") ?? undefined;
  const fbpCookie = readCookie("_fbp");
  const fbcCookie = readCookie("_fbc");

  let stored: FbAttribution = {};
  try {
    const raw = window.sessionStorage.getItem(FB_ATTRIBUTION_KEY);
    if (raw) stored = JSON.parse(raw) as FbAttribution;
  } catch {
    // ignore
  }

  const merged: FbAttribution = { ...stored };
  if (fbclid) merged.fbclid = fbclid;
  if (fbpCookie) merged.fbp = fbpCookie;
  if (fbcCookie) merged.fbc = fbcCookie;
  // Synthesize _fbc when we have a fresh fbclid but no cookie yet.
  if (fbclid && !merged.fbc) {
    merged.fbc = `fb.1.${Date.now()}.${fbclid}`;
  }

  try {
    window.sessionStorage.setItem(FB_ATTRIBUTION_KEY, JSON.stringify(merged));
  } catch {
    // ignore
  }

  return merged;
}

export function getStoredFbAttribution(): FbAttribution | null {
  if (typeof window === "undefined") return null;
  try {
    const raw = window.sessionStorage.getItem(FB_ATTRIBUTION_KEY);
    return raw ? (JSON.parse(raw) as FbAttribution) : null;
  } catch {
    return null;
  }
}

/** Generate a UUID for use as Pixel `eventID`. */
export function newClientEventId(): string {
  if (typeof crypto !== "undefined" && typeof crypto.randomUUID === "function") {
    return crypto.randomUUID();
  }
  // Fallback (extremely old browsers — should never hit in practice).
  return `${Date.now()}-${Math.random().toString(36).slice(2)}`;
}
