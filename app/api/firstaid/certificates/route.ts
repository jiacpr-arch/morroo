import { createAdminClient } from '@/lib/supabase/admin'
import { isUuid, learnerIdFromSession } from '@/lib/firstaid/server/learner'
import { rateLimited } from '@/lib/firstaid/server/rateLimit'

// Lists a learner's issued certificates (theory + practical, including rows
// migrated from the old firstaid deployment). The old app read these from
// local Dexie; server-side is now the only source. Same trust model as the
// progress route: a session binds the caller to their canonical learner_id,
// anonymous callers get rows for their local learnerId.
export async function GET(request: Request) {
  const limited = rateLimited(request, { key: 'certificates-list', limit: 60, windowMs: 60_000 })
  if (limited) return limited

  const url = new URL(request.url)
  const paramLearnerId = url.searchParams.get('learnerId') ?? ''

  const sessionLearnerId = await learnerIdFromSession()
  const learnerId = sessionLearnerId ?? paramLearnerId
  if (!isUuid(learnerId)) {
    return Response.json({ error: 'Missing learnerId' }, { status: 400 })
  }

  const admin = createAdminClient()
  const { data, error } = await admin
    .from('fa_certificates')
    .select('kind, code, issued_at, learner_name, location, revoked_at')
    .eq('learner_id', learnerId)
    .is('revoked_at', null)
    .order('issued_at', { ascending: true })

  if (error) {
    return Response.json({ error: error.message }, { status: 500 })
  }

  return Response.json({
    certificates: (data ?? []).map((r) => ({
      kind: r.kind,
      code: r.code,
      issuedAt: r.issued_at,
      learnerName: r.learner_name,
      location: r.location,
    })),
  })
}
