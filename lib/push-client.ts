// Browser-side Web Push helpers (profile toggle + SW registration).
//
// Kept free of React so the support matrix below is unit-testable.

import { detectInAppBrowserFromUA } from "@/lib/in-app-browser";

export const SW_URL = "/sw.js";

export type PushSupport =
  /** Ready to ask for permission / subscribe. */
  | { kind: "supported" }
  /** FB/IG/LINE in-app browser — no push there; open in Chrome/Safari first. */
  | { kind: "in_app"; app: "facebook" | "instagram" | "line" }
  /** iPhone/iPad Safari tab — push only works after "Add to Home Screen" (iOS 16.4+). */
  | { kind: "ios_needs_install" }
  /** Browser has no Push API at all (old iOS, some embedded webviews). */
  | { kind: "unsupported" };

export interface PushEnv {
  userAgent: string;
  /** Launched from the home screen (display-mode: standalone / navigator.standalone). */
  standalone: boolean;
  hasServiceWorker: boolean;
  hasPushManager: boolean;
  hasNotification: boolean;
  /** navigator.maxTouchPoints — iPadOS 13+ reports a Mac UA, so touch is the tell. */
  maxTouchPoints?: number;
}

export function isIOS(ua: string, maxTouchPoints = 0): boolean {
  if (/iPad|iPhone|iPod/.test(ua)) return true;
  return /Macintosh/.test(ua) && maxTouchPoints > 1;
}

export function getPushSupport(env: PushEnv): PushSupport {
  const app = detectInAppBrowserFromUA(env.userAgent);
  if (app) return { kind: "in_app", app };
  const apis = env.hasServiceWorker && env.hasPushManager && env.hasNotification;
  if (isIOS(env.userAgent, env.maxTouchPoints)) {
    if (!env.standalone) return { kind: "ios_needs_install" };
    return apis ? { kind: "supported" } : { kind: "unsupported" };
  }
  return apis ? { kind: "supported" } : { kind: "unsupported" };
}

export function readPushEnv(): PushEnv | null {
  if (typeof window === "undefined" || typeof navigator === "undefined") return null;
  const nav = navigator as Navigator & { standalone?: boolean };
  return {
    userAgent: nav.userAgent || "",
    standalone:
      nav.standalone === true ||
      (typeof window.matchMedia === "function" &&
        window.matchMedia("(display-mode: standalone)").matches),
    hasServiceWorker: "serviceWorker" in nav,
    hasPushManager: "PushManager" in window,
    hasNotification: "Notification" in window,
    maxTouchPoints: nav.maxTouchPoints ?? 0,
  };
}

/** VAPID public key (base64url) → the BufferSource pushManager.subscribe wants. */
export function urlBase64ToUint8Array(base64String: string): Uint8Array<ArrayBuffer> {
  const padding = "=".repeat((4 - (base64String.length % 4)) % 4);
  const base64 = (base64String + padding).replace(/-/g, "+").replace(/_/g, "/");
  const raw = atob(base64);
  const out = new Uint8Array(new ArrayBuffer(raw.length));
  for (let i = 0; i < raw.length; i++) out[i] = raw.charCodeAt(i);
  return out;
}
