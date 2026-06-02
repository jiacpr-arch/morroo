# เทมเพลตการออกแบบบทเรียน — School Mode

ระบบ School ใช้หลัก **Microlearning + Retrieval Practice** — เรียนทีละนิด แล้วตอบโจทย์สั้น ๆ
เพื่อย้ำความจำ เป็นรูปแบบ **Learn-and-Quiz loop** แบบเดียวกับ Duolingo
(คำค้นอ้างอิง: *"microlearning + retrieval practice"*).

เอกสารนี้คือสเปกอ้างอิงสำหรับผู้ออกแบบ/นำเข้าเนื้อหา และเป็นตัวเลขที่
`scripts/import-school-content.mjs` ใช้ตรวจ (warn เมื่อหลุดช่วง)

## ภาพรวม flow ของหนึ่ง topic

```
หนังสือฉบับเต็ม (Reference)   →  Concept Reader (micro-loop)  →  Flashcards  →  Quiz  →  Mastery
school_book_chapters             school_lessons (body_md)        school_flashcards  school_quizzes  ≥80%
อ่านต่อเนื่อง + สารบัญ          อ่านทีละ Part + mini-quiz                                         จาก ≥5 ข้อ
```

- **หนังสือฉบับเต็ม** = ตำราอ้างอิง อ่านได้อิสระ ไม่บังคับ (ดู `BookReader`)
- **Concept Reader** = micro-learning loop ที่บังคับทำ retrieval ระหว่างอ่าน (ดู `LessonReader`)

## 1. หน่วยเนื้อหา micro-lesson (`school_lessons.body_md`)

- แบ่งเนื้อหาเป็น **Part** ย่อย ๆ คั่นแต่ละ Part ด้วยบรรทัด `## ⏸ Mini Quiz`
  (กลไก `splitByMarker` ใน `components/school/LessonReader.tsx` ใช้ตัวคั่นนี้)
- ขนาดต่อ Part: **~5–8 บรรทัด (~120–180 คำ)** — สั้นพอให้จบใน 1–2 นาที
- จำนวน Part ต่อบทเรียน: **3–6 Part** (รวมอ่าน ~5–10 นาที = `estimated_min`)

## 2. Retrieval (`school_quizzes`)

- **1 mini-quiz ต่อ 1 Part** (gate): ต้องตอบก่อนจึงไป Part ถัดไป
- **Final retrieval ตอนจบบท: 3–5 ข้อ** (ข้อที่เหลือจากที่ใช้เป็น gate)
- รูปแบบข้อ: single-best-answer MCQ 4–5 ตัวเลือก พร้อมคำอธิบายเฉลย

## 3. จำนวนหน่วยต่อ lecture/บท (บังคับใช้ตอน import)

| หน่วย | จำนวน |
|-------|-------|
| Flashcards | **10–20 ใบ** (1 concept/ใบ) |
| Quizzes | **5–10 ข้อ** |

`import-school-content.mjs` จะ `console.warn` หากจำนวนหลุดช่วงนี้

## 4. เกณฑ์ผ่าน (Mastery)

- **ผ่านเมื่อทำ quiz ถูก ≥ 80% จากอย่างน้อย 5 ข้อ**
- ตรงกับ `MASTERY_THRESHOLD = 80` ใน `app/school/topic/[id]/page.tsx`
  และ Challenge mode (ผ่าน ≥80% รับ XP โบนัส)

## 5. สรุปสั้น ๆ (ไว้อธิบายให้คนอื่นฟัง)

> "ระบบใช้ Microlearning ผสม Retrieval Practice — อ่านเนื้อหาสั้น ๆ ทีละ Part
> แล้วตอบคำถามคั่นเพื่อย้ำความจำ (Learn-and-Quiz loop แบบ Duolingo)
> มีหนังสือฉบับเต็มเป็นตำราอ้างอิงควบคู่ไปด้วย"
