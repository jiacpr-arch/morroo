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

ยังเก็บไว้เป็น **summary** ให้ cron / analytics / โค้ดเก่าอ่านได้ (`expiry-warning`,
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

## ขายแยกรายการ (items) — วิชา / สาขา / ชุด / เคส / บท

นอกจากแพ็ก (ทั้งระบบ) ยังขาย "รายการเดียว" ในระบบได้ ผ่านคอลัมน์ `scope`
ของ `membership_entitlements` (`*` = ทั้งระบบ) — migration
`supabase/migrations/20260914_entitlement_scopes.sql`

| ระบบ | รายการที่ขาย | plan string | scope | ราคา (`lib/items.ts` ITEM_PRICES) |
|---|---|---|---|---|
| MCQ NL | รายวิชา | `item:mcq_subject:<mcq_subjects.id>` | `subject:<id>` | 79 / 59 / 39 ตามจำนวนข้อ (≥200 / 100–199 / <100) ซื้อขาด |
| MCQ NL | หมวดอายุรกรรม | `item:mcq_category:internal_med` | `category:internal_med` | 99 ซื้อขาด |
| MCQ NL | preclinic ทุกวิชา | `item:mcq_examtype:NL1` | `examtype:NL1` | 99 ซื้อขาด |
| Board | รายสาขา | `item:board_specialty:<slug>:month\|year` | `specialty:<slug>` | 299/เดือน · 1,990/ปี |
| MEQ | รายชุด | `item:meq_exam:<exams.id>` | `exam:<id>` | 29 ซื้อขาด |
| MEQ | รายวิชา | `item:meq_category:<category>` | `category:<category>` | 149 ซื้อขาด |
| Long Case | รายเคส (ทำได้ 3 ครั้ง) | `item:longcase_case:<long_cases.id>` | `case:<id>` | 49 ซื้อขาด |
| Long Case | รายวิชา | `item:longcase_specialty:<specialty>` | `specialty:<specialty>` | 129 ซื้อขาด |
| School | รายบท | `item:school_topic:<school_topics.id>` | `topic:<id>` | 39 ซื้อขาด |
| School | ทั้งปี | `item:school_year:<1-6>` | `year:<n>` | 199 ซื้อขาด |

- plan string วิ่งผ่าน checkout → Stripe metadata → fulfil เหมือนแพ็กปกติ
  ราคา/ชื่อคำนวณฝั่ง server เท่านั้น (`lib/billing/plan-resolver.ts` `resolveItem`)
- หน้าชำระเงิน `/payment/<plan string>` ดึงข้อมูลจาก `GET /api/billing/plan-info` และโชว์แพ็กใหญ่เป็น anchor
- การ์ดขายในหน้าใช้งานจริง (`components/ItemUpsell.tsx`): NL practice รายวิชา, Board practice/oral รายสาขา,
  MEQ answer รายชุด, Long Case card รายเคส, School guided รายบท — หน้า /pricing ไม่แสดงราคาย่อย
- เช็คสิทธิ์: `hasScopedAccess(product, scopes, profile, entitlements)` = ทั้งระบบ **หรือ** มี scope ที่ตรง
- Admin: `/admin/users` แสดงรายการที่ซื้อแยกและยกเลิกได้ (`POST /api/admin/membership` รับ `scope`)
- Items ไม่แตะ `profiles.membership_type` (ไม่ใช่แพ็ก) — cron/analytics มองผู้ซื้อรายการเดียวเป็น free ต่อไป

## Voucher / คูปอง (coupon_codes)

- `coupon_codes.plan_type` (migration `20260915_coupon_plan_type.sql`)
  - `free_trial` / `free_month`: แพ็กหรือรายการที่ให้ — ว่าง = แพ็ก นศพ. (`monthly`) เหมือนเดิม
    ใส่ได้ทั้ง plan ใน `PLAN_CATALOG` (เช่น `board_monthly`, `mcq_monthly`) และ item string
    (เช่น `item:board_specialty:internal_medicine:month`) — แลกที่ `/redeem` แล้ว `lib/redeem.ts`
    จะ `grantPlanDays` หรือ `grantProduct(scope)` ตามนั้น
  - `discount_percent` / `discount_fixed`: จำกัดให้ใช้กับแพ็ก/รายการเดียว — ว่าง = ทุกแพ็ก
- ส่วนลดใช้ที่หน้าชำระเงิน: ช่อง "มีโค้ดส่วนลด?" → `POST /api/billing/coupon-check` (preview)
  → `POST /api/billing/checkout {couponCode}` ตรวจซ้ำ (`lib/billing/coupon-checkout.ts`) แล้วส่งราคาหลังหักไป Stripe
  → ตอน fulfil บันทึกการใช้ผ่าน RPC `redeem_coupon_code` และเก็บ `coupon_redemptions.stripe_session_id`
- ราคาหลังหักไม่ต่ำกว่า ฿10 (ขั้นต่ำของ Stripe สำหรับ THB)
- สร้างคูปองที่ `/admin/coupons` มีช่อง "ให้แพ็ก / รายการ" (free) หรือ "ใช้กับแพ็ก" (discount)

## แพ็กเกจกลุ่ม / สถาบัน (organizations) — MVP

สำหรับคณะแพทย์ / ติวเตอร์ / กลุ่มเพื่อน — **ชำระเงินนอกระบบ** (ใบแจ้งหนี้ / โอน) แล้ว admin สร้างกลุ่มเอง
— migration `supabase/migrations/20260925_organizations.sql`

- ตาราง `organizations (id, name, seats, plan, expires_at, join_code, note, …)` และ
  `organization_members (org_id, user_id, role 'owner'|'member', joined_at)`
- RLS: สมาชิกอ่านกลุ่มของตัวเองได้, ผู้ใช้อ่านแถวสมาชิกของตัวเองได้, owner อ่านสมาชิกทั้งกลุ่มได้, admin อ่านได้ทั้งหมด
  — เขียนผ่าน service role (API) เท่านั้น
- **สิทธิ์**: `fetchEntitlements()` (`lib/entitlements.ts`) เติมแถวสังเคราะห์ `source = 'org'` หนึ่งแถวต่อ product ของ
  `organizations.plan` (ค่าเริ่มต้น `yearly` = แพ็ก นศพ.) หมดอายุตาม `organizations.expires_at`
  — `lib/organizations.ts` `orgEntitlementRows`. ไม่มีการเขียนลง `membership_entitlements` หรือ `profiles.membership_type`
  ดังนั้นสิทธิ์จบเองทันทีเมื่อกลุ่มหมดอายุหรือสมาชิกถูกลบ
- กติกาใน `resolveAccess`: แถว org เป็นแบบ **บวกเพิ่ม** — ไม่นับเป็น "มีแถวแล้ว" (ไม่ปิด legacy fallback),
  products = สิทธิ์ส่วนตัว ∪ สิทธิ์จากกลุ่ม; `deriveLegacyMembership` ตัดแถว org ทิ้งเสมอ
  (`syncLegacyMembership` และ `/api/admin/membership` ใช้ `fetchEntitlements(..., { includeOrg: false })`)
- ที่นั่ง: ทุกแถวสมาชิก (รวม owner) = 1 ที่นั่ง; การเข้าร่วมเช็คผ่าน RPC `join_organization` (lock แถว org กันแย่งที่นั่งพร้อมกัน)

| หน้า / API | ใช้ทำอะไร |
|---|---|
| `/admin/organizations` · `/api/admin/organizations[/id]` | สร้างกลุ่ม, ตั้งที่นั่ง/แพ็ก/วันหมดอายุ, ตั้งผู้ดูแลด้วยอีเมล, สร้างรหัสใหม่, ลบกลุ่ม |
| `/org/join/<code>` · `POST /api/org/join` | สมาชิกกดเข้าร่วม (ต้องล็อกอิน) |
| `/org` | owner: แดชบอร์ดสมาชิก (MCQ ที่ทำ, ความแม่นยำ, ใช้งานล่าสุด, streak), ลบสมาชิก, คัดลอกลิงก์เชิญ, Export CSV · คนทั่วไป: ช่องใส่รหัสกลุ่ม |
| `DELETE /api/org/members` | owner / admin ลบสมาชิก (ลบ owner ได้เฉพาะ admin) |
| `/pricing#group` | CTA "สำหรับกลุ่ม/สถาบัน" → LINE OA |
