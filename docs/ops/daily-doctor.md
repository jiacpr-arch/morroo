# หมอประจำวัน (morroo-daily-doctor)

Scheduled task ของแอป Claude Code ที่รันทุกเช้า **06:40** (เวลาไทย) ตรวจสุขภาพระบบ morroo
ทั้งหมด แก้บั๊กเล็กที่ปลอดภัยแล้ว merge เข้า `main` เอง ส่วนอะไรที่เสี่ยงจะเตรียม MR ไว้ให้
แต่ไม่ merge เอง — รอเราอนุมัติ

> รันเฉพาะตอนแอป Claude เปิดอยู่บนเครื่องนี้ ถ้าแอปปิดอยู่ตอน 06:40 มันจะรันตอนเปิดแอปครั้งถัดไปแทน

## ตรวจอะไรบ้าง

- **Vercel**: runtime error 24 ชม. ล่าสุด, deploy ที่ build fail
- **Supabase**: security advisors ใหม่, `board_gen_jobs` ที่ error/ค้าง, `scheduled_autoposts`
  ที่ล้มเหลว, `_ai_grade_errors`, `mcq_question_reports` ที่ค้าง, ความสดของเนื้อหา (blog/mcq/exam)
- **GitLab CI**: pipeline schedule (blog/mcq/board/…) ที่ล้มเหลวใน 24 ชม.

## ระดับความเสี่ยง (tier)

| Tier | ทำอะไร | เงื่อนไข |
|---|---|---|
| **A** | แก้ → เปิด MR → **merge เอง** → ตรวจหลัง deploy | root cause ชัดเจน, แก้ ≤5 ไฟล์, ไม่แตะ path ที่เสี่ยง (ดูด้านล่าง), มี test ที่ fail ก่อนแก้และ pass หลังแก้, `npm run verify` ผ่าน, MR pipeline เขียว |
| **B** | แก้ → เปิด MR → **ไม่ merge เอง** (label `tier-b`) | แตะ path ที่เสี่ยง, root cause ไม่ชัด, แก้ >5 ไฟล์, ไม่มี test คุมได้, หรือเปลี่ยนสิ่งที่ผู้ใช้/สาธารณะได้รับ |
| **C** | รายงานอย่างเดียว ไม่ทำอะไรเอง | secret/token, ลบ/ย้ายข้อมูล, การเงิน, บัญชีภายนอก, แก้ schema/RLS |

**Path ที่ถือว่าเสี่ยงเสมอ (Tier B โดยอัตโนมัติ):** billing/Stripe/FlowAccount, invoice/checkout,
`middleware.ts`, login, `lib/supabase/**`, `supabase/**` (migrations), `vercel.json`,
`.gitlab-ci.yml`, `next.config.ts`, `package.json`, `.claude/**`, `.env*`, ทุกอย่างที่ส่งข้อความ
ออก (LINE/email/autopost), `lib/ads-*`, `scripts/**` (content generator)

**คาดหวังวันแรกๆ**: Tier A จริงๆ มักมีแค่ 0-1 เรื่อง/วัน (บั๊กเล็กที่ชัดเจนจริงๆ ไม่ได้มีทุกวัน)
ส่วนใหญ่ที่เจอจะเป็น Tier B เพราะแตะระบบที่ส่งอะไรออกไปหาคนอื่น

## จะรู้ได้ยังไงว่ามีอะไรต้องทำ

1. **ทันทีหลังรันเสร็จ**: การแจ้งเตือนบนเครื่อง (ถ้ามีเรื่องรออนุมัติหรือ revert) + สรุปท้าย session
2. **08:00 LINE**: ส่วน "🩺 หมอประจำวัน" ใน admin-digest — merge แล้ว / รออนุมัติ (พร้อมลิงก์) / ต้องทำเอง
3. **รายละเอียดเต็ม**: MR บน GitLab (อาการ/สาเหตุ/สิ่งที่แก้/วิธีตรวจ) หรือไฟล์ที่
   `~/.claude/scheduled-tasks/morroo-daily-doctor/state/reports/YYYY-MM-DD.md`

## วิธีตอบสนอง

- **อนุมัติ**: พิมพ์ `merge !<เลข MR>` ใน Claude session ไหนก็ได้ หรือกด Merge บน GitLab เอง
- **ปฏิเสธ**: ปิด (close) MR บน GitLab
- **บอกให้เลื่อนไปก่อน 14 วัน**: เพิ่ม label `doctor-snooze` บน MR
- **บอกให้ลองแก้ใหม่**: เพิ่ม label `doctor-retry` บน MR ที่เคยปิดไปแล้ว
- **หยุดหมอทั้งระบบ**: ปิด scheduled task `morroo-daily-doctor` ในแอป Claude (Settings → Scheduled tasks)

## ที่เก็บข้อมูล

- ปม (state) การทำงาน: `~/.claude/scheduled-tasks/morroo-daily-doctor/state/`
  (`ledger.json` = สถานะแต่ละเรื่อง, `reports/YYYY-MM-DD.md` = รายงานแต่ละวัน)
- โค้ดที่หมอทำงาน: git worktree แยกที่ `.claude/worktrees/doctor/` (ไม่แตะ checkout หลักของเราเด็ดขาด)
- MR ทั้งหมดที่หมอเปิดจะมี label `daily-doctor`

## ข้อจำกัดที่รู้อยู่แล้ว

- ระบบ `ads-autofix-suggest` เดิม (เปิด PR แก้ landing page อัตโนมัติ) ยังผูกกับ **GitHub**
  (`lib/github-api.ts`, `jiacpr-arch/morroo`) ไม่ใช่ GitLab ที่ repo นี้ใช้จริง — หมอไม่แก้ให้เอง
  รายงานเป็น known issue ทุก 7 วัน ต้องตัดสินใจเองว่าจะย้ายไป GitLab หรือปิดระบบเดิม
- หมอรันแค่ 1 รอบ/วัน ใช้เวลาไม่เกิน ~40 นาที merge ได้จริงประมาณ 1 เรื่อง/วัน (pipeline + deploy +
  รอดู error หลัง deploy กินเวลาเยอะ) เรื่องที่เหลือจะต่อคิวไปวันถัดไป
