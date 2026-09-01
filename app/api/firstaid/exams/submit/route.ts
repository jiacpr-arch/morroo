import { randomUUID } from 'node:crypto'
import { createAdminClient } from '@/lib/supabase/admin'
import { scoreExam } from '@/lib/firstaid/server/examKey'
import { isUuid, learnerIdFromSession, reconcileLearner } from '@/lib/firstaid/server/learner'
import { rateLimited } from '@/lib/firstaid/server/rateLimit'

interface SubmitBody {
  learnerId?: string
  uuid?: string
  kind?: string
  answers?: Record<string, string>
  finishedAt?: string
}

// Server-authoritative exam scoring. The client submits the raw answer map and
// the server scores it against the real key (never trusting a client score),
// records the attempt in fa_exam_attempts (idempotent on the client-supplied
// uuid), and returns the result. This is what backs theory-certificate
// eligibility.
export async function POST(request: Request) {
  const limited = rateLimited(request, { key: 'exam-submit', limit: 20, windowMs: 60_000 })
  if (limited) return limited

  const admin = createAdminClient()

  const body = (await request.json().catch(() => ({}))) as SubmitBody
  const { kind, answers, learnerId, uuid, finishedAt } = body
  if (kind !== 'pre' && kind !== 'post') {
    return Response.json({ error: 'Invalid kind' }, { status: 400 })
  }
  if (!answers || typeof answers !== 'object') {
    return Response.json({ error: 'Missing answers' }, { status: 400 })
  }

  // Bind identity to the authenticated learner when a session is present; reject
  // a session that claims a different learnerId than the body.
  const sessionLearnerId = await learnerIdFromSession(admin)
  const { learnerId: effectiveLearnerId, forbidden } = reconcileLearner(learnerId, sessionLearnerId)
  if (forbidden) {
    return Response.json({ error: 'learnerId does not match session' }, { status: 403 })
  }
  if (!effectiveLearnerId) {
    return Response.json({ error: 'Missing learnerId' }, { status: 400 })
  }

  const result = scoreExam(kind, answers)

  const { error } = await admin.from('fa_exam_attempts').upsert(
    {
      uuid: isUuid(uuid) ? uuid : randomUUID(),
      learner_id: effectiveLearnerId,
      kind,
      score: result.score,
      correct: result.correctCount,
      total: result.totalQuestions,
      passed: result.passed,
      finished_at: typeof finishedAt === 'string' && finishedAt ? finishedAt : new Date().toISOString(),
    },
    { onConflict: 'uuid' },
  )
  if (error) return Response.json({ error: error.message }, { status: 500 })

  return Response.json(result)
}
