# New Repo Blueprint — สร้างเว็บใหม่จากระบบ MorRoo

คู่มือ step-by-step สำหรับ clone โครงระบบ MorRoo ไปทำเว็บใหม่ในแนวเดียวกัน
(เว็บข้อสอบ / คอร์สเรียน / ชุมชนเฉพาะ niche ที่มี subscription + AI + LINE)

> ใช้คู่กับ `docs/full-system-blueprint.md` (สถาปัตยกรรมระบบเต็ม)
> และ `docs/stripe-flowaccount-blueprint.md` (ระบบจ่ายเงิน 3 เส้นทาง)

---

## 0. ตัดสินใจก่อนเริ่ม

ตอบคำถาม 7 ข้อนี้ก่อน เก็บคำตอบไว้ในไฟล์ `BRAND.md` (อย่า commit secrets):

| # | คำถาม | ตัวอย่าง |
|---|---|---|
| 1 | ชื่อเว็บ + slogan | NurseRoo — ติวสภาการพยาบาลด้วย AI |
| 2 | Domain | nurseroo.com |
| 3 | กลุ่มเป้าหมาย | นักศึกษาพยาบาลปี 4 |
| 4 | การสอบ/หมวดเนื้อหา | สภาการพยาบาล ขั้น 1, 2 |
| 5 | วิชา / categories (10–20 รายการ) | การพยาบาลผู้ใหญ่, สูติฯ, กุมารฯ, จิตเวช, ชุมชน |
| 6 | แพ็กเกจ + ราคา | รายเดือน ฿149, รายปี ฿990 |
| 7 | AI persona | "อาจารย์พยาบาลผู้เชี่ยวชาญ 20 ปี" |

ถ้าตอบครบแล้ว ทุกอย่างที่เหลือเป็น mechanical replacement

---

## 1. Bootstrap Repo (15 นาที)

```bash
# 1. Clone โครงระบบ
git clone https://github.com/jiacpr-arch/morroo.git nurseroo
cd nurseroo
rm -rf .git
git init
git remote add origin git@github.com:YOUR_ORG/nurseroo.git

# 2. Rename package
# package.json → "name": "nurseroo"

# 3. ลบ data ของเดิมที่ไม่ใช้
rm -f seed-batch1.js seed-batch2.js seed-parts.js
rm -rf scripts/mcq-output* scripts/opus-generated scripts/detailed-explanations
rm -rf scripts/all_questions.json
rm -rf jiaraksa-sales-portal   # โปรเจ็กต์ฝัง — ลบถ้าไม่ใช้

# 4. ติดตั้ง deps
npm install

# 5. Sanity check
npm run lint
npm test
```

**สิ่งที่ห้ามลบ** (โครงระบบ): `app/api/`, `lib/`, `components/ui/`, `middleware.ts`,
`vercel.json`, `next.config.ts`, `supabase/migrations/`

---

## 2. ตั้งค่า External Services (1–2 ชั่วโมง)

ทำขนานกันได้ 4 อย่าง (เปิด tab ละบริการ):

### 2.1 Supabase (โปรเจ็กต์ใหม่)

1. Dashboard → New project → เลือก region `Southeast Asia (Singapore)`
2. **Authentication → Providers → Google:** เปิด, ใส่ OAuth client (สร้างจาก Google Cloud Console)
3. **Database → Migrations:** รัน `supabase db push` หรือ apply ทีละไฟล์ใน `supabase/migrations/`
4. รัน `supabase/seed.sql` (โครงตาราง core) แล้ว `mcq_schema.sql`, `longcase_schema.sql` ฯลฯ ตามต้องการ
5. **Storage → Create bucket:** `public-assets` (public), `user-uploads` (authenticated)
6. เก็บ `URL`, `anon key`, `service_role key`

### 2.2 Stripe + FlowAccount

1. Stripe Dashboard → Developers → API keys → เก็บ `sk_live_...`
2. Webhooks → Add endpoint → `https://YOUR_DOMAIN/api/billing/webhook`
   - Events: `checkout.session.completed`, `checkout.session.async_payment_succeeded`
   - เก็บ `whsec_...`
3. FlowAccount → Apps → Create OAuth app → เก็บ `client_id`, `client_secret`
4. (ทางเลือก) ใช้ Stripe + FlowAccount เดิมของ MorRoo ได้ — แค่เพิ่ม metadata `site=nurseroo`

### 2.3 LINE

1. LINE Developers Console → New provider (ถ้ายังไม่มี)
2. **Channel ที่ 1 — LINE Login:**
   - Channel type: LINE Login
   - Callback URL: `https://YOUR_DOMAIN/api/auth/line/callback`
   - เก็บ `Channel ID`, `Channel Secret`
3. **Channel ที่ 2 — Messaging API (LINE OA):**
   - สร้าง OA `@nurseroo`
   - Webhook URL: `https://YOUR_DOMAIN/api/line/webhook`
   - เปิด "Use webhook", ปิด "Auto-reply messages"
   - เก็บ `Channel access token (long-lived)`, `Channel secret`
4. **(ทางเลือก) LIFF:** Add LIFF app → endpoint `https://YOUR_DOMAIN/line/liff` → เก็บ `LIFF ID`
5. สร้าง LINE group ของแอดมิน → ดึง `groupId` ผ่าน webhook log

### 2.4 อื่นๆ

- **Resend:** API key → verify domain → `noreply@yourdomain.com`
- **Anthropic:** API key (`sk-ant-...`)
- **Together AI:** API key (สำหรับรูปปก blog) — ถ้าไม่ทำ blog ข้ามได้
- **Facebook Page + App:** สำหรับ auto-post — ถ้าไม่ทำ blog ข้ามได้
- **Sentry:** Project ใหม่ → DSN

---

## 3. Mechanical Replacement (1 ชั่วโมง)

ใช้ `grep -r` หาแล้วแทน คำที่ติด brand:

```bash
# ค้นหา hardcode ของเดิม
grep -rn "MorRoo\|morroo\|@508srmcr\|morroo.com" \
  --exclude-dir=node_modules --exclude-dir=.next \
  app components lib middleware.ts
```

แล้วแทนตามตาราง:

| ของเดิม | ของใหม่ | ที่อยู่ |
|---|---|---|
| `MorRoo` / `morroo` | `NurseRoo` / `nurseroo` | ทั่วไป |
| `morroo.com` | `nurseroo.com` | metadata, SEO, sitemap |
| LINE OA `@508srmcr` | `@nurseroo` | login page, footer, profile |
| `อายุรศาสตร์/ศัลยศาสตร์/...` | `การพยาบาลผู้ใหญ่/สูติฯ/...` | `lib/types-mcq.ts`, prompts |
| "แพทย์ผู้เชี่ยวชาญ" ใน prompt | "อาจารย์พยาบาล" | `app/api/mcq/generate-daily/`, `app/api/exams/generate-weekly/` |
| `STRIPE_PLANS` | ปรับ `amount` + `name` | `lib/stripe.ts` |

**ไฟล์ critical ที่ต้องแก้ด้วยมือ:**

- `app/layout.tsx` — `<title>`, OG image, lang
- `app/opengraph-image.tsx` — รูป OG
- `app/page.tsx` — Hero copy
- `app/lp/` — Landing page sections
- `lib/types-mcq.ts` — `SUBJECTS_ROTATION`
- `lib/stripe.ts` — `STRIPE_PLANS`
- `components/Navbar.tsx` / `Footer.tsx` — โลโก้ + ลิงก์ social
- `next-sitemap.config.js` — `siteUrl`
- `app/robots.ts` — `host`

---

## 4. Environment Variables

สร้าง `.env.local` (dev) + ใส่ทั้งหมดใน Vercel Project Settings:

```bash
# Site
NEXT_PUBLIC_SITE_URL=https://nurseroo.com

# Supabase
NEXT_PUBLIC_SUPABASE_URL=...
NEXT_PUBLIC_SUPABASE_ANON_KEY=...
SUPABASE_SERVICE_ROLE_KEY=...

# Auth
LINE_LOGIN_CHANNEL_ID=...
LINE_LOGIN_CHANNEL_SECRET=...
NEXT_PUBLIC_LIFF_ID=...

# LINE OA
LINE_CHANNEL_ACCESS_TOKEN=...
LINE_CHANNEL_SECRET=...
LINE_CHANNEL_TOKEN=...        # admin group push
LINE_TARGET_ID=...            # admin group ID

# Stripe
STRIPE_SECRET_KEY=sk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...

# FlowAccount
FLOWACCOUNT_TOKEN_URL=...
FLOWACCOUNT_BASE_URL=...
FLOWACCOUNT_CLIENT_ID=...
FLOWACCOUNT_CLIENT_SECRET=...

# Email
RESEND_API_KEY=re_...
MAIL_FROM=noreply@nurseroo.com
ADMIN_EMAIL=admin@nurseroo.com

# AI
ANTHROPIC_API_KEY=sk-ant-...
TOGETHER_API_KEY=...          # blog covers (optional)

# Facebook (optional)
FACEBOOK_PAGE_ID=...
FACEBOOK_APP_ID=...
FACEBOOK_APP_SECRET=...
FACEBOOK_USER_TOKEN=...

# Cron
CRON_SECRET=$(openssl rand -hex 32)
BLOG_GENERATE_SECRET=$(openssl rand -hex 32)
```

---

## 5. Deploy (30 นาที)

```bash
# 1. Push to GitHub
git add .
git commit -m "Initial bootstrap from morroo blueprint"
git push -u origin main

# 2. Import to Vercel
#    - Framework preset: Next.js
#    - Build command: (default — npm run build)
#    - Env vars: paste จากข้อ 4
#    - Domain: nurseroo.com (+ DNS A/CNAME ตามที่ Vercel แสดง)

# 3. หลัง deploy แรก:
#    - ทดสอบ Google login
#    - ทดสอบ LINE login
#    - ทดสอบ Stripe test mode (เปลี่ยน key เป็น sk_test ก่อน)
#    - ทดสอบ Supabase webhook (ส่ง message ใน LINE OA)
```

`vercel.json` (cron) — ทำงานอัตโนมัติทันทีหลัง deploy ไม่ต้องตั้งเพิ่ม

---

## 6. Smoke Test Checklist (ก่อนเปิดให้ user จริง)

- [ ] Sign up Google → onboarding → profile
- [ ] Sign up LINE login → profile
- [ ] Link LINE OA → ส่ง code → profile.line_user_id update
- [ ] ซื้อแพ็กเกจ test (Stripe test card `4242 4242 4242 4242`)
  - [ ] Webhook ยิงเข้า → `payment_orders.status = paid`
  - [ ] Invoice สร้างใน FlowAccount
  - [ ] LINE buyer + admin group ได้ notification
  - [ ] Email ใบเสร็จส่งถึง buyer
- [ ] Cron MCQ generate (ยิงด้วยมือ: `curl -X POST $URL/api/mcq/generate-daily -H "Authorization: Bearer $CRON_SECRET"`)
- [ ] เล่น MCQ → คะแนนบันทึกใน `mcq_attempts`
- [ ] ลืม password → magic link → login ได้
- [ ] Admin เข้า `/admin/revenue` (ตั้ง `profile.role = 'admin'` มือ)

---

## 7. ตัวอย่าง Concrete: NurseRoo

ตัวอย่างคำตอบข้อ 0 ครบสำหรับ niche "ติวสภาการพยาบาล":

```yaml
brand:
  name: NurseRoo
  slogan: ติวสภาการพยาบาลด้วย AI 24 ชั่วโมง
  domain: nurseroo.com
  audience: นักศึกษาพยาบาลปี 4 + พยาบาลที่ต้องสอบใบประกอบ
  exam_types: [TNC1, TNC2]   # สภาการพยาบาล ขั้น 1, 2

subjects:
  - { name: adult_nursing,        name_th: การพยาบาลผู้ใหญ่ }
  - { name: maternity_nursing,    name_th: การพยาบาลสูติศาสตร์ }
  - { name: pediatric_nursing,    name_th: การพยาบาลเด็ก }
  - { name: psychiatric_nursing,  name_th: การพยาบาลจิตเวช }
  - { name: community_nursing,    name_th: การพยาบาลชุมชน }
  - { name: geriatric_nursing,    name_th: การพยาบาลผู้สูงอายุ }
  - { name: nursing_management,   name_th: การบริหารการพยาบาล }
  - { name: nursing_research,     name_th: การวิจัยทางการพยาบาล }
  - { name: nursing_ethics,       name_th: จริยธรรมและกฎหมายวิชาชีพ }
  - { name: pharmacology,         name_th: เภสัชวิทยาทางการพยาบาล }

plans:
  monthly: { amount: 149,  name: "NurseRoo รายเดือน" }
  yearly:  { amount: 990,  name: "NurseRoo รายปี (ประหยัด 45%)" }
  bundle:  { amount: 199,  name: "NurseRoo ชุดข้อสอบ TNC1" }

ai_persona: |
  คุณเป็นอาจารย์พยาบาลผู้เชี่ยวชาญ ประสบการณ์ 20 ปี
  สอนเตรียมสอบสภาการพยาบาล (TNC) มาแล้วกว่า 5,000 คน
  ออกข้อสอบตามแนว blueprint ของสภาการพยาบาล

line_oa: "@nurseroo"
admin_line_group: "NurseRoo Admin"
```

ใส่ค่าพวกนี้ลง:

| ค่า | ไฟล์ |
|---|---|
| `subjects` | `lib/types-mcq.ts` → `SUBJECTS_ROTATION` |
| `plans` | `lib/stripe.ts` → `STRIPE_PLANS` |
| `ai_persona` | `app/api/mcq/generate-daily/route.ts`, `app/api/exams/generate-weekly/route.ts`, `app/api/longcase/generate-weekly/route.ts` (system prompt) |
| `brand.*` | `app/layout.tsx` metadata, `components/Navbar.tsx`, `components/Footer.tsx`, `app/page.tsx`, `app/lp/` |

---

## 8. ส่ง Context ให้ Claude ช่วย adapt

เมื่อ blueprint นี้อยู่บน GitHub แล้ว ส่ง prompt นี้ให้ Claude Code ใน repo ใหม่:

```
อ่าน blueprint สองไฟล์นี้:
- docs/new-repo-blueprint.md  (ขั้นตอน + checklist)
- docs/full-system-blueprint.md  (สถาปัตยกรรม)

ทำ section 3 (Mechanical Replacement) + section 7 (NurseRoo config) ทั้งหมด
ให้ฉัน — ใช้ค่าจาก BRAND.md ที่ฉันเขียนไว้

อย่าแตะไฟล์ใน lib/billing/, lib/supabase/, lib/stripe.ts (โครง)
อย่าลบ migration ใน supabase/migrations/
รายงานเป็น diff สั้นๆ ก่อนแก้จริง
```

Claude จะวิ่งทำให้ครบ ทั้ง rename, prompt, plans, subjects ในรอบเดียว

---

## 9. หลังเปิดเว็บแล้ว — Iteration Loop

| สัปดาห์ | งาน |
|---|---|
| 1 | Monitor Sentry + Supabase logs + LINE webhook errors |
| 2 | ดูข้อสอบ AI ที่ generate ว่ามี hallucination ไหม → ปรับ prompt |
| 3 | ดู conversion landing page → ปรับ copy `app/lp/` |
| 4 | เริ่มทำ blog auto-post (ถ้ายังไม่เปิด) |
| 8 | Refresh Facebook long-lived token (ถ้า cron ไม่ได้รันต่อเนื่อง) |

---

## Summary

ใช้เวลาทั้งหมด **~1 วัน** ต่อ 1 niche (ถ้าทุก service พร้อม)

```
0. ตอบ 7 คำถาม          →  30 นาที
1. Bootstrap repo        →  15 นาที
2. ตั้ง external services →  90 นาที (ขนาน)
3. Mechanical replace    →  60 นาที (ส่วนใหญ่ Claude ทำได้)
4. Env vars              →  20 นาที
5. Deploy                →  30 นาที
6. Smoke test            →  60 นาที
                            ────────
                            ~5 ชั่วโมงทำงานจริง
```
