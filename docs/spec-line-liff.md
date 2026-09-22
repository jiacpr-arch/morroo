# สเปก: LINE LIFF สำหรับหมอรู้ + ผลกระทบต่อระบบ autopost

> สถานะ: **Phase 0 + 1 + 3 + §6 (auth bridge + แปลงปุ่มลูกค้าเป็น LIFF + webhook reply‑token) เสร็จแล้ว** — เขียน 2026‑09‑21, อัปเดต 2026‑09‑22
> เป้าหมาย: ทุกลิงก์ที่ส่งจาก LINE OA เปิดแล้ว "ล็อกอินให้อัตโนมัติ" และการเชื่อมบัญชีเหลือแค่แตะครั้งเดียว โดยไม่ต้องรื้อ pipeline autopost
>
> **สิ่งที่ทำเสร็จแล้วในรอบนี้:**
> - **Phase 0** — ตั้งค่า LINE Developers console ครบ: LINE Login channel "morroologin" (`LINE_LOGIN_CHANNEL_ID=2010009663`) ผูกกับ OA `@901nmwcd` แล้ว, LIFF app "morroo" (`NEXT_PUBLIC_LIFF_ID=2010009663-BMDYoMQk`) ตั้ง Endpoint = `/line/liff`, Scope = profile/openid/email, Add friend = On (aggressive), และยื่นขอ email permission แล้ว (รอ LINE อนุมัติ — ระบบใช้ placeholder email ระหว่างรอได้ปกติ)
> - **Phase 1** — `lib/line-id-token.ts`, `lib/line-auth.ts`: logic verify ID token + find‑or‑create/link/sign‑in ที่ใช้ร่วมกันระหว่าง LINE Login OAuth (`app/api/auth/line/callback`, refactor แล้วไม่เปลี่ยน behavior) กับ LIFF; `app/api/auth/line/liff-session/route.ts` (ใหม่) แทน `/api/line/liff-link` เดิม (deprecated); `app/(morroo)/line/liff/page.tsx` อ่าน `liff.state` เพื่อ redirect กลับไปหน้าที่ตั้งใจเปิดหลัง sign‑in
> - **Phase 3 (ขยายจากแผนเดิม — ทำครบทุกปุ่มลูกค้าในรอบเดียว ไม่ใช่แค่ 1 ปุ่ม)** — `lib/line-links.ts` (ใหม่): `toLiffUri(fullUrl)` ห่อ URL เต็มที่มีอยู่แล้วให้เป็น LIFF deep link (รักษา path/query เดิมทั้งหมด รวม UTM), `liffDeepLink(path)` สำหรับ path เปล่า — ทั้งคู่ fallback เป็น URL ธรรมดาเมื่อไม่ได้ตั้ง `NEXT_PUBLIC_LIFF_ID`. ใช้ห่อปุ่มลูกค้าทั้งหมด 14 จุดใน `lib/line-flex-templates.ts` + `lib/daily-mcq-line.ts` (สรุปรายการ, ประกาศบทความ/ข่าว, newsletter, แจ้งเตือนหมดอายุ+จ่ายเงิน, streak‑nudge, ผลสอบ, การ์ด chatbot 4 ใบ, MCQ ประจำวัน/รายสัปดาห์, ผลเฉลย MCQ + แชร์เพื่อน + redeem code, Long Case ใหม่, teaser เสาร์/สรุปอาทิตย์) — **ไม่แตะ** การ์ดแอดมิน (`buildAdminDigestFlex`, `buildAdsSuggestFlex`) และแคปชัน FB/IG (`lib/autopost-copy.ts`, `lib/facebook.ts`, `lib/instagram.ts`) โดยตั้งใจ มี regression test กันไม่ให้ `liff.line.me` หลุดเข้าไปในแคปชันโซเชียล
> - Email policy ที่ยืนยันแล้ว: ไม่มี email จาก ID token → ใช้ placeholder `line_{userId}@line.morroo.com` (ชื่อ domain เดิมที่ `app/api/auth/line/callback` ใช้อยู่แล้ว) ไม่บล็อกผู้ใช้ (ยืนยันแล้วว่า LINE อนุมัติ email permission ของ channel นี้เร็วกว่าคาด — ผู้ใช้ใหม่ที่เชื่อมผ่าน LIFF ตอนนี้ได้อีเมลจริงแล้ว ไม่ใช่ placeholder)
> - **§6** — webhook (`app/api/line/webhook/route.ts`) ตอบด้วย `replyToken` ก่อนแทน push ตรง (`replyOrPushLineMessage()` ใน `lib/line.ts`, fallback เป็น push อัตโนมัติถ้า reply ล้มเหลว) — ประหยัดโควตารายเดือนของ LINE เพราะข้อความตอบแชท (ปริมาณหลัก) ไม่กินโควตาอีกต่อไป
>
> **ยังไม่ทำ** (Phase 2, 4, 5 เดิม): หน้า LIFF แบบ layout เบา + catch‑all route (ตอนนี้ `/line/liff` ยังอยู่ layout เต็มของเว็บ ใช้งานได้ปกติ), เลิก link‑code flow (`MORROO-XXXXXX`), autopost link‑builder/UTM/quota consolidation ฝั่ง blog/news digest — คงแผนเดิมไว้ด้านล่างเป็น backlog

---

## 0. TL;DR

| คำถาม | คำตอบสั้น |
|---|---|
| ใช้ LIFF ได้ไหม | ได้ และมีของอยู่แล้วครึ่งทาง: `@line/liff` ติดตั้งแล้ว, มีหน้า `/line/liff`, มี `/api/line/liff-link` ที่ verify ID token กับ LINE แล้ว |
| อะไรที่ยังขาด | (1) LIFF ยังสร้าง Supabase session ไม่ได้ ต้องไปกด login เอง (2) ปุ่มใน Flex ทุกใบยังชี้ `https://www.morroo.com/...` ซึ่งเปิดใน in‑app browser แบบไม่มี session (3) หน้า LIFF ยังอยู่ใต้ layout เต็ม (Navbar/Footer/ChatWidget/popup) |
| autopost ต้องแก้ไหม | **แก้น้อยมาก** — ไม่ต้องแตะ FB/IG เลย แก้แค่ "ตัวสร้างลิงก์ฝั่ง LINE" ให้เป็นจุดเดียว + เพิ่ม UTM + quota check ให้ news broadcast |
| ของแถมที่ควรทำพร้อมกัน | ✅ ทำแล้ว — webhook ตอบด้วย `replyToken` แทน push → ข้อความตอบกลับ (chatbot, เฉลย MCQ, greeting) **ไม่กินโควตารายเดือน** |

---

## 1. สิ่งที่มีอยู่แล้ว (as‑is)

### 1.1 โค้ด LINE ที่เกี่ยว

| ส่วน | ไฟล์ | หมายเหตุ |
|---|---|---|
| LIFF landing | `app/(morroo)/line/liff/page.tsx` | `liff.init` → `liff.login()` → `getIDToken()` → POST `/api/line/liff-link` |
| LIFF link API | `app/api/line/liff-link/route.ts` | verify ID token กับ `api.line.me/oauth2/v2.1/verify` (aud = `LINE_LOGIN_CHANNEL_ID`) แล้ว update `profiles.line_user_id` **ถ้ามี Supabase session อยู่แล้ว** ถ้าไม่มีตอบ `{linked:false}` แล้วให้ผู้ใช้ไปกด login เอง |
| LINE Login (OAuth) | `app/api/auth/line/route.ts`, `app/api/auth/line/callback/route.ts` | callback ทำครบ: หา user จาก `line_user_id` → ถ้าไม่มีสร้าง user → `admin.generateLink` + `verifyOtp` เพื่อ set cookie session |
| Link code | `app/api/line/generate-code/route.ts` + webhook branch `MORROO-XXXXXX` | flow เดิม: copy code ไปพิมพ์ใน LINE (มี friction สูง) |
| Webhook | `app/api/line/webhook/route.ts` | follow / postback (daily MCQ, ads‑autofix) / text → chatbot; ✅ ตอบด้วย `replyOrPushLineMessage()` (reply ก่อน, fallback push อัตโนมัติ) |
| Flex templates | `lib/line-flex-templates.ts` | ปุ่มทั้งหมดเป็น `uri: https://www.morroo.com/...` (มี `SITE` hardcode + `siteUrl` จาก env ปนกัน) |
| Daily MCQ | `lib/daily-mcq-line.ts` | ผลเฉลยมีปุ่ม "เชื่อมบัญชี" ชี้ `${SITE_URL}/line/liff` อยู่แล้ว (`needsLink`) |
| Profile UI | `app/(morroo)/profile/page.tsx` | ปุ่มสร้างรหัส MORROO‑ + copy |
| Floating CTA | `components/FloatingLineButton.tsx` | ลิงก์ `line.me/R/ti/p/@901nmwcd` (add friend เฉยๆ) ซ่อนบน `/line/*` |

### 1.2 Env ที่มีแล้ว

```
NEXT_PUBLIC_LIFF_ID           # LIFF app ID (ผูกกับ LINE Login channel)
LINE_LOGIN_CHANNEL_ID/SECRET  # ใช้ verify ID token + OAuth
LINE_CHANNEL_ACCESS_TOKEN     # Messaging API (OA)
LINE_AUTOPOST_ENABLED         # gate broadcast ฝั่ง blog/news
```

### 1.3 Autopost ที่มีแล้ว (สรุปเฉพาะทางเดินฝั่ง LINE)

```
blog_posts ──(scripts/generate-blog.mjs)──▶ FB ทันที (ฟรี)
           ──(cron autopost-ig*)──────────▶ IG
           ──(cron line-weekly-blog-digest, พุธ 12:00)──▶ LINE broadcast 1 carousel/สัปดาห์
news_items ──(autopostNewsItem)───────────▶ FB + LINE broadcast (ถ้า LINE_AUTOPOST_ENABLED)
scheduled_autoposts ──(cron autopost-scheduled)──▶ runAutopostRetry(platform)
```

ข้อสังเกตที่เกี่ยวกับ LIFF:
- ลิงก์บทความใน digest คือ `https://www.morroo.com/blog/${slug}` **ไม่มี UTM** → วัด traffic จาก LINE ไม่ได้ (ต่างจาก daily MCQ ที่ใส่ `utm_source=line` ครบ)
- `autopostNewsItem` broadcast โดย **ไม่เรียก `checkLineQuota()`** ก่อน (digest เรียก)
- URL base ถูก hardcode แยกกัน 4 ที่: `lib/news-autopost.ts`, `app/api/autopost/retry/route.ts`, `lib/line-flex-templates.ts` (`SITE`), `lib/daily-mcq-line.ts` (`SITE_URL`)

---

## 2. LIFF ทำงานอย่างไร (สิ่งที่ต้องรู้ก่อนออกแบบ)

1. **LIFF URL** = `https://liff.line.me/{LIFF_ID}/<path>?<query>` เมื่อกดใน LINE จะเปิด **Endpoint URL** ที่ตั้งไว้ใน console โดยแนบ `?liff.state=/<path>?<query>` มาก่อน แล้วหลัง `liff.init()` สำเร็จ SDK จะ redirect ไป `endpoint + /<path>?<query>` ให้เอง
2. ในแอป LINE ผู้ใช้ **ล็อกอิน LINE อยู่แล้ว** → `liff.getIDToken()` ได้ทันทีโดยไม่ต้องกดอะไร (ถ้าเปิดนอก LINE จะเด้งไป LINE Login web ก่อน)
3. LIFF ไม่กินโควตาข้อความ — โควตากินเฉพาะ push/multicast/broadcast **reply ฟรี**
4. Cookie ของ `www.morroo.com` ใช้ได้ปกติใน LIFF browser (first‑party, SameSite=Lax) → ถ้าเราตั้ง Supabase session ในหน้า LIFF แล้ว redirect ต่อไปหน้าอื่นของเว็บ ผู้ใช้จะ "ล็อกอินแล้ว" ทันที
5. ตั้งค่า **"Add friend option" = On (aggressive)** ใน LIFF app → เปิด LIFF ครั้งแรกจะชวนแอด OA ให้เลย (แทน `line.me/R/ti/p/...` ได้)
6. `email` ใน ID token จะมาก็ต่อเมื่อ scope `openid email` + channel ได้รับอนุมัติ email permission (ตอนนี้ OAuth ขอ `profile openid email` อยู่แล้ว)

---

## 3. สถาปัตยกรรมที่เสนอ

```
LINE Flex / rich menu / chatbot card
   │  uri: https://liff.line.me/{LIFF_ID}/nl/practice?q=…&utm_source=line…
   ▼
LIFF browser เปิด endpoint  https://www.morroo.com/line/liff?liff.state=/nl/practice?q=…
   │  (หน้า catch‑all ใต้ layout เบา  app/(liff)/line/liff/[[...path]]/page.tsx)
   │  liff.init → getIDToken → POST /api/auth/line/liff-session { idToken }
   ▼
/api/auth/line/liff-session
   │  verify ID token กับ LINE (โค้ดจาก liff-link เดิม)
   │  resolveOrCreateLineUser()   ← แยกออกมาจาก callback route เป็น lib/line-auth.ts
   │  ถ้ามี session อยู่แล้ว → link line_user_id ให้ user นั้น
   │  ถ้าไม่มี → generateLink + verifyOtp → set cookie
   ▼
window.location.replace("/nl/practice?q=…")   ← หน้าเว็บจริง มี session แล้ว
```

หลักการ: **หน้า LIFF มีหน้าเดียว ทำหน้าที่ "ด่านล็อกอิน + เชื่อมบัญชี" แล้วส่งต่อ** ไม่ต้องทำเว็บเวอร์ชัน LIFF แยกทุกหน้า

---

## 4. แผนงานเป็นเฟส

### Phase 0 — ตั้งค่า LINE Developers console (ไม่มีโค้ด, ~30 นาที)

- [ ] LIFF app อยู่ใต้ **LINE Login channel** เดียวกับที่ใช้ `LINE_LOGIN_CHANNEL_ID` (ไม่งั้น verify ID token จะ aud ไม่ตรง)
- [ ] Endpoint URL = `https://www.morroo.com/line/liff` (คงเดิม)
- [ ] Size = **Full**, Scopes = `profile`, `openid`, `email`
- [ ] Add friend option = **On (aggressive)**
- [ ] LINE Login channel ต้อง **link กับ OA** (Linked OA) เพื่อให้ `userId` จาก LIFF ตรงกับ `userId` ใน webhook — ถ้าไม่ link กัน ID จะเป็นคนละตัวและ link บัญชีไม่ตรงกับ postback ของ daily MCQ
- [ ] ตรวจ Vercel env: `NEXT_PUBLIC_LIFF_ID`, `LINE_LOGIN_CHANNEL_ID` มีครบทั้ง production + preview
- [ ] เพิ่ม LIFF endpoint ของ preview (ถ้าจะทดสอบบน preview ต้องสร้าง LIFF app ตัวที่ 2 ชี้ preview domain)

### Phase 1 — Auth bridge: LIFF → Supabase session ✅ เสร็จแล้ว (2026‑09‑22)

**ไฟล์ที่ทำจริง**

| ไฟล์ | สถานะ |
|---|---|
| `lib/line-id-token.ts` | ✅ `verifyLineIdToken(idToken, channelId)` — ย้ายจาก `liff-link` |
| `lib/line-auth.ts` | ✅ `resolveOrCreateLineUser()`, `linkLineToUser()`, `establishSessionFor()`, `linePlaceholderEmail()` |
| `app/api/auth/line/liff-session/route.ts` | ✅ ใหม่ — POST `{ idToken, displayName?, pictureUrl? }` → verify → มี session อยู่แล้ว? link : resolveOrCreate + establishSession → ตอบ `{ ok, linked, isNewSignup?, reason? }` |
| `app/api/auth/line/callback/route.ts` | ✅ refactor ให้เรียก `lib/line-auth.ts` — redirect/error code ทุกจุดเหมือนเดิม |
| `app/api/line/liff-link/route.ts` | ✅ ทำเครื่องหมาย `@deprecated` ในคอมเมนต์ ยังไม่ลบไฟล์ |
| `app/(morroo)/line/liff/page.tsx` | ✅ เรียก `/api/auth/line/liff-session` แทน, อ่าน `liff.state` แล้ว `location.replace()` กลับไปหน้าที่ตั้งใจเปิดหลัง sign‑in สำเร็จ (ยังอยู่ layout เต็มเดิม — Phase 2 ยังไม่ทำ) |
| `lib/daily-mcq-line.ts` | ✅ ปุ่ม "เชื่อมบัญชี" ใช้ `liffDeepLink("/line/liff")` (LIFF URL จริงเมื่อมี `NEXT_PUBLIC_LIFF_ID`, fallback URL ธรรมดา) |

**Edge cases**
- ~~ID token ไม่มี email~~ **ตัดสินใจแล้ว**: ใช้ placeholder `line_{userId}@line.morroo.com` (`lib/line-auth.ts` → `linePlaceholderEmail()`) ไม่บล็อกผู้ใช้ที่ด่านนี้ (ไม่ได้เพิ่ม flag `email_missing` ในรอบนี้ — ถ้าต้องการ nudge ให้กรอก email จริงทีหลัง ทำเป็นงานแยกต่างหากที่ onboarding)
- ผู้ใช้ล็อกอินเว็บด้วยบัญชี A แต่ LINE ผูกกับ B อยู่แล้ว → **ทำแล้ว**: ไม่ link ทับ ตอบ `{ ok:true, linked:false, reason:"already_linked_other" }` (`linkLineToUser` ใน `lib/line-auth.ts`)
- Rate limit บน `/api/auth/line/liff-session`: **ยังไม่ทำ** — ตัดสินใจข้ามในรอบนี้เพื่อไม่ให้ scope บวม เพราะ endpoint นี้ยิงผ่านได้ก็ต่อเมื่อมี ID token ที่ LINE เซ็นจริงเท่านั้น (ความเสี่ยง abuse ต่ำกว่า endpoint เปิดสาธารณะทั่วไป) — ถ้าพบการยิงซ้ำผิดปกติค่อยเพิ่ม pattern เดียวกับ `LINE_RATE_LIMIT_PER_HOUR` ใน webhook ทีหลัง

### Phase 2 — หน้า LIFF แบบเบา + deep link (~ครึ่งวัน)

| ไฟล์ | งาน |
|---|---|
| `app/(liff)/layout.tsx` (ใหม่) | root layout เบา: font + globals.css + PostHog เท่านั้น **ไม่มี** Navbar, Footer, ChatWidget, ExitIntentPopup, FirstVisitNudge, BetaPromoBanner, GTM/FB pixel (กัน popup ทับหน้า LIFF และลด JS) |
| `app/(liff)/line/liff/[[...path]]/page.tsx` | ย้ายจาก `app/(morroo)/line/liff/page.tsx`; อ่าน `params.path` + `searchParams` → หลัง liff-session สำเร็จ `location.replace("/" + path.join("/") + "?" + query)`; ถ้าไม่มี path → แสดงการ์ด "เชื่อมบัญชีสำเร็จ" เหมือนเดิม + ปุ่ม `liff.closeWindow()` |
| `lib/safe-redirect.ts` | ใช้ `safeInternalPath` กับ path ที่ประกอบขึ้น กัน open redirect |
| `lib/line-links.ts` (ใหม่) | `lineDeepLink(path, utm?)` → คืน `https://liff.line.me/${NEXT_PUBLIC_LIFF_ID}${path}` ถ้ามี LIFF ID, ไม่มีให้ fallback `https://www.morroo.com${path}`; + `SITE_URL` trimmed ที่เดียว |

หมายเหตุ Next.js: ก่อนเขียนโค้ดต้องอ่าน `node_modules/next/dist/docs/` ตาม `AGENTS.md` (route group ที่มี root layout ของตัวเอง, `middleware.ts` vs `proxy.ts`, `searchParams` เป็น Promise ใน Next 16)

### Phase 3 — เปลี่ยนปุ่มใน Flex ให้เป็น LIFF ✅ เสร็จแล้ว (2026‑09‑22)

**เปลี่ยนใจจากแผนเดิม**: แผนแรกจะทำทีละใบ (เริ่มจากปุ่มเดียว วัดผล 1 สัปดาห์ค่อยทำต่อ) แต่พอ auth bridge ยืนยันว่าทำงานถูกต้องจริงในแอป LINE แล้ว (Phase 0+1 ผ่านการทดสอบมือ) จึงตัดสินใจแปลงปุ่มลูกค้าทั้งหมดในรอบเดียว เพราะความเสี่ยงต่ำ (แค่ห่อ URL, มี test คุ้มกัน) และไม่มีเหตุผลต้องรอ

**สิ่งที่ทำจริง:**
- `lib/line-links.ts` (ใหม่) — `toLiffUri(fullUrl)`: รับ URL เต็มที่ caller สร้างไว้แล้ว (คง query/UTM ทุกตัว) แล้วห่อเป็น `https://liff.line.me/{LIFF_ID}<path><search>` เฉพาะเมื่อ host เป็น `www.morroo.com`/`morroo.com`; ไม่ใช่ host ของเราหรือไม่มี `NEXT_PUBLIC_LIFF_ID` → คืนค่าเดิมเฉยๆ. `liffDeepLink(path)` สำหรับกรณีมีแค่ path เปล่า (ย้ายมาจาก `lib/daily-mcq-line.ts` เดิม)
- ห่อทุกปุ่มลูกค้าใน `lib/line-flex-templates.ts`: `buildWeeklySummaryFlex`, `buildBlogAnnounceFlex` (+ `buildBlogDigestCarousel` ที่ reuse), `buildWeeklyNewsletterFlex`, `buildExpiryWarningMessage`, `buildStreakNudgeFlex`, `buildExamResultFlex`, `buildChatbotCard` (ทั้ง 4 การ์ดย่อย: pricing/register/longcase/meq), `buildDailyMcqBubble`/`buildWeeklyHardMcqBubble` (รับ `practiceUrl` ที่ห่อมาจาก caller แล้ว), `buildDailyMcqResultFlex` (เช่นกัน), `buildNewLongCaseBubble`, `buildCasegameTeaserBubble`, `buildWeekRecapBubble`
- `lib/daily-mcq-line.ts`: `dailyPracticeUrl()` ห่อด้วย `toLiffUri` ที่จุดเดียว (ครอบคลุมทั้งปุ่ม Flex และลิงก์ในข้อความ share/expired), ลิงก์ redeem code (streak‑5 reward) ก็ห่อด้วย — **เปลี่ยนใจจากแผนเดิม**: `practiceUrl`/`shareUrl` ก็แปลงเป็น LIFF ด้วย (ไม่ใช่แค่ `liffUrl` ปุ่มเชื่อมบัญชี) เพราะข้อดีคือเพื่อนที่กดลิงก์จากการแชร์ต่อก็ได้ auto sign‑in/sign‑up ทันทีเหมือนกัน ไม่มีข้อเสียที่มองเห็น
- **ตั้งใจไม่แตะ**: การ์ดแอดมิน (`buildAdminDigestFlex` → `/admin`, `buildAdsSuggestFlex`/`buildAdsMergeConfirmFlex` ระบบ ads‑autofix) เพราะเป็นเครื่องมือภายใน ไม่ใช่ลูกค้า; แคปชัน FB/IG (`lib/autopost-copy.ts`, `lib/facebook.ts`, `lib/instagram.ts`) เพราะ LIFF URL เปิดนอกแอป LINE จะเด้ง LINE Login ก่อน ไม่เหมาะกับ social caption — คนละไฟล์กับ `line-flex-templates.ts`/`daily-mcq-line.ts` อยู่แล้วจึงไม่มีความเสี่ยงชนกัน มี regression test ใน `lib/autopost-copy.test.ts` ยืนยันไม่มี `liff.line.me` หลุดเข้าไป
- Rich menu ใน OA Manager (ตั้งค่านอกโค้ด) — **ยังไม่ทำ**, ทำเมื่อสะดวก ไม่บล็อกอะไร

**Tests**: `lib/line-links.test.ts` (ใหม่, ครอบ `toLiffUri`/`liffDeepLink` ทั้ง happy path + fallback), เพิ่ม describe block ใน `lib/line-flex-templates.test.ts` ยืนยันปุ่มลูกค้าแต่ละใบห่อถูกต้อง + การ์ดแอดมิน/ads‑autofix ไม่ถูกแตะแม้ตั้ง LIFF_ID ไว้, `lib/autopost-copy.test.ts` (ใหม่) กัน FB/IG caption หลุด LIFF URL — รวม 854 เทสทั้งโปรเจกต์ผ่านหมด

### Phase 4 — เลิก link code (optional, ~2 ชม.)

- `app/(morroo)/profile/page.tsx`: แทนปุ่ม "สร้างรหัส" ด้วยปุ่มเดียว "เชื่อม LINE" → `href = lineDeepLink("/profile")` (เปิดแอป LINE → LIFF → link → กลับมา `/profile` พร้อม badge ✅)
- `components/FloatingLineButton.tsx` / `SocialLinks.line`: ชี้ LIFF (aggressive add‑friend) แทน `line.me/R/ti/p/` → แอดเพื่อน + เชื่อมบัญชีในจังหวะเดียวถ้าล็อกอินเว็บอยู่
- `OnboardingChecklist` ข้อ "เชื่อม LINE" ใช้ลิงก์เดียวกัน
- คง `generate-code` + webhook `MORROO-` ไว้เป็น fallback อีก 1 รอบ release แล้วค่อยลบ

### Phase 5 — ของแถมที่ LIFF เปิดโอกาสให้ (ทำทีหลัง)

- `liff.shareTargetPicker()` สำหรับ "แชร์ข้อนี้ให้เพื่อน" (ส่ง Flex การ์ดข้อสอบให้เพื่อนตรงๆ แทน `line.me/R/share?text=`)
- `liff.sendMessages()` หลังทำข้อสอบเสร็จใน LIFF ให้พิมพ์ผลลง chat ตัวเอง (ฟรี ไม่กินโควตา)
- ปิดหน้าอัตโนมัติ `liff.closeWindow()` หลัง link เสร็จเมื่อไม่มี `next`

---

## 5. autopost ต้องแก้อะไรบ้าง (คำตอบตรงๆ)

**ไม่ต้องแก้ pipeline** — FB/IG/scheduled/retry ทำงานเหมือนเดิมทุกอย่าง LIFF เป็นเรื่องของ "ลิงก์ที่ใส่ในข้อความ LINE" เท่านั้น สิ่งที่ควรแก้เพื่อให้ทำงานง่ายขึ้นและวัดผลได้:

| # | งาน | ไฟล์ | เหตุผล |
|---|---|---|---|
| A1 | รวม base URL ไว้ที่เดียว (`lib/line-links.ts` / `lib/site-url.ts`) | `lib/news-autopost.ts`, `app/api/autopost/retry/route.ts`, `lib/line-flex-templates.ts`, `lib/daily-mcq-line.ts` | ตอนนี้ hardcode 4 ที่ + มี comment เรื่อง env มี trailing whitespace ทำ LINE reject URI — แก้ครั้งเดียวจบ และเป็นจุดสลับ LIFF/ธรรมดา |
| A2 | Flex builder รับ `path` แทน `url` เต็ม (`buildBlogAnnounceFlex`, `buildBlogDigestCarousel`) | `lib/line-flex-templates.ts` + callers 3 ที่ | ให้ template ตัดสินใจเองว่าจะห่อเป็น LIFF ไหม caller ไม่ต้องรู้ |
| A3 | ใส่ UTM ให้ลิงก์ digest/news ฝั่ง LINE (`utm_source=line&utm_medium=digest|news&utm_campaign=<date>`) | `app/api/cron/line-weekly-blog-digest/route.ts`, `lib/news-autopost.ts` | ตอนนี้วัดไม่ได้เลยว่า LINE digest พาคนเข้าเว็บกี่คน (daily MCQ วัดได้แล้ว) |
| A4 | `autopostNewsItem` เรียก `checkLineQuota()` ก่อน broadcast | `lib/news-autopost.ts` | ให้เหมือน digest — กันซ้ำรอย Aug 2026 |
| A5 | ซ่อน/เตือน platform `line` ในหน้า schedule ของ admin | `app/(morroo)/admin/autopost/page.tsx` | นโยบายตอนนี้คือ LINE = digest รายสัปดาห์เท่านั้น การ schedule ต่อบทความจะ broadcast ทั้ง OA (ไม่พัง เพราะ `line_broadcast_at` กัน digest ซ้ำ แต่เปลืองโควตา) |
| A6 | เพิ่ม test: `lineDeepLink()` คืน LIFF URL เมื่อมี ID / fallback เมื่อไม่มี, และ FB caption ไม่มี `liff.line.me` | `lib/line-links.test.ts`, `lib/autopost-copy.test.ts` | กัน LIFF URL หลุดไป FB/IG |

สิ่งที่ **ไม่ต้อง** แก้: `scripts/generate-blog.mjs`, cron IG ทุกตัว, `lib/facebook.ts`, `lib/instagram.ts`, story/carousel image pipeline, `scheduled_autoposts` schema

---

## 6. webhook ใช้ reply แทน push ✅ เสร็จแล้ว (2026‑09‑22)

`app/api/line/webhook/route.ts` เดิม parse event โดยไม่อ่าน `replyToken` แล้วตอบทุกอย่างด้วย `sendLineMessage` (push) — ทั้ง chatbot reply, greeting ตอน follow, เฉลย daily MCQ, ads‑autofix, ผลลิงก์โค้ด MORROO‑XXXXXX — **ทุกข้อความนับโควตา** ทั้งที่ reply API ฟรี

**สิ่งที่ทำจริง:**
- `lib/line.ts`: เพิ่ม `replyLineMessage(replyToken, messages)` → `POST /v2/bot/message/reply` (ไม่มี quota check เพราะ reply API ไม่กินโควตา push/broadcast อยู่แล้ว) และ `replyOrPushLineMessage(lineUserId, replyToken, messages)` — reply ก่อน ถ้าไม่สำเร็จ (token หมดอายุ/ใช้ซ้ำ/ไม่มี token) fallback ไป `sendLineMessage` (push) ให้อัตโนมัติ
- `app/api/line/webhook/route.ts`: อ่าน `event.replyToken` จากทุก event แล้วเปลี่ยนทุกจุดที่เคย `sendLineMessage` เป็น `replyOrPushLineMessage` — ครอบคลุม postback (ads‑autofix, daily MCQ), follow greeting, non‑text greeting, chatbot reply (ทั้ง rate‑limit/email‑capture/ปกติ), ผลลัพธ์โค้ด MORROO‑XXXXXX ทุกกรณี (ไม่พบ/หมดอายุ/ผูกกับบัญชีอื่น/error/สำเร็จ)
- `app/api/line/jiaroo-webhook/route.ts`: ตรวจแล้วไม่มีการส่งข้อความ LINE เลย (webhook คนละแบบ) ไม่มีอะไรต้องแก้
- Tests: `lib/line.test.ts` เพิ่มเทสคลุม `replyLineMessage` (สำเร็จ/token ไม่ถูกต้อง/ไม่มี access token) และ `replyOrPushLineMessage` (reply สำเร็จไม่แตะ push, ไม่มี replyToken ไป push ตรง, reply ล้มเหลว fallback ไป push) — รวม 860 เทสทั้งโปรเจกต์ผ่านหมด

ผลคือโควตาที่เหลือไปใช้กับ daily MCQ push / digest broadcast ได้มากขึ้น เพราะข้อความตอบโต้ในแชท (ซึ่งเป็นปริมาณหลักของ traffic) ไม่กินโควตาอีกต่อไป

---

## 7. ลำดับที่แนะนำ + ประมาณเวลา

| ลำดับ | งาน | เวลา | ขึ้นกับ |
|---|---|---|---|
| 1 | Phase 0 (console) | 0.5 ชม. | — |
| 2 | §6 reply‑token | 2 ชม. | — |
| 3 | A1 + A2 + A3 + A4 + A6 (link builder ฝั่ง LINE) | 3 ชม. | — |
| 4 | Phase 1 (auth bridge) | 1 วัน | 1 |
| 5 | Phase 2 (layout เบา + catch‑all) | 0.5 วัน | 4 |
| 6 | Phase 3 ข้อ 1‑2 (daily MCQ, payment) | 2 ชม. | 3, 5 |
| 7 | วัดผล 1 สัปดาห์: click‑through ของ daily MCQ / link rate | — | 6 |
| 8 | Phase 3 ข้อ 3‑6 + Phase 4 | 0.5 วัน | 7 |
| 9 | Phase 5 | ตามสะดวก | 8 |

ข้อ 2 และ 3 ส่งเป็น PR แยกได้ทันที ไม่ต้องรอ LIFF

---

## 8. ความเสี่ยง / สิ่งที่ต้องระวัง

- **`userId` ไม่ตรงกัน** ถ้า LINE Login channel ไม่ได้ link กับ OA → link บัญชีผ่าน LIFF จะได้ ID ที่ webhook ไม่รู้จัก ต้องเช็คใน console ก่อนเริ่ม Phase 1
- **เปิดนอกแอป LINE** (desktop / คนก๊อปลิงก์ไปแชร์ที่อื่น): LIFF URL จะเด้งไป LINE Login web — ใช้ได้แต่ UX ไม่ดี จึงห้ามใช้ LIFF URL ใน FB/IG/email (A6 กันไว้)
- **LINE Flex `uri` validation เข้มมาก** — `https://liff.line.me/...` ผ่านแน่นอน แต่ห้ามมี whitespace (เหตุผลเดียวกับ `.trim()` ที่มีอยู่)
- **ID token ไม่มี email** → ต้องเลือกนโยบาย (placeholder vs บล็อก) ก่อนเขียน Phase 1
- **Session cookie ใน LIFF browser บน iOS**: first‑party ปกติ ไม่มีปัญหา ITP แต่ถ้าใครเปิด LIFF แล้ว "เปิดในเบราว์เซอร์ภายนอก" cookie จะไม่ตามไป — ยอมรับได้ (ผู้ใช้กด login ปกติได้)
- **Preview deploy**: LIFF ต้องมี endpoint ตายตัว ทดสอบบน preview ต้องมี LIFF app ตัวที่ 2 หรือทดสอบ auth bridge ด้วย unit test + production canary
- **`middleware.ts`**: ถ้า Next 16 ใน repo ย้ายไป `proxy.ts` แล้ว การเพิ่ม route group ใหม่ต้องเช็คว่า `updateSession` ยังครอบ `/line/liff/*` (ต้องครอบ เพราะ verifyOtp set cookie ผ่าน SSR client)

---

## 9. Checklist ก่อนเปิดใช้จริง

- [ ] เปิด `https://liff.line.me/{ID}/nl/practice?q=<uuid>` จากในแอป LINE → เห็นหน้า practice แบบล็อกอินแล้ว ไม่ผ่านหน้า login
- [ ] ผู้ใช้ใหม่ (ไม่มีบัญชี) เปิด LIFF → มี user ใหม่ใน `auth.users` + `profiles.line_user_id` ถูกต้อง
- [ ] ผู้ใช้ที่ล็อกอินเว็บด้วย Google อยู่แล้ว เปิด LIFF → link เข้าบัญชีเดิม ไม่สร้างซ้ำ
- [ ] LINE ที่ผูกบัญชี B แล้ว เปิด LIFF ขณะล็อกอิน A → ไม่ทับ แสดงข้อความ
- [ ] daily MCQ postback ยังทำงาน และปุ่ม "เชื่อมบัญชี" หายไปหลังผูกแล้ว (`needsLink=false`)
- [ ] FB caption / IG caption ไม่มี `liff.line.me`
- [ ] digest carousel ผ่าน LINE validation (ส่งหา `ADMIN_LINE_USER_ID` ก่อน broadcast)
- [ ] PostHog เห็น `utm_source=line&utm_medium=digest`
