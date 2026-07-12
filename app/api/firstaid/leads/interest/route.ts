import { createAdminClient } from '@/lib/supabase/admin'
import { notifyAdminLine } from '@/lib/firstaid/server/lineNotify'
import { rateLimited, sanitizeLine } from '@/lib/firstaid/server/rateLimit'

interface InterestBody {
  name?: string
  phone?: string
  learnerId?: string
  source?: string
}

export async function POST(request: Request) {
  const limited = rateLimited(request, { key: 'interest', limit: 5, windowMs: 60_000 })
  if (limited) return limited

  const body = (await request.json().catch(() => ({}))) as InterestBody
  const { name, phone, learnerId, source } = body
  if (!name?.trim() || !phone?.trim()) {
    return Response.json({ error: 'name and phone required' }, { status: 400 })
  }

  const admin = createAdminClient()
  const { error } = await admin.from('fa_course_interest').insert({
    learner_id: learnerId || null,
    name: name.trim().slice(0, 120),
    phone: phone.trim().slice(0, 40),
    source: source || 'unknown',
  })
  if (error) console.error('fa_course_interest insert failed', error)

  await notifyAdminLine(
    `🎯 สนใจคลาสปฏิบัติ\nชื่อ: ${sanitizeLine(name)}\nโทร: ${sanitizeLine(phone, 40)}\nSource: ${sanitizeLine(source || 'unknown', 40)}`,
  )

  return Response.json({ ok: true })
}
