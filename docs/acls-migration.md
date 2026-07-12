# การย้ายระบบการเรียนการสอน ACLS/BLS จาก acls-emr เข้า morroo

สถานะ: **ย้ายครบทุก phase แล้ว** (branch `claude/acls-morroo-migration-rby1wh`, PR #341)
ระบบเดิม (acls.morroo.com / bls.morroo.com) ยังเปิดคู่กันไปก่อนตามแผน — ดู "หลังจากนี้" ด้านล่าง

## ภาพรวม

ย้าย "ส่วนการเรียนการสอนทั้งหมด" ของแอป acls-emr (acls.morroo.com / bls.morroo.com — Vite + React PWA)
เข้ามาเป็นส่วนหนึ่งของ morroo (Next.js App Router) ภายใต้เส้นทาง `/acls/**` และ `/bls/**`
ส่วน EMR/เครื่องบันทึก code จริงยังอยู่ที่แอปเดิม

การตัดสินใจหลัก:

1. **ฐานข้อมูล**: ย้ายตาราง + RPC + storage + ข้อมูลเดิมทั้งหมดจากโปรเจกต์ Supabase เดิม
   (`emr-ai-clinic` / `elyyijlcjfvhxbpzscnv`) เข้าโปรเจกต์หลักของ morroo
2. **นักเรียน**: คงระบบรหัสห้องเรียน (class code + ชื่อ/เบอร์) ไม่บังคับสมัครสมาชิก morroo
3. **ขอบเขต**: ACLS + BLS, pre/post-test, certificate, cohort/instructor, video lessons,
   ALS knowledge, Q&A Deep, AI ตอบคำถามนักเรียน, admin ทั้งหมด, ข่าว + web push
4. **แอปเดิมเปิดคู่กันไปก่อน** — สคริปต์ copy ข้อมูลรันซ้ำได้ (delta sync) จนกว่าจะปิดแอปเดิม

## โครงสร้างใหม่ใน morroo

| ของเดิม (acls-emr) | ใหม่ (morroo) |
|---|---|
| `src/config/courseMode.js` (VITE_COURSE_MODE) | `lib/courses/config.ts` (mode จาก route segment) |
| `src/config/vouchers.js` | `lib/courses/vouchers.ts` |
| `src/db/database.js` + `src/services/syncEngine.js` | `lib/courses/offline/{db,sync-engine}.ts` (Dexie DB ชื่อ `MORROO_COURSES`) |
| `src/services/cohortSync.js` | `lib/courses/cohort.ts` |
| `src/stores/{preCourseStore,classStore,voucherStore}.js` | `lib/courses/stores/*.ts` |
| หน้า teaching ทั้งหมด | `app/acls/**`, `app/bls/**` |
| `api/**` (Vercel functions) | `app/api/acls/**`, `app/api/admin/acls/**`, `app/api/cron/acls-news` |
| หน้า admin | `app/admin/acls/**` (ใช้ `requireAdmin()` ของ morroo แทน shared account) |
| ตาราง `news`, `certificates`, `push_subscriptions` | เปลี่ยนชื่อเป็น `acls_news`, `acls_certificates`, `acls_push_subscriptions` |
| RPC `get_admin_stats`, `get_student_roster` | `get_acls_admin_stats`, `get_acls_student_roster` |
| ตาราง `cohort_*`, `acls_*`, `video_lessons` | ชื่อเดิม |

`app/acls-reader/**` เดิมของ morroo (reader ที่ต่อ DB เก่า) ถูกย้าย/ต่อยอดเป็น `app/acls/**`
และชี้เข้า DB หลักของ morroo แทน (มี redirect จาก `/acls-reader/*`)

## Env vars ใหม่

- `DEEPSEEK_API_KEY`, `OPENAI_API_KEY` — pipeline AI ตอบคำถามนักเรียน (คำตอบ + infographic)
- `NEXT_PUBLIC_VAPID_PUBLIC_KEY`, `VAPID_PRIVATE_KEY`, `VAPID_SUBJECT` — **ต้องใช้คู่ key เดิม
  จากแอป acls-emr** ไม่งั้น push subscription ที่ copy มาจะใช้ไม่ได้
- LINE notify (แจ้งเตือน cert/คำถามใหม่): ใช้ env LINE เดิมของ morroo หรือของแอปเก่าตามที่ตั้งค่า
- เฉพาะตอนรันสคริปต์ copy ข้อมูล (local): `OLD_ACLS_SUPABASE_URL`, `OLD_ACLS_SERVICE_ROLE_KEY`
- หลังย้ายเสร็จ: ลบ `NEXT_PUBLIC_ACLS_SUPABASE_URL` / `NEXT_PUBLIC_ACLS_SUPABASE_ANON_KEY`

## Data copy / delta sync

`scripts/migrate-acls-data.mjs` — copy ข้อมูลจากโปรเจกต์เก่า → ใหม่ แบบ idempotent upsert on PK
(รันซ้ำได้), copy storage bucket `acls-images`, rewrite URL รูปจากโดเมนโปรเจกต์เก่าเป็นโปรเจกต์ใหม่
และปิดท้ายด้วย audit ว่าไม่มี URL เก่าหลงเหลือ + รายงานจำนวน row เทียบสองฝั่ง

ระหว่างที่แอปเดิมยังเปิดอยู่ ให้รันสคริปต์นี้ซ้ำเป็นระยะ (ทางเดียว เก่า→ใหม่ เท่านั้น)
จนกว่าจะกำหนดวันปิดแอปเดิม

## สิ่งที่ย้ายมาแล้ว (ครบทุกฟีเจอร์ตามขอบเขตที่ตกลง)

- **ACLS** (`/acls/**`): pre-course 13 บท, pre-test, post-test, ผลสอบแบบแยกหัวข้อ, ใบประกาศนียบัตร
  PDF (ฟอนต์ Sarabun), ALS knowledge reader, Q&A เชิงลึก (+ฟอร์มถามคำถามใหม่ที่ AI ตอบให้),
  ฝึกอ่าน EKG, วิดีโอบทเรียน (คลัง + รายละเอียด + ควิซในตัว), ห้องเรียนอาจารย์ (roster, sync
  status, export CSV/PDF), ข่าว + web push
- **BLS** (`/bls/**`): pre-course 8 บท, post-test (คำถามคงที่ในโค้ด ไม่ผ่าน DB), ใบประกาศนียบัตร,
  เกมลำดับขั้น BLS (8 ด่าน), ฝึก CPR, Algorithm อ้างอิง, คู่มือ AED, การช่วยเหลือสำลัก,
  ห้องเรียนอาจารย์, ข่าว + web push (ใช้ infra ร่วมกับ ACLS ทั้งหมด)
- **Admin** (`/admin/acls/**`): จัดการบท/หมวด/Q&A/รูป, รูปประกอบ pre-course, Q&A เชิงลึก
  (ฉบับร่าง + เผยแพร่แล้ว), คิวตรวจคำถามนักเรียน (แก้ไข/เผยแพร่/สร้างใหม่/ปฏิเสธ), วิดีโอบทเรียน,
  สถิติรวม, รายชื่อนักเรียน, รายชื่อห้องเรียน
- **AI pipeline**: DeepSeek ตอบคำถาม + จัดหมวดหมู่, gpt-image-1 สร้างภาพประกอบ, Claude
  (web-search) คัดข่าวรายวัน 3 ครั้ง/วัน, Claude haiku สำหรับ ALS tip

## ข้อลดทอนที่ตั้งใจ (บันทึกไว้เพื่อความโปร่งใส)

- หน้า "ผลสอบ" แยกต่างหาก (QuizResults) ไม่ได้พอร์ต — คอมโพเนนต์ Exam แสดงผลแยกหัวข้อให้ทันทีหลังส่งคำตอบอยู่แล้ว
- ปุ่ม "จัดหมวดอัตโนมัติด้วย AI" ในหน้าแอดมิน Q&A เชิงลึก ไม่ได้พอร์ต (endpoint classify แยกอยู่นอกขอบเขต) — เลือกหมวดเองผ่าน dropdown แทน
- ไม่มี QR code สำหรับลิงก์เข้าห้องเรียน (ไม่มี dependency `qrcode`) — คัดลอกรหัส/ลิงก์แทนได้
- ตาราง PDF (ห้องเรียน/ใบสรุป) ใช้ grid renderer เขียนเอง แทน `jspdf-autotable` (ไม่ได้ติดตั้ง dependency นี้)
- ตัดโฆษณา/แบนเนอร์การตลาด (MorrooAdCard, JiacprCourseBanner, BLS upsell card) ออกทั้งหมด — ไม่ใช่ส่วนการเรียนการสอน

## หลังจากนี้ (ยังไม่ได้ทำ — ต้องตัดสินใจเพิ่ม)

1. **ปิดแอปเดิม**: ตอนนี้ acls.morroo.com/bls.morroo.com ยังรันคู่กันและเขียนข้อมูลเข้า DB เดิมอยู่
   (`elyyijlcjfvhxbpzscnv`) — ต้องกำหนดวันปิด แล้วรัน `scripts/migrate-acls-data.mjs` รอบสุดท้าย
   ก่อนปิดจริง (ตรวจแล้วล่าสุด ณ ตอนย้ายเสร็จ ข้อมูลยังตรงกัน 100% ไม่มี drift)
2. **ตั้งค่า env vars ใน Vercel ของ morroo** ตามรายการด้านล่าง (ยังไม่ได้ตั้ง — ฟีเจอร์ AI/push/LINE
   จะ fail แบบ silent/best-effort จนกว่าจะตั้งค่า)
3. **ทดสอบ flow จริงบน environment ที่มี env ครบ** — งานนี้ยืนยันด้วย `npm run build` + `tsc --noEmit`
   + `vitest` เท่านั้น ยังไม่ได้ลองกดใช้งานจริงในเบราว์เซอร์ (join ห้องเรียน, ทำข้อสอบ, โหลด
   certificate, ส่งคำถาม, publish จากแอดมิน)
4. ลบ `NEXT_PUBLIC_ACLS_SUPABASE_URL`/`_ANON_KEY` ออกจาก Vercel เมื่อมั่นใจว่าไม่มีที่ไหนอ้างอิงแล้ว

## แผนละเอียด

ดูแผน 10 phase ฉบับเต็มที่ใช้ระหว่างพัฒนาใน PR description ของ branch นี้ (PR #341)
