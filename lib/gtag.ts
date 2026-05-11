"use client";

/**
 * Browser-side helpers for GA4 + Google Ads conversion tracking.
 *
 * Safe on SSR — every function no-ops when `window.gtag` is unavailable.
 */

import { getSendTo, type ConversionEvent } from "@/lib/google-ads";

declare global {
  interface Window {
    dataLayer?: unknown[];
    gtag?: (...args: unknown[]) => void;
  }
}

function gtagSafe(...args: unknown[]) {
  if (typeof window === "undefined") return;
  if (typeof window.gtag !== "function") {
    window.dataLayer = window.dataLayer ?? [];
    window.dataLayer.push(args);
    return;
  }
  window.gtag(...args);
}

/** Fire a Google Ads conversion. Safe to call without IDs configured. */
export function trackConversion(
  event: ConversionEvent,
  params?: {
    value?: number;
    currency?: string;
    transactionId?: string;
    eventCallback?: () => void;
  }
) {
  const sendTo = getSendTo(event);
  if (!sendTo) {
    params?.eventCallback?.();
    return;
  }
  const payload: Record<string, unknown> = { send_to: sendTo };
  if (params?.value !== undefined) payload.value = params.value;
  if (params?.currency) payload.currency = params.currency;
  if (params?.transactionId) payload.transaction_id = params.transactionId;
  if (params?.eventCallback) {
    payload.event_callback = params.eventCallback;
    payload.event_timeout = 2000;
  }
  gtagSafe("event", "conversion", payload);
}

/** Fire a generic GA4 event. */
export function trackEvent(
  name: string,
  params?: Record<string, unknown>
) {
  gtagSafe("event", name, params ?? {});
}

/**
 * Read Google Ads click identifiers + UTM tags from the URL or sessionStorage,
 * persisting them across navigations within the session.
 *
 * Returns `null` outside the browser.
 */
export type AdsAttribution = {
  gclid?: string;
  gbraid?: string;
  wbraid?: string;
  fbclid?: string;
  fbc?: string;
  fbp?: string;
  utm_source?: string;
  utm_medium?: string;
  utm_campaign?: string;
  utm_term?: string;
  utm_content?: string;
  referrer?: string;
  landing_page?: string;
};

const ATTRIBUTION_KEY = "morroo:ads_attribution";

export function captureAdsAttribution(): AdsAttribution | null {
  if (typeof window === "undefined") return null;

  const url = new URL(window.location.href);
  const fromUrl: AdsAttribution = {};
  const params = url.searchParams;

  for (const k of [
    "gclid",
    "gbraid",
    "wbraid",
    "utm_source",
    "utm_medium",
    "utm_campaign",
    "utm_term",
    "utm_content",
  ] as const) {
    const v = params.get(k);
    if (v) (fromUrl as Record<string, string>)[k] = v;
  }

  let merged: AdsAttribution = {};
  try {
    const cached = window.sessionStorage.getItem(ATTRIBUTION_KEY);
    if (cached) merged = JSON.parse(cached) as AdsAttribution;
  } catch {
    // ignore
  }

  merged = { ...merged, ...fromUrl };
  if (!merged.referrer && document.referrer) merged.referrer = document.referrer;
  if (!merged.landing_page) merged.landing_page = url.pathname + url.search;

  try {
    window.sessionStorage.setItem(ATTRIBUTION_KEY, JSON.stringify(merged));
  } catch {
    // ignore
  }

  return merged;
}

export function getStoredAttribution(): AdsAttribution | null {
  if (typeof window === "undefined") return null;
  try {
    const cached = window.sessionStorage.getItem(ATTRIBUTION_KEY);
    return cached ? (JSON.parse(cached) as AdsAttribution) : null;
  } catch {
    return null;
  }
}
