import { createAdminClient } from '@/lib/supabase/admin'
import { isUuid, learnerIdFromSession, reconcileLearner } from '@/lib/firstaid/server/learner'
import { rateLimited } from '@/lib/firstaid/server/rateLimit'

// Replaces the old offline-first sync pair (api/sync/push.js + pull.js): the
// client now reads/writes progress directly against Supabase through this
// route. Trust model is unchanged — a session binds the caller to their
// canonical learner_id (mismatches are ignored/rejected), while anonymous
// learners operate best-effort under their local learnerId, exactly like the
// old sync endpoints did.

interface ExamAttemptRow {
  kind: string
  score: number
  passed: boolean | null
  finished_at: string
}

interface BestExam {
  kind: string
  score: number
  passed: boolean | null
  finishedAt: string
}

function bestOf(rows: ExamAttemptRow[], kind: string): BestExam | null {
  let best: ExamAttemptRow | null = null
  for (const r of rows) {
    if (r.kind !== kind) continue
    if (!best || r.score > best.score) best = r
  }
  if (!best) return null
  return { kind: best.kind, score: best.score, passed: best.passed, finishedAt: best.finished_at }
}

export async function GET(request: Request) {
  const limited = rateLimited(request, { key: 'progress-get', limit: 60, windowMs: 60_000 })
  if (limited) return limited

  const admin = createAdminClient()

  // Anti-tamper: a logged-in caller always gets their own progress — the
  // learnerId query param is ignored when it mismatches the session. Anonymous
  // callers get rows for the requested learnerId (same trust model as the old
  // sync push/pull for anonymous learners).
  const sessionLearnerId = await learnerIdFromSession(admin)
  const { searchParams } = new URL(request.url)
  const learnerId = sessionLearnerId || searchParams.get('learnerId') || ''
  if (!learnerId) return Response.json({ error: 'Missing learnerId' }, { status: 400 })

  const CAP = 500
  const [lessons, sims, exams] = await Promise.all([
    admin.from('fa_lesson_progress').select('lesson_id').eq('learner_id', learnerId).limit(CAP),
    admin
      .from('fa_simulation_runs')
      .select('scenario_id')
      .eq('learner_id', learnerId)
      .eq('passed', true)
      .limit(CAP),
    admin
      .from('fa_exam_attempts')
      .select('kind, score, passed, finished_at')
      .eq('learner_id', learnerId)
      .limit(CAP),
  ])
  for (const r of [lessons, sims, exams]) {
    if (r.error) return Response.json({ error: r.error.message }, { status: 500 })
  }

  const readLessonIds = ((lessons.data ?? []) as { lesson_id: string }[]).map((r) => r.lesson_id)
  const passedScenarioIds = [
    ...new Set(((sims.data ?? []) as { scenario_id: string }[]).map((r) => r.scenario_id)),
  ]
  const examRows = (exams.data ?? []) as ExamAttemptRow[]

  return Response.json({
    readLessonIds,
    passedScenarioIds,
    bestPre: bestOf(examRows, 'pre'),
    bestPost: bestOf(examRows, 'post'),
  })
}

interface ProgressBody {
  learnerId?: string
  lessonRead?: { lessonId?: string; readAt?: string }
  quizAttempt?: {
    uuid?: string
    lessonId?: string
    correct?: number
    total?: number
    finishedAt?: string
  }
  simulationRun?: {
    uuid?: string
    scenarioId?: string
    endingId?: string
    passed?: boolean
    finishedAt?: string
  }
}

export async function POST(request: Request) {
  const limited = rateLimited(request, { key: 'progress-post', limit: 30, windowMs: 60_000 })
  if (limited) return limited

  const admin = createAdminClient()

  const body = (await request.json().catch(() => ({}))) as ProgressBody
  const sessionLearnerId = await learnerIdFromSession(admin)
  const { learnerId, forbidden } = reconcileLearner(body.learnerId, sessionLearnerId)
  if (forbidden) {
    return Response.json({ error: 'learnerId does not match session' }, { status: 403 })
  }
  if (!learnerId) return Response.json({ error: 'Missing learnerId' }, { status: 400 })

  const synced = { lessonRead: 0, quizAttempt: 0, simulationRun: 0 }

  // Same columns and natural keys as the old api/sync/push.js upserts.
  if (body.lessonRead && body.lessonRead.lessonId) {
    const { error } = await admin.from('fa_lesson_progress').upsert(
      {
        learner_id: learnerId,
        lesson_id: body.lessonRead.lessonId,
        read_at: body.lessonRead.readAt || new Date().toISOString(),
      },
      { onConflict: 'learner_id,lesson_id' },
    )
    if (error) return Response.json({ error: error.message }, { status: 500 })
    synced.lessonRead = 1
  }

  if (body.quizAttempt && isUuid(body.quizAttempt.uuid) && body.quizAttempt.lessonId) {
    const q = body.quizAttempt
    const correct = typeof q.correct === 'number' ? q.correct : 0
    const total = typeof q.total === 'number' ? q.total : 0
    const { error } = await admin.from('fa_quiz_attempts').upsert(
      {
        uuid: q.uuid,
        learner_id: learnerId,
        lesson_id: q.lessonId,
        // fa_quiz_attempts.score is NOT NULL — derive it from correct/total,
        // matching what the old client stored (percentage 0–100). The new
        // payload doesn't carry a client-side pass verdict, so passed stays null.
        score: total ? Math.round((correct / total) * 100) : 0,
        correct,
        total,
        passed: null,
        finished_at: q.finishedAt || new Date().toISOString(),
      },
      { onConflict: 'uuid' },
    )
    if (error) return Response.json({ error: error.message }, { status: 500 })
    synced.quizAttempt = 1
  }

  if (body.simulationRun && isUuid(body.simulationRun.uuid) && body.simulationRun.scenarioId) {
    const s = body.simulationRun
    const { error } = await admin.from('fa_simulation_runs').upsert(
      {
        uuid: s.uuid,
        learner_id: learnerId,
        scenario_id: s.scenarioId,
        // fa_simulation_runs has no ending_id column (schema parity with the
        // old simulation_runs table) — endingId is accepted but not persisted.
        score: null,
        total: null,
        passed: s.passed ?? null,
        finished_at: s.finishedAt || new Date().toISOString(),
      },
      { onConflict: 'uuid' },
    )
    if (error) return Response.json({ error: error.message }, { status: 500 })
    synced.simulationRun = 1
  }

  return Response.json({ ok: true, synced })
}
