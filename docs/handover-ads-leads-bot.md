# Handover: Ads / Leads / Bot System (จาก morroo)

เอกสารนี้คือ **context แบบครบ** สำหรับโปรเจกต์ปลายทางที่จะรับช่วงระบบ ads / leads / bot ไปทำต่อ — อ่านครั้งเดียวควรเริ่มงานได้

ส่วนที่ "ไม่มีในรีโป้ต้นทาง" อยู่ใน **Section 0** — อ่านก่อนเสมอเพื่อ set expectation

---

## 0. ⚠️ สิ่งที่ "ไม่มี" ในรีโป้ต้นทาง — ต้องสร้างใหม่ถ้าต้องการ

| ฟีเจอร์ | สถานะ | หมายเหตุ |
|---|---|---|
| **Meta Marketing API** (สร้าง/แก้ campaign/adset/ad) | ❌ ไม่มี | ระบบนี้แค่ "รับ lead" จาก ads ที่สร้างใน Ads Manager UI โดยมนุษย์ ดู blueprint คร่าวๆ ใน Section 12 |
| **Meta Pixel / Conversion API (CAPI)** | ❌ ไม่มี | ไม่มี conversion tracking กลับไปที่ ads → วัด ROAS รายแคมเปญไม่ได้ มีแค่ `campaign_id`/`adset_id`/`ad_id` เก็บเป็น metadata บน `leads` row |
| **Google Ads / TikTok Ads** | ❌ ไม่มี | — |
| **Telegram / Discord bot** | ❌ ไม่มี | bot รองรับแค่ web, LINE OA, Facebook Messenger |
| **FSM / structured conversation flow** | ❌ ไม่มี | bot เป็น free-form Claude มีแค่ intent marker `[INTENT:trial]` กับ card marker `[CARD:...]` (ไม่มี dialog tree) |
| **LIFF UI ใน chat** | ❌ ไม่มี | มี LIFF link generation สำหรับ account linking แต่ไม่ได้ embed LIFF UI ใน bot conversation |
| **GTM / analytics tagging บน landing page** | ❌ ไม่มี | — |

---

## 1. ขอบเขตของระบบ

ระบบนี้ทำ **3 หน้าที่** ที่เชื่อมโยงกัน:

1. **Lead capture** — รับ lead จาก:
   - Facebook Lead Ads (Instant Form) → webhook
   - Landing page `/lp/free-trial` → form POST
   - LINE OA / FB Messenger → "embryo lead" ตอน first contact (auto-created จาก userId/PSID)
2. **Bot multi-channel** — ตอบแชตด้วย Claude บน 3 channel: web widget, LINE OA, FB Messenger
3. **Lead nurture** — ออก redeem code, ส่ง follow-up email/LINE/Messenger ตาม schedule (D1/D3/D6), มี admin pipeline view

ทุกอย่างผูกกับ **Supabase Postgres** เป็น single source of truth + ระบบ redeem code → Stripe coupon

---

## 2. Tech stack

- **Next.js 16** (App Router, route handlers รัน node runtime, `maxDuration = 60`)
- **React 19**
- **Supabase** (`@supabase/supabase-js`, `@supabase/ssr`) — DB + Auth + Storage + pg_cron + `net.http_post`
- **Anthropic SDK** (`@anthropic-ai/sdk` ≥ 0.80) — model: **`claude-sonnet-4-6`**, max_tokens 600
- **LINE Messaging API** (raw fetch สำหรับ webhook); `@line/liff` สำหรับ LIFF
- **Facebook Graph API v24.0** — Messenger + Lead Ads + Page autopost + Instagram
- **Resend** — transactional email
- **Stripe** — coupon ผูกกับ redeem code
- **Sentry** — error monitoring
- **sharp** — แปลงรูป cover เป็น JPEG สำหรับ IG (alpha channel ของ PNG ทำให้ IG container reject)

---

## 3. Database schema

### `leads` (canonical migration: `20260508_leads_redeem.sql`)
```sql
CREATE TABLE leads (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  source          text NOT NULL,
    -- 'fb_leadgen_form' | 'fb_messenger' | 'line_oa' | 'landing' | 'organic' | 'admin'
  campaign        text,
  ad_set          text,
  fb_lead_id      text UNIQUE,    -- idempotency key สำหรับ FB Instant Form replay
  fb_psid         text,           -- Messenger PSID
  line_user_id    text,           -- LINE userId
  email           text,
  phone           text,
  name            text,
  status_year     text,           -- ปีการศึกษา
  exam_target     text,           -- 'NL1' | 'NL2' | 'both' | 'unknown'
  reward_choice   text,           -- 'monthly_1m' | 'bundle_10q'
  stage           text NOT NULL DEFAULT 'new',
    -- 'new' | 'contacted' | 'code_issued' | 'registered' | 'redeemed' | 'paid' | 'dropped'
  user_id         uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  consent_pdpa    boolean NOT NULL DEFAULT false,
  consent_at      timestamptz,
  raw_payload     jsonb,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);
-- Indexes: stage, source, email, created_at DESC
-- Partial: fb_psid WHERE NOT NULL, line_user_id WHERE NOT NULL
-- RLS: admins only (read/update). Service role bypasses
```

### `redeem_codes`
```sql
CREATE TABLE redeem_codes (
  code              text PRIMARY KEY,
  reward_type       text NOT NULL,    -- 'monthly_1m' | 'bundle_10q'
  source            text NOT NULL,
  campaign          text,
  lead_id           uuid REFERENCES leads(id) ON DELETE SET NULL,
  issued_to_email   text,
  redeemed_by       uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  redeemed_at       timestamptz,
  expires_at        timestamptz NOT NULL,   -- default = 7 วัน
  stripe_coupon_id  text,
  created_at        timestamptz NOT NULL DEFAULT now()
);
```

### `chat_messages` (`20260507_chatbot.sql` + `20260510_chat_messages_lead_link.sql`)
```sql
CREATE TABLE chat_messages (
  id              bigserial PRIMARY KEY,
  channel         text NOT NULL,    -- 'web' | 'line' | 'facebook'
  channel_user_id text NOT NULL,    -- web: session uuid OR auth user id; line: lineUserId; facebook: PSID
  user_id         uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  lead_id         uuid REFERENCES leads(id) ON DELETE SET NULL,   -- linked from webhooks
  role            text NOT NULL,    -- 'user' | 'assistant'
  content         text NOT NULL,
  created_at      timestamptz NOT NULL DEFAULT now()
);
-- Indexes: (channel, channel_user_id, created_at DESC), (user_id, created_at DESC), (lead_id, created_at DESC)
-- RLS: service-role only
```

### `lead_messages_sent` — dedupe follow-up reminders
```sql
CREATE TABLE lead_messages_sent (
  lead_id   uuid NOT NULL REFERENCES leads(id) ON DELETE CASCADE,
  day       int NOT NULL,           -- 1 | 3 | 6
  channel   text NOT NULL,          -- 'email' | 'messenger' | 'line'
  sent_at   timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (lead_id, day, channel)
);
```

### `lead_chat_state` — สถานะ conversation (Messenger PSID)
```sql
CREATE TABLE lead_chat_state (
  psid          text PRIMARY KEY,
  step          text NOT NULL,
  partial_data  jsonb NOT NULL DEFAULT '{}',
  campaign      text,
  ad_set        text,
  updated_at    timestamptz NOT NULL DEFAULT now()
);
```

### `bundle_credits` — ledger ของ credit ที่มาจาก redeem
```sql
CREATE TABLE bundle_credits (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  delta       int NOT NULL,
  source      text NOT NULL,        -- 'redeem' | 'purchase' | 'use' | 'adjustment'
  reference   text,
  created_at  timestamptz NOT NULL DEFAULT now()
);
```

### `trial_messages_sent` (`20260509`) — dedupe trial-expiry reminders (D-3 / D-1)
```sql
CREATE TABLE trial_messages_sent (
  profile_id           uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  days_before_expiry   int NOT NULL,
  channel              text NOT NULL,    -- 'email' | 'line' | 'messenger'
  sent_at              timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (profile_id, days_before_expiry, channel)
);
```

### `line_link_codes` — รหัส 1-time สำหรับ link Supabase user ↔ LINE userId
```sql
-- (มีอยู่ในรีโป้ต้นทางก่อน migration tracking; schema คร่าวๆ:)
CREATE TABLE line_link_codes (
  code        text PRIMARY KEY,         -- 'MORROO-XXXXXX' (6 chars from CHARS = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789')
  user_id     uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  expires_at  timestamptz NOT NULL,
  created_at  timestamptz NOT NULL DEFAULT now()
);
```

### `app_settings` — KV store (ใช้เก็บ rotating FB user token)
```sql
CREATE TABLE app_settings (
  key        text PRIMARY KEY,
  value      text NOT NULL,
  updated_at timestamptz NOT NULL DEFAULT now()
);
-- key 'facebook_user_token' = current long-lived user token (rotates ทุก cron run)
```

### `blog_posts` extensions (`20260504_blog_autopost_state.sql` + `20260508_blog_instagram_state.sql`)
```
fb_post_id, fb_posted_at, fb_last_error,
cover_image_line, line_broadcast_at, line_last_error,
ig_media_id, ig_posted_at, ig_last_error,
autopost_format text CHECK IN ('cover_caption', 'quote_card', 'link_only')
-- Partial indexes บน WHERE fb_post_id IS NULL / line_broadcast_at IS NULL / ig_media_id IS NULL
```

### Migrations ที่ต้อง replay (เรียงตามวันที่)

```
20260406_app_settings.sql           (ถ้าไม่มี: สร้าง app_settings ก่อน — ใช้โดย FB token rotation)
20260407_line_notifications.sql     (RPC + pg_cron jobs สำหรับ LINE notif)
20260504_blog_autopost_state.sql    (blog_posts FB columns)
20260507_chatbot.sql                (chat_messages)
20260508_blog_instagram_state.sql   (blog_posts IG columns)
20260508_leads_redeem.sql           (leads, redeem_codes, lead_messages_sent, lead_chat_state, bundle_credits)
20260509_trial_messages_sent.sql    (trial reminder dedupe)
20260510_chat_messages_lead_link.sql (chat_messages.lead_id + line_oa source)
```

> ⚠️ `line_link_codes` ถูก reference ใน webhook แต่ไม่มี migration file ที่สร้างชัดเจน — ปลายทางต้องสร้างเอง (DDL อยู่ข้างบน)

---

## 4. Environment variables

```bash
# Supabase
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=

# Anthropic
ANTHROPIC_API_KEY=

# Facebook / Instagram
FACEBOOK_APP_ID=
FACEBOOK_APP_SECRET=
FACEBOOK_PAGE_ID=
FACEBOOK_PAGE_TOKEN=               # Page Access Token (pages_messaging permission)
FACEBOOK_USER_TOKEN=               # initial long-lived user token (60 days, will auto-rotate)
FACEBOOK_VERIFY_TOKEN=             # for Messenger webhook handshake
FACEBOOK_LEADS_VERIFY_TOKEN=       # for Lead Ads webhook handshake (separate token)
FACEBOOK_LEAD_FORM_REWARDS=        # 'form_id_a=monthly_1m,form_id_b=bundle_10q'
INSTAGRAM_AUTOPOST_ENABLED=true
INSTAGRAM_BUSINESS_ACCOUNT_ID=

# LINE (main OA)
LINE_CHANNEL_SECRET=
LINE_CHANNEL_ACCESS_TOKEN=
LINE_CHANNEL_TOKEN=                # บางจุดใช้ key นี้แทน — set ค่าเดียวกันได้
LINE_LOGIN_CHANNEL_ID=
LINE_TARGET_ID=
LINE_AUTOPOST_ENABLED=true

# LINE (Jiaroo secondary OA — separate channel)
JIAROO_LINE_CHANNEL_SECRET=
JIAROO_LINE_CHANNEL_TOKEN=

# Email / Cron
RESEND_API_KEY=
MAIL_FROM=
ADMIN_EMAIL=
CRON_SECRET=                       # Vercel Cron Bearer auth
BLOG_GENERATE_SECRET=              # alternative ?secret=… auth สำหรับ external trigger

NEXT_PUBLIC_SITE_URL=              # e.g. https://www.morroo.com
```

---

## 5. API endpoints

### Lead intake
| Method+Path | หน้าที่ |
|---|---|
| `POST /api/leads/create` | Public landing form. Body: `{name, email, phone?, status_year?, exam_target?, reward_choice, consent_pdpa, campaign?, ad_set?}` → สร้าง lead + ออก code + ส่ง email |
| `GET /api/leads/fb-instant-form` | Meta verify handshake (`FACEBOOK_LEADS_VERIFY_TOKEN`) |
| `POST /api/leads/fb-instant-form` | HMAC-verified leadgen webhook → `fetchLeadgenData` → `mapFieldData` → `createLead`. **ต้อง 200 เสมอหลัง processing** ยกเว้น signature fail → 401 |

### Bot / chat
| Method+Path | หน้าที่ |
|---|---|
| `POST /api/chat` | Web chat (anonymous session id หรือ logged-in user). Streaming SSE. Rate limit 30/hr/channel_user_id |
| `GET /api/facebook/webhook` | Messenger verify handshake |
| `POST /api/facebook/webhook` | Signed webhook → bot reply via `generateChatbotReply()`, rate limit 30/hr/PSID |
| `POST /api/line/webhook` | Main OA: ตรวจ "MORROO-XXXXXX" → account link, อื่นๆ → bot reply |
| `POST /api/line/jiaroo-webhook` | Secondary OA (different channel keys) |
| `POST /api/facebook/data-deletion` | Meta required endpoint |

### LINE features (notifications + linking)
| Method+Path | หน้าที่ |
|---|---|
| `POST /api/line/daily-reminder` | Cron-triggered |
| `POST /api/line/expiry-warning` | Cron-triggered |
| `POST /api/line/weekly-summary` | Cron-triggered |
| `POST /api/line/generate-code` | สร้าง 1-time code 'MORROO-XXXXXX' สำหรับ link account (Bearer auth) |
| `POST /api/line/liff-link` | LIFF link generation |

### Admin / CRM
| Method+Path | หน้าที่ |
|---|---|
| `PATCH /api/admin/leads/[id]/stage` | เปลี่ยน stage manual |
| `POST /api/admin/leads/[id]/issue-code` | ออก code manual |
| Page `/admin/leads` | Pipeline view |
| Page `/admin/chatbot` | Conversation viewer |

### Cron
| Method+Path | หน้าที่ |
|---|---|
| `GET /api/cron/lead-followup` | Daily — ส่ง follow-up email/LINE/Messenger (D1, D3, D6) |
| `GET /api/cron/trial-expiry` | Daily — D-3 / D-1 reminder ก่อน trial หมดอายุ |
| `GET /api/autopost/retry?platform=fb\|line\|ig\|both\|all&slug=...&limit=1` | Retry autopost (1 article/invocation, Vercel 60s cap) |

**Auth pattern ของ cron:** รับได้ทั้ง `Authorization: Bearer ${CRON_SECRET}` (Vercel Cron) หรือ `?secret=${BLOG_GENERATE_SECRET}` (external)

---

## 6. Library modules

### Bot core
| ไฟล์ | หน้าที่ |
|---|---|
| `lib/chatbot.ts` | `generateChatbotReply()` (non-streaming), `streamChatbotReply()` (SSE), `trimHistory()`. Uses Claude `claude-sonnet-4-6`, max 600 tokens. แยก `[INTENT:trial]` ก่อน, ตามด้วย `[CARD:...]` (LINE only) |
| `lib/bot-intent.ts` | `handleBotIntent(leadId, intent, channel)` — ออก/resend code ตามกฎ (cap 3, skip ถ้า redeemed/paid). `handleEmailCapture(leadId, message)` — detect bare email และบันทึกบน lead row. `detectEmail(message)` |
| `lib/lead-channel.ts` | `getOrCreateLeadFromChannel({channel, channelUserId})` — สร้าง embryo lead จาก PSID/lineUserId ตอน first contact, touch updated_at ทุกครั้ง |

### Channel adapters
| ไฟล์ | หน้าที่ |
|---|---|
| `lib/facebook-leads.ts` | `verifyWebhookSignature()` (HMAC-SHA256, constant-time), `fetchLeadgenData(leadgenId)` (Graph v24.0), `mapFieldData()` (รองรับ Thai aliases: อีเมล, ชื่อ, เบอร์โทร, ชั้นปี, ฯลฯ), `rewardForForm(formId)`, `resolvePageAccessToken()` |
| `lib/facebook-messenger.ts` | `sendFbMessage(psid, text)`, `sendFbTyping(psid, on)`, `sendFbReadReceipt(psid)`, `verifyFbSignature()`. Graph v24.0, `messaging_type: "RESPONSE"` (24-hour window) |
| `lib/facebook.ts` | **Token auto-refresh**: `getLatestUserToken()` (Supabase `app_settings` first, env fallback), `refreshUserToken()` (60-day exchange), `saveUserToken()`, `getPageToken(pageId, userToken)`. Cron ที่รัน 2x/week ทำให้ token ไม่หมดอายุ. `postToFacebook()` |
| `lib/instagram.ts` | `postToInstagram()` — 2-step API (container → publish). ต้อง JPEG ผ่าน sharp flatten |
| `lib/line.ts` | `sendLineMessage(userId, messages)` (push), `broadcastLineMessages(messages)`, `verifyLineSignature()` (base64 HMAC-SHA256) |
| `lib/line-flex-templates.ts` | Flex Message templates: `buildChatbotCard(card)` รองรับ `pricing`/`register`/`longcase`/`meq`, `buildBlogAnnounceFlex()` |

### Lead lifecycle
| ไฟล์ | หน้าที่ |
|---|---|
| `lib/leads.ts` | `createLead(args)` — idempotent บน `fb_lead_id`, ออก code, ส่ง email fire-and-forget |
| `lib/redeem.ts` | `issueRedeemCode({rewardType, source, campaign?, leadId?, issuedToEmail?})` → `{code, expiresAt}`. Default expiry = 7 วัน |
| `lib/email/send.ts`, `lib/email/templates.ts` | Resend wrapper: `sendRedeemCodeEmail()`, `sendLeadFollowupEmail()`, `sendTrialExpiryEmail()` |
| `lib/notifications.ts` | Multi-channel notification helpers |
| `lib/newsletter-unsubscribe.ts` | Token-based unsubscribe |

### Autopost (อยู่ติดกับระบบนี้เพราะใช้ FB token เดียวกัน)
| ไฟล์ | หน้าที่ |
|---|---|
| `lib/autopost-copy.ts` | `generateHook(post)` — AI-generated hook |
| `lib/autopost-format.ts` | `pickAutopostFormat()` (round-robin: cover_caption / quote_card / link_only), `categoryHashtag()` |

### UI
| ไฟล์ | หน้าที่ |
|---|---|
| `components/ChatWidget.tsx` | Web chat bubble มุมขวาล่าง: localStorage history (key `morroo-chat`, session id `morroo-chat-session`), greeting + 4 quick replies, streaming reply, unread badge |
| `app/lp/free-trial/page.tsx` | Landing page (รับ `?campaign=&ad_set=&reward=` query) |
| `app/lp/free-trial/LeadForm.tsx` | Form → POST `/api/leads/create` |
| `app/admin/leads/page.tsx` | Pipeline + redeem code view |
| `app/admin/chatbot/page.tsx` | Conversation viewer |

---

## 7. Business rules ที่สำคัญ

1. **Redeem code expiry = 7 วัน** จากวันออก
2. **Follow-up reminders ที่ D1, D3, D6** — D6 = "เหลือ 1 วัน" (D7 = "หมดวันนี้" สายไป) ดู `app/api/cron/lead-followup/route.ts`
3. **Bot trial intent cap = 3 codes / lead** ตลอดอายุ (constant `MAX_CODES_PER_LEAD` ใน `bot-intent.ts`) → กัน spam "ขอโค้ดใหม่"
4. **Skip trial logic** ถ้า `lead.stage ∈ {redeemed, paid}` — บอทยังคุยปกติได้ แค่ไม่ออก code
5. **Resend active code first** — ถ้า lead มี code ที่ unredeemed + ยังไม่ expired → ส่งซ้ำตัวเดิม ไม่ออกใหม่ (ลด waste codes)
6. **First-issue vs reissue copy** — ครั้งแรก: "🎁 พี่มีโค้ด..."; ครั้งต่อๆ ไป: "พี่ออกโค้ด...ใหม่ให้น้องเลยครับ"
7. **Webhook idempotency**:
   - FB Lead Ads → `fb_lead_id` UNIQUE constraint (replay-safe)
   - **ทุก Meta webhook ต้อง 200 หลัง best-effort** เพราะ Meta retry บน non-2xx; ยกเว้น signature fail → 401 (กัน replay abuse)
8. **Embryo lead** — ทุกครั้งที่มี first message ใน Messenger/LINE → สร้าง lead row อัตโนมัติ (`source = fb_messenger`/`line_oa`, `stage = new`, ไม่มี email) เพื่อ admin pipeline เห็นทุก conversation
9. **Rate limit** = 30 user messages / hour / `channel_user_id` (web + Messenger)
10. **LINE link code** = `MORROO-XXXXXX` (6 chars จาก `ABCDEFGHJKLMNPQRSTUVWXYZ23456789`); generate-code endpoint ลบ code เก่าของ user ก่อนสร้างใหม่; webhook ปฏิเสธถ้าหมดอายุหรือ LINE userId นี้ link กับ user อื่นแล้ว
11. **FB token rotation** — ทุกครั้งที่ cron blog/autopost รัน ระบบจะ exchange `FACEBOOK_USER_TOKEN` เป็น 60-day token ใหม่ และเก็บใน `app_settings.facebook_user_token`. ถ้า cron รันอย่างน้อย 1 ครั้งใน 60 วัน → token ไม่หมดอายุเลย. **เปลี่ยน Page = `DELETE FROM app_settings WHERE key = 'facebook_user_token'`**
12. **Autopost retry** = 1 article / invocation (Vercel maxDuration 60s). ใช้ partial index บน `WHERE fb_post_id IS NULL` ให้ scan ถูก
13. **PDPA consent** บังคับใน `/api/leads/create` (ถ้า `consent_pdpa: false` → return `missing_consent`)
14. **Email capture** — ถ้า user พิมพ์อีเมลล้วนๆ ในแชต (regex `^\w+@\w+\.\w{2,}$` บน trimmed message) → upsert บน lead row + ตอบ "บันทึกอีเมลแล้วนะครับ 📧"

---

## 8. External integration touch points

- **Meta App Dashboard:**
  - Webhook URLs:
    - Messenger → `https://<host>/api/facebook/webhook` (verify token = `FACEBOOK_VERIFY_TOKEN`)
    - Lead Ads → `https://<host>/api/leads/fb-instant-form` (verify token = `FACEBOOK_LEADS_VERIFY_TOKEN` — **คนละตัว**)
  - Page subscription: `messages`, `messaging_postbacks`, `leadgen`
- **LINE Developer Console** (สอง channel):
  - Main OA → `/api/line/webhook`
  - Jiaroo OA → `/api/line/jiaroo-webhook`
  - LIFF endpoint → `/lp/free-trial` (หรือที่ตั้งไว้)
- **Vercel Cron** (`vercel.json`): schedule `/api/cron/lead-followup` (daily), `/api/cron/trial-expiry` (daily), `/api/line/daily-reminder`, `/api/line/expiry-warning`, `/api/line/weekly-summary`, `/api/autopost/retry`
- **Supabase pg_cron + `net.http_post`**: schedule LINE notifications ฝั่ง DB (อ้าง `current_setting('app.site_url')`, `current_setting('app.blog_generate_secret')`)
- **Stripe**: coupon ถูกสร้างคู่กับ redeem code (`stripe_coupon_id` column)

---

## 9. Tests (สะท้อน business rules — ใช้เป็น spec ได้)

- `lib/bot-intent.test.ts` — cap 3 codes, resend active code, skip converted stages
- `lib/facebook-leads.test.ts` — signature verify, field mapping (Thai aliases), `rewardForForm`
- `lib/lead-channel.test.ts` — embryo lead create, lookup by PSID/userId, touch updated_at
- `app/api/cron/lead-followup/route.test.ts` — D1/D3/D6 dedupe, expired code skip

ใช้ **Vitest** (`npm test`)

---

## 10. SYSTEM_PROMPT ของ Bot (verbatim จาก `lib/chatbot.ts`)

> โปรเจกต์ปลายทางควรปรับ persona / สินค้า / ราคา / ลิงก์ ให้ตรงกับ branding ตัวเอง

```
คุณคือ "พี่หมอรู้" ผู้ช่วยอัจฉริยะของ MorRoo (หมอรู้) — แพลตฟอร์มเตรียมสอบใบประกอบวิชาชีพแพทย์ที่ใช้ AI

## ตัวตนและสไตล์
- คุณเป็นรุ่นพี่แพทย์ที่อบอุ่น เข้าใจความเครียดของน้อง ๆ ที่กำลังเตรียมสอบ
- พูดภาษาไทยกระชับ ใช้คำว่า "พี่/น้อง" หรือ "ครับ/ค่ะ" ตามบริบท ไม่ทางการเกินไป
- ตอบสั้น กระชับ 2-4 ประโยค (ยกเว้นมีคำถามที่ต้องอธิบายลึก)
- ใช้ emoji ได้บ้างแต่ไม่เยอะ (1-2 ตัวต่อข้อความ) เน้น 🩺 📚 ✨ 🎯

## ภารกิจ
ช่วยน้อง ๆ เตรียมสอบ และในขณะเดียวกัน **โน้มน้าวให้เห็นคุณค่า MorRoo จนสมัครหรือซื้อได้** โดย:
1. ฟังปัญหา/คำถามของน้อง ก่อน
2. ตอบให้เป็นประโยชน์ก่อนเสมอ (ถ้าตอบไม่ได้ ยอมรับตรง ๆ)
3. เชื่อมโยงไปกับฟีเจอร์ MorRoo ที่ช่วยแก้ปัญหานั้น (อย่ายัดเยียด — ทำเป็นธรรมชาติ)
4. ปิดท้ายด้วย CTA ที่เกี่ยวข้อง (ลิงก์/แพ็กเกจ)

## สินค้าและราคา (อัปเดตล่าสุด)
- **ฟรี**: ทำข้อสอบฟรี 5 ข้อ/สาขา + เห็นเฉลยสั้น (ไม่ต้องใส่บัตรเครดิต)
- **ซื้อชุด ฿299**: เลือก 10 ข้อ ดูเฉลยละเอียด + Key Points + AI ตรวจคำตอบ ไม่มีวันหมดอายุ
- **รายเดือน ฿199/เดือน** ⭐ ยอดนิยม: ข้อสอบทั้งหมดไม่จำกัด + AI ไม่จำกัด + Long Case ไม่จำกัด + ข้อสอบใหม่ทุกสัปดาห์
- **รายปี ฿1,490/ปี**: ทุกอย่างของรายเดือน + ประหยัด ฿898/ปี (ลด 38%)

## ฟีเจอร์หลัก (ใช้เป็นจุดขาย)
- **MEQ Progressive Case** — ข้อสอบอัตนัยสำหรับสอบ NL Step 3 จำลองสอบจริง
- **MCQ 1,300+ ข้อ** — ครอบคลุม 6 สาขาหลัก (Medicine, Surgery, OB-GYN, Pediatrics, Psychiatry, Family Med)
- **🤖 AI ตรวจคำตอบ** — feedback ทันที ไม่ต้องรออาจารย์
- **🩺 Long Case Exam** — AI Patient + AI Examiner จำลองสอบ Long Case เสมือนจริง
- **เฉลยละเอียด** — Key Points + เหตุผลแต่ละตัวเลือก
- **อัปเดตข้อสอบใหม่ทุกสัปดาห์**

## ลิงก์สำคัญ (ใช้แทรกเมื่อเหมาะสม)
- หน้าแรก: https://www.morroo.com
- สมัครฟรี: https://www.morroo.com/register
- แพ็กเกจ/ราคา: https://www.morroo.com/pricing
- ข้อสอบ MEQ: https://www.morroo.com/exams
- MCQ: https://www.morroo.com/dashboard
- Long Case: https://www.morroo.com/longcase

## CARD MARKERS — สำหรับช่อง LINE เท่านั้น (เว็บ/Facebook ห้ามใช้ marker นี้)
ถ้าช่องคือ LINE และจะแนะนำ CTA → ปิดท้ายข้อความด้วย marker ตัวใดตัวหนึ่ง (และห้ามใส่ลิงก์ URL ของ CTA นั้นในข้อความซ้ำ — ระบบจะแสดงเป็นการ์ดมีปุ่มกดเอง):
- [CARD:pricing] — ตอนแนะนำดูแพ็กเกจ/ราคา
- [CARD:register] — ตอนแนะนำสมัครฟรี
- [CARD:longcase] — ตอนแนะนำ Long Case Exam
- [CARD:meq] — ตอนแนะนำข้อสอบ MEQ
กฎ: 1 ข้อความมีได้ marker เดียว, marker ต้องอยู่ท้ายสุด, ห้ามใส่ใน channel เว็บหรือ Facebook

## INTENT MARKERS — ทุกช่องทาง (LINE, Facebook, เว็บ)
เมื่อน้องแสดงเจตนาอย่างชัดเจนว่าอยากเริ่มใช้ MorRoo หรือขอทดลองใช้ฟรี (เช่น "อยากลอง", "สมัครได้เลยไหม", "ขอโค้ดทดลองได้ไหม", "จะเริ่มเลยครับ", "สนใจสมัคร") → ปิดท้ายข้อความด้วย [INTENT:trial]
กฎ:
- ใช้เฉพาะเมื่อน้องแสดงเจตนาจะสมัครหรือทดลองใช้จริง ๆ เท่านั้น — ไม่ใช้กับการถามข้อมูลทั่วไป
- marker นี้ใช้ได้ทุกช่อง (LINE, Facebook, เว็บ) ไม่ขัดกับ CARD marker (ถ้ามี CARD ให้วาง CARD ก่อน แล้วตามด้วย INTENT)
- ระบบจะตัด marker ออกก่อนแสดงให้น้องเห็น

## เทคนิคการโน้มน้าว (ใช้เนียน ๆ ไม่ยัดเยียด)
- ถ้าน้องบ่นเรื่องเวลา → ชู AI ตรวจคำตอบ (feedback ทันที)
- ถ้าน้องกังวลเรื่องการสอบจริง → ชู Long Case + MEQ Progressive Case ที่จำลองสอบจริง
- ถ้าน้องขอข้อสอบ/อยากลอง → แนะนำ "สมัครฟรีไม่ต้องบัตรเครดิต" ก่อนเสมอ
- ถ้าน้องลองแล้วชอบ → ค่อยแนะนำรายเดือน ฿199 (เน้นว่าถูกกว่ากาแฟ 2 แก้ว/สัปดาห์)
- ถ้าน้องเตรียมยาว → ชูรายปี ฿1,490 (ประหยัด ฿898)

## ข้อห้ามเด็ดขาด
- ❌ ห้ามให้คำตอบทางการแพทย์ที่อาจอันตราย (ถ้าน้องถามเรื่องคนไข้จริง บอกให้ปรึกษาอาจารย์)
- ❌ ห้ามใส่ราคาผิด หรือสร้างโปรโมชั่นที่ไม่มีจริง
- ❌ ห้ามแอบอ้างว่ามีฟีเจอร์ที่ไม่ได้ระบุข้างบน
- ❌ ห้ามตอบยาวเกิน 4-5 ประโยค (ยกเว้นน้องขอคำอธิบายลึก)
- ❌ ห้ามใช้ Markdown ตาราง/หัวข้อใหญ่ (ตอบแบบแชทธรรมชาติ)
```

ต่อท้ายด้วย channel hint:
- web: `"ช่องทาง: เว็บแชทบนหน้า morroo.com — ใส่ลิงก์เต็ม URL ได้เลย"`
- line: `"ช่องทาง: LINE OA — ตอบสั้นกระชับ ใส่ลิงก์เต็มได้ น้องคลิกได้จาก LINE"`
- facebook: `"ช่องทาง: Facebook Messenger — ตอบสั้นกระชับ ใส่ลิงก์เต็มได้"`

---

## 11. Sample payloads

### 11.1 Facebook Lead Ads webhook (POST `/api/leads/fb-instant-form`)

Headers: `X-Hub-Signature-256: sha256=<hex>` (HMAC-SHA256 ของ raw body กับ `FACEBOOK_APP_SECRET`)

Body:
```json
{
  "object": "page",
  "entry": [{
    "id": "<page_id>",
    "time": 1715000000,
    "changes": [{
      "field": "leadgen",
      "value": {
        "leadgen_id": "1234567890",
        "page_id": "<page_id>",
        "form_id": "9876543210",
        "adgroup_id": "<ad_id>",
        "ad_id": "<ad_id>",
        "created_time": 1715000000
      }
    }]
  }]
}
```

หลัง verify signature → fetch full lead via Graph:
```
GET https://graph.facebook.com/v24.0/{leadgen_id}
   ?fields=id,created_time,ad_id,adset_id,campaign_id,form_id,field_data
   &access_token=<page_token>
```

Response:
```json
{
  "id": "1234567890",
  "created_time": "2026-05-11T03:00:00+0000",
  "ad_id": "...", "adset_id": "...", "campaign_id": "...", "form_id": "...",
  "field_data": [
    {"name": "email", "values": ["user@example.com"]},
    {"name": "ชื่อ",   "values": ["สมชาย ใจดี"]},
    {"name": "เบอร์โทร", "values": ["0812345678"]},
    {"name": "ชั้นปี", "values": ["5"]}
  ]
}
```

### 11.2 Facebook Messenger webhook (POST `/api/facebook/webhook`)

Headers: `X-Hub-Signature-256: sha256=<hex>`

Body (text message):
```json
{
  "object": "page",
  "entry": [{
    "id": "<page_id>",
    "time": 1715000000,
    "messaging": [{
      "sender": {"id": "<PSID>"},
      "recipient": {"id": "<page_id>"},
      "timestamp": 1715000000,
      "message": {
        "mid": "m_...",
        "text": "อยากลองใช้ค่ะ"
      }
    }]
  }]
}
```

### 11.3 LINE webhook (POST `/api/line/webhook`)

Headers: `X-Line-Signature: <base64 HMAC-SHA256(body, LINE_CHANNEL_SECRET)>`

Body (follow event + message):
```json
{
  "destination": "<bot_user_id>",
  "events": [
    {
      "type": "follow",
      "timestamp": 1715000000000,
      "source": {"type": "user", "userId": "U123abc..."},
      "replyToken": "...",
      "mode": "active"
    },
    {
      "type": "message",
      "timestamp": 1715000001000,
      "source": {"type": "user", "userId": "U123abc..."},
      "message": {"id": "...", "type": "text", "text": "ขอโค้ดทดลองได้ไหมคะ"},
      "replyToken": "...",
      "mode": "active"
    }
  ]
}
```

### 11.4 ตัวอย่าง bot reply ที่มี markers

LINE channel + ขอ trial:
```
สนใจอยากลองใช่ไหมครับ พี่มีโค้ดทดลองรายเดือนฟรีให้น้องเลย 🎁
ลองทำข้อสอบฟรีดูก่อนได้นะครับ [CARD:register] [INTENT:trial]
```

Web channel + แนะนำราคา:
```
ราคาเริ่มต้นที่รายเดือน ฿199 ครับ ประหยัดกว่ารายปี ฿1,490 ดูได้ที่ https://www.morroo.com/pricing 🎯
```

(การ์ดและ intent ถูก strip ก่อนแสดงผู้ใช้ ใช้ตัดสินใจฝั่ง server เท่านั้น)

---

## 12. Blueprint คร่าวๆ — Meta Marketing API (ถ้าจะสร้าง "การยิง ads programmatic")

> นี่เป็น **guideline ไม่ใช่ implementation** — รีโป้ต้นทางไม่มีโค้ดส่วนนี้

### 12.1 Auth & permissions
- ใช้ **System User** ของ Business Manager → ออก System User Access Token (ไม่หมดอายุ)
- App ต้องผ่าน **App Review** สำหรับ permissions:
  - `ads_management` — สร้าง/แก้ campaign, ad set, ad
  - `ads_read` — query insights
  - `business_management`
  - `pages_show_list`, `pages_read_engagement` (สำหรับ creative ที่ใช้ Page)

### 12.2 Endpoint ที่ใช้ (Graph API v24.0)

```
# Campaign
POST /act_{ad_account_id}/campaigns
  { "name", "objective": "OUTCOME_LEADS", "status": "PAUSED",
    "special_ad_categories": [], "buying_type": "AUCTION" }

# Ad Set (audience + budget + schedule)
POST /act_{ad_account_id}/adsets
  { "name", "campaign_id", "daily_budget": 50000,  // micros (= ฿500)
    "billing_event": "IMPRESSIONS", "optimization_goal": "LEAD_GENERATION",
    "targeting": { "geo_locations": {"countries": ["TH"]},
                   "age_min": 22, "age_max": 35,
                   "interests": [{"id": "...", "name": "Medicine"}] },
    "start_time", "end_time", "status": "PAUSED" }

# Ad Creative
POST /act_{ad_account_id}/adcreatives
  { "name", "object_story_spec": {
      "page_id": "<page_id>",
      "link_data": { "message", "link", "image_hash", "name", "description",
                     "call_to_action": {"type": "SIGN_UP"} } } }

# Ad
POST /act_{ad_account_id}/ads
  { "name", "adset_id", "creative": {"creative_id": "..."},
    "status": "PAUSED" }

# Activate
POST /{ad_id}  { "status": "ACTIVE" }

# Insights
GET /{campaign_id}/insights
  ?fields=spend,impressions,clicks,actions,cost_per_action_type
  &date_preset=last_7d
```

### 12.3 Suggested DB schema เสริม

```sql
CREATE TABLE ad_campaigns (
  id              text PRIMARY KEY,    -- Meta campaign_id
  name            text NOT NULL,
  objective       text NOT NULL,
  status          text NOT NULL,
  daily_budget    int,                  -- บาท
  created_at      timestamptz, updated_at timestamptz
);

CREATE TABLE ad_sets (
  id              text PRIMARY KEY,
  campaign_id     text REFERENCES ad_campaigns(id),
  name            text, status text,
  targeting       jsonb,
  daily_budget    int,
  start_time, end_time timestamptz
);

CREATE TABLE ad_creatives (
  id              text PRIMARY KEY,
  name            text, image_hash text, body text, headline text, link text
);

CREATE TABLE ads (
  id              text PRIMARY KEY,
  adset_id        text REFERENCES ad_sets(id),
  creative_id     text REFERENCES ad_creatives(id),
  name            text, status text
);

CREATE TABLE ad_performance_snapshots (
  id              bigserial PRIMARY KEY,
  level           text,              -- 'campaign' | 'adset' | 'ad'
  entity_id       text NOT NULL,
  date            date NOT NULL,
  spend           numeric, impressions int, clicks int, leads int,
  cost_per_lead   numeric,
  fetched_at      timestamptz NOT NULL DEFAULT now()
);
```

### 12.4 Meta Pixel + CAPI (เพิ่ม conversion tracking)
- ฝัง Meta Pixel base code ใน `app/layout.tsx`
- Trigger events:
  - `Lead` ตอน landing form submit success
  - `CompleteRegistration` ตอน signup ผ่าน redeem code
  - `Subscribe` ตอน Stripe webhook `customer.subscription.created`
- **CAPI** = ส่ง events จาก server-side ด้วย `event_id` เดียวกับ Pixel เพื่อ deduplicate (server-side ทนทานกว่า ad blockers)
  - Endpoint: `POST https://graph.facebook.com/v24.0/{pixel_id}/events`
  - ส่งพร้อม `user_data` ที่ hash แล้ว (em, ph, fn, ln, fbc, fbp)

### 12.5 Architectural notes
- เก็บ ad insights ทุกวัน (cron) เพื่อมี time-series — Meta API rate limit จะกินถ้า query บ่อยๆ
- Map `leads.campaign` → `ad_campaigns.id` เพื่อต่อ ROAS = (revenue from leads) / (campaign spend)
- A/B testing: สร้างหลาย ad set ต่อ 1 campaign → Meta จะ split traffic ให้

---

## 13. Out of scope (ไม่ต้องย้าย)

- MCQ / Long Case / MEQ exam features
- User auth (Supabase auth) — เกี่ยวแค่ตอนผูก `lead.user_id` หลังสมัคร
- Stripe checkout / billing — เกี่ยวแค่ตอนใช้ coupon
- Blog content generation — เกี่ยวแค่ตอน trigger autopost

---

## 14. Recommended porting workflow

1. **Provision infra:** Supabase project ใหม่, Vercel project ใหม่, Resend domain, Stripe account
2. **Replay migrations** ตามลำดับใน Section 3 (+ สร้าง `line_link_codes` ตาม DDL)
3. **Set env vars** ตาม Section 4
4. **Port lib/ + app/api/ + components/** ตามรายการ Section 6
5. **Setup webhooks externally:** Meta App + LINE Console + Vercel Cron + pg_cron
6. **Run tests** ใน Section 9 ให้ผ่าน
7. **Smoke test:**
   - POST `/api/leads/create` → ดูว่า lead row สร้าง + email ส่งจริง
   - ส่งข้อความใน LINE OA → ดูว่ามี chat_messages row + lead row + bot reply
   - Trigger FB Lead Ads test event → ดูว่า lead row สร้างจาก `fb_lead_id`
8. **เปลี่ยน SYSTEM_PROMPT, ลิงก์, ราคา, persona** ใน `chatbot.ts` ให้ตรงกับ branding ใหม่
