// Build and send the admin's LINE alert when a certificate is issued.
//
// Wraps notifyAdminLine (lib/firstaid/server/lineNotify.ts) with two extras over
// the bare theory ping that already existed:
//   1. a per-kind running tally for "today" (Asia/Bangkok day boundary), and
//   2. a message for the practical certificate, not just theory.
//
// Everything here is defensive: a failed/empty notification must never break
// certificate issuance, so notifyCertIssued swallows its own errors.
import type { SupabaseClient } from '@supabase/supabase-js'
import { notifyAdminLine } from './lineNotify'

const BKK_OFFSET_MS = 7 * 60 * 60 * 1000 // Bangkok is a fixed UTC+7 (no DST)

// The UTC instant of the most recent Asia/Bangkok midnight, as an ISO string.
// issued_at is stored in UTC, so `issued_at >= bangkokDayStartISO()` selects
// every certificate issued so far "today" in Bangkok wall-clock terms.
export function bangkokDayStartISO(now: Date = new Date()): string {
  const bkk = new Date(now.getTime() + BKK_OFFSET_MS)
  const midnightAsUtc = Date.UTC(bkk.getUTCFullYear(), bkk.getUTCMonth(), bkk.getUTCDate())
  return new Date(midnightAsUtc - BKK_OFFSET_MS).toISOString()
}

// Count certificates of one kind issued since Bangkok midnight (this one included).
export async function countIssuedToday(
  admin: SupabaseClient,
  kind: string,
  now: Date = new Date(),
): Promise<number> {
  const { count } = await admin
    .from('fa_certificates')
    .select('id', { count: 'exact', head: true })
    .eq('kind', kind)
    .gte('issued_at', bangkokDayStartISO(now))
  return count ?? 0
}

function fmtTime(iso: string): string {
  return new Date(iso).toLocaleString('th-TH', {
    timeZone: 'Asia/Bangkok',
    dateStyle: 'medium',
    timeStyle: 'short',
  })
}

export interface TheoryMessageDetails {
  learnerName: string
  learnerPhone: string
  learnerEmail: string
  score: number
  code: string
  issuedAt: string
  todayCount: number
}

export function buildTheoryMessage({
  learnerName,
  learnerPhone,
  learnerEmail,
  score,
  code,
  issuedAt,
  todayCount,
}: TheoryMessageDetails): string {
  return [
    '🎓 มีคนรับใบเซอร์ทฤษฎีใหม่!',
    `👤 ${learnerName}`,
    `📞 ${learnerPhone}`,
    `✉️ ${learnerEmail}`,
    `📊 post-test ${score}/100`,
    `🔖 รหัส ${code}`,
    `🕐 ${fmtTime(issuedAt)}`,
    `📅 วันนี้ออกใบทฤษฎีแล้ว ${todayCount} ใบ`,
  ].join('\n')
}

export interface PracticalMessageDetails {
  learnerName: string
  location?: string | null
  code: string
  issuedAt: string
  todayCount: number
}

export function buildPracticalMessage({
  learnerName,
  location,
  code,
  issuedAt,
  todayCount,
}: PracticalMessageDetails): string {
  return [
    '🏅 มีคนรับใบเซอร์ภาคปฏิบัติใหม่!',
    `👤 ${learnerName}`,
    location ? `📍 ${location}` : null,
    `🔖 รหัส ${code}`,
    `🕐 ${fmtTime(issuedAt)}`,
    `📅 วันนี้ออกใบปฏิบัติแล้ว ${todayCount} ใบ`,
  ]
    .filter(Boolean)
    .join('\n')
}

export interface CertIssuedDetails {
  kind: 'theory' | 'practical'
  learnerName: string
  learnerPhone?: string
  learnerEmail?: string
  score?: number
  location?: string | null
  code: string
  issuedAt: string
}

// Single entry point for the issuance endpoints. Computes today's tally, builds
// the right message, and pushes it — never throwing, so it is safe to await
// right before returning the freshly issued certificate.
export async function notifyCertIssued(
  admin: SupabaseClient,
  details: CertIssuedDetails,
): Promise<void> {
  try {
    const todayCount = await countIssuedToday(admin, details.kind)
    const text =
      details.kind === 'practical'
        ? buildPracticalMessage({ ...(details as unknown as PracticalMessageDetails), todayCount })
        : buildTheoryMessage({ ...(details as unknown as TheoryMessageDetails), todayCount })
    await notifyAdminLine(text)
  } catch (err) {
    console.error('notifyCertIssued failed', err)
  }
}
