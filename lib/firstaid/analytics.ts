"use client";

import { phCapture } from "@/lib/firstaid/posthog";

function fbqCustom(event: string, props: Record<string, unknown>) {
  try {
    window.fbq?.("trackCustom", event, props);
  } catch {
    /* tracking must not crash the app */
  }
}

/**
 * Central analytics sink — fans out to Meta Pixel + PostHog.
 * All milestone events in the app should go through here.
 *
 * @param event  snake_case event name
 */
export function track(event: string, props: Record<string, unknown> = {}) {
  fbqCustom(event, props);
  phCapture(event, props);
}
