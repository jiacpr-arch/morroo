# Full System Blueprint — Online Exam Platform

สร้างเว็บข้อสอบออนไลน์ที่เหมือน morroo.com แค่เปลี่ยนเนื้อหาวิชาที่สอบ

## Quick Start — สิ่งที่ต้องเปลี่ยนเมื่อ Clone ไปเว็บใหม่

| สิ่งที่เปลี่ยน | ตัวอย่าง MorRoo → NurseRoo |
|---|---|
| ชื่อเว็บ / Branding | MorRoo → NurseRoo |
| วิชาที่สอบ (SUBJECTS) | อายุรศาสตร์, ศัลยศาสตร์ → การพยาบาลผู้ใหญ่, สูติศาสตร์ |
| Prompt สร้างข้อสอบ | "แพทย์ผู้เชี่ยวชาญ" → "อาจารย์พยาบาล" |
| แพ็กเกจ/ราคา | ฿199/1,490/299 → ปรับตามต้องการ |
| LINE OA | @508srmcr → สร้าง OA ใหม่ |
| Domain | morroo.com → nurseroo.com |
| Supabase project | สร้างใหม่ |
| Stripe account | ใช้เดิมหรือสร้างใหม่ |
| FlowAccount | ใช้เดิมหรือสร้างใหม่ |

---

## Tech Stack

- **Framework:** Next.js 16 (App Router, Turbopack)
- **Database:** Supabase (PostgreSQL + Auth + RLS)
- **Auth:** Google OAuth (via Supabase) + LINE Login (custom)
- **Payment:** Stripe Checkout + FlowAccount (ใบกำกับภาษี)
- **AI:** Claude API (Haiku/Sonnet/Opus)
- **Email:** Resend
- **Notifications:** LINE Messaging API
- **Hosting:** Vercel
- **CSS:** Tailwind CSS 4 + shadcn/ui

---

## 1. AUTH SYSTEM

### 1.1 Google Login (via Supabase OAuth)

```
User กด "Login with Google"
  → supabase.auth.signInWithOAuth({ provider: "google" })
  → Google consent screen
  → Redirect to /auth/callback
  → exchangeCodeForSession(code)
  → Upsert profile { id, email, name, role: "user", membership_type: "free" }
  → Check onboarding_done → redirect /onboarding or /profile
```

**Files:**
- `app/login/page.tsx` — Google + LINE + email login buttons
- `app/register/page.tsx` — registration + referral code support
- `app/auth/callback/route.ts` — OAuth callback, profile upsert, onboarding check

**Supabase Config:** Enable Google provider in Supabase Dashboard → Authentication → Providers

### 1.2 LINE Login (Custom OAuth)

```
User กด "Login with LINE"
  → GET /api/auth/line?mode=login
  → Generate CSRF state → store in httpOnly cookie
  → Redirect to LINE authorize URL
  → User consents
  → LINE redirects to /api/auth/line/callback?code=xxx&state=xxx
  → Verify CSRF state
  → Exchange code for access_token (POST api.line.me/oauth2/v2.1/token)
  → Fetch LINE profile (GET api.line.me/v2/profile)
  → Extract email from id_token (optional)
  → Find or create Supabase user:
      1. Match by line_user_id in profiles
      2. Match by email in auth.users
      3. Create new user (placeholder email: line_{userId}@line.domain.com)
  → Generate magic link via supabase.auth.admin.generateLink()
  → Redirect to Supabase verify URL → establishes session
```

**Files:**
- `app/api/auth/line/route.ts` — authorization redirect
- `app/api/auth/line/callback/route.ts` — token exchange, user matching, magic link

**Env Vars:**
```
LINE_LOGIN_CHANNEL_ID=...
LINE_LOGIN_CHANNEL_SECRET=...
```

### 1.3 LINE OA Linking (Post-Login)

```
User กด "เชื่อมต่อ LINE" ในหน้า Profile
  → POST /api/line/generate-code (Bearer token auth)
  → Generate code: MORROO-ABC123 (expires 24h)
  → User copy code → ส่งใน LINE OA chat
  → LINE webhook receives message
  → Verify code in line_link_codes table
  → UPDATE profiles SET line_user_id = ... WHERE id = user_id
  → Delete used code
  → Send confirmation via LINE
```

**Files:**
- `app/api/line/generate-code/route.ts` — generate link code
- `app/api/line/webhook/route.ts` — handle follow + link code messages
- `lib/line.ts` — sendLineMessage(), verifyLineSignature()

**Env Vars:**
```
LINE_CHANNEL_ACCESS_TOKEN=...    # OA access token
LINE_CHANNEL_SECRET=...          # OA channel secret for webhook verification
```

### 1.4 Middleware (Auth Guard + Onboarding)

```typescript
// middleware.ts (Next.js 16 = proxy.ts)
// Skip paths: /login, /register, /onboarding, /auth, /api, /privacy
// If logged in AND onboarding_done = false → redirect /onboarding
// Exclude from matcher: api/billing/webhook, static files
```

### 1.5 Onboarding Flow

```
Step 1: เลือกวิชาที่จะสอบ (target_exam)
Step 2: เป้าหมายรายวัน (daily_goal: 10/20/30)
Step 3: วิชาที่อ่อน (weak_subjects: string[])
→ UPDATE profiles SET onboarding_done = true
→ Redirect /dashboard
```

---

## 2. PAYMENT SYSTEM (Stripe + FlowAccount)

> ดู blueprint เต็ม: `docs/stripe-flowaccount-blueprint.md`

### สรุป 3 เส้นทาง Defense-in-Depth

| # | Path | Trigger |
|---|---|---|
| 1 | **Webhook** | Stripe sends `checkout.session.completed` |
| 2 | **Success page verify** | User lands on `/payment/success` |
| 3 | **Daily cron reconcile** | Vercel Cron 03:00 UTC |

**Key principle:** Idempotent fulfillment keyed on `payment_orders.stripe_session_id`

### Plans Config

```typescript
export const STRIPE_PLANS: Record<string, { amount: number; name: string }> = {
  monthly: { amount: 199, name: "MorRoo รายเดือน" },
  yearly:  { amount: 1490, name: "MorRoo รายปี" },
  bundle:  { amount: 299, name: "MorRoo ชุดข้อสอบ" },
};
```

### Notifications on Purchase

| ใคร | ช่องทาง | เนื้อหา |
|---|---|---|
| Admin | LINE group | 🛒 ออเดอร์ใหม่ |
| Admin | Email | 🛒 ออเดอร์ใหม่ + links |
| Buyer | LINE | ✅ ชำระเงินสำเร็จ |
| Buyer | Email | ใบเสร็จรับเงิน HTML |
| Referrer | LINE | 🎉 เพื่อนสมัครแล้ว +30 วัน |

---

## 3. EXAM SYSTEM

### 3.1 MCQ (ปรนัย) — Daily Auto-Generate

```
Cron ทุกวัน → POST /api/mcq/generate-daily?secret=xxx
  → เลือกวิชาตาม rotation (16 วิชา)
  → Generate 30 ข้อ/วัน:
      Easy (6 ข้อ)   → Claude Haiku (เร็ว ถูก)
      Medium (15 ข้อ) → Claude Haiku
      Hard (9 ข้อ)    → Claude Sonnet (ลึก แม่น)
  → Insert to mcq_questions table
```

**Subjects Config (เปลี่ยนตรงนี้สำหรับเว็บใหม่):**
```typescript
const SUBJECTS_ROTATION = [
  { name: "cardio_med", name_th: "อายุรศาสตร์หัวใจ" },
  { name: "surgery", name_th: "ศัลยศาสตร์" },
  { name: "ped", name_th: "กุมารเวชศาสตร์" },
  // ... 16 วิชา
];
```

**AI Models:**
```typescript
const BATCH_CONFIG = {
  easyMedium: { count: 21, model: "claude-haiku-4-5-20251001", maxTokens: 32000 },
  hard:       { count: 9,  model: "claude-sonnet-4-6-20250514", maxTokens: 24000 },
};
```

**Prompt Pattern:**
```
คุณเป็น [ตำแหน่งผู้เชี่ยวชาญ] สาขา [วิชา]
สร้างข้อสอบ MCQ [จำนวน] ข้อ ระดับ [ง่าย/กลาง/ยาก]
สำหรับสอบ [ชื่อการสอบ]

กฎ:
- 5 ตัวเลือก (A-E)
- ตัวเลือกผิดต้อง plausible
- ตอบเป็น JSON: { scenario, choices, correct_answer, explanation, detailed_explanation }
```

### 3.2 MEQ (Progressive Case) — 2x/Week Auto-Generate

```
Cron จันทร์+พฤหัส → POST /api/exams/generate-weekly?secret=xxx
  → เลือก category ตาม rotation (6 สาขา)
  → Generate 1 เคส 6 ตอน (Claude Sonnet)
  → Insert to exams + exam_parts tables
```

**Prompt Pattern:**
```
สร้างข้อสอบ MEQ แบบ Progressive Case 6 ตอน
สาขา: [category]
ระดับ: [easy/medium/hard]

แต่ละตอน: scenario → question → answer → key_points → time_minutes
ตอน 1: Initial assessment
ตอน 2: Lab interpretation
ตอน 3: Differential diagnosis
ตอน 4: Definitive diagnosis
ตอน 5: Management
ตอน 6: Long-term/Complications
```

### 3.3 Long Case (OSCE-style) — Weekly + Real-time AI

```
Generation (Cron อาทิตย์):
  → Generate patient case (Claude Sonnet)
  → Store: patient_info, history_script, pe_findings, lab_results,
           correct_diagnosis, scoring_rubric

Runtime (User เล่น):
  Phase 1 — History Taking:
    User ↔ AI Patient (Claude Sonnet, streaming)
    AI ตอบเป็นคนไข้ ให้ข้อมูลเฉพาะที่ถูกถาม

  Phase 2 — PE + Lab:
    User เลือก PE findings + สั่ง lab

  Phase 3 — Diagnosis + Management:
    User ส่ง DDx + management plan

  Phase 4 — Examiner Questioning:
    AI Examiner (Claude Sonnet) ถามคำถาม
    User ตอบ → AI ประเมิน

  Phase 5 — Scoring:
    Claude Opus ให้คะแนนตาม rubric
    { history: 25, pe: 20, lab: 15, ddx: 20, management: 20 }
```

**AI Models per Phase:**
| Phase | Model | Purpose |
|---|---|---|
| Generation | Sonnet | สร้างเคส |
| Patient chat | Sonnet (streaming) | จำลองคนไข้ |
| Examiner chat | Sonnet (streaming) | ถามคำถาม |
| Final scoring | **Opus** | ให้คะแนน (ต้องแม่นที่สุด) |

---

## 4. REFERRAL SYSTEM

```
User A กด "สร้างลิงก์เชิญเพื่อน"
  → Generate code: MR-ABC123
  → Share link: https://domain.com/register?ref=MR-ABC123

User B สมัครผ่านลิงก์
  → Apply referral code → referrals table (status: pending)

User B จ่ายเงิน
  → Webhook trigger → check referral
  → Extend User A membership +30 days
  → Update referral status: rewarded
  → LINE notify User A
```

---

## 5. NOTIFICATION CRON JOBS

| Cron | เวลา | ทำอะไร |
|---|---|---|
| MCQ generate | ทุกวัน | สร้าง 30 ข้อสอบ MCQ |
| MEQ generate | จันทร์+พฤหัส | สร้าง 1 เคส MEQ |
| Long Case generate | อาทิตย์ | สร้าง 1 เคส Long Case |
| Expiry warning | ทุกวัน 09:00 ICT | LINE แจ้งเตือนหมดอายุ |
| Weekly summary | อาทิตย์ 10:00 ICT | LINE สรุปผลสัปดาห์ |
| Payment reconcile | ทุกวัน 10:00 ICT | กู้คืน payment ที่ตกหล่น |
| Blog generate | อังคาร+ศุกร์ 02:00 ICT | AI สร้างบทความ + รูปปก + โพสต์ FB |
| Abandoned checkout | ทุกวัน | Scan expired Stripe sessions, LINE แจ้ง |

---

## 6. DATABASE SCHEMA (Supabase)

### Core Tables

```sql
-- profiles (extends Supabase auth.users)
CREATE TABLE profiles (
  id uuid PRIMARY KEY REFERENCES auth.users,
  email text,
  name text,
  role text DEFAULT 'user',           -- user | admin
  membership_type text DEFAULT 'free', -- free | monthly | yearly | bundle
  membership_expires_at timestamptz,
  onboarding_done boolean DEFAULT false,
  daily_goal integer DEFAULT 20,
  target_exam text,                    -- customize per site
  weak_subjects text[],
  line_user_id text,
  line_linked_at timestamptz,
  referral_code text UNIQUE,
  referred_by text,
  created_at timestamptz DEFAULT now()
);

-- payment_orders
CREATE TABLE payment_orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users NOT NULL,
  plan_type text NOT NULL,
  amount numeric NOT NULL,
  status text DEFAULT 'pending',
  payment_method text DEFAULT 'stripe',
  stripe_session_id text,        -- idempotency key
  created_at timestamptz DEFAULT now()
);

-- invoices
CREATE TABLE invoices (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  invoice_number text NOT NULL UNIQUE,
  user_id uuid REFERENCES auth.users NOT NULL,
  order_id uuid REFERENCES payment_orders,
  stripe_session_id text,
  plan_type text NOT NULL,
  amount numeric NOT NULL,
  vat_amount numeric DEFAULT 0,
  total_amount numeric NOT NULL,
  buyer_name text,
  buyer_tax_id text,
  buyer_email text,
  status text DEFAULT 'paid',
  created_at timestamptz DEFAULT now()
);

-- line_link_codes
CREATE TABLE line_link_codes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users NOT NULL,
  code text NOT NULL UNIQUE,
  expires_at timestamptz DEFAULT now() + interval '24 hours',
  created_at timestamptz DEFAULT now()
);

-- referrals
CREATE TABLE referrals (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  referrer_id uuid REFERENCES auth.users NOT NULL,
  referred_id uuid REFERENCES auth.users,
  code text NOT NULL,
  status text DEFAULT 'pending',    -- pending | rewarded
  reward_days int DEFAULT 30,
  rewarded_at timestamptz,
  created_at timestamptz DEFAULT now()
);
```

### Exam Tables

```sql
-- mcq_subjects
CREATE TABLE mcq_subjects (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  name_th text NOT NULL,
  exam_type text,           -- customize: NL1, NL2, NURSE1, etc.
  question_count int DEFAULT 0
);

-- mcq_questions
CREATE TABLE mcq_questions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id uuid REFERENCES mcq_subjects,
  scenario text NOT NULL,
  choices jsonb NOT NULL,     -- [{label, text}, ...]
  correct_answer text NOT NULL,
  explanation text,
  detailed_explanation jsonb,
  difficulty text,            -- easy | medium | hard
  created_at timestamptz DEFAULT now()
);

-- mcq_attempts (user answers)
CREATE TABLE mcq_attempts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users,
  question_id uuid REFERENCES mcq_questions,
  selected_answer text,
  is_correct boolean,
  time_spent_seconds int,
  created_at timestamptz DEFAULT now()
);

-- exams (MEQ)
CREATE TABLE exams (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text,
  category text,
  difficulty text,
  status text DEFAULT 'published',
  is_free boolean DEFAULT false,
  publish_date date,
  created_at timestamptz DEFAULT now()
);

-- exam_parts (MEQ parts)
CREATE TABLE exam_parts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  exam_id uuid REFERENCES exams,
  part_number int,
  scenario text,
  question text,
  answer text,
  key_points text[],
  time_minutes int DEFAULT 10
);

-- long_cases
CREATE TABLE long_cases (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text,
  specialty text,
  difficulty text,
  patient_info jsonb,
  history_script jsonb,
  pe_findings jsonb,
  lab_results jsonb,
  correct_diagnosis text,
  accepted_ddx jsonb,
  management_plan text,
  scoring_rubric jsonb,
  created_at timestamptz DEFAULT now()
);
```

---

## 7. AUTO BLOG + FACEBOOK AUTO-POST

### 7.1 AI Blog Generator (Cron 2x/week)

```
Cron อังคาร + ศุกร์ 02:00 ICT (19:00 UTC วันก่อน)
POST /api/blog/generate?secret=$BLOG_GENERATE_SECRET

Flow:
1. Fetch existing titles (avoid duplicates)
2. Claude Sonnet picks topic + writes article as JSON
   { title, slug, description, image_prompt, content (HTML) }
3. Together AI FLUX.1-schnell-Free generates cover image (1200×630)
4. Upload image to Supabase Storage (public-assets/blog-covers/)
5. Save to blog_posts table
6. after() → postToFacebook()
```

**Files:**
- `app/api/blog/generate/route.ts` — Full auto blog pipeline
- `lib/blog.ts` — getBlogPosts(), getBlogPost(), getAllSlugs()
- `lib/facebook.ts` — postToFacebook() with auto-refresh token

**AI Prompt Pattern:**
```
คุณเป็น [ผู้เชี่ยวชาญ] สำหรับเว็บ [ชื่อเว็บ]
หมวดหมู่: [random category]
บทความที่เขียนไปแล้ว (ห้ามซ้ำ): [list]
สร้างบทความ 1 บทความ ตอบเป็น JSON
{ title, slug, description, image_prompt, content (HTML 600-900 คำ) }
```

### 7.2 Facebook Auto-Post (with Token Auto-Refresh)

```
postToFacebook() flow:
1. Get latest User Token (Supabase app_settings → fallback env var)
2. Exchange for fresh long-lived token (60 days)
3. Save refreshed token to Supabase (auto-refresh cycle)
4. Get Page Token from User Token
5. POST to /{PAGE_ID}/photos (with cover) or /feed (link only)
```

**Token never expires** — as long as cron runs once every 60 days (runs 2x/week)

**Database:**
```sql
CREATE TABLE app_settings (
  key text PRIMARY KEY,
  value text NOT NULL,
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE blog_posts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  slug text UNIQUE NOT NULL,
  title text NOT NULL,
  description text,
  category text,
  reading_time int DEFAULT 3,
  content text NOT NULL,
  cover_image text,
  published_at timestamptz DEFAULT now()
);
```

### 7.3 Revenue Dashboard (Admin)

```
/admin/revenue — Revenue dashboard with:
- Total revenue, orders, new members (by period 7d/30d/90d)
- Daily bar chart
- Plan breakdown (monthly/yearly/bundle)
- Admin-only access (profile.role = 'admin')
```

**File:** `app/admin/revenue/page.tsx`

---

## 8. ENVIRONMENT VARIABLES

```bash
# === Supabase ===
NEXT_PUBLIC_SUPABASE_URL=https://xxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_ROLE_KEY=eyJ...

# === Auth ===
LINE_LOGIN_CHANNEL_ID=...
LINE_LOGIN_CHANNEL_SECRET=...
# Google OAuth ตั้งใน Supabase Dashboard

# === LINE OA ===
LINE_CHANNEL_ACCESS_TOKEN=...
LINE_CHANNEL_SECRET=...
LINE_CHANNEL_TOKEN=...        # admin group push
LINE_TARGET_ID=...             # admin group ID

# === Stripe ===
STRIPE_SECRET_KEY=sk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...

# === FlowAccount ===
FLOWACCOUNT_TOKEN_URL=...
FLOWACCOUNT_BASE_URL=...
FLOWACCOUNT_CLIENT_ID=...
FLOWACCOUNT_CLIENT_SECRET=...

# === Email (Resend) ===
RESEND_API_KEY=re_...
MAIL_FROM=noreply@yourdomain.com
ADMIN_EMAIL=admin@yourdomain.com

# === AI ===
ANTHROPIC_API_KEY=sk-ant-...

# === Image Generation ===
TOGETHER_API_KEY=...             # Together AI for blog cover images

# === Facebook Auto-Post ===
FACEBOOK_PAGE_ID=...             # Facebook Page numeric ID
FACEBOOK_APP_ID=...              # Facebook App ID
FACEBOOK_APP_SECRET=...          # Facebook App Secret
FACEBOOK_USER_TOKEN=...          # Long-lived User Token (auto-refreshes)

# === Cron ===
BLOG_GENERATE_SECRET=...
CRON_SECRET=...

# === Site ===
NEXT_PUBLIC_SITE_URL=https://yourdomain.com
```

---

## 8. FILE STRUCTURE

```
app/
├── api/
│   ├── auth/line/              # LINE Login OAuth
│   │   ├── route.ts            # Authorization redirect
│   │   └── callback/route.ts   # Token exchange + user matching
│   ├── billing/
│   │   ├── checkout/route.ts   # Create Stripe session
│   │   ├── webhook/route.ts    # Stripe webhook (lazy Stripe init)
│   │   ├── verify/route.ts     # Success page fallback
│   │   └── reconcile/route.ts  # Daily cron safety net
│   ├── ai/
│   │   ├── mcq-chat/route.ts   # MCQ explanation chat
│   │   ├── longcase-patient/   # AI patient simulation
│   │   └── longcase-examiner/  # AI examiner + scoring
│   ├── mcq/
│   │   └── generate-daily/     # Daily MCQ auto-generation
│   ├── exams/
│   │   └── generate-weekly/    # MEQ auto-generation
│   ├── longcase/
│   │   ├── generate-weekly/    # Long case auto-generation
│   │   ├── start/route.ts      # Start a session
│   │   └── session/route.ts    # Session management
│   ├── line/
│   │   ├── webhook/route.ts    # LINE OA webhook
│   │   ├── generate-code/      # Link code generation
│   │   ├── expiry-warning/     # Membership expiry LINE push
│   │   └── weekly-summary/     # Weekly stats LINE push
│   ├── blog/
│   │   └── generate/route.ts   # AI blog + Together AI images + FB post
│   └── referral/
│       ├── generate/route.ts   # Generate referral code
│       └── apply/route.ts      # Apply referral code
├── auth/callback/route.ts      # Google OAuth callback
├── login/page.tsx
├── register/page.tsx
├── onboarding/page.tsx
├── payment/
│   ├── [plan]/page.tsx         # Plan selection
│   └── success/                # Post-payment verify
├── admin/
│   ├── users/page.tsx          # User/membership management
│   ├── payments/page.tsx       # Payment orders
│   ├── revenue/page.tsx        # Revenue dashboard (bar chart + plan breakdown)
│   └── mcq/                    # Question management
└── profile/page.tsx            # Profile + LINE linking

lib/
├── billing/
│   ├── fulfill-checkout.ts     # Idempotent fulfillment helper
│   └── send-fulfillment-notifications.ts
├── supabase/
│   ├── server.ts               # Server client (cookies)
│   ├── client.ts               # Browser client
│   ├── admin.ts                # Service role client
│   └── middleware.ts           # Session refresh + onboarding guard
├── stripe.ts                   # Stripe client (Proxy pattern)
├── line.ts                     # LINE messaging + signature verify
├── flowaccount.ts              # FlowAccount API
├── notifications.ts            # LINE admin + email admin + email receipt
├── facebook.ts                 # Facebook auto-post + token auto-refresh
├── blog.ts                     # Blog queries (getBlogPosts, getBlogPost)
└── types.ts                    # Profile, Exam types

middleware.ts                   # Auth guard (Next.js 16 → proxy.ts)
vercel.json                     # Cron schedule
```

---

## 9. HOW TO USE THIS BLUEPRINT

เวลาจะสร้างเว็บใหม่ ส่ง context ให้ Claude แบบนี้:

```
ใช้ blueprint จาก:
https://github.com/jiacpr-arch/morroo/blob/main/docs/full-system-blueprint.md

สร้างเว็บข้อสอบใหม่ชื่อ [NurseRoo]:
- วิชาที่สอบ: [การพยาบาลผู้ใหญ่, สูติศาสตร์, กุมาร, จิตเวช, ชุมชน, ...]
- การสอบ: [สภาการพยาบาล ขั้น 1, ขั้น 2]
- AI prompt role: "อาจารย์พยาบาลผู้เชี่ยวชาญ"
- แพ็กเกจ: [รายเดือน ฿149, รายปี ฿990]
- LINE OA: [@nurseroo]
- Domain: [nurseroo.com]
- ใช้ Supabase + Stripe + FlowAccount + LINE เหมือนเดิม
```

Claude จะอ่าน blueprint แล้ว adapt ทุกไฟล์ให้ตาม config ที่ระบุ
