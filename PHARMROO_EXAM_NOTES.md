# Pharmroo Exam System - Notes

## สถานะปัจจุบัน
- **Repo:** `jiacpr-arch/pharmroo` (เพิ่ง push ขึ้น GitHub)
- **Vercel:** project "pharmroo" domain pharmru.com (deploy ผ่าน CLI, เพิ่งเชื่อม Git)
- **Admin exams page:** placeholder "ระบบจัดการข้อสอบ MCQ กำลังพัฒนา" — ยังไม่มี CRUD
- **Admin exams/[id]:** redirect กลับ /admin/exams (ยังไม่มีอะไร)

## Tech Stack (pharmroo)
- Next.js 16 + React 19
- Drizzle ORM + PostgreSQL (Supabase)
- NextAuth v5 (beta.30)
- shadcn UI + Tailwind CSS v4
- Stripe payments
- Anthropic SDK

## Database Schema (อยู่แล้ว)
- `users` — id, email, name, role (user/admin), membership
- `mcqSubjects` — id, name, name_th, icon, exam_type (PLE-PC/PLE-CC1/both)
- `mcqQuestions` — id, subject_id, scenario, choices (JSONB), correct_answer, explanation, detailed_explanation (JSONB), difficulty, status
- `mcqAttempts` — user responses tracking
- `mcqSessions` — study session tracking
- `questionSets` — bundles with pricing
- `setQuestions` — many-to-many junction
- `setPurchases` — purchase tracking
- `paymentOrders` — payment management

## DB Files
- Schema: `lib/db/schema.ts`
- Queries: `lib/db/queries-mcq.ts`
- Mutations: `lib/db/mutations-mcq.ts`
- DB connection: `lib/db/index.ts`

## สิ่งที่ต้องสร้าง (เหมือน morroo)
Admin UI สำหรับจัดการข้อสอบ MCQ:
1. `/app/admin/exams/page.tsx` — CRUD list ข้อสอบ MCQ (สร้าง/แก้ไข/ลบ)
2. `/app/admin/exams/[id]/page.tsx` — จัดการ question detail (choices, เฉลย, คำอธิบาย)
3. API routes สำหรับ CRUD operations

## morroo exam system (ตัวอย่างที่ต้องทำตาม)
- `/app/admin/exams/page.tsx` — Full CRUD inline form (title, category, difficulty, status, publish_date, is_free)
- `/app/admin/exams/[id]/page.tsx` — Exam parts management (scenario, question, answer, key_points, time)
- Supabase direct queries (not Drizzle)
- Tables: `exams` + `exam_parts`

## ข้อแตกต่างสำคัญ
| | morroo | pharmroo |
|---|---|---|
| DB ORM | Supabase client direct | Drizzle ORM |
| Auth | Supabase Auth | NextAuth v5 |
| Exam type | Long-form case (scenario+written answer) | MCQ (multiple choice) |
| Schema | exams + exam_parts | mcqSubjects + mcqQuestions |
| UI framework | shadcn + Tailwind | shadcn + Tailwind (same) |

## หมายเหตุ
- ผมเข้าถึง pharmroo repo โดยตรงไม่ได้ (session จำกัดแค่ jiacpr-arch/morroo)
- แผน: เขียน code ใน morroo repo แล้วให้ user copy ไป pharmroo
- User ยังไม่แน่ใจ 100% ว่าต้องการอะไร — ต้องคุยเพิ่มพรุ่งนี้
