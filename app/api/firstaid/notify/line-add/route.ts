import { notifyAdminLine } from '@/lib/firstaid/server/lineNotify'
import { rateLimited, sanitizeLine } from '@/lib/firstaid/server/rateLimit'

// เรียกจาก client เมื่อผู้เรียนกด "ฉันแอดแล้ว" ใน LinePopup หลังเรียนจบบทแรก
export async function POST(request: Request) {
  const limited = rateLimited(request, { key: 'line-add', limit: 5, windowMs: 60_000 })
  if (limited) return limited

  const body = (await request.json().catch(() => ({}))) as { learnerId?: string }
  const learnerLine = body.learnerId ? `learner: ${sanitizeLine(body.learnerId, 40)}` : ''

  await notifyAdminLine(
    `📚 มีคนสนใจเรียน First Aid!\nแอด @jiacpr แล้ว และกำลังเรียนอยู่\n${learnerLine}\nติดตามชวนมาเรียน Practical ได้เลย 🎯`,
  )

  return Response.json({ ok: true })
}
