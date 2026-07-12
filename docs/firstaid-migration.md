# FirstAid → Morroo: คู่มือ cutover (เฟส 1)

ระบบเรียนปฐมพยาบาล (เดิม repo `jiacpr-arch/firstaid` deploy แยก) ถูกย้ายเข้ามาเป็น
section หนึ่งของ morroo: เสิร์ฟที่ `firstaid.morroo.com` ผ่าน host-rewrite ใน
`middleware.ts` → route tree `app/(firstaid)/firstaid/*` (root layout แยก คนละ
pixel/ฟอนต์/CSS กับ morroo) + API ที่ `app/api/firstaid/*` + ตาราง `fa_*` ใน
Supabase ของ morroo

## Env vars ที่ต้องตั้งใน Vercel (โปรเจกต์ morroo)

| ตัวแปร | ค่า |
|---|---|
| `NEXT_PUBLIC_FIRSTAID_META_PIXEL_ID` | `1524889459310260` (pixel เดิมของ firstaid — ห้ามใส่ใน preview ถ้าไม่อยากให้ event ปนโปรดักชัน) |
| `NEXT_PUBLIC_FIRSTAID_POSTHOG_KEY` / `_HOST` | ค่าเดิมจาก firstaid (`VITE_POSTHOG_KEY/HOST`) |
| `FIRSTAID_LINE_LOGIN_CHANNEL_ID` / `_SECRET` | LINE Login channel เดิมของ firstaid (OA @jiacpr) |
| `LINE_CHANNEL_ACCESS_TOKEN` / `LINE_ADMIN_USER_ID` | สำหรับแจ้งเตือนแอดมินตอนออกใบเซอร์/มี lead (ค่าเดิมจาก firstaid) — ถ้าชนกับของ morroo ให้ตั้งชื่อ `FIRSTAID_` นำหน้าแล้วแก้ใน `lib/firstaid/server/lineNotify.ts` |

สำหรับสคริปต์ migrate (รัน local เท่านั้น ไม่ต้องตั้งใน Vercel):
`OLD_SUPABASE_URL`, `OLD_SUPABASE_SERVICE_ROLE_KEY` (โปรเจกต์ firstaid เดิม),
`NEW_SUPABASE_URL`, `NEW_SUPABASE_SERVICE_ROLE_KEY` (โปรเจกต์ morroo)

## ขั้นตอนก่อน cutover

1. Apply `supabase/firstaid_phase1.sql` กับ Supabase ของ morroo (สร้างตาราง `fa_*`)
2. LINE Developers console (channel ของ firstaid): เพิ่ม callback URL
   `https://firstaid.morroo.com/api/firstaid/auth/line/callback`
   (+ URL ของ preview ถ้าจะทดสอบ login บน preview)
3. ย้ายข้อมูล: ทำแล้วผ่าน Supabase MCP (12 ก.ค. 2026) — ตาราง firstaid ใน
   โปรเจกต์ **jia-unified** (`tpoiyykbgsgnrdwzgzvn` ซึ่งเป็นโปรเจกต์ร่วมกับระบบอื่นของ Jia
   ห้ามปิดทิ้ง) ถูก copy เข้าโปรเจกต์ morroo (`knxidnzexqehusndquqg`) แล้ว
   identity เก่าอยู่ใน `fa_migrated_learners` (ไม่สร้าง auth user ล่วงหน้า — callback
   จะ adopt learner_id เดิมตอน login ครั้งแรก) ถ้าต้องรันซ้ำเอง:
   ```
   node scripts/firstaid/migrate/01-links-and-users.mjs   # line_identities → fa_migrated_learners
   node scripts/firstaid/migrate/02-certificates.mjs
   node scripts/firstaid/migrate/03-progress.mjs
   node scripts/firstaid/migrate/04-entitlements.mjs
   ```
   ทุกสคริปต์ idempotent (upsert บน natural key) รันซ้ำได้ และพิมพ์ count เทียบ old/new
4. QA บน preview subdomain (เช่น `firstaid-beta.morroo.com` — middleware รองรับ
   `firstaid-beta.*` อยู่แล้ว): เรียน→สอบ→ใบเซอร์ PNG/PDF บน iOS Safari /
   Android Chrome / LINE in-app browser

## ลำดับ cutover (~1 ชม. ย้อนกลับได้)

1. Snapshot Supabase เก่า (jia-unified)
2. Sync delta: รันสคริปต์ 01→04 ซ้ำ (หรือให้ Claude รันผ่าน Supabase MCP)
   เพื่อเก็บข้อมูลที่เขียนบนระบบเก่าหลังการ copy รอบแรก
3. Vercel: ย้ายโดเมน `firstaid.morroo.com` จากโปรเจกต์เก่า → โปรเจกต์ morroo (DNS ไม่ต้องแก้)
4. รันสคริปต์ migrate ซ้ำ (เก็บ delta ที่เขียนระหว่างสลับ)
5. ตรวจสด:
   - `https://firstaid.morroo.com/api/firstaid/certificates/verify?code=FA-XXXX` ด้วยรหัสเก่าจริง
   - เครื่องที่ติดตั้ง PWA เดิม: เปิดแอป → killer SW (`/sw.js`) ต้องล้าง cache แล้ว reload เข้าเว็บใหม่
   - flow เรียน→สอบ post-test→ออกใบเซอร์ครบ
   - Meta Events Manager เห็น PageView ที่ pixel `1524889459310260`, PostHog มี event เข้า
6. Repo เก่า: คง deploy ไว้เป็น admin (อ่านข้อมูลเก่า) — ปิด nurture cron ภายใน ~1 สัปดาห์,
   ติดป้าย README ว่า frozen
7. **Rollback**: ย้ายโดเมนกลับโปรเจกต์เก่าใน Vercel (นาทีเดียว)

## ระหว่างรอเฟส 2

- สร้าง voucher ใหม่: `node scripts/firstaid/create-voucher.mjs --chapter 0 --count 5 --price 249`
- ใบเซอร์ practical ที่ออกจากระบบ admin เก่า: รัน `02-certificates.mjs` ซ้ำรายสัปดาห์
  เพื่อให้ verify ได้บนโดเมนใหม่
- `/checkin` เป็นหน้า stub — งานเช็คชื่อ QR/ภาคปฏิบัติกลับมาในเฟส 2

## เฟสถัดไป

- **เฟส 2:** cohorts/sessions/attendance + `/checkin` + QR scan + issue-practical + หน้า admin voucher
- **เฟส 3:** admin 9 หน้า, LINE webhook/nurture cron, ad-report cron, ปิดโปรเจกต์ Vercel + Supabase เก่า
