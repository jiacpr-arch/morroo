# ล้างเนื้อหา School รอบ 3 ส.ค. 2026 (พร้อมที่เก็บสำรอง)

ตอนปรับวิชาปี 1 ให้ตรงหลักสูตรจริง (FMMD/พศพบ) เนื้อหาชุดเก่าที่ generate ไว้
สมัยทดลองระบบ (Cell Biology ล้วน) ถูกล้างออกทั้งหมด เพื่อเริ่มอัปไฟล์ใหม่รายวิชา

## ที่ลบออกจากตารางใช้งานจริง (Supabase project `morroo`)

| ตาราง | จำนวนที่ลบ |
|-------|-----------|
| `school_lessons` | 11 |
| `school_flashcards` | 175 |
| `school_quizzes` | 75 |
| `school_books` | 1 |
| `school_book_chapters` | 11 |
| `school_progress` (unit_type = flashcard/lesson/quiz/book_chapter) | 656 |

**ที่เก็บไว้:** โครง 10 รายวิชาปี 1 (`school_topics`), concept map 10 อัน
(`school_concepts`), คำถามนักเรียน 3 ข้อ (`school_questions`),
และ XP / streak / badge ของผู้ใช้ (`school_xp_events` 1,101 · `school_streaks` 4 ·
`school_user_badges` 177) — ไม่แตะ เพราะเป็นสถานะบัญชีผู้ใช้ ไม่ใช่เนื้อหา

## สำรองไว้ที่ไหน

คัดลอกทั้งตารางไว้ในสคีมา `archive` ของโปรเจกต์เดียวกัน (revoke สิทธิ์ anon/authenticated แล้ว):

```
archive.school_lessons_20260803
archive.school_flashcards_20260803
archive.school_quizzes_20260803
archive.school_books_20260803
archive.school_book_chapters_20260803
archive.school_progress_20260803
archive.school_concept_links_20260803
```

เก็บเป็นตารางในฐาน ไม่ใช่ไฟล์ในรีโป เพราะเครื่องที่รันไม่มี DB credential
สำหรับ dump ออกมาเป็นไฟล์ (ถ้าต้องการไฟล์ JSON ให้ dump จากสคีมา `archive` ได้ทุกเมื่อ)

## กู้คืน

```sql
insert into public.school_lessons       select * from archive.school_lessons_20260803;
insert into public.school_flashcards    select * from archive.school_flashcards_20260803;
insert into public.school_quizzes       select * from archive.school_quizzes_20260803;
insert into public.school_books         select * from archive.school_books_20260803;
insert into public.school_book_chapters select * from archive.school_book_chapters_20260803;
insert into public.school_progress      select * from archive.school_progress_20260803;
```

topic_id เดิมยังชี้ไปที่ `cell-biology` (FMMD 1201) ซึ่งยังอยู่ในฐาน — กู้แล้วผูกกลับได้ทันที

ลบที่เก็บสำรองทิ้งเมื่อแน่ใจแล้ว: `drop schema archive cascade;`
