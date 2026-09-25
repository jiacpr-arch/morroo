"use client";

import { useEffect } from "react";
import { SW_URL } from "@/lib/push-client";

// Registers the morroo service worker (app/(morroo)/sw.js/route.ts) once the
// page has loaded. Rendered only from the morroo root layout — firstaid and
// games have their own layouts and never register it.
//
// The worker has no fetch handler (push + notificationclick only), so
// registering it on every visit costs nothing and keeps an installed PWA /
// existing push subscription attached to a live registration.
export default function ServiceWorkerRegister() {
  useEffect(() => {
    if (typeof navigator === "undefined" || !("serviceWorker" in navigator)) return;
    const register = () => {
      navigator.serviceWorker
        .register(SW_URL, { scope: "/", updateViaCache: "none" })
        .catch((err) => console.warn("[sw] register failed:", err));
    };
    if (document.readyState === "complete") {
      register();
      return;
    }
    window.addEventListener("load", register, { once: true });
    return () => window.removeEventListener("load", register);
  }, []);

  return null;
}
