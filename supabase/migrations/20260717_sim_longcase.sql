-- ============================================
-- Code Blue Sim — Long Case decision games ("เกมเคส")
-- ============================================
--
-- เกมเคสใช้เอนจิน sim เดิม แต่เนื้อหามาจาก long_cases (ซักประวัติ→ตรวจ→แลป→
-- วินิจฉัย→รักษา) — แยกออกจากเคส ACLS ด้วยคอลัมน์ category
--   category = 'acls' (ค่าเริ่มต้น เคส Code Blue เดิม) | 'longcase' (เกมเคส)
--   source_case_id = อ้างกลับไปยัง long_cases ที่เป็นต้นฉบับ (ถ้าแปลงจากเคสจริง)

alter table public.sim_scenarios
  add column if not exists category text not null default 'acls'
    check (category in ('acls', 'longcase')),
  add column if not exists source_case_id uuid references public.long_cases(id) on delete set null;

create index if not exists idx_sim_scenarios_category on public.sim_scenarios(category);
