-- ===============================================================
-- หมอรู้ — Board seed: กุมารเวชศาสตร์ (pediatrics) — 30 MCQs
-- Safe to paste into Supabase SQL Editor. Re-runnable.
-- ===============================================================

begin;

-- 1/2 ─── mcq_subjects for this specialty ────────────────────
insert into public.mcq_subjects
  (name, name_th, icon, audience, board_specialty, exam_type, question_count)
values
  ('peds_clinical_decision', 'กุมารเวชศาสตร์ · การตัดสินใจทางเวชกรรม', '🩺', 'board', 'pediatrics', NULL, 0),
  ('peds_basic_science', 'กุมารเวชศาสตร์ · วิทยาศาสตร์การแพทย์พื้นฐาน', '🧬', 'board', 'pediatrics', NULL, 0),
  ('peds_ems_mgmt', 'กุมารเวชศาสตร์ · การจัดการระบบบริการการแพทย์ฉุกเฉิน', '🚨', 'board', 'pediatrics', NULL, 0),
  ('peds_integrative', 'กุมารเวชศาสตร์ · ข้อสอบบูรณาการ', '🧩', 'board', 'pediatrics', NULL, 0)
on conflict (name) do nothing;

-- 2/2 ─── 30 mcq_questions for pediatrics ─────────────

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 6 เดือน คลอดครบกำหนด มาห้องฉุกเฉินด้วยอาการหอบเหนื่อย ไอ มีเสียง wheeze เป็นมา 3 วัน ก่อนหน้าเป็นหวัด 1 สัปดาห์ พ่อแม่บอกว่าลูกกินนมน้อยลง

V/S: HR 165, RR 65, SpO2 89% room air, Temp 37.8°C, น้ำหนัก 7 kg
Gen: alert but tired, mild cyanosis perioral, nasal flaring, subcostal + intercostal retraction
Lungs: bilateral fine crackles + expiratory wheeze, prolonged expiratory phase

CBC: WBC 12,500, normal differential
CXR: hyperinflation + bilateral perihilar streaking + scattered atelectasis
RSV antigen: positive', '[{"label":"A","text":"IV antibiotics + bronchodilator + steroid"},{"label":"B","text":"Acute Bronchiolitis (RSV) moderate-severe: supportive care mainstay — O2 to SpO2 ≥ 90%, nasal suctioning, hydration; routine bronchodilators NOT recommended (AAP 2014 — no proven benefit); NO routine steroids or antibiotics (viral); HFNC for moderate distress; hospitalization for severe distress/hypoxia/dehydration/apnea < 3 mo; palivizumab prophylaxis for high-risk (premature, BPD, CHD)"},{"label":"C","text":"Discharge with oral antibiotic"},{"label":"D","text":"Intubation immediately"},{"label":"E","text":"Restrict fluid completely"}]'::jsonb,
  'B', 'Bronchiolitis = viral lower respiratory infection (RSV most common). Peak age 2-6 mo. AAP 2014 + NICE emphasize supportive care. Key: O2, hydration, monitoring. No routine antibiotics, bronchodilators, steroids, chest PT. HFNC may help. Prevention: hand hygiene + palivizumab for high-risk. A wrong — abx + steroid not indicated. C wrong — moderate distress can''t discharge. D wrong — try less invasive. E wrong — fluid needed.', NULL,
  'easy', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'AAP Clinical Practice Guideline: Bronchiolitis 2014 (Ralston SL et al.); NICE NG9', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 6 เดือน คลอดครบกำหนด มาห้องฉุกเฉินด้วยอาการหอบเหนื่อย ไอ มีเสียง wheeze เป็นมา 3 วัน ก่อนหน้าเป็นหวัด 1 สัปดาห์ พ่อแม่บอกว่าลูกกินนมน้อยลง

V/S: HR 165, RR 65, SpO2 89% room air, Temp 37.8°C, น้ำหนัก 7 kg
Gen: alert but tired, mild cyanosis perioral, nasal flaring, subcostal + intercostal retraction
Lungs: bilateral fine crackles + expiratory wheeze, prolonged expiratory phase

CBC: WBC 12,500, normal differential
CXR: hyperinflation + bilateral perihilar streaking + scattered atelectasis
RSV antigen: positive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 4 ปี ไข้สูง 39.8°C × 6 วัน + ผื่นแดง + ตาแดง 2 ข้าง + ปากแดงสด + แขนขาบวมแดง + ต่อมน้ำเหลืองที่คอข้างเดียว 1.8 cm + irritable

V/S: HR 142, BP 96/64, Temp 39.8°C
PE: cracked lips + strawberry tongue + cervical lymphadenopathy unilateral + bilateral non-purulent conjunctival injection + polymorphous rash + extremity edema + perineal desquamation

Lab: WBC 18,500, CRP 145, Plt 580,000 (rising), Albumin 2.8
Echo: dilated left main coronary (Z-score +3.5)', '[{"label":"A","text":"Discharge with paracetamol for viral exanthem"},{"label":"B","text":"Complete Kawasaki Disease (5/6 criteria) with coronary involvement: IVIG 2 g/kg IV over 10-12h within first 10 days (reduces coronary aneurysm 25→5%); high-dose aspirin 80-100 mg/kg/d until afebrile 48-72h then low-dose 3-5 mg/kg/d antiplatelet × 6-8 wk; echo at dx, 2 wk, 6-8 wk; high-risk Kobayashi → adjunctive steroid; IVIG-resistant → 2nd IVIG, infliximab; live vaccines delayed 11 mo post-IVIG"},{"label":"C","text":"Antibiotic for streptococcal scarlet fever"},{"label":"D","text":"Observation × 24 hours"},{"label":"E","text":"Hospice care"}]'::jsonb,
  'B', 'Kawasaki = acute vasculitis of medium vessels, leading cause acquired heart disease children. Criteria: fever ≥ 5 d + ≥ 4 of 5: conjunctivitis, oral changes, rash, extremity changes, cervical LN. IVIG + aspirin within first 10 days reduces coronary aneurysm 5×. Echo at dx, 2 wk, 6-8 wk. AHA 2017 guideline. Long-term cardiac surveillance.', NULL,
  'medium', 'cardiovascular', 'review',
  'pediatrics', 'clinical_decision', 'cardiovascular', 'peds',
  'AHA Scientific Statement: Kawasaki Disease 2017 (McCrindle BW et al.)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 4 ปี ไข้สูง 39.8°C × 6 วัน + ผื่นแดง + ตาแดง 2 ข้าง + ปากแดงสด + แขนขาบวมแดง + ต่อมน้ำเหลืองที่คอข้างเดียว 1.8 cm + irritable

V/S: HR 142, BP 96/64, Temp 39.8°C
PE: cracked lips + strawberry tongue + cervical lymphadenopathy unilateral + bilateral non-purulent conjunctival injection + polymorphous rash + extremity edema + perineal desquamation

Lab: WBC 18,500, CRP 145, Plt 580,000 (rising), Albumin 2.8
Echo: dilated left main coronary (Z-score +3.5)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 8 เดือน acute onset ปวดท้อง crying + กระสับกระส่าย 15-20 นาทีแล้วหยุด สลับเป็นรอบ ๆ × 6 ชั่วโมง อาเจียน 3 ครั้ง วันนี้ถ่าย currant jelly stool

V/S: HR 168, lethargic
Abdomen: distended, palpable sausage-shaped mass RUQ

US: target/donut sign + pseudokidney — ileocolic intussusception', '[{"label":"A","text":"Observe + serial exams"},{"label":"B","text":"Ileocolic Intussusception (most common bowel obstruction 6 mo-3 yr): IV fluid bolus 20 mL/kg + NG decompression + NPO; pneumatic or hydrostatic enema reduction under fluoroscopy/US guidance (80-90% success, first-line); contraindications: peritonitis, perforation, instability; surgery if enema fails, perforation, identifiable lead point (older children); post-reduction observation 12-24h (recurrence 5-10%)"},{"label":"C","text":"Antibiotic + outpatient"},{"label":"D","text":"Endoscopy"},{"label":"E","text":"MRI abdomen first"}]'::jsonb,
  'B', 'Intussusception (telescoping bowel) — most common obstruction infants 6 mo-3 yr. Classic triad: intermittent crampy pain + currant jelly stool + sausage mass (25-50%). Most ileocolic (95%). Lead point: lymphoid hyperplasia (post-viral, Peyer''s patches). US diagnostic (target sign). Enema reduction first-line. Surgery if fails or contraindicated. Older children: investigate pathological lead point.', NULL,
  'easy', 'gi', 'review',
  'pediatrics', 'clinical_decision', 'gi', 'peds',
  'AAP Section on Surgery; Marsicovetere P et al. Pediatr Rev 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 8 เดือน acute onset ปวดท้อง crying + กระสับกระส่าย 15-20 นาทีแล้วหยุด สลับเป็นรอบ ๆ × 6 ชั่วโมง อาเจียน 3 ครั้ง วันนี้ถ่าย currant jelly stool

V/S: HR 168, lethargic
Abdomen: distended, palpable sausage-shaped mass RUQ

US: target/donut sign + pseudokidney — ileocolic intussusception'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 12 ปี polyuria + polydipsia + น้ำหนักลด 6 kg × 2 เดือน + เหนื่อย + คลื่นไส้ + อาเจียน 6 ชม

V/S: BP 102/64, HR 124, RR 32 (Kussmaul), Temp 36.8°C, DTX HI
Gen: dehydrated, GCS 13, capillary refill 4 sec

ABG: pH 7.10, PaCO2 18, HCO3 6
Lab: Glucose 685, Na 132, K 5.4, BUN 28, Cr 1.0, Ketone urine 3+, AG 30
New DM type 1', '[{"label":"A","text":"Insulin bolus IV high dose + glucose 50% IV"},{"label":"B","text":"Pediatric DKA moderate-severe (ISPAD 2022): CAUTIOUS fluid resuscitation (high cerebral edema risk!) — 10-20 mL/kg NSS bolus if shock then deficit over 48h (not 24h); insulin drip 0.05-0.1 U/kg/hr start 1-2h AFTER fluid (NO bolus); K replacement in fluid once K < 5.5 + UO established; bicarbonate ONLY if pH < 6.9 + CV compromise; MONITOR for cerebral edema (HA, AMS, bradycardia, HT, sudden change) — mannitol or 3% HTS if suspected; transition to SC insulin when bicarbonate > 18, pH > 7.3, AG closed, eating; diabetes team consultation + family education"},{"label":"C","text":"Same protocol as adult DKA"},{"label":"D","text":"Restrict all fluid"},{"label":"E","text":"Discharge home with oral hypoglycemic"}]'::jsonb,
  'B', 'Pediatric DKA: high risk cerebral edema (mortality 20-25%, most common DKA death in peds). Key differences from adult: cautious fluid over 48h; NO insulin bolus; delayed insulin start; aggressive K replacement; avoid bicarbonate; high suspicion for cerebral edema. Glaser PECARN 2018: fast vs slow fluid + 0.45% vs 0.9% — both safe. Modern: gentle resuscitation + close monitoring + multidisciplinary team.', NULL,
  'hard', 'endocrine_metabolic', 'review',
  'pediatrics', 'clinical_decision', 'endocrine_metabolic', 'peds',
  'ISPAD Guidelines DKA 2022; Glaser PECARN NEJM 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 12 ปี polyuria + polydipsia + น้ำหนักลด 6 kg × 2 เดือน + เหนื่อย + คลื่นไส้ + อาเจียน 6 ชม

V/S: BP 102/64, HR 124, RR 32 (Kussmaul), Temp 36.8°C, DTX HI
Gen: dehydrated, GCS 13, capillary refill 4 sec

ABG: pH 7.10, PaCO2 18, HCO3 6
Lab: Glucose 685, Na 132, K 5.4, BUN 28, Cr 1.0, Ketone urine 3+, AG 30
New DM type 1'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 5 ปี ไข้สูง + คอแข็ง + ปวดศีรษะ + ซึม + กระสับกระส่าย × 24 ชม Vaccine complete

V/S: BP 98/62, HR 142, RR 32, Temp 39.6°C
GCS 12, neck stiffness +, Kernig + Brudzinski +
Mild petechial rash chest

CBC: WBC 22,500, CRP 285, Lactate 4.2
CT brain: normal
LP: WBC 1,850 (PMN 95%), Protein 220, Glucose 18, Gram stain: gram-neg diplococci', '[{"label":"A","text":"Wait for culture before any antibiotic"},{"label":"B","text":"Bacterial Meningitis likely Meningococcus (gram-neg diplococci + petechiae): IMMEDIATE IV antibiotic within 1h — Ceftriaxone 100 mg/kg/d + Vancomycin 60 mg/kg/d (until Spn sens known); Dexamethasone 0.15 mg/kg q6h × 2-4d (give before/with first antibiotic); resuscitation; ICU monitoring; droplet isolation 24h; public health reporting; chemoprophylaxis close contacts (rifampin, cipro, ceftriaxone single dose); audiology follow-up (hearing loss risk)"},{"label":"C","text":"Discharge with oral antibiotic"},{"label":"D","text":"Acyclovir only"},{"label":"E","text":"Steroid only without antibiotic"}]'::jsonb,
  'B', 'Bacterial meningitis = peds emergency. Gram-neg diplococci → N. meningitidis. Time to antibiotic = key prognostic factor — give within 1h. Empiric ceftriaxone + vancomycin. Dexamethasone before/with antibiotic. Isolation + chemoprophylaxis for meningococcal contacts. Long-term: hearing + developmental follow-up. MenACWY + MenB vaccines.', NULL,
  'medium', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'AAP Red Book 2024; IDSA Bacterial Meningitis Guideline 2004', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 5 ปี ไข้สูง + คอแข็ง + ปวดศีรษะ + ซึม + กระสับกระส่าย × 24 ชม Vaccine complete

V/S: BP 98/62, HR 142, RR 32, Temp 39.6°C
GCS 12, neck stiffness +, Kernig + Brudzinski +
Mild petechial rash chest

CBC: WBC 22,500, CRP 285, Lactate 4.2
CT brain: normal
LP: WBC 1,850 (PMN 95%), Protein 220, Glucose 18, Gram stain: gram-neg diplococci'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 18 เดือน development normal มา ED ชักทั้งตัว tonic-clonic 5 นาที ขณะไข้ 39.8°C จาก URI เริ่ม 2 ชม ก่อน หลังชักซึม 10-15 นาทีแล้วฟื้นปกติ ครอบครัวพ่อมีประวัติ febrile seizure

ไม่มี neuro deficit, neck supple, fontanelle ปกติ, no rash
WBC 9,200, glucose 96', '[{"label":"A","text":"Admit for EEG + MRI + LP mandatory"},{"label":"B","text":"Simple Febrile Seizure (6 mo-5 yr, generalized, < 15 min, single in 24h, normal exam): Reassurance (cornerstone — usually benign, recurrence 30%, epilepsy 2-5%); treat fever source (URI viral here); antipyretics for comfort (NOT to prevent recurrence — proven no benefit); NO routine EEG/MRI/LP for simple FS with normal exam in non-toxic well-vaccinated child > 12 mo; NO anticonvulsant prophylaxis; counsel parents: recurrence, safety, when to call EMS (> 5 min, breathing trouble); complex FS (focal, > 15 min, recurrent in 24h, abnormal exam) → fuller workup"},{"label":"C","text":"Long-term phenytoin prophylaxis"},{"label":"D","text":"Discharge without counseling"},{"label":"E","text":"Continuous IV anticonvulsant infusion"}]'::jsonb,
  'B', 'Simple Febrile Seizure: 6 mo-5 yr, fever > 38°C, generalized, < 15 min, single in 24h, normal exam, no CNS infection/metabolic cause. Most common peds seizure (3-5%). Strong familial. Recurrence 30%, epilepsy 2-3% (vs 1% baseline). AAP 2011/2018: minimal workup if classic + well-appearing + > 12 mo + vaccines complete. No prophylactic anticonvulsant. Education + reassurance + safety.', NULL,
  'easy', 'neurology', 'review',
  'pediatrics', 'clinical_decision', 'neurology', 'peds',
  'AAP Febrile Seizures Guideline 2011, re-affirmed 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 18 เดือน development normal มา ED ชักทั้งตัว tonic-clonic 5 นาที ขณะไข้ 39.8°C จาก URI เริ่ม 2 ชม ก่อน หลังชักซึม 10-15 นาทีแล้วฟื้นปกติ ครอบครัวพ่อมีประวัติ febrile seizure

ไม่มี neuro deficit, neck supple, fontanelle ปกติ, no rash
WBC 9,200, glucose 96'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 3 ปี healthy มา ED ไอเสียงดังบ่อย ๆ + เหมือนสำลัก + stridor inspiratory × 30 นาที ลดลงเล็กน้อย ยังมีอยู่ ไม่มีไข้ ประวัติเล่นกับถั่วลิสง 30 นาทีก่อน

V/S: HR 132, RR 28, SpO2 94%
Gen: anxious, mild distress
Stridor inspiratory mild, air entry decreased RLL, no wheeze

CXR (expiratory): RLL hyperinflation + slight mediastinal shift', '[{"label":"A","text":"Discharge — likely viral croup"},{"label":"B","text":"Suspected Foreign Body Aspiration (peds emergency): clinical history + asymmetric breath sounds + CXR signs = high suspicion; don''t disturb child (avoid converting partial to complete obstruction); allow comfortable position + O2; avoid blind finger sweep, back blows/abdominal thrust (per AHA peds BLS — only for complete obstruction with no air movement); urgent RIGID bronchoscopy in OR under GA by experienced peds ENT + anesthesia (diagnosis + removal); CT chest if equivocal but don''t delay; post-extraction monitor edema (steroid), pneumonia; prevention counseling — high-risk foods < 4 yr"},{"label":"C","text":"Heimlich maneuver in office"},{"label":"D","text":"Antibiotic + bronchodilator + outpatient"},{"label":"E","text":"Steroid alone"}]'::jsonb,
  'B', 'FBA — most common accidental death in toddlers. Peak 1-3 yr. Peanuts, popcorn, grapes, hot dogs, beads. Triad: choking + cough + wheeze (50%). CXR normal in 25% (radiolucent). Asymmetric breath sounds, air trapping, atelectasis, mediastinal shift on expiratory film. Rigid bronchoscopy by experienced team. Don''t agitate child + avoid blind interventions. AHA BLS: back blows/thrusts only for complete obstruction without air movement.', NULL,
  'medium', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'AAP Section on Otolaryngology — FBA; AHA Guidelines CPR 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 3 ปี healthy มา ED ไอเสียงดังบ่อย ๆ + เหมือนสำลัก + stridor inspiratory × 30 นาที ลดลงเล็กน้อย ยังมีอยู่ ไม่มีไข้ ประวัติเล่นกับถั่วลิสง 30 นาทีก่อน

V/S: HR 132, RR 28, SpO2 94%
Gen: anxious, mild distress
Stridor inspiratory mild, air entry decreased RLL, no wheeze

CXR (expiratory): RLL hyperinflation + slight mediastinal shift'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 6 ปี บวมรอบตา + ขา + ท้อง 1 สัปดาห์ ปัสสาวะออกน้อย สีคล้ายเบียร์เข้ม

V/S: BP 138/88 (high for age), HR 92
PE: periorbital + lower extremity pitting edema + mild ascites

Urinalysis: protein 4+, blood 3+, RBC casts + dysmorphic RBCs
Lab: Albumin 1.8, Cr 0.8, Chol 380, C3 ต่ำ, C4 ปกติ, ASO 480 (high)

ก่อน 3 สัปดาห์ pharyngitis ไม่รักษา', '[{"label":"A","text":"Steroid pulse therapy high dose"},{"label":"B","text":"Post-streptococcal AGN (PSGN) — classic features: nephritic syndrome, low C3 + normal C4, ASO elevated, RBC casts, recent strep: Supportive care (mainstay — usually self-limiting in children > 95% recover): salt + fluid restriction, diuretic (furosemide) for edema + HT, antihypertensive if severe; NO routine steroid; Penicillin × 10 days (eradicate strep + prevent transmission, not change PSGN course); Monitor BP, UO, weight, electrolytes, Cr; C3 normalize within 8 wk — if persistent → biopsy + DDx (MPGN, lupus, dense deposit); long-term follow-up 1-2 yr"},{"label":"C","text":"Renal transplant evaluation"},{"label":"D","text":"Aggressive immunosuppression"},{"label":"E","text":"Discharge with high-protein diet"}]'::jsonb,
  'B', 'PSGN — classic peds nephritic syndrome 1-3 wk after GAS infection. Immune complex deposition. Features: hematuria + RBC casts + proteinuria + HT + edema + AKI + LOW C3 + normal C4 + elevated ASO. Self-limiting > 95% children. Supportive care. NO routine steroid. C3 normalize 6-8 wk — if persistent → biopsy. DDx: IgA (C3 normal), MPGN (C3 persistent low), Lupus (C3 + C4 low + ANA), HSP (purpura + GI + joints).', NULL,
  'medium', 'renal_gu', 'review',
  'pediatrics', 'clinical_decision', 'renal_gu', 'peds',
  'KDIGO Glomerulonephritis Guideline 2021; Rodriguez-Iturbe B CJASN 2014', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 6 ปี บวมรอบตา + ขา + ท้อง 1 สัปดาห์ ปัสสาวะออกน้อย สีคล้ายเบียร์เข้ม

V/S: BP 138/88 (high for age), HR 92
PE: periorbital + lower extremity pitting edema + mild ascites

Urinalysis: protein 4+, blood 3+, RBC casts + dysmorphic RBCs
Lab: Albumin 1.8, Cr 0.8, Chol 380, C3 ต่ำ, C4 ปกติ, ASO 480 (high)

ก่อน 3 สัปดาห์ pharyngitis ไม่รักษา'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารก 36h GA 34 wk preterm BW 1,800g มาด้วย apnea + cyanosis + lethargy 2 ชม ก่อน ก่อนหน้านี้กินนมได้ดี

V/S: HR 168, BP 56/32 (hypotensive), RR irregular + apnea, Temp 35.8°C (hypothermia), SpO2 88%
Gen: lethargic, poor perfusion
Mother: GBS unknown, ROM 18h, intrapartum fever 38.4°C

Lab: WBC 4,200 (band 24%, I/T 0.4), Plt 102K
ABG: pH 7.20, HCO3 14, Lactate 4.8
CRP 28 (high for neonate)', '[{"label":"A","text":"Observation 24 hours"},{"label":"B","text":"Early-Onset Neonatal Sepsis (< 72h — likely GBS, E. coli, Listeria from maternal source): Immediate IV antibiotic within 1h — Ampicillin (GBS, Listeria, susceptible E. coli) + Gentamicin (gram-neg + synergy); cefotaxime if meningitis (NOT ceftriaxone in neonates — kernicterus + Ca precipitation); Septic workup: blood culture × 2, CBC, CRP serial, urine culture (if > 6 days), LP if possible, CXR; Resuscitation: warming, fluid bolus 10-20 mL/kg, vasopressor for hypotension, intubation if needed; NICU; Duration: 10-14d bacteremia, 14-21d meningitis; modify per culture; family support; long-term developmental follow-up"},{"label":"C","text":"Discharge home with parental observation"},{"label":"D","text":"Oral antibiotic"},{"label":"E","text":"Hold antibiotic until culture grows"}]'::jsonb,
  'B', 'Neonatal sepsis: early-onset < 72h (vertical from mother — GBS, E. coli, Listeria) vs late-onset > 72h (hospital/community). Risk factors: prematurity, prolonged ROM > 18h, maternal intrapartum fever, GBS unknown. Signs subtle: temperature instability (hypo > hyper), apnea, poor feeding, lethargy. Sepsis screen: CBC + I/T ratio + CRP + culture. Empirical antibiotic ASAP: ampicillin + gentamicin (NOT ceftriaxone). LP if possible. NICU resuscitation. Duration based on organism + culture + clinical.', NULL,
  'hard', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'AAP Red Book 2024; AAP COFN Suspected Early-Onset Sepsis 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารก 36h GA 34 wk preterm BW 1,800g มาด้วย apnea + cyanosis + lethargy 2 ชม ก่อน ก่อนหน้านี้กินนมได้ดี

V/S: HR 168, BP 56/32 (hypotensive), RR irregular + apnea, Temp 35.8°C (hypothermia), SpO2 88%
Gen: lethargic, poor perfusion
Mother: GBS unknown, ROM 18h, intrapartum fever 38.4°C

Lab: WBC 4,200 (band 24%, I/T 0.4), Plt 102K
ABG: pH 7.20, HCO3 14, Lactate 4.8
CRP 28 (high for neonate)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิง 14 เดือน normal development จน 9 เดือน หลังจากนั้นช้าลง: ไม่นั่งจน 14 เดือน, ไม่พูดคำ, ไม่ตอบสนองชื่อ, eye contact ลดลง, head circumference จาก 75th → 25th percentile

ไม่มี dysmorphic features
Family: น้องคนพี่ healthy, ไม่มีประวัติพันธุกรรม', '[{"label":"A","text":"Normal variation, observe"},{"label":"B","text":"Global Developmental Delay + Regression + Microcephaly progression — neurodegenerative concern (Rett syndrome in girls, mitochondrial, leukodystrophy, neurometabolic): multidisciplinary referral — dev peds, neuro, genetics; Tier 1: chromosomal microarray + Fragile X + MECP2 (Rett — regression 6-18 mo + microcephaly + hand stereotypies + lost purposeful hand use + breathing irregularities); brain MRI; metabolic screen (ammonia, lactate, AA, OA, acylcarnitine, VLCFA, MPS, lysosomal); TSH, CK; Tier 2: whole exome sequencing, mtDNA; Early intervention (don''t wait for dx): PT/OT/speech; Family support + genetic counseling; symptomatic + specific treatments for some metabolic disorders"},{"label":"C","text":"Refer adult psychiatry"},{"label":"D","text":"Lifestyle change only"},{"label":"E","text":"MRI without other workup"}]'::jsonb,
  'B', 'Developmental regression + microcephaly progression = red flag for neurodegenerative disease. Rett syndrome: girls, 6-18 mo regression + lost hand use + stereotypies + microcephaly progression + breathing irregularities + seizures — MECP2 gene (X-linked). Other: neurometabolic, leukodystrophies, neurogenetic syndromes. Tiered workup. Early intervention essential. Multidisciplinary: dev peds, neuro, genetics, therapies, family.', NULL,
  'hard', 'neurology', 'review',
  'pediatrics', 'clinical_decision', 'neurology', 'peds',
  'AAP Comprehensive Evaluation of Children with GDD 2014; RettSearch Consensus Criteria 2010', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิง 14 เดือน normal development จน 9 เดือน หลังจากนั้นช้าลง: ไม่นั่งจน 14 เดือน, ไม่พูดคำ, ไม่ตอบสนองชื่อ, eye contact ลดลง, head circumference จาก 75th → 25th percentile

ไม่มี dysmorphic features
Family: น้องคนพี่ healthy, ไม่มีประวัติพันธุกรรม'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 7 ปี น้ำหนัก 24 kg underlying asthma ICS regular มา ED ด้วยอาการเหนื่อย + wheeze ต่อเนื่อง 6 ชม ก่อนหน้านี้พ่นยา salbutamol ที่บ้านทุก 2 ชม ไม่ดีขึ้น

V/S: HR 142, RR 38, SpO2 88% room air, Temp 36.8°C
Gen: tired, unable to complete sentences
Use accessory muscles, suprasternal + intercostal retraction marked
Wheezing both lungs, expiratory phase prolonged', '[{"label":"A","text":"Salbutamol nebulization × 1 dose then reassess in 20 min"},{"label":"B","text":"Severe asthma exacerbation (PRAM/PASS high score): continuous nebulized SABA (salbutamol) + ipratropium nebulization (synergistic) × 3 stacked doses; systemic corticosteroid (oral pred 1-2 mg/kg or IV methylprednisolone 1 mg/kg); IV magnesium sulfate 25-50 mg/kg over 20 min (severe not responding); supplemental O2 to SpO2 ≥ 94%; prepare PICU; consider IV terbutaline, ketamine, or NIV/intubation for impending failure; chest X-ray if focal finding or atypical; admit; follow-up: action plan, ICS optimization, allergy + trigger review"},{"label":"C","text":"ICS increased dose + observe 1 hour"},{"label":"D","text":"Subcutaneous epinephrine + heliox"},{"label":"E","text":"Intubate immediately"}]'::jsonb,
  'B', 'Severe peds asthma exacerbation: failed home SABA + signs of severe distress (RR ↑, SpO2 < 92%, accessory muscle use, unable to speak in sentences). GINA + AAP: continuous nebulized SABA + ipratropium; systemic steroid (oral if tolerating, IV if not); IV MgSO4 for severe not responding to SABA dose 1; O2 to ≥ 94%; PICU for not improving. Intubation last resort (high barotrauma risk in status asthmaticus).', NULL,
  'medium', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'GINA 2024 Global Strategy for Asthma; AAP Acute Asthma Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 7 ปี น้ำหนัก 24 kg underlying asthma ICS regular มา ED ด้วยอาการเหนื่อย + wheeze ต่อเนื่อง 6 ชม ก่อนหน้านี้พ่นยา salbutamol ที่บ้านทุก 2 ชม ไม่ดีขึ้น

V/S: HR 142, RR 38, SpO2 88% room air, Temp 36.8°C
Gen: tired, unable to complete sentences
Use accessory muscles, suprasternal + intercostal retraction marked
Wheezing both lungs, expiratory phase prolonged'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 2 ปี ก่อนหน้านี้ healthy มาด้วยอาการไอเสียงเห่า (barking) + stridor inspiratory + hoarseness + ไข้ต่ำ 38.2°C เริ่ม 24 ชม ก่อน ก่อนหน้านี้มี URI 2 วัน

V/S: HR 132, RR 32, SpO2 95% room air
Gen: alert, mild distress at rest, no drooling, no toxic appearance
Stridor inspiratory at rest, mild retraction, no cyanosis
Voice hoarse, barking cough

Westley croup score = 4 (moderate)', '[{"label":"A","text":"Intubation immediately"},{"label":"B","text":"Moderate Croup (viral laryngotracheobronchitis, often parainfluenza): Dexamethasone 0.6 mg/kg PO/IV/IM single dose (or budesonide nebulization 2 mg as alternative) — Cochrane evidence reduces revisits, hospitalizations, intubation; Nebulized racemic epinephrine 2.25% 0.5 mL or L-epinephrine 5 mL of 1:1000 for moderate-severe distress at rest (immediate relief but observe 3-4h for rebound); humidified air NOT proven; supportive care, hydration, antipyretic; admit if persistent stridor at rest after Rx, hypoxia, dehydration, comorbidity; discharge home with parental education + return precautions"},{"label":"C","text":"IV antibiotic + admit"},{"label":"D","text":"Albuterol + ipratropium"},{"label":"E","text":"Discharge with cough syrup only"}]'::jsonb,
  'B', 'Croup (viral) common 6 mo-6 yr, parainfluenza most. Westley score grades severity: 0-2 mild, 3-5 moderate, 6-11 severe, 12+ impending failure. Mild: dexamethasone + discharge. Moderate-severe: + nebulized epinephrine, observe 3-4h. DDx: epiglottitis (toxic, drooling, tripod — Hib vaccine reduced), bacterial tracheitis, FBA, retropharyngeal abscess. Humidified air debunked. Single-dose dex effective.', NULL,
  'easy', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'AAP Section on Otolaryngology; Bjornson CL et al. NEJM 2004 (Dexamethasone in Croup)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 2 ปี ก่อนหน้านี้ healthy มาด้วยอาการไอเสียงเห่า (barking) + stridor inspiratory + hoarseness + ไข้ต่ำ 38.2°C เริ่ม 24 ชม ก่อน ก่อนหน้านี้มี URI 2 วัน

V/S: HR 132, RR 32, SpO2 95% room air
Gen: alert, mild distress at rest, no drooling, no toxic appearance
Stridor inspiratory at rest, mild retraction, no cyanosis
Voice hoarse, barking cough

Westley croup score = 4 (moderate)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 18 เดือน มาด้วยไข้สูง 39.4°C × 48 ชม ไม่มีอาการระบุชัดเจน irritable + ดื่มน้ำน้อยลง ปัสสาวะออกน้อย

Vaccine complete
V/S: HR 132, BP 92/58, RR 24, Temp 39.4°C
Gen: irritable, well-hydrated mostly
Kidney area: percussion tenderness left

Urinalysis (catheter sample): WBC > 100, nitrite +, leukocyte esterase +, bacteria +
Urine culture: pending
CBC: WBC 16,500, CRP 88', '[{"label":"A","text":"Wait for culture, no treatment"},{"label":"B","text":"Febrile UTI / Pyelonephritis (toddler with positive UA + flank tenderness): Empirical antibiotic — oral if tolerating + non-toxic (cefixime, cefpodoxime, amoxicillin-clavulanate) × 7-10 days OR IV if toxic/dehydrated/refusing PO (ceftriaxone 50 mg/kg/d then switch to PO); urine culture to guide; renal/bladder US within 2 weeks (AAP 2011 — first febrile UTI all children 2-24 mo); VCUG only if abnormal US or recurrence (AAP 2011 change from prior recommendation); follow-up: clinical resolution, repeat UA + culture only if persistent symptoms; counsel: hygiene, hydration, recognize recurrence symptoms; long-term: minority develop renal scarring (5-15%) — risk factor VUR"},{"label":"C","text":"Symptomatic only"},{"label":"D","text":"Surgery immediately"},{"label":"E","text":"Long-term prophylactic antibiotic for all"}]'::jsonb,
  'B', 'Pediatric UTI: 2-24 mo with fever, esp female + uncircumcised male, requires evaluation. Catheterized or suprapubic specimen (bag culture unreliable). E. coli most common. AAP 2011 (revised 2016): empirical antibiotic (oral OK if non-toxic) 7-10 d; US within 2 wk first febrile UTI; VCUG only if abnormal US or recurrence (departed from prior). Long-term: renal scarring risk in minority; VUR association. Counsel hygiene + hydration + recurrence signs.', NULL,
  'easy', 'renal_gu', 'review',
  'pediatrics', 'clinical_decision', 'renal_gu', 'peds',
  'AAP Subcommittee on Urinary Tract Infection — Clinical Practice Guideline 2011, re-affirmed 2016', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 18 เดือน มาด้วยไข้สูง 39.4°C × 48 ชม ไม่มีอาการระบุชัดเจน irritable + ดื่มน้ำน้อยลง ปัสสาวะออกน้อย

Vaccine complete
V/S: HR 132, BP 92/58, RR 24, Temp 39.4°C
Gen: irritable, well-hydrated mostly
Kidney area: percussion tenderness left

Urinalysis (catheter sample): WBC > 100, nitrite +, leukocyte esterase +, bacteria +
Urine culture: pending
CBC: WBC 16,500, CRP 88'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกชายอายุ 5 สัปดาห์ มาด้วยอาการอาเจียนพุ่ง (projectile) ทุกมื้อนม 2 สัปดาห์ น้ำหนักลด 200 g ก่อนหน้านี้กินดี

V/S: HR 142, dehydration moderate
Gen: hungry after vomiting ("hungry vomiter")
Abdomen: visible peristalsis epigastrium + palpable "olive-like" mass RUQ

Lab: Na 134, K 3.2 (low), Cl 92 (low), HCO3 32 (high) — hypochloremic, hypokalemic metabolic alkalosis
US abdomen: pyloric muscle thickness 5 mm, pyloric channel length 18 mm — consistent with hypertrophic pyloric stenosis', '[{"label":"A","text":"Emergent surgery without correction"},{"label":"B","text":"Hypertrophic Pyloric Stenosis: correct electrolyte + dehydration FIRST before surgery (NOT a surgical emergency — metabolic correction critical): IV NSS 20 mL/kg bolus if shock, then D5 1/2 NS + KCl 20-40 mEq/L at 1.5-2× maintenance; goal: Cl > 100, HCO3 < 26-30, K > 3.5, urine Cl > 20; NPO + NG decompression if vomiting; then Ramstedt pyloromyotomy (open or laparoscopic) — definitive, excellent outcomes; post-op: feeds advance within 4-8h; rarely persistent vomiting; counsel parents: not preventable, very good prognosis"},{"label":"C","text":"Antibiotic + observation"},{"label":"D","text":"Endoscopy"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', 'Hypertrophic Pyloric Stenosis: presents 2-12 wk (peak 3-5 wk), males 4:1, firstborn. Projectile non-bilious vomiting + hungry after + visible peristalsis + olive mass (60%). US diagnostic (muscle > 4 mm, channel > 15 mm). Classic: hypochloremic hypokalemic metabolic alkalosis from loss of HCl. CORRECT METABOLIC DERANGEMENT FIRST (not surgical emergency). Anesthesia risk if not corrected (paradoxic aciduria, post-op apnea). Ramstedt pyloromyotomy curative. Excellent prognosis.', NULL,
  'easy', 'gi', 'review',
  'pediatrics', 'clinical_decision', 'gi', 'peds',
  'AAP Section on Surgery; Pandya S, Heiss K. Pediatr Clin North Am 2012', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกชายอายุ 5 สัปดาห์ มาด้วยอาการอาเจียนพุ่ง (projectile) ทุกมื้อนม 2 สัปดาห์ น้ำหนักลด 200 g ก่อนหน้านี้กินดี

V/S: HR 142, dehydration moderate
Gen: hungry after vomiting ("hungry vomiter")
Abdomen: visible peristalsis epigastrium + palpable "olive-like" mass RUQ

Lab: Na 134, K 3.2 (low), Cl 92 (low), HCO3 32 (high) — hypochloremic, hypokalemic metabolic alkalosis
US abdomen: pyloric muscle thickness 5 mm, pyloric channel length 18 mm — consistent with hypertrophic pyloric stenosis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกแรกเกิด GA 38 wk BW 3.2 kg วันที่ 4 หลังเกิด มีอาการตัวเหลือง พ่อแม่กังวล

V/S: stable, breastfeeding ปานกลาง (น้ำหนักลด 9% ของน้ำหนักแรกเกิด), urine output ปานกลาง
Gen: alert, jaundice ลามถึงท้องและขา

Blood group: mother O+, baby A+, DAT positive
Total bilirubin: 22 mg/dL (high), Direct 0.8
Hb 14.2, retic 4% (high), peripheral smear: spherocytes, microspherocytes', '[{"label":"A","text":"Observation only"},{"label":"B","text":"Neonatal Hyperbilirubinemia from ABO incompatibility hemolysis (high risk per AAP Bhutani nomogram > 95th percentile + risk factors): immediate intensive phototherapy (target > 12 cm² body surface); hydration support (continue breastfeeding + supplementation if needed — NOT routine IVF unless dehydrated); exchange transfusion threshold based on age + risk + bilirubin trend (per AAP 2022 guideline curves) — typically TSB > 25 mg/dL in term healthy or > 20 + risk factors; monitor TSB q4-6h; check for ABO/Rh, G6PD, sepsis, sepsis, infection; phototherapy continued until TSB safely below threshold; long-term hearing screen (kernicterus = irreversible brain damage); counsel parents"},{"label":"C","text":"Discharge with sunlight exposure"},{"label":"D","text":"Stop breastfeeding permanently"},{"label":"E","text":"IV antibiotic only"}]'::jsonb,
  'B', 'Neonatal hyperbilirubinemia: physiologic (peak day 3-5, < 12 mg/dL term) vs pathologic (early < 24h, rapid rise, prolonged, direct > 20%). Causes: hemolytic (ABO, Rh, G6PD, hereditary spherocytosis), polycythemia, breastfeeding (suboptimal feeding) vs breast milk (later, > 7d), sepsis, hypothyroidism, biliary atresia (direct). AAP 2022 guidelines: TSB-age-based curves. Phototherapy first-line. Exchange for very high TSB. Kernicterus = bilirubin encephalopathy (lethargy, hypertonia, opisthotonos, sensorineural hearing loss).', NULL,
  'medium', 'hematology', 'review',
  'pediatrics', 'clinical_decision', 'hematology', 'peds',
  'AAP Clinical Practice Guideline: Hyperbilirubinemia in the Newborn 2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกแรกเกิด GA 38 wk BW 3.2 kg วันที่ 4 หลังเกิด มีอาการตัวเหลือง พ่อแม่กังวล

V/S: stable, breastfeeding ปานกลาง (น้ำหนักลด 9% ของน้ำหนักแรกเกิด), urine output ปานกลาง
Gen: alert, jaundice ลามถึงท้องและขา

Blood group: mother O+, baby A+, DAT positive
Total bilirubin: 22 mg/dL (high), Direct 0.8
Hb 14.2, retic 4% (high), peripheral smear: spherocytes, microspherocytes'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกแรกเกิด GA 39 wk BW 3.4 kg อายุ 2 วัน มีอาการ central cyanosis ต่อเนื่อง SpO2 78% pre-ductal และ 76% post-ductal, ไม่ดีขึ้นด้วย O2 100%

V/S: HR 152, RR 58, BP 64/40, Temp 36.8°C
PE: no respiratory distress, well-perfused, no murmur clearly heard

Hyperoxia test: PaO2 from 38 → 62 (failed to rise > 150 — suggests cardiac cause)
CXR: "egg on a string" appearance + decreased pulmonary vasculature
Echo: D-Transposition of Great Arteries (D-TGA), intact ventricular septum, small PDA, small PFO', '[{"label":"A","text":"Observation 24 hours"},{"label":"B","text":"Critical cyanotic congenital heart disease (D-TGA) — neonatal emergency: Maintain ductal patency — PROSTAGLANDIN E1 (alprostadil) IV infusion 0.05-0.1 mcg/kg/min (start immediately; allows mixing through PDA between parallel circulations); monitor for side effects (apnea, hypotension, fever); NICU/cardiac ICU admission; pediatric cardiology consult — cardiac catheterization + balloon atrial septostomy (Rashkind) within hours (improves mixing at atrial level); definitive surgery — arterial switch operation (ASO/Jatene) within first 2-3 weeks of life; pre-op stabilization: avoid hyperoxia + acidosis + temperature derangement; family counseling + multidisciplinary cardiac team"},{"label":"C","text":"Discharge with oxygen at home"},{"label":"D","text":"Diuretic alone"},{"label":"E","text":"Antibiotic only"}]'::jsonb,
  'B', 'Critical cyanotic CHD presenting early: D-TGA most common (egg-on-string CXR); also TAPVR, Tricuspid atresia, Truncus, Tetralogy + critical PS. Ductal-dependent — PGE1 maintains PDA for circulation mixing/blood flow. Hyperoxia test failed PaO2 < 150 = likely cardiac. Echo confirms. Rashkind balloon atrial septostomy = bridge. Arterial switch (Jatene) within 2-3 weeks. Pulse oximetry screening newborn (post-ductal > 95% + < 3% difference pre/post-ductal) — universal in many countries.', NULL,
  'hard', 'cardiovascular', 'review',
  'pediatrics', 'clinical_decision', 'cardiovascular', 'peds',
  'AHA Scientific Statement: Pediatric Cardiology; AAP Newborn Pulse Oximetry Screening Endorsement', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกแรกเกิด GA 39 wk BW 3.4 kg อายุ 2 วัน มีอาการ central cyanosis ต่อเนื่อง SpO2 78% pre-ductal และ 76% post-ductal, ไม่ดีขึ้นด้วย O2 100%

V/S: HR 152, RR 58, BP 64/40, Temp 36.8°C
PE: no respiratory distress, well-perfused, no murmur clearly heard

Hyperoxia test: PaO2 from 38 → 62 (failed to rise > 150 — suggests cardiac cause)
CXR: "egg on a string" appearance + decreased pulmonary vasculature
Echo: D-Transposition of Great Arteries (D-TGA), intact ventricular septum, small PDA, small PFO'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 8 เดือน มาด้วยผิวซีดมา 2 เดือน อ่อนเพลีย กินอาหารน้อย ส่วนใหญ่ดื่มนมวัวมาก (1.5 L/day) ตั้งแต่ 6 เดือน ไม่กินอาหารแข็ง

V/S: HR 132 (tachycardia), BP 88/52, Temp 36.8°C
Gen: pale, irritable, developmental milestones at age level
Mild systolic murmur grade 2/6 (flow murmur)

Lab: Hb 6.4 (severe anemia), MCV 58 (microcytic), MCH 18 (hypochromic), RDW 22% (high), Reticulocyte 1.0%, Ferritin 4 ng/mL (very low), Iron 18, TIBC 520, Transferrin sat 4%
Thalassemia screening: negative', '[{"label":"A","text":"Transfusion immediately"},{"label":"B","text":"Severe Iron Deficiency Anemia (cow milk excess + low intake of iron-rich food): correctable nutritional cause: Oral iron supplementation 3-6 mg/kg/day elemental iron in divided doses (or single daily — equivalent efficacy with better adherence per recent evidence); vitamin C to enhance absorption (give with citrus juice not milk); limit cow milk to < 500 mL/day (cow milk inhibits iron absorption + GI microbleeding); introduce iron-rich complementary foods (meat, fortified cereal, beans, dark green vegetables); reassess Hb 4 weeks (expect rise 1-2 g/dL); continue iron 3 months after Hb normal to replete stores; severe symptomatic anemia (HR > 180, CHF, severe pallor): consider transfusion (small aliquots over time to avoid CHF — transfusion-related); investigate other causes if no response (occult blood loss, malabsorption, parasites); developmental follow-up (iron deficiency linked to cognitive deficits)"},{"label":"C","text":"IV iron infusion immediately"},{"label":"D","text":"Bone marrow biopsy"},{"label":"E","text":"Erythropoietin"}]'::jsonb,
  'B', 'Pediatric IDA: peak 9-24 mo. Causes: cow milk excess > 500 mL/d (low Fe + induces GI microbleeding + low solid food intake); preemie/LBW (low stores); rapid growth. Diagnosis: microcytic hypochromic + low ferritin + low transferrin sat. DDx: thalassemia (high ferritin), anemia of chronic disease (high ferritin). Treatment: oral iron 3-6 mg/kg/d + vitamin C + dietary modification. Reassess 4 wk. Continue 3 mo post-Hb normal. Long-term: cognitive impact — early treatment important. Iron-fortified cereal + meat in complementary feeding (start 6 mo).', NULL,
  'easy', 'hematology', 'review',
  'pediatrics', 'clinical_decision', 'hematology', 'peds',
  'AAP Clinical Report: Diagnosis and Prevention of Iron Deficiency 2010', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 8 เดือน มาด้วยผิวซีดมา 2 เดือน อ่อนเพลีย กินอาหารน้อย ส่วนใหญ่ดื่มนมวัวมาก (1.5 L/day) ตั้งแต่ 6 เดือน ไม่กินอาหารแข็ง

V/S: HR 132 (tachycardia), BP 88/52, Temp 36.8°C
Gen: pale, irritable, developmental milestones at age level
Mild systolic murmur grade 2/6 (flow murmur)

Lab: Hb 6.4 (severe anemia), MCV 58 (microcytic), MCH 18 (hypochromic), RDW 22% (high), Reticulocyte 1.0%, Ferritin 4 ng/mL (very low), Iron 18, TIBC 520, Transferrin sat 4%
Thalassemia screening: negative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 2 ปี น้ำหนัก 9 kg (< 3rd percentile) ส่งจาก outpatient clinic ด้วยอาการน้ำหนักไม่เพิ่ม 6 เดือน + อาเจียนเป็นๆ หายๆ + กินอาหารน้อย + พัฒนาการช้า (ไม่พูดคำ ไม่เดินมั่นคง)

Family: parents working long hours, ทารกอยู่กับยายอายุ 75 ปี ภาวะเศรษฐกิจไม่ดี

Gen: pale, thin, lethargic, signs of micronutrient deficiency (cheilosis, koilonychia)
Mild abdominal distension
No organomegaly
No dysmorphic features', '[{"label":"A","text":"Discharge with multivitamins"},{"label":"B","text":"Failure to Thrive — multifactorial workup + multidisciplinary management: (1) Comprehensive history: diet (24h recall, food diary), feeding patterns, family + social, medical, GI symptoms; (2) Examination: anthropometrics (weight, height, head circumference, BMI plotted), signs of malnutrition + micronutrient deficiency, developmental assessment; (3) Workup: CBC, electrolytes, BUN, Cr, glucose, LFT, TSH, urinalysis, celiac serology, stool studies (O&P, occult blood); sweat chloride if suspicion CF; HIV; specific tests based on history; (4) Multidisciplinary: pediatrician, dietitian, social worker (food security, family support), developmental specialist, possibly psychiatry (eating disorder, depression), speech therapy (feeding/swallowing); (5) Nutritional rehabilitation: increase calorie density, supplemental feeds, NG/G-tube if severe; (6) Social interventions: food assistance, WIC, family support, evaluate for neglect (rare but consider); (7) Hospitalization criteria: severe malnutrition, refractory weight loss, suspected abuse/neglect, family inability to manage; (8) Re-feeding precaution if severe; (9) Long-term: developmental follow-up, school readiness, prevention of recurrence"},{"label":"C","text":"Operate for suspected obstruction"},{"label":"D","text":"Antibiotic empirical"},{"label":"E","text":"Ignore — will catch up"}]'::jsonb,
  'B', 'Failure to Thrive (FTT) = inadequate growth (weight < 3rd or 5th percentile, weight loss, or crossing 2 major percentile lines downward). Causes: organic (5-10% — CF, CHD, GI malabsorption, metabolic, endocrine, neurologic), non-organic (psychosocial — most common — feeding interactions, neglect, food insecurity, depression, postpartum). Workup: history + exam first then targeted labs. Multidisciplinary essential. Treat cause. Nutritional rehab. Social intervention often key. Don''t miss neglect/abuse but don''t assume. Long-term: developmental, cognitive impacts.', NULL,
  'medium', 'signs_symptoms', 'review',
  'pediatrics', 'clinical_decision', 'signs_symptoms', 'peds',
  'AAP Section on Endocrinology; Cole SZ, Lanham JS. Am Fam Physician 2011 (FTT Review)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 2 ปี น้ำหนัก 9 kg (< 3rd percentile) ส่งจาก outpatient clinic ด้วยอาการน้ำหนักไม่เพิ่ม 6 เดือน + อาเจียนเป็นๆ หายๆ + กินอาหารน้อย + พัฒนาการช้า (ไม่พูดคำ ไม่เดินมั่นคง)

Family: parents working long hours, ทารกอยู่กับยายอายุ 75 ปี ภาวะเศรษฐกิจไม่ดี

Gen: pale, thin, lethargic, signs of micronutrient deficiency (cheilosis, koilonychia)
Mild abdominal distension
No organomegaly
No dysmorphic features'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 9 เดือน นำส่งโดยพ่อแม่ด้วยอาการ multiple bruises ที่ขา + แขน + หลัง + ก้น 3 สัปดาห์ ไม่มีประวัติบาดเจ็บที่ชัดเจน หรือเล่ามีแต่ "ตกจากเก้าอี้"

Vaccine partial (delayed)
Development delayed (no sitting at 9 months, no babbling)

V/S: HR 132, BP 88/56, Temp 36.8°C, น้ำหนัก < 5th percentile
PE: multiple bruises ในระยะต่างๆ (different colors — yellow, blue, purple) ที่ป้องและ non-bony sites; subconjunctival hemorrhage; circular bruise คล้ายรอยมือ
Fundoscopy: bilateral retinal hemorrhages multiple layers

Family: father unemployed, mother depressed', '[{"label":"A","text":"Discharge home with vitamin K"},{"label":"B","text":"Non-Accidental Injury (NAI) / Child Abuse — multiple red flags: history inconsistent with injuries, multiple bruises different ages on non-bony sites, retinal hemorrhages (shaken baby), developmental delay, parental risk factors. Mandatory action: (1) Admit hospital for safety + workup; (2) Comprehensive evaluation: skeletal survey (occult fractures — rib, metaphyseal), head CT (subdural hematoma, edema, axonal injury), abdominal CT if concern, ophthalmology (retinal hemorrhages — specific for abusive head trauma), bone scan if concerning, coagulation studies (rule out bleeding disorder); (3) MANDATORY REPORT to child protective services / police (legally required, do not delay or ask parents'' permission); (4) Multidisciplinary child protection team consultation; (5) Social work + psychiatric assessment of family; (6) Safety plan before discharge — may require foster care, kinship placement, or supervised visits; (7) Court testimony documentation; (8) Long-term: developmental, behavioral, psychological follow-up (high risk PTSD, attachment, future problems); (9) Sibling assessment (others at risk); (10) Treatment + support for non-offending parent if applicable"},{"label":"C","text":"Counsel parents and discharge"},{"label":"D","text":"Ignore — accidental"},{"label":"E","text":"Surgical correction of bruises"}]'::jsonb,
  'B', 'Child abuse / Non-Accidental Injury — high mortality (death in infants common): red flags = history inconsistent with injuries; injuries at different ages; non-bony sites (back, buttocks, ears, neck); patterns (handprint, bite, ligature); retinal hemorrhages bilateral multi-layer (abusive head trauma / shaken baby); rib fractures (esp posterior, in infants); developmental delay + neglect signs. Mandatory reporting (legally required, immediately, do not need parental permission). Skeletal survey + head imaging + ophthalmology. Multidisciplinary: pediatrics, child abuse specialist, social work, CPS, law enforcement, possibly forensics. Safety FIRST. Document carefully. Long-term outcomes worse if unrecognized + return to abusive environment.', NULL,
  'medium', 'trauma', 'review',
  'pediatrics', 'clinical_decision', 'trauma', 'peds',
  'AAP Committee on Child Abuse and Neglect; The Lancet Series on Child Maltreatment 2009', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 9 เดือน นำส่งโดยพ่อแม่ด้วยอาการ multiple bruises ที่ขา + แขน + หลัง + ก้น 3 สัปดาห์ ไม่มีประวัติบาดเจ็บที่ชัดเจน หรือเล่ามีแต่ "ตกจากเก้าอี้"

Vaccine partial (delayed)
Development delayed (no sitting at 9 months, no babbling)

V/S: HR 132, BP 88/56, Temp 36.8°C, น้ำหนัก < 5th percentile
PE: multiple bruises ในระยะต่างๆ (different colors — yellow, blue, purple) ที่ป้องและ non-bony sites; subconjunctival hemorrhage; circular bruise คล้ายรอยมือ
Fundoscopy: bilateral retinal hemorrhages multiple layers

Family: father unemployed, mother depressed'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 5 ปี น้ำหนัก 18 kg มาด้วยอาการ chronic ไอเรื้อรัง + เหนื่อย + น้ำหนักไม่เพิ่ม 6 เดือน + ถ่ายอุจจาระมีน้ำมันมัน + อาเจียน

Vaccine complete
Family: ลูกพี่ลูกน้องสมาชิกครอบครัวมี cystic fibrosis

V/S: HR 102, RR 22, SpO2 96%, ไม่มีไข้
Gen: pale, thin, mild clubbing
Lungs: occasional crackles bilateral, mild expiratory wheeze
Abdomen: distended, mild tenderness, no hepatosplenomegaly
Pilonidal area: bulky stool noted on undergarment

Sweat chloride test: 78 mEq/L (high — > 60 = positive)
CFTR genetic testing: F508del homozygous
Fecal elastase: < 100 (pancreatic insufficiency)', '[{"label":"A","text":"Symptomatic only"},{"label":"B","text":"Cystic Fibrosis — multisystem disease requiring multidisciplinary care: (1) Respiratory: airway clearance (chest physiotherapy, oscillating PEP, hypertonic saline neb, dornase alfa, exercise), CFTR modulator therapy (elexacaftor/tezacaftor/ivacaftor for F508del — \"Trikafta\" — major outcome improvement), antibiotic (acute exacerbations + chronic suppressive for Pseudomonas), inhaled antibiotics (tobramycin, aztreonam); (2) Pancreatic insufficiency: pancreatic enzyme replacement therapy (PERT — Creon) with meals, fat-soluble vitamin supplements (ADEK), high-calorie diet (120-150% RDA), salt supplementation; (3) Sweat chloride loss prevention: extra salt, hydration; (4) Endocrine: monitor for CF-related diabetes (annual OGTT from age 10), osteoporosis (DEXA); (5) GI: monitor for distal intestinal obstruction syndrome, biliary cirrhosis, GERD; (6) Reproductive: counseling (males infertile due CBAVD, females reduced fertility); (7) Vaccinations: all routine + annual influenza + pneumococcal + COVID; (8) Multidisciplinary CF center care: pediatric pulmonology, gastroenterology, nutritionist, social work, psychology, respiratory therapy; (9) Family genetic counseling (autosomal recessive); (10) Newborn screening confirmation in younger siblings; (11) Long-term: lung transplant evaluation when FEV1 < 30% predicted; survival ~ 50 years modern with Trikafta"},{"label":"C","text":"Steroid alone"},{"label":"D","text":"Probiotic only"},{"label":"E","text":"Discharge with cough syrup"}]'::jsonb,
  'B', 'Cystic Fibrosis: autosomal recessive, CFTR gene (most common F508del), affects exocrine glands. Multisystem: respiratory (chronic infection, bronchiectasis), pancreatic insufficiency (steatorrhea, FTT), CF-related diabetes, sweat chloride loss, infertility (CBAVD males), biliary, sinopulmonary, intestinal obstruction. Diagnosis: newborn screening (immunoreactive trypsinogen), sweat chloride > 60, CFTR genetic testing. Multidisciplinary CF center care. Trikafta (elexacaftor/tezacaftor/ivacaftor) revolutionized care for F508del. Survival ~ 50 yr modern. Lung transplant for end-stage.', NULL,
  'hard', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'Cystic Fibrosis Foundation Guidelines; Middleton PG et al. NEJM 2019 (Trikafta)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 5 ปี น้ำหนัก 18 kg มาด้วยอาการ chronic ไอเรื้อรัง + เหนื่อย + น้ำหนักไม่เพิ่ม 6 เดือน + ถ่ายอุจจาระมีน้ำมันมัน + อาเจียน

Vaccine complete
Family: ลูกพี่ลูกน้องสมาชิกครอบครัวมี cystic fibrosis

V/S: HR 102, RR 22, SpO2 96%, ไม่มีไข้
Gen: pale, thin, mild clubbing
Lungs: occasional crackles bilateral, mild expiratory wheeze
Abdomen: distended, mild tenderness, no hepatosplenomegaly
Pilonidal area: bulky stool noted on undergarment

Sweat chloride test: 78 mEq/L (high — > 60 = positive)
CFTR genetic testing: F508del homozygous
Fecal elastase: < 100 (pancreatic insufficiency)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'อาจารย์อธิบาย pediatric pharmacology — drug dosing differs from adults

คำถาม: หลักการ pediatric drug dosing + key developmental pharmacokinetic differences', '[{"label":"A","text":"Same dose as adult per body weight"},{"label":"B","text":"Pediatric dosing requires consideration of developmental pharmacokinetics: (1) Absorption — gastric pH higher in neonates (favors penicillin, disfavors weak acids); slower gastric emptying; (2) Distribution — higher % water (neonates 75% water vs adult 60% — increased Vd of water-soluble drugs like aminoglycosides); lower albumin (higher free fraction of bound drugs — bilirubin displacement risk in neonates with ceftriaxone, sulfa); BBB permeable in neonate; (3) Metabolism — CYP450 immature at birth → mature by age 1 (varies); UGT (glucuronidation) immature → ''gray baby syndrome'' with chloramphenicol; (4) Excretion — GFR low at birth, matures by 1 yr → renal drug dose adjustment; (5) Dosing methods: weight-based (mg/kg) for most; body surface area (m²) for chemotherapy; age-band approximations; (6) Special considerations: ceftriaxone CI in neonates < 4 wk (bilirubin displacement + Ca precipitation); chloramphenicol gray baby syndrome; tetracycline tooth/bone deposition < 8 yr; fluoroquinolone cartilage concern; aspirin Reye syndrome with viral illness; codeine/tramadol CI < 12 yr; benzyl alcohol toxicity in preservatives; (7) Always verify dose + use pediatric-specific resources"},{"label":"C","text":"Halve adult dose for all children"},{"label":"D","text":"Pediatric-specific dosing not necessary"},{"label":"E","text":"Use weight only"}]'::jsonb,
  'B', 'Pediatric pharmacology = different from adult due to developmental changes in ADME. Weight-based dosing standard. Special CI: ceftriaxone < 4 wk (bilirubin, Ca), chloramphenicol (gray baby), tetracycline < 8 yr (tooth, bone), fluoroquinolone (cartilage), aspirin + viral illness (Reye), codeine < 12 yr (variable metabolism, respiratory depression). Verify dose meticulously.', NULL,
  'medium', 'procedures', 'review',
  'pediatrics', 'basic_science', 'procedures', 'peds',
  'AAP Pediatric Clinical Pharmacology; Lexicomp Pediatric Drug Information', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'อาจารย์อธิบาย pediatric pharmacology — drug dosing differs from adults

คำถาม: หลักการ pediatric drug dosing + key developmental pharmacokinetic differences'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถาม physiology — neonatal transitional circulation', '[{"label":"A","text":"Same as adult"},{"label":"B","text":"Neonatal Transitional Circulation: fetal — high pulmonary vascular resistance (PVR), low systemic vascular resistance (SVR), R→L shunting through ductus arteriosus + foramen ovale + ductus venosus; oxygenation from placenta. AT BIRTH: (1) First breath expands lungs → ↓PVR + ↑oxygenation → pulmonary blood flow increases; (2) Cord clamping → loss of placental low-resistance circuit → ↑SVR; (3) Increased pulmonary venous return → ↑LA pressure → functional closure of foramen ovale (anatomic 3 mo-1 yr); (4) Higher PaO2 + ↓ prostaglandins → functional closure of ductus arteriosus (anatomic by 2-3 weeks); (5) Ductus venosus closes when umbilical flow stops; (6) Persistent fetal circulation (PPHN — persistent pulmonary HT of newborn) if PVR fails to drop — causes: meconium aspiration, sepsis, RDS, congenital diaphragmatic hernia — Rx: 100% O2, sedation, mechanical vent, iNO (selective pulmonary vasodilator), milrinone, ECMO; ductal-dependent CHD (HLHS, critical AS/PS, TGA, Tricuspid atresia) — PGE1 maintains PDA until surgery"},{"label":"C","text":"No transition occurs"},{"label":"D","text":"PDA never closes"},{"label":"E","text":"Foramen ovale always patent"}]'::jsonb,
  'B', 'Neonatal transition: fetal R→L shunts + high PVR → newborn L→R adult circulation. Trigger: first breath + cord clamping. PVR drops, SVR rises, shunts close. PPHN if PVR fails to drop (iNO, ECMO). Ductal-dependent CHD: PGE1 maintains PDA (HLHS, critical AS/PS, TGA, Tricuspid atresia). PPS (peripheral pulmonary stenosis) common in newborns from incomplete transition — benign murmur usually.', NULL,
  'medium', 'cardiovascular', 'review',
  'pediatrics', 'basic_science', 'cardiovascular', 'peds',
  'Nelson Textbook of Pediatrics 22nd ed Ch. 461; Avery''s Diseases of the Newborn 11th ed', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'Resident ถาม physiology — neonatal transitional circulation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'อาจารย์อธิบาย immunology — infant immune system + vaccine response', '[{"label":"A","text":"Same as adult"},{"label":"B","text":"Infant immune system maturation: (1) Innate: present at birth but qualitatively + quantitatively immature; (2) Adaptive: passive (maternal IgG transplacentally — protects 6 mo, wanes), active maturing; (3) Maternal IgG falls 6-9 mo while infant own immune building → ''physiologic hypogammaglobulinemia'' (6-9 mo nadir) → susceptibility window; (4) IgA in breast milk — mucosal protection; (5) IgM appears first to new antigen; IgG class switching; (6) T-cell response immature — Th2-biased — atopy susceptibility; (7) Vaccine response: live attenuated (MMR, varicella, rotavirus, BCG) need cellular immunity — given after 6 mo; inactivated/subunit/conjugate (DTaP, Hib, PCV13, Hepatitis B, polio IPV) — given starting birth/2 mo; conjugate vaccines (PCV, Hib, MenACWY) — conjugate protein to polysaccharide for T-cell-dependent response in infants; (8) Polysaccharide unconjugated vaccines (pneumovax 23) poorly immunogenic < 2 yr — give after 2 yr; (9) Live vaccines CI in pregnant, severe immunodeficiency, recent IVIG (delay 11 mo for MMR/varicella)"},{"label":"C","text":"Adults respond same as infants"},{"label":"D","text":"No need for vaccination"},{"label":"E","text":"Single dose universal"}]'::jsonb,
  'B', 'Infant immune system immature + Th2-biased. Maternal IgG protects ~ 6 mo then wanes. Live vaccines after 6-12 mo (cellular immunity needed). Conjugate vaccines key — convert T-independent polysaccharide to T-dependent (PCV, Hib, MenACWY) — effective in infants. Unconjugated polysaccharide (PPSV23) ineffective < 2 yr. Maternal vaccination (Tdap pregnancy, RSV, COVID, influenza) → passive transfer protects infant. Live vaccines CI in pregnancy + immunocompromised.', NULL,
  'easy', 'id', 'review',
  'pediatrics', 'basic_science', 'id', 'peds',
  'CDC Recommended Immunization Schedule; AAP Red Book 2024', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'อาจารย์อธิบาย immunology — infant immune system + vaccine response'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'อาจารย์อธิบาย physiology — pediatric fluid + electrolyte calculation', '[{"label":"A","text":"Same as adult"},{"label":"B","text":"Pediatric Fluid Management: (1) Maintenance fluid ''4-2-1 rule'' (Holliday-Segar): 4 mL/kg/hr first 10 kg + 2 mL/kg/hr next 10 kg + 1 mL/kg/hr each additional kg (e.g., 25 kg child = 40 + 20 + 5 = 65 mL/hr); (2) Maintenance fluid composition: isotonic — D5 NS preferred over D5 0.45 NS (Cochrane evidence — hypotonic causes iatrogenic hyponatremia, especially in ill children) — AAP 2018 endorse isotonic; (3) Resuscitation: NSS or LR 20 mL/kg bolus over 15-30 min for shock, may repeat × 2-3 then assess + consider blood/colloid; (4) Dehydration assessment: mild (3-5%), moderate (6-9% — sunken eyes, dry MM, decreased turgor, prolonged capillary refill, tachycardia), severe (≥ 10% — lethargic, sunken fontanelle, very poor perfusion, hypotension late sign in peds); (5) Replacement: 50% deficit + maintenance over first 8h, remaining 50% over next 16h; oral rehydration solution (ORS) preferred for mild-moderate (cheaper, safer, effective); (6) Electrolyte considerations: K based on serum + UO; correct Na slowly (max 10-12 mEq/L/d to avoid central pontine myelinolysis); (7) Special situations: DKA (cautious slow fluid as discussed), burns (Parkland formula for kids), neonatal (different calculations)"},{"label":"C","text":"8-4-2 rule"},{"label":"D","text":"Always restrict fluid"},{"label":"E","text":"Adult formula"}]'::jsonb,
  'B', 'Pediatric fluid management essential skill. 4-2-1 rule (Holliday-Segar 1957) for maintenance. AAP 2018 + NEJM 2018 (Friedman): isotonic preferred over hypotonic (less iatrogenic hyponatremia, esp ill children). 20 mL/kg bolus for shock (can repeat). Replace deficit over 24h (DKA 48h slower). ORS for mild-moderate dehydration. Cautions: rapid Na correction (CPM), DKA cerebral edema, neonatal special, burns Parkland. Frequent re-assessment + adjustment.', NULL,
  'medium', 'renal_gu', 'review',
  'pediatrics', 'basic_science', 'renal_gu', 'peds',
  'AAP Clinical Practice Guideline: Maintenance IV Fluids in Children 2018 (Feld LG et al.); Holliday MA, Segar WE. Pediatrics 1957', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'อาจารย์อธิบาย physiology — pediatric fluid + electrolyte calculation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital wants to reduce neonatal mortality + improve newborn screening + immunization rates

คำถาม: child health policy + quality metrics', '[{"label":"A","text":"Single intervention solves all"},{"label":"B","text":"Comprehensive Child Health Program — multi-level intervention: (1) Antenatal: maternal nutrition + iron + folate, vaccination (Tdap, flu, COVID, RSV maternal), screening (gestational diabetes, group B Strep), education; (2) Intrapartum: skilled birth attendant, group B Strep prophylaxis if indicated, immediate skin-to-skin contact, delayed cord clamping (1-3 min — improves iron stores), early breastfeeding initiation; (3) Newborn: routine care (vitamin K, eye prophylaxis, hepatitis B vaccine), newborn screening (heel prick — congenital hypothyroidism, PKU, sickle cell, CF, etc.), pulse oximetry screening (critical CHD), hearing screening; (4) Well-child visits at scheduled intervals: growth + development monitoring, anticipatory guidance, vaccinations per CDC/local schedule, screening (lead, anemia, vision, hearing, autism, depression in adolescents); (5) Vaccination: universal + catch-up programs, education, address vaccine hesitancy, school requirements; (6) Nutrition: breastfeeding promotion (6 mo exclusive), complementary feeding 6 mo, micronutrient programs (iron, vitamin D, vitamin A), school meal programs; (7) Safety: car seats, helmets, water safety, firearm storage, lead paint; (8) Mental health: screening, school-based programs, family support; (9) Equity: address social determinants (food security, housing, education access); (10) Quality metrics: infant mortality, vaccination coverage, well-child visit completion, screening uptake, hospitalization rates"},{"label":"C","text":"Adult medicine principles only"},{"label":"D","text":"Ignore prevention"},{"label":"E","text":"Single specialty manages"}]'::jsonb,
  'B', 'Comprehensive child health — life-course approach + multi-level intervention. WHO + AAP + CDC frameworks. Key components: antenatal, intrapartum, newborn screening + immunization, well-child visits, anticipatory guidance, safety, mental health, equity. Quality metrics: infant mortality (key indicator), vaccination coverage, screening uptake. Social determinants of health critical. Multidisciplinary + multi-level. Thailand: maternal + child health policy improved outcomes significantly past decades.', NULL,
  'easy', 'signs_symptoms', 'review',
  'pediatrics', 'ems_mgmt', 'signs_symptoms', 'peds',
  'WHO Reproductive Maternal Newborn Child + Adolescent Health Strategy; AAP Bright Futures Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'Hospital wants to reduce neonatal mortality + improve newborn screening + immunization rates

คำถาม: child health policy + quality metrics'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'PICU implements quality improvement to reduce CLABSI in children — different from adult considerations', '[{"label":"A","text":"Same as adult bundle"},{"label":"B","text":"Pediatric CLABSI Prevention Bundle: similar adult core (hand hygiene, max barrier, chlorhexidine ≥ 0.5% in alcohol > 2 mo old, site selection — IJ or subclavian preferred over femoral in non-emergent, daily review) + pediatric-specific: (1) Use of central lines minimized — peripheral IV when possible, midline if longer duration; (2) Catheter selection by size + child size (different small catheters); (3) Site selection: in infants/children — IJ often easier than subclavian; femoral acceptable in PICU/post-op cardiac (less infection difference than adults); (4) Insertion checklist + observer; (5) Chlorhexidine bathing daily in PICU (less convincing evidence than adults); (6) Dressing change protocols (transparent q7d or per soil); (7) Hub disinfection (\"scrub the hub\"); (8) Daily review of necessity — early removal; (9) Antimicrobial-impregnated catheters in selected; (10) Education + ongoing competency assessment; (11) PICU-specific: TPN line designation, sepsis surveillance; (12) Family education + engagement; (13) Tracking + feedback: CLABSI rate per 1000 catheter-days; (14) Multidisciplinary: physicians, nurses, infection prevention, family"},{"label":"C","text":"Avoid all central lines"},{"label":"D","text":"Use all femoral lines"},{"label":"E","text":"No prevention needed in children"}]'::jsonb,
  'B', 'Pediatric CLABSI prevention — similar core to adult bundle (Pronovost Keystone applies) + pediatric considerations: smaller catheters, site preference varies, chlorhexidine after 2 mo old, family engagement. Pediatric ICU CLABSI lower with bundle implementation (Miller MR Pediatrics 2010 — 40% reduction). Modern: family-centered care, technology, electronic surveillance. Continuous improvement + audit + feedback critical.', NULL,
  'medium', 'id', 'review',
  'pediatrics', 'ems_mgmt', 'id', 'peds',
  'Miller MR et al. Pediatrics 2010 (PICU CLABSI Bundle); CDC HICPAC + PIDS Guidelines for Pediatric', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'PICU implements quality improvement to reduce CLABSI in children — different from adult considerations'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Pediatric department implements ''Family-Centered Care'' (FCC) — partner with families to improve outcomes', '[{"label":"A","text":"Exclude families from care decisions"},{"label":"B","text":"Family-Centered Care (FCC) in pediatric/PICU — partnership with families improves outcomes: (1) Core principles (Institute for Patient + Family-Centered Care): respect + dignity, information sharing, participation, collaboration; (2) Open visitation 24/7 + family at bedside; (3) Family rounds — daily bedside multidisciplinary rounds including family + child (age-appropriate); (4) Shared decision-making — values, goals, options discussed; (5) Family presence during procedures + resuscitation (AHA + AAP endorse); (6) Parental + caregiver role: comfort, education, advocacy, observation; (7) Sibling support + visitation; (8) Cultural + linguistic competence — interpreters, cultural understanding; (9) Discharge planning involves family early; (10) Family advisory councils — family input on hospital policies + design; (11) Education programs + support groups; (12) Bereavement care for family if child dies; (13) Outcome measures: family satisfaction, length of stay, readmission, error rates (reduced when family engaged), staff satisfaction; (14) Evidence: family presence at resuscitation reduces PTSD in family + does not impair care (Compassionate Connected Care, Doyle Crit Care Med); FCC reduces LOS, complications, costs (Cooper RL Crit Care Med)"},{"label":"C","text":"Visit only 2 hours/day"},{"label":"D","text":"Decisions by physicians alone"},{"label":"E","text":"No family communication"}]'::jsonb,
  'B', 'FCC = evidence-based partnership with families. Core: respect, information, participation, collaboration. Reduces LOS, complications, PTSD, increases satisfaction. Family-centered rounds, presence during resuscitation, shared decision-making, cultural competence. IPFCC framework. AAP, AHA endorse. Modern pediatric care unimaginable without family partnership.', NULL,
  'easy', 'psych_behavior', 'review',
  'pediatrics', 'ems_mgmt', 'psych_behavior', 'peds',
  'Institute for Patient + Family-Centered Care; Committee on Hospital Care + IPFCC. Patient + Family-Centered Care + the Pediatrician''s Role 2012', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'Pediatric department implements ''Family-Centered Care'' (FCC) — partner with families to improve outcomes'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 4 ปี diagnosed ALL (acute lymphoblastic leukemia) — induction phase chemotherapy, multidisciplinary care

คำถาม: pediatric cancer integrative management', '[{"label":"A","text":"Chemotherapy only by oncologist"},{"label":"B","text":"Pediatric Cancer Integrative Multidisciplinary Care: (1) Oncology team: pediatric hematology-oncology, treatment protocol per COG/UKALL/equivalent; (2) Treatment: induction → consolidation → maintenance for ALL; risk-stratified (cytogenetics, MRD); intrathecal therapy + cranial RT (selected) for CNS prophylaxis; (3) Supportive: tumor lysis syndrome prevention (hydration, allopurinol, rasburicase for high risk), febrile neutropenia management (empirical broad antibiotic within 1h), antifungal prophylaxis selected, antiviral if needed, transfusion support, growth factors (G-CSF); (4) Multidisciplinary team: oncology, infectious disease, nutritionist, PT/OT, psychology, child life, social work, chaplain, school liaison, primary pediatrician coordination; (5) Family support: shared decision-making, anticipatory guidance, sibling support, financial counseling (treatment expensive), respite care; (6) Child life specialist: developmentally appropriate education, coping, distraction, procedural support; (7) School re-integration: maintain education, home/hospital schooling, school nurse coordination, transition back; (8) Long-term survivorship: 90% 5-year survival ALL — surveillance for late effects (secondary malignancy, cardiotoxicity, growth, fertility, cognitive, psychosocial); transition to adult survivor clinic; (9) Palliative care concurrent — improves QOL even in curative intent; (10) End-of-life care if treatment fails — pediatric palliative + hospice integration"},{"label":"C","text":"Refuse all support"},{"label":"D","text":"Single specialist"},{"label":"E","text":"Ignore long-term effects"}]'::jsonb,
  'B', 'Pediatric cancer = integrative + multidisciplinary + family-centered. ALL 90% 5-year survival modern. Treatment phases. Risk-stratified (MRD, cytogenetics). Supportive care critical (febrile neutropenia, tumor lysis, transfusions). Multidisciplinary team. Family support essential. Long-term survivorship: late effects screening, transition to adult care. Palliative care concurrent (improves QOL + may extend life). Modern pediatric oncology highly integrated.', NULL,
  'hard', 'hemato_onco', 'review',
  'pediatrics', 'integrative', 'hemato_onco', 'peds',
  'Children''s Oncology Group Protocols; AAP + ASCO Pediatric Cancer Survivorship; ChIPS — Children''s International Project on Palliative + Hospice Services', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 4 ปี diagnosed ALL (acute lymphoblastic leukemia) — induction phase chemotherapy, multidisciplinary care

คำถาม: pediatric cancer integrative management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Adolescent 16-year-old + chronic medical condition — transition to adult care

คำถาม: adolescent transition + multimorbidity', '[{"label":"A","text":"Abrupt transfer at 18"},{"label":"B","text":"Adolescent Transition to Adult Care (integrative + planned process): (1) Begin transition planning in early adolescence (age 12-14) — not abrupt at 18; (2) Joint pediatric + adult provider coordination — written transition plan, shared records; (3) Self-management skills development: medication knowledge + administration, appointment scheduling, insurance navigation, recognizing warning signs, communication with providers; (4) Address adolescent-specific issues: sexuality + reproductive health, mental health (depression, anxiety, substance use higher in chronic illness), school/career planning, peer relationships, identity + autonomy; (5) Family role evolution — from primary decision-maker to support; (6) Confidentiality + assent/consent transition; (7) Specific concerns by condition (DM, CF, cancer survivor, congenital heart, sickle cell, IBD, transplant); (8) Insurance + legal: medical decision-making, conservatorship if cognitive impairment, transition of insurance; (9) Multidisciplinary support: adolescent medicine, social work, mental health, primary care; (10) Outcome metrics: continuity of care, no gap, adherence, satisfaction; (11) Got Transition + Six Core Elements framework (national approach); (12) Special populations: developmental disabilities, autism (specialized adult providers limited), cognitive impairment, complex care"},{"label":"C","text":"Pediatric care for life"},{"label":"D","text":"Ignore transition needs"},{"label":"E","text":"Discharge from all care"}]'::jsonb,
  'B', 'Adolescent transition to adult care = critical integrative process. Begin early, planned, not abrupt. Six Core Elements (Got Transition): transition policy, tracking, readiness, planning, transfer, completion. Self-management skill building. Adolescent-specific issues. Family + autonomy balance. Multidisciplinary. Specific to condition (CF, DM, sickle cell, transplant, complex care). Outcomes: continuity, adherence. Gap in transition = poor outcomes. Modern: ''Got Transition'' national framework + AAP/AAFP/ACP joint clinical report.', NULL,
  'medium', 'psych_behavior', 'review',
  'pediatrics', 'integrative', 'psych_behavior', 'peds',
  'AAP/AAFP/ACP Clinical Report: Transitions Clinical Report 2018; Got Transition / National Alliance to Advance Adolescent Health', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'Adolescent 16-year-old + chronic medical condition — transition to adult care

คำถาม: adolescent transition + multimorbidity'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Premature infant ex-32 weeks now 6 months chronological age — chronic lung disease + developmental concerns + family stress

คำถาม: post-NICU follow-up + integrative care', '[{"label":"A","text":"Discharge from all follow-up"},{"label":"B","text":"Premature Infant Follow-up (NICU Graduate) — Integrative Multidisciplinary: (1) High-risk infant follow-up clinic (HRIF): developmental assessment, growth, neurological at scheduled intervals up to 2-3 years (corrected age); (2) Subspecialty care: pulmonology (BPD/CLD — chronic lung disease, RSV prophylaxis with palivizumab, weaning O2 home), ophthalmology (ROP — retinopathy of prematurity, follow-up), cardiology (PDA, congenital concerns), neurology (IVH, PVL, hydrocephalus), GI (NEC, feeding difficulties); (3) Developmental: PT, OT, speech therapy, early intervention services (IDEA Part C), assessments (Bayley, AIMS); (4) Nutrition: high-calorie formulas, fortification, weight gain monitoring, feeding therapy; (5) Vaccination: catch-up schedule + RSV prophylaxis (palivizumab) for high-risk; (6) Hearing + vision screening + monitoring; (7) Family support: parental mental health (high postpartum depression + PTSD risk), sibling support, financial counseling (NICU costs, ongoing care), respite care; (8) Coordinate care: medical home with primary pediatrician + specialty consults; (9) Long-term: school readiness assessment, IEP if developmental delays, transition planning; (10) Outcomes: many achieve typical development; some have lasting disabilities — early intervention improves outcomes; family-centered support throughout; corrected age use until 2 yr for milestones"},{"label":"C","text":"Single specialty manages all"},{"label":"D","text":"Refuse early intervention"},{"label":"E","text":"Use chronological age only"}]'::jsonb,
  'B', 'NICU graduate follow-up = quintessentially integrative. High-Risk Infant Follow-up clinic standard model. Subspecialty care (pulm, ophtho, cardio, neuro, GI, dev). Early intervention essential — improves outcomes. Family-centered + corrected age use until 2 yr. Long-term outcomes variable — modern care + interventions improve trajectory. Family support critical (parental MH, finances, social). AAP + March of Dimes guidelines. Outcomes registry data informs care.', NULL,
  'medium', 'respiratory', 'review',
  'pediatrics', 'integrative', 'respiratory', 'peds',
  'AAP Section on Perinatal Pediatrics; Follow-up Care of High-Risk Infants 2008 + updates', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'Premature infant ex-32 weeks now 6 months chronological age — chronic lung disease + developmental concerns + family stress

คำถาม: post-NICU follow-up + integrative care'
  );

commit;

-- verify
select board_section, count(*) from public.mcq_questions
where board_specialty = 'pediatrics' and exam_source = 'AI-generated-board-seed'
group by 1 order by 1;
