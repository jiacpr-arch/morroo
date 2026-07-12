import { test, expect } from 'vitest'
import type { SupabaseClient } from '@supabase/supabase-js'
import {
  bangkokDayStartISO,
  countIssuedToday,
  buildTheoryMessage,
  buildPracticalMessage,
  notifyCertIssued,
} from './certNotify'

interface RecordedCalls {
  table?: string
  select?: { cols: string; opts: { count: string; head: boolean } }
  eq?: Record<string, string>
  gte?: { col: string; val: string }
}

// A minimal stand-in for the Supabase query builder: thenable, records the calls.
function fakeAdmin({ count = 0 as number | null } = {}) {
  const calls: RecordedCalls = {}
  const qb = {
    select(cols: string, opts: { count: string; head: boolean }) {
      calls.select = { cols, opts }
      return qb
    },
    eq(col: string, val: string) {
      ;(calls.eq ||= {})[col] = val
      return qb
    },
    gte(col: string, val: string) {
      calls.gte = { col, val }
      return qb
    },
    then(resolve: (v: { count: number | null }) => void) {
      resolve({ count })
    },
  }
  const admin = {
    from(table: string) {
      calls.table = table
      return qb
    },
    _calls: calls,
  }
  return admin as unknown as SupabaseClient & { _calls: RecordedCalls }
}

test('bangkokDayStartISO maps an instant to the preceding Bangkok midnight (UTC+7)', () => {
  // 20:00 Bangkok on Jun 18 → midnight Jun 18 = 17:00 UTC Jun 17
  expect(bangkokDayStartISO(new Date('2026-06-18T13:00:00Z'))).toBe('2026-06-17T17:00:00.000Z')
  // 23:59 Bangkok on Jun 18 → same Bangkok day
  expect(bangkokDayStartISO(new Date('2026-06-18T16:59:00Z'))).toBe('2026-06-17T17:00:00.000Z')
  // 01:00 Bangkok on Jun 19 → rolls to the next Bangkok day
  expect(bangkokDayStartISO(new Date('2026-06-18T18:00:00Z'))).toBe('2026-06-18T17:00:00.000Z')
})

test('countIssuedToday filters by kind + Bangkok day start and returns the count', async () => {
  const admin = fakeAdmin({ count: 3 })
  const n = await countIssuedToday(admin, 'theory', new Date('2026-06-18T13:00:00Z'))
  expect(n).toBe(3)
  expect(admin._calls.table).toBe('fa_certificates')
  expect(admin._calls.eq!.kind).toBe('theory')
  expect(admin._calls.gte!.col).toBe('issued_at')
  expect(admin._calls.gte!.val).toBe('2026-06-17T17:00:00.000Z')
  expect(admin._calls.select!.opts.head).toBe(true)
})

test('countIssuedToday treats a null count as zero', async () => {
  expect(await countIssuedToday(fakeAdmin({ count: null }), 'practical')).toBe(0)
})

test('buildTheoryMessage includes contact, score, code and the daily tally', () => {
  const msg = buildTheoryMessage({
    learnerName: 'สมหญิง',
    learnerPhone: '0812345678',
    learnerEmail: 'a@b.com',
    score: 92,
    code: 'FA-ABCD2345',
    issuedAt: '2026-06-18T13:00:00Z',
    todayCount: 5,
  })
  expect(msg).toMatch(/ทฤษฎี/)
  expect(msg).toMatch(/สมหญิง/)
  expect(msg).toMatch(/0812345678/)
  expect(msg).toMatch(/92\/100/)
  expect(msg).toMatch(/FA-ABCD2345/)
  expect(msg).toMatch(/วันนี้ออกใบทฤษฎีแล้ว 5 ใบ/)
})

test('buildPracticalMessage shows location when present and always shows the tally', () => {
  const withLoc = buildPracticalMessage({
    learnerName: 'สมชาย',
    location: 'ศูนย์ Jia',
    code: 'FA-WXYZ2345',
    issuedAt: '2026-06-18T13:00:00Z',
    todayCount: 2,
  })
  expect(withLoc).toMatch(/ภาคปฏิบัติ/)
  expect(withLoc).toMatch(/ศูนย์ Jia/)
  expect(withLoc).toMatch(/วันนี้ออกใบปฏิบัติแล้ว 2 ใบ/)
})

test('buildPracticalMessage omits the location line when there is no location', () => {
  const noLoc = buildPracticalMessage({
    learnerName: 'สมชาย',
    location: null,
    code: 'FA-WXYZ2345',
    issuedAt: '2026-06-18T13:00:00Z',
    todayCount: 1,
  })
  expect(noLoc).not.toMatch(/📍/)
  expect(noLoc).toMatch(/วันนี้ออกใบปฏิบัติแล้ว 1 ใบ/)
})

test('notifyCertIssued never throws — not on a no-op LINE config, not on a DB error', async () => {
  // No LINE env configured → notifyAdminLine is a silent no-op; must resolve.
  await expect(
    notifyCertIssued(fakeAdmin({ count: 1 }), {
      kind: 'theory',
      learnerName: 'x',
      learnerPhone: '0',
      learnerEmail: 'x@y.z',
      score: 90,
      code: 'FA-ABCD2345',
      issuedAt: '2026-06-18T13:00:00Z',
    }),
  ).resolves.toBeUndefined()
  // A throwing admin must be swallowed too.
  const throwingAdmin = {
    from() {
      throw new Error('db down')
    },
  } as unknown as SupabaseClient
  await expect(
    notifyCertIssued(throwingAdmin, {
      kind: 'practical',
      learnerName: 'x',
      code: 'FA-ABCD2345',
      issuedAt: '2026-06-18T13:00:00Z',
    }),
  ).resolves.toBeUndefined()
})
