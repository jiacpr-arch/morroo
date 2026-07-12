# การย้ายระบบ jia-online (คอร์ส CPR/AED) เข้า morroo.com/cpr

สถานะ: **Phase 1 — lift-and-shift หน้าเรียนทั้งหมด** (จากแผน 5 เฟส)

ต้นทาง: repo `jia-online` ที่ `files/jia-online/` (React 18 + Vite SPA ไฟล์เดียว `src/App.jsx` ~3,800 บรรทัด)
ปลายทาง: โซน `/cpr` ในเว็บนี้ — แบรนด์ JIA TRAINER CENTER แยกจาก chrome ของ morroo

## โครงสร้างที่ย้ายมา (Phase 1)

- `lib/cpr/config.ts` — ค่าคงที่ทั้งหมด (palette, PRICING, COURSE, TEASER_QUIZ, โค้ดโปรโม, CERT_DECO)
  คีย์/URL อ่านจาก env แทนการ hardcode
- `lib/cpr/storage.ts` — localStorage helpers (คีย์ prefix `jia_*` **คงเดิมทุกตัว** เพื่อความต่อเนื่องของ
  ข้อมูลผู้เรียนตอน cutover จาก cpr.morroo.com)
- `lib/cpr/analytics.ts` — fbTrack/safeTrack (**ใช้ Meta Pixel ที่ root layout init แล้ว — ห้าม init ซ้ำ**),
  PostHog โปรเจกต์ JIA (A/B flag `gate_placement`)
- `lib/cpr/api.ts` — Supabase REST โปรเจกต์ CPR (`tpoiyykbgsgnrdwzgzvn`), LIFF, edge functions,
  ตัวสร้างโค้ด LEAD-/VCH-/JIA-
- `lib/cpr/cert.ts` — export ใบประกาศ PNG/PDF (html-to-image + jspdf)
- `lib/cpr/supabase-server.ts` — service-role client (ใช้ Phase 2/3)
- `components/cpr/*` — หน้า learner ทั้งหมด (Landing, Store, TeaserQuiz, SignupGate, Register,
  LineAddPrompt, Claim, Payment, Course, Certificate, MiniCert, Booking, Blog, News, InAppNotice)
- `components/cpr/CprApp.tsx` — แทน `switch(page)` เดิมด้วย URL จริง + จัดการ deep links
- `app/cpr/[[...page]]/page.tsx` + `app/cpr/layout.tsx` + `app/cpr/cpr.css`
- `components/HideOnCprChrome.tsx` — ซ่อน Navbar/Footer/ป๊อปอัพ morroo บน `/cpr`

## แผนที่ URL

| หน้าเดิม (page state) | URL ใหม่ |
|---|---|
| landing | `/cpr` (มี resume redirect ตาม `jia_last_page`) |
| store / teaserquiz / signupgate | `/cpr/store` `/cpr/quiz` `/cpr/signup` |
| register / lineprompt / claim | `/cpr/register` `/cpr/line-add` `/cpr/claim?code=` |
| payment / course | `/cpr/payment` `/cpr/course` (รับ `?stripe=success&modules=`) |
| certificate / minicert / booking | `/cpr/certificate` `/cpr/minicert` `/cpr/booking` |
| blog / blog-detail | `/cpr/blog` `/cpr/blog/[slug]` |
| `?promo=CODE` | redirect → `/cpr/claim?code=CODE` |
| `?admin=1` | redirect ไป cpr.morroo.com เดิม (Admin ย้ายใน Phase 4 → `/admin/cpr`) |

## Env vars ที่ต้องตั้ง (Vercel + .env.local)

```
NEXT_PUBLIC_CPR_SUPABASE_URL=https://tpoiyykbgsgnrdwzgzvn.supabase.co
NEXT_PUBLIC_CPR_SUPABASE_ANON_KEY=sb_publishable_...   # publishable key ของโปรเจกต์ CPR
CPR_SUPABASE_SERVICE_ROLE_KEY=...                      # server-only (ใช้ Phase 2/3)
CPR_ADMIN_API_KEY=...                                  # server-only (ใช้ Phase 4)
NEXT_PUBLIC_CPR_LIFF_ID=2010458255-JAxIKawy
NEXT_PUBLIC_CPR_POSTHOG_KEY=phc_...                    # PostHog โปรเจกต์ JIA
NEXT_PUBLIC_CPR_POSTHOG_HOST=https://us.i.posthog.com
```

หมายเหตุ: โค้ดมี fallback เป็นค่า public เดิม (URL + LIFF ID) เพื่อให้ build ผ่านโดยไม่มี env
แต่ **anon key ไม่มี fallback** — ต้องตั้ง `NEXT_PUBLIC_CPR_SUPABASE_ANON_KEY` ก่อนใช้งานจริง

## งานที่เหลือ (เฟสถัดไป — ดูแผนเต็มใน PR)

- **Phase 0 (คงค้าง, ต้องทำมือ):**
  - 🔴 rotate service_role key ของโปรเจกต์หลัก morroo ที่หลุดใน `seed-batch1.js` (ลบออกจากโค้ดแล้ว
    แต่ key เดิมอยู่ใน git history — ต้อง rotate ใน Supabase dashboard)
  - ดึงซอร์ส edge functions `stripe-checkout` และ `online-course-broadcast` จากโปรเจกต์ CPR
    มาเก็บใน version control
  - ตั้ง `ADMIN_API_KEY` ใหม่บนโปรเจกต์ CPR และลบ `LEGACY_ADMIN_KEY` ออกจาก `admin-api/index.ts`
  - อัปเดต success/cancel URL ที่อนุญาตใน `stripe-checkout` (ถ้ามี validation) ให้รองรับ
    `https://www.morroo.com/cpr/course`
- **Phase 2:** Landing/Blog เป็น server-rendered + แปลง style เป็น Tailwind/shadcn ทีละหน้า
- **Phase 3:** ย้าย write ทั้งหมดผ่าน `/api/cpr/*` แล้วค่อย revoke anon RLS (หลัง cutover เท่านั้น)
- **Phase 4:** Admin CRM → `/admin/cpr` ใช้ `requireAdmin()` ของ morroo
- **Phase 5:** cutover `cpr.morroo.com` → หน้า handoff โอน localStorage ข้าม origin
  (`/cpr/migrate#state=...`) + redirect ถาวร + **อัปเดต LIFF endpoint URL ใน LINE Developers console**
