// Service worker for www.morroo.com, served at /sw.js with scope "/".
// Registered by components/pwa/ServiceWorkerRegister.tsx from the morroo
// root layout only.
//
// No conflict with firstaid: on firstaid.morroo.com the middleware
// host-rewrites /sw.js to /firstaid/sw.js (the killer worker), and service
// workers are per-origin anyway, so the two never share a scope.
//
// Deliberately minimal — push + notificationclick only, and NO fetch handler
// and NO caches. Almost every morroo page is authenticated/personalised, and
// a caching worker would risk serving one session's page (or a stale paywall
// state) after login/logout/upgrade. Without a fetch handler the browser
// talks to the network exactly as if no worker existed.
//
// Cache-Control: no-cache so the browser revalidates the script on every
// update check and picks up changes here promptly.

const SW_SOURCE = `// morroo service worker — web push only, no caching.
const DEFAULT_URL = '/dashboard';
const DEFAULT_ICON = '/icons/morroo-192.png';
const BADGE = '/icons/badge-96.png';

self.addEventListener('install', () => {
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(self.clients.claim());
});

self.addEventListener('push', (event) => {
  let data = {};
  try {
    data = event.data ? event.data.json() : {};
  } catch (e) {
    data = { body: event.data ? event.data.text() : '' };
  }
  const title = data.title || 'หมอรู้ (MorRoo)';
  const options = {
    body: data.body || '',
    icon: data.icon || DEFAULT_ICON,
    badge: BADGE,
    tag: data.tag || undefined,
    renotify: !!data.tag,
    lang: 'th',
    data: { url: data.url || DEFAULT_URL },
  };
  event.waitUntil(self.registration.showNotification(title, options));
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  const raw = (event.notification.data && event.notification.data.url) || DEFAULT_URL;
  let target;
  try {
    target = new URL(raw, self.location.origin);
  } catch (e) {
    target = new URL(DEFAULT_URL, self.location.origin);
  }
  // Only ever open our own origin — never an attacker-supplied URL.
  if (target.origin !== self.location.origin) {
    target = new URL(DEFAULT_URL, self.location.origin);
  }
  event.waitUntil(
    (async () => {
      const windowClients = await self.clients.matchAll({ type: 'window', includeUncontrolled: true });
      for (const client of windowClients) {
        if ('focus' in client) {
          try {
            await client.focus();
            if ('navigate' in client) await client.navigate(target.href);
            return;
          } catch (e) {
            // fall through to openWindow
          }
        }
      }
      await self.clients.openWindow(target.href);
    })()
  );
});
`;

export function GET() {
  return new Response(SW_SOURCE, {
    headers: {
      "Content-Type": "application/javascript; charset=utf-8",
      "Cache-Control": "no-cache, max-age=0",
      "Service-Worker-Allowed": "/",
    },
  });
}
