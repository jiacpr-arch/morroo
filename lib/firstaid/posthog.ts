"use client";

import posthog from "posthog-js";

// firstaid-scoped PostHog. Gated on its own env var so morroo pages (which
// don't use PostHog) never load it, and previews without the key stay silent.
const KEY = process.env.NEXT_PUBLIC_FIRSTAID_POSTHOG_KEY;
const HOST =
  process.env.NEXT_PUBLIC_FIRSTAID_POSTHOG_HOST || "https://us.i.posthog.com";

let initialised = false;

export function initPostHog() {
  if (!KEY || initialised) return;
  posthog.init(KEY, {
    api_host: HOST,
    person_profiles: "identified_only",
    capture_pageview: false,
    capture_pageleave: false,
    autocapture: false,
  });
  initialised = true;
}

export function identifyLearner({
  learnerId,
  lineUserId,
  displayName,
}: {
  learnerId?: string;
  lineUserId?: string;
  displayName?: string;
} = {}) {
  if (!KEY || !initialised) return;
  if (learnerId) {
    posthog.identify(learnerId, {
      ...(lineUserId ? { lineUserId } : {}),
      ...(displayName ? { displayName } : {}),
    });
  }
}

export function phCapture(event: string, props?: Record<string, unknown>) {
  if (!KEY || !initialised) return;
  posthog.capture(event, props);
}
