// KILLER SERVICE WORKER — served at https://firstaid.morroo.com/sw.js (the
// exact URL the old Vite PWA registered its precaching worker at).
//
// The old worker precached the entire SPA with autoUpdate, so returning
// visitors would otherwise stay trapped in the cached old app forever. This
// replacement takes over immediately (skipWaiting), wipes every cache,
// unregisters itself, and reloads all open windows so they fetch the new app
// from the network. Must stay in place for a long time (>= 12 months).
//
// Cache-Control: no-cache is critical — the browser must revalidate the SW
// script itself, or it would never see this killer version.

const SW_SOURCE = `// firstaid killer service worker — replaces the old precaching PWA worker.
self.addEventListener('install', () => {
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    (async () => {
      try {
        const keys = await caches.keys();
        await Promise.all(keys.map((key) => caches.delete(key)));
      } catch (e) {
        // ignore — proceed to unregister regardless
      }
      try {
        await self.registration.unregister();
      } catch (e) {
        // ignore
      }
      const windowClients = await self.clients.matchAll({ type: 'window' });
      for (const client of windowClients) {
        try {
          client.navigate(client.url);
        } catch (e) {
          // ignore — client may have gone away
        }
      }
    })()
  );
});
`;

export function GET() {
  return new Response(SW_SOURCE, {
    headers: {
      "Content-Type": "application/javascript; charset=utf-8",
      "Cache-Control": "no-cache, max-age=0",
    },
  });
}
