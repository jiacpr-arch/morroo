import { randomUUID } from 'node:crypto'
import { createAdminClient } from '@/lib/supabase/admin'
import { generateCertCode } from '@/lib/firstaid/server/certCode'
import { notifyCertIssued } from '@/lib/firstaid/server/certNotify'
import { scoreExam, POST_PASSING as PASSING } from '@/lib/firstaid/server/examKey'
import { learnerIdFromSession, reconcileLearner } from '@/lib/firstaid/server/learner'
import { rateLimited } from '@/lib/firstaid/server/rateLimit'

interface IssueTheoryBody {
  learnerId?: string
  learnerName?: string
  learnerPhone?: string
  learnerEmail?: string
  consent?: boolean
  answers?: Record<string, string>
}

export async function POST(request: Request) {
  const limited = rateLimited(request, { key: 'issue-theory', limit: 10, windowMs: 60_000 })
  if (limited) return limited

  const admin = createAdminClient()

  const body = (await request.json().catch(() => ({}))) as IssueTheoryBody
  const { learnerId, learnerName, learnerPhone, learnerEmail, consent, answers } = body
  // Contact details + PDPA consent are required for self-service issuance.
  if (!learnerId || !learnerName || !learnerPhone || !learnerEmail) {
    return Response.json({ error: 'Missing fields' }, { status: 400 })
  }
  if (!consent) return Response.json({ error: 'Consent required' }, { status: 400 })

  // Bind to the authenticated learner when a session is present, so a cert
  // can't be minted against someone else's learnerId.
  const sessionLearnerId = await learnerIdFromSession(admin)
  const { forbidden } = reconcileLearner(learnerId, sessionLearnerId)
  if (forbidden) {
    return Response.json({ error: 'learnerId does not match session' }, { status: 403 })
  }

  // Idempotent: a learner gets exactly one theory certificate. Return the existing
  // one before doing any writes so repeated taps never create duplicates.
  const { data: existing } = await admin
    .from('fa_certificates')
    .select('*')
    .eq('learner_id', learnerId)
    .eq('kind', 'theory')
    .maybeSingle()
  if (existing) return Response.json({ certificate: existing })

  // Eligibility must be backed by a server-scored post-test attempt — the score
  // is never taken from the client. Prefer an existing attempt row; if there
  // isn't one yet, score the submitted answers here against the real key.
  const { data: attempts } = await admin
    .from('fa_exam_attempts')
    .select('score, passed')
    .eq('learner_id', learnerId)
    .eq('kind', 'post')
    .order('score', { ascending: false })
    .limit(1)
  let best: { score: number; passed: boolean } | null = attempts?.[0] ?? null
  if ((!best || !best.passed || best.score < PASSING) && answers && typeof answers === 'object') {
    const result = scoreExam('post', answers)
    if (result.passed) {
      const { data: inserted } = await admin
        .from('fa_exam_attempts')
        .insert({
          uuid: randomUUID(),
          learner_id: learnerId,
          kind: 'post',
          score: result.score,
          correct: result.correctCount,
          total: result.totalQuestions,
          passed: true,
          finished_at: new Date().toISOString(),
        })
        .select('score, passed')
        .single()
      best = inserted
    }
  }
  if (!best || !best.passed || best.score < PASSING) {
    return Response.json({ error: 'Post-test not passed' }, { status: 409 })
  }

  const cert = {
    learner_id: learnerId,
    kind: 'theory',
    code: generateCertCode(),
    issued_at: new Date().toISOString(),
    learner_name: learnerName,
    learner_phone: learnerPhone,
    learner_email: learnerEmail,
    pdpa_consent_at: new Date().toISOString(),
  }
  const { data, error } = await admin.from('fa_certificates').insert(cert).select().single()
  if (error) {
    // Lost a race with a concurrent issue — return the row that won.
    if (error.code === '23505') {
      const { data: winner } = await admin
        .from('fa_certificates')
        .select('*')
        .eq('learner_id', learnerId)
        .eq('kind', 'theory')
        .maybeSingle()
      if (winner) return Response.json({ certificate: winner })
    }
    return Response.json({ error: error.message }, { status: 500 })
  }

  // A fresh theory cert means a real lead just finished the course — alert the
  // admin on LINE with the running tally for the day. Awaited (so the push
  // completes before the function freezes) but never allowed to fail issuance:
  // notifyCertIssued swallows its own errors.
  await notifyCertIssued(admin, {
    kind: 'theory',
    learnerName,
    learnerPhone,
    learnerEmail,
    score: best.score,
    code: data.code,
    issuedAt: data.issued_at,
  })

  return Response.json({ certificate: data })
}
