# แผนยิง Ads — MorRoo (หมอรู้) — H2/2026

> เอกสารนี้อิง **ข้อมูลจริง** จากบัญชีโฆษณา Facebook (`act_10153192786713173`) + Supabase `morroo`
> ดึงข้อมูล ณ 2026-06-21 (ช่วง last 90 วัน)
> เป้าหมาย: เลิกหว่านงบ → โฟกัสโครงสร้างเดียวที่วัดผลได้ และดึง warm pool ที่ทิ้งไว้กลับมา

---

## 0. สรุปสถานการณ์จริง (อ่านก่อนเสมอ)

### Funnel ปัจจุบัน
| ตัวชี้วัด | ค่า |
|---|---|
| ผู้ใช้ทั้งหมด | **51 คน** (ฟรี 36 / เคยจ่าย 15) |
| จ่ายอยู่จริงตอนนี้ (active) | **9 คน** (รายเดือน 5 + รายปี 4) — รายเดือน churn ไปแล้ว 6 |
| รายได้รวม | **฿3,776** (6 ออเดอร์ approved) |
| สมัครใหม่ต่อสัปดาห์ | 1–6 คน (พีคสุด 12 สัปดาห์เดียว) |
| Engagement | 367 MCQ attempts, 227 sessions, 25 long case — **ดี** |
| คลังข้อสอบจริง | **6,801 ข้อ** (ไม่ใช่ "1,300+" ตามที่บอทพูด — อัปเดต copy ได้) |
| กลุ่มเป้าหมายจริง | เตรียม NL1/NL2 (ส่วนใหญ่เลือก "both"), บางส่วน board |

### สิ่งที่ ads ทำพลาด (จากตัวเลขแคมเปญจริง)
1. **หว่านงบข้ามวัตถุประสงค์/ข้ามธุรกิจ** — บัญชีเดียวปน Jia CPR / AED / MorRoo รวม 39 แคมเปญ
2. **เผางบกับ Awareness** — `morroo 1 / morrow / morroo 1 – more active` รวม ~฿2,100 เพื่อ Reach อย่างเดียว CTR 0.13–0.21% = **เกือบศูนย์ค่า**
3. **Optimize ผิดจังหวะ** — แคมเปญ `MorRoo - Signup` (OUTCOME_LEADS / website registration) ได้ **428 คลิก → สมัครจริง 1 คน** (CPR ฿1,221) เพราะ conversion event น้อยเกินกว่าจะออกจาก learning phase (Meta ต้องการ ~50 conv/สัปดาห์ แต่เราได้สมัครรวมแค่ ~5/สัปดาห์) → อัลกอริทึม optimize ไม่ได้
4. **ทิ้ง warm pool** — Traffic แคมเปญสร้าง pool อุ่นมหาศาล (`ACLSmorroo` 2,709 LPV, `MORROO-Advice-Broad` 3,389 คลิก, `FirstAid` 3,990 LPV) แต่ **แคมเปญ retargeting ทุกตัว PAUSED / ฿0** = เงินที่หล่นหายตรงนี้
5. **Lead รั่วที่แชต** — 19 lead จาก Messenger/LINE ค้าง stage `new` ไม่เคยถูก nurture เป็นโค้ด (มีแค่ landing form ที่ออกโค้ดได้ 6, redeemed 1)

### สิ่งที่ "ทำได้ดี" และต้องต่อยอด
- **คลิกถูกมาก**: Traffic/LPV ของ MorRoo อยู่ที่ CPC ฿0.5–0.85, LPV ฿0.65–2.1 (ดีมากสำหรับไทย)
- **Lead form ถูกที่สุด**: `Morroo Free Trial` form ได้ 13 leads @ ฿72; เทียบ `CPR Book` lead ads ทำได้ 577 leads @ ฿9.37 → **on-Facebook lead form แปลงถูกกว่า website registration มากบนบัญชีนี้**
- **Tracking มีแล้ว**: Meta Pixel `966371002896288` + CAPI (`lib/meta/events-api.ts`) + TikTok CAPI + GA4 ครบ — แต่ต้อง verify (ดู Phase 0)

---

## 1. หลักคิดของแผนนี้

> **ห้าม scale งบตอนนี้** — ยังไม่เจอสูตรที่ work ด้วยซ้ำ การเพิ่มงบ = เผาเร็วขึ้น
> เป้าหมาย 4–6 สัปดาห์แรก = **หา combo (audience × creative × objective) ที่ได้ลูกค้าจ่ายต่ำกว่าต้นทุนเป้า** แล้วค่อย scale เฉพาะตัวที่ชนะ

กฎเหล็ก 3 ข้อ:
1. **Optimize ที่ event ที่มีปริมาณพอ** — ตอนนี้ conversion น้อย → เริ่มที่ event ถูก/บ่อย (Landing Page View, Lead form) ไม่ใช่ Purchase/Registration
2. **เก็บ warm pool ทุกชิ้น** → retarget = แหล่ง conversion ถูกที่สุดที่เรายังไม่แตะ
3. **1 โครงสร้างสะอาด** — แยกบัญชี/แคมเปญ MorRoo ออกจาก CPR/AED ให้ชัด, naming `[MR]_...`

---

## 2. Phase 0 — แก้ก่อนเติมงบ (สัปดาห์ที่ 0, ~3–5 วัน)

- [ ] **Verify Pixel + CAPI ด้วย Test Events** (Events Manager → Test Events)
  - `PageView` (middleware) ✓ — ยืนยันยิง
  - `CompleteRegistration` — ⚠️ ตอนนี้ server-side ยิงเฉพาะสมัครผ่าน **Google/LINE OAuth** (`app/auth/callback`, `app/api/auth/line/callback`); สมัคร email/password อาศัย client-side `fbq` อย่างเดียว → **เพิ่ม CAPI ฝั่ง server สำหรับ email signup ด้วย** และตรวจ dedup ด้วย `event_id` เดียวกัน
  - `Subscribe` / `Purchase` (billing webhook) — ยืนยันยิงพร้อม `value`/`currency` และ fbc/fbp
- [ ] **ปิด/เก็บกวาดแคมเปญเก่า** — pause ทุกตัวที่เป็น Awareness ของ MorRoo และตัวที่ spend>฿500 / 0 conv
- [ ] **สร้าง Custom Audiences** (ฐานของ retargeting + lookalike):
  - Website visitors 30 / 90 / 180 วัน (ทั้งเว็บ + แยก `/pricing`, `/exams`, `/longcase`)
  - Video viewers 50%+ (มีคลิปอยู่แล้ว)
  - FB Page + IG engagers 365 วัน
  - Lead form openers (ยังไม่ submit)
  - **Customer list upload**: อัป 51 users + 9 paying (hash email) → ฐาน Lookalike
- [ ] **สร้าง Lookalike 1% (TH)** จาก (ก) paying customers ถ้าถึงขั้นต่ำ ไม่ถึงใช้ (ข) all users + engagers
- [ ] **เช็ค Landing page** `/register` และ `/lp/free-trial` โหลด < 3 วิ บนมือถือ, CTA "สมัครฟรี" above the fold, มี UTM
- [ ] **จัดทัพตามปฏิทินสอบ** — NL1/NL2/board มี peak ของ demand ก่อนสอบ → อัดงบช่วง 6–8 สัปดาห์ก่อนรอบสอบ ลดช่วง low season

---

## 3. Phase 1 — Acquisition ที่ match ปริมาณ (สัปดาห์ 1–3, งบ ~฿300–500/วัน)

รัน **2 เครื่องยนต์คู่กัน** (ABO เพื่อคุม test ให้แต่ละ ad set ได้งบยุติธรรม):

### เครื่องยนต์ A — Instant Lead Form (พิสูจน์แล้วว่าถูกสุด)
- **Campaign**: `[MR]_Lead_InstantForm` — Objective **OUTCOME_LEADS**, on-Facebook Instant Form
- **ทำไม**: ไม่พึ่ง pixel volume, ต้นทุนต่อ lead ในบัญชีนี้ ฿9–72 → เก็บ email เข้า `leads` → ออก redeem code → nurture (ระบบมีอยู่แล้ว)
- **Form**: ถาม email + ชั้นปี + เป้าหมายสอบ (NL1/NL2/both) → map เข้า `exam_target`
- **เป้า**: cost/lead < ฿40, lead→redeem > 30%

### เครื่องยนต์ B — Traffic → Free Trial (เลี้ยง pixel + สร้าง pool)
- **Campaign**: `[MR]_Traffic_FreeTrial` — Objective **Traffic**, optimize **Landing Page Views**
- **ปลายทาง**: `morroo.com/register?utm_source=fb&utm_medium=paid&utm_campaign=free_trial`
- **ทำไม**: CPC ฿0.5–0.85 ถูกมาก, ป้อน pixel ให้สะสม event จนพอ optimize conversion ใน Phase 3
- **เป้า**: LPV < ฿2, registration rate ของ traffic นี้ (วัดผ่าน pixel)

### Ad sets (ใช้กับทั้ง A และ B)
1. **Broad** — TH, อายุ 20–35, ไม่ใส่ interest (ให้ Meta หา) ← 2024+ Meta แนะนำ broad + creative ดี
2. **Lookalike 1%** — จาก customer/engager list
3. **Interest** — นักศึกษาแพทย์ / โรงเรียนแพทย์ (ศิริราช จุฬาฯ รามาฯ มอ. มช. ขอนแก่น) / การแพทย์ / ใบประกอบวิชาชีพเวชกรรม

---

## 4. Phase 2 — เก็บ warm pool (เงินที่หล่นหาย — เริ่มทันทีคู่ Phase 1)

- **Campaign**: `[MR]_Retarget` — Objective **OUTCOME_LEADS** (หรือ SALES ถ้า pixel มี Subscribe พอ)
- **Audience** (รวมจาก Phase 0): website visitors 30–180d + video viewers 50%+ + lead-form openers + FB/IG engagers — **exclude ผู้ที่สมัครแล้ว/จ่ายแล้ว**
- **Offer**: โค้ดทดลองฟรี / รายเดือน ฿199 เดือนแรก / urgency ใกล้รอบสอบ
- **งบ**: ฿100–150/วัน (audience เล็กแต่ ROI สูงสุด)
- **แก้ leak ฝั่งแชต**: 19 leads ค้าง `new` จาก Messenger/LINE → ตรวจ bot intent + lead-followup cron ให้ดัน D1/D3/D6 จริง

---

## 5. Phase 3 — Scale เฉพาะตัวชนะ (สัปดาห์ 4+)

- เมื่อ ad set ใด CPA ต่ำกว่าเป้าต่อเนื่อง 3–5 วัน → duplicate เพิ่มงบ +20% หรือย้ายเข้า CBO
- เมื่อ pixel สะสม conversion พอ (~50/สัปดาห์) → ย้าย optimize เป็น **CompleteRegistration** แล้วค่อย **Subscribe/Purchase**
- ฆ่าทุก ad ที่ spend > ฿500 แต่ 0 conv; รีเฟรช creative ทุกครั้งที่ frequency > 3

---

## 6. KPI เป้าหมาย (อิงค่าจริงที่บัญชีนี้ทำได้)

| Metric | เป้า | หมายเหตุ |
|---|---|---|
| LPV cost | < ฿2 | เคยทำได้ ฿0.65–2.1 |
| CPC (link) | < ฿1.5 | เคยทำได้ ฿0.5–0.85 |
| Cost / Lead (form) | < ฿40 | เคย ฿9–72 |
| Lead → redeem code | > 30% | ตอนนี้ ~แค่ landing ที่ทำได้ |
| Cost / Registration | < ฿120 | ตอนนี้พังเพราะ tracking |
| CAC / paying (เดือนแรก ฿199) | < ฿199 blended | LTV รายปี ฿1,490 ช่วยได้ |
| Frequency / ad set | < 3 | เกินแล้วรีเฟรช creative |

---

## 7. งบประมาณแนะนำ

- **ระยะ test**: ฿400/วัน (~฿12,000/เดือน) แบ่ง A ฿180 / B ฿120 / Retarget ฿100
- **อย่าเพิ่งเพิ่ม** จนกว่าจะเจอ ad set ที่ CPA ถึงเป้า — แล้วค่อย scale ตัวนั้นตัวเดียว
- เทียบ benchmark: ที่ผ่านมา ~฿12k → 51 users / ฿3,776 รายได้ (ROAS ติดลบ) → เป้าระยะ test คือ **ดัน cost/registration ลงให้วัดได้** ก่อนพูดเรื่อง scale

---

## 8. Creative — มุมที่ควรยิง (ต่อยอดจาก `facebook-ads-template.md`)

ใช้ template เดิมได้ แต่ปรับให้ตรงข้อมูลจริง:
1. **Pain — "อ่านเยอะแต่ทำข้อสอบไม่ได้"** (CTR แนวนี้เคยสูง 2.6–5%)
2. **จุดต่างที่คู่แข่งไม่มี — Long Case AI (AI Patient + AI Examiner)** จำลองสอบ NL Step 3 เสมือนจริง ← differentiator แข็งสุด
3. **ความน่าเชื่อถือด้วยตัวเลขจริง — "ข้อสอบจริง 6,801 ข้อ + เฉลยละเอียด + AI ตรวจคำตอบทันที"**
4. **Free, ไม่ต้องใส่บัตร — ทำฟรี 5 ข้อ/สาขา** (ลด friction หัวกรวย)
5. **Social proof** — รีวิวผู้สอบผ่าน / before-after percentile (เก็บจากผู้ใช้ active 9 คน)
6. ทำ 3 sizes ต่อชิ้น (1:1, 4:5, 9:16) เน้น Reels/Story เพราะ CPM ถูก

> ปฏิทินสอบ = ตัวเร่ง: อัด urgency "เหลือ X สัปดาห์ก่อนสอบ NL" ช่วง 6–8 สัปดาห์ก่อนรอบสอบจริง

---

## 9. หมายเหตุระบบ (ใช้เครื่องมือที่มีอยู่แล้ว)

- โปรเจกต์มี **ad diagnostics ในตัว** (`ad_diagnostics_runs`, `ad_diagnostics_findings`, `ad_suggest_prs`, `lib/ads-page-suggester.ts`) — ใช้รัน health check แคมเปญ + auto-suggest landing page อัตโนมัติได้
- Lead/redeem/drip ครบ (`lib/leads.ts`, `lib/redeem.ts`, `signup_drip_sent`, cron `lead-followup`) — โฟกัสแก้ที่ **leak ของ Messenger/LINE leads**
- ก่อนยิงรอบใหม่: รัน Phase 0 checklist ให้ครบทุกข้อ
