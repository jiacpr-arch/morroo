import { createAdminClient } from '@/lib/supabase/admin'
import { learnerIdFromSession } from '@/lib/firstaid/server/learner'
import { rateLimited } from '@/lib/firstaid/server/rateLimit'

// Redeems a voucher code to grant a chapter (or the whole-course bundle, chapter 0)
// entitlement to the caller. Unlike progress writes, login is mandatory here — an
// entitlement must bind to the durable learner_id (fa_learner_links) so it survives
// a device change, not the throwaway local/anonymous id.
export async function POST(request: Request) {
  const limited = rateLimited(request, { key: 'entitlements-redeem', limit: 10, windowMs: 60_000 })
  if (limited) return limited

  const admin = createAdminClient()

  const learnerId = await learnerIdFromSession(admin)
  if (!learnerId) return Response.json({ error: 'login_required' }, { status: 401 })

  const body = (await request.json().catch(() => ({}))) as { code?: string }
  const code = String(body.code || '').trim().toUpperCase()
  if (!code) return Response.json({ error: 'Missing code' }, { status: 400 })

  // Atomic claim: only succeeds if the code is still 'active'. A concurrent
  // redeem (or replay) loses this race and gets 0 rows back.
  const { data: voucher, error: claimErr } = await admin
    .from('fa_vouchers')
    .update({ status: 'redeemed', redeemed_by: learnerId, redeemed_at: new Date().toISOString() })
    .eq('code', code)
    .eq('status', 'active')
    .select('code, chapter')
    .maybeSingle()

  if (claimErr) return Response.json({ error: claimErr.message }, { status: 500 })
  if (!voucher) return Response.json({ error: 'invalid_code' }, { status: 400 })

  const { error: grantErr } = await admin.from('fa_lesson_entitlements').upsert(
    { learner_id: learnerId, chapter: voucher.chapter, source: 'voucher', order_ref: voucher.code },
    { onConflict: 'learner_id,chapter' },
  )
  if (grantErr) return Response.json({ error: grantErr.message }, { status: 500 })

  return Response.json({ ok: true, chapter: voucher.chapter })
}
