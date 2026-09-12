# สิทธิ์สมาชิกแยกรายระบบ (membership entitlements)

สมาชิกถือสิทธิ์ได้ **พร้อมกันหลายระบบ** และแต่ละระบบหมดอายุแยกกัน
เพื่อให้แยกสิทธิ์และเก็บเงินได้ทีละระบบ:

| product    | ระบบ                                   | จุดเช็คสิทธิ์หลัก |
|------------|----------------------------------------|-------------------|
| `school`   | Y1–Y6 micro-learning (flashcard/quiz/SRS) | `app/(morroo)/school/**` |
| `mcq`      | MCQ NL Step 2                          | `app/(morroo)/nl/practice`, `nl/try` |
| `meq`      | ข้อสอบ MEQ + AI ตรวจคำตอบ              | `app/(morroo)/exams/[id]/answer`, `app/api/grade` |
| `longcase` | Long Case (audience = student)         | `app/(morroo)/longcase`, `app/api/longcase/start` |
| `board`    | MCQ บอร์ด + Oral Exam                  | `app/(morroo)/board/**`, `app/api/longcase/start` (case audience = board) |

## โครงสร้าง

- ตาราง `membership_entitlements (user_id, product, expires_at, source, reference, …)`
  PK = `(user_id, product)`; `expires_at = NULL` คือไม่มีวันหมดอายุ (bundle)
  — migration `supabase/migrations/20260913_membership_entitlements.sql`
  (มี backfill จาก `profiles.membership_type` ที่ยัง active ให้อัตโนมัติ)
- RPC (service role เท่านั้น)
  - `grant_entitlement(user, product, days, source, ref)` — ต่ออายุ **ทบ** จากวันหมดอายุเดิม
  - `set_entitlement(user, product, expires_at, …)` — ตั้งค่าตรง ๆ (admin) / revoke = ตั้งเป็น now()
- `lib/membership.ts` — pure model
  - `PLAN_CATALOG` = แพ็กที่ขาย (ราคา, ชื่อ Stripe, products ที่ปลดล็อก, ระยะเวลา) **แหล่งเดียว**
    ที่ `STRIPE_PLANS`, `/payment/[plan]`, การ์ดราคา และเมนู admin ดึงไปใช้
  - `resolveAccess(profile, entitlements)` → `{ school, mcq, meq, longcase, board, anyPaid }`
  - `hasMcqAccess / hasMeqAccess / hasLongcaseAccess / hasBoardAccess / hasSchoolAccess`
- `lib/entitlements.ts` — server helpers: `fetchAccess`, `grantPlan`, `grantPlanDays`,
  `grantProduct`, `setProduct`, `revokeProduct`, `extendActiveProducts`, `syncLegacyMembership`

## แพ็ก → ระบบ

| plan | products |
|------|----------|
| `monthly` / `yearly` (แพ็ก นศพ.) | mcq + meq + longcase + school |
| `bundle` | mcq (ไม่มีวันหมดอายุ) |
| `board_monthly` / `board_yearly` | board |
| `mcq_*`, `meq_*`, `longcase_*`, `school_*` | ระบบนั้นระบบเดียว |

## กติกาการเช็คสิทธิ์

1. ถ้าผู้ใช้มีแถวใน `membership_entitlements` (แม้หมดอายุแล้ว) → ใช้ตารางนี้ **เท่านั้น**
   เพื่อให้ admin revoke แล้วสิทธิ์ไม่กลับมาจากคอลัมน์เก่า
2. ถ้าไม่มีแถวเลย (ยังไม่ backfill) → fallback ไป `profiles.membership_type` ตามตาราง plan → products

## คอลัมน์เก่า `profiles.membership_type / membership_expires_at`

ยังเก็บไว้เป็น **summary** ให้ cron / analytics / โค้ดเก่าอ่านได้ (`trial-expiry`, `expiry-warning`,
`signup-drip`, revenue, beta) — ทุกครั้งที่ grant/revoke จะ `syncLegacyMembership()`
ให้ค่าเป็นแพ็กที่กว้างที่สุดที่ยัง active ทั้งหมด และ expiry = วันหมดอายุล่าสุดของแพ็กนั้น

## จุดที่ให้สิทธิ์

| ทาง | โค้ด |
|-----|------|
| Stripe checkout | `lib/billing/fulfill-checkout.ts` → `grantPlan(userId, planType, {source:"stripe"})` |
| อนุมัติสลิป (admin) | `app/(morroo)/admin/payments` → `POST /api/admin/membership {action:"grant_plan"}` |
| Admin จัดการสมาชิก | `app/(morroo)/admin/users` → `POST /api/admin/membership` (`grant` / `set` / `revoke` / `grant_plan`) |
| Redeem code / coupon | `lib/redeem.ts` → `grantPlanDays(userId, "monthly", days)` |
| Referral | `extendActiveProducts()` — ต่ออายุทุกระบบที่ active อยู่ |
| Bug-hunter reward | `app/api/mcq/redeem-points` — RPC ต่อคอลัมน์เก่า แล้ว `extendActiveProducts()` ต่อ entitlement ให้ตรงกัน |

## การ deploy

1. รัน `supabase/migrations/20260913_membership_entitlements.sql` ใน Supabase (มี backfill ในตัว, รันซ้ำได้)
2. deploy โค้ด — ก่อน migration ถูกรัน โค้ดจะ fallback ไปคอลัมน์เก่าอัตโนมัติ (query ตารางล้มเหลว → `[]`)
3. ตรวจราคาแพ็กรายระบบใน `PLAN_CATALOG` (`lib/membership.ts`) — ตอนนี้เป็นราคาตั้งต้น
