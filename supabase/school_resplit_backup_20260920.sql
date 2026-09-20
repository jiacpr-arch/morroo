-- ตารางสำรองสำหรับ scripts/resplit-lesson-parts.ts — เก็บ body_md เดิมของบทเรียน
-- ก่อนแบ่งใหม่เป็น "mini class" (ส่วนสั้น 6-12 ส่วน + คำถามท้ายทุกส่วนรวมส่วนสุดท้าย)
--
-- ตั้งใจไว้ใน public schema (ไม่ใช่ archive แบบตารางสำรองชุดก่อน ๆ) เพราะสคริปต์คุยกับ
-- Supabase ผ่าน PostgREST client (service-role key) ซึ่งเข้าถึงได้เฉพาะ schema ที่เปิดไว้ใน
-- Settings → API → Exposed schemas เท่านั้น — ตารางนี้ใช้ RLS เปิดแต่ไม่มี policy แทน
-- (ปิดกั้น anon/authenticated โดยปริยาย, service role ข้าม RLS ได้อยู่แล้วจึงยังเขียน/อ่านได้)
--
-- ไม่มี primary key ผูกกับ lesson_id โดยตรง — รันสคริปต์ซ้ำ (FORCE=1) กี่ครั้งก็ไม่ชนกัน
-- เก็บประวัติทุกครั้งที่สำรองไว้ครบ

create table if not exists public.school_lessons_resplit_backup_20260920 (
  id uuid primary key default gen_random_uuid(),
  lesson_id uuid not null references public.school_lessons(id) on delete cascade,
  topic_id uuid,
  layer text,
  title text,
  body_md text not null,
  estimated_min int,
  sort_order int,
  source text,
  status text,
  lesson_created_at timestamptz,
  backed_up_at timestamptz not null default now()
);

create index if not exists school_lessons_resplit_backup_20260920_lesson_id_idx
  on public.school_lessons_resplit_backup_20260920 (lesson_id);

alter table public.school_lessons_resplit_backup_20260920 enable row level security;
-- ไม่มี policy ใด ๆ ตั้งใจ — anon/authenticated เข้าไม่ได้เลย, service role (สคริปต์นี้) ข้าม RLS ได้เสมอ

-- กู้คืนบทใดบทหนึ่งกลับเป็นก่อนแบ่งใหม่ (เอา backup ล่าสุดของ lesson นั้น):
--
-- update public.school_lessons l
-- set body_md = b.body_md
-- from (
--   select distinct on (lesson_id) lesson_id, body_md
--   from public.school_lessons_resplit_backup_20260920
--   where lesson_id = '<uuid>'
--   order by lesson_id, backed_up_at desc
-- ) b
-- where l.id = b.lesson_id;

-- ลบตารางสำรองทิ้งเมื่อแน่ใจแล้วว่าไม่ต้องกู้คืนอีก:
-- drop table public.school_lessons_resplit_backup_20260920;
