-- ============================================
-- หมอรู้ — Board Phase 2A: scaffold 11 specialties (besides EM)
--
-- เพิ่ม blueprint + topic_categories ของ section "clinical_decision"
-- สำหรับ 11 สาขาที่เหลือ พร้อม mcq_subjects (entry point ของ practice)
-- ทุกสาขา is_published=false → public ยังไม่เห็น แต่ AI generator
-- จะเริ่มสะสมข้อสอบเข้า DB ทันที (script ถูก update ให้กิน is_active แทน)
--
-- ใช้ exam_year=2568 (พ.ศ.) เป็น placeholder — แทนที่ด้วย blueprint จริง
-- จากราชวิทยาลัยฯ ของแต่ละสาขาเมื่อ source PDF ได้
-- ============================================

-- ─── 1. Blueprints: 4 sections × 11 specialties = 44 rows ─

insert into public.board_exam_blueprints
  (specialty_slug, exam_year, section_code, section_label_th, section_label_en, question_count, display_order)
values
  -- internal_medicine
  ('internal_medicine', 2568, 'clinical_decision', 'ก. การตัดสินใจทางเวชกรรม',          'Clinical Decision Making',           130, 10),
  ('internal_medicine', 2568, 'basic_science',     'ข. วิทยาศาสตร์การแพทย์พื้นฐาน',   'Basic Science',                       30, 20),
  ('internal_medicine', 2568, 'ems_mgmt',          'ค. การจัดการคลินิก',                'Clinical Management',                 20, 30),
  ('internal_medicine', 2568, 'integrative',       'ง. ข้อสอบบูรณาการ',                 'Integrative',                         20, 40),
  -- surgery
  ('surgery',           2568, 'clinical_decision', 'ก. การตัดสินใจทางเวชกรรม',          'Clinical Decision Making',           130, 10),
  ('surgery',           2568, 'basic_science',     'ข. วิทยาศาสตร์การแพทย์พื้นฐาน',   'Basic Science',                       30, 20),
  ('surgery',           2568, 'ems_mgmt',          'ค. การจัดการคลินิก',                'Clinical Management',                 20, 30),
  ('surgery',           2568, 'integrative',       'ง. ข้อสอบบูรณาการ',                 'Integrative',                         20, 40),
  -- pediatrics
  ('pediatrics',        2568, 'clinical_decision', 'ก. การตัดสินใจทางเวชกรรม',          'Clinical Decision Making',           130, 10),
  ('pediatrics',        2568, 'basic_science',     'ข. วิทยาศาสตร์การแพทย์พื้นฐาน',   'Basic Science',                       30, 20),
  ('pediatrics',        2568, 'ems_mgmt',          'ค. การจัดการคลินิก',                'Clinical Management',                 20, 30),
  ('pediatrics',        2568, 'integrative',       'ง. ข้อสอบบูรณาการ',                 'Integrative',                         20, 40),
  -- ob_gyn
  ('ob_gyn',            2568, 'clinical_decision', 'ก. การตัดสินใจทางเวชกรรม',          'Clinical Decision Making',           130, 10),
  ('ob_gyn',            2568, 'basic_science',     'ข. วิทยาศาสตร์การแพทย์พื้นฐาน',   'Basic Science',                       30, 20),
  ('ob_gyn',            2568, 'ems_mgmt',          'ค. การจัดการคลินิก',                'Clinical Management',                 20, 30),
  ('ob_gyn',            2568, 'integrative',       'ง. ข้อสอบบูรณาการ',                 'Integrative',                         20, 40),
  -- orthopedics
  ('orthopedics',       2568, 'clinical_decision', 'ก. การตัดสินใจทางเวชกรรม',          'Clinical Decision Making',           130, 10),
  ('orthopedics',       2568, 'basic_science',     'ข. วิทยาศาสตร์การแพทย์พื้นฐาน',   'Basic Science',                       30, 20),
  ('orthopedics',       2568, 'ems_mgmt',          'ค. การจัดการคลินิก',                'Clinical Management',                 20, 30),
  ('orthopedics',       2568, 'integrative',       'ง. ข้อสอบบูรณาการ',                 'Integrative',                         20, 40),
  -- psychiatry
  ('psychiatry',        2568, 'clinical_decision', 'ก. การตัดสินใจทางเวชกรรม',          'Clinical Decision Making',           130, 10),
  ('psychiatry',        2568, 'basic_science',     'ข. วิทยาศาสตร์การแพทย์พื้นฐาน',   'Basic Science',                       30, 20),
  ('psychiatry',        2568, 'ems_mgmt',          'ค. การจัดการคลินิก',                'Clinical Management',                 20, 30),
  ('psychiatry',        2568, 'integrative',       'ง. ข้อสอบบูรณาการ',                 'Integrative',                         20, 40),
  -- anesthesiology
  ('anesthesiology',    2568, 'clinical_decision', 'ก. การตัดสินใจทางเวชกรรม',          'Clinical Decision Making',           130, 10),
  ('anesthesiology',    2568, 'basic_science',     'ข. วิทยาศาสตร์การแพทย์พื้นฐาน',   'Basic Science',                       30, 20),
  ('anesthesiology',    2568, 'ems_mgmt',          'ค. การจัดการคลินิก',                'Clinical Management',                 20, 30),
  ('anesthesiology',    2568, 'integrative',       'ง. ข้อสอบบูรณาการ',                 'Integrative',                         20, 40),
  -- radiology
  ('radiology',         2568, 'clinical_decision', 'ก. การตัดสินใจทางเวชกรรม',          'Clinical Decision Making',           130, 10),
  ('radiology',         2568, 'basic_science',     'ข. วิทยาศาสตร์การแพทย์พื้นฐาน',   'Basic Science',                       30, 20),
  ('radiology',         2568, 'ems_mgmt',          'ค. การจัดการคลินิก',                'Clinical Management',                 20, 30),
  ('radiology',         2568, 'integrative',       'ง. ข้อสอบบูรณาการ',                 'Integrative',                         20, 40),
  -- family_medicine
  ('family_medicine',   2568, 'clinical_decision', 'ก. การตัดสินใจทางเวชกรรม',          'Clinical Decision Making',           130, 10),
  ('family_medicine',   2568, 'basic_science',     'ข. วิทยาศาสตร์การแพทย์พื้นฐาน',   'Basic Science',                       30, 20),
  ('family_medicine',   2568, 'ems_mgmt',          'ค. การจัดการคลินิก',                'Clinical Management',                 20, 30),
  ('family_medicine',   2568, 'integrative',       'ง. ข้อสอบบูรณาการ',                 'Integrative',                         20, 40),
  -- pathology
  ('pathology',         2568, 'clinical_decision', 'ก. การตัดสินใจทางเวชกรรม',          'Clinical Decision Making',           130, 10),
  ('pathology',         2568, 'basic_science',     'ข. วิทยาศาสตร์การแพทย์พื้นฐาน',   'Basic Science',                       30, 20),
  ('pathology',         2568, 'ems_mgmt',          'ค. การจัดการคลินิก',                'Clinical Management',                 20, 30),
  ('pathology',         2568, 'integrative',       'ง. ข้อสอบบูรณาการ',                 'Integrative',                         20, 40),
  -- rehab_medicine
  ('rehab_medicine',    2568, 'clinical_decision', 'ก. การตัดสินใจทางเวชกรรม',          'Clinical Decision Making',           130, 10),
  ('rehab_medicine',    2568, 'basic_science',     'ข. วิทยาศาสตร์การแพทย์พื้นฐาน',   'Basic Science',                       30, 20),
  ('rehab_medicine',    2568, 'ems_mgmt',          'ค. การจัดการคลินิก',                'Clinical Management',                 20, 30),
  ('rehab_medicine',    2568, 'integrative',       'ง. ข้อสอบบูรณาการ',                 'Integrative',                         20, 40)
on conflict (specialty_slug, exam_year, section_code) do nothing;

-- ─── 2. Topic categories ─ generic organ-system breakdown per specialty
-- (เฉพาะ section clinical_decision; section อื่นเติมภายหลังเมื่อมี blueprint จริง)
-- ใช้ helper CTE เพื่อหา blueprint_id ของแต่ละ (specialty, clinical_decision, 2568)

with bp as (
  select id, specialty_slug
  from public.board_exam_blueprints
  where exam_year=2568 and section_code='clinical_decision'
)
insert into public.board_topic_categories
  (blueprint_id, slug, name_th, name_en, peds_count, adult_count, other_count, display_order)
select bp.id, t.slug, t.name_th, t.name_en, t.peds, t.adult, t.other, t.ord
from bp
join (values
  -- internal_medicine (12 topics)
  ('internal_medicine','cardiology',        'โรคหัวใจและหลอดเลือด',                    'Cardiovascular',           0, 12, 0, 10),
  ('internal_medicine','pulmonary',         'โรคทางเดินหายใจ',                        'Pulmonary',                0, 11, 0, 20),
  ('internal_medicine','gi_im',             'โรคทางเดินอาหารและตับ',                  'GI/Hepatology',            0, 11, 0, 30),
  ('internal_medicine','renal_im',          'โรคไตและสมดุลกรด-เบส',                   'Nephrology',               0, 10, 0, 40),
  ('internal_medicine','endocrine_im',      'โรคต่อมไร้ท่อ',                          'Endocrinology',            0, 10, 0, 50),
  ('internal_medicine','hemato_onco_im',    'โลหิตวิทยาและมะเร็ง',                   'Hematology/Oncology',      0, 12, 0, 60),
  ('internal_medicine','infectious_im',     'โรคติดเชื้อ',                            'Infectious Disease',       0, 11, 0, 70),
  ('internal_medicine','rheumatology',      'โรคข้อและรูมาติก',                       'Rheumatology',             0,  8, 0, 80),
  ('internal_medicine','neurology_im',      'โรคระบบประสาท',                          'Neurology',                0, 10, 0, 90),
  ('internal_medicine','allergy_immuno',    'โรคภูมิแพ้และภูมิคุ้มกัน',               'Allergy/Immunology',       0,  6, 0, 100),
  ('internal_medicine','geriatrics',        'เวชศาสตร์ผู้สูงอายุ',                    'Geriatrics',               0,  9, 0, 110),
  ('internal_medicine','critical_care_im',  'เวชศาสตร์วิกฤต',                         'Critical Care',            0, 10, 0, 120),

  -- surgery (10 topics)
  ('surgery','gi_surgery',         'ศัลยศาสตร์ทางเดินอาหาร',                   'GI Surgery',               1, 16, 0, 10),
  ('surgery','hepatobiliary',      'ตับ ทางเดินน้ำดี และตับอ่อน',              'Hepatobiliary',            0, 13, 0, 20),
  ('surgery','vascular',           'ศัลยศาสตร์หลอดเลือด',                      'Vascular',                 0, 13, 0, 30),
  ('surgery','breast',             'เต้านม',                                    'Breast',                   0, 10, 0, 40),
  ('surgery','endocrine_surg',     'ศัลยศาสตร์ต่อมไร้ท่อ',                     'Endocrine Surgery',        0,  9, 0, 50),
  ('surgery','trauma_surg',        'ศัลยศาสตร์อุบัติเหตุ',                     'Trauma Surgery',           3, 14, 0, 60),
  ('surgery','surgical_oncology',  'ศัลย์มะเร็ง',                              'Surgical Oncology',        0, 13, 0, 70),
  ('surgery','pediatric_surgery',  'ศัลย์เด็ก',                                'Pediatric Surgery',       12,  0, 0, 80),
  ('surgery','colorectal',         'ศัลย์ลำไส้ใหญ่และทวารหนัก',                'Colorectal',               0, 12, 0, 90),
  ('surgery','critical_care_surg', 'การดูแลผู้ป่วยศัลยกรรมวิกฤต',              'Surgical Critical Care',   0, 14, 0, 100),

  -- pediatrics (12 topics)
  ('pediatrics','neonatology',     'ทารกแรกเกิด',                              'Neonatology',             16,  0, 0, 10),
  ('pediatrics','cardiology_ped',  'โรคหัวใจในเด็ก',                          'Pediatric Cardiology',    11,  0, 0, 20),
  ('pediatrics','pulmonary_ped',   'โรคทางเดินหายใจในเด็ก',                   'Pediatric Pulmonary',     11,  0, 0, 30),
  ('pediatrics','gi_ped',          'โรคทางเดินอาหารในเด็ก',                    'Pediatric GI',            10,  0, 0, 40),
  ('pediatrics','infectious_ped',  'โรคติดเชื้อในเด็ก',                        'Pediatric ID',            12,  0, 0, 50),
  ('pediatrics','hemato_onco_ped', 'โลหิตวิทยา-มะเร็งเด็ก',                   'Ped Hem/Onc',             11,  0, 0, 60),
  ('pediatrics','neurology_ped',   'ระบบประสาทเด็ก',                          'Pediatric Neurology',     10,  0, 0, 70),
  ('pediatrics','endocrine_ped',   'ต่อมไร้ท่อในเด็ก',                        'Pediatric Endocrine',      9,  0, 0, 80),
  ('pediatrics','nephro_ped',      'โรคไตในเด็ก',                              'Pediatric Nephrology',     8,  0, 0, 90),
  ('pediatrics','development',     'พัฒนาการและพฤติกรรม',                      'Development/Behavior',    11,  0, 0, 100),
  ('pediatrics','adolescent',      'เวชศาสตร์วัยรุ่น',                         'Adolescent Medicine',      9,  0, 0, 110),
  ('pediatrics','emergency_ped',   'เวชศาสตร์ฉุกเฉินเด็ก',                    'Pediatric Emergency',     12,  0, 0, 120),

  -- ob_gyn (10 topics)
  ('ob_gyn','prenatal',           'การฝากครรภ์',                              'Prenatal Care',            0, 14, 0, 10),
  ('ob_gyn','labor_delivery',     'การคลอด',                                   'Labor & Delivery',         0, 17, 0, 20),
  ('ob_gyn','postpartum',         'หลังคลอด',                                  'Postpartum',               0, 10, 0, 30),
  ('ob_gyn','high_risk_pregnancy','การตั้งครรภ์เสี่ยงสูง',                    'High-Risk Pregnancy',      0, 15, 0, 40),
  ('ob_gyn','gynec_oncology',     'มะเร็งทางนรีเวช',                          'Gynec Oncology',           0, 14, 0, 50),
  ('ob_gyn','reproductive_endo',  'อนามัยเจริญพันธุ์',                        'Reproductive Endo',        0, 11, 0, 60),
  ('ob_gyn','urogyne',            'นรีเวชระบบทางเดินปัสสาวะ',                 'Urogynecology',            0,  9, 0, 70),
  ('ob_gyn','family_planning',    'การวางแผนครอบครัว',                        'Family Planning',          0, 10, 0, 80),
  ('ob_gyn','gyne_infections',    'โรคติดเชื้อทางนรีเวช',                      'Gyne Infections',          0, 12, 0, 90),
  ('ob_gyn','benign_gyne',        'นรีเวชทั่วไป',                              'Benign Gynecology',        0, 18, 0, 100),

  -- orthopedics (10 topics)
  ('orthopedics','trauma_ortho',      'อุบัติเหตุกระดูกและข้อ',                'Orthopedic Trauma',        5, 15, 0, 10),
  ('orthopedics','sports_med',        'เวชศาสตร์การกีฬา',                      'Sports Medicine',          0, 12, 0, 20),
  ('orthopedics','spine_ortho',       'กระดูกสันหลัง',                          'Spine',                    1, 13, 0, 30),
  ('orthopedics','pediatric_ortho',   'ออร์โธปิดิกส์เด็ก',                     'Pediatric Ortho',         14,  0, 0, 40),
  ('orthopedics','foot_ankle',        'เท้าและข้อเท้า',                         'Foot & Ankle',             0,  9, 0, 50),
  ('orthopedics','hand_upper',        'มือและรยางค์บน',                        'Hand & Upper Extremity',   0, 14, 0, 60),
  ('orthopedics','hip_knee',          'สะโพกและเข่า',                           'Hip & Knee',               0, 16, 0, 70),
  ('orthopedics','shoulder_elbow',    'หัวไหล่และศอก',                          'Shoulder & Elbow',         0, 11, 0, 80),
  ('orthopedics','oncology_ortho',    'มะเร็งกระดูก',                          'Orthopedic Oncology',      2,  8, 0, 90),
  ('orthopedics','infections_ortho',  'โรคติดเชื้อกระดูกและข้อ',               'Orthopedic Infections',    2, 10, 0, 100),

  -- psychiatry (10 topics)
  ('psychiatry','mood_disorders',     'โรคซึมเศร้าและอารมณ์',                  'Mood Disorders',           1, 16, 0, 10),
  ('psychiatry','anxiety_disorders',  'โรควิตกกังวลและ OCD',                    'Anxiety/OCD',              1, 12, 0, 20),
  ('psychiatry','psychotic_disorders','โรคจิตเภทและกลุ่ม psychotic',            'Psychotic Disorders',      0, 16, 0, 30),
  ('psychiatry','addiction',          'การติดสาร',                              'Addiction Medicine',       1, 13, 0, 40),
  ('psychiatry','personality',        'บุคลิกภาพ',                              'Personality Disorders',    0,  9, 0, 50),
  ('psychiatry','child_psych',        'จิตเวชเด็กและวัยรุ่น',                  'Child & Adolescent Psych', 14,  0, 0, 60),
  ('psychiatry','geriatric_psych',    'จิตเวชผู้สูงอายุ',                       'Geriatric Psych',          0, 10, 0, 70),
  ('psychiatry','eating_disorders',   'โรคการกิน',                              'Eating Disorders',         3,  6, 0, 80),
  ('psychiatry','neuropsych',         'จิตเวชศาสตร์ระบบประสาท',                'Neuropsychiatry',          0, 12, 0, 90),
  ('psychiatry','forensic_psych',     'จิตเวชศาสตร์ทางกฎหมาย',                 'Forensic Psych',           0, 17, 0, 100),

  -- anesthesiology (9 topics)
  ('anesthesiology','general_anes',     'การให้ยาสลบทั่วไป',                   'General Anesthesia',       2, 16, 0, 10),
  ('anesthesiology','regional_anes',    'การระงับความรู้สึกเฉพาะส่วน',         'Regional Anesthesia',      0, 15, 0, 20),
  ('anesthesiology','cardiac_anes',     'วิสัญญีโรคหัวใจ',                     'Cardiac Anesthesia',       1, 14, 0, 30),
  ('anesthesiology','neuro_anes',       'วิสัญญีสมองและประสาท',                'Neuro Anesthesia',         1, 12, 0, 40),
  ('anesthesiology','ob_anes',          'วิสัญญีสูติ',                          'OB Anesthesia',            0, 14, 0, 50),
  ('anesthesiology','peds_anes',        'วิสัญญีกุมาร',                         'Pediatric Anesthesia',    14,  0, 0, 60),
  ('anesthesiology','pain_med',         'เวชศาสตร์การปวด',                     'Pain Medicine',            1, 15, 0, 70),
  ('anesthesiology','critical_care_anes','วิสัญญีวิกฤต',                        'Critical Care',            1, 16, 0, 80),
  ('anesthesiology','ambulatory_anes',  'วิสัญญีผู้ป่วยนอก',                    'Ambulatory Anesthesia',    1,  7, 0, 90),

  -- radiology (9 topics)
  ('radiology','chest_rad',           'ภาพรังสีทรวงอก',                        'Chest Radiology',          2, 17, 0, 10),
  ('radiology','abdominal_rad',       'ภาพรังสีช่องท้อง',                      'Abdominal Radiology',      2, 17, 0, 20),
  ('radiology','neuro_rad',           'ภาพรังสีสมองและประสาท',                 'Neuroradiology',           2, 16, 0, 30),
  ('radiology','msk_rad',             'ภาพรังสีกระดูกและข้อ',                  'MSK Radiology',            2, 14, 0, 40),
  ('radiology','peds_rad',            'รังสีกุมาร',                            'Pediatric Radiology',     13,  0, 0, 50),
  ('radiology','breast_imaging',      'ภาพถ่ายเต้านม',                          'Breast Imaging',           0, 12, 0, 60),
  ('radiology','nuclear_med',         'เวชศาสตร์นิวเคลียร์',                   'Nuclear Medicine',         1, 11, 0, 70),
  ('radiology','interventional_rad',  'รังสีร่วมรักษา',                        'Interventional Radiology', 1, 14, 0, 80),
  ('radiology','cardiac_imaging',     'ภาพหัวใจ',                              'Cardiac Imaging',          1, 12, 0, 90),

  -- family_medicine (10 topics)
  ('family_medicine','adult_chronic',     'โรคเรื้อรังในผู้ใหญ่',                 'Adult Chronic Disease',    0, 18, 0, 10),
  ('family_medicine','geriatric_fm',      'เวชศาสตร์ผู้สูงอายุ',                  'Geriatrics',               0, 14, 0, 20),
  ('family_medicine','women_health_fm',   'สุขภาพสตรี',                            'Women''s Health',         0, 13, 0, 30),
  ('family_medicine','child_health_fm',   'สุขภาพเด็ก',                            'Child Health',            14,  0, 0, 40),
  ('family_medicine','mental_health_fm',  'สุขภาพจิตในเวชปฏิบัติทั่วไป',        'Mental Health',            1, 12, 0, 50),
  ('family_medicine','msk_fm',            'กล้ามเนื้อและกระดูก',                  'MSK',                      1, 10, 0, 60),
  ('family_medicine','derm_fm',           'ผิวหนัง',                                'Dermatology',              2,  8, 0, 70),
  ('family_medicine','eent_fm',           'ตา หู คอ จมูก',                         'EENT',                     2,  7, 0, 80),
  ('family_medicine','palliative',        'การดูแลผู้ป่วยระยะสุดท้าย',              'Palliative Care',          0, 11, 0, 90),
  ('family_medicine','preventive',        'เวชศาสตร์ป้องกัน',                      'Preventive Medicine',      1, 11, 0, 100),

  -- pathology (8 topics)
  ('pathology','surgical_path',       'พยาธิวิทยาศัลยกรรม',                     'Surgical Pathology',       2, 22, 0, 10),
  ('pathology','hematopath',          'พยาธิวิทยาโลหิต',                        'Hematopathology',          2, 14, 0, 20),
  ('pathology','cytopath',            'เซลล์วิทยา',                              'Cytopathology',            0, 13, 0, 30),
  ('pathology','microbiology_path',   'จุลชีววิทยา',                              'Microbiology',             1, 13, 0, 40),
  ('pathology','molecular_path',      'พยาธิวิทยาโมเลกุล',                       'Molecular Pathology',      1, 13, 0, 50),
  ('pathology','autopsy',             'การตรวจศพ',                                'Autopsy',                  1, 13, 0, 60),
  ('pathology','forensic_path',       'พยาธิวิทยานิติเวช',                       'Forensic Pathology',       2, 12, 0, 70),
  ('pathology','clinical_chemistry',  'เคมีคลินิก',                              'Clinical Chemistry',       1, 14, 0, 80),

  -- rehab_medicine (9 topics)
  ('rehab_medicine','stroke_rehab',       'การฟื้นฟูหลังโรคหลอดเลือดสมอง',         'Stroke Rehabilitation',    0, 18, 0, 10),
  ('rehab_medicine','sci_rehab',          'ฟื้นฟูไขสันหลังบาดเจ็บ',                'SCI Rehabilitation',       1, 13, 0, 20),
  ('rehab_medicine','tbi_rehab',          'ฟื้นฟูสมองบาดเจ็บ',                     'TBI Rehabilitation',       2, 12, 0, 30),
  ('rehab_medicine','msk_rehab',          'ฟื้นฟูกล้ามเนื้อและกระดูก',             'MSK Rehabilitation',       1, 16, 0, 40),
  ('rehab_medicine','pediatric_rehab',    'ฟื้นฟูกุมาร',                            'Pediatric Rehab',         14,  0, 0, 50),
  ('rehab_medicine','prosthetics',        'อวัยวะเทียมและกายอุปกรณ์',              'Prosthetics & Orthotics',  1, 12, 0, 60),
  ('rehab_medicine','cardiac_rehab',      'ฟื้นฟูหัวใจ',                            'Cardiac Rehabilitation',   0, 14, 0, 70),
  ('rehab_medicine','pulmonary_rehab',    'ฟื้นฟูปอด',                              'Pulmonary Rehabilitation', 0, 13, 0, 80),
  ('rehab_medicine','pain_rehab',         'ฟื้นฟูการปวดเรื้อรัง',                  'Pain Rehabilitation',      0, 17, 0, 90)
) as t(specialty_slug, slug, name_th, name_en, peds, adult, other, ord)
  on bp.specialty_slug = t.specialty_slug
on conflict (blueprint_id, slug) do nothing;

-- ─── 3. mcq_subjects ─ 4 entry points × 11 specialties = 44 rows
-- (em already seeded ใน board_seed.sql)

insert into public.mcq_subjects
  (name, name_th, icon, audience, board_specialty, exam_type, question_count)
values
  -- internal_medicine (im)
  ('im_clinical_decision',  'IM · การตัดสินใจทางเวชกรรม', '🩺', 'board', 'internal_medicine', null, 0),
  ('im_basic_science',      'IM · วิทยาศาสตร์การแพทย์พื้นฐาน', '🧬', 'board', 'internal_medicine', null, 0),
  ('im_ems_mgmt',           'IM · การจัดการคลินิก',        '📋', 'board', 'internal_medicine', null, 0),
  ('im_integrative',        'IM · ข้อสอบบูรณาการ',         '🧩', 'board', 'internal_medicine', null, 0),
  -- surgery (surg)
  ('surg_clinical_decision','Surgery · การตัดสินใจทางเวชกรรม','🔪','board','surgery',null,0),
  ('surg_basic_science',    'Surgery · วิทยาศาสตร์การแพทย์พื้นฐาน','🧬','board','surgery',null,0),
  ('surg_ems_mgmt',         'Surgery · การจัดการคลินิก',    '📋','board','surgery',null,0),
  ('surg_integrative',      'Surgery · ข้อสอบบูรณาการ',    '🧩','board','surgery',null,0),
  -- pediatrics (peds)
  ('peds_clinical_decision','Peds · การตัดสินใจทางเวชกรรม','👶','board','pediatrics',null,0),
  ('peds_basic_science',    'Peds · วิทยาศาสตร์การแพทย์พื้นฐาน','🧬','board','pediatrics',null,0),
  ('peds_ems_mgmt',         'Peds · การจัดการคลินิก',     '📋','board','pediatrics',null,0),
  ('peds_integrative',      'Peds · ข้อสอบบูรณาการ',      '🧩','board','pediatrics',null,0),
  -- ob_gyn (obgyn)
  ('obgyn_clinical_decision','OB-GYN · การตัดสินใจทางเวชกรรม','🤰','board','ob_gyn',null,0),
  ('obgyn_basic_science',    'OB-GYN · วิทยาศาสตร์การแพทย์พื้นฐาน','🧬','board','ob_gyn',null,0),
  ('obgyn_ems_mgmt',         'OB-GYN · การจัดการคลินิก',    '📋','board','ob_gyn',null,0),
  ('obgyn_integrative',      'OB-GYN · ข้อสอบบูรณาการ',     '🧩','board','ob_gyn',null,0),
  -- orthopedics (ortho)
  ('ortho_clinical_decision','Ortho · การตัดสินใจทางเวชกรรม','🦴','board','orthopedics',null,0),
  ('ortho_basic_science',    'Ortho · วิทยาศาสตร์การแพทย์พื้นฐาน','🧬','board','orthopedics',null,0),
  ('ortho_ems_mgmt',         'Ortho · การจัดการคลินิก',    '📋','board','orthopedics',null,0),
  ('ortho_integrative',      'Ortho · ข้อสอบบูรณาการ',     '🧩','board','orthopedics',null,0),
  -- psychiatry (psych)
  ('psych_clinical_decision','Psych · การตัดสินใจทางเวชกรรม','🧘','board','psychiatry',null,0),
  ('psych_basic_science',    'Psych · วิทยาศาสตร์การแพทย์พื้นฐาน','🧬','board','psychiatry',null,0),
  ('psych_ems_mgmt',         'Psych · การจัดการคลินิก',    '📋','board','psychiatry',null,0),
  ('psych_integrative',      'Psych · ข้อสอบบูรณาการ',     '🧩','board','psychiatry',null,0),
  -- anesthesiology (anes)
  ('anes_clinical_decision','Anes · การตัดสินใจทางเวชกรรม','💉','board','anesthesiology',null,0),
  ('anes_basic_science',    'Anes · วิทยาศาสตร์การแพทย์พื้นฐาน','🧬','board','anesthesiology',null,0),
  ('anes_ems_mgmt',         'Anes · การจัดการคลินิก',     '📋','board','anesthesiology',null,0),
  ('anes_integrative',      'Anes · ข้อสอบบูรณาการ',      '🧩','board','anesthesiology',null,0),
  -- radiology (rad)
  ('rad_clinical_decision', 'Rad · การตัดสินใจทางเวชกรรม','🩻','board','radiology',null,0),
  ('rad_basic_science',     'Rad · วิทยาศาสตร์การแพทย์พื้นฐาน','🧬','board','radiology',null,0),
  ('rad_ems_mgmt',          'Rad · การจัดการคลินิก',      '📋','board','radiology',null,0),
  ('rad_integrative',       'Rad · ข้อสอบบูรณาการ',       '🧩','board','radiology',null,0),
  -- family_medicine (fm)
  ('fm_clinical_decision',  'FM · การตัดสินใจทางเวชกรรม', '🏠','board','family_medicine',null,0),
  ('fm_basic_science',      'FM · วิทยาศาสตร์การแพทย์พื้นฐาน','🧬','board','family_medicine',null,0),
  ('fm_ems_mgmt',           'FM · การจัดการคลินิก',       '📋','board','family_medicine',null,0),
  ('fm_integrative',        'FM · ข้อสอบบูรณาการ',        '🧩','board','family_medicine',null,0),
  -- pathology (path)
  ('path_clinical_decision','Path · การตัดสินใจทางเวชกรรม','🔬','board','pathology',null,0),
  ('path_basic_science',    'Path · วิทยาศาสตร์การแพทย์พื้นฐาน','🧬','board','pathology',null,0),
  ('path_ems_mgmt',         'Path · การจัดการคลินิก',     '📋','board','pathology',null,0),
  ('path_integrative',      'Path · ข้อสอบบูรณาการ',      '🧩','board','pathology',null,0),
  -- rehab_medicine (rehab)
  ('rehab_clinical_decision','Rehab · การตัดสินใจทางเวชกรรม','🦽','board','rehab_medicine',null,0),
  ('rehab_basic_science',    'Rehab · วิทยาศาสตร์การแพทย์พื้นฐาน','🧬','board','rehab_medicine',null,0),
  ('rehab_ems_mgmt',         'Rehab · การจัดการคลินิก',    '📋','board','rehab_medicine',null,0),
  ('rehab_integrative',      'Rehab · ข้อสอบบูรณาการ',     '🧩','board','rehab_medicine',null,0)
on conflict (name) do nothing;
