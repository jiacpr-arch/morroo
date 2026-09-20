# สเปกวัด Conversion จริง — Meta Conversions API (CAPI)

**เวอร์ชัน 2** (21 ก.ย. 2026) — แก้จากเวอร์ชันแรกที่อ้างโฟลเดอร์ `ads-autopilot` ซึ่งตรวจสอบแล้วว่า**ไม่เคยมีอยู่จริง** (ค้น 4 วิธีทั่วเครื่องไม่เจอ) เวอร์ชันนี้ทำในที่ที่พิสูจน์แล้วว่ามีจริงและใช้งานได้

**ส่งให้:** Claude Code ที่ **`~/Dev/morroo`** (repo หลักบน GitHub `jiacpr-arch/morroo`, mirror ไป GitLab อัตโนมัติ, Vercel deploy จาก GitHub)

**หลักการที่ห้ามละเมิด:** เซลล์ยืนยันแล้วว่า**ไม่ต้องการเปลี่ยนวิธีขาย** — ยังคุยแชท รับโอนตรง รับสลิปเหมือนเดิมทุกอย่าง งานนี้ทำงานอยู่ "เบื้องหลัง" เท่านั้น ห้ามเสนอ payment link หรือ web checkout ใดๆ

**อย่าสร้างซ้ำ:** repo นี้มีระบบ `ads-autofix` (วินิจฉัย+pause โฆษณา, `lib/ads-diagnostics.ts`) อยู่แล้ว และเพิ่งแก้บั๊กเสร็จไปใน PR #430 — งาน CAPI นี้เป็นคนละเรื่อง (ส่ง conversion event ไม่ใช่วินิจฉัย/pause) แต่ **ใช้ pixel ID, token, และ pattern การเรียก Meta API แบบเดียวกับที่ `lib/ads-diagnostics.ts` ใช้อยู่แล้ว** — เปิดไฟล์นั้นดูก่อนเริ่มเขียน จะได้ไม่ต้อง reverse-engineer credential ใหม่

---

## เป้าหมาย

ตอนนี้ระบบเห็นแค่ **"มีคนทักแชทกี่คน"** (Messaging conversations started) ไม่เห็นเลยว่า**ใครจ่ายเงินจริง** — ทำให้ต้องเดาจากตัวเลขที่ไม่สมบูรณ์ตลอด และ `ads-autofix` เองก็ตัดสิน pause จากสัญญาณเดียวกันนี้ (lead, CPL) ซึ่งไม่ใช่ยอดขายจริง

เป้าหมาย: ส่ง **Purchase event** กลับไป Meta ทุกครั้งที่มีคนจ่ายเงินจริง (ปิดในแชทหรือผ่านเว็บก็ตาม) เพื่อให้:
1. Meta (Andromeda/Lattice) เรียนรู้จาก "คนที่จ่ายเงินจริง" แทนที่จะ optimize จากแค่ "คนที่ทัก"
2. ในอนาคต `ads-autofix` ปรับให้ใช้ signal "ยอดขายจริง" แทน "lead" ได้ (ไม่ใช่งานนี้ แต่เป็นเหตุผลที่ทำ CAPI ก่อน)

---

## ขั้นที่ 0: สำรวจของเดิมก่อนเขียนโค้ดใหม่ (บังคับ ห้ามข้าม)

1. เปิด `lib/ads-diagnostics.ts` อ่านว่าใช้ token/pixel ID จากไหน (`META_SYSTEM_USER_TOKEN`, fallback `app_settings.facebook_user_token`) — **CAPI ต้องใช้ token ตัวเดียวกัน** ไม่สร้างใหม่
2. หา **ระบบลงทะเบียนนักเรียน/ออกใบประกาศ** ของ jiacpr.com — ยังไม่เคยยืนยัน path ที่แน่ชัด ลองหาด้วย:
   ```
   mdfind "certificate" -onlyin ~/Dev
   mdfind "certificate" -onlyin ~/Projects
   gh repo list jiacpr-arch --limit 30
   ```
   ถ้าไม่เจอ ให้ถาม user ตรงๆ ว่า repo ชื่ออะไร ก่อนเริ่ม Part A — **อย่าสมมติชื่อ**
3. เช็ก Supabase project ของ morroo (`payment_orders`, `profiles` หรือ schema ที่ใกล้เคียง) ว่ามี webhook จาก Omise อยู่แล้วหรือยัง สำหรับ Part C

---

## Part A — คอร์ส CPR/First Aid (ปิดในแชท + โอนตรง)

**อัปเดต 21 ก.ย.:** ระบบใบประกาศ "จริง" กำลังถูกสร้างอยู่ที่ `class.jiacpr.com`
(repo `~/Dev/jia-learning-hub`) โดย Codex ไม่ใช่ Claude Code — ยังไม่เสร็จ
ห้าม Claude Code เข้าไปแก้ repo นั้นตอนนี้ กันชนงานกับ Codex

**แนวทางที่เลือก (ทาง B):** แทนที่จะรอระบบใบประกาศเสร็จ ให้ทำฟอร์มบันทึก
ยอดขายแบบเบา แยกต่างหาก ใน `~/Dev/morroo` (repo เดิมที่ทำ Part C ไปแล้ว)
เป้าหมายคือรู้ว่า "ใครจ่ายเงินจริง" ให้เร็วที่สุด ไม่ต้องรอใบประกาศสวยงาม
ใบประกาศเป็นคนละเรื่อง ทำทีหลังได้

### ขั้นที่ 1: สร้างฟอร์มบันทึกยอดขาย (ของใหม่ทั้งหมด)

หน้าเดียว ป้องกันด้วยรหัสผ่านง่ายๆ หรือ auth ที่มีอยู่แล้วใน morroo
(เซลล์ใช้มือถือกรอกหลังปิดยอด)

**ฟิลด์:**
- ชื่อลูกค้า
- เบอร์โทร (บังคับ — ใช้ hash ส่ง CAPI)
- คอร์สที่ซื้อ (dropdown: CPR ฿500 / First Aid ฿999 / ALS ฿5,900)
- ราคาที่จ่ายจริง (default ตามคอร์ส แก้ไขได้ถ้ามีส่วนลด)
- ช่องทางที่มา (dropdown: Facebook / LINE / เดินมาเอง / เพื่อนแนะนำ) — ไม่บังคับ
- วันที่ (default วันนี้)

**เก็บลง Supabase table ใหม่** ชื่อ `course_sales` (ไม่ต้องผูกกับตารางเดิม
ของ Morroo — เป็นระบบแยก)

### ขั้นที่ 2: ยิง CAPI ทันทีที่บันทึกสำเร็จ

หลัง insert แถวใหม่ → เรียก `sendMetaEvent()` (ฟังก์ชันเดียวกับที่ใช้ใน
Part C, `lib/meta/events-api.ts`) ส่ง:

```
event_name: "Purchase"
event_time: (unix timestamp ตอนบันทึก)
action_source: "system_generated"  // รองรับแล้วใน PR #431
user_data:
  ph: sha256(เบอร์โทรลูกค้า)  // normalize: ตัดช่องว่าง/ขีด, เติม 66 นำหน้าแทน 0
custom_data:
  currency: "THB"
  value: (ราคาที่กรอก)
  content_name: (ชื่อคอร์ส)
pixel_id: "966371002896288"
// ใช้ META_CAPI_ACCESS_TOKEN ตัวเดิม (แยกจาก Marketing API token
// ตามที่ตัดสินใจแล้วใน PR #431 — อย่ารวม token)
```

### ขั้นที่ 3: เชื่อมกับระบบใบประกาศในอนาคต (ไม่ใช่งานตอนนี้ — บันทึกไว้)

เมื่อ Codex ทำ jia-learning-hub เสร็จ ให้พิจารณา 2 ทาง:
- ย้าย logic CAPI จาก course_sales ไปเสียบที่ระบบใบประกาศแทน (จุดเดียว)
- หรือให้ทั้งสองจุดยิง CAPI คู่กัน โดยใช้ event_id เดียวกัน
  (เช่น เบอร์โทร+วันที่ hash) กัน dedup

ไม่ต้องตัดสินใจตอนนี้ — แค่บันทึกไว้เป็นงานต่อเนื่องในอนาคต

### ขั้นที่ 4: ช่องทางที่มา (มีอยู่แล้วในฟอร์มขั้นที่ 1)

ใช้สำหรับรายงานภายใน ไม่กระทบ CAPI

### สิ่งที่ทำจริง (อัปเดตหลังส่งงาน)

| ขั้น | ไฟล์ |
| --- | --- |
| 1 — ฟอร์ม + ตาราง | `supabase/migrations/20260921_course_sales.sql`, `lib/course-sales.ts`, `app/(morroo)/admin/course-sales/page.tsx` |
| 2 — ยิง CAPI | `app/api/admin/course-sales/route.ts` |
| 3 — dedup ในอนาคต | `courseSaleEventId()` ใน `lib/course-sales.ts` |
| 4 — ช่องทางที่มา | คอลัมน์ `source_channel` |

สามจุดที่ตัดสินใจต่างจากสเปกเล็กน้อย พร้อมเหตุผล:

1. **auth ใช้ `requireAdmin()` ที่มีอยู่แล้ว ไม่ทำรหัสผ่านแยก** — สเปกเปิดทาง
   ไว้ทั้งสองแบบ ตัวที่มีอยู่ผูกกับ `profiles.role = 'admin'` จึงไม่ต้องมี
   ความลับเพิ่มอีกตัวให้หลุด และใช้ pattern เดียวกับหน้า admin อื่นทั้งหมด
2. **ราคาหยิบจาก catalog ฝั่ง server ไม่เชื่อตัวเลขจาก browser** — ฟอร์มส่งมาแค่
   `courseId` ส่วน `priceThb` เป็น override สำหรับส่วนลดเท่านั้น
3. **เพิ่มคอลัมน์ `capi_sent_at` / `capi_error`** — ไม่ได้อยู่ในสเปก แต่ถ้า Meta
   ล่มตอนกดบันทึก ยอดขายต้องไม่หายไปด้วย คอลัมน์นี้ทำให้แถวที่ยังไม่ถึง Meta
   ตามเก็บทีหลังได้ และ `sendMetaEvent()` ถูกแก้ให้คืน `boolean` เพื่อรู้ผลจริง
   (เดิมคืน `void` — กลืน error เงียบ จึงแยกไม่ออกว่าถึงหรือไม่ถึง)

## Part B — สินค้า/บริการ AED (jia1669.com)

ปิดการขายแบบเดียวกับคอร์ส — **ใช้ logic เดียวกับ Part A**

- Pixel: `751248198005586` (ของ jia1669.com — คนละตัวกับ Part A/C)
- ราคาไม่คงที่ (เช่า/ขาย/เช่าซื้อ) — `value` ดึงจากยอดขายจริง (FlowAccount quotation ถ้ามี ชื่อ sales_name "ดลภาค" ที่เคยเห็น) ไม่ hardcode
- **ห้ามแก้เว็บ jia1669.com บน MakeWebEasy** — งานนี้ทำฝั่ง backend/ระบบบัญชีเท่านั้น

---

## Part C — Morroo / CaseGame (จ่ายผ่านเว็บอยู่แล้ว — ทำก่อน ง่ายสุด)

### ขั้นที่ 1: ตรวจสอบ

Morroo ใช้ Omise — เช็ก webhook ตอนจ่ายเงินสำเร็จ (ตามขั้นที่ 0 ข้อ 3) มีอยู่แล้วหรือยัง

### ขั้นที่ 2: ต่อเข้า CAPI

ที่ webhook หรือจุดที่ update `payment_orders.status = 'approved'` เพิ่ม call:

```
event_name: "Purchase"
event_time: (unix timestamp)
action_source: "website"
event_source_url: (URL หน้าที่กดจ่ายเงิน)
user_data:
  em: sha256(อีเมล)  // ถ้ามี
  ph: sha256(เบอร์โทร)  // ถ้ามี
  fbc: (ค่า fbclid cookie — สำคัญมาก เพราะมาจากทราฟฟิกโฆษณาโดยตรง)
custom_data:
  currency: "THB"
  value: (ยอดที่จ่ายจริง)
pixel_id: "966371002896288"
```

**ย้ำ:** ถ้า `fbc`/`fbclid` capture ไม่ครบ ให้แก้จุดนั้นพร้อมกัน — ไม่งั้น CAPI ไม่มีประโยชน์เลยเพราะจับคู่กับคนจากโฆษณาไม่ได้

### ขั้นที่ 3: Deduplication

ยิง Pixel ฝั่ง browser คู่กับ CAPI ฝั่ง server โดยใช้ **`event_id` เดียวกันทั้งคู่**

---

## เกณฑ์ตรวจรับ (ทุก Part)

1. ทดสอบด้วย **Meta Events Manager → Test Events** ก่อน — ต้องเห็น `Purchase` พร้อม match quality (matched ไม่ใช่แค่ received)
2. ทำใน branch ใหม่ (ชื่อแบบ `feat/capi-<part>`) — **ห้าม push ตรงเข้า main, ห้าม deploy production เอง** (ใช้ pattern เดียวกับ PR #430: branch → PR → CI เขียว → Preview → user ตรวจ → merge เอง)
3. รายงานกลับ: event ไหนยิงจากจุดไหน, match rate ประมาณจาก test events, path ของระบบลงทะเบียนที่เจอจริง (Part A)

## ห้ามทำ

- ห้ามเสนอ/สร้าง payment link หรือเปลี่ยนขั้นตอนขายให้เซลล์ทำต่างจากเดิม
- ห้ามแก้เว็บ jia1669.com บน MakeWebEasy
- ห้ามสร้าง Conversion Action ใหม่ใน Google Ads — งานนี้เป็นฝั่ง Meta CAPI เท่านั้น
- ห้ามเก็บเบอร์โทร/อีเมล plain text ส่งออกนอกระบบ — hash (SHA-256) ก่อนส่งทุกครั้ง
- **ห้ามสร้างโฟลเดอร์/repo ใหม่สำหรับงานนี้** — ทำใน `~/Dev/morroo` เท่านั้น (Part B แม้เป็นของ jia1669.com ก็ยังเขียน integration code ที่นี่ เพราะเก็บ credential/pattern ไว้ที่เดียว จนกว่าจะมี repo ของ jia1669 ที่ยืนยันแล้วว่ามีจริง)

---

## ลำดับที่แนะนำ

1. **ขั้นที่ 0** ก่อนเสมอ — ห้ามข้าม
2. **Part C (Morroo)** — ง่ายสุด ไม่ต้องรอคำตอบใคร
3. **Part A (คอร์ส)** — ถามคำถามขั้นที่ 1 ก่อนเขียนโค้ด
4. **Part B (AED/jia1669)** — ทำหลังสุด ซับซ้อนกว่าเพราะราคาไม่คงที่ และอาจต้องหา repo ของ jia1669 เพิ่มถ้ามี
