// Push-only service worker for the ACLS/BLS course news feature.
// Ported from acls-emr's src/sw.js — deliberately WITHOUT the
// precacheAndRoute()/workbox precaching logic from the source: morroo is a
// large marketing site, and a fetch-intercepting caching SW here would be
// dangerous (stale marketing pages, checkout flows, etc.) and is out of
// scope for this phase. This file only ever runs for visitors who opted
// into push notifications (see components/courses/PushToggle.tsx, the only
// place that registers it).

self.addEventListener("install", () => {
  self.skipWaiting();
});

self.addEventListener("activate", (event) => {
  event.waitUntil(self.clients.claim());
});

// Web push handler
self.addEventListener("push", (event) => {
  let data = {};
  try {
    data = event.data ? event.data.json() : {};
  } catch {
    data = { title: "ข่าวใหม่", body: event.data ? event.data.text() : "" };
  }

  const title = data.title || "ข่าวใหม่";
  const options = {
    body: data.body || "",
    icon: "/favicon.ico",
    badge: "/favicon.ico",
    tag: data.tag || "news",
    renotify: true,
    data: { url: data.url || "/acls/news" },
  };

  event.waitUntil(self.registration.showNotification(title, options));
});

self.addEventListener("notificationclick", (event) => {
  event.notification.close();
  const url = event.notification.data?.url || "/acls/news";
  event.waitUntil(
    self.clients.matchAll({ type: "window", includeUncontrolled: true }).then((list) => {
      // If a tab is already open, focus it and navigate
      for (const client of list) {
        if ("focus" in client) {
          client.focus();
          if ("navigate" in client) client.navigate(url);
          return;
        }
      }
      // Otherwise open a new tab
      if (self.clients.openWindow) return self.clients.openWindow(url);
    })
  );
});
