# แผนใส่รูปประกอบบทเรียน School (Lesson Illustrations)

> สถานะ (20 ก.ย. 2026): **Phase 0 ทำแล้ว** (`LessonFigure`, ช่อง alt/caption ในแอดมิน,
> `school_visuals.lesson_id`, การ์ดสรุปท้ายบท, thumbnail ในลิสต์บท, event PostHog) ·
> **สคริปต์ระดับ 2 เขียนแล้วและรันกับ API จริงแล้ว** (`npm run gen:figures` → `scripts/generate-lesson-figures.ts`) —
> diagram (Claude เขียน SVG) ใช้งานได้ดี ทดสอบจริงกับบท FMMD 1201 lesson 1 สำเร็จ ·
> **Phase 1 นำร่อง FMMD 1201** วาด SVG มือ 15 รูปไว้ที่ `public/lesson-images/school/cell-biology/` —
> ใส่เข้า DB ด้วย `supabase/school_figures_cell_biology_20260920.sql` **หลัง deploy** (ไฟล์รูปต้องขึ้นเว็บก่อน ไม่งั้นรูปแตก)
>
> **เปลี่ยนจากแผนเดิม:** ทดสอบ hero ด้วย gpt-image-2.5-flare ผ่าน API ตรง ๆ แล้วคุณภาพ/สไตล์ไม่นิ่งพอ
> (ครั้งหนึ่งหลุดเป็นภาพมืดมีกะโหลก ทั้งที่ prompt สั่ง flat/friendly ไว้) เทียบกับรูปที่ทำเอง/อัปโหลดมือผ่าน
> `/admin/school` ไม่ได้คุณภาพเท่า — **ตัดสินใจ (20 ก.ย.): ปิด hero-by-AI เป็นค่าเริ่มต้นในสคริปต์
> (`WITH_HERO=1` ถึงจะเปิด) ให้แอดมินหา/อัปโหลด hero เองแทน** diagram ยังเป็น AI (Claude เขียน SVG)
> เหมือนเดิมเพราะคุมคุณภาพ label ได้ 100% ไม่มีปัญหาเรื่องสไตล์หลุด
>
> ตัวเลือกอื่นในหัวข้อ 7: summary card เก็บใน `school_visuals` + `lesson_id`, Phase 1 รีวิวโดยแอดมินก่อนปล่อย

## 0. ปัญหาและเป้าหมาย

บทเรียนใน School ตอนนี้เป็นตัวหนังสือล้วน นักเรียนอ่านแล้วเบื่อและสรุปใจความไม่ได้
เป้าหมายของรูปจึงไม่ใช่ "ตกแต่ง" แต่คือ **ช่วยสรุปใจความของแต่ละ Part ให้เห็นในภาพเดียว**
(dual coding: อ่าน + เห็นภาพ → จำได้นานกว่า) และมีจังหวะพักสายตาทุก ~150 คำ

### สภาพปัจจุบัน (จาก DB โปรเจกต์ `morroo`)

| รายการ | ค่า |
|---|---|
| วิชา (`school_topics`) | 10 (มีบทเรียนแล้ว 8 วิชา) |
| บทเรียน (`school_lessons`) | 44 |
| บทเรียนที่มีรูป (`![` ใน body_md) | **0** |
| ความยาวเฉลี่ยต่อบท | ~10,000 ตัวอักษร · 4 Part |
| Visual Summaries (`school_visuals`) | 0 |
| Flashcard ที่มี `image_url` | 0 |

### ของที่ "มีอยู่แล้ว" และเอามาต่อได้ทันที (ไม่ต้องสร้างใหม่)

| ชิ้นส่วน | ที่อยู่ | ใช้ทำอะไร |
|---|---|---|
| ปุ่ม "+ แทรกรูปตรงนี้" ระหว่างทุก Part | `components/school/LessonReader.tsx` (`onInsertImage`) + `SchoolAdminPanel.tsx` tab **แก้ไข** | แอดมินอัปรูปแล้วระบบเขียน `![](url)` ลง `body_md` ให้เอง โดยไม่แตะ marker `## ⏸ Mini Quiz` |
| API อัปโหลดรูป (admin เท่านั้น) | `app/api/admin/school/upload-image/route.ts` → bucket `public-assets/school/` | รับ png/jpg/webp/gif/**svg** ≤ 8 MB คืน public URL |
| ตาราง + หน้า Visual Summaries | `school_visuals`, `/school/visuals`, tab **Visual** ใน admin | รูปสรุป 1 ภาพต่อบท + quick check + flashcard ที่เกี่ยว |
| เรนเดอร์รูปที่มีตัวหนังสือไทยเป็น PNG | `next/og` (`ImageResponse`) ใน `lib/autopost-story-image.tsx`, `lib/autopost-carousel-image.tsx` | ฟอนต์ไทยชัด ใช้ทำ "การ์ดสรุป" แบบ template ได้ |
| เรียกโมเดลสร้างรูป | `app/api/blog/generate/route.ts` (OpenAI `gpt-image-1`) และ `scripts/backfill-blog-covers.mjs` (Together FLUX) + `scripts/lib/cover-compose.mjs` (sharp ซ้อนข้อความไทย) | ภาพประกอบเชิง illustration แบบ "ห้ามมีตัวหนังสือ" |
| Import pipeline ที่ให้ Claude เขียนบท | `app/api/admin/school/import/route.ts` (tool schema `body_md`) | จุดที่จะให้ AI "ระบุว่าควรมีรูปอะไรตรงไหน" ตั้งแต่ตอนสร้างบท |

สรุปคือ **ท่อส่งรูปเข้าบทเรียนมีแล้ว ขาดแค่ (1) ตัวรูป และ (2) วิธีแสดงรูปให้มี caption/alt** — แผนนี้จึงเน้นสองอย่างนั้น

---

## 1. รูปแบบรูป 3 ชนิด (แต่ละชนิดตอบโจทย์คนละอย่าง)

| ชนิด | ตอบโจทย์ | วิธีทำ | ต่อบทมีกี่รูป |
|---|---|---|---|
| **A. Hero (ภาพเปิดบท)** | ดึงความสนใจ บอกว่าบทนี้ว่าด้วยอะไร | AI illustration (`gpt-image-1`) โดย prompt ห้ามมีตัวหนังสือ แล้วใส่คำบรรยายไทยใต้รูปด้วย markdown | 1 (ก่อน Part 1) |
| **B. Diagram (แผนภาพสรุป Part)** | *"สรุปใจความ"* — กลไก / ขั้นตอน / การจำแนก / เปรียบเทียบ ของ Part นั้น | **SVG ที่ Claude เขียนเอง** (label ไทยได้ ไฟล์เล็ก คมทุกขนาดจอ) หรือ Mermaid → SVG | 1 ต่อ Part (3–4 รูป) |
| **C. Summary card (สรุปท้ายบท 1 ภาพ)** | ทวนก่อนทำ Final Retrieval + ใช้แชร์/ทบทวนได้ | template `next/og` (ฟอนต์ไทย) → PNG จาก 3–5 key points ที่ Claude สกัดจากบท | 1 (เก็บใน `school_visuals` และโชว์ที่การ์ด "เรียนจบบทนี้แล้ว") |

**ทำไม Diagram ต้องเป็น SVG ไม่ใช่รูป AI:** โมเดลสร้างรูป (gpt-image-1 / FLUX) เขียนตัวหนังสือไทยเพี้ยนและวาง label ผิดที่บ่อย
รูปที่ต้อง "อ่านแล้วเข้าใจ" (ลูกศร กล่อง ชื่อโครงสร้าง) จึงให้ Claude สร้างเป็น SVG ตรง ๆ ดีกว่า —
เราคุมข้อความได้ 100 % ตรวจแก้ได้ด้วยมือ และอัปผ่าน API เดิมได้เพราะรับ `image/svg+xml` อยู่แล้ว
ส่วนรูป AI เอาไว้ทำ Hero ที่ต้องการ "บรรยากาศ" ไม่ต้องการความถูกต้องของ label

### แนวทางออกแบบรูปให้ "สรุปได้" (ใช้เป็น checklist ตอนรีวิว)

1. รูป 1 รูป = ประเด็นเดียว ตอบคำถาม "Part นี้ต้องจำอะไร" ได้ในภาพ
2. ≤ 7 องค์ประกอบ / ≤ 5 label; label เป็น **ไทย + ศัพท์อังกฤษในวงเล็บ** เหมือนภาษาที่ใช้ในบท
3. ทุกรูปมี **caption 1 ประโยค** (บอกว่าต้องดูอะไร) และ **alt** (สำหรับ screen reader / เวลารูปโหลดไม่ขึ้น)
4. พาเลตเดียวทั้งระบบ: ใช้สีตาม layer เดิม (anatomy / physio / biochem / path / pharm / clinical / foundation) ให้นักเรียนจำสีได้
5. ห้ามใส่ตัวเลข dose / cut‑off ที่ไม่มีในบท (กติกาเดียวกับ import mode `expand`)
6. ไม่ก๊อปรูปจากตำรา/สไลด์อาจารย์ — ใช้รูปที่สร้างเอง; ถ้าใช้รูป CC ต้องระบุที่มาใน caption
7. ราสเตอร์: กว้าง ≤ 1200 px, `.webp`; เวกเตอร์: `.svg` ไม่ฝังฟอนต์ (ใช้ `font-family: system-ui, sans-serif`)

---

## 2. วางรูปตรงไหนในบท (กติกาต่อ Part)

โครงบทตอนนี้คือ `Part 1 → ⏸ quiz → Part 2 → ⏸ quiz → … → Part 4 → Final Retrieval`
(แยกด้วย `splitLessonParts` ใน `lib/school/lesson-parts.ts`)

```
[Hero A + caption]                 ← บรรทัดแรกของ Part 1
Part 1: ย่อหน้าเปิด
[Diagram B1]                       ← หลังย่อหน้าที่ "แนะนำ concept" ไม่ใช่ท้าย Part
Part 1: ย่อหน้าที่เหลือ
## ⏸ Mini Quiz  (ไม่แตะ)
Part 2 …  [Diagram B2] …
## ⏸ Mini Quiz
Part 3 …  [Diagram B3] …
## ⏸ Mini Quiz
Part 4 …  [Diagram B4 หรือไม่มีถ้า Part เป็นสรุป/pearls]
                                   ← การ์ด "เรียนจบ" โชว์ Summary card C + ลิงก์ /school/visual/[id]
Final Retrieval
```

กติกา
- **1 Part = 1 รูป** (อย่างมาก 2) ให้มีจังหวะพักทุก ~150 คำ แต่ไม่ถี่จนอ่านไม่ต่อเนื่อง
- วางรูป **หลังย่อหน้าที่แนะนำเรื่องนั้น** เพื่อให้ "อ่านนิดหน่อย → เห็นภาพ → อ่านรายละเอียด"
- Part ที่เป็น "💡 Clinical pearls / 🎯 Mnemonics / 🔗 Connections" ไม่ต้องมี diagram (ใช้ Summary card แทน)
- mini quiz ควรอ้างถึงรูปได้ เช่น "จากแผนภาพ ข้อใด…" — ทำให้รูปมีเหตุผลที่ต้องดู

### รูปแบบ markdown ที่จะใช้ (คอนเวนชันใหม่)

```md
![alt ภาษาไทยสั้น ๆ](https://…/public-assets/school/xxxx.svg "caption: ระนาบ 3 แบบของร่างกาย — sagittal แบ่งซ้าย/ขวา")
```

- ใช้ `title` ของ markdown image (ข้อความในเครื่องหมายคำพูด) เป็น **caption** — react-markdown ส่งมาเป็น prop `title` อยู่แล้ว
  ไม่ต้องแก้ตัว parser และไม่กระทบ `splitLessonParts`
- ตอนนี้ปุ่มแทรกรูปเขียน `![](url)` เปล่า ๆ → ต้องเพิ่มช่องกรอก alt + caption (ดู Phase 0)

---

## 3. วิธี "ทำรูปขึ้นมา" — 3 ระดับ เลือกตามกำลัง

### ระดับ 1 — มือล้วน (ทำได้วันนี้ ไม่ต้องแก้โค้ด)

เข้า `/admin/school` → tab **แก้ไข** → เลือกบท → กด "+ แทรกรูปตรงนี้" ระหว่าง Part → เลือกไฟล์ → บันทึก
เหมาะกับรูปที่วาดเอง / ทำใน Canva / Excalidraw แล้ว export PNG‑WebP
ข้อจำกัด: 44 บท × ~5 รูป ≈ 220 รูป ทำมือไม่ไหว → ใช้ระดับ 1 กับ **บทนำร่อง** เท่านั้น

### ระดับ 2 — กึ่งอัตโนมัติ (แนะนำเป็นตัวหลัก): สคริปต์ `scripts/generate-lesson-figures.mjs`

ต่อบทเรียน 1 บท สคริปต์ทำ 4 ขั้น (ดึง lesson จาก DB ด้วย service role เหมือน `backfill-blog-covers.mjs`)

1. **Figure spec** — ส่ง `body_md` ทั้งบทให้ Claude (`claude-sonnet-4-6`) พร้อม tool `propose_figures` ให้คืน JSON

   ```json
   {
     "hero": { "alt": "...", "caption": "...", "image_prompt": "English scene, no text" },
     "figures": [
       { "part": 1, "after_paragraph": 2, "kind": "diagram",
         "title": "ระนาบของร่างกาย", "alt": "...", "caption": "...",
         "svg": "<svg viewBox='0 0 800 480' …>…</svg>" }
     ],
     "summary": { "headline": "...", "points": ["…", "…", "…"], "check_questions": [{ "q": "...", "a": "..." }] }
   }
   ```

   กติกาใน prompt: ไม่เกิน 1 รูป/Part, label ≤ 5, ห้าม dose/cut‑off นอกบท, SVG ต้องมี `viewBox`, ไม่ใช้ `<foreignObject>`, ไม่ใช้ฟอนต์ภายนอก
2. **Render**
   - `kind: "diagram"` → เซฟ SVG ตรง ๆ (ตรวจด้วย `sharp` ว่าพาร์สได้ + ขนาด ≤ 200 KB)
   - `hero` → `gpt-image-1` (โค้ด + key เดิมจาก blog generate) → `sharp` แปลง webp กว้าง 1200
   - `summary` → template `next/og` แบบเดียวกับ `lib/autopost-carousel-image.tsx` (พาเลตตาม layer) → PNG 1080×1350
3. **Upload** ไป `public-assets/school/lessons/{lesson_id}/{hero|p1|p2|p3|summary}.{svg|webp|png}` (upsert ทับได้ตอนรีเจน)
4. **เขียนกลับ** — ใช้ `splitLessonPartsRaw` / `joinLessonParts` แทรก `![alt](url "caption")` ตามตำแหน่ง `part` + `after_paragraph`
   และ `insert` แถวใน `school_visuals` (topic_id, layer, title, image_url, notes_md = points, check_questions)

การควบคุม: `LESSON_ID=…` ทำทีละบท, `TOPIC=FMMD 1201` ทำทั้งวิชา, `DRY=1` แค่พิมพ์ spec ไม่อัป, `FORCE=1` รีเจนทับ
ทุกบทที่รันแล้ว **ต้องเปิดดูใน `/admin/school` tab แก้ไข ก่อนปล่อย** (แอดมินเห็นเหมือนนักเรียนเป๊ะ)
ถ้ารูปไหนไม่ดี ให้แก้ SVG ในมือ (เป็นข้อความ แก้ง่าย) หรือกดอัปรูปใหม่ทับ

ต้นทุนโดยประมาณต่อบท: Claude 1 call (~15k token in / ~6k out) + gpt‑image‑1 1 รูป → ทั้ง 44 บทอยู่ในหลักไม่กี่ร้อยบาท
(SVG กับ next/og ไม่มีค่ารูป) — ยืนยันราคาจริงกับหน้า pricing ก่อนรันทั้งชุด

### ระดับ 3 — ฝังในท่อสร้างบท (ทำหลังระดับ 2 นิ่งแล้ว)

- `app/api/admin/school/import/route.ts`: เพิ่ม `figures[]` ใน tool schema ของ step lesson ให้ Claude คิดรูปพร้อมเขียนบท
  (ตอนเขียนบทเขาเห็น source อยู่แล้ว spec จะตรงเนื้อหากว่า) แล้วเรียก renderer เดียวกับสคริปต์ใน `after()` เหมือน blog cover
- `app/api/cron/school-enrich/route.ts`: เพิ่มโหมด "บทที่ยังไม่มีรูป" วันละ N บท ให้ค่อย ๆ เติมเองจนครบ
- `docs/school-lesson-template.md`: เพิ่มหัวข้อ "รูปประกอบ" (1 Part 1 รูป, caption/alt บังคับ, SVG สำหรับ diagram)

---

## 4. งานฝั่งโค้ดที่ต้องทำก่อน (Phase 0 — ~1 วัน)

| # | งาน | ไฟล์ | หมายเหตุ |
|---|---|---|---|
| 1 | คอมโพเนนต์ `LessonFigure`: `<figure>` + `<img loading="lazy">` + `<figcaption>` จาก `title`, มุมมน, กดขยายเต็มจอ (dialog) | `components/school/LessonFigure.tsx` (ใหม่) | ใช้ `<img>` ธรรมดา ไม่ใช้ `next/image` เพราะ SVG จาก storage และไม่รู้ขนาดล่วงหน้า |
| 2 | ส่ง `components={{ img: LessonFigure }}` ให้ `ReactMarkdown` | `components/school/LessonReader.tsx`, `BookReader.tsx`, `CaseWalker.tsx`, `DailyLessonStepper.tsx`, `GuidedRunner.tsx` | ทุกที่ที่เรนเดอร์ body_md |
| 3 | ช่องแทรกรูปในแอดมิน: เพิ่ม input alt + caption แล้วเขียน `![alt](url "caption")` | `SchoolAdminPanel.tsx` (`insertImageInLessonPart`, `insertImageInChapter`), `ImageUploader.tsx` | ใส่ default ให้กรอกน้อยสุด |
| 4 | การ์ด "เรียนจบบทนี้แล้ว" โชว์ Summary card ของบท + ลิงก์ไป `/school/visual/[id]` | `LessonReader.tsx`, query ใน `lib/supabase/queries-school.ts` (หา visual ของ lesson) | ต้องมีวิธีผูก visual ↔ lesson: เพิ่มคอลัมน์ `lesson_id uuid null` ใน `school_visuals` (migration ใหม่) |
| 5 | Thumbnail ในลิสต์บท: ใช้ Hero ของบทเป็นรูปเล็กในการ์ด | `components/school/ChapterList.tsx` | ดึงจากรูปแรกใน body_md (regex) หรือเก็บ `hero_url` ใน `school_lessons` |
| 6 | PostHog event `lesson_figure_zoom` และมี property `has_figures` ตอน `lesson_completed` | `LessonFigure.tsx`, `LessonReader.tsx` | ไว้วัดผลข้อ 6 |

---

## 5. แผนรูปรายวิชา (44 บทที่มีอยู่)

ระบุว่าแต่ละวิชาควรใช้ diagram แบบไหน เพื่อให้ prompt ของสคริปต์เจาะจงต่อวิชาได้

| วิชา | บท | Diagram ที่เหมาะ (ชนิด B) | Hero (ชนิด A) |
|---|---|---|---|
| FMMD 1101 บทนำคำศัพท์ทางการแพทย์ | 7 | **แยกส่วนคำ** (prefix–root–suffix เป็นกล่องต่อกัน), ระนาบ/ทิศทางร่างกาย (รูปคนกับเส้นระนาบ), ตารางภาพศัพท์ตามระบบ | นักศึกษาแพทย์กับตำรา/ป้ายอวัยวะ |
| FMMD 1103 คณิต‑ฟิสิกส์ | 6 | **กราฟจริง** (sin/log, อนุพันธ์‑ปริพันธ์, การแจกแจงความน่าจะเป็น) — สร้างเป็น SVG จากสูตรจริงด้วยโค้ด ไม่ให้ AI วาดเดา; free‑body diagram ของ statics/biomechanics | กราฟ/แรงบนโครงกระดูก |
| FMMD 1104 เคมี | 6 | ตารางธาตุย่อ, โครงสร้าง functional group, **แผนภาพ pH scale**, ขั้น stoichiometry เป็น flow | หลอดทดลอง/โมเลกุล |
| FMMD 1105 ดิจิทัล | 3 | **Flowchart** ขั้นตอนประเมินแหล่งข้อมูล (CRAAP), ภาพหน้าจอ Excel ที่ทำเอง (ไม่ใช่ AI), แผนผังการอ้างอิง | คนใช้แล็ปท็อปกับข้อมูล |
| FMMD 1108 ชีวิตมนุษย์ | 6 (Aging ซ้ำ 2 บท) | **Timeline** สัปดาห์ที่ 1–8 ของตัวอ่อน, กราฟการเติบโต, ลำดับพัฒนาการเด็ก, เส้นทางวัยรุ่น→วัยชรา | ช่วงวัยของมนุษย์ |
| FMMD 1109 แพทย์กับสังคม | 7 | **Timeline ประวัติศาสตร์**, concept map (Actor‑Network), เปรียบเทียบเมือง/ชนบท 2 คอลัมน์ | ชุมชน/โรงพยาบาลชุมชน |
| FMMD 1111 ระบบสุขภาพ | 6 (มีบท "Modern & Future Medicine" ซ้ำกับ 1109) | **โครงสร้างระบบสุขภาพไทย** (org chart), SDH rainbow model, WHO 6 building blocks, ลำดับ prevention 3 ระดับ | ระบบสาธารณสุข/ชุมชน |
| FMMD 1201 ชีววิทยาของเซลล์ | 3 | **แผนผังเซลล์ + organelle** ที่ label ไทย/อังกฤษ, เส้นทาง ER→Golgi→vesicle, ตาราง organelle vs โรค | ภาพเซลล์ 3D (AI ทำได้ดี ไม่ต้องมี label) |

### ของที่เจอระหว่างสำรวจและควรจัดการก่อนใส่รูป (ไม่งั้นเสียรูปเปล่า)

- `FMMD 1101` บท "Statics of the Body…" **body_md ว่าง** (0 ตัวอักษร) — ซ้ำกับบทใน 1103 ด้วย น่าจะลบ
- `FMMD 1108` บท "Aging" มี 2 บท (sort 4 และ 5) เนื้อหาต่างกันเล็กน้อย — รวมหรือลบ 1
- "Modern & Future Medicine" อยู่ทั้ง 1109 (sort 6) และ 1111 (sort 0) — เลือกวิชาเดียว
- วิชาอีก 2 วิชาใน `school_topics` ยังไม่มีบทเรียน — เมื่อ import ให้ใช้ระดับ 3 ได้เลย

---

## 6. ลำดับทำจริง (Phases) และวิธีวัดผล

| Phase | ทำอะไร | ผลที่ต้องได้ |
|---|---|---|
| **0** (1 วัน) | งานโค้ดในข้อ 4 ทั้ง 6 ข้อ + migration `school_visuals.lesson_id` | แทรกรูปมือแล้วเห็น caption/alt/zoom ในหน้านักเรียน |
| **1 นำร่อง** (2–3 วัน) | รัน `generate-lesson-figures.mjs` กับ **FMMD 1201 (3 บท)** — วิชาที่รูปช่วยมากสุด แก้ prompt/SVG จนพอใจ | 3 บท มี hero + 3 diagram + summary card ครบ ผ่านรีวิวแอดมิน |
| **2 ขยาย** (1 สัปดาห์) | รันทีละวิชาที่เหลือ (1108 → 1104 → 1101 → 1103 → 1111 → 1109 → 1105) รีวิวเป็นชุด | 44 บทมีรูป ≥ 3 รูป, `school_visuals` 44 การ์ด |
| **3 ฝังท่อ** | ระดับ 3 (import + cron) + อัปเดต `school-lesson-template.md` | บทใหม่มีรูปมาตั้งแต่ตอน import |

**วัดผล (PostHog ที่ต่ออยู่แล้ว)** เทียบก่อน/หลังใน 2 สัปดาห์ของวิชานำร่อง
- lesson completion rate (เข้าบท → ถึงการ์ด "เรียนจบ")
- เวลาต่อ Part (ควรลดลงหรือคงที่ ไม่ใช่เพิ่ม — แปลว่าอ่านแล้วเข้าใจเร็วขึ้น)
- คะแนน mini quiz / Final Retrieval ครั้งแรก (ควรดีขึ้น)
- `lesson_figure_zoom` (รูปไหนไม่มีใครกดดูเลย = ไม่ช่วย ควรรีเจน)
- คำถามใน AskMore ที่เกี่ยวกับ Part ที่มีรูป (ควรน้อยลง)

---

## 7. คำถามที่ต้องตัดสินใจก่อนเริ่ม Phase 1

1. Hero ใช้ `gpt-image-1` (key มีแล้ว ใช้กับบล็อก) หรือ Together FLUX (ถูกกว่า สคริปต์มีแล้ว) — เสนอ gpt‑image‑1 เพราะสไตล์นิ่งกว่า
2. Summary card จะเก็บใน `school_visuals` (โชว์ในหน้า Visuals ด้วย) หรือฝังใน body_md ท้ายบทเฉย ๆ — เสนอ `school_visuals` + `lesson_id` เพราะได้ quick‑check และหน้ารวมฟรี
3. ให้แอดมินรีวิวทุกรูปก่อนปล่อย (ปลอดภัยแต่ช้า) หรือปล่อยเลยแล้วแก้ทีหลังจากรายงานผ่าน "รายงานปัญหา" — เสนอรีวิวเฉพาะ Phase 1 แล้วปล่อยอัตโนมัติจาก Phase 2 โดยโชว์ป้าย "รูปสร้างโดย AI"
