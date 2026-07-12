import { createAdminClient } from '@/lib/supabase/admin'

// Public certificate lookup by code (FA-XXXXXXXX) — pre-migration codes keep
// verifying because fa_certificates carries the old `code` values verbatim.
export async function GET(request: Request) {
  const { searchParams } = new URL(request.url)
  const code = (searchParams.get('code') || '').toString().toUpperCase()
  if (!code) return Response.json({ error: 'Missing code' }, { status: 400 })

  const admin = createAdminClient()

  const { data, error } = await admin
    .from('fa_certificates')
    .select('code, kind, learner_name, issued_at, location')
    .eq('code', code)
    .maybeSingle()
  if (error) return Response.json({ error: error.message }, { status: 500 })
  if (!data) return Response.json({ error: 'Not found' }, { status: 404 })
  return Response.json({ certificate: data })
}
