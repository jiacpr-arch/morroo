# จัดทัพแคมเปญ + ปฏิทินสอบ — MorRoo H2/2026

> เอกสารปฏิบัติ (execution) ต่อจาก `docs/ads-plan-2026H2.md`
> อัปเดต 2026-06-22 — ระบุ **Custom Audience จริงที่สร้างแล้ว** + โครงสร้างแคมเปญที่พร้อมกดสร้าง + ปฏิทินอัดงบตามรอบสอบ
> บัญชี: `act_10153192786713173` · Pixel/Dataset `morroo` = `966371002896288` (ยิงจริงทั้ง browser + CAPI)

---

## 1. คลัง Custom Audiences (สร้างแล้ว ✅)

สร้างบน pixel `966371002896288` — เป็นฐานของ Retargeting (Phase 2) และ seed ของ Lookalike

| Audience | ID | Retention | ใช้ทำอะไร |
|---|---|---|---|
| ผู้เข้าเว็บทั้งหมด 30 วัน (ของเดิม) | `52567800284597` | 30 วัน | retarget ร้อนสุด |
| `[MR] เว็บทั้งหมด 90 วัน` | `52569112192597` | 90 วัน | retarget |
| `[MR] เว็บทั้งหมด 180 วัน (seed)` | `52569111931997` | 180 วัน | **seed Lookalike** + retarget กว้าง |
| `[MR] ผู้เข้า /pricing 180 วัน` | `52569484597597` | 180 วัน | high intent — ปิดการขาย |
| `[MR] ผู้เข้า /register 180 วัน` | `52569484751797` | 180 วัน | สมัครค้าง — ดันให้จบ |
| `[MR] ผู้เข้า /exams 180 วัน` | `52569112726797` | 180 วัน | สนใจเนื้อหา |
| `[MR] ผู้เข้า /longcase 180 วัน` | `52569112890597` | 180 วัน | จุดต่าง Long Case AI |
| `[MR] ผู้มีปฏิสัมพันธ์กับเพจ 365 วัน` | `52579627674597` | 365 วัน | FB engager (event `page_engaged`) — retarget + seed LAL |
| `[MR] ผู้มีปฏิสัมพันธ์กับ IG 365 วัน` | `52580720825797` | 365 วัน | IG engager (event `ig_business_profile_all`) — retarget + seed LAL |

> **Page MorRoo** = `1014545448419881` (morroo.com) · **IG** = `17841425921611769` (@morroodee) · **pixel** = `966371002896288` — ทั้งหมด owned by Jiacpr, เชื่อมเข้า ad account แล้ว

### ยังไม่ได้สร้าง — ติดเงื่อนไข (ทำต่อเมื่อพร้อม)
- **Lookalike 1% (TH)** — เครื่องมือ MCP สร้าง LAL ไม่ได้ ต้องสร้างในหน้า Ads Manager เอง
  - seed: `[MR] เว็บทั้งหมด 180 วัน` (`52569111931997`) หรือ `[MR] เพจ engager 365 วัน` (`52579627674597`)
  - ⚠️ ตอนนี้ pool เล็กกว่าเกณฑ์ขั้นต่ำ 100 คนของ Meta → **รอสะสม ~2–4 สัปดาห์หลังเริ่มยิง Traffic** แล้วค่อยสร้าง
- **Video viewers 50%+** — ต้องเลือกคลิปในหน้า Ads Manager (video engagement CA ระบุวิดีโอเป็นรายตัว) → ทำใน UI
- **Lead-form audiences** — รอ Page accept **Leadgen ToS** + แคมเปญ A เริ่มเก็บ lead ก่อน (ยังไม่มีฟอร์มให้ดึง)
- **Customer list (51 users / 9 paying)** — ต้องดึง email hash จาก Supabase; 51 คนต่ำกว่าเกณฑ์ match ที่ดี → คุณภาพ seed ต่ำ แนะนำรอฐานโต

---

## 2. จัดทัพแคมเปญ (โครงสร้างพร้อมกดสร้าง)

> หลักเดิม: **ห้าม scale** จนกว่าจะเจอ ad set ที่ CPA ถึงเป้า · naming `[MR]_...` · แยกขาดจาก CPR/AED
> โครงสร้าง ABO (งบที่ระดับ ad set) เพื่อ test แต่ละ audience อย่างยุติธรรม

### แคมเปญ A — `[MR]_Lead_InstantForm` (ถูกสุด พิสูจน์แล้ว)
- Objective: **OUTCOME_LEADS** · On-Facebook Instant Form (ไม่พึ่ง pixel volume)
- ⚠️ ก่อนยิง: Page ต้อง **accept Leadgen ToS** ก่อน (ตอนนี้ยังไม่ได้ทำทุก Page)
- งบรวม ~฿180/วัน
- Form: email + ชั้นปี + เป้าหมายสอบ (NL1 / NL2 / both) → map เข้า `exam_target` → ออก redeem code → drip

| Ad set | Audience | งบ/วัน |
|---|---|---|
| A1 Broad | TH, 20–35, ไม่ใส่ interest | ฿80 |
| A2 Lookalike 1% | LAL จาก seed (รอสร้าง) | ฿60 |
| A3 Interest | นศ.แพทย์ / รร.แพทย์ (ศิริราช จุฬาฯ รามาฯ มอ. มช. ขอนแก่น) / ใบประกอบวิชาชีพเวชกรรม | ฿40 |

### แคมเปญ B — `[MR]_Traffic_FreeTrial` (เลี้ยง pixel + สร้าง pool) — ✅ สร้างแล้ว (PAUSED)
- **campaign_id** `52580729960597` · Objective **OUTCOME_TRAFFIC** · optimize **LANDING_PAGE_VIEWS** · สถานะ **PAUSED**
- ปลายทาง: `morroo.com/register?utm_source=fb&utm_medium=paid&utm_campaign=free_trial`
- งบรวม ~฿120/วัน — เป้า LPV < ฿2 (เคยทำได้ ฿0.65–2.1)
- **Ad set B1 Broad** = `52580833488197` (PAUSED) · TH อายุ 20–35 (ปิด Advantage+ Audience ให้เป็นช่วงตายตัว ตามกฎไทยห้ามยิง <20) · งบ ฿120/วัน · autobid · billing IMPRESSIONS
- ยังไม่ได้สร้าง: **ad + creative** (รอเลือกรูป/โพสต์ + copy angle) · ad set B2 Lookalike (รอ LAL) · B3 Interest (รอ interest IDs)

### แคมเปญ C — `[MR]_Retarget` (เงินที่หล่นหาย — เริ่มเมื่อ pool โตพอ)
- Objective: **OUTCOME_LEADS** (เปลี่ยนเป็น SALES เมื่อ pixel มี Subscribe พอ)
- งบ ฿100/วัน · audience เล็กแต่ ROI สูงสุด
- **Include** (รวมเป็น 1 ad set): `90 วัน` + `/pricing` + `/register` + `/exams` + `/longcase`
- **Exclude**: ผู้สมัครแล้ว/จ่ายแล้ว (ใช้ customer list เมื่ออัปได้ หรือ pixel CompleteRegistration/Subscribe)
- Offer: โค้ดทดลองฟรี / รายเดือน ฿199 เดือนแรก / urgency ใกล้รอบสอบ

> งบรวมระยะ test = **฿400/วัน** (A ฿180 / B ฿120 / Retarget ฿100) — ตรงกับ `ads-plan-2026H2.md` §7

---

## 3. ปฏิทินสอบ → ตารางอัดงบ

> **ตรรกะ:** demand พุ่งก่อนรอบสอบ → **อัดงบหนัก 6–8 สัปดาห์ก่อนวันสอบ**, urgency creative "เหลือ X สัปดาห์", แล้วลดงบช่วง low season
> ⚠️ ปี **2569 (2026) เป็นปีสุดท้ายที่แยกสอบ NL-1 / NL-2** (ปี 2570 รวมเป็นข้อสอบบูรณาการเดียว)

### ⚠️ วันสอบจริง — ต้องยืนยันจาก [cmathai.org](https://cmathai.org/news)
ดึงวันแม่นยำจากเว็บ ศรว. ไม่ได้ (เว็บบล็อก) — ตารางล่างเป็น **กรอบรอบปกติ ใส่วันจริงทับได้เลย**
ข้อมูลที่ยืนยันแล้ว: NL-2 ครั้งที่ 2/2569 ถูกเลื่อนเป็น **19 เม.ย. 2026** (อยู่ครึ่งปีแรก H1)

| รอบสอบ (H2/2026) | เดือนสอบโดยประมาณ* | หน้าต่างอัดงบ (6–8 สัปดาห์ก่อน) | กลุ่มเป้า/creative |
|---|---|---|---|
| **NL-1 ครั้งที่ 3** | ~ก.ย. 2026 | ก.ค.–ก.ย. | ปี 3, basic science, urgency |
| **NL-2 ครั้งที่ 3** | ~พ.ย.–ธ.ค. 2026 | ต.ค.–ธ.ค. | ปี 6/extern, clinical, Long Case AI |
| **NL-3 / OSCE** | ตามรอบ รร.แพทย์ | ก่อนรอบ 6–8 สัปดาห์ | เน้น Long Case AI (differentiator) |

\* เดือนเป็นค่าประมาณจากรอบปกติของ ศรว. — **กรอกวันจริงก่อนตั้ง schedule แคมเปญ**

### แอ็กชันต่อปฏิทิน
- [ ] เจ้าของยืนยันวันสอบ NL-1/NL-2/NL-3 รอบ H2 2026 จาก cmathai.org → เติมในตาราง
- [ ] ตั้ง start/stop date ของแคมเปญให้ peak ตรงหน้าต่างอัดงบ
- [ ] เตรียม creative urgency ชุด "เหลือ X สัปดาห์ก่อนสอบ NL" (ทำ 1:1 / 4:5 / 9:16)
- [ ] ช่วง low season (ไม่มีรอบใกล้): ลดงบเหลือเฉพาะ Retarget + Traffic บำรุง pixel

---

## 4. ลำดับงานถัดไป (checklist)

1. [x] ~~เจ้าของส่ง Page ID~~ → ได้แล้ว (`1014545448419881`) · สร้าง Page engager 365 วันแล้ว
2. [ ] **Accept Leadgen ToS** บน Page MorRoo → ปลดล็อกแคมเปญ A (Instant Form) + lead-form audience
3. [ ] เริ่มแคมเปญ B (Traffic) ก่อน — สะสม pixel + ขยาย Custom Audience
4. [ ] รอ pool ≥ 100 → สร้าง **Lookalike 1%** จาก seed `52569111931997` (ทำในหน้า Ads Manager)
5. [ ] อัป **customer list** เมื่อฐานโต/Supabase พร้อม → seed LAL คุณภาพสูง
6. [ ] เปิด **Retarget (C)** เมื่อ audience members พอ
7. [ ] กรอกวันสอบจริง → ตั้งปฏิทินอัดงบ
