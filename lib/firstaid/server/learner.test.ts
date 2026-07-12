import { test, expect } from 'vitest'
import type { SupabaseClient } from '@supabase/supabase-js'
import {
  reconcileLearner,
  learnerIdForAuthUser,
  adoptDeviceProgress,
  isUuid,
} from './learner'

test('reconcileLearner: authenticated learner wins over body when they match', () => {
  expect(reconcileLearner('L1', 'L1')).toEqual({ learnerId: 'L1', forbidden: false })
})

test('reconcileLearner: a session learner overrides an absent body learnerId', () => {
  expect(reconcileLearner(undefined, 'L1')).toEqual({ learnerId: 'L1', forbidden: false })
})

test('reconcileLearner: mismatch between body and session is forbidden (cross-account)', () => {
  expect(reconcileLearner('victim', 'attacker')).toEqual({ learnerId: null, forbidden: true })
})

test('reconcileLearner: anonymous (no session) falls back to the body learnerId', () => {
  expect(reconcileLearner('L2', null)).toEqual({ learnerId: 'L2', forbidden: false })
  expect(reconcileLearner(undefined, null)).toEqual({ learnerId: null, forbidden: false })
})

test('learnerIdForAuthUser maps an auth user to its fa_learner_links learner_id', async () => {
  const calls: { table?: string; eq?: [string, string] } = {}
  const admin = {
    from(table: string) {
      calls.table = table
      return {
        select() {
          return this
        },
        eq(col: string, val: string) {
          calls.eq = [col, val]
          return this
        },
        async maybeSingle() {
          return { data: { learner_id: 'learner-9' } }
        },
      }
    },
  } as unknown as SupabaseClient
  expect(await learnerIdForAuthUser(admin, 'auth-1')).toBe('learner-9')
  expect(calls.table).toBe('fa_learner_links')
  expect(calls.eq).toEqual(['auth_user_id', 'auth-1'])
})

test('learnerIdForAuthUser returns null when there is no link row', async () => {
  const admin = {
    from() {
      return {
        select() {
          return this
        },
        eq() {
          return this
        },
        async maybeSingle() {
          return { data: null }
        },
      }
    },
  } as unknown as SupabaseClient
  expect(await learnerIdForAuthUser(admin, 'auth-2')).toBeNull()
})

const CANON = '11111111-2222-4333-8444-555555555555'
const DEVICE = '99999999-8888-4777-8666-555555555555'

function fakeMergeAdmin() {
  const updates: Array<{ table: string; set: Record<string, string>; where: [string, string] }> = []
  const admin = {
    from(table: string) {
      return {
        update(set: Record<string, string>) {
          return {
            async eq(col: string, val: string) {
              updates.push({ table, set, where: [col, val] })
              return { error: null }
            },
          }
        },
      }
    },
  }
  return { admin: admin as unknown as SupabaseClient, updates }
}

test('adoptDeviceProgress re-points all four progress tables to the canonical learner', async () => {
  const { admin, updates } = fakeMergeAdmin()
  await adoptDeviceProgress(admin, CANON, DEVICE)
  expect(updates.map((u) => u.table)).toEqual([
    'fa_lesson_progress',
    'fa_quiz_attempts',
    'fa_exam_attempts',
    'fa_simulation_runs',
  ])
  for (const u of updates) {
    expect(u.set).toEqual({ learner_id: CANON })
    expect(u.where).toEqual(['learner_id', DEVICE])
  }
})

test('adoptDeviceProgress is a no-op for missing, invalid, or identical device ids', async () => {
  const { admin, updates } = fakeMergeAdmin()
  await adoptDeviceProgress(admin, CANON, null)
  await adoptDeviceProgress(admin, CANON, 'not-a-uuid')
  await adoptDeviceProgress(admin, CANON, CANON)
  expect(updates).toEqual([])
})

test('adoptDeviceProgress swallows per-table errors (login must not break)', async () => {
  const admin = {
    from() {
      throw new Error('db down')
    },
  } as unknown as SupabaseClient
  await expect(adoptDeviceProgress(admin, CANON, DEVICE)).resolves.toBeUndefined()
})

test('isUuid accepts v4-style uuids and rejects junk', () => {
  expect(isUuid(DEVICE)).toBe(true)
  expect(isUuid('FA-ABCD1234')).toBe(false)
  expect(isUuid(null)).toBe(false)
})
