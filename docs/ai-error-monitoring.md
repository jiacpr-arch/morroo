# AI Error Monitoring & Alerting

ทุก error จากการเรียก Anthropic API ถูกรวมศูนย์ผ่าน `logAIError()` (`lib/anthropic-error.ts`)
ซึ่งส่งไป **3 ทาง**: console, Sentry (`Sentry.captureException`), และ PostHog (event `ai_error`)
พร้อม tag/property `ai_context` ที่บอกจุดที่ล้มเหลว (เช่น `longcase-examiner:score`,
`chatbot:stream`).

เป้าหมาย: รู้ทันทีเมื่ออัตรา AI error พุ่ง (เช่นช่วง Anthropic overloaded) แทนที่จะรู้ตอนผู้ใช้บ่น.

## 1. Sentry Alert (ตั้งใน Sentry Console)

1. Sentry → โปรเจกต์ → **Alerts → Create Alert → Issues** (หรือ Metric Alert)
2. เงื่อนไขแนะนำ:
   - **When**: number of events in an issue/group
   - **Filter**: `feature:ai` (tag ที่ `logAIError` ใส่ให้)
   - **Threshold**: เช่น มากกว่า **20 events ใน 5 นาที**
3. **Action**: ส่งเข้า Slack/อีเมล/LINE Notify (ตามที่ตั้ง integration ไว้)
4. ดู breakdown ราย `ai_context` เพื่อรู้ว่า feature ไหนล่ม (chatbot / longcase / mcq ...)

> ต้องตั้งค่า `SENTRY_DSN` (หรือ `NEXT_PUBLIC_SENTRY_DSN`) ใน env แล้ว — ดู `sentry.server.config.ts`

## 2. PostHog Alert (ต้องตั้ง env ก่อน)

`logAIError()` จะยิง event `ai_error` ไป PostHog เฉพาะเมื่อมี env นี้ (ถ้าไม่มี = ข้ามเงียบ ๆ ปลอดภัย):

| Env var | ค่า |
|---|---|
| `POSTHOG_PROJECT_KEY` | Project API key ของ PostHog (ขึ้นต้น `phc_...`) |
| `POSTHOG_HOST` | (ออปชัน) ดีฟอลต์ `https://us.i.posthog.com` |

ตั้ง `POSTHOG_PROJECT_KEY` ใน Vercel → Project → Settings → Environment Variables (production + preview)

หลัง event เริ่มไหลเข้า PostHog:
1. สร้าง Insight: Trends → event `ai_error` (นับต่อชั่วโมง/นาที) — breakdown ตาม property `ai_context` หรือ `status`
2. ตั้ง **Alert** บน insight นั้น: เกิน threshold → แจ้งเตือน

property ที่ส่งไปกับ event: `ai_context` (จุดที่ล้ม), `status` (HTTP status เช่น 529/500/429)

## 3. กลไกกัน error ที่มีอยู่แล้ว (อ้างอิง)

- **Retry**: `createAnthropic()` ตั้ง `maxRetries: 4`
- **Model fallback**: `createWithFallback` / `streamTextWithFallback` (`lib/anthropic.ts`) —
  Sonnet→Haiku สำหรับแชต, Opus→Sonnet สำหรับให้คะแนน
- **ข้อความสุภาพ**: `friendlyAIError()` แทน error ดิบ
- **Banner หน้าเว็บ**: `AiHealthProvider` + `AiStatusBanner` แสดงเมื่อ AI ล้มซ้ำ ๆ (จาก Long Case / MCQ / ChatWidget)
