-- ============================================
-- หมอรู้ (MorRoo) — เพิ่ม "เทอม" ให้รายวิชา School
-- ============================================
-- หน้า admin import ให้เลือก ชั้นปี → เทอม → วิชา ก่อนอัปโหลดไฟล์
-- เดิมมีแค่ year จึงต้องเติม term
--
-- term = null หมายถึง "ยังไม่ระบุ / เรียนทั้งปี" — ตัวกรองในหน้า admin
-- แสดงวิชาที่ term เป็น null ในทุกเทอม จึงไม่ต้องไปเดาเทอมของวิชาเดิม
--
-- 3 = ภาคฤดูร้อน (บางหลักสูตรมี)
alter table public.school_topics
  add column if not exists term smallint
  check (term is null or term between 1 and 3);

comment on column public.school_topics.term is
  'ภาคการศึกษา 1-2 (3 = ภาคฤดูร้อน). null = ยังไม่ระบุ / เรียนทั้งปี';

create index if not exists idx_school_topics_year_term
  on public.school_topics(year, term);
