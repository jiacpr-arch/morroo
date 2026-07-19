# แผนยุบรวม 3 โปรเจกต์เข้า morroo (Next.js) บน www.morroo.com

## Context

ตอนนี้มี 4 โปรเจกต์ในเครือเดียวกัน (ธุรกิจอบรมการแพทย์/ปฐมพยาบาลของ Jia) แต่แยกกันอยู่คนละโค้ดเบส คนละเครื่องมือ:

| โปรเจกต์ | Repo | Stack | Domain จริง | Vercel project | Backend |
|---|---|---|---|---|---|
| **morroo** (flagship) | `morroo` | Next.js 16 (App Router), Supabase, shadcn/ui, Tailwind v4 | www.morroo.com | `morroo` | Supabase (ของตัวเอง) |
| FirstAid | `firstaid` | Vite + React 19, Zustand, Dexie (offline) | firstaid.morroo.com | `firstaid` (Vite) | Supabase แยก + LINE Login |
| ACLS/BLS | `acls-emr` | Vite + React 19, Zustand, Dexie | acls.morroo.com, bls.morroo.com | `acls-emr-urjm`, `bls-morroo` (repo เดียว deploy 2 ที่ ผ่าน `VITE_COURSE_MODE`) | Supabase "emr-ai-clinic" แยก |
| CPR Online | `jia-online` | Vite + React 18, ทั้งแอพอยู่ใน `App.jsx` ไฟล์เดียว (~3,900 บรรทัด) | cpr.morroo.com | `jia-online` (Vite) | Supabase แยก + **Stripe (เงินจริง)** + LINE Login |

**สิ่งที่ค้นพบสำคัญ:** งานยุบรวมเริ่มไปแล้วบางส่วน — โค้ดของ FirstAid ถูกย้ายเข้าไปเป็น route group `(firstaid)` ใน repo `morroo` แล้ว พร้อม middleware ที่ rewrite host `firstaid.morroo.com` → `/firstaid/*` (ดู `docs/firstaid-migration.md`) **แต่ DNS/Vercel domain ของ `firstaid.morroo.com` ยังชี้ไปที่ Vercel project เดิม (`firstaid`, Vite) อยู่ — ยังไม่ได้ cutover จริง** นี่คือจุดเริ่มต้นที่เสี่ยงต่ำที่สุดและใกล้เสร็จที่สุด

ผู้ใช้ต้องการให้ทุกอย่างมาอยู่ใน Next.js ของ morroo เพราะดูดีที่สุดและขายง่ายที่สุด แต่ต้อง **ไม่กระทบผู้ใช้จริง/ลูกค้าที่กำลังใช้งานแต่ละ subdomain อยู่** โดยเฉพาะ `cpr.morroo.com` ที่มีการชำระเงินจริงผ่าน Stripe

**เรื่อง backend/Supabase:** ตามที่คุยกัน — **แยก Supabase ของแต่ละโปรเจกต์ไว้เหมือนเดิมก่อน** ไม่ยุบรวมตอนนี้ เพราะ route group ใหม่แต่ละตัวเรียก Supabase client ของตัวเองผ่าน env vars ของตัวเองได้เลย (แบบเดียวกับที่ `(firstaid)` ทำอยู่แล้วคู่กับ Supabase ของ morroo เอง ในโค้ดเบสเดียวกัน) ไม่ต้องทำ data migration หรือแตะ RLS ของเก่าเลย — ค่อยพิจารณายุบรวม backend ทีหลังถ้ามีเหตุผลทางธุรกิจจริง ๆ (เช่น อยากได้ single login ข้ามคอร์ส หรือ CRM มุมมองเดียว)

## แนวทาง: ยุบรวมแบบ "strangler-fig" ทีละโปรเจกต์ ไม่ทำทีเดียวทั้งหมด

เหตุผลที่ไม่ทำ big-bang: แต่ละแอพมีระบบ auth ต่างกัน (LINE Login, Stripe, admin password), `jia-online` มีเงินจริงไหลผ่าน Stripe, `acls-emr` มี game logic ซับซ้อน (Code Blue sim, Recorder Hero) ที่ port ยาก การรื้อทีเดียวหมดเสี่ยงเกินไป

**รูปแบบมาตรฐานต่อ 1 โปรเจกต์ (ใช้ pattern เดียวกับที่ firstaid ทำค้างไว้):**
1. ย้าย/เขียนโค้ดของแอพนั้นให้เป็น route group ใหม่ใน repo `morroo` (เช่น `app/(acls)/...`) ใช้ shadcn/ui + design tokens ของ morroo แทน CSS เดิม
2. ต่อ Supabase client ของแอพนั้นแยกจากของ morroo (คนละ env var, คนละ client instance — ทำได้ในโค้ดเบสเดียวกันสบาย)
3. เพิ่ม middleware host-rewrite (มี pattern อยู่แล้วจาก firstaid) — ทดสอบผ่าน preview/beta subdomain ก่อน (เช่น `acls-beta.morroo.com`) **โดย domain จริงยังไม่ขยับ**
4. เทียบ feature parity กับของเดิมให้ครบ (checklist ด้านล่าง)
5. **คัตโอเวอร์**: ย้าย DNS/Vercel domain (เช่น `acls.morroo.com`) จาก Vercel project เดิมมาที่ project `morroo` — เป็นการกดปุ่มเดียวใน Vercel, ย้อนกลับได้ทันทีถ้ามีปัญหา (deployment เดิมยังอยู่ ไม่ได้ลบ)
6. Monitor 1–2 สัปดาห์ (Sentry/PostHog/Vercel logs) ก่อนพิจารณาปิด Vercel project เดิม

**สาเหตุที่วิธีนี้ "ไม่กระทบ session อื่นเลย":**
- Vercel project เดิม (`firstaid`, `acls-emr-urjm`, `bls-morroo`, `jia-online`) ไม่ถูกแตะเลยจนกว่าจะถึงขั้นตอนคัตโอเวอร์ — ผู้ใช้จริงยังคงใช้ของเดิมอยู่ตลอดระหว่างพัฒนา
- งานพัฒนาทั้งหมดอยู่ใน branch/route group ใหม่ของ repo `morroo` เท่านั้น ไม่แตะ repo อื่นเลย
- Supabase/ข้อมูล/LINE Login channel/Stripe key ของแต่ละแอพยังเป็นตัวเดิม — ผู้ใช้ไม่ต้อง re-login หรือเสี่ยงข้อมูลหาย
- คัตโอเวอร์ = เปลี่ยน DNS record เดียว ย้อนกลับได้เกือบทันที ไม่ใช่การ deploy หรือ migrate ข้อมูล

## แผนเป็นเฟส (เรียงตามความเสี่ยง — จบเฟสหนึ่งก่อนเริ่มเฟสถัดไป)

### Phase 0 — ปิดงาน FirstAid ที่ค้างไว้ (proof point แรก)
- **สถานะตอนนี้:** โค้ด route group `(firstaid)` ใน repo `morroo` เสร็จไปเกือบหมดแล้ว, middleware host-rewrite มีอยู่แล้ว, แต่ **DNS `firstaid.morroo.com` ยังชี้ไป Vercel project เดิม (`firstaid`, Vite)** — ยังไม่ cutover
- **งานที่เหลือ:**
  1. เทียบ feature parity ระหว่าง `(firstaid)` ใน morroo กับแอพ Vite ที่รันจริงอยู่ตอนนี้ (เช็คทีละหน้า: บทเรียน, ผังช่วยชีวิต 11 ผัง, simulation 5 สถานการณ์, pre/post-test, ใบเซอร์, LINE login, admin panel)
  2. ปิดช่องว่างที่พบ, restyle ให้ตรง design system ของ morroo
  3. Deploy ทดสอบผ่าน preview URL (ยังไม่แตะ domain จริง)
  4. คัตโอเวอร์: ย้าย `firstaid.morroo.com` จาก project `firstaid` → project `morroo`
  5. Monitor 1–2 สัปดาห์, เก็บ project `firstaid` (Vite) ไว้เป็นตัวย้อนกลับ ยังไม่ลบ
- **ผลลัพธ์เฟสนี้:** พิสูจน์ว่า pattern (route group + host-rewrite + Supabase แยก) ใช้งานได้จริงในโปรดักชัน ก่อนเอาไปใช้กับอีก 2 โปรเจกต์ที่เสี่ยงกว่า

### Phase 1 — ACLS/BLS: แยกเป็นคนละส่วนเด็ดขาด (acls.morroo.com, bls.morroo.com)
- **ความเสี่ยงธุรกิจ:** ต่ำ (ไม่มีเงินจริงไหลผ่าน) แต่ **งานวิศวกรรมเยอะ** — มี Code Blue sim + Recorder Hero (canvas/game logic) ที่ต้อง port ให้ครบ
- **การตัดสินใจ: แยก ACLS กับ BLS เป็นคนละคอร์ส/คนละเมนูเลย** — ไม่ port ระบบ `VITE_COURSE_MODE` toggle เดิม (ที่เป็นแอพเดียว build 2 รอบสลับเนื้อหา) เข้ามา แต่สร้าง **2 route group แยก: `app/(acls)/` และ `app/(bls)/`** แต่ละอันมี layout, เมนู/navigation, สี accent, โลโก้ย่อย และหน้า landing ของตัวเอง — บนหน้า hub ของ morroo.com ก็เป็นการ์ดคอร์สคนละใบ
- โค้ดที่ใช้ร่วมกันจริง ๆ (เช่น engine ของ Code Blue sim, quiz component, ตัวออกใบเซอร์) แยกออกมาเป็น shared module (เช่น `lib/resus/` หรือ `components/resus/`) แล้วให้ทั้ง 2 route group เรียกใช้ — เนื้อหา/สถานการณ์/ข้อสอบเป็นของใครของมัน
- **งาน:**
  1. สร้าง `app/(acls)/` และ `app/(bls)/` ต่อ Supabase project "emr-ai-clinic" เดิม (ข้อมูล ACLS/BLS อยู่ใน DB เดียวกันอยู่แล้ว query แยกตามคอร์สได้)
  2. เพิ่ม host-mapping ใน middleware: `acls.morroo.com` → `/(acls)`, `bls.morroo.com` → `/(bls)`
  3. Port ฟีเจอร์ทีละส่วน: บทเรียน/quiz → Code Blue sim → Recorder Hero → drug calculator → admin (ส่วนที่ใช้ร่วมกันไปไว้ shared module)
  4. ทดสอบ parity ผ่าน preview/beta subdomain ก่อน
  5. คัตโอเวอร์ทีละ domain (`acls.morroo.com` ก่อน แล้วตามด้วย `bls.morroo.com`) จาก project `acls-emr-urjm`/`bls-morroo` → `morroo`
  6. Monitor, เก็บ project เดิมไว้ก่อน

### Phase 2 — jia-online (cpr.morroo.com) — ทำท้ายสุด
- **ความเสี่ยงธุรกิจ:** สูงสุด — มี **Stripe ชำระเงินจริง** + LINE Login gate + PromptPay + โค้ดทั้งแอพอยู่ในไฟล์เดียว (`App.jsx` ~3,900 บรรทัด)
- **งาน:**
  1. แตก `App.jsx` เป็น component ก่อน (จำเป็นก่อน migrate จริง)
  2. สร้าง route group ใหม่ ต่อ Supabase + Stripe + LINE ของ jia-online เดิม (ใช้ key/channel เดิม ไม่สร้างใหม่)
  3. ทดสอบ flow การจ่ายเงินอย่างละเอียดเป็นพิเศษ (Stripe checkout, webhook, PromptPay, ออกใบเซอร์หลังจ่าย) ใน sandbox/preview ก่อนคัตโอเวอร์จริง
  4. คัตโอเวอร์ `cpr.morroo.com` เป็นลำดับสุดท้าย พร้อม monitor ใกล้ชิดช่วงแรก (เงินจริงไหลผ่านจุดนี้)
  5. เก็บ project `jia-online` เดิมไว้เป็น fallback นานกว่ากรณีอื่นก่อนพิจารณาปิด

### Phase 3 (อนาคต, ยังไม่ทำตอนนี้) — ยุบรวม Supabase + Single Sign-On ทั้งเครือ
- เป้าหมายหลัก: **login ครั้งเดียวใช้ได้ทุกคอร์ส** — รวม auth เป็น Supabase เดียว (ของ morroo) + LINE Login channel เดียว, บัญชีเดียวเห็นใบเซอร์/ความคืบหน้าทุกคอร์ส, ฝั่งธุรกิจได้ CRM มุมมองเดียว (cross-sell ข้ามคอร์สง่ายขึ้น)
- การ map บัญชีเดิม → บัญชีรวม ใช้ **LINE userId** เป็น key เชื่อม (ทุกระบบผูก LINE identity อยู่แล้ว: `line_identities` ใน firstaid, LINE link ใน jia-online)
- ไม่ใช่ prerequisite ของ Phase 0–2 เลย — โค้ดรวมกันได้ทั้งหมดโดยที่ backend ยังแยกกันอยู่

## การเข้าระบบระหว่าง Phase 0–2 (ก่อนมี SSO)

- แต่ละคอร์สยังใช้ Supabase + LINE Login channel เดิมของตัวเอง → บัญชีแยกกันเหมือนปัจจุบัน (ไม่แย่ลงกว่าเดิม)
- ความซ้ำซ้อนต่ำ เพราะทุกแอพ login ด้วย LINE เหมือนกัน — ครั้งถัดไป LINE auto-approve ทันที ผู้ใช้แค่แตะปุ่มเดียว ไม่ต้องกรอกอะไร
- **ข้อควรระวัง:** เมื่อหลายคอร์สรันใน Next.js app เดียวกันคนละ subdomain ต้องตั้ง session/auth cookie แบบ **per-host** (ห้ามใช้ `Domain=.morroo.com`) เพื่อไม่ให้ session ของแต่ละคอร์สตีกันหรือรั่วข้าม subdomain

## วิธีรวม: ย้ายเข้า Next.js จริง ไม่ใช้ iframe

ตัดสินใจแล้วว่า**ไม่ใช้ iframe** ครอบแอพเดิม เพราะ (1) LINE Login และ Stripe checkout ที่ต้อง redirect จะพัง/โดนบล็อก third-party cookie ใน iframe, (2) UX บนมือถือ/LINE in-app browser แย่ ทั้งที่ traffic หลักมาจาก Facebook Ads บนมือถือ, (3) SEO เป็นศูนย์, (4) Meta Pixel/PostHog track ข้าม frame ไม่ได้ ทำให้วัดผลแอดเพี้ยน, (5) หน้าตาข้างในยังเป็นของเก่า ไม่ตอบโจทย์ "ดูดี/ขายง่าย" — ทุกแอพจึงย้ายเข้ามาเป็น route group จริงใน Next.js และ restyle ใหม่

## หน้าแรก www.morroo.com — redesign เป็น hub ของเครือ (งานคู่ขนาน Phase 0)

ปัจจุบันสินค้าในเครือโผล่แค่เป็นลิงก์ "เว็บในเครือ" ที่ footer/ad banner (`lib/network-sites.ts`) — ควร redesign หน้าแรกให้เป็น hub โชว์สินค้าทั้งเครือ **โดยสินค้าเดิมของ morroo ไม่ถูกลดบทบาท — ยังเป็นพระเอกของหน้า** เพราะเป็นตัวที่มีลูกค้าจ่ายเงินอยู่:

- **โครงสร้างหน้าเป็น "กลุ่มสินค้า":**
  - **กลุ่มเตรียมสอบ (ของเดิม morroo — ตำแหน่งเด่นสุด/hero):** คลังข้อสอบ board, Longcase AI, School, Code Blue Sim, blog — CTA หลักของหน้ายังพาไป pricing/สมัครสมาชิกเหมือนเดิม (revenue หลัก)
  - **กลุ่มคอร์สอบรม + ใบเซอร์ (ที่ยุบรวมเข้ามา):** FirstAid, CPR, ACLS, BLS — section ถัดลงมา การ์ดคอร์สพร้อมสี accent ประจำคอร์ส ราคา และ CTA
- **flow ของสมาชิกเดิมไม่เปลี่ยน:** login แล้วเข้า dashboard/เมนูเดิมได้ทุกอย่าง — redesign เกิดที่หน้า landing สำหรับ visitor ใหม่เป็นหลัก
- ใช้ข้อมูลจาก `lib/network-sites.ts` เดิมเป็น source, สไตล์ shadcn/ui + brand tokens ที่มีอยู่ ทำได้ทันทีโดยไม่ต้องรอ migration ของแอพไหนเสร็จ (ช่วงแรกการ์ดลิงก์ไป subdomain เดิม แล้วค่อยเปลี่ยนเป็น internal route เมื่อแต่ละแอพย้ายเข้ามาแล้ว)
- ประโยชน์เชิงธุรกิจ: สองกลุ่มเสริมกัน — ผู้เรียน FirstAid/CPR (ตลาดกว้าง ราคาเข้าถึงง่าย) เป็น audience สำหรับ cross-sell ขึ้นไปหากลุ่มเตรียมสอบ และในทางกลับกัน

## Design system: ระบบเดียว + เอกลักษณ์ย่อยต่อคอร์ส (sub-brand)

morroo มี shadcn/ui (style `base-nova`) + Tailwind v4 OKLCH tokens + สี brand teal `#16A085` อยู่แล้ว ส่วนอีก 3 แอพต่างคนต่างมี palette ของตัวเอง (เขียว `#16A34A`, ฯลฯ) หรือไม่มี framework เลย (jia-online ใช้ inline style ทั้งหมด) — ตอนย้ายแต่ละแอพ ควร **restyle ใหม่ด้วย component ของ morroo** ไม่ใช่ copy CSS เดิมมาใช้ต่อ

แนวทางคือ "ระบบเดียว เอกลักษณ์ย่อยของใครของมัน":

- **ใช้ร่วมกันทั้งเครือ:** layout, ฟอนต์ Sarabun, spacing, ชุด component shadcn/ui เดียวกัน, navigation/footer ร่วมที่สลับไปคอร์สอื่นในเครือได้
- **เอกลักษณ์ต่อคอร์ส:** แต่ละ route group กำหนด **สี accent ประจำคอร์ส** ของตัวเองผ่านการ override CSS variable (`--color-brand` ฯลฯ) ใน layout ของ route group นั้น — เช่น FirstAid = เขียว `#16A34A` (สีเดิม), CPR = แดง/ส้มโทนฉุกเฉิน, ACLS = น้ำเงินเข้มโทนวิชาชีพ, BLS = ฟ้า — ปุ่ม/ลิงก์/หัวข้อในส่วนนั้นเปลี่ยนตามอัตโนมัติโดยไม่ต้องแก้ component, บวกไอคอน/โลโก้ย่อยและภาพ hero ประจำคอร์ส, บุคลิกภาษาต่างกันได้ (FirstAid เป็นมิตรกับคนทั่วไป, ACLS จริงจังแบบบุคลากรการแพทย์)
- หน้า hub ของ morroo.com ใช้สี accent ของแต่ละคอร์สบนการ์ดคอร์ส → ดูหลากหลายแต่เป็นระบบเดียวกัน

## มาตรการป้องกัน morroo core (มีลูกค้าจ่ายเงินอยู่บน www.morroo.com — ห้ามพัง)

www.morroo.com มีสมาชิกชำระเงินจริง (Stripe subscription, ระบบสอบ, invoice) — งาน migration ทั้งหมดต้องไม่เสี่ยงต่อส่วนนี้:

1. **แยกส่วนสนิทด้วย route group** — โค้ดใหม่ทั้งหมดอยู่ใน route group ใหม่ (`(acls)`, `(cpr)`) ที่มี layout/CSS/error boundary ของตัวเอง ไม่แก้ไฟล์ใน `app/(morroo)/` และ `app/api/` เดิม ยกเว้นจำเป็นจริง ๆ และต้อง review เป็นพิเศษ
2. **จุดเสี่ยงร่วมจุดเดียวคือ `middleware.ts`** — แก้แบบ additive เท่านั้น (เพิ่ม host-mapping ใหม่ ไม่แตะ logic เดิมของ morroo/firstaid ที่พิสูจน์แล้ว) และทุกครั้งที่แก้ ต้องทดสอบครบทุก host (www, firstaid, acls, bls, cpr) บน preview deployment ก่อน merge
3. **ไม่แตะ Supabase ของ morroo** — ไม่มี migration/แก้ schema ตาราง `profiles`, billing, exam ใด ๆ ในงานนี้ ระบบสมาชิกและการสอบของลูกค้าเดิมไม่ถูกกระทบ
4. **Rollback ใน ~1 นาที** — Vercel เก็บทุก deployment ไว้ กด promote previous deployment กลับได้ทันที ไม่ต้อง revert code ก่อน
5. **Smoke test ก่อน merge ทุก PR**: บน preview URL ต้องผ่าน — login สมาชิก morroo, เข้าหน้าสอบ/ข้อสอบ, หน้า pricing/payment, และ cron/API routes สำคัญไม่ error
6. **Deploy ช่วง traffic ต่ำ + เฝ้า Sentry/PostHog/Vercel logs หลัง deploy ทุกครั้ง** โดยเฉพาะ error จาก middleware และ API billing

## สิ่งที่ยังไม่ทำตอนนี้

- ไม่ยุบรวม Supabase/ข้อมูลของแต่ละแอพ (ตามที่ตกลง — แยกไว้ก่อน)
- ไม่ลบ/ปิด repo หรือ Vercel project เดิม จนกว่าคัตโอเวอร์แต่ละตัวจะนิ่งแล้ว
- ไม่ทำ migration ทีเดียวทั้ง 3 โปรเจกต์พร้อมกัน

## การตรวจสอบ (verification) ต่อแต่ละเฟส

- ทำ feature-parity checklist ของ user flow หลักก่อนคัตโอเวอร์ทุกครั้ง เช่น:
  - jia-online: สมัคร → LINE login → ดูบทเรียน → ทำแบบทดสอบ → จ่ายเงิน (PromptPay/Stripe) → ออกใบเซอร์
  - acls/bls: บทเรียน → quiz → Code Blue sim → ใบเซอร์
  - firstaid: บทเรียน → ผังช่วยชีวิต → simulation → pre/post-test → ใบเซอร์
- ทดสอบบนมือถือจริง (ทุกแอพเป็น PWA/ใช้ผ่าน LINE LIFF)
- ยืนยันว่า session/LINE login ของผู้ใช้เดิมยังใช้ได้ต่อเนื่องหลังคัตโอเวอร์ (ไม่ต้อง login ใหม่, ใบเซอร์เก่ายังเรียกดูได้)
- หลังคัตโอเวอร์แต่ละตัว เฝ้า error rate ใน Sentry/PostHog/Vercel logs — ถ้าผิดปกติ ย้าย DNS กลับไป project เดิมได้ทันที

## ขั้นต่อไปที่แนะนำ

เริ่มที่ **FirstAid**: ตรวจว่า route group `(firstaid)` ใน repo `morroo` ตอนนี้ครบ parity กับแอพ Vite จริงที่รันอยู่บน `firstaid.morroo.com` หรือยัง (มีอะไรขาด/ต่างไปบ้าง) แล้วปิดช่องว่างที่เหลือ ก่อนดำเนินการคัตโอเวอร์ domain จริงเป็นตัวแรก — เป็นการพิสูจน์ pattern ทั้งหมดก่อนลงมือกับ acls-emr และ jia-online ที่เสี่ยงกว่า
