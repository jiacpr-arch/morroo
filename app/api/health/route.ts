// Uptime-monitor endpoint. The old firstaid Vite app exposed /api/health, and
// /api/* is exempt from the middleware host-rewrite, so this global route
// answers on every host — reporting which app the caller's host serves.
export async function GET(request: Request) {
  const host = request.headers.get('host') ?? ''
  const app = /^firstaid(-beta)?\./i.test(host) ? 'firstaid' : 'morroo'
  return Response.json({ ok: true, app, ts: new Date().toISOString() })
}
