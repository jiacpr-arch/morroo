/**
 * trackEvent — fires both the Vercel Web Analytics event (so it shows
 * up in the dashboard) and a mirror to our own analytics_events table
 * via /api/analytics/track (so we can query it for digests/admin pages).
 *
 * Session ID is generated per browser tab and kept in sessionStorage,
 * so a single visitor's events stay grouped for funnel analysis.
 */

import { track as vercelTrack } from "@vercel/analytics";
import { phCapture } from "@/lib/posthog";

type Properties = Record<string, string | number | boolean | null>;

const SESSION_KEY = "morroo_aid";

function getSessionId(): string | null {
  if (typeof window === "undefined") return null;
  try {
    let id = window.sessionStorage.getItem(SESSION_KEY);
    if (!id) {
      id =
        typeof crypto !== "undefined" && crypto.randomUUID
          ? crypto.randomUUID()
          : `s_${Date.now()}_${Math.random().toString(36).slice(2, 10)}`;
      window.sessionStorage.setItem(SESSION_KEY, id);
    }
    return id;
  } catch {
    return null;
  }
}

export function track(eventName: string, properties?: Properties): void {
  if (typeof window === "undefined") return;

  if (properties) {
    vercelTrack(eventName, properties);
  } else {
    vercelTrack(eventName);
  }

  // Mirror ทุก event เข้า PostHog ด้วย — ยกเว้น pageview เพราะ PostHog จับ
  // $pageview ของตัวเองอยู่แล้ว (history_change) จะได้ไม่นับซ้ำ
  if (eventName !== "pageview") {
    phCapture(eventName, properties);
  }

  const payload = {
    event_name: eventName,
    properties: properties ?? null,
    session_id: getSessionId(),
    path: window.location.pathname + window.location.search,
    referrer: document.referrer || null,
  };

  // Fire-and-forget. keepalive so it survives page navigation.
  try {
    fetch("/api/analytics/track", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
      keepalive: true,
    }).catch(() => {});
  } catch {
    // ignore
  }
}
