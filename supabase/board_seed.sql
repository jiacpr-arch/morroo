-- ============================================
-- หมอรู้ — Seed: 12 board specialties + EM blueprint (พ.ศ. 2559)
--
-- รันหลัง 20260514_board_exam.sql เสมอ
-- ============================================

-- ─── 12 specialties ────────────────────────────────────
-- เปิดเฉพาะ emergency_medicine ใน Phase 1; ที่เหลือ scaffold เป็น "เร็วๆนี้"

insert into public.board_specialties
  (slug, name_th, name_en, short_name_th, icon, royal_college,
   has_long_case, has_osce, has_oral, is_published, display_order)
values
  ('internal_medicine',     'อายุรศาสตร์',          'Internal Medicine',     'อายุรฯ',        '🩺', 'ราชวิทยาลัยอายุรแพทย์แห่งประเทศไทย',                true,  false, true,  false, 10),
  ('surgery',               'ศัลยศาสตร์',           'Surgery',               'ศัลย์',         '🔪', 'ราชวิทยาลัยศัลยแพทย์แห่งประเทศไทย',                 true,  true,  true,  false, 20),
  ('pediatrics',            'กุมารเวชศาสตร์',       'Pediatrics',            'กุมาร',         '👶', 'ราชวิทยาลัยกุมารแพทย์แห่งประเทศไทย',                true,  true,  true,  false, 30),
  ('ob_gyn',                'สูติศาสตร์-นรีเวชวิทยา','Obstetrics & Gynecology','สูติ-นรีเวช',   '🤰', 'ราชวิทยาลัยสูตินรีแพทย์แห่งประเทศไทย',              true,  true,  true,  false, 40),
  ('orthopedics',           'ออร์โธปิดิกส์',        'Orthopedics',           'ortho',         '🦴', 'ราชวิทยาลัยแพทย์ออร์โธปิดิกส์แห่งประเทศไทย',         false, true,  true,  false, 50),
  ('psychiatry',            'จิตเวชศาสตร์',         'Psychiatry',            'จิตเวช',        '🧘', 'ราชวิทยาลัยจิตแพทย์แห่งประเทศไทย',                  true,  true,  true,  false, 60),
  ('emergency_medicine',    'เวชศาสตร์ฉุกเฉิน',     'Emergency Medicine',    'EM',            '🚑', 'ราชวิทยาลัยแพทย์ฉุกเฉินแห่งประเทศไทย',              true,  true,  true,  true,  70),
  ('anesthesiology',        'วิสัญญีวิทยา',         'Anesthesiology',        'วิสัญญี',       '💉', 'ราชวิทยาลัยวิสัญญีแพทย์แห่งประเทศไทย',              false, true,  true,  false, 80),
  ('radiology',             'รังสีวิทยา',           'Radiology',             'รังสี',         '🩻', 'ราชวิทยาลัยรังสีแพทย์แห่งประเทศไทย',                false, false, true,  false, 90),
  ('family_medicine',       'เวชศาสตร์ครอบครัว',    'Family Medicine',       'family med',    '🏠', 'ราชวิทยาลัยแพทย์เวชศาสตร์ครอบครัวแห่งประเทศไทย',     true,  false, true,  false, 100),
  ('pathology',             'พยาธิวิทยา',           'Pathology',             'พยาธิ',         '🔬', 'ราชวิทยาลัยพยาธิแพทย์แห่งประเทศไทย',                false, false, true,  false, 110),
  ('rehab_medicine',        'เวชศาสตร์ฟื้นฟู',      'Rehabilitation Medicine','rehab',         '🦽', 'ราชวิทยาลัยแพทย์เวชศาสตร์ฟื้นฟูแห่งประเทศไทย',       false, true,  true,  false, 120)
on conflict (slug) do nothing;

update public.board_specialties set
  total_mcq_count = 200,
  exam_format = 'MCQ 200 ข้อ (Clinical Decision 130, Basic Science 30, EMS Management 20, Integrative 20) + Long Case + OSCE + Oral',
  description_th = 'การสอบบอร์ดเฉพาะทางเวชศาสตร์ฉุกเฉิน ตามเกณฑ์ราชวิทยาลัยแพทย์ฉุกเฉินแห่งประเทศไทย'
where slug = 'emergency_medicine';

-- ─── EM blueprint ปี 2559 ──────────────────────────────

with bp_sections as (
  insert into public.board_exam_blueprints
    (specialty_slug, exam_year, section_code, section_label_th, section_label_en, question_count, display_order)
  values
    ('emergency_medicine', 2559, 'clinical_decision', 'ก. การตัดสินใจทางเวชกรรม',                         'Clinical Decision Making',           130, 10),
    ('emergency_medicine', 2559, 'basic_science',     'ข. วิทยาศาสตร์การแพทย์พื้นฐานทางเวชศาสตร์ฉุกเฉิน', 'Basic Science of Emergency Medicine', 30, 20),
    ('emergency_medicine', 2559, 'ems_mgmt',          'ค. การจัดการระบบบริการการแพทย์ฉุกเฉิน',            'EMS Management',                      20, 30),
    ('emergency_medicine', 2559, 'integrative',       'ง. ข้อสอบบูรณาการ',                                'Integrative',                         20, 40)
  on conflict (specialty_slug, exam_year, section_code) do nothing
  returning id, section_code
)
insert into public.board_topic_categories
  (blueprint_id, slug, name_th, name_en, peds_count, adult_count, other_count, display_order)
select
  (select id from public.board_exam_blueprints
    where specialty_slug = 'emergency_medicine'
      and exam_year = 2559
      and section_code = 'clinical_decision'),
  t.slug, t.name_th, t.name_en, t.peds, t.adult, t.other, t.ord
from (values
  ('cardiovascular',     'ความผิดปกติของระบบหัวใจและหลอดเลือด',                  'Cardiovascular disorders',                    1, 7, 0, 10),
  ('dermatology',        'ความผิดปกติของผิวหนัง',                                'Cutaneous disorders',                         1, 2, 0, 20),
  ('endocrine_metabolic','ความผิดปกติของต่อมไร้ท่อ-เมตาบอลิก-โภชนาการ',          'Endocrine/Metabolic/Nutritional disorders',   1, 3, 0, 30),
  ('eent',               'ความผิดปกติของตา หู คอ จมูก ฟัน',                      'Head/EENT disorders',                         2, 4, 0, 40),
  ('environmental',      'ความผิดปกติจากสภาวะแวดล้อม',                           'Environmental disorders',                     1, 4, 0, 50),
  ('gi',                 'ความผิดปกติของระบบทางเดินอาหาร',                       'Gastrointestinal disorders',                  2, 6, 0, 60),
  ('hemato_onco',        'ความผิดปกติของระบบโลหิตวิทยาและมะเร็ง',                'Hematologic/Oncologic disorders',             1, 3, 0, 70),
  ('id',                 'ความผิดปกติจากโรคติดเชื้อ-ภูมิคุ้มกัน',                'Immune system/Infectious disorders',          2, 4, 0, 80),
  ('msk_nontrauma',      'ความผิดปกติของกล้ามเนื้อและกระดูก (ที่ไม่ใช่อุบัติเหตุ)','Musculoskeletal disorders (non-traumatic)',1, 3, 0, 90),
  ('neurology',          'ความผิดปกติของระบบประสาท',                             'Nervous system disorders',                    1, 6, 0, 100),
  ('obgyn',              'ความผิดปกติของสูติ-นรีเวช',                            'Obstetrics and Gynecology disorders',         0, 6, 0, 110),
  ('psych_behavior',     'ความผิดปกติทางจิตและพฤติกรรม',                         'Psychobehavioral disorders',                  1, 3, 0, 120),
  ('renal_gu',           'ความผิดปกติของไตและทางเดินปัสสาวะ',                    'Renal/Genitourinary disorders',               1, 3, 0, 130),
  ('respiratory',        'ความผิดปกติของระบบทางเดินหายใจ',                       'Thoracic-Respiratory disorders',              2, 5, 0, 140),
  ('toxicology',         'พิษวิทยา',                                             'Toxicologic disorders',                       2, 6, 0, 150),
  ('trauma',             'อุบัติเหตุ',                                           'Traumatic disorders',                         6, 14, 0, 160),
  ('procedures',         'หัตถการและการดูแลทั่วไป',                              'Procedures/Skills',                           0, 5, 0, 170),
  ('signs_symptoms',     'อาการและอาการแสดงสำคัญ',                               'Signs/Symptoms/Presentations',                1, 8, 0, 180),
  ('special_clinical',   'หัวข้อทางคลินิกพิเศษ',                                 'Special Clinical Topics',                     0, 2, 0, 190)
) as t(slug, name_th, name_en, peds, adult, other, ord)
on conflict (blueprint_id, slug) do nothing;

-- ─── EM mcq_subjects (entry points สำหรับ practice mode) ─

insert into public.mcq_subjects
  (name, name_th, icon, audience, board_specialty, exam_type, question_count)
values
  ('em_clinical_decision', 'EM · การตัดสินใจทางเวชกรรม',           '🚑', 'board', 'emergency_medicine', null, 0),
  ('em_basic_science',     'EM · วิทยาศาสตร์การแพทย์พื้นฐาน',      '🧬', 'board', 'emergency_medicine', null, 0),
  ('em_ems_mgmt',          'EM · การจัดการระบบบริการการแพทย์ฉุกเฉิน','🚨', 'board', 'emergency_medicine', null, 0),
  ('em_integrative',       'EM · ข้อสอบบูรณาการ',                    '🧩', 'board', 'emergency_medicine', null, 0)
on conflict (name) do nothing;
