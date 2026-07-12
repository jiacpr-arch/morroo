import type { CourseMode } from "@/lib/courses/config";

// Ported from acls-emr's src/services/pushService.js + src/config/push.js.
// Client-only: every export early-returns when `window` isn't available so
// this file is safe to import from a server component without crashing
// (though in practice only PushToggle.tsx, a "use client" component, uses it).

// Public VAPID key for Web Push subscription. Safe to expose client-side —
// it's the public half of the signing pair. Same hardcoded fallback as the
// source's src/config/push.js so local/preview builds without the env var
// configured don't crash.
const DEFAULT_PUBLIC_KEY =
  "BH5zjcz8nBNK5ZdfLw4m3-0wTsRLS4I2tjTz-X1waylgkqW5h1iMpkd5wZbaoF6hdR0CWF2WLniS7zwFQA5lWVU";

export const VAPID_PUBLIC_KEY =
  process.env.NEXT_PUBLIC_VAPID_PUBLIC_KEY || DEFAULT_PUBLIC_KEY;

export function isPushSupported(): boolean {
  return (
    typeof window !== "undefined" &&
    "serviceWorker" in navigator &&
    "PushManager" in window &&
    "Notification" in window
  );
}

export type PushPermissionState = "unsupported" | NotificationPermission;

export function getPermissionState(): PushPermissionState {
  if (!isPushSupported()) return "unsupported";
  return Notification.permission; // 'default' | 'granted' | 'denied'
}

// Convert URL-safe base64 to Uint8Array (required by PushManager.subscribe)
function urlBase64ToUint8Array(base64String: string): Uint8Array {
  const padding = "=".repeat((4 - (base64String.length % 4)) % 4);
  const base64 = (base64String + padding).replace(/-/g, "+").replace(/_/g, "/");
  const raw = atob(base64);
  const arr = new Uint8Array(raw.length);
  for (let i = 0; i < raw.length; i++) arr[i] = raw.charCodeAt(i);
  return arr;
}

async function getRegistration(): Promise<ServiceWorkerRegistration> {
  const reg = await navigator.serviceWorker.getRegistration();
  if (reg) return reg;
  return navigator.serviceWorker.ready;
}

// Registers the push-only service worker at the site root. Called from
// PushToggle on mount, before subscribing — push is opt-in, so there's no
// other reason to have a service worker active on morroo.
export async function registerServiceWorker(): Promise<ServiceWorkerRegistration | null> {
  if (typeof window === "undefined" || !("serviceWorker" in navigator)) return null;
  try {
    return await navigator.serviceWorker.register("/course-sw.js", {
      scope: "/",
      updateViaCache: "none",
    });
  } catch {
    return null;
  }
}

export async function subscribePush(course: CourseMode): Promise<PushSubscription> {
  if (!isPushSupported()) throw new Error("Push not supported");

  const permission = await Notification.requestPermission();
  if (permission !== "granted") {
    throw new Error("Permission denied");
  }

  const reg = await getRegistration();
  let sub = await reg.pushManager.getSubscription();
  if (!sub) {
    sub = await reg.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey: urlBase64ToUint8Array(VAPID_PUBLIC_KEY) as BufferSource,
    });
  }

  // Send to backend. `course` is the actual site the visitor is on ('acls' or
  // 'bls') — never 'both', which is reserved for cross-course broadcasts.
  const res = await fetch("/api/acls/push", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      subscription: sub.toJSON(),
      course,
      userAgent: navigator.userAgent.slice(0, 200),
    }),
  });

  if (!res.ok) {
    throw new Error("Backend subscribe failed: " + res.status);
  }

  return sub;
}

export async function unsubscribePush(): Promise<void> {
  if (typeof window === "undefined" || !("serviceWorker" in navigator)) return;
  const reg = await getRegistration();
  const sub = await reg.pushManager.getSubscription();
  if (!sub) return;

  await fetch("/api/acls/push", {
    method: "DELETE",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ endpoint: sub.endpoint }),
  }).catch(() => {
    /* best effort */
  });

  await sub.unsubscribe();
}

export async function getCurrentSubscription(): Promise<PushSubscription | null> {
  if (!isPushSupported()) return null;
  const reg = await getRegistration();
  return reg.pushManager.getSubscription();
}
