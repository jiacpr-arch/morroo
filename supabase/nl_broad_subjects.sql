-- Broad NL subjects for importing compiled past-exam papers.
-- Past papers are organised by BROAD subject (Internal medicine, Surgery, ...),
-- which is coarser than the existing subspecialty subjects. This seeds the broad
-- buckets so the bulk importer can match `subject` slugs. Idempotent — existing
-- slugs are skipped (ON CONFLICT DO NOTHING).
-- Run in Supabase SQL Editor.

insert into public.mcq_subjects (name, name_th, icon, exam_type, audience) values
  -- NL2 (clinical) broad subjects
  ('internal_med', 'อายุรศาสตร์ (รวม)',        '🩺', 'NL2', 'student'),
  ('surgery',      'ศัลยศาสตร์',                '🔪', 'NL2', 'student'),
  ('ped',          'กุมารเวชศาสตร์',            '👶', 'NL2', 'student'),
  ('ob_gyn',       'สูติศาสตร์-นรีเวชวิทยา',     '🤰', 'NL2', 'student'),
  ('ortho',        'ออร์โธปิดิกส์',             '🦴', 'NL2', 'student'),
  ('psychi',       'จิตเวชศาสตร์',              '🧘', 'NL2', 'student'),
  ('ent',          'โสต ศอ นาสิก (ENT)',        '👂', 'NL2', 'student'),
  ('eye',          'จักษุวิทยา',                '👁️', 'NL2', 'student'),
  ('forensic',     'นิติเวชศาสตร์',             '🔍', 'NL2', 'student'),
  ('epidemio',     'เวชศาสตร์ชุมชน/ระบาดวิทยา',  '📊', 'NL2', 'student'),
  ('emergency',    'เวชศาสตร์ฉุกเฉิน',          '🚑', 'NL2', 'student'),
  ('radiology',    'รังสีวิทยา',                '🩻', 'NL2', 'student'),
  ('anesthesia',   'วิสัญญีวิทยา',              '💉', 'NL2', 'student'),
  ('rehab',        'เวชศาสตร์ฟื้นฟู',           '🦽', 'NL2', 'student'),
  ('derm',         'ตจวิทยา (ผิวหนัง)',         '🩹', 'NL2', 'student'),
  ('family_med',   'เวชศาสตร์ครอบครัว',         '👨‍👩‍👧', 'NL2', 'student'),
  -- NL1 (preclinical) broad subjects
  ('biochemistry',         'ชีวเคมี/อณูชีววิทยา',           '🧪', 'NL1', 'student'),
  ('cell_biology',         'ชีววิทยาของเซลล์',              '🔬', 'NL1', 'student'),
  ('genetics',             'พันธุศาสตร์/พัฒนาการ',          '🧬', 'NL1', 'student'),
  ('immunology',           'วิทยาภูมิคุ้มกัน',              '🛡️', 'NL1', 'student'),
  ('microbiology',         'จุลชีววิทยา',                   '🦠', 'NL1', 'student'),
  ('parasitology',         'ปรสิตวิทยา',                    '🪱', 'NL1', 'student'),
  ('pharmacology',         'เภสัชวิทยาพื้นฐาน',             '💊', 'NL1', 'student'),
  ('biostatistics',        'ชีวสถิติ/ระเบียบวิธีวิจัย',      '📈', 'NL1', 'student'),
  ('pathology',            'พยาธิวิทยา',                    '🔬', 'NL1', 'student'),
  ('lab_principles',       'หลักการตรวจทางห้องปฏิบัติการ',   '🧫', 'NL1', 'student'),
  ('hemato_preclinic',     'ระบบเลือด (preclinic)',         '🩸', 'NL1', 'student'),
  ('cardiovascular',       'ระบบหัวใจและหลอดเลือด (preclinic)', '❤️', 'NL1', 'student'),
  ('respiratory',          'ระบบทางเดินหายใจ (preclinic)',  '🫁', 'NL1', 'student'),
  ('gi_preclinic',         'ระบบทางเดินอาหาร (preclinic)',  '🫄', 'NL1', 'student'),
  ('renal_preclinic',      'ระบบไต (preclinic)',            '🫘', 'NL1', 'student'),
  ('neuro_preclinic',      'ระบบประสาท (preclinic)',        '🧠', 'NL1', 'student'),
  ('endocrine_preclinic',  'ระบบต่อมไร้ท่อ (preclinic)',     '🦋', 'NL1', 'student'),
  ('reproductive',         'ระบบสืบพันธุ์',                 '🍼', 'NL1', 'student'),
  ('musculoskeletal',      'ระบบกล้ามเนื้อและกระดูก',       '💪', 'NL1', 'student'),
  ('skin',                 'ระบบผิวหนัง',                   '🧴', 'NL1', 'student'),
  ('multisystem',          'กระบวนการหลายระบบ',             '🔗', 'NL1', 'student')
on conflict (name) do nothing;
