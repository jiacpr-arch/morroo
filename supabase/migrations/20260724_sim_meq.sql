-- ============================================
-- Code Blue Sim — MEQ progressive-case decision games ("เกมเคส MEQ")
-- ============================================
--
-- ต่อยอดจาก 20260717_sim_longcase.sql: แปลงข้อสอบ MEQ (exams + exam_parts,
-- เคสไล่ 6 ตอน) เป็นเกมเคสด้วยเอนจิน sim เดิม แยกด้วยคอลัมน์ category
--   category = 'meq'  → เกมเคสที่แปลงจาก MEQ
--   source_exam_id    → อ้างกลับไปยัง exams ต้นฉบับ (FK แยกจาก source_case_id
--                        ของ long_cases เพราะคนละตาราง)
--
-- CHECK เดิมของ category สร้างแบบ inline ตอน add column ใน migration ก่อนหน้า
-- postgres จึงตั้งชื่อให้อัตโนมัติเป็น sim_scenarios_category_check — drop แล้ว
-- สร้างใหม่ให้รวม 'meq'

alter table public.sim_scenarios
  drop constraint if exists sim_scenarios_category_check;

alter table public.sim_scenarios
  add constraint sim_scenarios_category_check
    check (category in ('acls', 'longcase', 'meq'));

alter table public.sim_scenarios
  add column if not exists source_exam_id uuid references public.exams(id) on delete set null;

create index if not exists idx_sim_scenarios_source_exam on public.sim_scenarios(source_exam_id);
