# หมอประจำวัน (morroo-daily-doctor)

Scheduled task ของแอป Claude Code ที่รันทุกเช้า **~06:43** (เวลาไทย) ตรวจสุขภาพระบบ morroo
ทั้งหมด แก้บั๊กเล็กที่ปลอดภัยแล้ว merge เข้า `main` เอง ส่วนอะไรที่เสี่ยงจะเตรียม PR ไว้ให้
แต่ไม่ merge เอง — รอเราอนุมัติ

> รันเฉพาะตอนแอป Claude เปิดอยู่บนเครื่องนี้ ถ้าแอปปิดอยู่ตอน 06:43 มันจะรันตอนเปิดแอปครั้งถัดไปแทน

## Repo: GitHub เป็นหลัก, GitLab sync ทางเดียว

ตั้งแต่ 2026-09-18 **Vercel deploy production จาก GitHub** (`jiacpr-arch/morroo`) แล้ว —
ไม่ใช่ GitLab เหมือนตอนที่ระบบนี้เริ่มสร้าง หมอจึงทำงานบน GitHub (`gh` CLI, GitHub PR) เป็นหลัก

GitLab (`jiacpr/morroo`) ยังมีอยู่และยังใช้งาน แต่ sync **ทางเดียว** ผ่าน GitLab push-mirror
(GitLab → GitHub อัตโนมัติ) ที่เราตั้งค่าไว้เอง — หมอไม่ยุ่งกับ GitLab เลย ไม่ตรวจ ไม่ push
ไม่เปิด MR ที่นั่น ถ้า mirror ค้าง/พังต้องเข้าไปดูเองที่ GitLab → Settings → Repository →
Mirroring repositories (พบปัญหานี้ครั้งนึงแล้วตอน 2026-09-18: มีคน push ตรงเข้า GitHub
โดยไม่ผ่าน GitLab ทำให้สอง repo เพี้ยนกัน ต้องเปิด MR ดึงกลับเข้า GitLab ด้วยมือ)

## ตรวจอะไรบ้าง

- **Vercel**: runtime error 24 ชม. ล่าสุด, deploy ที่ build fail
- **Supabase**: security advisors ใหม่, `board_gen_jobs` ที่ error/ค้าง, `scheduled_autoposts`
  ที่ล้มเหลว, `_ai_grade_errors`, `mcq_question_reports` ที่ค้าง, ความสดของเนื้อหา (blog/mcq/exam)
- **GitHub Actions**: check บน PR ที่หมอเปิดเอง (lint+typecheck+test, `.github/workflows/verify.yml`)
- **GitLab CI pipeline ของ content generator (blog/mcq/board/…) — หมอไม่ได้เช็คโดยตรง**
  (ไม่มี `glab` แล้ว) ดูอ้อมๆ จากความสดของเนื้อหาใน Supabase แทน ถ้าดู stale ต้องเข้า GitLab เองดูพีพไลน์

## ระดับความเสี่ยง (tier)

| Tier | ทำอะไร | เงื่อนไข |
|---|---|---|
| **A** | แก้ → เปิด PR → **merge เอง** → ตรวจหลัง deploy | root cause ชัดเจน, แก้ ≤5 ไฟล์, ไม่แตะ path ที่เสี่ยง (ดูด้านล่าง), มี test ที่ fail ก่อนแก้และ pass หลังแก้, `npm run verify` ผ่าน, PR check เขียว |
| **B** | แก้ → เปิด PR → **ไม่ merge เอง** (label `tier-b`) | แตะ path ที่เสี่ยง, root cause ไม่ชัด, แก้ >5 ไฟล์, ไม่มี test คุมได้, หรือเปลี่ยนสิ่งที่ผู้ใช้/สาธารณะได้รับ |
| **C** | รายงานอย่างเดียว ไม่ทำอะไรเอง | secret/token, ลบ/ย้ายข้อมูล, การเงิน, บัญชีภายนอก, แก้ schema/RLS |

**Path ที่ถือว่าเสี่ยงเสมอ (Tier B โดยอัตโนมัติ):** billing/Stripe/FlowAccount, invoice/checkout,
`middleware.ts`, login, `lib/supabase/**`, `supabase/**` (migrations), `vercel.json`,
`.gitlab-ci.yml`, `.github/workflows/**`, `next.config.ts`, `package.json`, `.claude/**`, `.env*`,
ทุกอย่างที่ส่งข้อความออก (LINE/email/autopost), `lib/ads-*`, `scripts/**` (content generator)

**คาดหวังวันแรกๆ**: Tier A จริงๆ มักมีแค่ 0-1 เรื่อง/วัน (บั๊กเล็กที่ชัดเจนจริงๆ ไม่ได้มีทุกวัน)
ส่วนใหญ่ที่เจอจะเป็น Tier B เพราะแตะระบบที่ส่งอะไรออกไปหาคนอื่น

## จะรู้ได้ยังไงว่ามีอะไรต้องทำ

1. **ทันทีหลังรันเสร็จ**: การแจ้งเตือนบนเครื่อง (ถ้ามีเรื่องรออนุมัติหรือ revert) + สรุปท้าย session
2. **08:00 LINE**: ส่วน "🩺 หมอประจำวัน" ใน admin-digest — merge แล้ว / รออนุมัติ (พร้อมลิงก์) / ต้องทำเอง
3. **รายละเอียดเต็ม**: PR บน GitHub (อาการ/สาเหตุ/สิ่งที่แก้/วิธีตรวจ) หรือไฟล์ที่
   `~/.claude/scheduled-tasks/morroo-daily-doctor/state/reports/YYYY-MM-DD.md`

## วิธีตอบสนอง

- **อนุมัติ**: พิมพ์ `merge #<เลข PR>` ใน Claude session ไหนก็ได้ หรือกด Merge บน GitHub เอง
- **ปฏิเสธ**: ปิด (close) PR บน GitHub
- **บอกให้เลื่อนไปก่อน 14 วัน**: เพิ่ม label `doctor-snooze` บน PR
- **บอกให้ลองแก้ใหม่**: เพิ่ม label `doctor-retry` บน PR ที่เคยปิดไปแล้ว
- **หยุดหมอทั้งระบบ**: ปิด scheduled task `morroo-daily-doctor` ในแอป Claude (Settings → Scheduled tasks)

## ที่เก็บข้อมูล

- ปม (state) การทำงาน: `~/.claude/scheduled-tasks/morroo-daily-doctor/state/`
  (`ledger.json` = สถานะแต่ละเรื่อง, `reports/YYYY-MM-DD.md` = รายงานแต่ละวัน)
- โค้ดที่หมอทำงาน: git worktree แยกที่ `.claude/worktrees/doctor/` (ไม่แตะ checkout หลักของเราเด็ดขาด)
  `origin` ของ worktree นี้คือ GitHub
- PR ทั้งหมดที่หมอเปิดจะมี label `daily-doctor` (บน GitHub `jiacpr-arch/morroo`)

## ข้อจำกัดที่รู้อยู่แล้ว

- ระบบ `ads-autofix-suggest` เดิม (เปิด PR แก้ landing page อัตโนมัติ) ผูกกับ GitHub อยู่แล้ว
  (`lib/github-api.ts`, `jiacpr-arch/morroo`) ตอนนี้ตรงกับที่ Vercel deploy จริงแล้ว — ไม่ใช่
  known issue อีกต่อไป
- GitLab push-mirror เป็นทิศทางเดียว (GitLab → GitHub) ถ้ามีใคร push ตรงเข้า GitHub โดยไม่ผ่าน
  GitLab (เช่นจาก PR ที่เปิดบน GitHub ตรงๆ) สอง repo จะเพี้ยนกันอีก ต้อง sync มือแบบที่ทำไปแล้ว
  ครั้งนึง — หมอไม่ตรวจ/ไม่แก้เรื่องนี้ให้ ต้องดูเองเป็นระยะ
- หมอรันแค่ 1 รอบ/วัน ใช้เวลาไม่เกิน ~40 นาที merge ได้จริงประมาณ 1 เรื่อง/วัน (check + deploy +
  รอดู error หลัง deploy กินเวลาเยอะ) เรื่องที่เหลือจะต่อคิวไปวันถัดไป
