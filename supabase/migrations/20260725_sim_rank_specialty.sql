-- ============================================
-- เกมเคส — ระบบยศแพทย์ + ความเชี่ยวชาญรายสาขา
-- ============================================
--
-- ยศคิดจาก XP สะสมเดิม (profiles.school_xp) ไม่ต้องเก็บอะไรเพิ่ม — ดู
-- lib/school/rank.ts
--
-- ความเชี่ยวชาญต้องรู้ว่า run ไหนเป็นสาขาอะไร แต่ sim_runs เก็บแค่
-- scenario_slug และสาขาอยู่คนละตารางตามชนิดของเคส:
--   เกมจาก long case → sim_scenarios.source_case_id → long_cases.specialty
--   เกมจาก MEQ       → sim_scenarios.source_exam_id → exams.category
--   เกมสังเคราะห์      → ไม่มีแถวใน sim_scenarios เลย (slug = 'lc-<uuid>')
-- การ join 3 ทางทุกครั้งที่อยากรู้ว่าใครเก่งสาขาไหนแพงเกินไป จึง denormalize
-- ลง sim_runs ตอนบันทึกผล

alter table public.sim_runs
  add column if not exists specialty text;

comment on column public.sim_runs.specialty is
  'สาขาของเคส ณ ตอนเล่น (denormalize จาก long_cases.specialty / exams.category) — ใช้คิดความเชี่ยวชาญรายสาขา';

-- Backfill 1: เคสที่มีแถวใน sim_scenarios (polished long case + MEQ)
update public.sim_runs r
set specialty = coalesce(lc.specialty, e.category)
from public.sim_scenarios s
  left join public.long_cases lc on lc.id = s.source_case_id
  left join public.exams e on e.id = s.source_exam_id
where s.slug = r.scenario_slug
  and r.specialty is null
  and coalesce(lc.specialty, e.category) is not null;

-- Backfill 2: เกมสังเคราะห์จาก long_cases ที่ยังไม่มีแถวใน sim_scenarios
-- เทียบ id เป็น text ไม่ใช่ cast slug เป็น uuid — slug ที่ไม่ใช่ uuid จะได้
-- ไม่ทำทั้ง statement พัง
update public.sim_runs r
set specialty = lc.specialty
from public.long_cases lc
where r.specialty is null
  and r.scenario_slug like 'lc-%'
  and lc.id::text = substring(r.scenario_slug from 4)
  and lc.specialty is not null;

-- อ่านความเชี่ยวชาญของตัวเอง = ตัดด้วย user_id แล้วจัดกลุ่มตามสาขา
create index if not exists idx_sim_runs_user_specialty
  on public.sim_runs(user_id, specialty);

-- เหรียญเมื่อไต่ถึงขั้น "เชี่ยวชาญ" ในสาขาแรก (ดู EXPERTISE_TIERS ใน
-- lib/sim/expertise.ts) — ใช้ catalog + XP engine เดิมของ school
insert into public.school_badges (slug, name_th, name_en, description, icon, xp_reward, sort_order) values
  ('sim_specialist', 'ผู้เชี่ยวชาญเฉพาะสาขา', 'Board Specialist', 'ชนะเคสในสาขาเดียวครบ 15 เคส', '🎯', 200, 180)
on conflict (slug) do nothing;
