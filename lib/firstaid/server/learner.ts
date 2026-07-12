// Resolves the canonical learner_id for the caller. The old firstaid app minted
// a Supabase bearer token via a LINE-login bridge (api/auth/line.js) and mapped
// it through `line_identities`; in morroo the session lives in Supabase SSR
// cookies and the mapping lives in `fa_learner_links` — but the trust model is
// identical. Returns null when there is no session — the app still supports
// anonymous learners who never logged in with LINE.
import type { SupabaseClient } from '@supabase/supabase-js'

const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i

export function isUuid(value: unknown): value is string {
  return typeof value === 'string' && UUID_RE.test(value)
}

// Maps a Supabase auth user id → the learner_id recorded in fa_learner_links.
export async function learnerIdForAuthUser(
  admin: SupabaseClient,
  authUserId: string,
): Promise<string | null> {
  const { data } = await admin
    .from('fa_learner_links')
    .select('learner_id')
    .eq('auth_user_id', authUserId)
    .maybeSingle()
  return (data as { learner_id?: string } | null)?.learner_id || null
}

// Reads the Supabase session user (SSR cookies) and maps it to a learner_id.
// The Next-specific imports are lazy so this module stays importable from unit
// tests that run outside a request scope.
export async function learnerIdFromSession(admin?: SupabaseClient): Promise<string | null> {
  const { createClient } = await import('@/lib/supabase/server')
  const supabase = await createClient()
  const { data, error } = await supabase.auth.getUser()
  if (error || !data?.user) return null
  if (!admin) {
    const { createAdminClient } = await import('@/lib/supabase/admin')
    admin = createAdminClient()
  }
  return learnerIdForAuthUser(admin, data.user.id)
}

export interface ReconciledLearner {
  learnerId: string | null
  forbidden: boolean
}

// Given a body-supplied learnerId and an authenticated learner (or null),
// returns the id to trust: the authenticated one wins, and a mismatch is a
// forbidden cross-account attempt. { learnerId, forbidden } — check forbidden first.
export function reconcileLearner(
  bodyLearnerId: string | null | undefined,
  sessionLearnerId: string | null | undefined,
): ReconciledLearner {
  if (sessionLearnerId) {
    if (bodyLearnerId && bodyLearnerId !== sessionLearnerId) {
      return { learnerId: null, forbidden: true }
    }
    return { learnerId: sessionLearnerId, forbidden: false }
  }
  return { learnerId: bodyLearnerId || null, forbidden: false }
}

const PROGRESS_TABLES = [
  'fa_lesson_progress',
  'fa_quiz_attempts',
  'fa_exam_attempts',
  'fa_simulation_runs',
] as const

// When a device that accumulated progress under an anonymous learner id logs in
// to an account whose canonical learner id differs, re-point the progress rows
// to the canonical id so nothing is stranded. Best-effort: a unique-key clash
// (e.g. the same lesson already read under both ids) or any other error is
// logged and skipped — a partial merge must never break login.
export async function adoptDeviceProgress(
  admin: SupabaseClient,
  canonicalLearnerId: string,
  deviceLearnerId: string | null | undefined,
): Promise<void> {
  if (!deviceLearnerId || !isUuid(deviceLearnerId)) return
  if (deviceLearnerId === canonicalLearnerId) return
  for (const table of PROGRESS_TABLES) {
    try {
      const { error } = await admin
        .from(table)
        .update({ learner_id: canonicalLearnerId })
        .eq('learner_id', deviceLearnerId)
      if (error) console.error(`adoptDeviceProgress: ${table} merge failed`, error)
    } catch (err) {
      console.error(`adoptDeviceProgress: ${table} merge failed`, err)
    }
  }
}
