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

### ขั้นที่ 1: ถามก่อนเริ่มเขียนโค้ด

หาระบบลงทะเบียนตามขั้นที่ 0 ข้อ 2 ได้แล้ว **ถามเจ้าของ (user) คำถามนี้ก่อน:**

> "ตอนนี้เซลล์ลงชื่อนักเรียนในระบบตอนไหน — (ก) ทันทีที่ลูกค้าโอนเงินมา หรือ (ข) รอถึงวันเรียนจริงถึงลงทะเบียน"
>
> ถ้า (ก) → ทำ CAPI ได้ทันทีตามสเปกนี้ ข้อมูลตรงเวลา
> ถ้า (ข) → CAPI จะ delay หลายวันถึงสัปดาห์ (ยังทำได้ แต่ Meta optimize ได้ช้ากว่า) — แจ้งข้อเสียนี้ให้ user รับทราบก่อน แต่ทำต่อได้เลยถ้า user โอเค

### ขั้นที่ 2: จุดที่ต้องแก้

หาจุดในระบบที่บันทึก "นักเรียนคนใหม่ + จ่ายเงินแล้ว" → เพิ่ม logic หลัง insert สำเร็จ → เรียก Meta Conversions API ส่ง event `Purchase`

### ขั้นที่ 3: field ที่ต้องส่ง

```
event_name: "Purchase"
event_time: (unix timestamp ตอนบันทึก)
action_source: "system_generated"  // ปิดในแชท ไม่ใช่ผ่านเว็บ
user_data:
  ph: sha256(เบอร์โทรลูกค้า)  // normalize ก่อน hash: ตัดช่องว่าง/ขีด, ใส่ 66 นำหน้าแทน 0
custom_data:
  currency: "THB"
  value: (ราคาคอร์สจริง — 500 / 999 / 5900 แล้วแต่คอร์ส)
  content_name: (ชื่อคอร์ส)
pixel_id: "966371002896288"
access_token: (ตัวเดียวกับที่ ads-diagnostics.ts ใช้ — ดูขั้นที่ 0)
```

**สำคัญ:** normalize เบอร์โทรให้ตรงรูปแบบเดียวกับ pixel ฝั่งเว็บเกม (cpr.morroo.com) ที่มีอยู่แล้ว ไม่งั้น Meta จับคู่ไม่ได้

### ขั้นที่ 4: ช่อง "มาจากช่องทางไหน" (ไม่บังคับ)

ถ้าเพิ่มง่าย เพิ่มช่องเดียว: ทัก Facebook / LINE / เดินมาเอง / เพื่อนแนะนำ — ไม่กระทบ CAPI แต่ช่วยอ่านรายงานภายใน

---

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
