import { createAdminClient } from '@/lib/supabase/admin'
import { learnerIdFromSession } from '@/lib/firstaid/server/learner'
import { rateLimited } from '@/lib/firstaid/server/rateLimit'

// Returns which chapters (0 = whole-course bundle, 1-4 = single chapter) the
// authenticated learner has purchased. Login required — entitlements only ever
// exist against the durable learner_id, never an anonymous local id.
export async function GET(request: Request) {
  const limited = rateLimited(request, { key: 'entitlements-list', limit: 60, windowMs: 60_000 })
  if (limited) return limited

  const admin = createAdminClient()

  const learnerId = await learnerIdFromSession(admin)
  if (!learnerId) return Response.json({ error: 'login_required' }, { status: 401 })

  const { data, error } = await admin
    .from('fa_lesson_entitlements')
    .select('chapter')
    .eq('learner_id', learnerId)
  if (error) return Response.json({ error: error.message }, { status: 500 })

  return Response.json({ chapters: ((data ?? []) as { chapter: number }[]).map((r) => r.chapter) })
}
