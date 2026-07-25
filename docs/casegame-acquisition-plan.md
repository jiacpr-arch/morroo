# แผน: ใช้ "เกมเคส" เป็นหัวกรวยดึงลูกค้าผ่านการยิงแอด

> ต่อยอดจาก `docs/ads-plan-2026H2.md` และ `docs/ads-campaign-setup-2026H2.md`
> เอกสารนี้ = กลยุทธ์ + สถานะงานฝั่งระบบ · เขียน 2026-07-24

---

## 1. ปัญหาที่กำลังแก้

`docs/ads-plan-2026H2.md` สรุปไว้ว่าเราใช้งบแอดไป ~฿12,000 แลกผู้ใช้ 51 คน / รายได้ ฿3,776 (ROAS ติดลบ) และระบุสาเหตุรากไว้ที่ข้อ 3:

> **Optimize ผิดจังหวะ** — Meta ต้องการ ~50 conversion/สัปดาห์ แต่เราได้สมัครรวมแค่ ~5/สัปดาห์ → อัลกอริทึม optimize ไม่ได้

แคมเปญ `MorRoo - Signup` เลยได้ **428 คลิก → สมัครจริง 1 คน** (CPR ฿1,221)

**เกมเคสแก้ตรงจุดนี้** เพราะ "เริ่มเล่นเกม" เกิดบ่อยกว่า "สมัครสมาชิก" หลายเท่า — เป็น conversion event ตัวแรกที่มีปริมาณพอให้ Meta ออกจาก learning phase ได้จริง

เหตุผลประกอบอีกสองข้อ:
- **เล่นได้โดยไม่ต้องล็อกอิน** — friction ต่ำกว่า `/register` มาก และเป็นข้อได้เปรียบที่ห้ามทิ้ง
- **คนเล่นจบเกม = warm pool คุณภาพสูงสุดที่เรามี** → ป้อนแคมเปญ C `[MR]_Retarget` ที่ตอนนี้ paused ใช้งบ ฿0

---

## 2. สิ่งที่ทำไปแล้ว (ฝั่งระบบ)

ก่อนหน้านี้ตัวเกม **ไม่ยิง analytics event เลยแม้แต่ตัวเดียว** — ยิงแอดไปก็วัดอะไรไม่ได้ ตอนนี้อุดแล้ว

### 2.1 Event ที่ยิงจากตัวเกม

ใช้ชื่อ event เดียวครอบทั้ง Code Blue (ACLS) และเกมเคส แล้วแยกด้วย prop `category`
(`components/sim/SimRunner.tsx` เรียก payload builder ใน `lib/sim/track.ts`)

| Event | ยิงเมื่อ | ใช้ดูอะไร |
|---|---|---|
| `casegame_start` | กด "รับเคส" / "เล่นอีกครั้ง" | ปริมาณหัวกรวย · `is_replay` แยกเล่นซ้ำ |
| `casegame_first_decision` | ตัดสินใจข้อแรก | สัญญาณ "ไม่ใช่คนเปิดผ่าน" |
| `casegame_complete` | จบเคส | เกรด/แพ้ชนะ/เวลาจริง (`duration_sec`) |
| `casegame_cta_view` | ฟอร์มขออีเมลโผล่บนจอ debrief | **ตัวหารของขั้นสุดท้าย** |
| `casegame_cta_click` | คลิก CTA ท้ายเกม | แยก `lead_form` / `login` / `pricing` |
| `casegame_lead` | เก็บอีเมลสำเร็จ | **ตัวชี้ขาดของแคมเปญ** |

> `casegame_lead` ยิงคู่กับ `lp_lead_form_submit` โดยตั้งใจ — ตัวหลังทำให้ยอด lead รวมของทั้งระบบยังครบ ส่วนตัวแรกให้หน้าแอดมินนับ lead จากเกมได้โดยไม่ต้องดึงคอลัมน์ `properties` มาทั้งก้อน (query จำกัด 50k แถว)

ทั้งหมดข้ามเมื่ออยู่ในโหมด `practice` (admin playtest) จะได้ไม่ปนสถิติจริง

> **`run_id` ติดไปกับทุก event ของเกม** (`start` / `first_decision` / `complete` / `cta_view` / `cta_click` / `lead`) — 1 รอบเล่น = 1 id
> จำเป็นเพราะสองเรื่อง: (1) โหมด autostart ทำให้การ **รีโหลดหน้า** นับเป็น `start` ใหม่ทุกครั้ง แยกจากการกด "เล่นอีกครั้ง" ไม่ออกถ้าไม่มี id, (2) ถ้าไม่มี id การจับคู่ `start` กับ `complete` ทำได้แค่ระดับ session+slug ซึ่งพังทันทีที่คนเล่นเคสเดิมซ้ำ
>
> ```sql
> -- funnel ที่ dedupe การรีโหลดออกแล้ว
> select count(distinct properties->>'run_id') filter (where event_name='casegame_start')      as starts,
>        count(distinct properties->>'run_id') filter (where event_name='casegame_cta_view')   as saw_form,
>        count(distinct properties->>'run_id') filter (where event_name='casegame_lead')       as leads
> from analytics_events where created_at > now() - interval '7 days';
> ```

> **ทำไมต้องมี `cta_view`:** ฟอร์มขออีเมลโผล่เฉพาะคนที่ **เล่นจบ + ยังไม่ล็อกอิน + ไม่ใช่โหมดซ้อม** ถ้าวัดแต่ `casegame_lead` แล้วเห็นเลข 0 จะแยกไม่ออกเลยว่า "ไม่มีใครเล่นถึง", "เห็นแล้วไม่กรอก" หรือ "ฟอร์มพัง" — ซึ่งเป็นสามปัญหาที่แก้คนละทางกันหมด

### 2.2 ส่ง conversion เข้า Meta

`app/api/track/casegame/route.ts` — ยิง **server-side ทางเดียว** ไม่มี browser copy จึงไม่ต้อง dedupe และรอด ad blocker (middleware เคยพบว่า ~97% ของคลิกโฆษณามองไม่เห็นจาก browser pixel)

ใช้ standard event `ViewContent` + convention ของ `content_name` แทนการเพิ่ม custom event เพราะ Meta สร้าง **Custom Conversion** จาก standard event + กติกา `content_name`/`content_type` ได้อยู่แล้ว และใช้เป็น optimization target ได้เต็มรูปแบบ

- `content_type` = `casegame`
- `content_name` = `casegame_start:<slug>` / `casegame_complete:<slug>`
- `event_id` = `casegame:<start|complete>:<runId>` (1 รอบเล่น = 1 id → beacon ยิงซ้ำไม่ถูกนับสอง conversion)

กันสแปม: rate limit ต่อ IP (40/นาที) + ตรวจว่า `slug` เป็นเคสที่มีอยู่จริง — ถ้าไม่กัน ใครก็ยิง conversion ปลอมจนอัลกอริทึมโฆษณาเรียนรู้ผิดได้

### 2.3 CTA ท้ายเกม

เดิมหน้า debrief มีแค่ลิงก์ "เข้าสู่ระบบ เพื่อเก็บ XP" ตัวเล็กๆ — ขอให้คนแปลกหน้าสมัครสมาชิกเพื่อแลก XP ไม่คุ้มในสายตาเขา ทั้งที่จังหวะเพิ่งเล่นจบคือจุด intent สูงสุดของทั้ง funnel

ตอนนี้เป็น `components/sim/DebriefLeadCta.tsx` — เก็บอีเมลตรงนั้นเลย แลก **ข้อสอบจริงฟรี 10 ข้อ** (`reward_choice: bundle_10q` ผูกกับบริบทเกม และ commitment ต่ำกว่าสมาชิกรายเดือน) แล้วส่งต่อเข้าเส้นทางเดิมทั้งหมด: `/api/leads/create` → `issueRedeemCode` → อีเมลโค้ด → cron `lead-followup` (D1/D3/D6) ไม่ต้องสร้างระบบใหม่

ยังคงลิงก์ "เข้าสู่ระบบ" ไว้เป็นทางรองสำหรับคนที่มีบัญชีอยู่แล้ว

### 2.4 Attribution

`utm_campaign` / `utm_content` อ่านจาก URL ที่หน้า `/sim/[slug]` และส่งต่อไปติดกับ lead
หน้ารวม `/casegame` ก็ส่ง utm ต่อไปยังลิงก์เข้าเล่นด้วย — ไม่งั้นเทียบปลายทางโฆษณาสองแบบ (ข้อ 3.2) ไม่ได้เลย

### 2.5 รายงาน

`analytics_events` ไม่มี allowlist ฝั่งเขียน แต่ฝั่งอ่าน hardcode ชื่อ event ไว้ จึงลงทะเบียนเพิ่มที่:
- `app/(morroo)/admin/analytics/page.tsx` — การ์ด "เกมเคส — funnel" (เริ่มเล่น → ตัดสินใจข้อแรก → เล่นจบ → **เห็นฟอร์ม** → ให้อีเมล)
  ขั้น "ให้อีเมล" หารด้วย **ยอดเห็นฟอร์ม** ไม่ใช่ยอดเล่นจบ — ยอดเล่นจบรวมคนที่ล็อกอินอยู่แล้วซึ่งไม่เคยเห็นฟอร์ม ทำให้ conversion ต่ำกว่าจริงเสมอ
- `lib/analytics-weekly.ts` — เข้า digest รายสัปดาห์

---

## 3. สถานะการยิงแอด

> อัปเดต 2026-07-25 — ✅ = ทำแล้ว · ⬜ = ยังต้องทำ

### 3.1 ก่อนเปิดงบบาทแรก
- [x] **ยืนยันว่า event ยิงจริงบน production** — `casegame_start` / `casegame_first_decision` / `casegame_complete` มีข้อมูลจริงในตาราง `analytics_events` แล้ว
  ⚠️ ตัวแรกสุดในตารางคือ **25 ก.ค. 2026** — ก่อนหน้านั้น `/sim/<slug>` มี 231 pageviews โดยไม่มี event เลย ข้อมูล funnel ย้อนหลังจึงไม่มี ใช้เทียบ baseline ไม่ได้
- [ ] **ยืนยัน `casegame_cta_view` → `casegame_lead` ยิงจริงบน production** — สองตัวนี้ยังไม่เคยมีข้อมูลสักแถว (e2e ครอบแล้วว่ายิงถูกใน browser จริง แต่ยังไม่มีผู้เล่นจริงเดินผ่านครบ)
- [ ] **ยืนยันฝั่ง Meta ด้วย Test Events** — ตั้ง `META_TEST_EVENT_CODE` แล้วเล่น 1 รอบ ต้องเห็น `ViewContent` พร้อม `content_type: casegame`
  ⚠️ ยังไม่ได้ทำ · dataset stats รวมแยกไม่ได้ว่า `ViewContent` ใบไหนมาจากเกม เพราะหน้า `/register` ก็ยิง event เดียวกัน
- [ ] **สร้าง Custom Conversion "เล่นเกมเคสจริง"** บน pixel `966371002896288` จากกติกา `content_name` **ขึ้นต้นด้วย** `casegame_first_decision`
  ⚠️ **ต้องทำในหน้า Events Manager เอง** — MCP ไม่มีเครื่องมือสร้าง Custom Conversion · ตัวนี้คือ optimization target ของทั้งแผน
  ⚠️ **ห้ามใช้ `casegame_start`** — โฆษณายิงเข้าโหมด autostart (`?start=1`) เกมจึงเริ่มเองทุกครั้งที่หน้าโหลด `start` เลยมีค่าเท่ากับ Landing Page View ใช้เป็น optimization target ไม่ได้ · "ตัดสินใจข้อแรก" คือสัญญาณแรกที่พิสูจน์ว่าเล่นจริง และยังมีปริมาณพอให้เรียนรู้ (~70% ของคนที่เข้า)
- [x] **สร้าง Custom Audience** `[MR] คนเล่นเกมเคส 180 วัน` = `52588558510197`
  กติกาใช้ URL (`url i_contains "/sim/"`) ไม่ใช่ `content_type` เพราะ WCA rule รองรับ filter แค่ `url`/`event` · เป็น seed ของ Lookalike 1% ที่ติดเงื่อนไข pool < 100 คน

### 3.2 แคมเปญ — สร้างแล้ว ทั้งหมดยัง PAUSED (ยังไม่เสียเงิน)

| สิ่งที่สร้าง | ID | สถานะ |
|---|---|---|
| Campaign `[MR]_Traffic_CaseGame` (OUTCOME_TRAFFIC) | `52588558588397` | PAUSED |
| Ad set `CG1 Broad — TH 20-35` (LPV, ฿120/วัน, ABO) | `52588558665397` | PAUSED |
| Ad `[MR] CaseGame — Hub (autostart)` | `52588565382197` | PAUSED |
| Ad `[MR] CaseGame — Direct (autostart)` | `52588565384197` | PAUSED |

> ad รุ่นแรก (`52588558807597`, `52588558810397`) ปลดระวางแล้ว — เปลี่ยนชื่อเป็น "เลิกใช้ ไม่มี autostart" และคง PAUSED ไว้ · link ของ creative แก้ในที่ไม่ได้ (immutable) การเปลี่ยนปลายทางจึงต้องสร้าง creative + ad ใหม่เสมอ

ปิด Advantage+ Audience (`advantage_audience: 0`) ให้อายุ 20–35 เป็นช่วงตายตัว ตามกฎไทยห้ามยิงต่ำกว่า 20
ต้องวิ่ง**คู่กับ** `[MR]_Traffic_FreeTrial` (`52580729960597` — **ACTIVE อยู่จริง** ใช้ไป ฿849 ใน 7 วัน) เพื่อเทียบ **ไม่ใช่ไปแทนที่**

**ทุกปลายทางของโฆษณาต้องมี `&start=1`** — เกมจะข้ามจอ title แล้วเริ่มเล่นทันทีที่หน้าโหลด คนกดโฆษณาเข้ามาจึงได้ engage ทันทีโดยไม่ต้องกดอะไรอีก (ผู้ใช้ที่เข้ามาเองยังเจอจอ title ตามปกติ เพราะจอนั้นเป็นที่เลือกระดับความยาก)

**ทดสอบปลายทาง 2 แบบด้วย ad 2 ตัวใน ad set เดียว:**
- ก. Hub → `/casegame?...&utm_content=hub&start=1` — เห็นว่ามีหลายเคส แต่เพิ่ม 1 คลิก (หน้ารวมส่ง `start` ต่อให้เอง)
- ข. Direct → `/sim/lc-testicular-torsion-01?...&utm_content=direct&start=1` — เข้าเกมทันที 0 คลิก

วัดด้วย `casegame_first_decision / LPV` ของแต่ละ ad — ไม่ใช่ `casegame_start` ซึ่งตอนนี้เท่ากับ LPV ไปแล้ว

**เมื่อ Custom Conversion สะสมได้ ~50/สัปดาห์** → เปลี่ยนแคมเปญเป็น Conversions optimize บน event นั้น (นี่คือเป้าหมายจริงของทั้งแผน)

จากนั้นป้อน `[MR]_Retarget` ด้วย audience คนเล่นเกม (exclude คนสมัคร/จ่ายแล้ว)

### 3.3 Creative

ต่อยอด "มุม 2 — Long Case AI" ใน `docs/ads-creative-copy-2026H2.md` แต่เปลี่ยน CTA เป็น **"ลองเล่นเคสฟรี ไม่ต้องสมัคร"** — เป็นข้อเสนอที่ friction ต่ำกว่าทุกตัวที่เคยยิง

### 3.4 Content depth (ทำคู่ขนาน)

เคส built-in มีแค่ 3 เคส ถ้าคนเล่นจบแล้วไม่มีอะไรต่อ retention = 0 และการยิงแอดจะกลายเป็นซื้อคนมาเล่นฟรีเฉยๆ
ใช้ `npm run gen:casegames` (`scripts/generate-longcase-games.ts`) → ตั้งเป้ามีเคส published **≥ 10 เคส** ก่อนเปิดงบเต็ม

---

## 4. เกณฑ์ go/no-go

| ขั้น | ตัววัด | เกณฑ์ผ่าน |
|---|---|---|
| เปิดงบได้ | Custom Conversion สร้างแล้ว + Meta Test Events ผ่าน (§3.1 สองข้อที่ยังค้าง) | ครบทุกข้อ |
| เกมน่าเล่นจริง | ตัดสินใจข้อแรก / เริ่มเล่น | > 70% |
| เกมจบได้จริง | เล่นจบ / เริ่มเล่น | > 40% |
| **ตัวชี้ขาด** | ให้อีเมล / เล่นจบ | **> 15%** |
| ต้นทุน | cost / เริ่มเล่นเกม | < ฿10 |
| ปลายทาง | lead → redeem | > 30% (เท่าเกณฑ์เดิมใน `ads-plan-2026H2.md`) |

**ถ้า lead rate < 15% หลังเก็บ 2 สัปดาห์ → หยุด อย่าเพิ่มงบ** — ปัญหาอยู่ที่ข้อเสนอ ไม่ใช่ที่ปริมาณ traffic

⚠️ **อย่าตัดสินแคมเปญนี้ที่ CPC หรือจำนวนคนเล่น** — เกมดึงคนได้ถูกกว่าเสมอ CPC จะสวยขึ้นแน่นอน แต่ CAC ต่อคนจ่ายจริงอาจไม่ดีขึ้นเลย ตัดสินที่ lead → redeem → จ่าย เหมือนเดิม

---

## 5. ปฏิทิน

รอบสอบถัดไป: **NL-1 รอบ 2/2569 = 2026-10-10** และ **NL-2 รอบ 4/2569 = 2026-10-11** (`lib/exam-dates.ts`)
หน้าต่างอัดงบ 6–8 สัปดาห์ก่อนสอบ = **กลาง ส.ค. → 10 ต.ค.**

| ช่วง | งาน |
|---|---|
| ทันที | §3.1 ทั้งหมด (Test Events → Custom Conversion → Custom Audience) |
| ~สัปดาห์ที่ 2 | เปิด `[MR]_Traffic_CaseGame` งบเล็ก · §3.4 เพิ่มเคสคู่ขนาน |
| กลาง ส.ค. – 10 ต.ค. | หน้าต่างอัดงบ · scale เฉพาะ ad set ที่ผ่านเกณฑ์ §4 |

---

## 6. ความเสี่ยง

- **คนเล่นเกม ≠ คนจ่ายเงิน** — ความเสี่ยงจริง แต่ต่ำกว่าปกติเพราะกลุ่มเป้าหมายแคบมาก (นศ.แพทย์ไทย) คนนอกวงไม่คลิกอยู่แล้ว คุมด้วยเกณฑ์ §4
- **เคสน้อย** — §3.4 ต้องเดินคู่ขนาน ไม่งั้น retention พัง
- **Custom Conversion / Lookalike สร้างผ่าน MCP ไม่ได้** — ต้องทำในหน้า Ads Manager เอง (เหมือนกรณี Lookalike ที่ `ads-campaign-setup-2026H2.md` ระบุไว้) เผื่อเวลาให้เจ้าของบัญชี
